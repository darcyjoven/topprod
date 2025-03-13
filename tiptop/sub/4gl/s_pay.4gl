# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: s_pay.4gl
# Descriptions...:交款明細作業
# Date & Author..:NO.FUN-960130 08/08/22 By Sunyanchun
# Input Parameter: p_type  單據別 01:订单，02:出货单，03:销退单，  
#                                 04:订金退回单artt700，05:押金收取单artt624，06:押金退回单artt625 
#                                 07:费用单artt610，08:费用退款单artt615，11:交款单artt611，
#                                 09:赠品发放单artt603，10:赠品退还单artt604，12:代收款单artt701,13:代退款单artt702,
#                                 20:发卡almt610，21:储值卡充值almt620，22:储值卡退余额almt630，
#                                 23:换卡almt616
#                  p_no    單號
#                  p_org   機構別
#                  p_sum   總金額
#                  p_flag  審核碼
# Return code....:
# Modify.........: 09/02/11 By Zhangyajun 功能調整&BUG修改
# Modify.........: FUN-9A0102 09/10/30 By Cockroach 過單
# Modify.........: FUN-9B0016 09/11/03 By sunyanchun post no
# Modify.........: No.TQC-9B0025 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0157 09/12/07 By bnlent 卡券管控修改
# Modify.........: No.FUN-9C0074 09/12/15 By bnlent 判断符号写反了 
# Modify.........: No.FUN-A10016 10/01/06 By bnlent 券付款时标志参数g_success应赋初值Y
# Modify.........: No.TQC-A10122 10/01/14 By Cockroach 手續費與手續費率字段判斷調整
# Modify.........: No.FUN-A10106 10/01/26 By destiny 单别为赠品发放时收款应为1
# Modify.........: No:FUN-A70118 10/07/29 By shiwuying 儲值卡金額移動時INSERT一筆到lsn_file中
# Modify.........: No:TQC-AC0124 10/12/17 By huangtao 押金不可以券付
# Modify.........: No:TQC-AC0310 10/12/22 By shiwuying window初始化
# Modify.........: No:TQC-AC0127 10/12/27 By wuxj     修改window初始化
# Modify.........: No:TQC-B10042 11/01/07 By shenyang 
# Modify.........: No:TQC-B80023 11/08/02 By lilingyu ROLLBACK WORK位置錯誤,導致call cl_err3報錯訊息不准確
# Modify.........: No:FUN-BB0117 11/11/27 By baogc 招商歐亞達回收 - 相關邏輯修改
# Modify.........: No:FUN-BA0069 11/12/13 By yangxf 修改過帳/過帳還原時更新會員銷售及積分,加入積分款別
# Modify.........: No.FUN-BB0024 11/12/13 By yangxf 銷退加上積分抵現的邏輯
# Modify.........: No.FUN-BA0068 12/01/11 By pauline mark lsn08 增加lsnlegal,lsnplant
# Modify.........: No.FUN-BC0071 12/01/19 By huangtao 畫面加入實收折讓
# Modify.........: No.FUN-C20098 12/02/21 By huangtao 修改FUN-BC0071的bug
# Modify.........: No.TQC-C20379 12/02/22 By huangtao 修正FUN-BC0071的bug
# Modify.........: No.TQC-C30085 12/03/07 By pauline 券生效/失效當天應可使用券付款 
# Modify.........: No.TQC-C30174 12/03/09 By baogc 添加信用卡交款金額為負時的退款邏輯
# Modify.........: No.TQC-C30179 12/03/10 By baogc 手工轉帳添加"手工轉帳取消"ACTION
# Modify.........: No.FUN-C30165 12/03/27 By pauline 當來源為退款類型的將畫面上"收款" 修改成 "付款" 
# Modify.........: No.FUN-C30038 12/03/27 By JinJJ rxy11增加开窗q_nmt，AFTER FIELD 一并修改，存在anmi080且有效
# Modify.........: No.FUN-C40018 12/04/18 By pauline 寫入lsn_file時,金額的正負值調整 
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C70127 12/07/31 By nanbing s_pay_detail函數去除空白行,s_pay函數當g_prog='artt700',隱藏sum3
# Modify.........: No.CHI-C80052 12/08/29 By pauline 銷售/銷退單積分抵現時,積分不應四捨五入
# Modify.........: No:FUN-C90085 12/09/18 By xumm 添加"取消付款"按钮
# Modify.........: No:FUN-C90102 12/10/31 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant由lsnstore取代
# Modify.........: No:FUN-CB0025 12/11/08 By shiwuying 款别冲预收逻辑修改,如果是订金的冲预收,分摊到其他款别上,rxy33=Y
# Modify.........: No:FUN-CC0057 12/12/18 By xumm 将类型20改为23
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_type     LIKE  smy_file.smyslip,
       g_no       LIKE  rti_file.rti01,       #No.FUN-9B0016
       g_org      LIKE  tqb_file.tqb01,
       g_sum      LIKE  rxx_file.rxx04,
       g_flag     LIKE  rti_file.rticonf
DEFINE g_rxx04_01    LIKE rxx_file.rxx04         #現金交款金額                                                   
DEFINE g_rxx04_02    LIKE rxx_file.rxx04         #銀聯卡交款金額                                                  
DEFINE g_rxx04_03    LIKE rxx_file.rxx04         #支票交款金額                                                        
DEFINE g_rxx04_04    LIKE rxx_file.rxx04         #卷交款金額                                                         
DEFINE g_rxx05_03    LIKE rxx_file.rxx04         #支票交款金額                                                        
DEFINE g_rxx05_04    LIKE rxx_file.rxx04         #卷交款金額                                                         
DEFINE g_rxx04_05    LIKE rxx_file.rxx04         #聯盟卡交款金額                                                       
DEFINE g_rxx04_06    LIKE rxx_file.rxx04         #儲值卡交款金額                                                     
DEFINE g_rxx04_07    LIKE rxx_file.rxx04         #衝預收                                                              
DEFINE g_rxx04_08    LIKE rxx_file.rxx04         #手工轉帳                                                          
DEFINE g_rxx04_09    LIKE rxx_file.rxx04         #積分抵現              #FUN-BA0069 add
DEFINE g_rxx04_10    LIKE rxx_file.rxx04         #收款折讓              #FUN-BC0071 add
DEFINE g_rxx04_point LIKE rxx_file.rxx04         #抵現積分              #FUN-BA0069 add
DEFINE g_lpj12_before LIKE lpj_file.lpj12                               #FUN-BA0069 add
DEFINE g_lpj12_amount LIKE lpj_file.lpj12                               #FUN-BA0069 add
DEFINE g_rxy05       LIKE rxy_file.rxy05                                #FUN-BA0069 add
DEFINE g_lpj12_after LIKE lpj_file.lpj12                                #FUN-BA0069 add
DEFINE g_oga87       LIKE oga_file.oga87         #會員卡號 銷售         #FUN-BA0069 add
#FUN-BB0024 --------------STA
DEFINE g_oha87       LIKE oha_file.oha87         #會員卡號 銷退
DEFINE g_lpj12       LIKE lpj_file.lpj12         #剩余積分
DEFINE g_lpj02       LIKE lpj_file.lpj02         #卡種
DEFINE g_rxy05_point LIKE rxy_file.rxy05         #退回積分
#FUN-BB0024 --------------END
DEFINE g_sum2        LIKE rxx_file.rxx04         #交款合計金額                                                          
DEFINE g_sum3        LIKE rxx_file.rxx04         #未交款合計金額                                                     
DEFINE g_sum4        LIKE rxx_file.rxx04         #支票溢交款金額                                                    
DEFINE g_sum5        LIKE rxx_file.rxx04         #卷溢交款金額
DEFINE g_cnt         LIKE type_file.num10        #FUN-C90085 add
DEFINE g_rxy         RECORD
         rxy05            LIKE rxy_file.rxy05,         #銀聯卡：本次交款金額       
         rxy06            LIKE rxy_file.rxy06,         #銀聯卡：卡號    
         rxy07            LIKE rxy_file.rxy07,         #銀聯卡：手續費率
         rxy08            LIKE rxy_file.rxy08,         #銀聯卡：手續費
         rxy20            LIKE rxy_file.rxy20
                     END RECORD
DEFINE g_rxy5        RECORD                            #聯盟卡                                                            
         rxy05            LIKE rxy_file.rxy05,         #聯盟卡：本次交款金額                                                        
         rxy06            LIKE rxy_file.rxy06,         #聯盟卡：卡號                                                                
         rxy07            LIKE rxy_file.rxy07,         #聯盟卡：手續費率                                                            
         rxy08            LIKE rxy_file.rxy08,         #聯盟卡：手續費                                                              
         rxy20            LIKE rxy_file.rxy20,         #聯盟卡：固定手續費
         rxy12            LIKE rxy_file.rxy12          #聯盟卡：卡種類編號                                                         
                     END RECORD
DEFINE g_rec_b       LIKE type_file.num5
DEFINE l_ac          LIKE type_file.num5 
DEFINE g_rxz         DYNAMIC ARRAY OF RECORD     #銀聯卡刷卡單身
           rxz03        LIKE rxz_file.rxz03,
           rxz04        LIKE rxz_file.rxz04,
           rxz05        LIKE rxz_file.rxz05,
           rxz06        LIKE rxz_file.rxz06,
           rxz07        LIKE rxz_file.rxz07,
           rxz08        LIKE rxz_file.rxz08,
           rxz08_desc   LIKE gen_file.gen02,
           rxz09        LIKE rxz_file.rxz09,
           rxz10        LIKE rxz_file.rxz10,
           rxz11        LIKE rxz_file.rxz11,
           rxz11_desc   LIKE nmt_file.nmt02,
           rxz12        LIKE rxz_file.rxz12,
           rxz13        LIKE rxz_file.rxz13,
           rxz14        LIKE rxz_file.rxz14,
           rxz15        LIKE rxz_file.rxz15 
                    END RECORD
DEFINE g_rxz5        DYNAMIC ARRAY OF RECORD     #聯盟卡單身檔
           rxz03        LIKE rxz_file.rxz03,
           rxz04        LIKE rxz_file.rxz04,
           rxz05        LIKE rxz_file.rxz05,
           rxz06        LIKE rxz_file.rxz06,
           rxz07        LIKE rxz_file.rxz07,
           rxz08        LIKE rxz_file.rxz08,
           rxz08_desc   LIKE gen_file.gen02,
           rxz09        LIKE rxz_file.rxz09,
           rxz10        LIKE rxz_file.rxz10,
           rxz15        LIKE rxz_file.rxz15 
                    END RECORD
DEFINE g_rxy3       DYNAMIC ARRAY OF RECORD       #支票單身
         rxy02          LIKE rxy_file.rxy02,
         rxy06          LIKE rxy_file.rxy06,
         rxy09          LIKE rxy_file.rxy09,
         rxy10          LIKE rxy_file.rxy10,
         rxy11          LIKE rxy_file.rxy11,
         rxy05          LIKE rxy_file.rxy05,
         rxy17          LIKE rxy_file.rxy17
                    END RECORD
DEFINE g_rxy_t      RECORD
         rxy02          LIKE rxy_file.rxy02,                                                                    
         rxy06          LIKE rxy_file.rxy06,                                                                        
         rxy09          LIKE rxy_file.rxy09,                                                                        
         rxy10          LIKE rxy_file.rxy10,                                                                         
         rxy11          LIKE rxy_file.rxy11,                                                                          
         rxy05          LIKE rxy_file.rxy05,                                                                         
         rxy17          LIKE rxy_file.rxy17
                    END RECORD
DEFINE g_rxy4       DYNAMIC ARRAY OF RECORD       #券單身
         rxy02          LIKE rxy_file.rxy02,
         rxy12          LIKE rxy_file.rxy12,
         rxy12_desc     LIKE lpx_file.lpx02,
         lpx04          LIKE lpx_file.lpx04,
         rxy13          LIKE rxy_file.rxy13,
         rxy13_desc     LIKE rxy_file.rxy13,
         rxy14          LIKE rxy_file.rxy14,
         rxy15          LIKE rxy_file.rxy15,
         rxy16          LIKE rxy_file.rxy16,
         total          LIKE rxy_file.rxy15,
         rxy05          LIKE rxy_file.rxy05,
         rxy17          LIKE rxy_file.rxy17
                     END RECORD
DEFINE g_rxy4_t      RECORD
         rxy02          LIKE rxy_file.rxy02,
         rxy12          LIKE rxy_file.rxy12,                                                                                        
         rxy12_desc     LIKE lpx_file.lpx02,                                                                                        
         lpx04          LIKE lpx_file.lpx04,                                                                                        
         rxy13          LIKE rxy_file.rxy13,                                                                                        
         rxy13_desc     LIKE rxy_file.rxy13,                                                                                        
         rxy14          LIKE rxy_file.rxy14,                                                                                        
         rxy15          LIKE rxy_file.rxy15,                                                                                        
         rxy16          LIKE rxy_file.rxy16,                                                                                        
         total          LIKE rxy_file.rxy15,                                                                                        
         rxy05          LIKE rxy_file.rxy05,                                                                                        
         rxy17          LIKE rxy_file.rxy17                                                                                         
                     END RECORD
DEFINE g_rxy7       DYNAMIC ARRAY OF RECORD         #衝預收單身資料
         rxy02          LIKE rxy_file.rxy02,
         rxy19          LIKE rxy_file.rxy19,
         rxy06          LIKE rxy_file.rxy06,
         rxy03          LIKE rxy_file.rxy03,  #FUN-CB0025
        #FUN-BB0117 Add Begin ---
         rxy32          LIKE rxy_file.rxy32,
         lul05          LIKE lul_file.lul05,
         oaj02          LIKE oaj_file.oaj02,
        #FUN-BB0117 Add End -----
         sum1           LIKE rxx_file.rxx04,
         sum2           LIKE rxx_file.rxx04,
         sum3           LIKE rxx_file.rxx04,
         rxy05          LIKE rxy_file.rxy05
                     END RECORD
DEFINE g_rxy7_t      RECORD
         rxy02          LIKE rxy_file.rxy02,
         rxy19          LIKE rxy_file.rxy19,
         rxy06          LIKE rxy_file.rxy06,
         rxy03          LIKE rxy_file.rxy03,  #FUN-CB0025
        #FUN-BB0117 Add Begin ---
         rxy32          LIKE rxy_file.rxy32,
         lul05          LIKE lul_file.lul05,
         oaj02          LIKE oaj_file.oaj02,
        #FUN-BB0117 Add End -----
         sum1           LIKE rxx_file.rxx04,                                                                                        
         sum2           LIKE rxx_file.rxx04,                                                                                        
         sum3           LIKE rxx_file.rxx04,                                                                                        
         rxy05          LIKE rxy_file.rxy05
                     END RECORD
DEFINE g_time1           LIKE rxy_file.rxy22
DEFINE g_legal2          LIKE azw_file.azw02
 
FUNCTION s_pay(p_type,p_no,p_org,p_sum,p_flag)
DEFINE  p_type     LIKE  smy_file.smyslip,
        p_no       LIKE  rti_file.rti01,
        p_org      LIKE  tqb_file.tqb01,
        p_sum      LIKE  rxx_file.rxx04,
        p_flag     LIKE  rti_file.rticonf
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(p_type) OR cl_null(p_no) OR cl_null(p_org) 
      OR cl_null(p_flag) OR cl_null(p_sum) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   
   LET g_time1 = TIME  
   LET g_type = p_type
   LET g_no = p_no
   LET g_org =  p_org 
   LET g_sum = p_sum
   LET g_flag = p_flag
   SELECT azw02 INTO g_legal2 FROM azw_file WHERE azw01 = g_org
   OPEN WINDOW s_pay_w AT 10,20 WITH FORM "sub/42f/s_pay"
      ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("s_pay")
  #CALL cl_ui_init() #TQC-AC0310
   #FUN-C70127 sta-add
   IF g_prog = "artt700" THEN
      CALL cl_set_comp_visible("sum3",FALSE)
   END IF
   #FUN-C70127 end-add

  #FUN-C30165 add START
  #退款類型的將畫面上"收款" 修改成 "付款"
   IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08' 
     #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
      OR g_type = '22' THEN                  #FUN-CC0057
      CALL cl_getmsg('sub-247',g_lang) RETURNING l_string  #付款明細
      CALL cl_set_comp_lab_text("detail",l_string)
      CALL cl_getmsg('sub-248',g_lang) RETURNING l_string  #現金付款金額
      CALL cl_set_comp_att_text("rxx04_01",l_string)
      CALL cl_getmsg('sub-249',g_lang) RETURNING l_string  #信用卡付款金额
      CALL cl_set_comp_att_text("rxx04_02",l_string)
      CALL cl_getmsg('sub-250',g_lang) RETURNING l_string  #支票付款金額
      CALL cl_set_comp_att_text("rxx04_03",l_string)
      CALL cl_getmsg('sub-251',g_lang) RETURNING l_string  #券付款金額
      CALL cl_set_comp_att_text("rxx04_04",l_string)
      CALL cl_getmsg('sub-252',g_lang) RETURNING l_string  #聯盟卡付款金額
      CALL cl_set_comp_att_text("rxx04_05",l_string)
      CALL cl_getmsg('sub-253',g_lang) RETURNING l_string  #儲值卡付款金額
      CALL cl_set_comp_att_text("rxx04_06",l_string)
      CALL cl_getmsg('sub-254',g_lang) RETURNING l_string  #沖預付款金額
      CALL cl_set_comp_att_text("rxx04_07",l_string)
      CALL cl_getmsg('sub-272',g_lang) RETURNING l_string  #實付折讓金額
      CALL cl_set_comp_att_text("rxx04_10",l_string)
      CALL cl_getmsg('sub-255',g_lang) RETURNING l_string  #總付款金額
      CALL cl_set_comp_att_text("sum1",l_string)
      CALL cl_getmsg('sub-256',g_lang) RETURNING l_string  #付款金額合計
      CALL cl_set_comp_att_text("sum2",l_string)
      CALL cl_getmsg('sub-257',g_lang) RETURNING l_string  #未付款金額合計
      CALL cl_set_comp_att_text("sum3",l_string)
      CALL cl_getmsg('sub-258',g_lang) RETURNING l_string  #支票溢付款金額
      CALL cl_set_comp_att_text("sum3",l_string)
      CALL cl_getmsg('sub-259',g_lang) RETURNING l_string  #券溢退款金額
      CALL cl_set_comp_att_text("sum4",l_string)
   END IF   
  #FUN-C30165 add END
 
   LET g_action_choice = ""
   CALL pay_menu()
   CLOSE WINDOW s_pay_w
END FUNCTION 
 
FUNCTION pay_menu()
    MENU ""
       BEFORE MENU
          CALL pay_set_visble()
          CALL pay_show()
 
       ON ACTION exit
          EXIT MENU
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON ACTION money         #現金
          CALL pay_money()
   
       ON ACTION bank_card     #銀聯卡
          CALL pay_bank()
          
       ON ACTION cheque        #支票
          CALL pay_cheque()
   
       ON ACTION paper         #卷
          CALL pay_paper()
 
       ON ACTION union_card    #聯盟卡
          CALL pay_union()
 
       ON ACTION save_card     #儲值卡
          CALL pay_save()
 
       ON ACTION prepare_get   #衝預收
          CALL pay_get()
 
       ON ACTION transfer1     #手工轉帳
          CALL pay_tran()

#FUN-BA0069 add begin ---
       ON ACTION integral_t620      #積分抵現 銷售
          IF g_type = '02' THEN
             CALL pay_integral()
          END IF
#FUN-BB0024 ------------STA
          IF g_type = '03' THEN
             CALL pay_integral_t700()
          END IF
#FUN-BB0024 ------------END 
#FUN-C90085-----add----str
       ON ACTION undo_pay     #取消付款
          CALL s_showmsg_init()
          LET g_success = 'Y'
          IF cl_null(g_type) OR cl_null(g_no) 
             OR cl_null(g_org) OR cl_null(g_flag) THEN
             CALL s_errmsg('','','','-400',1)
             LET g_success = 'N'
          END IF
          IF g_flag <> 'N' THEN
             CALL s_errmsg('','','','sub-186',1)
             LET g_success = 'N'
          END IF
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt
            FROM rxx_file
           WHERE rxx00 = g_type
             AND rxx01 = g_no
             AND rxxplant = g_org
          IF g_cnt = 0 THEN
             CALL s_errmsg('','','','sub-537',1)
             LET g_success = 'N'
          END IF
          IF g_success = 'Y' THEN
             IF cl_confirm('sub-536') THEN
                BEGIN WORK
                CALL undo_pay(g_type,g_no,g_org,g_sum,g_flag)
                IF g_success = 'Y' THEN
                   COMMIT WORK
                ELSE
                   CALL s_showmsg()
                   ROLLBACK WORK
                   RETURN
                END IF
             END IF
          ELSE
             CALL s_showmsg()
          END IF
                 
#FUN-C90085-----add----end
          CALL pay_show()
#FUN-BA0069 add end   ---
 
   END MENU
END FUNCTION 
#根據單別動態隱藏畫面上的組件
FUNCTION pay_set_visble()
DEFINE  l_n   LIKE type_file.num5    #FUN-BC0071 add

   IF g_type = "01" OR g_type = "05" OR g_type = "07" THEN   
      CALL cl_set_act_visible("prepare_get",FALSE)
      CALL cl_set_comp_visible("rxx04_07",FALSE) 
#TQC-AC0124 ----------------STA
      IF g_type = "05" THEN
         CALL cl_set_act_visible("paper",FALSE)    
      END IF         
#TQC-AC0124 ----------------END
   END IF
#FUN-BC0071 ----------------STA
   IF g_type = "01" OR g_type = '02' OR g_type = '03' THEN   #TQC-C20379 add g_type = '03'
      SELECT COUNT(*) INTO l_n FROM rxc_file,rah_file 
       WHERE rxc00 = g_type AND rxc01 = g_no
         AND rxc03 = '03' AND rxc04 = rah02 
         AND rahplant = g_org AND rah10 = '4'
      IF l_n > 0 THEN
         CALL s_ins_rxx_rxy()
         CALL cl_set_comp_visible("rxx04_10",TRUE) 
      ELSE
         CALL cl_set_comp_visible("rxx04_10",FALSE) 
      END IF
   ELSE                                                          #FUN-C90085 add
      CALL cl_set_comp_visible("rxx04_10",FALSE)                 #FUN-C90085 add
   END IF
#FUN-BC0071 ----------------END 

                                                                                                                   
   IF g_type = "04" OR g_type = "03" OR g_type = "06" OR g_type = "08" THEN                                             
      CALL cl_set_act_visible("cheque",FALSE)               
      CALL cl_set_act_visible("paper",FALSE)               
      CALL cl_set_act_visible("prepare_get",FALSE)        
      CALL cl_set_act_visible("transfer1",FALSE)      
      CALL cl_set_comp_visible("rxx04_03",FALSE)
      CALL cl_set_comp_visible("rxx04_04",FALSE)
      CALL cl_set_comp_visible("rxx04_07",FALSE)   
      CALL cl_set_comp_visible("rxx04_08",FALSE)      
      CALL cl_set_comp_visible("sum4,sum5",FALSE)    
      CALL cl_set_comp_visible("over_detail",FALSE) #FUN-870007
   END IF
 
#FUN-BB0024 ------------mark -----------sta
#  IF g_type = '03' THEN
#     CALL cl_set_act_visible("save_card",FALSE)
#  END IF
#FUN-BB0024 ------------mark-------------end
  #IF g_type = '07' THEN #FUN-BB0117 Mark
   IF g_type = '07' OR g_type = '11' THEN #FUN-BB0117 Add
     #CALL cl_set_act_visible("paper,union_card,save_card,prepare_get",FALSE) #FUN-BB0117 Mark
      CALL cl_set_act_visible("paper,union_card,save_card",FALSE)             #FUN-BB0117 Add
      CALL cl_set_act_visible("prepare_get",TRUE)
      CALL cl_set_comp_visible("rxx04_07",TRUE)
     #CALL cl_set_comp_visible("rxx04_04,rxx04_05,rxx04_06",FALSE) #FUN-BB0117 Mark
      CALL cl_set_comp_visible("rxx04_04,rxx04_05,rxx04_06,sum5",FALSE) #FUN-BB0117 Add
   END IF
   IF g_type = '08' THEN
      CALL cl_set_act_visible("bank_card,paper,union_card,save_card,transfer1",FALSE)  
      CALL cl_set_comp_visible("rxx04_02,rxx04_05,rxx04_06",FALSE)
   END IF
#FUN-BA0069 add begin ---
   IF g_type = '02' OR g_type = '03' THEN       #FUN-BB0024 add
      CALL cl_set_act_visible("integral_t620",TRUE)
      CALL cl_set_comp_visible("rxx04_09,rxx04_point",TRUE)
   ELSE
      CALL cl_set_act_visible("integral_t620",FALSE)
      CALL cl_set_comp_visible("rxx04_09,rxx04_point",FALSE)
   END IF
#FUN-BA0069 add end ---
#FUN-C90085-----add----str
   #IF g_type = "20" THEN  #FUN-CC0057 mark
   IF g_type = "20" OR g_type = "23" THEN  #FUN-CC0057 add
      CALL cl_set_act_visible("paper",FALSE)
      CALL cl_set_act_visible("union_card",FALSE)
      CALL cl_set_act_visible("save_card",FALSE)
      CALL cl_set_act_visible("prepare_get",FALSE)
      CALL cl_set_act_visible("transfer1",FALSE)
      CALL cl_set_act_visible("integral_t620",FALSE)
      CALL cl_set_comp_visible("rxx04_04,rxx04_05,rxx04_06,rxx04_07,rxx04_08,sum5",FALSE)
      IF g_prog = "almt616"THEN
         CALL cl_set_act_visible("bank_card",FALSE)
         CALL cl_set_act_visible("cheque",FALSE)
         CALL cl_set_comp_visible("rxx04_02,rxx04_03,sum4",FALSE)
      END IF
   END IF

   IF g_type = "21" THEN
      CALL cl_set_act_visible("paper",FALSE)
      CALL cl_set_act_visible("union_card",FALSE)
      CALL cl_set_act_visible("save_card",FALSE)
      CALL cl_set_act_visible("prepare_get",FALSE)
      CALL cl_set_act_visible("transfer1",FALSE)
      CALL cl_set_act_visible("integral_t620",FALSE)
      CALL cl_set_comp_visible("rxx04_04,rxx04_05,rxx04_06,rxx04_07,rxx04_08,sum5",FALSE)
   END IF
   IF g_type = "22" THEN
      CALL cl_set_act_visible("paper",FALSE)
      CALL cl_set_act_visible("bank_card",FALSE)
      CALL cl_set_act_visible("cheque",FALSE)
      CALL cl_set_act_visible("union_card",FALSE)
      CALL cl_set_act_visible("save_card",FALSE)
      CALL cl_set_act_visible("prepare_get",FALSE)
      CALL cl_set_act_visible("integral_t620",FALSE)
      CALL cl_set_comp_visible("rxx04_02,rxx04_03,rxx04_04,rxx04_05,rxx04_06,rxx04_07,sum4,sum5",FALSE)
   END IF
#FUN-C90085-----add----end
END FUNCTION
FUNCTION pay_show()
  
   LET g_rxx04_01 = 0
   LET g_rxx04_02 = 0
   LET g_rxx04_03 = 0
   LET g_rxx04_04 = 0
   LET g_rxx04_05 = 0
   LET g_rxx04_06 = 0
   LET g_rxx04_07 = 0
   LET g_rxx04_08 = 0
   LET g_rxx04_09 = 0      #FUN-BA0069 add
   LET g_rxx04_10 = 0      #FUN-BC0071 add 
   LET g_sum2 = 0
   LET g_sum3 = 0
   LET g_sum4 = 0
   LET g_sum5 = 0
 
   #得到現金交款金額
   SELECT rxx04 INTO g_rxx04_01 FROM rxx_file 
      WHERE rxx02 = '01' AND rxx00 = g_type
        AND rxx01 = g_no AND rxxplant = g_org
   IF cl_null(g_rxx04_01) THEN LET g_rxx04_01 = 0  END IF
   DISPLAY g_rxx04_01 TO FORMONLY.rxx04_01
   #得到銀聯卡交款金額
   SELECT rxx04 INTO g_rxx04_02 FROM rxx_file
      WHERE rxx02 = '02' AND rxx00 = g_type
        AND rxx01 = g_no AND rxxplant = g_org
   IF cl_null(g_rxx04_02) THEN LET g_rxx04_02 = 0  END IF
   DISPLAY g_rxx04_02 TO FORMONLY.rxx04_02
   #得到支票交款金額
  #dongbg 扣除溢收款
   SELECT rxx04 INTO g_rxx04_03 FROM rxx_file                                                                                       
  #SELECT rxx04,rxx05 INTO g_rxx04_03,g_rxx05_03 FROM rxx_file                                                                                       
      WHERE rxx02 = '03' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_03) THEN LET g_rxx04_03 = 0  END IF                                                                           
   IF cl_null(g_rxx05_03) THEN LET g_rxx05_03 = 0  END IF                                                                           
   DISPLAY g_rxx04_03 TO FORMONLY.rxx04_03
   #得到卷交款金額                                                                                                                
   SELECT rxx04 INTO g_rxx04_04 FROM rxx_file                                                                                       
  #SELECT rxx04,rxx05 INTO g_rxx04_04,g_rxx05_04 FROM rxx_file                                                                                       
      WHERE rxx02 = '04' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_04) THEN LET g_rxx04_04 = 0  END IF                                                                           
   IF cl_null(g_rxx05_04) THEN LET g_rxx05_04 = 0  END IF                                                                           
   DISPLAY g_rxx04_04 TO FORMONLY.rxx04_04
   #得到聯盟卡交款金額                                                                                                      
   SELECT rxx04 INTO g_rxx04_05 FROM rxx_file                                                                                       
      WHERE rxx02 = '05' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_05) THEN LET g_rxx04_05 = 0  END IF                                                                           
   DISPLAY g_rxx04_05 TO FORMONLY.rxx04_05
   #得到儲值卡交款金額                                                                                      
   SELECT rxx04 INTO g_rxx04_06 FROM rxx_file                                                           
      WHERE rxx02 = '06' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_06) THEN LET g_rxx04_06 = 0  END IF                                                                           
   DISPLAY g_rxx04_06 TO FORMONLY.rxx04_06
   #得到衝預收交款金額                                                                                        
   SELECT rxx04 INTO g_rxx04_07 FROM rxx_file                                                                                       
      WHERE rxx02 = '07' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_07) THEN LET g_rxx04_07 = 0  END IF                                                                           
   DISPLAY g_rxx04_07 TO FORMONLY.rxx04_07
   #得到手工轉帳交款金額                                                                                      
   SELECT rxx04 INTO g_rxx04_08 FROM rxx_file                                                                                       
      WHERE rxx02 = '08' AND rxx00 = g_type                                                                                         
        AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_08) THEN LET g_rxx04_08 = 0  END IF                                                                           
   DISPLAY g_rxx04_08 TO FORMONLY.rxx04_08
 
#FUN-BA0069 add begin ---
   #得到抵現積分 銷售用
   SELECT oga87 INTO g_oga87          #抓取会员卡号
     FROM oga_file
    WHERE oga01 = g_no

   SELECT rxx04 INTO g_rxx04_09
     FROM rxx_file
    WHERE rxx00 = g_type
      AND rxx01 = g_no
      AND rxx02 = '09'
      AND rxxplant = g_org

   SELECT SUM(rxy23) INTO g_rxx04_point
     FROM rxy_file
    WHERE rxy00 = g_type
      AND rxy01 = g_no
      AND rxy03 = '09'
      AND rxyplant = g_org
   IF cl_null(g_rxx04_09) THEN
      LET g_rxx04_09 = 0
   END IF
   IF cl_null(g_rxx04_point) THEN
      LET g_rxx04_point = 0
   END IF
   DISPLAY g_rxx04_09 TO FORMONLY.rxx04_09
   DISPLAY g_rxx04_point TO FORMONLY.rxx04_point
#FUN-BA0069 add end ---

#FUN-BC0071 ---------STA
   SELECT rxx04 INTO g_rxx04_10 FROM rxx_file                                                                                       
    WHERE rxx02 = '10' AND rxx00 = g_type                                                                                         
     AND rxx01 = g_no AND rxxplant = g_org                                                                                         
   IF cl_null(g_rxx04_10) THEN LET g_rxx04_10 = 0  END IF                                                                           
   DISPLAY g_rxx04_10 TO FORMONLY.rxx04_10
#FUN-BC0071 ---------END

#FUN-BB0024 -----------STA
   #得到抵現積分 銷退用
   SELECT oha87 INTO g_oha87 FROM oha_file WHERE oha01 = g_no
#FUN-BB0024 -----------END
   DISPLAY g_sum TO FORMONLY.sum1
   #計算交款合計金額
   LET g_sum2 = g_rxx04_01 + g_rxx04_02 + g_rxx04_03 + g_rxx04_04 
              + g_rxx04_05 + g_rxx04_06 + g_rxx04_07 + g_rxx04_08
              + g_rxx04_09                                       #FUN-BA0069 add
              + g_rxx04_10                                       #FUN-BC0071 add         
  #           - g_rxx05_03 - g_rxx05_04
   IF cl_null(g_sum2) THEN LET g_sum2 = 0 END IF
   DISPLAY g_sum2 TO FORMONLY.sum2
   #計算未交款金額合計
   LET g_sum3 = g_sum - g_sum2
   DISPLAY g_sum3 TO FORMONLY.sum3
   #計算支票溢交款金額
   SELECT rxx05 INTO g_sum4 FROM rxx_file
      WHERE rxx02 = '03' AND rxx00 = g_type
        AND rxx01 = g_no AND rxxplant = g_org
   IF cl_null(g_sum4) THEN LET g_sum4 = 0 END IF
   DISPLAY g_sum4 TO FORMONLY.sum4
   #計算卷溢交款金額
   SELECT rxx05 INTO g_sum5 FROM rxx_file 
      WHERE rxx02 = '04' AND rxx00 = g_type
        AND rxx01 = g_no AND rxxplant = g_org 
   IF cl_null(g_sum5) THEN LET g_sum5 = 0 END IF
   DISPLAY g_sum5 TO FORMONLY.sum5 
END FUNCTION
#------------------現金付款開始----------------------
FUNCTION pay_money()
DEFINE l_money       LIKE rxx_file.rxx04
DEFINE l_rxy02       LIKE rxy_file.rxy02
DEFINE l_rxx04       LIKE rxx_file.rxx04
DEFINE l_money_type  LIKE rxx_file.rxx03
DEFINE l_flag        LIKE type_file.num5
DEFINE l_oha10       LIKE oha_file.oha10
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add

    IF g_type = "03" THEN
       SELECT oha10 INTO l_oha10 FROM oha_file WHERE oha01 = g_no
       IF g_flag <> 'N' AND l_oha10 IS NOT NULL THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    ELSE
       IF g_flag <> 'N' THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    END IF 
    
    OPEN WINDOW pay1_w AT 10,20 WITH FORM "sub/42f/s_pay1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   #CALL cl_ui_init()           #TQC-AC0310
    CALL cl_ui_locale("s_pay1")

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-248',g_lang) RETURNING l_string  #現金付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-260',g_lang) RETURNING l_string  #付款應付餘額
       CALL cl_set_comp_att_text("total",l_string)
    END IF
   #FUN-C30165 add END
 
    DISPLAY g_sum3 TO FORMONLY.total
    DISPLAY g_sum3 TO rxy05
    LET l_money = g_sum3
 
    INPUT l_money WITHOUT DEFAULTS FROM rxy05
 
        AFTER FIELD rxy05
           IF l_money <= 0 OR l_money > g_sum3 THEN
              CALL cl_err('','sub-187',0)
              NEXT FIELD rxy05
           END IF
           IF g_prog = "artt620" THEN
              IF l_money < g_sum3 THEN
                 CALL cl_err('','sub-215',0)
                 NEXT FIELD rxy05
              END IF
           END IF
 
        ON ACTION all_cancel
           CALL pay_cancel() RETURNING l_flag
           IF l_flag = 0 THEN
              LET INT_FLAG = 1
              EXIT INPUT
           END IF
        ON ACTION controlg
           CALL cl_cmdask()
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW pay1_w
       CALL pay_show()    
       RETURN
    END IF
  
    IF g_type = '01' OR g_type = '02' OR  
       g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add   #FUN-CC0057 add
#      g_type = '05' OR g_type = '07' THEN                        #No.FUN-A10106
      #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
       g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
       LET l_money_type = 1
    ELSE
       LET l_money_type = -1
    END IF
 
    BEGIN WORK
    SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file 
     WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
    IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
    LET l_rxy02 = l_rxy02 + 1
     
    INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxyplant,rxy21,rxy22,rxylegal,rxy33) #FUN-CB0025 Add rxy33
                  VALUES(g_type,g_no,l_rxy02,'01',l_money_type,l_money,g_org,g_today,
                         g_time1,g_legal2,'N') #FUN-CB0025
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins rxy_file',SQLCA.sqlcode,1)
       ROLLBACK WORK
       CLOSE WINDOW pay1_w
       RETURN
    END IF
 
    SELECT rxx04 INTO l_rxx04 FROM rxx_file 
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '01' AND rxxplant = g_org
    IF cl_null(l_rxx04) THEN 
       LET l_rxx04 = 0
    END IF
    
    IF SQLCA.sqlcode = 100 THEN
       INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
                     VALUES(g_type,g_no,'01',l_money_type,l_money,0,g_org,g_legal2)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                     
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)                                                                          
          ROLLBACK WORK    
          CLOSE WINDOW pay1_w                                                                                                 
          RETURN                                                                                                        
       END IF
    ELSE
       UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + l_money 
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '01' 
            AND rxxplant = g_org
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          CLOSE WINDOW pay1_w
          RETURN
       END IF
    END IF
 
    COMMIT WORK
 
    CLOSE WINDOW pay1_w
    CALL pay_show()    
END FUNCTION
#把以前交過的現金全部取消
FUNCTION pay_cancel()
 
   #FUN-C30165 add START
    IF g_type = '04' OR g_type = '06'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
      IF NOT cl_confirm('sub-271') THEN RETURN 1 END IF
    ELSE
   #FUN-C30165 add END
      IF NOT cl_confirm('art-494') THEN RETURN 1 END IF
    END IF  #FUN-C30165 add 
    BEGIN WORK
 
    #把現金交款金額置成0
    UPDATE rxx_file SET rxx04 = 0 
       WHERE rxx02 = '01' 
         AND rxx00 = g_type
         AND rxx01 = g_no
         AND rxxplant = g_org
    IF SQLCA.SQLCODE THEN 
       CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
       RETURN
    END IF
 
    #把現金交款明細都置成0
    UPDATE rxy_file SET rxy05 = 0 
       WHERE rxy00 = g_type
         AND rxy01 = g_no
         AND rxy03 = '01'
         AND rxyplant = g_org
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","rxy_file",g_no,"",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
       RETURN
    END IF
 
    COMMIT WORK   
    RETURN 0              
END FUNCTION
#----------------------現金付款結束------------------------
#----------------------銀聯卡付款--------------------------
FUNCTION pay_bank()
DEFINE l_oha10       LIKE oha_file.oha10
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add

    IF g_type = "03" THEN
       SELECT oha10 INTO l_oha10 FROM oha_file WHERE oha01 = g_no
       IF g_flag <> 'N' AND l_oha10 IS NOT NULL THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    ELSE
       IF g_flag <> 'N' THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    END IF 
    #IF g_flag <> 'N' THEN
    #   CALL cl_err('','sub-186',1)
    #   RETURN
    #END IF
   
    OPEN WINDOW pay2_w AT 10,20 WITH FORM "sub/42f/s_pay2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   #CALL cl_ui_init()           #TQC-AC0310
    CALL cl_ui_locale("s_pay2")

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-261',g_lang) RETURNING l_string  #本次付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-260',g_lang) RETURNING l_string  #付款應付餘額
       CALL cl_set_comp_att_text("total",l_string)
    END IF
   #FUN-C30165 add END
    
    DISPLAY g_sum3 TO FORMONLY.total     #未交金額合計
    CALL pay2_bp_refresh()
    CALL pay2_menu()
    
    CLOSE WINDOW pay2_w                                                                                                          
END FUNCTION
FUNCTION pay2_menu()
 
    WHILE TRUE
        CALL pay2_bp("G")
        CASE g_action_choice
           WHEN "insert"
              LET g_action_choice="insert"
              IF cl_chk_act_auth() THEN
                 CALL pay2_a()
              END IF
 
           WHEN "exit"
              EXIT WHILE
 
           WHEN "controlg"
              CALL cl_cmdask()
 
        END CASE
   END WHILE  
   CLOSE WINDOW pay2_w
   CALL pay_show()  
END FUNCTION
FUNCTION pay2_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_rxz TO s_rxz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
       ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
    
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION pay2_a()
DEFINE l_rxy02    LIKE rxy_file.rxy02                                                                              
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_total2   LIKE rxz_file.rxz05
 
   LET g_rxy.rxy05 = g_sum3
   LET g_rxy.rxy06 = ''
   LET g_rxy.rxy07 = ''
   LET g_rxy.rxy08 = (g_rxy.rxy05*g_rxy.rxy07)/1000
   LET g_rxy.rxy20 = 'N'
 
   #計算刷卡合計
   SELECT SUM(rxz05) INTO l_total2 FROM rxz_file 
       WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org AND rxz20 = '2'
   IF cl_null(l_total2) THEN LET l_total2 = 0 END IF
   DISPLAY l_total2 TO FORMONLY.total2
 
   DISPLAY g_sum3 TO FORMONLY.total      
   DISPLAY BY NAME g_rxy.rxy05,g_rxy.rxy06,g_rxy.rxy07,g_rxy.rxy08,g_rxy.rxy20
   CALL pay2_bp_refresh()
 
   INPUT BY NAME g_rxy.rxy05,g_rxy.rxy06,g_rxy.rxy20,g_rxy.rxy07,g_rxy.rxy08  
       WITHOUT DEFAULTS 
 
        BEFORE INPUT
           CALL cl_set_act_visible("accept,cancel", FALSE)       
           IF NOT cl_null(g_rxy.rxy20) THEN                                                                              
              IF g_rxy.rxy20 = 'Y' THEN                                                                                             
                 LET g_rxy.rxy08 = 20                                                                                               
                 LET g_rxy.rxy07 = ''                                                                                               
                 DISPLAY BY NAME g_rxy.rxy07,g_rxy.rxy08                                                                            
                 CALL cl_set_comp_entry("rxy07",FALSE)                                                                              
                 CALL cl_set_comp_entry("rxy08",TRUE)                                                                               
              ELSE                                                                                                                  
                 LET g_rxy.rxy07 = 0                                                                                                
                 LET g_rxy.rxy08 = (g_rxy.rxy07*g_rxy.rxy08)/1000                                                                   
                 DISPLAY BY NAME g_rxy.rxy07,g_rxy.rxy08                                                                            
                 CALL cl_set_comp_entry("rxy07",TRUE)                                                                               
                 CALL cl_set_comp_entry("rxy08",FALSE)                                                                              
              END IF                                                                                                                
           END IF       
                                                       
        AFTER FIELD rxy05                                                                                     
          #TQC-C30174 Add&Mark Begin ---
          #IF g_rxy.rxy05 <= 0 OR g_rxy.rxy05 > g_sum3 THEN                                                              
          #   CALL cl_err('','sub-187',0)                                                                          
          #   NEXT FIELD rxy05                                                                                   
          #END IF

           IF NOT cl_null(g_rxy.rxy05) THEN
              IF g_rxy.rxy05 = 0 OR g_rxy.rxy05 > g_sum3 THEN
                 CALL cl_err('','sub-242',0)
                 NEXT FIELD rxy05
              END IF
              IF NOT cl_null(g_rxy.rxy06) AND NOT cl_null(g_rxy.rxy05) AND g_rxy.rxy05 < 0 THEN
                 CALL chk_rxy06()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rxy05
                 END IF
                 CALL chk_rxy05()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rxy05
                 END IF
                 CALL get_rxy08()
                 DISPLAY BY NAME g_rxy.rxy20,g_rxy.rxy08,g_rxy.rxy07
              ELSE
          #TQC-C30174 Add&Mark End -----
                 IF NOT cl_null(g_rxy.rxy07) AND NOT cl_null(g_rxy.rxy05) THEN                                                            
                    LET g_rxy.rxy08 = (g_rxy.rxy07*g_rxy.rxy05)/1000     
                    DISPLAY BY NAME g_rxy.rxy08                                                         
                 END IF               
              END IF #TQC-C30174 Add
           END IF #TQC-C30174 Add
       #TQC-C30174 Add Begin ---
        AFTER FIELD rxy06
           IF NOT cl_null(g_rxy.rxy06) AND NOT cl_null(g_rxy.rxy05) AND g_rxy.rxy05 < 0 THEN
              CALL chk_rxy06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD rxy06
              END IF
              CALL chk_rxy05()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD rxy05
              END IF
              CALL get_rxy08()
              DISPLAY BY NAME g_rxy.rxy20,g_rxy.rxy08,g_rxy.rxy07
           END IF
       #TQC-C30174 Add End -----

        AFTER FIELD rxy07 
           IF g_rxy.rxy07 < 0 THEN
             #CALL cl_err('','sub-188',0)    #TQC-A10122 MARK
              CALL cl_err('','alm-352',0)    #TQC-A10122 ADD
              NEXT FIELD rxy07
           END IF
           IF NOT cl_null(g_rxy.rxy07) AND NOT cl_null(g_rxy.rxy05) THEN
              LET g_rxy.rxy08 = (g_rxy.rxy07*g_rxy.rxy05)/1000
              DISPLAY BY NAME g_rxy.rxy08
           END IF    
 
        AFTER FIELD rxy08
           IF NOT cl_null(g_rxy.rxy08) THEN
             #TQC-C30174 Add Begin ---
              IF NOT cl_null(g_rxy.rxy06) AND NOT cl_null(g_rxy.rxy05) AND g_rxy.rxy05 < 0 THEN
                 CALL chk_rxy08()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rxy08
                 END IF
              ELSE
             #TQC-C30174 Add End -----
                 IF g_rxy.rxy08 < 0 THEN
                    CALL cl_err('','sub-195',0)
                    NEXT FIELD rxy08
                 END IF
              END IF #TQC-C30174 Add
           END IF
            
        AFTER FIELD rxy20
          #TQC-C30174 Add Begin ---
           IF NOT cl_null(g_rxy.rxy06) AND NOT cl_null(g_rxy.rxy05) AND g_rxy.rxy05 < 0 THEN
              IF g_rxy.rxy20 = 'N' THEN
                 CALL cl_err('','sub-238',0) #退款操作時，固定手續費欄位必須勾選
                 NEXT FIELD rxy20
              END IF
              IF g_rxy.rxy20 = 'Y' THEN
                 LET g_rxy.rxy07 = ''
                 DISPLAY BY NAME g_rxy.rxy07
                 CALL cl_set_comp_entry("rxy07",FALSE)
                 CALL cl_set_comp_entry("rxy08",TRUE)
              END IF
           ELSE
          #TQC-C30174 Add End -----
              IF NOT cl_null(g_rxy.rxy20) THEN
                 IF g_rxy.rxy20 = 'Y' THEN
                    LET g_rxy.rxy08 = 20
                    LET g_rxy.rxy07 = ''
                    DISPLAY BY NAME g_rxy.rxy07,g_rxy.rxy08
                    CALL cl_set_comp_entry("rxy07",FALSE)
                    CALL cl_set_comp_entry("rxy08",TRUE)
                 ELSE
                    #LET g_rxy.rxy07 = 0  
                    LET g_rxy.rxy08 = (g_rxy.rxy07*g_rxy.rxy08)/1000                                                            
                    DISPLAY BY NAME g_rxy.rxy07,g_rxy.rxy08
                    CALL cl_set_comp_entry("rxy07",TRUE)
                    CALL cl_set_comp_entry("rxy08",FALSE)
                 END IF
              END IF
           END IF #TQC-C30174 Add
           
        ON CHANGE rxy20
          #TQC-C30174 Add Begin ---
           IF NOT cl_null(g_rxy.rxy06) AND NOT cl_null(g_rxy.rxy05) AND g_rxy.rxy05 < 0 THEN
              IF g_rxy.rxy20 = 'N' THEN
                 CALL cl_err('','sub-238',0) #退款操作時，固定手續費欄位必須勾選
                 NEXT FIELD rxy20
              END IF
              IF g_rxy.rxy20 = 'Y' THEN
                 LET g_rxy.rxy07 = ''
                 DISPLAY BY NAME g_rxy.rxy07
                 CALL cl_set_comp_entry("rxy07",FALSE)
                 CALL cl_set_comp_entry("rxy08",TRUE)
              END IF
           ELSE
          #TQC-C30174 Add End -----
              IF g_rxy.rxy20 = 'Y' THEN
                 LET g_rxy.rxy08 = 20
                 LET g_rxy.rxy07 = ''                                                                                               
                 DISPLAY BY NAME g_rxy.rxy08,g_rxy.rxy07                                                                           
                 CALL cl_set_comp_entry("rxy07",FALSE)
                 CALL cl_set_comp_entry("rxy08",TRUE)                                                                              
              ELSE                                
                 #LET g_rxy.rxy07 = 0
                 LET g_rxy.rxy08 = (g_rxy.rxy07*g_rxy.rxy08)/1000                                                                    
                 DISPLAY BY NAME g_rxy.rxy07,g_rxy.rxy08                                                                           
                 CALL cl_set_comp_entry("rxy07",TRUE)
                 CALL cl_set_comp_entry("rxy08",FALSE)
              END IF    
           END IF #TQC-C30174 Add
                       
        ON ACTION controlg                                                                                  
           CALL cl_cmdask()
 
        ON ACTION auto_card
    
        ON ACTION hard_card
           ACCEPT INPUT 
 
        ON ACTION cancel_card 
           LET g_rxy.rxy05 = ''
           LET g_rxy.rxy06 = ''
           LET g_rxy.rxy07 = ''
           LET g_rxy.rxy08 = ''
           LET g_rxy.rxy20 = ''
           DISPLAY BY NAME g_rxy.rxy05,g_rxy.rxy06,g_rxy.rxy07,g_rxy.rxy08,g_rxy.rxy20            
           LET INT_FLAG = 1
           EXIT INPUT
    END INPUT
 
    IF INT_FLAG THEN                                                                                                
       LET INT_FLAG = 0                                                                                           
       RETURN                                                                                                         
    END IF
    
    CALL pay2_insert()
    #計算銀聯卡刷卡合計                                                                                                    
    SELECT SUM(rxz05) INTO l_total2 FROM rxz_file                                                                             
        WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org AND rxz20 = '2'                      
    IF cl_null(l_total2) THEN LET l_total2 = 0 END IF                                                                               
    DISPLAY l_total2 TO FORMONLY.total2
    CALL pay_show()
    DISPLAY g_sum3 TO FORMONLY.total
END FUNCTION
 
FUNCTION pay2_insert()
DEFINE l_money_type    LIKE rxz_file.rxz02   #款別類型
DEFINE l_n             LIKE type_file.num5
DEFINE l_rxy02         LIKE rxy_file.rxy02
DEFINE l_rxz03         LIKE rxz_file.rxz03
DEFINE l_time          LIKE rxz_file.rxz07
DEFINE l_money         LIKE rxy_file.rxy08
DEFINE l_sql           STRING
   LET g_success = 'Y'
   LET l_time = TIME (CURRENT)
 
   SELECT COUNT(*) INTO l_n FROM rxx_file 
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '02' AND rxxplant = g_org
 
   IF g_type = '01' OR g_type = '02' OR 
      g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add  #FUN-CC0057 add OR g_type = '23'
#     g_type = '05' OR g_type = '07' THEN
     #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
      g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
      LET l_money_type = '1'
   ELSE
      LET l_money_type = '-1'
   END IF
   
   BEGIN WORK
 
   #檢查交款匯總檔中是否有該單別、單號、機構的交款記錄，如果有INSERT，否則UPDATE
   IF l_n = 0 OR cl_null(l_n) THEN
      INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal) 
                VALUES(g_type,g_no,'02',l_money_type,g_rxy.rxy05,0,g_org,g_legal2)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("ins","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxy.rxy05
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '02' AND rxxplant = g_org
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   #INSERT 到交款明細檔
   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
      WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
 
   IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
   LET l_rxy02 = l_rxy02 + 1
   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,
                        rxy07,rxy08,rxy18,rxy20,rxyplant,rxy21,rxy22,
                        rxylegal,rxy33)              #FUN-CB0025 Add rxy33
          VALUES(g_type,g_no,l_rxy02,'02',l_money_type,g_rxy.rxy05,
                 g_rxy.rxy06,g_rxy.rxy07,g_rxy.rxy08,'T',g_rxy.rxy20,
                 g_org,g_today,g_time1,g_legal2,'N') #FUN-CB0025
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","rxy_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   #INSERT 到刷卡明細檔
   SELECT MAX(rxz03) INTO l_rxz03 FROM rxz_file
       WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org
   IF cl_null(l_rxz03) THEN LET l_rxz03 = 0 END IF                                                                                  
   LET l_rxz03 = l_rxz03 + 1                      
   INSERT INTO rxz_file(rxz00,rxz01,rxz02,rxz03,rxz04,rxz05,rxz06,
                        rxz07,rxz08,rxz09,rxz10,rxz15,rxz20,rxzplant,
                        rxzlegal)
          VALUES(g_type,g_no,l_money_type,l_rxz03,g_rxy.rxy06,g_rxy.rxy05,
                 g_today,l_time,g_user,g_rxy.rxy08,g_rxy.rxy07,g_rxy.rxy20,
                 '2',g_org,g_legal2)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","rxz_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK 
      RETURN
   END IF
   COMMIT WORK
   #刷新刷卡明細單身
   CALL pay2_bp_refresh()
   CALL pay_show()
END FUNCTION
FUNCTION pay2_bp_refresh()
DEFINE  l_cnt    LIKE type_file.num5
DEFINE  l_sql    STRING
 
   LET l_sql = "SELECT rxz03,rxz04,rxz05,rxz06,rxz07,rxz08,'',",
               "       rxz09,rxz10,rxz11,'',rxz12,rxz13,rxz14,rxz15 ",
               "  FROM rxz_file ",
               " WHERE rxz00 = '",g_type,"' AND rxz01 = '",g_no,
               "' AND rxzplant = '",g_org,"' AND rxz20 = '2' ",
               " ORDER BY rxz03 "
   PREPARE pay2_pb FROM l_sql
   DECLARE rzx2_cs CURSOR FOR pay2_pb 
   
   CALL g_rxz.clear()
   LET l_cnt = 1
 
   FOREACH rzx2_cs INTO g_rxz[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gen02 INTO g_rxz[l_cnt].rxz08_desc FROM gen_file
          WHERE gen01 = g_rxz[l_cnt].rxz08
      
      SELECT nmt02 INTO g_rxz[l_cnt].rxz11_desc FROM nmt_file
          WHERE nmt01 = g_rxz[l_cnt].rxz11
      LET l_cnt = l_cnt + 1
   END FOREACH
 
   CALL g_rxz.deleteElement(l_cnt)
   LET g_rec_b = l_cnt-1
 
   DISPLAY ARRAY g_rxz TO s_rxz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION

#TQC-C30174 Add Begin ---
FUNCTION chk_rxy05()
DEFINE l_rxz05 LIKE rxz_file.rxz05

   LET g_errno = ''
   INITIALIZE l_rxz05 TO NULL
   SELECT SUM(rxz05) INTO l_rxz05 
     FROM rxz_file 
    WHERE rxz00 = g_type AND rxz01 = g_no AND rxz04 = g_rxy.rxy06
   IF cl_null(l_rxz05) THEN LET l_rxz05 = 0 END IF
   IF g_rxy.rxy05 * (-1) <> l_rxz05 THEN
      LET g_errno = 'sub-239' #退款操作時，應將當前信用卡的付款金額一次退清
   END IF
END FUNCTION

FUNCTION chk_rxy06()
DEFINE l_n LIKE type_file.num5

   LET g_errno = ''
   LET l_n = 0
   SELECT COUNT(*) INTO l_n 
     FROM rxz_file 
    WHERE rxz00 = g_type AND rxz01 = g_no AND rxz04 = g_rxy.rxy06
   IF l_n = 0 THEN 
      LET g_errno = 'sub-240' #不存在當前信用卡付款資料，不能做退款操作
   END IF 
END FUNCTION

#若為退款，手續費為單身手續費匯總且勾選固定手續費欄位
FUNCTION get_rxy08()
DEFINE l_rxz09 LIKE rxz_file.rxz09

   INITIALIZE l_rxz09 TO NULL
   SELECT SUM(rxz09) INTO l_rxz09 
     FROM rxz_file 
    WHERE rxz00 = g_type AND rxz01 = g_no AND rxz04 = g_rxy.rxy06
   IF cl_null(l_rxz09) THEN LET l_rxz09 = 0 END IF
   LET g_rxy.rxy20 = 'Y'
   LET g_rxy.rxy07 = ''
   LET g_rxy.rxy08 = l_rxz09 * (-1)
   CALL cl_set_comp_entry('rxy07',FALSE)
END FUNCTION

FUNCTION chk_rxy08()
DEFINE l_rxz09 LIKE rxz_file.rxz09

   LET g_errno = ''
   INITIALIZE l_rxz09 TO NULL
   SELECT SUM(rxz09) INTO l_rxz09 
     FROM rxz_file 
    WHERE rxz00 = g_type AND rxz01 = g_no AND rxz04 = g_rxy.rxy06
   IF cl_null(l_rxz09) THEN LET l_rxz09 = 0 END IF
   IF l_rxz09 <> g_rxy.rxy08*(-1) THEN
      LET g_errno = 'sub-241' #退款操作時，應將當前信用卡的付款手續費一次退清
   END IF
END FUNCTION
#TQC-C30174 Add End -----

#-------------------------銀聯卡交款結束---------------------------
#-------------------支票付款開始----------------------------------
FUNCTION pay_cheque()
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add
    
    IF g_flag <> 'N' THEN
       CALL cl_err('','sub-186',1)
       RETURN
    END IF
 
    OPEN WINDOW pay3_w AT 10,20 WITH FORM "sub/42f/s_pay3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_init()            #TQC-AC0310
    CALL cl_ui_locale("s_pay3")
    CALL cl_set_comp_visible("rxy02",FALSE)
   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-262',g_lang) RETURNING l_string  #付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-263',g_lang) RETURNING l_string  #票券溢付款金額
       CALL cl_set_comp_att_text("rxy17",l_string)
    END IF
   #FUN-C30165 add END
    CALL pay3_b_fill()
    CALL pay3_menu()
    CLOSE WINDOW pay3_w 
    CALL pay_show()
END FUNCTION
FUNCTION pay3_menu()
 
    WHILE TRUE
        CALL pay3_bp("G")
        CASE g_action_choice
           WHEN "detail"
              LET g_action_choice="detail"
              CALL pay3_b()
 
           WHEN "exit"
              EXIT WHILE
 
           WHEN "controlg"
              CALL cl_cmdask()
 
        END CASE
   END WHILE  
   CLOSE WINDOW pay3_w
   CALL pay_show()  
END FUNCTION
FUNCTION pay3_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_rxy3 TO s_rxy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
 
       ON ACTION detail
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DISPLAY
       
       ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION pay3_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1,
    l_sql           STRING,
    l_money_type    LIKE rxz_file.rxz02,
    l_rxy05         LIKE rxy_file.rxy05,
    l_rxy17         LIKE rxy_file.rxy17
DEFINE l_nmt01      LIKE nmt_file.nmt01 #No.FUN-C30038								
DEFINE l_nmtacti    LIKE nmt_file.nmtacti #No.FUN-C30038
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET l_sql = "SELECT rxy02,rxy06,rxy09,rxy10,rxy11,rxy05,rxy17 FROM rxy_file",
                " WHERE rxy00='",g_type,"' AND rxy01= '",g_no,
                "' AND rxyplant = '",g_org,"' AND rxy02 = ? ",
                "  AND rxy33 = 'N'", #FUN-CB0025
                " FOR UPDATE "
    LET l_sql = cl_forupd_sql(l_sql)  #No.TQC-9B0025
    DECLARE pay3_bcl CURSOR FROM l_sql      # LOCK CURSOR
 
    INPUT ARRAY g_rxy3 WITHOUT DEFAULTS FROM s_rxy.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
      
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_rxy_t.* = g_rxy3[l_ac].*
 
              OPEN pay3_bcl USING g_rxy_t.rxy02 
              IF STATUS THEN
                 CALL cl_err("OPEN pay3_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE 
                 FETCH pay3_bcl INTO g_rxy3[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxy_t.rxy02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxy3[l_ac].* TO NULL
           #LET g_rxy3[l_ac].rxy05 = g_sum3
           LET g_rxy_t.* = g_rxy3[l_ac].*
           CALL cl_show_fld_cont()
           SELECT MAX(rxy02) INTO g_rxy3[l_ac].rxy02 FROM rxy_file                                                        
               WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org                                         
           IF cl_null(g_rxy3[l_ac].rxy02) THEN                                                                           
              LET g_rxy3[l_ac].rxy02 = 0                                                                                   
           END IF                                                                                               
           LET g_rxy3[l_ac].rxy02 = g_rxy3[l_ac].rxy02 + 1
           
           NEXT FIELD rxy06
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF g_type = '01' OR g_type = '02' OR 
              g_type = '21' OR g_type = '20' OR  g_type = '23' OR        #FUN-C90085 add   #FUN-CC0057 add g_type = '23'
#             g_type = '05' OR g_type = '07' THEN
             #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
              g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
              LET l_money_type = '1'
           ELSE
              LET l_money_type = '-1'
           END IF
           INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,
                                rxy06,rxy09,rxy10,rxy11,rxy17,rxy18,
                                rxyplant,rxy21,rxy22,rxylegal,rxy33)  #FUN-CB0025 Add rxy33
                       VALUES(g_type,g_no,g_rxy3[l_ac].rxy02,'03',l_money_type,
                              g_rxy3[l_ac].rxy05,g_rxy3[l_ac].rxy06,g_rxy3[l_ac].rxy09,
                              g_rxy3[l_ac].rxy10,g_rxy3[l_ac].rxy11,g_rxy3[l_ac].rxy17,
                              'T',g_org,g_today,g_time1,g_legal2,'N') #FUN-CB0025
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","rxy_file",g_rxy3[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
          END IF
          #更新交款匯總檔
          SELECT COUNT(*) INTO l_n FROM rxx_file 
              WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '03' AND rxxplant = g_org
          IF cl_null(l_n) OR l_n = 0 THEN
             INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,
                                  rxxplant,rxxlegal)
                           VALUES(g_type,g_no,'03',l_money_type,g_rxy3[l_ac].rxy05,
                                  g_rxy3[l_ac].rxy17,NULL,g_org,g_legal2)
          ELSE
             UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxy3[l_ac].rxy05,
                                 rxx05 = COALESCE(rxx05,0) + g_rxy3[l_ac].rxy17
                WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '03' AND rxxplant = g_org
          END IF
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("ins","rxy_file",g_rxy3[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          END IF
          CALL pay_show()
 
       AFTER FIELD rxy09
          IF NOT cl_null(g_rxy3[l_ac].rxy09) AND 
             NOT cl_null(g_rxy3[l_ac].rxy05) THEN
             IF g_rxy3[l_ac].rxy09 < g_rxy3[l_ac].rxy05 THEN
                CALL cl_err('','sub-190',0)
                NEXT FIELD rxy09
             END IF
             LET g_rxy3[l_ac].rxy17 = g_rxy3[l_ac].rxy09 - g_rxy3[l_ac].rxy05
          END IF
          IF NOT cl_null(g_rxy3[l_ac].rxy09) THEN
             IF g_rxy3[l_ac].rxy09 <= 0 THEN
                CALL cl_err('','sub-187',0)
                NEXT FIELD rxy09
             END IF
          END IF

#No.FUN-C30038---START---
      AFTER FIELD rxy11
         IF NOT cl_null(g_rxy3[l_ac].rxy11) THEN
            LET g_errno=''
            SELECT nmt01,nmtacti INTO l_nmt01,l_nmtacti FROM nmt_file
              WHERE nmt01=g_rxy3[l_ac].rxy11
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno='aap-007'
                                        LET l_nmt01=NULL
               WHEN l_nmtacti='N'       LET g_errno='axr-093'
               OTHERWISE
                  LET g_errno=SQLCA.sqlcode USING '------'
            END CASE

            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rxy3[l_ac].rxy11,g_errno,1)
               LET g_rxy3[l_ac].rxy11 = g_rxy_t.rxy11
               DISPLAY BY NAME g_rxy3[l_ac].rxy11
               NEXT FIELD rxy11
            END IF
         END IF
#No.FUN-C30038---END---
 
       AFTER FIELD rxy05
          IF NOT cl_null(g_rxy3[l_ac].rxy09) AND
             NOT cl_null(g_rxy3[l_ac].rxy05) THEN
             IF g_rxy3[l_ac].rxy09 < g_rxy3[l_ac].rxy05 THEN
                CALL cl_err('','sub-190',0)
                NEXT FIELD rxy05
             END IF
             LET g_rxy3[l_ac].rxy17 = g_rxy3[l_ac].rxy09 - g_rxy3[l_ac].rxy05
          END IF
          IF NOT cl_null(g_rxy3[l_ac].rxy05) THEN
             IF g_rxy_t.rxy05 IS NULL THEN LET g_rxy_t.rxy05 = 0 END IF
             IF (g_rxy3[l_ac].rxy05 - g_rxy_t.rxy05)> g_sum3 
                OR g_rxy3[l_ac].rxy05 <= 0 THEN
                CALL cl_err('','sub-187',0)
                NEXT FIELD rxy05
             END IF
          END IF
 
       BEFORE DELETE
            IF g_rxy_t.rxy02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM rxy_file WHERE rxy00 = g_type AND rxy01 = g_no
                    AND rxyplant = g_org AND rxy02 = g_rxy_t.rxy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rxy_file",g_rxy_t.rxy02,"",SQLCA.sqlcode,"","",1)
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                #更新交款匯總檔
                IF g_rxy_t.rxy05 IS NULL THEN LET g_rxy_t.rxy05 = 0 END IF
 
                UPDATE rxx_file SET rxx04 = rxx04 - g_rxy_t.rxy05,
                                    rxx05 = rxx05 - g_rxy_t.rxy17
                   WHERE rxx00 = g_type AND rxx01 = g_no 
                     AND rxxplant = g_org AND rxx02 = '03'
                IF SQLCA.sqlcode THEN
                   CANCEL DELETE
                END IF
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rxy3[l_ac].* = g_rxy_t.*
            CLOSE pay3_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_rxy3[l_ac].rxy02,-263,0)
            LET g_rxy3[l_ac].* = g_rxy_t.*
         ELSE
            UPDATE rxy_file SET rxy06=g_rxy3[l_ac].rxy06,
                                rxy09=g_rxy3[l_ac].rxy09,
                                rxy10=g_rxy3[l_ac].rxy10,
                                rxy11=g_rxy3[l_ac].rxy11,
                                rxy05=g_rxy3[l_ac].rxy05,
                                rxy17=g_rxy3[l_ac].rxy17
                WHERE rxy00 = g_type AND rxy01 = g_no 
                  AND rxy02 = g_rxy_t.rxy02 AND rxyplant = g_org
                   
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","rxy_file",g_rxy_t.rxy02,"",SQLCA.sqlcode,"","",1)  
               LET g_rxy3[l_ac].* = g_rxy_t.*
            ELSE
               LET l_rxy05 = g_rxy3[l_ac].rxy05 - g_rxy_t.rxy05
               LET l_rxy17 = g_rxy3[l_ac].rxy17 - g_rxy_t.rxy17
               IF l_rxy05 IS NULL THEN LET l_rxy05 = 0 END IF
               IF l_rxy17 IS NULL THEN LET l_rxy17 = 0 END IF
               UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + l_rxy05,                                         
                                   rxx05 = COALESCE(rxx05,0) + l_rxy17                                              
                  WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '03' AND rxxplant = g_org
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  RETURN
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL pay_show()
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_rxy3[l_ac].* = g_rxy_t.*
            END IF
            CLOSE pay3_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE pay3_bcl
         COMMIT WORK

#No.FUN-C30038---START---
		ON ACTION controlp					     
		   CASE					          
		      WHEN INFIELD(rxy11)					              
		         CALL cl_init_qry_var()					                
		         LET g_qryparam.form="q_nmt"					                
		         LET g_qryparam.default1=g_rxy3[l_ac].rxy11
                 
		         CALL cl_create_qry() RETURNING g_rxy3[l_ac].rxy11			                
		         DISPLAY BY NAME g_rxy3[l_ac].rxy11	                 
		         NEXT FIELD rxy11			 
		      OTHERWISE					            
		         EXIT CASE					                 
		  END CASE	
#No.FUN-C30038---END---
    
      END INPUT
      CLOSE pay3_bcl
      COMMIT WORK   
END FUNCTION
FUNCTION pay3_b_fill()
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
  
    LET l_sql = "SELECT rxy02,rxy06,rxy09,rxy10,rxy11,rxy05,rxy17 ",
                "FROM rxy_file WHERE rxy00 = '",g_type,"' AND rxy03 = '03' ",
                " AND rxy01 = '",g_no,"' AND rxyplant = '",g_org,"'"
               ,"  AND rxy33 = 'N'"  #FUN-CB0025
    PREPARE pay3_pb FROM l_sql
    DECLARE pay3_curs CURSOR FOR pay3_pb
 
    CALL g_rxy3.clear()
    LET l_cnt = 1
    MESSAGE "Searching!"
    FOREACH pay3_curs INTO g_rxy3[l_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET l_cnt = l_cnt + 1
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rxy3.deleteElement(l_cnt)
    MESSAGE ""
    LET g_rec_b = l_cnt-1
END FUNCTION
#--------------支票結束---------------------------------
FUNCTION pay_paper()
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add
 
    IF g_flag <> 'N' THEN
       CALL cl_err('','sub-186',1)
       RETURN
    END IF
 
    OPEN WINDOW pay4_w AT 10,20 WITH FORM "sub/42f/s_pay4"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_init()             #TQC-AC0310
   #CALL cl_ui_locale("s_pay4_w") #TQC-AC0310 #TQC-AC0127 mark
    CALL cl_ui_locale("s_pay4") #TQC-AC0127   add 
    CALL cl_set_comp_visible("rxy02",FALSE)
    CALL cl_set_comp_visible("lpx04",FALSE)  #bnl 券類型編號的有效日期已不用了
   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-264',g_lang) RETURNING l_string  #券付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-265',g_lang) RETURNING l_string  #券溢付款金額
       CALL cl_set_comp_att_text("rxy17",l_string)
    END IF
   #FUN-C30165 add END
    CALL pay4_b_fill()
    CALL pay4_menu()
    CLOSE WINDOW pay4_w 
    CALL pay_show()
END FUNCTION
FUNCTION pay4_menu()
 
    WHILE TRUE
        CALL pay4_bp("G")
        CASE g_action_choice
           WHEN "detail"
              LET g_action_choice="detail"
              CALL pay4_b()
 
           WHEN "exit"
              EXIT WHILE
 
           WHEN "controlg"
              CALL cl_cmdask()
 
        END CASE
   END WHILE  
   CALL pay_show()  
END FUNCTION
FUNCTION pay4_bp(p_ud)
DEFINE  p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_rxy4 TO s_rxy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
 
       ON ACTION detail
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DISPLAY
       
       ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION pay4_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1,
    l_sql           STRING,
    l_money_type    LIKE rxz_file.rxz02
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET l_sql = "SELECT rxy02,rxy12,'','',rxy13,'',rxy14,rxy15,rxy16,",
                "'',rxy05,rxy17 FROM rxy_file",
                " WHERE rxy00='",g_type,"' AND rxy01= '",g_no,
                "' AND rxyplant = '",g_org,"' AND rxy02 = ? ",
                "  AND rxy33 = 'N'", #FUN-CB0025
                " FOR UPDATE "
    LET l_sql = cl_forupd_sql(l_sql)  #No.TQC-9B0025
    DECLARE pay4_bcl CURSOR FROM l_sql      # LOCK CURSOR
 
    INPUT ARRAY g_rxy4 WITHOUT DEFAULTS FROM s_rxy.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
      
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_rxy4_t.* = g_rxy4[l_ac].*
 
              OPEN pay4_bcl USING g_rxy4_t.rxy02 
              IF STATUS THEN
                 CALL cl_err("OPEN pay4_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE 
                 FETCH pay4_bcl INTO g_rxy4[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxy4_t.rxy02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT lpx02,lpx04 INTO g_rxy4[l_ac].rxy12_desc,g_rxy4[l_ac].lpx04                         
                    FROM lpx_file WHERE lpx01 = g_rxy4[l_ac].rxy12
                 SELECT lrz02 INTO g_rxy4[l_ac].rxy13_desc FROM lrz_file
                  WHERE lrz01 = g_rxy4[l_ac].rxy13 AND lrz03 = 'Y'
                 LET g_rxy4[l_ac].total = g_rxy4[l_ac].rxy13_desc*g_rxy4[l_ac].rxy16
              END IF
              CALL cl_show_fld_cont()
            END IF
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxy4[l_ac].* TO NULL
           LET g_rxy4_t.* = g_rxy4[l_ac].*
           CALL cl_show_fld_cont()
           SELECT MAX(rxy02) INTO g_rxy4[l_ac].rxy02 FROM rxy_file                                                        
               WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org                                         
           IF cl_null(g_rxy4[l_ac].rxy02) THEN                                                                           
              LET g_rxy4[l_ac].rxy02 = 0                                                                                   
           END IF                                                                                               
           LET g_rxy4[l_ac].rxy02 = g_rxy4[l_ac].rxy02 + 1
           NEXT FIELD rxy12
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_type = '01' OR g_type = '02' OR 
              g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add  #FUN-CC0057 add g_type = '23'
#             g_type = '05' OR g_type = '07' THEN
             #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
              g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
              LET l_money_type = '1'
           ELSE
              LET l_money_type = '-1'
           END IF
           IF g_rxy4[l_ac].rxy17 IS NULL THEN LET g_rxy4[l_ac].rxy17 = 0 END IF
           INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,
                                rxy12,rxy13,rxy14,rxy15,rxy16,rxy17,
                                rxyplant,rxy21,rxy22,rxylegal,rxy33)                 #FUN-CB0025 Add rxy33
                       VALUES(g_type,g_no,g_rxy4[l_ac].rxy02,'04',l_money_type,
                              g_rxy4[l_ac].rxy05,g_rxy4[l_ac].rxy12,g_rxy4[l_ac].rxy13,
                              g_rxy4[l_ac].rxy14,g_rxy4[l_ac].rxy15,g_rxy4[l_ac].rxy16,
                              g_rxy4[l_ac].rxy17,g_org,g_today,g_time1,g_legal2,'N') #FUN-CB0025
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","rxy_file",g_rxy4[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
          END IF
          IF g_rxy4[l_ac].rxy05 IS NULL THEN LET g_rxy4[l_ac].rxy05 = 0 END IF 
          IF g_rxy4[l_ac].rxy17 IS NULL THEN LET g_rxy4[l_ac].rxy17 = 0 END IF 
          SELECT COUNT(*) INTO l_n FROM rxx_file 
              WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '04' AND rxxplant = g_org
          IF cl_null(l_n) OR l_n = 0 THEN
             INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,
                                  rxxplant,rxxlegal) 
                           VALUES(g_type,g_no,'04',l_money_type,g_rxy4[l_ac].rxy05,
                                  g_rxy4[l_ac].rxy17,NULL,g_org,g_legal2)
          ELSE
             UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxy4[l_ac].rxy05,
                                 rxx05 = COALESCE(rxx05,0) + g_rxy4[l_ac].rxy17
                WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '04' AND rxxplant = g_org
          END IF
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("ins","rxy_file",g_rxy4[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          END IF
          CALL pay_show()
 
       AFTER FIELD rxy12
          IF NOT cl_null(g_rxy4[l_ac].rxy12) THEN
            IF g_rxy4_t.rxy12 IS NULL OR
               (g_rxy4[l_ac].rxy12 != g_rxy4_t.rxy12 ) THEN
               CALL pay4_rxy12()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxy4[l_ac].rxy12,g_errno,0)
                  LET g_rxy4[l_ac].rxy12 = g_rxy4_t.rxy12
                  DISPLAY BY NAME g_rxy4[l_ac].rxy12
                  NEXT FIELD rxy12
               END IF
               #檢查交易單身中是否有折價，若有折價，不可使用可用于促銷的券
               CALL pay4_scale()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxy4[l_ac].rxy12,g_errno,0)
                  LET g_rxy4[l_ac].rxy12 = g_rxy4_t.rxy12
                  DISPLAY BY NAME g_rxy4[l_ac].rxy12
                  NEXT FIELD rxy12
               END IF
            END IF  
          ELSE LET g_rxy4[l_ac].rxy12_desc = NULL
          END IF
 
      AFTER FIELD rxy13
          IF NOT cl_null(g_rxy4[l_ac].rxy13) THEN
             CALL pay4_rxy13()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rxy4[l_ac].rxy13,g_errno,0) 
                NEXT FIELD rxy13
             END IF
          
             IF NOT cl_null(g_rxy4[l_ac].rxy15) 
                AND NOT cl_null(g_rxy4[l_ac].rxy14) THEN
                LET g_rxy4[l_ac].total = g_rxy4[l_ac].rxy16*g_rxy4[l_ac].rxy13_desc
             END IF
          ELSE
             LET g_rxy4[l_ac].rxy13_desc = NULL 
          END IF
 
      AFTER FIELD rxy14
          IF NOT cl_null(g_rxy4[l_ac].rxy15) 
             AND NOT cl_null(g_rxy4[l_ac].rxy14) THEN
             CALL pay4_chk_rxy14()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0) 
                NEXT FIELD rxy14
             END IF
             #No.FUN-9B0157 ..begin
             IF g_success = 'N' THEN
                CALL s_showmsg()
                NEXT FIELD rxy14
             END IF
             #No.FUN-9B0157 ..end
             IF NOT cl_null(g_rxy4[l_ac].rxy13) THEN
                LET g_rxy4[l_ac].total = g_rxy4[l_ac].rxy16*g_rxy4[l_ac].rxy13_desc
             END IF
             #計算券益交金額
             IF NOT cl_null(g_rxy4[l_ac].rxy13)                                                                                     
                AND NOT cl_null(g_rxy4[l_ac].rxy05) THEN                                                                
                LET g_rxy4[l_ac].rxy17 = g_rxy4[l_ac].total - g_rxy4[l_ac].rxy05                                                    
             END IF 
          END IF
 
       AFTER FIELD rxy15
          IF NOT cl_null(g_rxy4[l_ac].rxy15) 
             AND NOT cl_null(g_rxy4[l_ac].rxy14) THEN
             CALL pay4_chk_rxy14()                                                                                                  
             IF NOT cl_null(g_errno) THEN                                                                                           
                CALL cl_err('',g_errno,0)                                                                                           
                NEXT FIELD rxy15                                                                                                   
             END IF
             #No.FUN-9B0157 ..begin
             IF g_success = 'N' THEN
                CALL s_showmsg()
                NEXT FIELD rxy15
             END IF
             #No.FUN-9B0157 ..end
             IF NOT cl_null(g_rxy4[l_ac].rxy13) THEN
                LET g_rxy4[l_ac].total = g_rxy4[l_ac].rxy16*g_rxy4[l_ac].rxy13_desc    
             END IF
             #計算券益交金額
             IF NOT cl_null(g_rxy4[l_ac].rxy13) 
                AND NOT cl_null(g_rxy4[l_ac].rxy05) THEN
                LET g_rxy4[l_ac].rxy17 = g_rxy4[l_ac].total - g_rxy4[l_ac].rxy05
             END IF 
          END IF
 
       AFTER FIELD rxy05
          IF NOT cl_null(g_rxy4[l_ac].total) AND
             NOT cl_null(g_rxy4[l_ac].rxy05) THEN
             IF g_rxy4[l_ac].total < g_rxy4[l_ac].rxy05 THEN
                CALL cl_err('','sub-192',0)
                NEXT FIELD rxy05
             END IF
             LET g_rxy4[l_ac].rxy17 = g_rxy4[l_ac].total - g_rxy4[l_ac].rxy05
          END IF
          IF NOT cl_null(g_rxy4[l_ac].rxy05) THEN
             IF g_rxy4_t.rxy05 IS NULL THEN LET g_rxy4_t.rxy05 = 0 END IF
             IF (g_rxy4[l_ac].rxy05-g_rxy4_t.rxy05) > g_sum3 
                OR g_rxy4[l_ac].rxy05 <= 0 THEN
                CALL cl_err('','sub-187',0)
                NEXT FIELD rxy05
             END IF
          END IF
 
       BEFORE DELETE
            IF g_rxy4_t.rxy02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM rxy_file WHERE rxy00 = g_type AND rxy01 = g_no
                    AND rxyplant = g_org AND rxy02 = g_rxy4_t.rxy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rxy_file",g_rxy4_t.rxy02,"",SQLCA.sqlcode,"","",1)
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                #
                IF g_rxy4_t.rxy05 IS NULL THEN LET g_rxy4_t.rxy05 = 0 END IF
                UPDATE rxx_file SET rxx04 = rxx04 - g_rxy4_t.rxy05,
                                    rxx05 = rxx05 - g_rxy4_t.rxy17
                   WHERE rxx00 = g_type AND rxx01 = g_no 
                     AND rxxplant = g_org AND rxx02 = '04'
                IF SQLCA.sqlcode THEN
                   CANCEL DELETE
                END IF
                COMMIT WORK
            END IF
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rxy4[l_ac].* = g_rxy4_t.*
            CLOSE pay4_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_rxy4[l_ac].rxy02,-263,0)
            LET g_rxy4[l_ac].* = g_rxy4_t.*
         ELSE
            UPDATE rxy_file SET rxy12=g_rxy4[l_ac].rxy12,
                                rxy13=g_rxy4[l_ac].rxy13,
                                rxy14=g_rxy4[l_ac].rxy14,
                                rxy15=g_rxy4[l_ac].rxy15,
                                rxy16=g_rxy4[l_ac].rxy16,
                                rxy05=g_rxy4[l_ac].rxy05,
                                rxy17=g_rxy4[l_ac].rxy17
                WHERE rxy00 = g_type AND rxy01 = g_no 
                  AND rxy02 = g_rxy4_t.rxy02 AND rxyplant = g_org
                   
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","rxy_file",g_rxy4_t.rxy02,"",SQLCA.sqlcode,"","",1)  
               LET g_rxy4[l_ac].* = g_rxy4_t.*
            ELSE
               UPDATE rxx_file SET rxx04 = rxx04 + (g_rxy4[l_ac].rxy05 - g_rxy4_t.rxy05),
                                   rxx05 = rxx05 + (g_rxy4[l_ac].rxy17 - g_rxy4_t.rxy17)
                   WHERE rxx00 = g_type AND rxx01 = g_no 
                     AND rxxplant = g_org AND rxx02 = '04'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
                  LET g_rxy4[l_ac].* = g_rxy4_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL pay_show()
               END IF
            END IF
         END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_rxy4[l_ac].* = g_rxy4_t.*
             END IF
             CLOSE pay4_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE pay4_bcl
          COMMIT WORK
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(rxy12)
               CALL cl_init_qry_var()
               #LET g_qryparam.arg1 = g_today   #No.FUN-9B0157
               LET g_qryparam.form ="q_lpx01_1"
               LET g_qryparam.default1 = g_rxy4[l_ac].rxy12
               CALL cl_create_qry() RETURNING g_rxy4[l_ac].rxy12
               DISPLAY BY NAME g_rxy4[l_ac].rxy12
               CALL pay4_rxy12()
               NEXT FIELD rxy12
 
             WHEN INFIELD(rxy13)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lrz01"
               LET g_qryparam.default1 = g_rxy4[l_ac].rxy13
               CALL cl_create_qry() RETURNING g_rxy4[l_ac].rxy13
               DISPLAY BY NAME g_rxy4[l_ac].rxy13
               CALL pay4_rxy13()
               NEXT FIELD rxy13
            END CASE
 
      END INPUT
      CLOSE pay4_bcl
      COMMIT WORK   
 
END FUNCTION
#檢查券面額編號
FUNCTION pay4_rxy13()
DEFINE l_lrz03      LIKE lrz_file.lrz03   
 
   LET g_errno = ''
   SELECT lrz02,lrz03 INTO g_rxy4[l_ac].rxy13_desc,l_lrz03 FROM lrz_file 
       WHERE lrz01 = g_rxy4[l_ac].rxy13
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'sub-208'
        WHEN l_lrz03 = 'N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'   
   END CASE
 
END FUNCTION
#比較券的起始編號和終止編號
FUNCTION pay4_chk_rxy14()
DEFINE l_start      LIKE  rxy_file.rxy14
DEFINE l_end        LIKE  rxy_file.rxy15
DEFINE l_flag       LIKE  rxy_file.rxy15 #No.FUN-9B0157
DEFINE l_flag1      LIKE  rxy_file.rxy15 #No.FUN-9B0157
DEFINE l_location   LIKE  type_file.num5
DEFINE l_i          LIKE  type_file.num5
DEFINE l_lqe01      LIKE  lqe_file.lqe01 #No.FUN-9B0157
DEFINE l_lqe02      LIKE  lqe_file.lqe02 #No.FUN-9B0157
DEFINE l_lqe03      LIKE  lqe_file.lqe03 #No.FUN-9B0157
DEFINE l_lqe17      LIKE  lqe_file.lqe17 #No.FUN-9B0157
DEFINE l_lqe20      LIKE  lqe_file.lqe20 #No.FUN-9B0157
DEFINE l_lqe21      LIKE  lqe_file.lqe21 #No.FUN-9B0157
DEFINE l_lpx21      LIKE  lpx_file.lpx21 #No.FUN-9B0157
DEFINE l_lpx22      LIKE  lpx_file.lpx22 #No.FUN-9B0157
DEFINE l_lpx23      LIKE  lpx_file.lpx23 #No.FUN-9B0157
DEFINE l_lpx24      LIKE  lpx_file.lpx24 #No.FUN-9B0157
DEFINE l_success    LIKE  type_file.chr1 #No.FUN-9B0157

   LET g_errno = ''
   LET g_success ='Y'  #No.FUN-A10016
   #No.FUN-9B0157 ..begin
   #No.FUN-A10016 ..begin
   #IF cl_null(g_rxy4[l_ac].rxy12) AND cl_null(g_rxy4[l_ac].rxy13) THEN
   #   SELECT lqe02,lqe03 INTO g_rxy4[l_ac].rxy12,g_rxy4[l_ac].rxy13
   #     FROM lqe_file
   #    WHERE lqe01 = g_rxy4[l_ac].rxy14
   #END IF
   #IF cl_null(g_rxy4[l_ac].rxy12) AND cl_null(g_rxy4[l_ac].rxy13) THEN
   #   SELECT lqe02,lqe03 INTO g_rxy4[l_ac].rxy12,g_rxy4[l_ac].rxy13
   #     FROM lqe_file
   #    WHERE lqe01 = g_rxy4[l_ac].rxy15
   #END IF
   IF NOT cl_null(g_rxy4[l_ac].rxy14) AND cl_null(g_rxy4[l_ac].rxy12) THEN
      SELECT lqe02 INTO g_rxy4[l_ac].rxy12
        FROM lqe_file
       WHERE lqe01 = g_rxy4[l_ac].rxy14
   END IF
   IF NOT cl_null(g_rxy4[l_ac].rxy15) AND cl_null(g_rxy4[l_ac].rxy12) THEN
      SELECT lqe02 INTO g_rxy4[l_ac].rxy12
        FROM lqe_file
       WHERE lqe01 = g_rxy4[l_ac].rxy15
   END IF
   IF NOT cl_null(g_rxy4[l_ac].rxy14) AND cl_null(g_rxy4[l_ac].rxy13) THEN
      SELECT lqe03 INTO g_rxy4[l_ac].rxy13
        FROM lqe_file
       WHERE lqe01 = g_rxy4[l_ac].rxy14
   END IF
   IF NOT cl_null(g_rxy4[l_ac].rxy15) AND cl_null(g_rxy4[l_ac].rxy13) THEN
      SELECT lqe03 INTO g_rxy4[l_ac].rxy13
        FROM lqe_file
       WHERE lqe01 = g_rxy4[l_ac].rxy15
   END IF
   #No.FUN-A10016 ..end
   SELECT lrz02 INTO g_rxy4[l_ac].rxy13_desc FROM lrz_file
     WHERE lrz01 = g_rxy4[l_ac].rxy13 AND lrz03 = 'Y'
   IF  cl_null(g_rxy4[l_ac].rxy12) OR  
       cl_null(g_rxy4[l_ac].rxy13) THEN
       LET g_errno='sub-220'
       RETURN
   END IF
 
   SELECT lpx02,lpx21,lpx22,lpx23,lpx24 
     INTO g_rxy4[l_ac].rxy12_desc,l_lpx21,l_lpx22,l_lpx23,l_lpx24
     FROM lpx_file
    WHERE lpx01 = g_rxy4[l_ac].rxy12
   IF SQLCA.sqlcode=100 THEN
      LET g_errno ='sub-218'
      RETURN
   END IF 
   DISPLAY BY NAME g_rxy4[l_ac].rxy12
   DISPLAY BY NAME g_rxy4[l_ac].rxy13 
   DISPLAY BY NAME g_rxy4[l_ac].rxy12_desc
   DISPLAY BY NAME g_rxy4[l_ac].rxy13_desc 
   IF NOT cl_null(g_rxy4[l_ac].rxy14) THEN
      IF l_lpx21 <> LENGTH(g_rxy4[l_ac].rxy14) THEN
         LET g_errno = 'sub-216'
         RETURN 
      END IF
      IF l_lpx23<>g_rxy4[l_ac].rxy14[1,l_lpx22] THEN
         LET g_errno = 'sub-215' 
         RETURN
      END IF
      FOR l_i = l_lpx22+1 TO l_lpx21                                                                          
         IF g_rxy4[l_ac].rxy14[l_i] MATCHES "[a-z]"                                                                         
            OR g_rxy4[l_ac].rxy14[l_i] MATCHES "[A-Z]" THEN                                                                     
            LET g_errno = 'sub-219'
            RETURN 
         END IF                                                                                                             
      END FOR
   END IF
   IF NOT cl_null(g_rxy4[l_ac].rxy15) THEN
      IF l_lpx21 <> LENGTH(g_rxy4[l_ac].rxy15) THEN
         LET g_errno = 'sub-216'
         RETURN 
      END IF
      IF l_lpx23<>g_rxy4[l_ac].rxy15[1,l_lpx22] THEN
         LET g_errno = 'sub-215' 
         RETURN
      END IF
      FOR l_i = l_lpx22+1 TO l_lpx21                                                                          
         IF g_rxy4[l_ac].rxy15[l_i] MATCHES "[a-z]"                                                                         
            OR g_rxy4[l_ac].rxy15[l_i] MATCHES "[A-Z]" THEN                                                                     
            LET g_errno = 'sub-219'
            RETURN 
         END IF                                                                                                             
      END FOR
   END IF
   IF cl_null(g_rxy4[l_ac].rxy14) OR cl_null(g_rxy4[l_ac].rxy15) THEN
      RETURN
   END IF
   
   #計算券的起始編號(從右邊第一個字母或0開始計算)
   #LET l_location = 0                                                                                                     
   #FOR l_i = 1 TO LENGTH(g_rxy4[l_ac].rxy14)                                                                          
   #   IF g_rxy4[l_ac].rxy14[l_i] MATCHES "[a-z]"                                                                         
   #      OR g_rxy4[l_ac].rxy14[l_i] MATCHES "[A-Z]" THEN                                                                     
   #      LET l_location = l_i                                                                                            
   #   END IF                                                                                                             
   #END FOR
   #IF l_location = 0 THEN 
   #   LET l_location = 1 
   #ELSE
   #   LET l_location = l_location + 1
   #END IF                                                                       
   #FOR l_i=l_start TO l_end
   #    LET l_lqe01 = g_rxy4[l_ac].rxy14[1,l_location],l_i
   #END FOR    
   #LET l_start = g_rxy4[l_ac].rxy14[l_location,LENGTH(g_rxy4[l_ac].rxy14)]      
   #計算券的終止編號(從右邊第一個字母或0開始計算)                                          
   #LET l_location = 0                                                                                                     
   #FOR l_i = 1 TO LENGTH(g_rxy4[l_ac].rxy15)                                                                         
   #   IF g_rxy4[l_ac].rxy15[l_i] MATCHES "[a-z]"                                                                         
   #      OR g_rxy4[l_ac].rxy15[l_i] MATCHES "[A-Z]" THEN                                                                     
   #      LET l_location = l_i                                                                                            
   #   END IF                                                                                                             
   #END FOR
   #IF l_location = 0 THEN 
   #   LET l_location = 1 
   #ELSE
   #   LET l_location = l_location + 1  
   #END IF
   #LET l_end = g_rxy4[l_ac].rxy15[l_location,LENGTH(g_rxy4[l_ac].rxy15)]
   LET l_start = g_rxy4[l_ac].rxy14[l_lpx22+1,l_lpx21]
   LET l_end = g_rxy4[l_ac].rxy15[l_lpx22+1,l_lpx21]
   IF l_end - l_start < 0 THEN 
      LET g_errno = 'sub-193' 
      RETURN
   END IF
   LET g_rxy4[l_ac].rxy16 = l_end - l_start + 1
   LET l_flag =''
   FOR l_i = 1 TO l_lpx24
       LET l_flag = l_flag CLIPPED,'&' 
   END FOR 
   LET l_success ='Y'
   CALL s_showmsg_init()
   FOR l_i = l_start TO l_end
       LET l_flag1 = l_i USING l_flag 
       LET l_lqe01 = l_lpx23 CLIPPED,l_flag1 
       SELECT lqe02,lqe03,lqe17,lqe20,lqe21
         INTO l_lqe02,l_lqe03,l_lqe17,l_lqe20,l_lqe21
         FROM lqe_file
        WHERE lqe01 = l_lqe01
       IF SQLCA.SQLCODE THEN  
          CALL s_errmsg('lqe01',l_lqe01,'select lqe01',SQLCA.sqlcode,1)
          LET l_success ='N'
          LET l_lqe20 = NULL
          LET l_lqe21 = NULL
          CONTINUE FOR
       END IF
       IF l_lqe02<> g_rxy4[l_ac].rxy12 THEN 
          CALL s_errmsg('lqe01',l_lqe01,'select lqe02','sub-218',1)
          LET l_success ='N'
          CONTINUE FOR
       END IF 
       IF l_lqe03<> g_rxy4[l_ac].rxy13 THEN 
          CALL s_errmsg('lqe01',l_lqe01,'select lqe03','sub-217',1)
          LET g_rxy4[l_ac].rxy13 = NULL
          LET g_rxy4[l_ac].rxy13_desc = NULL
          LET l_success ='N'
          CONTINUE FOR
       END IF 
       IF l_lqe17<>'1' THEN 
          CALL s_errmsg('lqe01',l_lqe01,'select lqe17','alm-760',1)
          LET l_success ='N'
          CONTINUE FOR
       END IF 
      #IF (NOT cl_null(l_lqe20) AND l_lqe20 >= g_today) OR                     #TQC-C30085 mark
      #   (NOT cl_null(l_lqe21) AND l_lqe21 <= g_today) THEN #No.FUN-9C0074    #TQC-C30085 mark
       IF (NOT cl_null(l_lqe20) AND l_lqe20 > g_today) OR                      #TQC-C30085 add 
          (NOT cl_null(l_lqe21) AND l_lqe21 < g_today) THEN #No.FUN-9C0074     #TQC-C30085 add 
          CALL s_errmsg('lqe20,lqe21',l_lqe20,'select lqe20,lqe21','alm-393',1)
          LET l_success ='N'
          CONTINUE FOR
       END IF
   END FOR
   IF l_success = 'N' THEN
      LET g_success ='N'
      RETURN
   END IF
   #No.FUN-9B0157 ..end
END FUNCTION
#檢查交易單身中是否有折價，若有折價，不可使用可用于促銷的券
FUNCTION pay4_scale()
DEFINE l_sql         STRING
DEFINE l_lpx31       LIKE lpx_file.lpx31
DEFINE l_oeb47       LIKE oeb_file.oeb47
 
   LET g_errno = ''
   CASE g_type
      WHEN "01"
         LET l_sql = "SELECT oeb47 FROM oeb_file WHERE oeb01 = '",g_no,"'"
      WHEN "02"
         LET l_sql = "SELECT ogb47 FROM ogb_file WHERE ogb01 = '",g_no,"'"
      WHEN "03"
         LET l_sql = "SELECT ohb47 FROM ohb_file WHERE ohb01 = '",g_no,"'"
      WHEN "03"
   END CASE
   PREPARE pre_sel_oeb47 FROM l_sql
   DECLARE cur_oeb47 CURSOR FOR pre_sel_oeb47
 
   FOREACH cur_oeb47 INTO l_oeb47
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF l_oeb47 IS NULL THEN LET l_oeb47 = 0 END IF
      IF l_oeb47 > 0 THEN EXIT FOREACH END IF
   END FOREACH
 
   #有折價情況
   IF l_oeb47 > 0 THEN
      SELECT lpx31  INTO l_lpx31 FROM lpx_file 
          WHERE lpx01 = g_rxy4[l_ac].rxy12
      #可用于促銷
      IF l_lpx31 = 'N' THEN LET g_errno = 'sub-210' END IF   
   END IF
END FUNCTION
#檢查券類型是否存在、有效，并帶出名稱及有效日期
FUNCTION pay4_rxy12()
DEFINE l_lpxacti     LIKE lpx_file.lpxacti
DEFINE l_lpx15       LIKE lpx_file.lpx15
 
   #SELECT lpx02,lpx04,lpx15 INTO g_rxy4[l_ac].rxy12_desc,g_rxy4[l_ac].lpx04,l_lpx15 #No.FUN-9B0157
   SELECT lpx02,lpx15 INTO g_rxy4[l_ac].rxy12_desc,l_lpx15 #No.FUN-9B0157
      FROM lpx_file WHERE lpx01 = g_rxy4[l_ac].rxy12
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                  LET g_rxy4[l_ac].rxy12_desc = NULL
                                  LET g_rxy4[l_ac].lpx04 = NULL
        WHEN l_lpxacti='N' LET g_errno = '9028'
        WHEN l_lpx15<>'Y'  LET g_errno = 'sub-211'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT lpx28 INTO g_rxy4[l_ac].rxy13 FROM lpx_file #No.FUN-9B0157
       WHERE lpx01 = g_rxy4[l_ac].rxy12
      IF NOT cl_null(g_rxy4[l_ac].rxy13) THEN
         CALL cl_set_comp_entry('rxy13',FALSE)
         CALL pay4_rxy13()
      ELSE
         CALL cl_set_comp_entry('rxy13',TRUE)
      END IF
   END IF
END FUNCTION
FUNCTION pay4_b_fill()
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
  
    LET l_sql = "SELECT rxy02,rxy12,'','',rxy13,'',",
                "       rxy14,rxy15,rxy16,'',rxy05,rxy17 ",
                "  FROM rxy_file WHERE rxy00 = '",g_type,"' AND rxy03 = '04' ",
                "   AND rxy33 = 'N'", #FUN-CB0025
                "   AND rxy01 = '",g_no,"' AND rxyplant = '",g_org,"'"
    PREPARE pay4_pb FROM l_sql
    DECLARE pay4_curs CURSOR FOR pay4_pb
 
    CALL g_rxy4.clear()
    LET l_cnt = 1
    MESSAGE "Searching!"
    FOREACH pay4_curs INTO g_rxy4[l_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT lpx02,lpx04 INTO g_rxy4[l_cnt].rxy12_desc,g_rxy4[l_cnt].lpx04
           FROM lpx_file WHERE lpx01 = g_rxy4[l_cnt].rxy12
        SELECT lrz02 INTO g_rxy4[l_cnt].rxy13_desc FROM lrz_file
         WHERE lrz01 = g_rxy4[l_cnt].rxy13 AND lrz03 = 'Y'
        LET g_rxy4[l_cnt].total = g_rxy4[l_cnt].rxy16*g_rxy4[l_cnt].rxy13_desc
        IF g_rxy4[l_cnt].total IS NULL THEN LET g_rxy4[l_cnt].total = 0 END IF
        LET l_cnt = l_cnt + 1
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rxy4.deleteElement(l_cnt)
    MESSAGE ""
    LET g_rec_b = l_cnt-1
END FUNCTION
#---------------券結束------------------------------------
#-------------聯盟卡開始----------------------------------
FUNCTION pay_union()
DEFINE l_oha10       LIKE oha_file.oha10
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add

    IF g_type = "03" THEN
       SELECT oha10 INTO l_oha10 FROM oha_file WHERE oha01 = g_no
       IF g_flag <> 'N' AND l_oha10 IS NOT NULL THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    ELSE
       IF g_flag <> 'N' THEN     
          CALL cl_err('','sub-186',1)   
          RETURN       
       END IF
    END IF 
 
   #IF g_flag <> 'N' THEN
   #   CALL cl_err('','sub-186',1)
   #   RETURN
   # END IF
 
    OPEN WINDOW pay5_w AT 10,20 WITH FORM "sub/42f/s_pay5"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   #CALL cl_ui_init()             #TQC-AC0310
   #CALL cl_ui_locale("s_pay5_w") #TQC-AC0310 #TQC-AC0127  mark
    CALL cl_ui_locale("s_pay5") #TQC-AC0127  add
    
   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-261',g_lang) RETURNING l_string  #本次付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-260',g_lang) RETURNING l_string  #付款應付餘額
       CALL cl_set_comp_att_text("total",l_string)
    END IF
   #FUN-C30165 add END

    DISPLAY g_sum3 TO FORMONLY.total
    CALL pay5_bp_refresh()
    CALL pay5_menu()
    
    CLOSE WINDOW pay5_w  
END FUNCTION
FUNCTION pay5_menu()
 
    WHILE TRUE
        CALL pay5_bp("G")
        CASE g_action_choice
           WHEN "insert"
              LET g_action_choice="insert"
              IF cl_chk_act_auth() THEN
                 CALL pay5_a()
              END IF
 
           WHEN "exit"
              EXIT WHILE
 
           WHEN "controlg"
              CALL cl_cmdask()
 
        END CASE
   END WHILE  
   CLOSE WINDOW pay5_w
   CALL pay_show()  
END FUNCTION
FUNCTION pay5_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_rxz5 TO s_rxz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
       ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
    
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION pay5_a()
DEFINE l_rxy02    LIKE rxy_file.rxy02                                                                              
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_total2   LIKE rxz_file.rxz05
DEFINE l_rxw02    LIKE rxw_file.rxw02
DEFINE l_rxw03    LIKE rxw_file.rxw03
 
   LET g_rxy5.rxy05 = g_sum3
   LET g_rxy5.rxy06 = ''
   LET g_rxy5.rxy07 = ''
   LET g_rxy5.rxy08 = (g_rxy5.rxy05*g_rxy5.rxy07)/1000
   LET g_rxy5.rxy20 = 'N'
   LET g_rxy5.rxy12 = ''
   
   #查詢刷聯盟卡合計
   SELECT SUM(rxz05) INTO l_total2 FROM rxz_file 
       WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org AND rxz20 = '5'
   IF cl_null(l_total2) THEN LET l_total2 = 0 END IF
   DISPLAY l_total2 TO FORMONLY.total2
 
   DISPLAY g_sum3 TO FORMONLY.total      
   DISPLAY BY NAME g_rxy5.rxy05,g_rxy5.rxy06,g_rxy5.rxy07,
                   g_rxy5.rxy08,g_rxy5.rxy20,g_rxy5.rxy12
   CALL pay5_bp_refresh()
 
   INPUT BY NAME g_rxy5.rxy05,g_rxy5.rxy12,g_rxy5.rxy06,
                 g_rxy5.rxy20,g_rxy5.rxy07,g_rxy5.rxy08 
       WITHOUT DEFAULTS 
 
        BEFORE INPUT
           CALL cl_set_act_visible("accept,cancel", FALSE)       
           IF NOT cl_null(g_rxy5.rxy20) THEN                                                                              
              IF g_rxy5.rxy20 = 'Y' THEN                                                                                      
                 LET g_rxy5.rxy08 = 20                                                                                              
                 LET g_rxy5.rxy07 = ''                                                                                              
                 DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08                                                                
                 CALL cl_set_comp_entry("rxy07",FALSE)                                                                              
                 CALL cl_set_comp_entry("rxy08",TRUE)                                                                               
              ELSE                                                                                                                  
                 LET g_rxy5.rxy07 = 0                                                                                               
                 LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy08)/1000                                                     
                 DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08                                                                 
                 CALL cl_set_comp_entry("rxy07",TRUE)                                                   
                 CALL cl_set_comp_entry("rxy08",FALSE)                                                                              
              END IF                                                                                                                
           END IF       
                                                       
        AFTER FIELD rxy05                                                                                     
           IF g_rxy5.rxy05 <= 0 OR g_rxy5.rxy05 > g_sum3 THEN                                                              
              CALL cl_err('','sub-187',0)                                                                          
              NEXT FIELD rxy05                                                                                   
           END IF
           IF NOT cl_null(g_rxy5.rxy07) AND NOT cl_null(g_rxy5.rxy05) THEN                                     
              LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy05)/1000     
              DISPLAY BY NAME g_rxy5.rxy08                                                         
           END IF               
                                                                                                    
        AFTER FIELD rxy07 
           IF g_rxy5.rxy07 < 0 THEN
             #CALL cl_err('','sub-188',0)   #TQC-A10122 MARK
              CALL cl_err('','alm-352',0)   #TQC-A10122 ADD
              NEXT FIELD rxy07
           END IF
           IF NOT cl_null(g_rxy5.rxy07) AND NOT cl_null(g_rxy5.rxy05) THEN
              LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy05)/1000
              DISPLAY BY NAME g_rxy5.rxy08
           END IF    
 
        AFTER FIELD rxy08                                                                                                           
           IF NOT cl_null(g_rxy5.rxy08) THEN                                                                            
              IF g_rxy5.rxy08 < 0 THEN                                                                                              
                 CALL cl_err('','sub-195',0)                                                                                        
                 NEXT FIELD rxy08                                                                                                   
              END IF                                                                                                                
           END IF
 
        AFTER FIELD rxy12
           IF NOT cl_null(g_rxy5.rxy12) THEN
              SELECT rxw02,rxw03 INTO l_rxw02,l_rxw03 FROM rxw_file
                 WHERE rxw01 = g_rxy5.rxy12 AND rxwacti = 'Y'
              IF SQLCA.sqlcode=100 THEN
                 CALL cl_err('','sub-194',0)
                 NEXT FIELD rxy12
              END IF 
              CALL pay5_scale()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD rxy12
              END IF
              DISPLAY l_rxw02 TO FORMONLY.rxy12_desc
              LET g_rxy5.rxy07 = l_rxw03
              LET g_rxy5.rxy20 = 'N'
              LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy05)/1000
              DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy20,g_rxy5.rxy08
           END IF      
            
        AFTER FIELD rxy20
           IF NOT cl_null(g_rxy5.rxy20) THEN
              IF g_rxy5.rxy20 = 'Y' THEN
                 LET g_rxy5.rxy08 = 20
                 LET g_rxy5.rxy07 = ''
                 DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08
                 CALL cl_set_comp_entry("rxy07",FALSE)
                 CALL cl_set_comp_entry("rxy08",TRUE)
              ELSE
                 LET g_rxy5.rxy07 = 0  
                 LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy08)/1000                                                            
                 DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08
                 CALL cl_set_comp_entry("rxy07",TRUE)
                 CALL cl_set_comp_entry("rxy08",FALSE)
                 SELECT rxw03 INTO g_rxy5.rxy07 FROM rxw_file                                                             
                    WHERE rxw01 = g_rxy5.rxy12 AND rxwacti = 'Y'
                 LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy05)/1000                                                        
                 DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08
              END IF
           END IF
           
        ON CHANGE rxy20
          IF g_rxy5.rxy20 = 'Y' THEN
             LET g_rxy5.rxy08 = 20
             LET g_rxy5.rxy07 = ''                                                                                               
             DISPLAY BY NAME g_rxy5.rxy08,g_rxy5.rxy07                                                                           
             CALL cl_set_comp_entry("rxy07",FALSE)
             CALL cl_set_comp_entry("rxy08",TRUE)                                                                              
          ELSE                                
             LET g_rxy5.rxy07 = 0
             LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy08)/1000                                                                    
             DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08                                                                           
             CALL cl_set_comp_entry("rxy07",TRUE)
             CALL cl_set_comp_entry("rxy08",FALSE)
             SELECT rxw03 INTO g_rxy5.rxy07 FROM rxw_file                                                                 
                 WHERE rxw01 = g_rxy5.rxy12 AND rxwacti = 'Y'
             LET g_rxy5.rxy08 = (g_rxy5.rxy07*g_rxy5.rxy05)/1000
             DISPLAY BY NAME g_rxy5.rxy07,g_rxy5.rxy08
          END IF  
  
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxy12)
                 CALL cl_set_act_visible("accept,cancel",TRUE)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_rxw" 
                 LET g_qryparam.default1 = g_rxy5.rxy12
                 CALL cl_create_qry() RETURNING g_rxy5.rxy12
                 DISPLAY BY NAME g_rxy5.rxy12
                 CALL cl_set_act_visible("accept,cancel", FALSE) 
                 NEXT FIELD rxy12
           END CASE
                       
        ON ACTION controlg                                                                                  
           CALL cl_cmdask()
 
        ON ACTION auto_card
    
        ON ACTION hard_card
           ACCEPT INPUT 
 
        ON ACTION cancel_card 
           LET g_rxy5.rxy05 = ''
           LET g_rxy5.rxy06 = ''
           LET g_rxy5.rxy07 = ''
           LET g_rxy5.rxy08 = ''
           LET g_rxy5.rxy20 = ''
           DISPLAY BY NAME g_rxy5.rxy05,g_rxy5.rxy06,g_rxy5.rxy07,
                           g_rxy5.rxy08,g_rxy5.rxy20,g_rxy5.rxy12        
           LET INT_FLAG = 1    
           EXIT INPUT                                                                  
    END INPUT
                                                                             
    IF INT_FLAG THEN                                                                                                
       LET INT_FLAG = 0                                                                                           
       RETURN                                                                                                         
    END IF
    
    CALL pay5_insert()
    #聯盟卡刷卡合計                                                                                                               
    SELECT SUM(rxz05) INTO l_total2 FROM rxz_file                                                                             
        WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org AND rxz20 = '5'                                                                  
    IF cl_null(l_total2) THEN LET l_total2 = 0 END IF                                                                               
    DISPLAY l_total2 TO FORMONLY.total2
    CALL pay_show()
    DISPLAY g_sum3 TO FORMONLY.total      #應交款總額
END FUNCTION
#檢查交易單身中是否有折價，若有折價，不可使用可用于促銷的聯盟卡
FUNCTION pay5_scale()
DEFINE l_sql         STRING
DEFINE l_rxw06       LIKE rxw_file.rxw06
DEFINE l_ogb47       LIKE ogb_file.ogb47
 
   LET g_errno = ''
   
   CASE g_type
      WHEN "01"
         LET l_sql = "SELECT oeb47 FROM oeb_file WHERE oeb01 = '",g_no,"'"
      WHEN "02"
         LET l_sql = "SELECT ogb47 FROM ogb_file WHERE ogb01 = '",g_no,"'"
      WHEN "03"
         LET l_sql = "SELECT ohb47 FROM ohb_file WHERE ohb01 = '",g_no,"'"
      OTHERWISE RETURN
   END CASE
   PREPARE pre_sel_ogb47 FROM l_sql
   DECLARE cur_ogb47 CURSOR FOR pre_sel_ogb47
 
   FOREACH cur_ogb47 INTO l_ogb47
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF l_ogb47 IS NULL THEN LET l_ogb47 = 0 END IF
      IF l_ogb47 > 0 THEN EXIT FOREACH END IF
   END FOREACH
 
   #有折價情況
   IF l_ogb47 > 0 THEN
      SELECT rxw06 INTO l_rxw06 FROM rxw_file 
          WHERE rxw01 = g_rxy5.rxy12 AND rxwacti = 'Y'
      IF SQLCA.SQLCODE = 100 THEN LET g_errno = 'sub-213' RETURN END IF
      #可用于促銷  
      IF l_rxw06 = 'N' THEN LET g_errno = 'sub-212' END IF   
   END IF
END FUNCTION
#檢查券類型是否存在、有效，并帶出名稱及有效日期
FUNCTION pay5_insert()
DEFINE l_money_type    LIKE rxz_file.rxz02
DEFINE l_n             LIKE type_file.num5
DEFINE l_rxy02         LIKE rxy_file.rxy02
DEFINE l_rxz03         LIKE rxz_file.rxz03
DEFINE l_time          LIKE rxz_file.rxz07
DEFINE l_money         LIKE rxy_file.rxy08
DEFINE l_sql           STRING
 
   LET g_success = 'Y'
   LET l_time = TIME (CURRENT)
 
   IF g_type = '01' OR g_type = '02' OR 
      g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add  #FUN-CC0057 add  OR g_type = '23'
#     g_type = '05' OR g_type = '07' THEN
     #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
      g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
      LET l_money_type = '1'
   ELSE
      LET l_money_type = '-1'
   END IF
   
   BEGIN WORK
 
   SELECT COUNT(*) INTO l_n FROM rxx_file 
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '05' AND rxxplant = g_org
   IF l_n = 0 OR cl_null(l_n) THEN
      INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal) 
                VALUES(g_type,g_no,'05',l_money_type,g_rxy5.rxy05,0,g_org,g_legal2)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        ROLLBACK WORK          #TQC-B80023
         CALL cl_err3("ins","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK          #TQC-B80023
         RETURN
      END IF
   ELSE
      UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxy5.rxy05
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '05' AND rxxplant = g_org
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#        ROLLBACK WORK         #TQC-B80023
         CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK         #TQC-B80023
         RETURN
      END IF
   END IF
 
   #
   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
      WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
 
   IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
   LET l_rxy02 = l_rxy02 + 1
   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,
                        rxy07,rxy08,rxy12,rxy20,rxyplant,rxy21,rxy22,
                        rxylegal,rxy33)  #FUN-CB0025 Add rxy33
          VALUES(g_type,g_no,l_rxy02,'05',l_money_type,g_rxy5.rxy05,
                 g_rxy5.rxy06,g_rxy5.rxy07,g_rxy5.rxy08,g_rxy5.rxy12,
                 g_rxy5.rxy20,g_org,g_today,g_time1,g_legal2,'N') #FUN-CB0025
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     ROLLBACK WORK      #TQC-B80023
      CALL cl_err3("ins","rxy_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK      #TQC-B80023
      RETURN
   END IF
 
   #
   SELECT MAX(rxz03) INTO l_rxz03 FROM rxz_file
       WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org
   IF cl_null(l_rxz03) THEN LET l_rxz03 = 0 END IF                                                                                  
   LET l_rxz03 = l_rxz03 + 1                      
   INSERT INTO rxz_file(rxz00,rxz01,rxz02,rxz03,rxz04,rxz05,rxz06,
                        rxz07,rxz08,rxz09,rxz10,rxz15,rxz20,rxzplant,rxzlegal)
          VALUES(g_type,g_no,l_money_type,l_rxz03,g_rxy5.rxy06,g_rxy5.rxy05,
                 g_today,l_time,g_user,g_rxy5.rxy08,g_rxy5.rxy07,
                 g_rxy5.rxy20,'5',g_org,g_legal2)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     ROLLBACK WORK    #TQC-B80023
      CALL cl_err3("ins","rxz_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK    #TQC-B80023
      RETURN
   END IF
   COMMIT WORK
   #
   CALL pay5_bp_refresh()
   CALL pay_show()
END FUNCTION
FUNCTION pay5_bp_refresh()
DEFINE  l_cnt    LIKE type_file.num5
DEFINE  l_sql    STRING
 
   LET l_sql = "SELECT rxz03,rxz04,rxz05,rxz06,rxz07,rxz08,'',",
               "       rxz09,rxz10,rxz15 ",
               "  FROM rxz_file ",
               " WHERE rxz00 = '",g_type,"' AND rxz01 = '",g_no,
               "'  AND rxzplant = '",g_org,"' AND rxz20 = '5' ",
               " ORDER BY rxz03 "
   PREPARE pay5_pb FROM l_sql
   DECLARE rzx5_cs CURSOR FOR pay5_pb 
   
   CALL g_rxz5.clear()
   LET l_cnt = 1
 
   FOREACH rzx5_cs INTO g_rxz5[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gen02 INTO g_rxz5[l_cnt].rxz08_desc FROM gen_file
          WHERE gen01 = g_rxz5[l_cnt].rxz08
      
      LET l_cnt = l_cnt + 1
   END FOREACH
 
   CALL g_rxz5.deleteElement(l_cnt)
   LET g_rec_b = l_cnt-1
 
   DISPLAY ARRAY g_rxz5 TO s_rxz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
#-------------聯盟卡結束----------------------------------
#-------------儲值卡開始----------------------------------
FUNCTION pay_save()
DEFINE l_rxz04       LIKE rxz_file.rxz04
DEFINE l_rxz05       LIKE rxz_file.rxz05
#DEFINE l_lpt03       LIKE lpt_file.lpt03 #No.FUN-9B0157
#DEFINE l_lpt05       LIKE lpt_file.lpt05 #No.FUN-9B0157
DEFINE l_lpj02       LIKE lpj_file.lpj02 #No.FUN-9B0157
DEFINE l_lpj06       LIKE lpj_file.lpj06 #No.FUN-9B0157
DEFINE l_money_type  LIKE rxx_file.rxx03
DEFINE l_rxz03       LIKE rxz_file.rxz03
DEFINE l_rxy02       LIKE rxy_file.rxy02
DEFINE l_rxx04       LIKE rxx_file.rxx04
DEFINE l_lsn02       LIKE lsn_file.lsn02 #No.FUN-A70118
DEFINE l_lsn04       LIKE lsn_file.lsn04 #No.FUN-A70118
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add 
DEFINE l_n           LIKE type_file.num10 #FUN-C70045 add
   IF g_flag <> 'N' THEN
      CALL cl_err('','sub-186',1)
      RETURN
   END IF
 
   OPEN WINDOW pay9_w AT 10,20 WITH FORM "sub/42f/s_pay9"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
  #CALL cl_ui_init()             #TQC-AC0310
  #CALL cl_ui_locale("s_pay9_w") #TQC-AC0310  #TQC-AC0127  mark
   CALL cl_ui_locale("s_pay9") #TQC-AC0127  add

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-253',g_lang) RETURNING l_string  #儲值卡付款金額
       CALL cl_set_comp_att_text("rxz05",l_string)
       CALL cl_getmsg('sub-260',g_lang) RETURNING l_string  #付款應付餘額
       CALL cl_set_comp_att_text("total",l_string)
    END IF
   #FUN-C30165 add END
 
   DISPLAY g_sum3 TO FORMONLY.total
 
   INPUT l_rxz04,l_rxz05 WITHOUT DEFAULTS FROM rxz04,rxz05
      AFTER FIELD rxz04
         IF NOT cl_null(l_rxz04) THEN
            #CALL pay9_rxz04(l_rxz04) RETURNING l_lpt03,l_lpt05 #No.FUN-9B0157
            CALL pay9_rxz04(l_rxz04) RETURNING l_lpj02,l_lpj06  #No.FUN-9B0157
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_rxz04,g_errno,1)
               NEXT FIELD rxz04
            END IF
         END IF
 
      AFTER FIELD rxz05
         IF NOT cl_null(l_rxz05) THEN
            IF l_rxz05 < 0 THEN
               CALL cl_err('rxz05','alm-192',1)
               NEXT FIELD rxz05
            END IF
           IF g_type <> '06'  THEN  # TQC-B10042        
            IF l_rxz05 > l_lpj06 THEN  #No.FUN-9B0157 lpt03->lpj06
               CALL cl_err('rxz05','alm-289',1)
               NEXT FIELD rxz05
            END IF
           END IF    # TQC-B10042
            IF l_rxz05 > g_sum3 THEN
               CALL cl_err(l_rxz05,'sub-187',0)
               NEXT FIELD rxz05
            END IF
         END IF
 
      ON ACTION controlg
           CALL cl_cmdask() 
 
      AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW pay9_w
      CALL pay_show() 
      RETURN
   END IF
   IF g_type = '01' OR g_type = '02' OR  
      g_type = '21' OR g_type = '20' OR  g_type = '23' OR        #FUN-C90085 add  #FUN-CC0057 add g_type = '23' OR 
#     g_type = '05' OR g_type = '07' THEN
     #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
      g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
       LET l_money_type = 1
    ELSE
       LET l_money_type = -1
    END IF
 
    IF cl_null(l_rxz04) OR cl_null(l_rxz05) THEN
       CLOSE WINDOW pay9_w
       CALL pay_show() 
       RETURN
    END IF
 
    BEGIN WORK
    SELECT MAX(rxz03) INTO l_rxz03 FROM rxz_file
       WHERE rxz00 = g_type AND rxz01 = g_no AND rxzplant = g_org
    IF l_rxz03 IS NULL THEN LET l_rxz03=0 END IF
    LET l_rxz03=l_rxz03 + 1
    INSERT INTO rxz_file(rxz00,rxz01,rxz02,rxz03,rxz04,rxz05,rxz06,rxz07,rxz08,
                        rxz20,rxzplant,rxzlegal)
       VALUES(g_type,g_no,l_money_type,l_rxz03,l_rxz04,l_rxz05,g_today,g_time1,g_user,
              '6',g_org,g_legal2)
   
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('ins rxz_file',SQLCA.sqlcode,1) 
      ROLLBACK WORK
      CLOSE WINDOW pay9_w
      RETURN
   END IF
 
   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00 = g_type
        AND rxy01 = g_no AND rxyplant = g_org
   IF l_rxy02 IS NULL THEN LET l_rxy02=0 END IF
   LET l_rxy02=l_rxy02+1
   
   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,
                        rxy12,rxyplant,rxy21,rxy22,rxylegal,rxy33) #FUN-CB0025 Add rxy33
        VALUES(g_type,g_no,l_rxy02,'06',l_money_type,l_rxz05,l_rxz04,
               l_lpj02,g_org,g_today,g_time1,g_legal2,'N')#No.FUN-9B0157 lpt05->lpj02 #FUN-CB0025
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('ins rxy_file',SQLCA.sqlcode,1) 
      ROLLBACK WORK
      CLOSE WINDOW pay9_w
      RETURN
   END IF
 
   #No.FUN-9B0157 ..begin
   IF l_money_type = 1 THEN
      #UPDATE lpt_file SET lpt03 = l_lpt03 + l_rxz05 WHERE lpt02 = l_rxz04
      #UPDATE lpj_file SET lpj06 = l_lpt03 + l_rxz05 WHERE lpj03 = l_rxz04
      UPDATE lpj_file SET lpj06 = l_lpj06 - l_rxz05,
                          lpjpos = '2'    #FUN-D30007 add
      #FUN-C90085---mark--str
      #                   lpj08 = g_today,
      #                   lpj07 = COALESCE(lpj07,0)+1,
      #                   lpj15 = COALESCE(lpj15,0)+l_rxz05
      #FUN-C90085---mark--end
       WHERE lpj03 = l_rxz04 
   ELSE
      #UPDATE lpt_file SET lpt03 = l_lpt03 - l_rxz05 WHERE lpt02 = l_rxz04
      #UPDATE lpj_file SET lpj06 = l_lpt03 - l_rxz05 WHERE lpj03 = l_rxz04
      UPDATE lpj_file SET lpj06 = l_lpj06 + l_rxz05,
                          lpjpos = '2'        #FUN-D30007 add 
      #FUN-C90085---mark--str
      #                   lpj08 = g_today,
      #                   lpj07 = COALESCE(lpj07,0)+1,
      #                   lpj15 = COALESCE(lpj15,0)-l_rxz05
      #FUN-C90085---mark--end
       WHERE lpj03 = l_rxz04 
   END IF
   #No.FUN-9B0157 ..end
 
   IF SQLCA.sqlcode THEN 
      CALL cl_err('upd lpt_file',SQLCA.sqlcode,1) 
      ROLLBACK WORK
      CLOSE WINDOW pay9_w
      RETURN
   END IF

  #No.FUN-A70118 -BEGIN-----
   IF l_money_type = 1 THEN
      LET l_lsn04 = 0 - l_rxz05
   ELSE
      LET l_lsn04 = l_rxz05
   END IF
   CASE g_type
      WHEN '01' LET l_lsn02 = '6'
      WHEN '02' LET l_lsn02 = '7'
      WHEN '03' LET l_lsn02 = '8'
      WHEN '04' LET l_lsn02 = '9'
#FUN-C70045 mark begin  ---
#     WHEN '05' LET l_lsn02 = 'A' 
#     WHEN '06' LET l_lsn02 = 'B'
#     WHEN '07' LET l_lsn02 = 'C'
#     WHEN '08' LET l_lsn02 = 'D'
#FUN-C70045 mark end ----
#FUN-C70045 add begin ---
      WHEN '05' LET l_lsn02 = 'C'
      WHEN '06' LET l_lsn02 = 'D'
      WHEN '07' LET l_lsn02 = 'A'
      WHEN '08' LET l_lsn02 = 'B'
#FUN-C70045 add end ----
      OTHERWISE LET l_lsn02 = g_type
   END CASE
  #INSERT INTO lsn_file(lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn08)  #FUN-BA0068 mark
  #   #          VALUES(l_rxz04,l_lsn02,g_no,l_rxz05,g_today,'',100,g_org)  #FUN-BA0068 mark
#FUN-B#0068 add START
#FUN-C#0045 add begin ---
   SELECT COUNT(*) INTO l_n
     FROM lsn_file 
    WHERE lsn01 = l_rxz04
      AND lsn02 = l_lsn02
      AND lsn03 = g_no
   IF l_n > 0 THEN
      UPDATE lsn_file SET lsn04 = lsn04 + l_lsn04,
                          lsn05 = g_today
       WHERE lsn01 = l_rxz04
         AND lsn02 = l_lsn02
         AND lsn03 = g_no
        #AND lsnplant = g_org  #FUN-C90102 mark 
         AND lsnstore = g_org  #FUN-C90102 add
         AND lsn10 = '1'
   ELSE
#FUN-C70045 add end ----
     #INSERT INTO lsn_file(lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsnlegal,lsnplant,lsn10)               #FUN-C70045 add lsn10  #FUN-C90102 mark 
      INSERT INTO lsn_file(lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsnlegal,lsnstore,lsn10)               #FUN-C90102 add
                   #VALUES(l_rxz04,l_lsn02,g_no,l_rxz05,g_today,'',100,g_legal2,g_org)  #FUN-C40018 mark
                   #VALUES(l_rxz04,l_lsn02,g_no,l_lsn04,g_today,'',100,g_legal2,g_org)  #FUN-C40018 add     #FUN-C70045 mark
                    VALUES(l_rxz04,l_lsn02,g_no,l_lsn04,g_today,'',100,g_legal2,g_org,'1')                  #FUN-C70045 add
   END IF           #FUN-C70045 add
#FUN-BA0068 add END
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins lsn_file',SQLCA.sqlcode,1)
      ROLLBACK WORK
      CLOSE WINDOW pay9_w
      RETURN
   END IF
  #No.FUN-A70118 -END-------
 
   SELECT rxx04 INTO l_rxx04 FROM rxx_file
       WHERE rxx00 = g_type AND rxx01 = g_no 
         AND rxx02 = '06' AND rxxplant = g_org
   IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
 
   IF SQLCA.sqlcode = 100 THEN
      INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
          VALUES(g_type,g_no,'06',l_money_type,l_rxz05,0,g_org,g_legal2)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                     
         CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)                                                                          
         ROLLBACK WORK    
         CLOSE WINDOW pay9_w                                                                                                 
         RETURN                                                                                                        
      END IF
   ELSE
      UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + l_rxz05
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '06' 
            AND rxxplant = g_org
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('UPD rxx_file',SQLCA.sqlcode,1)
         ROLLBACK WORK
         CLOSE WINDOW pay9_w
         RETURN
      END IF
   END IF
 
   COMMIT WORK
   CLOSE WINDOW pay9_w
   CALL pay_show() 
END FUNCTION
#No.FUN-9B0157 ..begin
#市场储值卡表结构改变,现都判断卡状态表lpj_file
FUNCTION pay9_rxz04(p_cardno)
DEFINE p_cardno  LIKE rxz_file.rxz04
#DEFINE l_lpt03   LIKE lpt_file.lpt03  
#DEFINE l_lpt14   LIKE lpt_file.lpt14  
#DEFINE l_lpt05   LIKE lpt_file.lpt05
#DEFINE l_lps09   LIKE lps_file.lps09
DEFINE l_lpj02   LIKE lpj_file.lpj02  
DEFINE l_lpj05   LIKE lpj_file.lpj05  
DEFINE l_lpj06   LIKE lpj_file.lpj06 
DEFINE l_lpj09   LIKE lpj_file.lpj09
DEFINE l_lpj16   LIKE lpj_file.lpj16
#DEFINE l_lph03   LIKE lph_file.lph03
 
   LET g_errno=''
   SELECT lpj02,lpj05,lpj06,lpj09,lpj16
     INTO l_lpj02,l_lpj05,l_lpj06,l_lpj09,l_lpj16
     FROM lpj_file
    WHERE lpj03=p_cardno
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'
                               LET l_lpj02 = NULL
                               LET l_lpj05 = NULL
                               LET l_lpj06 = NULL    
        WHEN l_lpj09 != '2'    LET g_errno = 'alm-818'
        WHEN l_lpj16 != 'Y'    LET g_errno = 'sub-209'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(l_lpj05) THEN 
      IF l_lpj05 < g_today THEN   
         LET g_errno = 'alm-217'
      END IF
   END IF
   
   #SELECT lpt03,lpt14,lpt05,lps09  #No.FUN-9B0157
   #   INTO l_lpt03,l_lpt14,l_lpt05,l_lps09  
   #   FROM lpt_file,lps_file
   #  WHERE lpt02 = p_cardno
   #    AND lps01 = lpt01
 
   #CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'
   #                            LET l_lpt03 = NULL
   #                            LET l_lpt14 = NULL    #No.FUN-9B0157
   #                            LET l_lpt05 = NULL
   #     WHEN l_lps09 != 'Y'    LET g_errno = '9029'
   #     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   #END CASE
 
   #IF cl_null(g_errno) AND NOT cl_null(l_lpt14) THEN  
   #   IF l_lpt14 < g_today THEN   #No.FUN-9B0157
   #      LET g_errno = 'alm-211'
   #   END IF
   #END IF
   
   #IF cl_null(g_errno) THEN
   #   SELECT lph03 INTO l_lph03 FROM lph_file WHERE lph01 = l_lpt05
   #   IF SQLCA.sqlcode THEN
   #      LET g_errno = SQLCA.sqlcode
   #   ELSE
   #      IF l_lph03 <> '1' THEN LET g_errno = 'sub-209' END IF
   #   END IF
   #END IF
 
   #IF cl_null(g_errno) THEN                                                                                                         
   #   DISPLAY l_lpt03 TO FORMONLY.lpt03                                                                                             
   #ELSE                                                                                                                             
   #   LET l_lpt03 = NULL                                                                                                            
   #END IF       
   IF cl_null(g_errno) THEN                                                                                                         
      IF cl_null(l_lpj06) THEN LET l_lpj06=0 END IF
      DISPLAY l_lpj06 TO FORMONLY.lpj06                                                                                             
   ELSE                                                                                                                             
      LET l_lpj06 = NULL                                                                                                            
   END IF       
                                                                                                                    
   #RETURN l_lpt03,l_lpt05
   RETURN l_lpj02,l_lpj06
END FUNCTION
#No.FUN-9B0157 ..end
#---------------儲值卡結束------------------------------------
#---------------衝預收開始-------------------------------------
FUNCTION pay_get()
DEFINE cb   ui.ComboBox
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add

   IF g_flag <> 'N' THEN
      CALL cl_err('','sub-186',1)
      RETURN
   END IF
   
   OPEN WINDOW pay7_w AT 10,20 WITH FORM "sub/42f/s_pay7"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_init()             #TQC-AC0310
   #CALL cl_ui_locale("s_pay7_w") #TQC-AC0310 #TQC-AC0127  mark
    CALL cl_ui_locale("s_pay7") #TQC-AC0127   ADD 
    CALL cl_set_comp_visible("rxy02",FALSE)
   #FUN-BB0117 Add Begin ---

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-262',g_lang) RETURNING l_string  #付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-266',g_lang) RETURNING l_string  #沖預付款單號
       CALL cl_set_comp_att_text("rxy06",l_string)
       CALL cl_getmsg('sub-267',g_lang) RETURNING l_string  #沖預付款類型
       CALL cl_set_comp_att_text("rxy19",l_string)
       CALL cl_getmsg('sub-268',g_lang) RETURNING l_string  #暫付款
       CALL cl_set_comp_att_text("rxy19_2",l_string)
    END IF
   #FUN-C30165 add END

   IF g_prog = 'artt610' OR g_prog = 'artt611' THEN
      CALL cl_set_comp_visible("rxy32,lul05,oaj02",TRUE)
      CALL cl_set_comp_entry("rxy19",FALSE)
   ELSE
      CALL cl_set_comp_visible("rxy32,lul05,oaj02",FALSE)
      CALL cl_set_comp_entry("rxy19",TRUE)
      LET cb = ui.ComboBox.forName("rxy19")
      CALL cb.removeItem('3')
   END IF
   #FUN-BB0117 Add End -----
    CALL pay7_b_fill()
    CALL pay7_menu()
    CLOSE WINDOW pay7_w 
    CALL pay_show()
END FUNCTION
FUNCTION pay7_menu()
 
    CALL pay7_b_fill()
    CALL pay7_b()
 
    WHILE TRUE
        CALL pay7_bp("G")
        CASE g_action_choice
           WHEN "detail"
              LET g_action_choice="detail"
              CALL pay7_b()
 
           WHEN "exit"
              EXIT WHILE
 
           WHEN "controlg"
              CALL cl_cmdask()
 
        END CASE
   END WHILE  
   CALL pay_show()  
END FUNCTION
FUNCTION pay7_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
 
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_rxy7 TO s_rxy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
 
       ON ACTION detail
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DISPLAY
       
       ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION pay7_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1,
    l_sql           STRING,
    l_money_type    LIKE rxz_file.rxz02,
    l_rxy05         LIKE rxy_file.rxy05,
    l_oga03         LIKE oga_file.oga03
DEFINE l_lul07      LIKE lul_file.lul07 #FUN-BB0117 Add
DEFINE l_rxy33      LIKE rxy_file.rxy33 #FUN-CB0025
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #LET l_sql = "SELECT rxy02,rxy19,rxy06,'','','',rxy05 FROM rxy_file",             #FUN-BB0117 Mark
    LET l_sql = "SELECT rxy02,rxy19,rxy06,rxy03,rxy32,'','','','','',rxy05 FROM rxy_file", #FUN-BB0117 Add #FUN-CB0025 Add rxy03
                " WHERE rxy00='",g_type,"' AND rxy01= '",g_no,
                "' AND rxyplant = '",g_org,"' AND rxy02 = ? ",
                " FOR UPDATE "
    LET l_sql = cl_forupd_sql(l_sql)  #No.TQC-9B0025
    DECLARE pay7_bcl CURSOR FROM l_sql      # LOCK CURSOR
 
    INPUT ARRAY g_rxy7 WITHOUT DEFAULTS FROM s_rxy.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
      
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           IF g_prog = 'artt610' OR g_prog = 'artt611' THEN
              CALL cl_set_comp_entry("rxy19",FALSE)
              LET g_rxy7[l_ac].rxy03 = '07'          #FUN-CB0025
              DISPLAY BY NAME g_rxy7[l_ac].rxy03     #FUN-CB0025
              CALL cl_set_comp_entry("rxy03",FALSE)  #FUN-CB0025
           ELSE
              CALL cl_set_comp_entry("rxy19",TRUE)
           END IF
           IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_rxy7_t.* = g_rxy7[l_ac].*
 
              OPEN pay7_bcl USING g_rxy7_t.rxy02 
              IF STATUS THEN
                 CALL cl_err("OPEN pay7_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE 
                 FETCH pay7_bcl INTO g_rxy7[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxy7_t.rxy02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL pay7_money()
              LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 - g_rxy7[l_ac].rxy05
              LET g_rxy7[l_ac].sum3 = g_rxy7[l_ac].sum3 + g_rxy7[l_ac].rxy05
             #FUN-BB0117 Add Begin ---
              SELECT lul05 INTO g_rxy7[l_ac].lul05
                FROM lul_file
               WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
              IF NOT cl_null(g_rxy7[l_ac].lul05) THEN
                 SELECT oaj02 INTO g_rxy7[l_ac].oaj02
                   FROM oaj_file
                  WHERE oaj01 = g_rxy7[l_ac].lul05
              END IF
             #FUN-BB0117 Add End -----
              CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxy7[l_ac].* TO NULL
           LET g_rxy7_t.* = g_rxy7[l_ac].*
           CALL cl_show_fld_cont()
           SELECT MAX(rxy02) INTO g_rxy7[l_ac].rxy02 FROM rxy_file                                                        
               WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org                                         
           IF cl_null(g_rxy7[l_ac].rxy02) THEN                                                                           
              LET g_rxy7[l_ac].rxy02 = 0                                                                                   
           END IF                                                                                               
           LET g_rxy7[l_ac].rxy02 = g_rxy7[l_ac].rxy02 + 1
          #FUN-BB0117 Add Begin ---
           IF g_prog = 'artt610' OR g_prog = 'artt611' THEN
              LET g_rxy7[l_ac].rxy19 = '3'
              LET g_rxy7[l_ac].rxy03 = '07'          #FUN-CB0025
              DISPLAY BY NAME g_rxy7[l_ac].rxy03     #FUN-CB0025
              CALL cl_set_comp_entry("rxy03",FALSE)  #FUN-CB0025
           ELSE
          #FUN-BB0117 Add End -----
              LET g_rxy7[l_ac].rxy19 = '1'
           END IF #FUN-BB0117 Add
           NEXT FIELD rxy19
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF g_type = '01' OR g_type = '02' OR 
              g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add   #FUN-CC0057 add g_type = '23' OR 
#             g_type = '05' OR g_type = '07' THEN
             #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
              g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
              LET l_money_type = '1'
           ELSE
              LET l_money_type = '-1'
           END IF
          #FUN-CB0025 Begin---
           IF g_rxy7[l_ac].rxy19 = '1' THEN
              LET l_rxy33 = 'Y'
           ELSE
              LET l_rxy33 = 'N'
           END IF
          #FUN-CB0025 End-----
           INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,
                                rxy06,rxy19,rxyplant,rxy21,rxy22,rxylegal,rxy32,rxy33) #FUN-BB0117 Add rxy32 #FUN-CB0025 Add rxy33
                      #VALUES(g_type,g_no,g_rxy7[l_ac].rxy02,'07',l_money_type,               #FUN-CB0025
                       VALUES(g_type,g_no,g_rxy7[l_ac].rxy02,g_rxy7[l_ac].rxy03,l_money_type, #FUN-CB0025
                              g_rxy7[l_ac].rxy05,g_rxy7[l_ac].rxy06,
                              g_rxy7[l_ac].rxy19,g_org,g_today,g_time1,g_legal2,g_rxy7[l_ac].rxy32,l_rxy33) #FUN-BB0117 Add g_rxy7[l_ac].rxy32 #FUN-CB0025
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","rxy_file",g_rxy7[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
            #FUN-BB0117 Add Begin ---
            #更新待抵單信息
             IF g_rxy7[l_ac].rxy19 = '3' THEN
                UPDATE lul_file SET lul07 = COALESCE(lul07,0) + g_rxy7[l_ac].rxy05
                 WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                   CALL cl_err3("upd","lul_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = g_rxy7[l_ac].rxy06
                   IF cl_null(l_lul07) THEN LET l_lul07 = 0 END IF
                   UPDATE luk_file SET luk11 = l_lul07 WHERE luk01 = g_rxy7[l_ac].rxy06
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                      CALL cl_err3("upd","luk_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                      CANCEL INSERT
                   END IF
                END IF
             END IF
            #FUN-BB0117 Add End -----
          END IF
          SELECT COUNT(*) INTO l_n FROM rxx_file 
           WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '07' AND rxxplant = g_org
             AND rxx03 = '1'
          IF cl_null(l_n) OR l_n = 0 THEN
             INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,
                                  rxx11,rxxplant,rxxlegal)
                           VALUES(g_type,g_no,'07',l_money_type,
                                  g_rxy7[l_ac].rxy05,0,NULL,g_org,
                                  g_legal2)
          ELSE
             UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxy7[l_ac].rxy05
              WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '07' 
                AND rxxplant = g_org AND rxx03 = '1'
          END IF
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("ins","rxy_file",g_rxy7[l_ac].rxy02,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          END IF
          CALL pay_show()
 
       ON CHANGE rxy19
          LET g_rxy7[l_ac].rxy06 = ''
          LET g_rxy7[l_ac].rxy05 = ''
          LET g_rxy7[l_ac].sum1 = ''
          LET g_rxy7[l_ac].sum2 = ''
          LET g_rxy7[l_ac].sum3 = ''
         #FUN-CB0025 Begin---
          IF g_rxy7[l_ac].rxy19 = '1' THEN
             CALL cl_set_comp_entry("rxy03",TRUE)
          ELSE
             CALL cl_set_comp_entry("rxy03",FALSE)
             LET g_rxy7[l_ac].rxy03 = '07'
             DISPLAY BY NAME g_rxy7[l_ac].rxy03
          END IF

       AFTER FIELD rxy03
          IF NOT cl_null(g_rxy7[l_ac].rxy03) AND g_rxy7[l_ac].rxy19 = '1' AND NOT cl_null(g_rxy7[l_ac].rxy06) THEN
             IF g_rxy7_t.rxy03 IS NULL OR
                (g_rxy7[l_ac].rxy03 <> g_rxy7_t.rxy03) THEN
                CALL pay7_rxy06()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rxy06
                END IF
                CALL pay7_money()
                CALL pay7_rxy05(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rxy06
                END IF
             END IF
          END IF
         #FUN-CB0025 End-----

       AFTER FIELD rxy06
         #IF NOT cl_null(g_rxy7[l_ac].rxy06) THEN #FUN-CB0025
          IF NOT cl_null(g_rxy7[l_ac].rxy06) AND NOT cl_null(g_rxy7[l_ac].rxy03) THEN #FUN-CB0025
             IF g_rxy7_t.rxy06 IS NULL OR 
                (g_rxy7[l_ac].rxy06 != g_rxy7_t.rxy06 ) THEN
                CALL pay7_rxy06()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rxy06
                END IF
               #FUN-BB0117 Add Begin ---
                IF g_rxy7[l_ac].rxy19 = '3' THEN
                   CALL pay7_rxy32()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_rxy7[l_ac].rxy32 = g_rxy7_t.rxy32
                      NEXT FIELD rxy06
                   END IF
                END IF
               #FUN-BB0117 Add End -----
                
                CALL pay7_money()
               #CALL pay7_rxy05()      #FUN-BB0117 Mark
                CALL pay7_rxy05(p_cmd) #FUN-BB0117 Add 
                IF NOT cl_null(g_errno) THEN                                                                
                   CALL cl_err('',g_errno,0)                                                             
                   NEXT FIELD rxy06                                                                                         
                END IF
             END IF
          END IF

      #FUN-BB0117 Add Begin ---
       AFTER FIELD rxy32
          IF NOT cl_null(g_rxy7[l_ac].rxy32) THEN
             IF g_rxy7_t.rxy32 IS NULL OR
                (g_rxy7[l_ac].rxy32 != g_rxy7_t.rxy32) THEN
                IF NOT cl_null(g_rxy7[l_ac].rxy06) THEN
                   CALL pay7_rxy32()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_rxy7[l_ac].rxy32 = g_rxy7_t.rxy32
                      NEXT FIELD rxy32
                   END IF
                   CALL pay7_money()
                END IF
             END IF
          END IF
      #FUN-BB0117 Add End -----
 
       AFTER FIELD rxy19
          IF NOT cl_null(g_rxy7[l_ac].rxy19) THEN 
             IF g_rxy7_t.rxy19 IS NULL OR
                (g_rxy7[l_ac].rxy19 != g_rxy7_t.rxy19 ) THEN
                CALL pay7_rxy06()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rxy19
                END IF
                CALL pay7_money()
             END IF
          END IF
          
       AFTER FIELD rxy05
          IF NOT cl_null(g_rxy7[l_ac].rxy05) THEN
             IF g_rxy7_t.rxy05 IS NULL OR
                (g_rxy7[l_ac].rxy05 != g_rxy7_t.rxy05 ) THEN
                IF g_rxy7[l_ac].rxy05 <= 0 THEN
                   CALL cl_err('','sub-187',0)
                   NEXT FIELD rxy05
                END IF
               #CALL pay7_rxy05()      #FUN-BB0117 Mark
                CALL pay7_rxy05(p_cmd) #FUN-BB0117 Add
                IF NOT cl_null(g_errno) THEN                                                                             
                   CALL cl_err('',g_errno,0)                                                                            
                   NEXT FIELD rxy05                                                                                        
                END IF
             END IF
          END IF
 
 
       BEFORE DELETE
            IF g_rxy7_t.rxy02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM rxy_file WHERE rxy00 = g_type AND rxy01 = g_no
                    AND rxyplant = g_org AND rxy02 = g_rxy7_t.rxy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rxy_file",g_rxy7_t.rxy02,"",SQLCA.sqlcode,"","",1)
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                #
                IF g_rxy7_t.rxy05 IS NULL THEN LET g_rxy7_t.rxy05 = 0 END IF
 
               #FUN-BB0117 Add Begin ---
               #更新待抵單信息
                IF g_rxy7[l_ac].rxy19 = '3' THEN
                   UPDATE lul_file SET lul07 = COALESCE(lul07,0) - g_rxy7_t.rxy05
                    WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                      CALL cl_err3("upd","lul_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                      CANCEL DELETE
                   ELSE
                      SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = g_rxy7[l_ac].rxy06
                      IF cl_null(l_lul07) THEN LET l_lul07 = 0 END IF
                      UPDATE luk_file SET luk11 = l_lul07 WHERE luk01 = g_rxy7[l_ac].rxy06
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                         CALL cl_err3("upd","luk_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                         CANCEL DELETE
                      END IF
                   END IF
                END IF
               #FUN-BB0117 Add End -----

                UPDATE rxx_file SET rxx04 = rxx04 - g_rxy7_t.rxy05
                   WHERE rxx00 = g_type AND rxx01 = g_no 
                     AND rxxplant = g_org AND rxx03 = '1' 
                     AND rxx02 = '07'
                IF SQLCA.sqlcode THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_rxy7[l_ac] TO NULL
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rxy7[l_ac].* = g_rxy7_t.*
            CLOSE pay7_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_rxy7[l_ac].rxy02,-263,0)
            LET g_rxy7[l_ac].* = g_rxy7_t.*
         ELSE
           #FUN-CB0025 Begin---
           IF g_rxy7[l_ac].rxy19 = '1' THEN
              LET l_rxy33 = 'Y'
           ELSE
              LET l_rxy33 = 'N'
           END IF
          #FUN-CB0025 End-----
            UPDATE rxy_file SET rxy06=g_rxy7[l_ac].rxy06,
                                rxy03=g_rxy7[l_ac].rxy03, #FUN-CB0025
                                rxy33=l_rxy33,            #FUN-CB0025
                                rxy19=g_rxy7[l_ac].rxy19,
                                rxy32=g_rxy7[l_ac].rxy32, #FUN-BB0117 Add
                                rxy05=g_rxy7[l_ac].rxy05
                WHERE rxy00 = g_type AND rxy01 = g_no 
                  AND rxy02 = g_rxy7_t.rxy02 AND rxyplant = g_org
                   
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","rxy_file",g_rxy7_t.rxy02,"",SQLCA.sqlcode,"","",1)  
               LET g_rxy7[l_ac].* = g_rxy7_t.*
            ELSE
               LET l_rxy05 = g_rxy7[l_ac].rxy05 - g_rxy7_t.rxy05
               IF l_rxy05 IS NULL THEN LET l_rxy05 = 0 END IF
              #FUN-BB0117 Add Begin ---
              #更新待抵單信息 
               IF g_rxy7[l_ac].rxy19 = '3' THEN
                  UPDATE lul_file SET lul07 = COALESCE(lul07,0) + l_rxy05
                   WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                     CALL cl_err3("upd","lul_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     RETURN
                  ELSE
                     SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = g_rxy7[l_ac].rxy06
                     IF cl_null(l_lul07) THEN LET l_lul07 = 0 END IF
                     UPDATE luk_file SET luk11 = l_lul07 WHERE luk01 = g_rxy7[l_ac].rxy06
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        CALL cl_err3("upd","luk_file",g_rxy7[l_ac].rxy06,"",SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        RETURN
                     END IF
                  END IF
               END IF
              #FUN-BB0117 Add End -----
               UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + l_rxy05
                  WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '07' 
                    AND rxxplant = g_org AND rxx03 = '1'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  RETURN
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL pay_show()
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_rxy7[l_ac].* = g_rxy7_t.*
            END IF
            CLOSE pay7_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE pay7_bcl
         COMMIT WORK
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(rxy06)
               CALL cl_init_qry_var()
             #FUN-CB0025 Begin---
             # IF g_rxy7[l_ac].rxy19 = '1' THEN
             #    LET g_qryparam.form = "q_ogb31_2"
             #    LET g_qryparam.arg1 = g_no
             ##ELSE #FUN-BB0117 Mark
             # END IF #FUN-BB0117 Add
               IF g_rxy7[l_ac].rxy19 = '1' THEN
                  LET g_qryparam.form = "q_ogb31_2"
                  LET g_qryparam.arg1 = g_no
                  LET g_qryparam.default1 = g_rxy7[l_ac].rxy06
                  LET g_qryparam.default2 = g_rxy7[l_ac].rxy03
                  CALL cl_create_qry() RETURNING g_rxy7[l_ac].rxy06,g_rxy7[l_ac].rxy03
                  DISPLAY BY NAME g_rxy7[l_ac].rxy06,g_rxy7[l_ac].rxy03
                  CALL pay7_money()
                  NEXT FIELD rxy06
               END IF
             #FUN-CB0025 End-----
               IF g_rxy7[l_ac].rxy19 = '2' THEN #FUN-BB0117 Add
                  SELECT oga03 INTO l_oga03 FROM oga_file WHERE oga01 = g_no
                  LET g_qryparam.form = "q_ogb31_1"
                  LET g_qryparam.arg1 = l_oga03
               END IF
              #FUN-BB0117 Add Begin ---
               IF g_rxy7[l_ac].rxy19 = '3' THEN
                  LET g_qryparam.form = "q_lul01"
                  CALL pay7_rxy06_get_where()
                  CALL cl_create_qry() RETURNING g_rxy7[l_ac].rxy06,g_rxy7[l_ac].rxy32
                  DISPLAY BY NAME g_rxy7[l_ac].rxy06,g_rxy7[l_ac].rxy32
                  CALL pay7_money()
                  NEXT FIELD rxy06
               ELSE
              #FUN-BB0117 Add End -----
                  LET g_qryparam.default1 = g_rxy7[l_ac].rxy06
                  CALL cl_create_qry() RETURNING g_rxy7[l_ac].rxy06
                  DISPLAY BY NAME g_rxy7[l_ac].rxy06
                  CALL pay7_money()
                  NEXT FIELD rxy06
               END IF #FUN-BB0117 Add
           END CASE     
      END INPUT
      CLOSE pay7_bcl
      COMMIT WORK   
END FUNCTION

#FUN-BB0117 Add Begin ---
FUNCTION pay7_rxy06_get_where()
DEFINE l_lua04 LIKE lua_file.lua04
DEFINE l_lua06 LIKE lua_file.lua06
DEFINE l_lua07 LIKE lua_file.lua07
DEFINE l_lui05 LIKE lui_file.lui05
DEFINE l_lui06 LIKE lui_file.lui06
DEFINE l_lui07 LIKE lui_file.lui07

   IF g_type = '07' THEN
      SELECT lua04,lua06,lua07 INTO l_lua04,l_lua06,l_lua07
        FROM lua_file
       WHERE lua01 = g_no
      LET g_qryparam.where = " lukconf = 'Y'"
      IF NOT cl_null(l_lua04) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk08 = '",l_lua04,"' "
      END IF
      IF NOT cl_null(l_lua06) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk06 = '",l_lua06,"' "
      END IF
      IF NOT cl_null(l_lua07) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk07 = '",l_lua07,"' "
      END IF
   END IF
   IF g_type = '11' THEN
      SELECT lui05,lui06,lui07 INTO l_lui05,l_lui06,l_lui07
        FROM lui_file
       WHERE lui01 = g_no
      LET g_qryparam.where = " lukconf = 'Y'"
      IF NOT cl_null(l_lui07) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk08 = '",l_lui07,"' "
      END IF 
      IF NOT cl_null(l_lui05) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk06 = '",l_lui05,"' "
      END IF 
      IF NOT cl_null(l_lui06) THEN 
         LET g_qryparam.where = g_qryparam.where CLIPPED," AND luk07 = '",l_lui06,"' "
      END IF
   END IF
END FUNCTION

FUNCTION pay7_rxy32()
DEFINE l_n  LIKE type_file.num5

   LET g_errno = ''
   IF NOT cl_null(g_rxy7[l_ac].rxy06) AND NOT cl_null(g_rxy7[l_ac].rxy32) THEN
      SELECT COUNT(*) INTO l_n 
        FROM lul_file 
       WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
      IF l_n = 0 THEN 
         LET g_errno = 'art-763' #该待抵单不存在此项次的资料
      END IF
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#檢查交款金額是否超過可衝金額和本次出貨單應交總額
#FUNCTION pay7_rxy05()     #FUN-BB0117 Mark
FUNCTION pay7_rxy05(p_cmd) #FUN-BB0117 Add
DEFINE p_cmd LIKE type_file.chr1 

    IF g_rxy7[l_ac].sum3 IS NULL OR g_rxy7[l_ac].rxy05 IS NULL THEN
       RETURN
    END IF
  
    LET g_errno = ''
    IF g_rxy7[l_ac].rxy05 > g_rxy7[l_ac].sum3 THEN
       LET g_errno = 'sub-200'
       RETURN
    END IF
    CALL pay_show()
   #FUN-BB0117 Add&Mark Begin ---
   #IF g_rxy7[l_ac].rxy05 - g_rxx04_07 > g_sum3 THEN 
   #   LET g_errno = 'sub-201'
   #   RETURN
   #END IF
    IF p_cmd = 'a' THEN
       IF g_rxy7[l_ac].rxy05 > g_sum3 THEN
          LET g_errno = 'art-765'
          RETURN
       END IF
    END IF
    IF p_cmd = 'u' THEN
       IF g_rxy7[l_ac].rxy05 - g_rxy7_t.rxy05 > g_sum3 THEN
          LET g_errno = 'art-765'
          RETURN
       END IF
    END IF
   #FUN-BB0117 Add&Mark End -----
    
END FUNCTION
#計算總金額、已衝金額、可衝金額
FUNCTION pay7_money()
DEFINE l_rxy01        LIKE rxy_file.rxy01
DEFINE l_rxy05        LIKE rxy_file.rxy05
DEFINE l_ogaconf      LIKE oga_file.ogaconf
DEFINE l_oga10        LIKE oga_file.oga10
DEFINE l_oob09        LIKE oob_file.oob09
DEFINE l_sql          STRING
DEFINE l_lul06        LIKE lul_file.lul06 #待抵金額 #FUN-BB0117 Add  
DEFINE l_lul07        LIKE lul_file.lul07 #已沖金額 #FUN-BB0117 Add 
DEFINE l_lul08        LIKE lul_file.lul08 #已退金額 #FUN-BB0117 Add 
 
    IF cl_null(g_rxy7[l_ac].rxy19) OR cl_null(g_rxy7[l_ac].rxy06) THEN
       RETURN
    END IF
 
    IF g_rxy7[l_ac].rxy19 = '1' THEN
       #查詢銷售訂單收取訂金總額
       SELECT SUM(rxx04) INTO g_rxy7[l_ac].sum1 FROM rxx_file 
        WHERE rxx00 = '01' AND rxx01 = g_rxy7[l_ac].rxy06
          AND rxx03 = '1' AND  rxxplant = g_org
          AND rxx02 = g_rxy7[l_ac].rxy03  #FUN-CB0025
       IF g_rxy7[l_ac].sum1 IS NULL THEN LET g_rxy7[l_ac].sum1 = 0 END IF
 
       #查詢該銷售訂單的已衝金額
       SELECT SUM(rxy05) INTO g_rxy7[l_ac].sum2 FROM rxy_file 
        WHERE rxy00 = g_type AND rxyplant = g_org AND rxy04 = '1'
         #AND rxy19 = '1'  AND rxy03 = '07'                               #FUN-CB0025
          AND rxy19 = '1'  AND rxy03 = g_rxy7[l_ac].rxy03 AND rxy33 = 'Y' #FUN-CB0025
          AND rxy06 = g_rxy7[l_ac].rxy06
       IF g_rxy7[l_ac].sum2 IS NULL THEN LET g_rxy7[l_ac].sum2 = 0 END IF
 
       #查詢該訂單對應的出貨單
       LET l_sql = "SELECT DISTINCT rxy01,rxy05 FROM rxy_file ",
                   " WHERE rxy00 = '",g_type,"' AND rxy06 = '",g_rxy7[l_ac].rxy06,
                  #"'  AND rxy03 = '07' ",                               #FUN-CB0025
                   "'  AND rxy33 = 'Y' AND rxy03 = g_rxy7[l_ac].rxy03 ", #FUN-CB0025
                   "   AND rxy04 = '1' AND rxy19 = '1' ",
                   "   AND rxyplant = '",g_org,"'"
       PREPARE oga_pb FROM l_sql
       DECLARE oga_cur CURSOR FOR oga_pb
 
       FOREACH oga_cur INTO l_rxy01,l_rxy05
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF l_rxy05 IS NULL THEN LET l_rxy05 = 0 END IF
 
          #檢查該出貨單是否有衝帳,如果有減掉
          LET l_ogaconf = NULL
          SELECT ogaconf FROM oga_file WHERE oga01 = l_rxy01
          IF l_ogaconf = 'X' THEN
             LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 - l_rxy05   #計算已衝金額
          END IF
       END FOREACH
       LET g_rxy7[l_ac].sum3 = g_rxy7[l_ac].sum1 - g_rxy7[l_ac].sum2   #計算可衝金額
    END IF
    #暫收款
    IF g_rxy7[l_ac].rxy19 = '2' THEN
       #查詢該帳單的總金額 
       SELECT oma54t-oma55 INTO g_rxy7[l_ac].sum1 FROM oma_file
          WHERE oma01 = g_rxy7[l_ac].rxy06
 
       #查詢該帳單的已衝金額                                                                                             
       SELECT SUM(rxy05) INTO g_rxy7[l_ac].sum2 FROM rxy_file                                                  
          WHERE rxy00 = g_type AND rxyplant = g_org AND rxy04 = '1'                       
            AND rxy19 = '2'  AND rxy03 = '07'                                                                              
            AND rxy06 = g_rxy7[l_ac].rxy06                                                                
       IF g_rxy7[l_ac].sum2 IS NULL THEN LET g_rxy7[l_ac].sum2 = 0 END IF
       #查詢該訂單對應的出貨單                                                                                                      
       LET l_sql = "SELECT DISTINCT rxy01,rxy05 FROM rxy_file ",
                   " WHERE rxy00 = '",g_type,"' AND rxy06 = '",g_rxy7[l_ac].rxy06,                                         
                   "' AND rxy03 = '07' AND rxy04 = '1' AND rxy19 = '2' ",                       
                   " AND rxyplant = '",g_org,"'"                                                                                      
       PREPARE oga_pb1 FROM l_sql                                                                                                  
       DECLARE oga_cur1 CURSOR FOR oga_pb1
 
       FOREACH oga_cur INTO l_rxy01,l_rxy05
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF l_rxy05 IS NULL THEN LET l_rxy05 = 0 END IF 
          #檢查該出貨單是否有衝帳,如果有減掉                                                                                  
          SELECT ogaconf,oga10 INTO l_ogaconf,l_oga10 FROM oga_file WHERE oga01 = l_rxy01                    
          IF l_ogaconf = 'X' OR NOT cl_null(l_oga10) THEN                                                                     
             LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 - l_rxy05   #計算已衝金額                                                    
          END IF
       END FOREACH
       #
       SELECT SUM(oob09) INTO l_oob09 FROM oob_file,ooa_file 
          WHERE oob06 = g_rxy7[l_ac].rxy06
            AND oob03 = '1' AND oob04 = '3' AND ooaconf = 'N'
            AND ooa01 = oob01
       IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
 
       LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 + l_oob09   #計算已衝金額的和
 
       LET g_rxy7[l_ac].sum3 = g_rxy7[l_ac].sum1 - g_rxy7[l_ac].sum2   #計算可衝金額
    END IF

   #FUN-BB0117 Add Begin ---
    IF g_rxy7[l_ac].rxy19 = '3' THEN
       IF NOT cl_null(g_rxy7[l_ac].rxy06) AND NOT cl_null(g_rxy7[l_ac].rxy32) THEN
          #查詢待抵單
          SELECT lul05,lul06,lul07,lul08 INTO g_rxy7[l_ac].lul05,l_lul06,l_lul07,l_lul08
            FROM lul_file 
           WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
          IF cl_null(l_lul06) THEN LET l_lul06 = 0 END IF
          IF cl_null(l_lul07) THEN LET l_lul07 = 0 END IF
          IF cl_null(l_lul08) THEN LET l_lul08 = 0 END IF
          IF NOT cl_null(g_rxy7[l_ac].lul05) THEN 
             SELECT oaj02 INTO g_rxy7[l_ac].oaj02 FROM oaj_file WHERE oaj01 = g_rxy7[l_ac].lul05
          END IF
          #計算總金額 = 待抵金額 - 已退金額
          LET g_rxy7[l_ac].sum1 = l_lul06 - l_lul08
          #查詢該待抵單的已沖金額
          SELECT SUM(lul07) INTO g_rxy7[l_ac].sum2 FROM lul_file
           WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
          #查詢出該單據已沖金額
          SELECT SUM(rxy05) INTO l_rxy05  FROM rxy_file
           WHERE rxy00 = g_type AND rxyplant = g_org AND rxy04 = '1'
             AND rxy19 = '3'  AND rxy03 = '07' AND rxy01 = p_no
             AND rxy06 = g_rxy7[l_ac].rxy06 AND rxy32 = g_rxy7[l_ac].rxy32
          IF cl_null(l_rxy05) THEN LET l_rxy05 = 0 END IF
          LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 - l_rxy05   #計算已沖金額
          #計算可沖金額 = 總金額 - 已沖金額
          LET g_rxy7[l_ac].sum3 = g_rxy7[l_ac].sum1 - g_rxy7[l_ac].sum2
       END IF
    END IF
   #FUN-BB0117 Add End -----
 
    DISPLAY BY NAME g_rxy7[l_ac].sum1,g_rxy7[l_ac].sum2,g_rxy7[l_ac].sum3
END FUNCTION
 
#計算已衝金額
FUNCTION s_up_money(p_no)    #p_no:預收款單號
DEFINE l_rxy01    LIKE rxy_file.rxy05
DEFINE l_rxy05    LIKE rxy_file.rxy05
DEFINE l_ogaconf  LIKE oga_file.ogaconf
DEFINE l_oga10    LIKE oga_file.oga10
DEFINE l_oob09    LIKE oob_file.oob09
DEFINE l_sql      STRING
DEFINE p_no       LIKE rxy_file.rxy06
DEFINE l_sum2     LIKE rxx_file.rxx04
 
    #計算該帳單已經衝的金額
    SELECT SUM(rxy05) INTO l_sum2 FROM rxy_file                                                  
          WHERE rxy00 = '02' 
#           AND rxyplant = g_org 
            AND rxy04 = '1'                       
            AND rxy19 = '2'  AND rxy03 = '07'                                                                              
            AND rxy06 = p_no
    IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF
 
    LET l_sql = "SELECT DISTINCT rxy01,rxy05 FROM rxy_file ",
                   " WHERE rxy00 = '",02,"' AND rxy06 = '",p_no,                                         
                   "' AND rxy03 = '07' AND rxy04 = '1' AND rxy19 = '2' "
#                  " AND rxyplant = '",g_org,"'"                                                                                      
    PREPARE oga_pb11 FROM l_sql                                                                                                  
    DECLARE oga_cur11 CURSOR FOR oga_pb11
 
    FOREACH oga_cur INTO l_rxy01,l_rxy05
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rxy05 IS NULL THEN LET l_rxy05 = 0 END IF 
                                                                                          
       SELECT ogaconf,oga10 INTO l_ogaconf,l_oga10 FROM oga_file WHERE oga01 = l_rxy01                    
       IF l_ogaconf = 'X' OR NOT cl_null(l_oga10) THEN                                                                     
          LET l_sum2 = l_sum2 - l_rxy05                                                      
       END IF
    END FOREACH
    SELECT SUM(oob09) INTO l_oob09 FROM oob_file,ooa_file 
       WHERE oob06 = p_no
         AND oob03 = '1' AND oob04 = '3' AND ooaconf = 'N'
         AND ooa01 = oob01
 
   IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
   LET l_sum2 = l_sum2 + l_oob09
 
   IF l_sum2 IS NULL THEN
      LET l_sum2 = 0 
   END IF
 
   RETURN l_sum2
END FUNCTION
#檢查衝預收單號是否有效
#衝預收款類型: 1:銷售訂單--->出貨單對應的銷售訂單，且該銷售訂單已經審核，訂單中的商品沒有全部結案
#              2:應付帳單號--->帳款類型為：24(暫收)，客戶為出貨單的客戶，已經審核
#              3:費用待抵單
FUNCTION pay7_rxy06()
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  l_ogb31      LIKE ogb_file.ogb31
DEFINE  l_oeaconf    LIKE oea_file.oeaconf
DEFINE  l_cnt1       LIKE type_file.num5
DEFINE  l_oga03      LIKE oga_file.oga03
DEFINE  l_sql        STRING
DEFINE  l_n          LIKE type_file.num5   
DEFINE  l_lua04      LIKE lua_file.lua04   #FUN-BB0117 Add 
DEFINE  l_lua06      LIKE lua_file.lua06   #FUN-BB0117 Add 
DEFINE  l_lua07      LIKE lua_file.lua07   #FUN-BB0117 Add 
DEFINE  l_lukconf    LIKE luk_file.lukconf #FUN-BB0117 Add
DEFINE  l_luk06      LIKE luk_file.luk06   #FUN-BB0117 Add 
DEFINE  l_luk07      LIKE luk_file.luk07   #FUN-BB0117 Add 
DEFINE  l_luk08      LIKE luk_file.luk08   #FUN-BB0117 Add 
 
  
   LET g_errno = ''
   IF cl_null(g_rxy7[l_ac].rxy06) OR cl_null(g_rxy7[l_ac].rxy19) THEN
      RETURN
   END IF
 
   IF g_rxy7[l_ac].rxy19 = '1' THEN
      SELECT COUNT(*) INTO l_n FROM rxy_file
       WHERE rxy00 = '02' AND rxy01 = g_no
        #AND rxy03 = '07'               #FUN-CB0025
         AND rxy03 = g_rxy7[l_ac].rxy03 #FUN-CB0025
         AND rxy33 = 'Y'                #FUN-CB0025
         AND rxy04 = '1' AND rxy06 = g_rxy7[l_ac].rxy06
         AND rxyplant = rxyplant AND rxy19 ='1'
      IF l_n > 0 OR l_n IS NULL THEN
         LET g_errno = 'sub-202'
         RETURN
      END IF
      #查找出貨單單身中所有的銷售訂單
      LET l_sql = "SELECT ogb31 FROM ogb_file WHERE ogb01 = '",g_no ,"'"
      PREPARE pay7_pb FROM l_sql     
      DECLARE pay7_curs CURSOR FOR pay7_pb
      LET l_cnt = 0
      FOREACH pay7_curs INTO l_ogb31
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         IF l_ogb31 = g_rxy7[l_ac].rxy06 THEN LET l_cnt = l_cnt + 1 END IF
      END FOREACH
      #沒有找到
      IF l_cnt = 0 THEN LET g_errno = 'sub-196' RETURN END IF   
      #銷售訂單是否審核
      SELECT oeaconf INTO l_oeaconf FROM oea_file WHERE oea01 = g_rxy7[l_ac].rxy06
      IF l_oeaconf <> 'Y' THEN LET g_errno = 'sub-197' RETURN END IF
      #看該銷售訂單中所有已經結案的商品
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oeb_file 
         WHERE oeb01 = g_rxy7[l_ac].rxy06 AND oeb70 = 'Y'
      IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
 
      #查詢銷售訂單中所有的商品
      SELECT COUNT(*) INTO l_cnt1 FROM oeb_file 
         WHERE oeb01 = g_rxy7[l_ac].rxy06
      IF l_cnt1 IS NULL THEN LET l_cnt1 = 0 END IF
 
      IF l_cnt = l_cnt1 THEN LET g_errno = 'sub-198' RETURN END IF
  #ELSE #FUN-BB0117 Mark
   END IF #FUN-BB0117 Add
   IF g_rxy7[l_ac].rxy19 = '2' THEN #FUN-BB0117 Add
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rxy_file WHERE rxy00 = '02' AND rxy01 = g_no                                                    
         AND rxy03 = '07' AND rxy04 = '1' AND rxy06 = g_rxy7[l_ac].rxy06                                                            
         AND rxyplant = rxyplant AND rxy19 = '2'
      IF l_n IS NULL OR l_n > 0 THEN
         LET g_errno = 'sub-202'
         RETURN
      END IF
      SELECT oga03 INTO l_oga03 FROM oga_file WHERE oga01 = g_no
      SELECT * FROM oma_file WHERE oma01 = g_rxy7[l_ac].rxy06 
         AND oma00 = '24' AND oma03 = l_oga03 AND omaconf = 'Y'
      IF SQLCA.sqlcode = 100 THEN LET g_errno = 'sub-199' RETURN END IF    
   END IF   
  #FUN-BB0117 Add Begin ---
   IF g_rxy7[l_ac].rxy19 = '3' THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rxy_file WHERE rxy00 = '07' AND rxy01 = g_no
         AND rxy03 = '07' AND rxy04 = '1' AND rxy06 = g_rxy7[l_ac].rxy06
         AND rxyplant = rxyplant AND rxy19 = '3' AND rxy32 = g_rxy7[l_ac].rxy32
      IF l_n IS NULL OR l_n > 0 THEN
         LET g_errno = 'art-764'
         RETURN
      END IF
      SELECT lua04,lua06,lua07 INTO l_lua04,l_lua06,l_lua07
        FROM lua_file
       WHERE lua01 = g_no
      LET l_sql = "SELECT luk06,luk07,luk08,lukconf ",
                  "  FROM luk_file ",
                  " WHERE luk01 = '",g_rxy7[l_ac].rxy06,"' "
     #IF NOT cl_null(l_lua04) THEN #合同編號
     #   LET l_sql = l_sql CLIPPED," AND luk08 = '",l_lua04,"' "
     #END IF
     #IF NOT cl_null(l_lua06) THEN #商戶編號
     #   LET l_sql = l_sql CLIPPED," AND luk06 = '",l_lua06,"' "
     #END IF
     #IF NOT cl_null(l_lua07) THEN #攤位編號
     #   LET l_sql = l_sql CLIPPED," AND luk07 = '",l_lua07,"' "
     #END IF
      PREPARE sel_count_pre FROM l_sql
      EXECUTE sel_count_pre INTO l_luk06,l_luk07,l_luk08,l_lukconf
      CASE
         WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm1204' #不存在該待抵單
         WHEN (NOT cl_null(l_lua04) AND (l_lua04 <> l_luk08 OR cl_null(l_luk08)))
                                  LET g_errno = 'alm1508' #待抵單中的合同編號與費用單不一致
         WHEN (NOT cl_null(l_lua06) AND (l_lua06 <> l_luk06 OR cl_null(l_luk06)))
                                  LET g_errno = 'alm1509' #待抵單中的商戶編號與費用單不一致
         WHEN (NOT cl_null(l_lua07) AND (l_lua07 <> l_luk07 OR cl_null(l_luk07)))
                                  LET g_errno = 'alm1510' #待抵單中的攤位編號與費用單不一致
         WHEN l_lukconf <> 'Y'    LET g_errno = 'alm1274' #該待抵單未確認
         OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
   END IF
  #FUN-BB0117 Add End -----
END FUNCTION
FUNCTION pay7_b_fill()
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
  
   #LET l_sql = "SELECT rxy02,rxy19,rxy06,'','','',rxy05 ",             #FUN-BB0117 Mark
    LET l_sql = "SELECT rxy02,rxy19,rxy06,rxy03,rxy32,'','','','','',rxy05 ", #FUN-BB0117 Add #FUN-CB0025 Add rxy03
                "  FROM rxy_file ",
                " WHERE rxy00 = '",g_type,"' ",
               #"   AND rxy03 = '07' ",                  #FUN-CB0025
                "   AND (rxy03 = '07' OR rxy33 = 'Y') ", #FUN-CB0025
                "   AND rxy01 = '",g_no,"' AND rxyplant = '",g_org,"'"
   #FUN-BB0117 Add Begin ---
    IF g_prog = 'artt610' OR g_prog = 'artt611' THEN
       LET l_sql = l_sql CLIPPED," AND rxy19 = '3' "
    ELSE
       LET l_sql = l_sql CLIPPED," AND (rxy19 = '1' OR rxy19 = '2') "
    END IF
   #FUN-BB0117 Add End -----
    PREPARE pay7_pb1 FROM l_sql
    DECLARE pay7_curs1 CURSOR FOR pay7_pb1
 
    CALL g_rxy7.clear()
    LET l_ac = 1
    MESSAGE "Searching!"
    FOREACH pay7_curs1 INTO g_rxy7[l_ac].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL pay7_money()
        LET g_rxy7[l_ac].sum2 = g_rxy7[l_ac].sum2 - g_rxy7[l_ac].rxy05                                                
        LET g_rxy7[l_ac].sum3 = g_rxy7[l_ac].sum3 + g_rxy7[l_ac].rxy05
       #FUN-BB0117 Add Begin ---
        SELECT lul05 INTO g_rxy7[l_ac].lul05 
          FROM lul_file 
         WHERE lul01 = g_rxy7[l_ac].rxy06 AND lul02 = g_rxy7[l_ac].rxy32
        IF NOT cl_null(g_rxy7[l_ac].lul05) THEN
           SELECT oaj02 INTO g_rxy7[l_ac].oaj02
             FROM oaj_file 
            WHERE oaj01 = g_rxy7[l_ac].lul05
        END IF
       #FUN-BB0117 Add End -----
        LET l_ac = l_ac + 1
        IF l_ac > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rxy7.deleteElement(l_ac)
    MESSAGE ""
    LET g_rec_b = l_ac-1
END FUNCTION
#------------------衝預收結束----------------------------------
#------------------人工轉帳開始--------------------------------
FUNCTION pay_tran()
DEFINE l_money       LIKE rxx_file.rxx04
DEFINE l_money_type  LIKE rxx_file.rxx03
DEFINE l_rxy02       LIKE rxy_file.rxy02
DEFINE l_rxx04       LIKE rxx_file.rxx04
DEFINE l_rxy06       LIKE rxy_file.rxy06
DEFINE l_rxy08       LIKE rxy_file.rxy08
DEFINE l_flag        LIKE type_file.num5 #TQC-C30179 Add
DEFINE l_rxy06_p     LIKE rxy_file.rxy06 #TQC-C30179 Add
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add 

   IF g_flag <> 'N' THEN
      CALL cl_err('','sub-186',1)
      RETURN
   END IF
 
   OPEN WINDOW pay8_w AT 10,20 WITH FORM "sub/42f/s_pay8"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  #CALL cl_ui_init()   #TQC-AC0310
   CALL cl_ui_locale("s_pay8")

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-262',g_lang) RETURNING l_string  #付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-260',g_lang) RETURNING l_string  #付款應付餘額
       CALL cl_set_comp_att_text("total",l_string)
    END IF
   #FUN-C30165 add END
 
   DISPLAY g_sum3 TO FORMONLY.total
   DISPLAY g_sum3 TO rxy05
   LET l_money = g_sum3
 
   INPUT l_rxy06,l_money,l_rxy08 WITHOUT DEFAULTS FROM rxy06,rxy05,rxy08
 
       AFTER FIELD rxy05
           IF l_money <= 0 OR l_money > g_sum3 THEN
              CALL cl_err('','sub-187',0)
              NEXT FIELD rxy05
           END IF

      #TQC-A10122 ADD--------------------- 
       AFTER FIELD rxy08
          IF NOT cl_null(l_rxy08) THEN
             IF l_rxy08 < 0 THEN
                CALL cl_err('','sub-195',0)
                NEXT FIELD rxy08
             END IF
          END IF
      #TQC-A10122 ADD---------------------

      #TQC-C30179 Add Begin ---
       ON ACTION pay_tran_cancel
          LET l_rxy06_p = GET_FLDBUF(rxy06)
          CALL pay_tran_cancel(l_rxy06_p) RETURNING l_flag
          IF l_flag = 0 THEN
              LET INT_FLAG = 1
              EXIT INPUT
          END IF 
      #TQC-C30179 Add End -----

        ON ACTION controlg
           CALL cl_cmdask()
   END INPUT
 
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW pay8_w
       CALL pay_show()    
       RETURN
   END IF
   IF g_type = '01' OR g_type = '02' OR  
      g_type = '21' OR g_type = '20' OR g_type = '23' OR         #FUN-C90085 add  #FUN-CC0057 add g_type = '23' OR 
#     g_type = '05' OR g_type = '07' THEN
     #g_type = '05' OR g_type = '07' OR g_type='09' THEN         #No.FUN-A10106 #FUN-BB0117 Mark
      g_type = '05' OR g_type = '07' OR g_type='09' OR g_type = '11' THEN       #FUN-BB0117 Add
      LET l_money_type = 1
   ELSE
      LET l_money_type = -1
   END IF
 
   BEGIN WORK
   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
       WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
   IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
   LET l_rxy02 = l_rxy02 + 1
 
   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,
                        rxy08,rxyplant,rxy21,rxy22,rxylegal,rxy33) #FUN-CB0025 Add rxy33
       VALUES(g_type,g_no,l_rxy02,'08',l_money_type,l_money,l_rxy06,
              l_rxy08,g_org,g_today,g_time1,g_legal2,'N')          #FUN-CB0025
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins rxy_file',SQLCA.sqlcode,1)
      ROLLBACK WORK
      CLOSE WINDOW pay8_w
      RETURN
   END IF
 
   SELECT rxx04 INTO l_rxx04 FROM rxx_file 
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '08' AND rxxplant = g_org
   IF cl_null(l_rxx04) THEN 
      LET l_rxx04 = 0
   END IF
 
   IF SQLCA.sqlcode = 100 THEN
      INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
         VALUES(g_type,g_no,'08',l_money_type,l_money,0,g_org,g_legal2)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                     
         CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)                                                                          
         ROLLBACK WORK    
         CLOSE WINDOW pay8_w                                                                                                 
         RETURN                                                                                                        
      END IF
   ELSE
      UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + l_money 
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '08'
            AND rxxplant = g_org
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('UPD rxx_file',SQLCA.sqlcode,1)
         ROLLBACK WORK
         CLOSE WINDOW pay8_w
         RETURN
      END IF
   END IF
 
   COMMIT WORK
 
   CLOSE WINDOW pay8_w
   CALL pay_show()
END FUNCTION 

#TQC-C30179 Add Begin ---
#手工轉帳取消
FUNCTION pay_tran_cancel(p_rxy06)
DEFINE p_rxy06     LIKE rxy_file.rxy06
DEFINE l_n         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_rxy05_sum LIKE rxy_file.rxy05

   IF NOT cl_null(p_rxy06) THEN
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n 
        FROM rxy_file 
       WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org AND rxy06 = p_rxy06 AND rxy03 = '08'
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-243') THEN RETURN 1 END IF #是否取消當前卡號下的手工轉帳金額？
      ELSE
         CALL cl_err('','sub-244',0) #當前卡號無手工轉帳記錄！
         RETURN 1
      END IF
   ELSE
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM rxx_file
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '08' AND rxxplant = g_org
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-245') THEN RETURN 1 END IF #是否取消所有手工轉帳金額？
      ELSE
         CALL cl_err('','sub-246',0) #無手工轉帳記錄！
         RETURN 1
      END IF
   END IF

   BEGIN WORK
   LET l_sql = "UPDATE rxy_file ",
               "   SET rxy05 = 0,rxy08 = 0 ",
               " WHERE rxy00 = '",g_type,"' ",
               "   AND rxy01 = '",g_no,"' ",
               "   AND rxy03 = '08' ",
               "   AND rxyplant = '",g_org,"' "
   IF NOT cl_null(p_rxy06) THEN 
      LET l_sql = l_sql CLIPPED," AND rxy06 = '",p_rxy06,"' " 
   END IF
   PREPARE del_rxy_01 FROM l_sql
   EXECUTE del_rxy_01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("del","rxy_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN 1
   END IF 

   INITIALIZE l_rxy05_sum TO NULL
   SELECT SUM(rxy05) INTO l_rxy05_sum 
     FROM rxy_file 
    WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org AND rxy03 = '08'
   IF cl_null(l_rxy05_sum) THEN LET l_rxy05_sum = 0 END IF
   UPDATE rxx_file SET rxx04 = l_rxy05_sum
    WHERE rxx00 = g_type 
      AND rxx01 = g_no 
      AND rxx02 = '08'
      AND rxxplant = g_org
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rxx_file",g_no,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN 1
   END IF

   COMMIT WORK
   RETURN 0
END FUNCTION
#TQC-C30179 Add End -----
 

#FUN-BA0069 add begin ----
FUNCTION pay_integral()
DEFINE l_string   LIKE  ze_file.ze03   #FUN-C30165 add

   IF g_flag <> 'N' THEN
      CALL cl_err('','sub-186',1)
      RETURN
   END IF
   IF cl_null(g_oga87) THEN
      CALL cl_err('','axm-562','')
      RETURN
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   OPEN WINDOW s_pay9_1 AT 10,20 WITH FORM "sub/42f/s_pay9_1"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("s_pay9_1")

   LET g_action_choice = ""
   CALL pay9_1_menu()
   CLOSE WINDOW s_pay9_1

END FUNCTION

FUNCTION pay9_1_menu()
    MENU ""
       BEFORE MENU
         CALL pay9_1_a()

       ON ACTION exit
          EXIT MENU
       ON ACTION controlg
          CALL cl_cmdask()
       ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
   END MENU
END FUNCTION

FUNCTION pay9_1_a()
DEFINE l_sum_rxx04_point LIKE rxx_file.rxx04           #未扣賬積分
DEFINE l_lpj12           LIKE lpj_file.lpj12
DEFINE l_lpj02           LIKE lpj_file.lpj02
DEFINE l_lph38           LIKE lph_file.lph38
DEFINE l_lph39           LIKE lph_file.lph39
DEFINE temp_a            LIKE lpj_file.lpj12
DEFINE l_point           LIKE type_file.num20_6   #CHI-C80052 add
DEFINE l_rxy02           LIKE rxy_file.rxy02
DEFINE l_money_type      LIKE rxz_file.rxz02   #款別類型
DEFINE l_rxx04           LIKE rxx_file.rxx04

   LET l_point = 0     #CHI-C80052 add
   IF g_type = '01' OR g_type = '02' OR
      g_type = '21' OR g_type = '20' OR g_type = '23' OR    #FUN-C90085 add  #FUN-CC0057 add g_type = '23' OR 
      g_type = '05' OR g_type = '07' OR g_type='09' THEN
      LET l_money_type = '1'
   ELSE
      LET l_money_type = '-1'
   END IF
   SELECT lpj12,lpj02 INTO l_lpj12,l_lpj02             #取得會員卡的剩餘積分及卡種
     FROM lpj_file
    WHERE lpj03 = g_oga87
   IF cl_null(l_lpj12) THEN
      LET l_lpj12 = 0
   END IF
   SELECT SUM(rxy23) INTO l_sum_rxx04_point   #未扣賬積分
     FROM rxy_file,oga_file
    WHERE rxy00 = g_type
      AND rxy01 = oga01
      AND rxy03 = '09'
      AND ogapost = 'N'
      AND oga87 = g_oga87
   IF cl_null(l_sum_rxx04_point) THEN
      LET l_sum_rxx04_point = 0
   END IF
   LET g_lpj12_before = l_lpj12 - l_sum_rxx04_point
   DISPLAY g_lpj12_before TO lpj12_before
   SELECT lph38,lph39  INTO l_lph38,l_lph39            #取得該卡種的積分抵現規則
     FROM lph_file
    WHERE lph01 = l_lpj02
      AND lph37 = 'Y'
   IF SQLCA.sqlcode = 100 THEN
      LET l_lph38 = 0
      LET l_lph39 = 0
      LET g_lpj12_amount = 0
   ELSE   #計算總可抵現金
      LET l_point = g_lpj12_before/l_lph38 * l_lph39          #CHI-C80052 add 
      LET temp_a = s_trunc(l_point,0)                         #CHI-C80052 add    #無條件去除
     #LET temp_a = g_lpj12_before/l_lph38                     #CHI-C80052 mark
     #LET temp_a = cl_numfor(temp_a,20,0)                     #CHI-C80052 mark
     #LET g_lpj12_amount = temp_a*l_lph39                     #CHI-C80052 mark
      LET g_lpj12_amount = temp_a                             #CHI-C80052 add
   END IF
   DISPLAY g_lpj12_amount TO lpj12_amount
   IF g_lpj12_amount <= g_sum3 THEN
      LET g_rxy05 = g_lpj12_amount
   END IF
   IF g_lpj12_amount > g_sum3 THEN
      LET g_rxy05 = g_sum3
   END IF
   DISPLAY g_rxy05 TO rxy05
  #LET g_lpj12_after = g_lpj12_before - ((g_rxy05/l_lph39)*l_lph38)   #CHI-C80052 mark
  #CHI-C80052 add START
   LET l_point = 0 
   LET l_point = (g_rxy05/l_lph39)*l_lph38
   LET l_point = s_roundup(l_point,0)    #無條件進位 
   LET g_lpj12_after = g_lpj12_before - l_point
  #CHI-C80052 add END
   DISPLAY g_lpj12_after TO lpj12_after
   INPUT g_rxy05 WITHOUT DEFAULTS FROM rxy05

      AFTER FIELD rxy05
         IF NOT cl_null(g_rxy05) THEN
            IF g_rxy05 <= 0 THEN
               CALL cl_err('','sub-155',0)
               LET g_rxy05 = ''
               NEXT FIELD rxy05
            END IF
            IF g_rxy05 > g_lpj12_amount THEN
               CALL cl_err('','sub-156',0)
               LET g_rxy05 = ''
               NEXT FIELD rxy05
            END IF
            IF g_rxy05 > g_sum3 THEN
               CALL cl_err('','sub-157',0)
               LET g_rxy05 = ''
               NEXT FIELD rxy05
            END IF
           #LET g_lpj12_after = g_lpj12_before - ((g_rxy05/l_lph39)*l_lph38)   #CHI-C80052 mark mark
           #CHI-C80052 add START
            LET l_point = 0
            LET l_point = (g_rxy05/l_lph39)*l_lph38
            LET l_point = s_roundup(l_point,0)   #無條件進入
            LET g_lpj12_after = g_lpj12_before - l_point
           #CHI-C80052 add END
            LET g_rxx04_09 = g_rxy05
            LET g_rxx04_point = g_lpj12_before - g_lpj12_after
            DISPLAY g_lpj12_after TO lpj12_after
         ELSE
            LET g_rxy05 = 0
           #LET g_lpj12_after = g_lpj12_before - ((g_rxy05/l_lph39)*l_lph38)    #CHI-C80052 mark mark
           #CHI-C80052 add START
            LET l_point = 0
            LET l_point = (g_rxy05/l_lph39)*l_lph38
            LET l_point = s_roundup(l_point,0)   #無條件進入
            LET g_lpj12_after = g_lpj12_before - l_point
           #CHI-C80052 add END
            LET g_rxx04_point = g_lpj12_before - g_lpj12_after
            LET g_rxx04_09 = 0
            DISPLAY g_lpj12_after TO lpj12_after
         END IF

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION controlg
         CALL cl_cmdask()
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF

    BEGIN WORK
    SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
       WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
    IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
    LET l_rxy02 = l_rxy02 + 1

    INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxy12,rxy21,rxy22,rxy23,rxylegal,rxyplant,rxy33) #FUN-CB0025 Add rxy33
                  VALUES(g_type,g_no,l_rxy02,'09',l_money_type,g_rxy05,g_oga87,l_lpj02,g_today,g_time1,g_rxx04_point,g_legal2,g_org,'N') #FUN-CB0025
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins rxy_file',SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF

    SELECT rxx04 INTO l_rxx04 FROM rxx_file
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '09' AND rxxplant = g_org
    IF cl_null(l_rxx04) THEN
       LET l_rxx04 = 0
    END IF

    IF SQLCA.sqlcode = 100 THEN
       INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
                     VALUES(g_type,g_no,'09',l_money_type,g_rxx04_09,0,g_org,g_legal2)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxx04_09
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '09'
            AND rxxplant = g_org
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
    COMMIT WORK
END FUNCTION
#FUN-BA0069 add end ---
#FUN-BB0024 --------------------STA
FUNCTION pay_integral_t700()
DEFINE l_lph37    LIKE lph_file.lph37
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add

   IF g_flag <> 'N' THEN
      CALL cl_err('','sub-186',1)
      RETURN
   END IF

   IF cl_null(g_oha87) THEN
      CALL cl_err('','axm-564','')
      RETURN
   ELSE
      SELECT lpj12,lpj02 INTO g_lpj12,g_lpj02             #取得會員卡的剩餘積分及卡種
        FROM lpj_file
       WHERE lpj03 = g_oha87
      IF cl_null(g_lpj12) THEN
         LET g_lpj12 = 0
      END IF
      SELECT lph37 INTO l_lph37 FROM lph_file
       WHERE lph01 = g_lpj02
      IF STATUS =100 OR l_lph37 = 'N' THEN
         CALL cl_err('','axm-564','')
         RETURN
      END IF
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   OPEN WINDOW s_pay9_2 AT 10,20 WITH FORM "sub/42f/s_pay9_2"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("s_pay9_2")

   LET g_action_choice = ""
   CALL pay9_2_menu()
   CLOSE WINDOW s_pay9_2

END FUNCTION

FUNCTION pay9_2_menu()
   MENU ""
       BEFORE MENU
         CALL pay9_2_a()

       ON ACTION exit
          EXIT MENU

       ON ACTION controlg
          CALL cl_cmdask()
       ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
   END MENU

END FUNCTION

FUNCTION pay9_2_a()
DEFINE l_sum_rxx04_point LIKE rxx_file.rxx04           #未退回積分
DEFINE l_lpj12           LIKE lpj_file.lpj12
DEFINE l_lpj02           LIKE lpj_file.lpj02
DEFINE l_lph38           LIKE lph_file.lph38
DEFINE l_lph39           LIKE lph_file.lph39
DEFINE temp_a            LIKE lpj_file.lpj12
DEFINE l_rxy02           LIKE rxy_file.rxy02
DEFINE l_money_type      LIKE rxz_file.rxz02   #款別類型
DEFINE l_rxx04           LIKE rxx_file.rxx04
DEFINE l_point           LIKE type_file.num20_6   #CHI-C80052 add

   LET l_point = 0     #CHI-C80052 add
   IF g_type = '01' OR g_type = '02' OR
      g_type = '21' OR g_type = '20' OR g_type = '23' OR      #FUN-C90085 add #FUN-CC0057 add g_type = '23' OR 
      g_type = '05' OR g_type = '07' OR g_type='09' THEN
      LET l_money_type = '1'
   ELSE
      LET l_money_type = '-1'
   END IF
   SELECT lpj12,lpj02 INTO l_lpj12,l_lpj02             #取得會員卡的剩餘積分及卡種
     FROM lpj_file
    WHERE lpj03 = g_oha87
   IF cl_null(l_lpj12) THEN
      LET l_lpj12 = 0
   END IF
   SELECT SUM(rxy23) INTO l_sum_rxx04_point   #未退回積分
     FROM rxy_file,oha_file
    WHERE rxy00 = g_type
      AND rxy01 = oha01
      AND rxy03 = '09'
      AND ohapost = 'N'
      AND oha87 = g_oha87
   IF cl_null(l_sum_rxx04_point) THEN
      LET l_sum_rxx04_point = 0
   END IF
   LET g_lpj12_before = l_lpj12 + l_sum_rxx04_point
   DISPLAY g_lpj12_before TO lpj12_before
   SELECT lph38,lph39  INTO l_lph38,l_lph39            #取得該卡種的積分抵現規則
     FROM lph_file
    WHERE lph01 = l_lpj02
      AND lph37 = 'Y'
   IF SQLCA.sqlcode = 100 THEN
      LET l_lph38 = 0
      LET l_lph39 = 0
      LET g_lpj12_amount = 0
   END IF
   LET g_rxy05 = g_sum3
   DISPLAY g_rxy05 TO rxy05
  #LET g_rxy05_point = (g_rxy05/l_lph39)*l_lph38   #CHI-C80052 mark
  #CHI-C80052 add START
   LET l_point = (g_rxy05/l_lph39)*l_lph38
   LET l_point = s_roundup(l_point,0)    #無條件進位 
   LET g_rxy05_point = l_point
  #CHI-C80052 add END
   LET g_lpj12_after = g_lpj12_before + g_rxy05_point
   DISPLAY g_rxy05_point TO rxy05_point
   DISPLAY g_lpj12_after TO lpj12_after
   INPUT g_rxy05 WITHOUT DEFAULTS FROM rxy05

      AFTER FIELD rxy05
         IF NOT cl_null(g_rxy05) THEN
            IF g_rxy05 <= 0 THEN
               CALL cl_err('','sub-155',0)
               LET g_rxy05 = ''
               NEXT FIELD rxy05
            END IF
            IF g_rxy05 > g_sum3 THEN
               CALL cl_err('','sub-157',0)
               LET g_rxy05 = ''
               NEXT FIELD rxy05
            END IF
           #LEt g_rxy05_point = (g_rxy05/l_lph39)*l_lph38   #CHI-C80052 mark
           #CHI-C80052 add START
            LET l_point = 0
            LET l_point = (g_rxy05/l_lph39)*l_lph38
            LET l_point = s_roundup(l_point,0)    #無條件進位
            LET g_rxy05_point = l_point
           #CHI-C80052 add END
            LET g_lpj12_after = g_lpj12_before + g_rxy05_point
            LET g_rxx04_09 = g_rxy05
            LET g_rxx04_point = g_lpj12_after - g_lpj12_before
            DISPLAY g_rxy05_point TO rxy05_point
            DISPLAY g_lpj12_after TO lpj12_after
         ELSE
            LET g_rxy05 = 0
            LET g_rxy05_point = 0
           #LET g_lpj12_after = g_lpj12_before + ((g_rxy05/l_lph39)*l_lph38)   #CHI-C80052 mark
            LET g_lpj12_after = g_lpj12_before + g_rxy05_point                 #CHI-C80052 add 
            LET g_rxx04_point = g_lpj12_after - g_lpj12_before
            LET g_rxx04_09 = 0
            DISPLAY g_rxy05_point TO rxy05_point
            DISPLAY g_lpj12_after TO lpj12_after
         END IF

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION controlg
         CALL cl_cmdask()
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF

    BEGIN WORK
    SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
       WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
    IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
    LET l_rxy02 = l_rxy02 + 1

    INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxy12,rxy21,rxy22,rxy23,rxylegal,rxyplant,rxy33) #FUN-CB0025 Add rxy33
                  VALUES(g_type,g_no,l_rxy02,'09',l_money_type,g_rxy05,g_oha87,l_lpj02,g_today,g_time1,g_rxx04_point,g_legal2,g_org,'N') #FUN-CB0025
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins rxy_file',SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF

    SELECT rxx04 INTO l_rxx04 FROM rxx_file
       WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '09' AND rxxplant = g_org
    IF cl_null(l_rxx04) THEN
       LET l_rxx04 = 0
    END IF

    IF SQLCA.sqlcode = 100 THEN
       INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
                     VALUES(g_type,g_no,'09',l_money_type,g_rxx04_09,0,g_org,g_legal2)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       UPDATE rxx_file SET rxx04 = COALESCE(rxx04,0) + g_rxx04_09
          WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '09'
            AND rxxplant = g_org
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
    COMMIT WORK
END FUNCTION
#FUN-BB0024 --------------------END

#------------------人工轉帳結束--------------------------------  
#----------交、退款明細-------------
FUNCTION s_pay_detail(p_type,p_no,p_org,p_flag)
DEFINE  p_type     LIKE  smy_file.smyslip,
        p_no       LIKE  rti_file.rti01,
        p_org      LIKE  tqb_file.tqb01,
        p_sum      LIKE  rxx_file.rxx04,
        p_flag     LIKE  rti_file.rticonf
DEFINE l_rxy     DYNAMIC ARRAY OF RECORD
          rxy02       LIKE rxy_file.rxy02,
          rxy03       LIKE rxy_file.rxy03,
          rxy33       LIKE rxy_file.rxy33, #FUN-CB0025
          rxy05       LIKE rxy_file.rxy05,
          rxy06       LIKE rxy_file.rxy06,
          rxy32       LIKE rxy_file.rxy32, #FUN-BB0117 Add
          rxy07       LIKE rxy_file.rxy07,
          rxy08       LIKE rxy_file.rxy08,
          rxy09       LIKE rxy_file.rxy09,
          rxy10       LIKE rxy_file.rxy10,
          rxy11       LIKE rxy_file.rxy11,
          rxy12       LIKE rxy_file.rxy12,
          rxy13       LIKE rxy_file.rxy13,
          rxy14       LIKE rxy_file.rxy14,
          rxy15       LIKE rxy_file.rxy15,
          rxy16       LIKE rxy_file.rxy16,
          rxy17       LIKE rxy_file.rxy17,
          rxy19       LIKE rxy_file.rxy19,
          rxy23       LIKE rxy_file.rxy23,    #FUN-BA0069 add
          rxy21       LIKE rxy_file.rxy21,
          rxy22       LIKE rxy_file.rxy22
                      END RECORD
DEFINE l_cnt   LIKE type_file.num5
DEFINE  l_string   LIKE  ze_file.ze03   #FUN-C30165 add
   
   IF cl_null(p_type) OR cl_null(p_no) OR cl_null(p_org) 
      OR cl_null(p_flag) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   
   LET g_type = p_type  #FUN-C30165 add
   DECLARE s_rxy_curs CURSOR FOR
        SELECT rxy02,rxy03,rxy33,rxy05,rxy06,rxy32,rxy07,rxy08,rxy09,rxy10,rxy11,    #FUN-BB0117 Add rxy32 #FUN-CB0025 Add rxy33
               rxy12,rxy13,rxy14,rxy15,rxy16,rxy17,rxy19,rxy23,rxy21,rxy22     #FUN-BA0069 add rxy23
           FROM rxy_file
         WHERE rxy00 = p_type
           AND rxy01 = p_no
           AND rxyplant = p_org
          ORDER BY rxy02
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare s_rxy_curs',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   CALL l_rxy.clear()
   LET l_cnt = 1
   FOREACH s_rxy_curs INTO l_rxy[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach s_rxy_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET l_cnt = l_cnt + 1
   END FOREACH
   #CALL g_rxz.deleteElement(l_cnt) #FUN-C70127 mark
   CALL l_rxy.deleteElement(l_cnt) #FUN-C70127 add
   LET l_cnt = l_cnt - 1
 
   OPEN WINDOW s_detail_w AT 10,2 WITH FORM "sub/42f/s_detail"
      # ATTRIBUTE(BORDER,GREEN,FORM LINE FIRST)  #No.TQC-9B0025
        ATTRIBUTE( STYLE = g_win_style )         #No.TQC-9B0025
   CALL cl_ui_locale("s_detail")
   DISPLAY l_cnt TO FORMONLY.cn2

   #FUN-C30165 add START
   #退款類型的將畫面上"收款" 修改成 "付款"
    IF g_type = '03' OR g_type = '04' OR g_type = '06' OR g_type = '08'
      #OR g_type = '22' OR g_type = '23' THEN #FUN-CC0057
       OR g_type = '22' THEN                  #FUN-CC0057
       CALL cl_getmsg('sub-262',g_lang) RETURNING l_string  #付款金額
       CALL cl_set_comp_att_text("rxy05",l_string)
       CALL cl_getmsg('sub-263',g_lang) RETURNING l_string  #票券溢付款金額
       CALL cl_set_comp_att_text("rxy17",l_string)
       CALL cl_getmsg('sub-267',g_lang) RETURNING l_string  #沖預付款類型
       CALL cl_set_comp_att_text("rxy19",l_string)
       CALL cl_getmsg('sub-268',g_lang) RETURNING l_string  #暫付款
       CALL cl_set_comp_att_text("rxy19_2",l_string)
       CALL cl_getmsg('sub-269',g_lang) RETURNING l_string  #付款日期
       CALL cl_set_comp_att_text("rxy21",l_string)
       CALL cl_getmsg('sub-270',g_lang) RETURNING l_string  #付款時間
       CALL cl_set_comp_att_text("rxy22",l_string)
    END IF
   #FUN-C30165 add END
 
   DISPLAY ARRAY l_rxy TO s_rxy8.* ATTRIBUTE(COUNT=l_cnt)
      ON ACTION cancel
         LET INT_FLAG=FALSE
         EXIT DISPLAY
   END DISPLAY  
   CLOSE WINDOW s_detail_w
END FUNCTION
#No.FUN-9A0102 MARK
#NO.FUN-960130------end------

#FUN-BC0071 ------------------STA
FUNCTION s_ins_rxx_rxy()
DEFINE l_rxy02   LIKE rxy_file.rxy02  
DEFINE l_n       LIKE type_file.num5

   BEGIN WORK
   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file
    WHERE rxy00 = g_type AND rxy01 = g_no AND rxyplant = g_org
    IF cl_null(l_rxy02) THEN LET l_rxy02 = 0 END IF
    LET l_rxy02 = l_rxy02 + 1  

   SELECT SUM(rxc06) INTO g_rxx04_10 FROM rxc_file WHERE rxc00 = g_type AND rxc03 = '03' AND rxc02= 0
                                     AND rxc01 = g_no

#FUN-C20098 -----------STA
    SELECT COUNT(*) INTO l_n FROM rxy_file 
     WHERE rxy00 = g_type AND rxy01 = g_no AND rxy03 = '10' AND rxyplant = g_org
   
    IF l_n = 0 THEN 
#FUN-C20098 -----------END
       INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy21,rxy22,rxylegal,rxyplant,rxy33) #FUN-CB0025 Add rxy33
                  VALUES(g_type,g_no,l_rxy02,'10',1,g_rxx04_10,g_today,g_time1,g_legal2,g_org,'N')   #FUN-CB0025
       IF SQLCA.sqlcode THEN
          CALL cl_err('ins rxy_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
#FUN-C20098 -----------STA       
    ELSE
       UPDATE rxy_file SET rxy05 = g_rxx04_10
        WHERE rxy00 = g_type AND rxy01 = g_no AND rxy03 = '10' AND rxyplant = g_org
       IF SQLCA.sqlcode THEN
          CALL cl_err('upd rxy_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF 
#FUN-C20098 -----------END

#FUN-C20098 -----------STA
    SELECT COUNT(*) INTO l_n FROM rxx_file 
     WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '10' AND rxxplant = g_org
   
    IF l_n = 0 THEN 
#FUN-C20098 -----------END
       INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxxplant,rxxlegal)
                       VALUES(g_type,g_no,'10',1,g_rxx04_10,0,g_org,g_legal2)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
#FUN-C20098 -----------STA
    ELSE
       UPDATE rxx_file SET rxx04 = g_rxx04_10
        WHERE rxx00 = g_type AND rxx01 = g_no AND rxx02 = '10' AND rxxplant = g_org
       IF SQLCA.sqlcode THEN
          CALL cl_err('upd rxx_file',SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
#FUN-C20098 -----------END
    COMMIT WORK
END FUNCTION
#FUN-BC0071 ------------------END

#FUN-C90085----add-----str
FUNCTION undo_pay(p_type,p_no,p_org,p_sum,p_flag)
DEFINE l_rxx04         LIKE rxx_file.rxx04
DEFINE l_money_type    LIKE rxx_file.rxx03
DEFINE l_rxz05         LIKE rxz_file.rxz05
DEFINE l_rxz04         LIKE rxz_file.rxz04
DEFINE l_rxy05         LIKE rxy_file.rxy05
DEFINE l_rxy06         LIKE rxy_file.rxy06
DEFINE l_rxy32         LIKE rxy_file.rxy32
DEFINE l_lul07         LIKE lul_file.lul07
DEFINE p_type          LIKE smy_file.smyslip
DEFINE p_no            LIKE rti_file.rti01
DEFINE p_org           LIKE tqb_file.tqb01
DEFINE p_sum           LIKE rxx_file.rxx04
DEFINE p_flag          LIKE rti_file.rticonf
DEFINE l_sql           STRING
DEFINE l_lsn02         LIKE lsn_file.lsn02

   CALL s_showmsg_init()
   LET g_type = p_type
   LET g_no = p_no
   LET g_org =  p_org
   LET g_sum = p_sum
   LET g_flag = p_flag
   #儲值卡交款
   SELECT rxx04 INTO l_rxx04 FROM rxx_file
      WHERE rxx02 = '06' AND rxx00 = g_type
        AND rxx01 = g_no AND rxxplant = g_org
   IF NOT cl_null(l_rxx04) THEN 
      IF g_type = '01' OR g_type = '02' OR
         g_type = '21' OR g_type = '20' OR
         g_type = '23' OR                       #FUN-CC0057 add
         g_type = '05' OR g_type = '07' OR
         g_type='09' OR g_type = '11' THEN   
         LET l_money_type = 1
      ELSE
         LET l_money_type = -1
      END IF
      LET l_sql = "SELECT rxz04,rxz05 FROM rxz_file",
                  " WHERE rxz00 = '",g_type,"'",
                  "   AND rxz01 = '",g_no,"'",
                  "   AND rxzplant = '",g_org,"'"
      PREPARE sel_rxz_pb FROM l_sql
      DECLARE sel_rxz_cs CURSOR FOR sel_rxz_pb
      FOREACH sel_rxz_cs INTO l_rxz04,l_rxz05
         IF l_money_type = 1 THEN
            UPDATE lpj_file SET lpj06 = lpj06 + l_rxz05,
                                lpjpos = '2'              #FUN-D30007 add
             WHERE lpj03 = l_rxz04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rxz04',l_rxz04,'upd lpj_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         ELSE
            UPDATE lpj_file SET lpj06 = lpj06 - l_rxz05,
                                lpjpos = '2'            #FUN-D30007 add
             WHERE lpj03 = l_rxz04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rxz04',l_rxz04,'upd lpj_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         CASE g_type
              WHEN '01' LET l_lsn02 = '6'
              WHEN '02' LET l_lsn02 = '7'
              WHEN '03' LET l_lsn02 = '8'
              WHEN '04' LET l_lsn02 = '9'
              WHEN '05' LET l_lsn02 = 'C'
              WHEN '06' LET l_lsn02 = 'D'
              WHEN '07' LET l_lsn02 = 'A'
              WHEN '08' LET l_lsn02 = 'B'
              OTHERWISE LET l_lsn02 = g_type
         END CASE
         DELETE FROM lsn_file
          WHERE lsn01 = l_rxz04
            AND lsn02 = l_lsn02
            AND lsn03 = g_no
           #AND lsnplant = g_org  #FUN-C90102 mark 
            AND lsnstore = g_org  #FUN-C90102 add
            AND lsn10 = '1'
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('rxz04',l_rxz04,'del lsn_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   END IF 
   #衝預收交款
   LET l_sql = "SELECT rxy05,rxy06,rxy32 ",
               "  FROM rxy_file ",
               " WHERE rxy19 = '3' ",
               "   AND rxy03 = '07' ",
               "   AND rxy00 = '",g_type,"' ",
               "   AND rxy01 = '",g_no,"' ",
               "   AND rxyplant = '",g_org,"' "
   PREPARE sel_rxy32_pre FROM l_sql
   DECLARE sel_rxy32_cs CURSOR FOR sel_rxy32_pre
   FOREACH sel_rxy32_cs INTO l_rxy05,l_rxy06,l_rxy32
      IF NOT cl_null(l_rxy05) THEN 
         UPDATE lul_file SET lul07 = COALESCE(lul07,0) - l_rxy05
          WHERE lul01 = l_rxy06 AND lul02 = l_rxy32
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rxy06',l_rxy06,'del lul_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         ELSE
            SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = l_rxy06
            IF cl_null(l_lul07) THEN LET l_lul07 = 0 END IF
            UPDATE luk_file SET luk11 = l_lul07 WHERE luk01 = l_rxy06
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('rxy06',l_rxy06,'del luk_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
      INITIALIZE l_rxy05,l_rxy06,l_rxy32 TO NULL
   END FOREACH

   DELETE  FROM rxx_file 
    WHERE rxx00 = g_type
      AND rxx01 = g_no
      AND rxxplant = g_org
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxx01',g_no,'del rxx_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DELETE  FROM rxy_file 
    WHERE rxy00 = g_type
      AND rxy01 = g_no
      AND rxyplant = g_org
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxy01',g_no,'del rxy_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DELETE  FROM rxz_file 
    WHERE rxz00 = g_type
      AND rxz01 = g_no
      AND rxzplant = g_org
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxz01',g_no,'del rxz_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#FUN-C90085----add-----end
