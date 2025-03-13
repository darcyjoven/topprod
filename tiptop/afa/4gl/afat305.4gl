# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Date & Author..: 00/03/03 By Alex Lin
# Modify.........: No.+206 010612 by linda add fee05 類別 1.部門 2.廠商
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-530043 05/03/26 By Smapmin 回寫afai300中"已使用次數"
# Modify.........: No.MOD-530668 05/03/28 By Smapmin B單身會卡在模具編號欄位
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.MOD-570160 05/08/03 By Smapmin 歸還單單身輸入的領用單
#                                                    該廠商(部門)應與歸還單單頭廠商(部門)相同
# Modify.........: No.MOD-580153 05/08/19 By Smapmin 輸入完該張單據的當時,不能列印
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-660068 06/06/14 By Claire 流程訊息通知傳參數
# Modify.........: No.FUN-660136 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t305_q() 一開始應清空g_fee.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/26 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/19 By lala   報表轉為使用p_query
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/12 By TSD.zeak 自定欄位功能修改
# Modify.........: No.FUN-840241 08/06/19 By sherry 加上確認/取消確認功能，在確認時才回afai300數量feb12
# Modify.........: No.FUN-850024 08/05/08 By Cockroach 報表轉CR 
#                                08/07/30 By Cockroach 追單至31區
# Modify.........: No.FUN-910038 09/02/26 By sabrina 與EasyFlow整合，並將確認段拆出至afat305_sub.4gl
# Modify.........: No.TQC-970404 09/07/31 By Carrier before row時保留舊值
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0136 09/10/21 By mike 应增加AFTER FIELD fee02 日期与现行期别之起迄日期之检查.                           
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B60140 11/09/08 By zhangweib "財簽二二次改善"追單
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fee           RECORD LIKE fee_file.*,
    g_fee_t         RECORD LIKE fee_file.*,
    g_fee_o         RECORD LIKE fee_file.*,
    g_fee01_t       LIKE fee_file.fee01,   #簽核等級 (舊值)
    g_t1            LIKE fee_file.fee01,   #No.FUN-550034       #No.FUN-680070 VARCHAR(05)
 
    l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    g_fef           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fef02       LIKE fef_file.fef02,   #序號
        fef03       LIKE fef_file.fef03,   #模具編號
        fea02       LIKE fea_file.fea02,   #模具名稱
        fef05       LIKE fef_file.fef05,   #借用單號
        fef04       LIKE fef_file.fef04    #數量
        #FUN-850068 --start---
        ,fefud01 LIKE fef_file.fefud01,
        fefud02 LIKE fef_file.fefud02,
        fefud03 LIKE fef_file.fefud03,
        fefud04 LIKE fef_file.fefud04,
        fefud05 LIKE fef_file.fefud05,
        fefud06 LIKE fef_file.fefud06,
        fefud07 LIKE fef_file.fefud07,
        fefud08 LIKE fef_file.fefud08,
        fefud09 LIKE fef_file.fefud09,
        fefud10 LIKE fef_file.fefud10,
        fefud11 LIKE fef_file.fefud11,
        fefud12 LIKE fef_file.fefud12,
        fefud13 LIKE fef_file.fefud13,
        fefud14 LIKE fef_file.fefud14,
        fefud15 LIKE fef_file.fefud15
        #FUN-850068 --end--
                    END RECORD,
    g_fef_t         RECORD                 #程式變數 (舊值)
        fef02       LIKE fef_file.fef02,   #序號
        fef03       LIKE fef_file.fef03,   #模具編號
        fea02       LIKE fea_file.fea02,   #模具名稱
        fef05       LIKE fef_file.fef05,   #借用單號
        fef04       LIKE fef_file.fef04    #數量
        #FUN-850068 --start---
        ,fefud01 LIKE fef_file.fefud01,
        fefud02 LIKE fef_file.fefud02,
        fefud03 LIKE fef_file.fefud03,
        fefud04 LIKE fef_file.fefud04,
        fefud05 LIKE fef_file.fefud05,
        fefud06 LIKE fef_file.fefud06,
        fefud07 LIKE fef_file.fefud07,
        fefud08 LIKE fef_file.fefud08,
        fefud09 LIKE fef_file.fefud09,
        fefud10 LIKE fef_file.fefud10,
        fefud11 LIKE fef_file.fefud11,
        fefud12 LIKE fef_file.fefud12,
        fefud13 LIKE fef_file.fefud13,
        fefud14 LIKE fef_file.fefud14,
        fefud15 LIKE fef_file.fefud15
        #FUN-850068 --end--
                    END RECORD,
    g_fef_o         RECORD                 #程式變數 (舊值)
        fef02       LIKE fef_file.fef02,   #序號
        fef03       LIKE fef_file.fef03,   #模具編號
        fea02       LIKE fea_file.fea02,   #模具名稱
        fef05       LIKE fef_file.fef05,   #借用單號
        fef04       LIKE fef_file.fef04    #數量
        #FUN-850068 --start---
        ,fefud01 LIKE fef_file.fefud01,
        fefud02 LIKE fef_file.fefud02,
        fefud03 LIKE fef_file.fefud03,
        fefud04 LIKE fef_file.fefud04,
        fefud05 LIKE fef_file.fefud05,
        fefud06 LIKE fef_file.fefud06,
        fefud07 LIKE fef_file.fefud07,
        fefud08 LIKE fef_file.fefud08,
        fefud09 LIKE fef_file.fefud09,
        fefud10 LIKE fef_file.fefud10,
        fefud11 LIKE fef_file.fefud11,
        fefud12 LIKE fef_file.fefud12,
        fefud13 LIKE fef_file.fefud13,
        fefud14 LIKE fef_file.fefud14,
        fefud15 LIKE fef_file.fefud15
        #FUN-850068 --end--
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
#   g_wc,g_wc2,g_sql  LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
    g_wc,g_wc2,g_sql  STRING,              #TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    g_cmd           LIKE type_file.chr1      #MOD-580153       #No.FUN-680070 VARCHAR(1)
#No.FUN-850024  --ADD START--                                                                                                       
#DEFINE   g_sql           STRING                                                                                                    
DEFINE   g_str           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
#No.FUN-850024  --ADD END--   
 
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_argv1         LIKE fee_file.fee01            # 單號             #TQC-630052       #No.FUN-680070 VARCHAR(16)
DEFINE g_argv2         STRING              # 指定執行的功能   #TQC-630052
DEFINE g_laststage    LIKE type_file.chr1          #FUN-910038 add
DEFINE g_chr2         LIKE type_file.chr1          #FUN-910038 add
DEFINE g_approve      LIKE type_file.chr1          #FUN-910038 add
 
 
MAIN
# DEFINE                                                                       #NO.FUN-6A0069   
#    l_time        LIKE type_file.chr8                    #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-850024  --ADD START--                                                                                                   
 LET g_sql =         "fef01.fef_file.fef01,",                                                                                       
                     "fee02.fee_file.fee02,",                                                                                       
                     "gem02.gem_file.gem02,",                                                                                       
                     "fef02.fef_file.fef02,",                                                                                       
                     "fef03.fef_file.fef03,",                                                                                       
                     "fea02.fea_file.fea02,",                                                                                       
                     "fef04.fef_file.fef04,",                                                                                       
                     "fef05.fef_file.fef05,",                                                                                       
                     "fee04.fee_file.fee04 "                                                                                        
   LET l_table = cl_prt_temptable('afat305',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.FUN-850024  --ADD END--            
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                           #NO.FUN-6A0069     
 
    LET g_forupd_sql = " SELECT * FROM fee_file WHERE fee01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t305_cl CURSOR FROM g_forupd_sql
 
   #FUN-910038---easyflow---add---start---
    IF fgl_getenv('EASYFLOW')  = "1" THEN  #判斷是否為簽核模式
       LET g_argv1 = aws_efapp_wsk(1)       #取得單號
    END IF
   #FUN-910038---easyflow---add---end
 
   IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN      #FUN-910038 add 若為背景作業則不開窗
      LET p_row = 4 LET p_col = 15
      OPEN WINDOW t305_w AT p_row,p_col              #顯示畫面
          WITH FORM "afa/42f/afat305"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
      CALL cl_ui_init()
   END IF                                         #FUN-910038 add
   
   #FUN-910038---easyflow---add--start
   #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
   #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()
   #FUN-910038---easyflow---add---end
 
   #TQC-630052-begin
   # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(fee01)
   # 執行I時，g_argv1是單號(fee01)
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t305_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t305_a()
            END IF
        #FUN-910038---easyflow---add---start
         WHEN "efconfirm"
            CALL t305_q()
            CALL t305sub_y_chk(g_fee.fee01)          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL t305sub_y_upd(g_fee.fee01, g_action_choice)       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
        #FUN-910038---easyflow---ad---end
         #TQC-660068-begin
         OTHERWISE
               CALL t305_q()
         #TQC-660068-end
      END CASE
   END IF
   #TQC-630052-end
 
  #FUN-910038---easyflow---add---start
  #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, invalid, void, confirm, undo_confirm, easyflow_approval")    
        RETURNING g_laststage
  #FUN-910038---easyflow---add---end
 
    CALL t305_menu()
    CLOSE WINDOW t305_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                  #NO.FUN-6A0069   
END MAIN
 
#QBE 查詢資料
FUNCTION t305_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
     DEFINE l_str STRING #No.MOD-4A0248
 
    CLEAR FORM                             #清除畫面
   CALL g_fef.clear()
 
   IF cl_null(g_argv1) THEN  #TQC-630052
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fee.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
      fee01,fee02,fee07,fee05,fee03,fee04,fee06,feemksg,feeconf,     #FUN-910038 add fee06,fee07,feemksg,feeconf
      feeuser,feegrup,feemodu,feedate,feeacti
      #FUN-850068   ---start---
      ,feeud01,feeud02,feeud03,feeud04,feeud05,
      feeud06,feeud07,feeud08,feeud09,feeud10,
      feeud11,feeud12,feeud13,feeud14,feeud15
      #FUN-850068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(fee01) #單據編號
              #  LET g_t1=g_fee.fee01[1,3]
              #  CALL q_fah( FALSE, TRUE,g_t1,'E',g_sys) RETURNING g_t1
              #  LET g_fee.fee01[1,3]=g_t1
              #  DISPLAY BY NAME g_fee.fee01
                   #--No.MOD-4A0248--------
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_fee"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fee01
                   #--END---------------
                 NEXT FIELD fee01
            WHEN INFIELD(fee03) #部門代號
                  #--No.MOD-4A0248--
                 CALL GET_FLDBUF(fee05) RETURNING l_str
                   CASE l_str
                       WHEN '1'
                       #  IF g_fee.fee05='1' THEN
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_gem"
                            LET g_qryparam.state = "c"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO fee03
                       WHEN '2'
                       #  ELSE
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_pmc3"
                            LET g_qryparam.state = "c"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO fee03
                       #  END IF
                   END CASE
                 #---END---#
                 NEXT FIELD fee03
           #FUN-910038---easyflow---add---start---
            WHEN INFIELD(fee07) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fee07
                 NEXT FIELD fee07
           #FUN-910038---easyflow---add---end---
           OTHERWISE
                 EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND feeuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND feegrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND feegrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('feeuser', 'feegrup')
  #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON fef02,fef03,fea02,fef05,fef04   #螢幕上取單身條件
                       #No.FUN-850068 --start--
                       ,fefud01,fefud02,fefud03,fefud04,fefud05,
                       fefud06,fefud07,fefud08,fefud09,fefud10,
                       fefud11,fefud12,fefud13,fefud14,fefud15
                       #No.FUN-850068 ---end---
 
            FROM s_fef[1].fef02,s_fef[1].fef03,s_fef[1].fea02,s_fef[1].fef05,
                 s_fef[1].fef04
                 #No.FUN-850068 --start--
                 ,s_fef[1].fefud01,s_fef[1].fefud02,s_fef[1].fefud03,
                 s_fef[1].fefud04,s_fef[1].fefud05,s_fef[1].fefud06,
                 s_fef[1].fefud07,s_fef[1].fefud08,s_fef[1].fefud09,
                 s_fef[1].fefud10,s_fef[1].fefud11,s_fef[1].fefud12,
                 s_fef[1].fefud13,s_fef[1].fefud14,s_fef[1].fefud15
                 #No.FUN-850068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fef03) #模具編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_feb"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fef03
                 NEXT FIELD fef03
              WHEN INFIELD(fef05)     #領用單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fed"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fef05
                 NEXT FIELD fef05
              OTHERWISE
                 EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
  #TQC-630052-begin
   ELSE
      LET g_wc =" fee01 = '",g_argv1,"'"  
      LET g_wc2=" 1=1"
   END IF
  #TQC-630052-end
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fee01 FROM fee_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fee01 ",
                   "  FROM fee_file, fef_file ",
                   " WHERE fee01 = fef01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t305_prepare FROM g_sql
    DECLARE t305_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t305_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fee_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM fee_file,fef_file WHERE ",
                  "fef01=fee01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t305_precount FROM g_sql
    DECLARE t305_count CURSOR FOR t305_precount
END FUNCTION
 
FUNCTION t305_menu()
DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-7C0043
DEFINE l_creator         VARCHAR(1)         #「不准」時是否退回填表人 #FUN-910038
DEFINE l_flowuser        VARCHAR(1)         # 是否有指定加簽人員      #FUN-910038
  LET l_flowuser = "N"                                           #FUN-910038
 
   WHILE TRUE
      CALL t305_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t305_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t305_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t305_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t305_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t305_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t305_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.FUN-840241---Begin
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #FUN-910038---easyflow---add---start
                #CALL t305_y()
                 CALL t305sub_y_chk(g_fee.fee01)        #CALL 原確認的check段
                 IF g_success = "Y" THEN
                    CALL t305sub_y_upd(g_fee.fee01,g_action_choice)       #CALL 原確認的 update 段
                    CALL t305sub_refresh(g_fee.fee01) RETURNING g_fee.*           #重新讀取g_fee.*
                    CALL t305_show() 
                 END IF 
               #FUN-910038---easyflow---add---end
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
                 CALL t305_z()
            END IF         
         #No.FUN-840241---End   
 
    #FUN-910038---easyflow---add---start
       #@WHEN "EasyFlow送簽"
         WHEN "easyflow_approval"           
            IF cl_chk_act_auth() THEN
                #FUN-C20012 add str---
                 SELECT * INTO g_fee.* FROM fee_file
                  WHERE fee01 = g_fee.fee01
                 CALL t305_show()
                 CALL t305_b_fill(' 1=1')
                #FUN-C20012 add end---
                 CALL t305_ef()
                 CALL t305_show()  #FUN-C20012 add
            END IF
 
        #@WHEN "簽核狀況"
          WHEN "approval_status"               
              IF cl_chk_act_auth() THEN  
                 IF aws_condition2() THEN               
                     CALL aws_efstat2()
                 END IF
              END IF
 
        #@WHEN "准"
          WHEN "agree"                    #執行 EF 簽核, "准" 功能
              IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關並且無加簽人員
                 CALL t305sub_y_upd(g_fee.fee01,g_action_choice)       #CALL 原確認的 update 段
                 CALL t305sub_refresh(g_fee.fee01) RETURNING g_fee.*
                 CALL t305_show()
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN   #執行 EF 簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                         IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                           CALL t305_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale,invalid,  void, confirm, undo_confirm,easyflow_approval")
                                RETURNING g_laststage
                         ELSE
                             EXIT WHILE
                         END IF
                       ELSE
                         EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
              END IF
 
        #@WHEN "不准"
          WHEN "deny"    #執行 EF 簽核, "不准" 功能
              IF (l_creator := aws_efapp_backflow() ) IS NOT NULL THEN #退回關卡
                IF aws_efapp_formapproval() THEN   #執行 EF 簽核
                   IF l_creator = "Y" THEN         #當退回填表人時
                      LET g_fee.fee06 = 'R'         #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_fee.fee06
                   END IF
                   IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                        IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                           CALL t305_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, invalid, void, confirm, undo_confirm,easyflow_approval")
                               RETURNING g_laststage
                        ELSE
                              EXIT WHILE
                        END IF
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
        #@WHEN "加簽"
          WHEN "modify_flow"               #執行 EF 簽核, "加簽" 功能
              IF aws_efapp_flowuser() THEN  #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
       #@WHEN "撤簽"
         WHEN "withdraw"                  #執行 EF 簽核, "撤簽" 功能
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
       #@WHEN "抽單"
         WHEN "org_withdraw"               #執行 EF 簽核, "抽單" 功能
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
       #@WHEN "簽核意見"
         WHEN "phrase"                      #執行 EF 簽核, "簽核意見" 功能
              CALL aws_efapp_phrase()
    #FUN-910038---easyflow---add---end---
 
         WHEN "output"
#No.FUN-850024 --COMEBACK START--
##No.FUN-7C0043--start--                                                         
#        IF cl_chk_act_auth()                                                   
#              #THEN CALL t305_out()                                            
#              THEN                                                             
#              IF cl_null(g_wc) THEN LET g_wc='1=1' END IF 
#              IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF                      
#              LET l_cmd = 'p_query "afat305" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'     
#              CALL cl_cmdrun(l_cmd)                                            
#        END IF                                                                 
##No.FUN-7C0043--end--
          IF cl_chk_act_auth() THEN                                                                                         
             CALL t305_out()  
          END IF
#No.FUN-850024 --COMEBACK END-- 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fee.fee01 IS NOT NULL THEN
                  LET g_doc.column1 = "fee01"
                  LET g_doc.value1 = g_fee.fee01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fef),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t305_v()
               CALL t305_field_pic()
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t305_a()
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    MESSAGE ""
    CLEAR FORM
    CALL g_fef.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fee.* LIKE fee_file.*             #DEFAULT 設定
    LET g_fee01_t = NULL
    LET g_fee.fee02 = g_today
    LET g_fee.fee05 = '1'
    LET g_fee.fee06 = '0'                #FUN-910038  add
    LET g_fee.fee07 = g_user             #FUN-910038  add
    CALL t305_fee07('d')                 #FUN-910038  add
 
    #預設值及將數值類變數清成零
    LET g_fee_t.* = g_fee.*
    LET g_fee_o.* = g_fee.*
    LET g_fee.feeconf='N'       #No.FUN-840241
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fee.feeuser=g_user
        LET g_fee.feeoriu = g_user #FUN-980030
        LET g_fee.feeorig = g_grup #FUN-980030
        LET g_fee.feegrup=g_grup
        LET g_fee.feemodu=' '
        LET g_fee.feedate=g_today
        LET g_fee.feeacti='Y'              #資料有效
        LET g_fee.feelegal= g_legal    #FUN-980003 add
 
        CALL t305_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fee.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        # KEY 不可空白
        IF g_fee.fee01 IS NULL OR g_fee.fee02 IS NULL
           OR g_fee.fee03 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK  #No:7837,7689
#No.FUN-550034 --start--
        CALL s_auto_assign_no("afa",g_fee.fee01,g_fee.fee02," ","fee_file","fee01","","","")
             RETURNING li_result,g_fee.fee01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fee.fee01
#       IF g_fah.fahauno='Y' THEN #自動賦予單號
#           CALL s_afaauno(g_fee.fee01,g_fee.fee02) RETURNING g_i,g_fee.fee01
#           IF g_i THEN CONTINUE WHILE END IF	#有問題
#           DISPLAY BY NAME g_fee.fee01
#       END IF
#No.FUN-550034 ---end--
        INSERT INTO fee_file VALUES (g_fee.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN   			
            CALL cl_err3("ins","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127  #No.FUN-B80054---調整至回滾事務前---
            ROLLBACK WORK  #No:7837
#            CALL cl_err(g_fee.fee01,SQLCA.sqlcode,1)         #No.FUN-660127
            CONTINUE WHILE
        ELSE
            COMMIT WORK   #No:7837
            CALL cl_flow_notify(g_fee.fee01,'I')
        END IF
        SELECT fee01 INTO g_fee.fee01 FROM fee_file
            WHERE fee01 = g_fee.fee01
        LET g_fee01_t = g_fee.fee01        #保留舊值
        LET g_fee_t.* = g_fee.*
        LET g_fee_o.* = g_fee.*
        LET g_rec_b=0
        CALL t305_b()      #輸入單身
       #FUN-910038---add---start---
        IF NOT cl_null(g_fee.fee01) AND g_fah.fahconf = 'Y' AND g_fah.fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
           CALL t305sub_y_chk(g_fee.fee01)    #CALL 原確認的check段
           IF g_success = "Y" THEN
              CALL t305sub_y_upd(g_fee.fee01,g_action_choice)   #CALL原確認的update段
              CALL t305sub_refresh(g_fee.fee01) RETURNING g_fee.*
              CALL t305_show()
           END IF
        END IF
       #FUN-910038---ad---end---
 
        EXIT WHILE
    END WHILE
     LET g_cmd = 'a'   #MOD-580153
     LET g_wc = ' '   #MOD-580153
END FUNCTION
 
FUNCTION t305_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fee.fee01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fee.* FROM fee_file
     WHERE fee01=g_fee.fee01
    IF g_fee.feeacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fee.fee01,'mfg1000',0)
        RETURN
    END IF
   #FUN-910038---add---start---
    IF g_fee.fee06 matches '[Ss]'  THEN       #送簽中不可更改資料
       CALL cl_err('','apm-030', 0)
       RETURN
    END IF
   #FUN-910038---add---end---
 
    #No.FUN-840241---Begin                                                      
    IF g_fee.feeconf = 'Y' THEN                                                 
       CALL cl_err('','9023',0)                                              
       RETURN                                                                   
    END IF                                                                      
    #No.FUN-840241---End  
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fee01_t = g_fee.fee01
    BEGIN WORK
 
    OPEN t305_cl USING g_fee.fee01
    IF STATUS THEN
       CALL cl_err("OPEN t305_cl:", STATUS, 1)
       CLOSE t305_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t305_cl INTO g_fee.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t305_cl ROLLBACK WORK RETURN
    END IF
    CALL t305_show()
    WHILE TRUE
        LET g_fee01_t = g_fee.fee01
        LET g_fee_o.* = g_fee.*
        LET g_fee.feemodu=g_user
        LET g_fee.feedate=g_today
        CALL t305_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fee.*=g_fee_t.*
            CALL t305_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fee.fee01 != g_fee01_t THEN            # 更改單號
            UPDATE fef_file SET fef01 = g_fee.fee01
                WHERE fef01 = g_fee01_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('fef',SQLCA.sqlcode,0)    #No.FUN-660127
                 CALL cl_err3("upd","fef_file",g_fee01_t,"",SQLCA.sqlcode,"","fef",1)  #No.FUN-660127
                 CONTINUE WHILE
            END IF
        END IF
        LET g_fee.fee06 = '0'        #FUN-910038 add
        UPDATE fee_file SET fee_file.* = g_fee.*
            WHERE fee01 = g_fee.fee01
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)     #No.FUN-660127
             CALL cl_err3("upd","fee_file",g_fee01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t305_cl
    DISPLAY BY NAME g_fee.fee06    #FUN-910038 add
    CALL t305_field_pic()          #FUN-910038 add
    COMMIT WORK
    CALL cl_flow_notify(g_fee.fee01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION t305_i(p_cmd)
DEFINE
    l_n		LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
DEFINE li_result   LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE l_bdate LIKE type_file.dat #MOD-9A0136                                                                                       
DEFINE l_edate LIKE type_file.dat #MOD-9A0136    
    DISPLAY BY NAME g_fee.fee02,g_fee.fee07,g_fee.feeuser,g_fee.feegrup,   #FUN-910038 add fee07
    g_fee.feemodu,g_fee.feedate,g_fee.feeacti,g_fee.feeconf #No.FUN-840241 add feeconf
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0029
 
    INPUT BY NAME g_fee.feeoriu,g_fee.feeorig,
        g_fee.fee01,g_fee.fee02,g_fee.fee07,g_fee.fee05,g_fee.fee03,g_fee.fee04,    #FUN-910038 add fee07
        g_fee.feeconf,g_fee.fee06,g_fee.feemksg,    #FUN-840241 add feeconf  #FUN-910038 add fee06,feemksg
        g_fee.feeuser,g_fee.feegrup,g_fee.feemodu,g_fee.feedate,g_fee.feeacti
        #FUN-850068     ---start---
        ,g_fee.feeud01,g_fee.feeud02,g_fee.feeud03,g_fee.feeud04,
        g_fee.feeud05,g_fee.feeud06,g_fee.feeud07,g_fee.feeud08,
        g_fee.feeud09,g_fee.feeud10,g_fee.feeud11,g_fee.feeud12,
        g_fee.feeud13,g_fee.feeud14,g_fee.feeud15 
        #FUN-850068     ----end----
        WITHOUT DEFAULTS
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t305_set_entry(p_cmd)
        CALL t305_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fee01")
#No.FUN-550034 ---end---
 
    AFTER FIELD fee01
       #IF NOT cl_null(g_fee.fee01) AND (g_fee.fee01!=g_fee01_t) THEN     #FUN-910038 mark
        IF NOT cl_null(g_fee.fee01) THEN                                  #FUN-910038 add
#No.FUN-550034 --start--
    CALL s_check_no("afa",g_fee.fee01,g_fee01_t,"E","fee_file","fee01","")
         RETURNING li_result,g_fee.fee01
    DISPLAY BY NAME g_fee.fee01
       IF (NOT li_result) THEN
          NEXT FIELD fee01
       END IF
 
#          LET g_t1=g_fee.fee01[1,3]
#          CALL s_afaslip(g_t1,'E',g_sys)      #檢查外送單別
#          IF NOT cl_null(g_errno) THEN  #抱歉, 有問題
#          CALL cl_err(g_t1,g_errno,0)
#                 LET g_fee.fee01 = g_fee_o.fee01
#                 NEXT FIELD fee01
#          END IF
#
           
           LET g_t1 = s_get_doc_no(g_fee.fee01)     #FUN-910038 add
           SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
#
#          IF p_cmd='a' THEN
#             IF g_fee.fee01[1,3] IS NOT NULL  AND
#                cl_null(g_fee.fee01[5,10]) AND g_fah.fahauno = 'N' THEN
#                NEXT FIELD fee01
#             ELSE
#                NEXT FIELD fee02
#             END IF
#          END IF
#          IF g_fee.fee01 != g_fee_t.fee01 OR g_fee_t.fee01 IS NULL THEN
#             IF g_fah.fahauno = 'Y' AND NOT cl_chk_data_continue(g_fee.fee01[5,10]) THEN
#                CALL cl_err('','9056',0)
#                NEXT FIELD fee01
#             END IF
#             SELECT COUNT(*) INTO l_n FROM fee_file
#              WHERE fee01 = g_fee.fee01
#             IF l_n > 0 THEN   #資料重複
#                CALL cl_err(g_fee.fee01,-239,0)
#                LET g_fee.fee01 = g_fee_t.fee01
#                DISPLAY BY NAME g_fee.fee01
#                NEXT FIELD fee01
#             END IF
#          END IF
#
#No.FUN-550034 ---end--
 
   #FUN-910038---easyflow---add---start---
          IF g_fee.fee01 != g_fee_t.fee01 OR g_fee_t.fee01 IS NULL THEN
             LET g_fee.feemksg = g_fah.fahapr
             DISPLAY BY NAME g_fee.feemksg
             END IF
   #FUN-910038---easyflow---add---end---
 
        END IF
        LET g_fee_o.fee01 = g_fee.fee01
 
   #MOD-9A0136   ---start                                                                                                           
    AFTER FIELD fee02                                                                                                               
       IF NOT cl_null(g_fee.fee02) THEN                                                                                             
          CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate                                                           
          IF g_fee.fee02 < l_bdate                                                                                                  
             THEN CALL cl_err(g_fee.fee02,'afa-130',0)                                                                              
             NEXT FIELD fee02                                                                                                       
          END IF                                                                                                                    
         #FUN-B60140   ---start   Add
          IF g_faa.faa31 = "Y" THEN
             CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
             IF g_fee.fee02 < l_bdate
                THEN CALL cl_err(g_fee.fee02,'afa-130',0)
                NEXT FIELD fee02
             END IF
          END IF
         #FUN-B60140   ---end     Add
       END IF                                                                                                                       
   #MOD-9A0136   ---end      
 
   #No.+206 010612 add by linda
    AFTER FIELD fee05
          IF cl_null(g_fee.fee05) AND g_fee.fee05 NOT MATCHES '[12]'THEN
             NEXT FIELD fee05
          END IF
    #No.+206 END---
 
    AFTER FIELD fee03                       #部門代號
        IF NOT cl_null(g_fee.fee03) THEN
           CALL t305_fee03(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_fee.fee03,g_errno,0)
              LET g_fee.fee03 = g_fee_o.fee03
              DISPLAY BY NAME g_fee.fee03
              NEXT FIELD fee03
           END IF
        END IF
        LET g_fee_o.fee03 = g_fee.fee03
 #FUN-910038---easyflow---add---start
    AFTER FIELD fee07                #申請人
      IF NOT cl_null(g_fee.fee07) THEN
         CALL t305_fee07('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_fee.fee07,g_errno,0)
            LET g_fee.fee07 = g_fee_o.fee07
            DISPLAY BY NAME g_fee.fee07
            NEXT FIELD fee07
         END IF
      END IF
      LET g_fee_o.fee07 = g_fee.fee07
 #FUN-910038---easyflow---add---end---
 
    #FUN-850068     ---start---
    AFTER FIELD feeud01
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud02
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud03
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud04
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud05
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud06
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud07
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud08
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud09
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud10
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud11
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud12
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud13
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud14
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD feeud15
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    #FUN-850068     ----end----
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG                  #欄位說明
 
    ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp #ok
           CASE
            WHEN INFIELD(fee01) #單據編號
                 LET g_t1 = s_get_doc_no(g_fee.fee01)       #No.FUN-550034
                 #CALL q_fah( FALSE, TRUE,g_t1,'E',g_sys) RETURNING g_t1  #TQC-670008
                 CALL q_fah( FALSE, TRUE,g_t1,'E','AFA') RETURNING g_t1   #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
                 LET g_fee.fee01 = g_t1       #No.FUN-550034
                 DISPLAY BY NAME g_fee.fee01
                 NEXT FIELD fee01
            WHEN INFIELD(fee03) #部門代號
                 IF g_fee.fee05='1' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_fee.fee03
                    CALL cl_create_qry() RETURNING g_fee.fee03
#                    CALL FGL_DIALOG_SETBUFFER( g_fee.fee03 )
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc3"
                    LET g_qryparam.default1 = g_fee.fee03
                    CALL cl_create_qry() RETURNING g_fee.fee03
#                    CALL FGL_DIALOG_SETBUFFER( g_fee.fee03 )
                 END IF
                 DISPLAY BY NAME g_fee.fee03
                 CALL t305_fee03('d')
                 NEXT FIELD fee03
            #FUN-910038---easyflow---add---start---
            WHEN INFIELD(fee07) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fee.fee07
                 CALL cl_create_qry() RETURNING g_fee.fee07
                 DISPLAY BY NAME g_fee.fee07
                 NEXT FIELD fee07
            #FUN-910038---easyflow---add---end---
 
           OTHERWISE
                 EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t305_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fee01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t305_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fee01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t305_fee03(p_cmd)  #部門代號
    DEFINE l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti,
           p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
  LET g_errno = " "
  IF g_fee.fee05 ='1' THEN
     SELECT gem02,gemacti INTO l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01 = g_fee.fee03
  ELSE
     SELECT pmc03,pmcacti INTO l_gem02,l_gemacti
       FROM pmc_file
      WHERE pmc01 = g_fee.fee03
  END IF
  CASE WHEN SQLCA.SQLCODE = 100
                       IF g_fee.fee05='1' THEN
                          LET g_errno = 'afa-083'
                       ELSE
                          LET g_errno = 'aom-061'
                       END IF
                       LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
 IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
 END IF
END FUNCTION
 
#Query 查詢
FUNCTION t305_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fee.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fef.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t305_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fee.* TO NULL
        RETURN
    END IF
    OPEN t305_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fee.* TO NULL
    ELSE
        OPEN t305_count
        FETCH t305_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t305_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t305_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t305_cs INTO g_fee.fee01
        WHEN 'P' FETCH PREVIOUS t305_cs INTO g_fee.fee01
        WHEN 'F' FETCH FIRST    t305_cs INTO g_fee.fee01
        WHEN 'L' FETCH LAST     t305_cs INTO g_fee.fee01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t305_cs INTO g_fee.fee01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)
        INITIALIZE g_fee.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fee.* FROM fee_file WHERE fee01 = g_fee.fee01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)      #No.FUN-660127
         CALL cl_err3("sel","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_fee.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fee.feeuser   #FUN-4C0059
    LET g_data_group = g_fee.feegrup   #FUN-4C0059
    CALL t305_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t305_show()
    LET g_fee_t.* = g_fee.*                #保存單頭舊值
    LET g_fee_o.* = g_fee.*                #保存單頭舊值
    DISPLAY BY NAME g_fee.feeoriu,g_fee.feeorig,                              # 顯示單頭值
 
 
        g_fee.fee01,g_fee.fee02,g_fee.fee07,g_fee.fee05,  #FUN-910038 add fee07
        g_fee.fee06,g_fee.feemksg,                        #FUN-910038 add
        g_fee.fee03,g_fee.fee04,g_fee.feeuser,
        g_fee.feegrup,g_fee.feemodu,g_fee.feedate,
        g_fee.feeacti
        #FUN-850068     ---start---
        ,g_fee.feeud01,g_fee.feeud02,g_fee.feeud03,g_fee.feeud04,
        g_fee.feeud05,g_fee.feeud06,g_fee.feeud07,g_fee.feeud08,
        g_fee.feeud09,g_fee.feeud10,g_fee.feeud11,g_fee.feeud12,
        g_fee.feeud13,g_fee.feeud14,g_fee.feeud15,g_fee.feeconf #No.FUN-840241 add feeconf 
        #FUN-850068     ----end----
    #CALL cl_set_field_pic("","","","","",g_fee.feeacti)   #FUN-910038 mark
    CALL t305_field_pic()                                  #FUN-910038 add
    #CALL t305_fee01('d')
    LET g_t1 = s_get_doc_no(g_fee.fee01)       #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t305_fee03('d')
    CALL t305_fee07('d')                    #FUN-910038 add
    CALL t305_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t305_r()
DEFINE l_fef03  LIKE  fef_file.fef03,
       l_fef04  LIKE  fef_file.fef04,
       l_feb12  LIKE  feb_file.feb12
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fee.fee01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_fee.feeacti = 'N' THEN RETURN END IF
    IF g_fee.feeconf = 'X' THEN RETURN END IF  #CHI-C80041
    #No.FUN-840241---Begin
    IF g_fee.feeconf = 'Y' THEN 
       CALL cl_err('','9023',0) 
       RETURN 
    END IF
    #No.FUN-840241---End
    SELECT * INTO g_fee.* FROM fee_file
     WHERE fee01=g_fee.fee01
 
   #FUN-910038---add---start---          #送簽中不可刪除
    IF g_fee.fee06 matches '[Ss]'  THEN
       CALL cl_err('','apm-030', 0)
       RETURN
    END IF
   #FUN-910038---add---end---
 
    BEGIN WORK
 
    OPEN t305_cl USING g_fee.fee01
    IF STATUS THEN
       CALL cl_err("OPEN t305_cl:", STATUS, 1)
       CLOSE t305_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t305_cl INTO g_fee.*                     # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)   #資料被他人LOCK
        CLOSE t305_cl ROLLBACK WORK RETURN
    END IF
    CALL t305_show()
    LET g_success='Y'
    IF cl_delete() THEN                            #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fee01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fee.fee01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                        #No.FUN-9B0098 10/02/24
       DELETE FROM fee_file WHERE fee01 = g_fee.fee01
 
       IF STATUS THEN
#          CALL cl_err('del fee',SQLCA.SQLCODE,0)         #No.FUN-660127
           CALL cl_err3("del","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","del fee",1)  #No.FUN-660127
          LET g_success='N'
       END IF
       IF g_success ='Y' THEN
          DECLARE t305_r CURSOR FOR
              SELECT fef03,fef04 FROM fef_file WHERE fef01=g_fee.fee01
          CALL s_showmsg_init()  #No.FUN-710028
          FOREACH t305_r INTO l_fef03,l_fef04
          #No.FUN-710028 --begin                                                                                                              
             IF g_success='N' THEN                                                                                                         
                LET g_totsuccess='N'                                                                                                       
                LET g_success="Y"                                                                                                          
             END IF                                                                                                                        
          #No.FUN-710028 --end
               #No.FUN-840241---Begin
               #SELECT feb12 INTO l_feb12 FROM feb_file WHERE feb02=l_fef03
               #UPDATE feb_file SET feb12=l_feb12 + l_fef04
               #    WHERE feb02=l_fef03
               #IF SQLCA.sqlcode THEN
#              #   CALL cl_err('upd feb',SQLCA.sqlcode,0)                     #No.FUN-660127
               #   CALL cl_err3("upd","feb_file",l_fef03,"",SQLCA.sqlcode,"","upd feb",1) #No.FUN-660127 #No.FUN-710028
               #   CALL s_errmsg('feb02',l_fef03,'upd feb',SQLCA.sqlcode,1)   #No.FUN-710028
               #   LET g_success='N'
#              #   EXIT FOREACH     #No.FUN-710028 
               #   CONTINUE FOREACH #No.FUN-710028 
               #END IF
               #No.FUN-840241---End
##FUN-530043
               #UPDATE feb_file SET feb09 = feb09 - 1
               #       WHERE feb02 = l_fef03
##END FUN-530043
               #No.FUN-840241---End
          END FOREACH
          #No.FUN-710028 --begin                                                                                                              
          IF g_totsuccess="N" THEN                                                                                                        
             LET g_success="N"                                                                                                            
          END IF                                                                                                                          
          #No.FUN-710028 --end
 
       END IF
       IF g_success ='Y' THEN
          DELETE FROM fef_file WHERE fef01 = g_fee.fee01
          IF STATUS THEN
#            CALL cl_err('del fee',SQLCA.SQLCODE,0)                         #No.FUN-710028
             CALL cl_err3("del","fef_file",g_fee.fee01,"",SQLCA.sqlcode,"","del fee",1)  #No.FUN-660127 #No.FUN-710028
             CALL s_errmsg('fef01',g_fee.fee01,'del fee',SQLCA.sqlcode,1)   #No.FUN-710028
             LET g_success='N'
          END IF
       END IF
    ELSE
       LET g_success = 'N'      #FUN-910038 add g_success='n'不刪除 
    END IF
    CLOSE t305_cl
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       CLEAR FORM
       OPEN t305_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t305_cs
          CLOSE t305_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t305_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t305_cs
          CLOSE t305_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t305_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t305_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t305_fetch('/')
       END IF
       CALL g_fef.clear()
       CALL cl_cmmsg(4)
       COMMIT WORK
       CALL cl_flow_notify(g_fee.fee01,'D')
    END IF
END FUNCTION
 
FUNCTION t305_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_feb06         LIKE feb_file.feb06,
    l_fed04         LIKE fed_file.fed04,
    l_fef04         LIKE fef_file.fef04,
    l_sum           LIKE type_file.chr6,                #歸還數量的總和       #No.FUN-680070 VARCHAR(06)
    l_feb12_t       LIKE feb_file.feb12,
    l_feb12         LIKE feb_file.feb12,
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否       #No.FUN-680070 SMALLINT
    l_count         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_fec03         LIKE fec_file.fec03,    #MOD-570160
    l_fee06         LIKE fee_file.fee06     #FUN-910038 add
DEFINE l_fecconf    LIKE fec_file.fecconf        #No.FUN-840241
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_fee.fee01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_fee.* FROM fee_file
     WHERE fee01=g_fee.fee01
 
    LET l_fee06 = g_fee.fee06    #FUN-910038 add
    IF g_fee.feeacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fee.fee01,'mfg1000',0)
        RETURN
    END IF
 
  #FUN-910038---add---start---          #送簽中不可更改單身資料
   IF g_fee.fee06 matches '[Ss]'  THEN
        CALL cl_err('','apm-030', 0)
        RETURN
   END IF
  #FUN-910038---add---end---
 
    IF g_fee.feeconf = 'Y' THEN CALL cl_err('','apm-242',0) RETURN END IF #No.FUN-840241
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fef02,fef03,'',fef05,fef04 ",
                       " FROM fef_file  ",
                       " WHERE fef01=? ",
                       " AND fef02  =? ",
                       " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t305_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fef.clear() END IF
 
 
        INPUT ARRAY g_fef WITHOUT DEFAULTS FROM s_fef.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_docno_format("fef05")   #No.FUN-550034
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fef_t.* = g_fef[l_ac].*  #BACKUP
           #LET g_fef_o.* = g_fef[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t305_cl USING g_fee.fee01
            IF STATUS THEN
               CALL cl_err("OPEN t305_cl:", STATUS, 1)
               CLOSE t305_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t305_cl INTO g_fee.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t305_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
            #IF g_fef_t.fef02 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_fef_t.* = g_fef[l_ac].*  #BACKUP
                LET g_fef_o.* = g_fef[l_ac].*  #No.TQC-970404
 
                OPEN t305_bcl USING g_fee.fee01,g_fef_t.fef02
                IF STATUS THEN
                   CALL cl_err("OPEN t305_bcl:", STATUS, 1)
                   CLOSE t305_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t305_bcl INTO g_fef[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fef_t.fef02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       SELECT fea02 INTO g_fef[l_ac].fea02 FROM fea_file
                        WHERE fea01=(SELECT feb01 FROM feb_file
                                      WHERE feb02=g_fef[l_ac].fef03)
 
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD fef02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fef[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fef[l_ac].* TO s_fef.*
              CALL g_fef.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO fef_file(fef01,fef02,fef03,fef04,fef05
                                #No.FUN-850068 --start--
                                ,fefud01,fefud02,fefud03,fefud04,fefud05,
                                fefud06,fefud07,fefud08,fefud09,fefud10,
                                fefud11,fefud12,fefud13,fefud14,fefud15,
                                #No.FUN-850068 ---end---
                                feflegal) #FUN-980003 add
            VALUES(g_fee.fee01,g_fef[l_ac].fef02,
                   g_fef[l_ac].fef03,g_fef[l_ac].fef04,
                   g_fef[l_ac].fef05
                   #No.FUN-850068 --start--
                   ,g_fef[l_ac].fefud01,g_fef[l_ac].fefud02,g_fef[l_ac].fefud03,
                   g_fef[l_ac].fefud04,g_fef[l_ac].fefud05,g_fef[l_ac].fefud06,
                   g_fef[l_ac].fefud07,g_fef[l_ac].fefud08,g_fef[l_ac].fefud09,
                   g_fef[l_ac].fefud10,g_fef[l_ac].fefud11,g_fef[l_ac].fefud12,
                   g_fef[l_ac].fefud13,g_fef[l_ac].fefud14,g_fef[l_ac].fefud15,
                   #No.FUN-850068 ---end---
                   g_legal) #FUN-980003 add
#No.FUN-840241---Begin
##FUN-530043
#            SELECT COUNT(*) INTO l_count
#                   FROM fef_file WHERE fef03 = g_fef[l_ac].fef03
#            UPDATE feb_file SET feb09 = l_count WHERE feb02 = g_fef[l_ac].fef03
##END FUN-530043
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
##               CALL cl_err(g_fef[l_ac].fef02,SQLCA.sqlcode,0)    #No.FUN-660127
#                CALL cl_err3("upd","feb_file",g_fef[l_ac].fef03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
#              #LET g_fef[l_ac].* = g_fef_t.*
#               CANCEL INSERT
#            ELSE
             
             # SELECT feb12 INTO l_feb12_t FROM feb_file
             #  WHERE feb02=g_fef[l_ac].fef03
             # IF l_feb12_t IS NULL THEN LET l_feb12_t = 0 END IF
             # UPDATE feb_file SET feb12=l_feb12_t-g_fef[l_ac].fef04
             #  WHERE feb02=g_fef[l_ac].fef03
             # IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#            #     CALL cl_err(g_fef[l_ac].fef03,SQLCA.sqlcode,0)    #No.FUN-660127
             #     CALL cl_err3("upd","feb_file",g_fef[l_ac].fef03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
             #    LET g_fef[l_ac].* = g_fef_t.*
             # ELSE
             #No.FUN-840241---End
                 MESSAGE 'INSERT O.K'
                 LET l_fee06 = '0'     #FUN-910038 add 
                LET g_rec_b=g_rec_b+1
             #    COMMIT WORK                      #No.FUN-840241
                 DISPLAY g_rec_b TO FORMONLY.cn2
             # END IF                              #No.FUN-840241
            #END IF
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fef[l_ac].* TO NULL      #900423
            LET g_fef[l_ac].fef04=0
            LET g_fef_t.* = g_fef[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            IF g_fef[l_ac].fef02 IS NULL OR
               g_fef[l_ac].fef02 = 0 THEN
                SELECT max(fef02)+1 INTO g_fef[l_ac].fef02 FROM fef_file
                 WHERE fef01 = g_fee.fee01
                IF g_fef[l_ac].fef02 IS NULL THEN
                    LET g_fef[l_ac].fef02 = 1
                END IF
            END IF
           #NEXT FIELD fef02
 
        BEFORE FIELD fef02                        #default 序號
 
        AFTER FIELD fef02                        #check 序號是否重複
            IF NOT cl_null(g_fef[l_ac].fef02) THEN
               IF g_fef[l_ac].fef02 != g_fef_t.fef02 OR
                  g_fef_t.fef02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fef_file
                    WHERE fef01 = g_fee.fee01 AND fef02 = g_fef[l_ac].fef02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fef[l_ac].fef02 = g_fef_t.fef02
                       NEXT FIELD fef02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fef03                  #模具編號
            IF NOT cl_null(g_fef[l_ac].fef03) THEN
                IF g_fef_t.fef03 IS NULL OR (g_fef[l_ac].fef03 != g_fef_t.fef03)  THEN #MOD-530668
                  SELECT COUNT(*) INTO l_cnt FROM fef_file  #檢查重複用
                   WHERE fef01=g_fee.fee01 AND fef03=g_fef[l_ac].fef03
                    # AND fef02!=g_fef[l_ac].fef02
                  IF l_cnt> 0 THEN
                     CALL cl_err(g_fef[l_ac].fef03,'afa-906',0)
                     NEXT FIELD fef03
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM feb_file   #check存在feb
                   WHERE feb02=g_fef[l_ac].fef03
                  IF l_cnt=0 THEN
                     CALL cl_err('','afa-907',0) NEXT FIELD fef03 END IF
                  CALL t305_fef03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fef[l_ac].fef03,g_errno,0)
                     LET g_fef[l_ac].fef03 = g_fef_o.fef03
                     DISPLAY g_fef[l_ac].fef03 TO fef03
                     NEXT FIELD fef03
                  END IF
                END IF
             END IF
            LET g_fef_o.fef03 = g_fef[l_ac].fef03
 
        AFTER FIELD fef04                          #數量
            IF NOT cl_null(g_fef[l_ac].fef04) THEN
               IF g_fef[l_ac].fef04 <= 0 THEN
                   CALL cl_err('','afa-037',0)
                   NEXT FIELD fef04
               END IF
 
               SELECT fed04 INTO l_fed04 FROM fed_file      #在外領用量
               WHERE fed03 = g_fef[l_ac].fef03 AND fed01=g_fef[l_ac].fef05
               SELECT sum(fef04) INTO l_fef04 FROM fef_file #歸還量
                WHERE fef03 = g_fef[l_ac].fef03 AND fef05=g_fef[l_ac].fef05
 
               IF cl_null(l_fed04) THEN  LET l_fed04=0 END IF
               IF cl_null(l_fef04) THEN  LET l_fef04=0 END IF
               IF cl_null(g_fef_t.fef04) THEN  LET g_fef_t.fef04=0 END IF
               LET l_sum = l_fef04 - g_fef_t.fef04 + g_fef[l_ac].fef04
               IF  l_sum > l_fed04   THEN
                   CALL cl_err('','afa-912',0)
                   NEXT FIELD fef04
               END IF
            END IF
 
        AFTER FIELD fef05                          #領用單號
            IF NOT cl_null(g_fef[l_ac].fef05) THEN
               IF g_fef_o.fef05 IS NULL OR
                  (g_fef[l_ac].fef05 != g_fef_o.fef05) THEN
                  SELECT COUNT(*) INTO l_cnt FROM fef_file  #檢查重複用
                   WHERE fef01=g_fee.fee01 AND fef03=g_fef[l_ac].fef03 AND
                         fef05=g_fef[l_ac].fef05
                  IF l_cnt>0 THEN
                     CALL cl_err(g_fef[l_ac].fef05,'afa-918',0)
                     NEXT FIELD fef05
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM fed_file   #check存在fed
                   WHERE fed01=g_fef[l_ac].fef05
                     AND fed03=g_fef[l_ac].fef03
                  IF l_cnt=0 THEN
                     CALL cl_err('','afa-915',0)
                     NEXT FIELD fef05
                  END IF
               END IF
 #MOD-570160
               SELECT fec03 INTO l_fec03 FROM fec_file
                 WHERE fec01 = g_fef[l_ac].fef05
               IF g_fee.fee03 <> l_fec03 THEN
                  CALL cl_err('','afa-974',0)
                  NEXT FIELD fef05
               END IF
 #END MOD-570160
               #No.FUN-840241---Begin
               SELECT fecconf INTO l_fecconf FROM fec_file
                WHERE fec01 = g_fef[l_ac].fef05
                IF l_fecconf = 'N' THEN
                   CALL cl_err(g_fef[l_ac].fef05,'anm-960',0)
                   NEXT FIELD fef05
                END IF   
               #No.FUN-840241---End
               
            ELSE
               NEXT FIELD fef05
            END IF
 
 
        #No.FUN-850068 --start--
        AFTER FIELD fefud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fefud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
        BEFORE DELETE                            #是否取消單身
            IF g_fef_t.fef02 > 0 AND
               g_fef_t.fef02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fef_file
                 WHERE fef01 = g_fee.fee01 AND
                       fef02 = g_fef_t.fef02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('del fef',SQLCA.sqlcode,0)       #No.FUN-660127
                    CALL cl_err3("del","fef_file",g_fee.fee01,g_fef_t.fef02,SQLCA.sqlcode,"","del fef",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
#No.FUN-840241---Begin
##FUN-530043
#                UPDATE feb_file SET feb09 = feb09 - 1
#                       WHERE feb02 = g_fef[l_ac].fef03
##END FUN-530043
#                SELECT feb12 INTO l_feb12_t FROM feb_file
#                 WHERE feb02 = g_fef_t.fef03
#                UPDATE feb_file SET feb12=l_feb12_t + g_fef_t.fef04
#                 WHERE feb02 = g_fef_t.fef03
#                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                    CALL cl_err('upd feb',SQLCA.sqlcode,0)         #No.FUN-660127
#                     CALL cl_err3("upd","feb_file",g_fef_t.fef03,"",SQLCA.sqlcode,"","upd feb",1)  #No.FUN-660127
#                   ROLLBACK WORK
#                   EXIT INPUT
#                END IF
#No.FUN-840241---End
                LET l_fee06 = '0'      #FUN-910038 add
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fef[l_ac].* = g_fef_t.*
               CLOSE t305_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fef[l_ac].fef02,-263,1)
               LET g_fef[l_ac].* = g_fef_t.*
            ELSE
                UPDATE fef_file SET
                  fef02=g_fef[l_ac].fef02,fef03=g_fef[l_ac].fef03,
                  fef04=g_fef[l_ac].fef04,fef05=g_fef[l_ac].fef05
                  #No.FUN-850068 --start--
                  ,fefud01 = g_fef[l_ac].fefud01,
                  fefud02 = g_fef[l_ac].fefud02,
                  fefud03 = g_fef[l_ac].fefud03,
                  fefud04 = g_fef[l_ac].fefud04,
                  fefud05 = g_fef[l_ac].fefud05,
                  fefud06 = g_fef[l_ac].fefud06,
                  fefud07 = g_fef[l_ac].fefud07,
                  fefud08 = g_fef[l_ac].fefud08,
                  fefud09 = g_fef[l_ac].fefud09,
                  fefud10 = g_fef[l_ac].fefud10,
                  fefud11 = g_fef[l_ac].fefud11,
                  fefud12 = g_fef[l_ac].fefud12,
                  fefud13 = g_fef[l_ac].fefud13,
                  fefud14 = g_fef[l_ac].fefud14,
                  fefud15 = g_fef[l_ac].fefud15
                  #No.FUN-850068 ---end---
                WHERE fef01=g_fee.fee01 AND fef02=g_fef_t.fef02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                   CALL cl_err(g_fef[l_ac].fef02,SQLCA.sqlcode,0)              #No.FUN-660127
                    CALL cl_err3("upd","fef_file",g_fee.fee01,g_fef_t.fef02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   LET g_fef[l_ac].* = g_fef_t.*
                   LET g_success='N'
                   ROLLBACK WORK        #FUN-910038 add 
               ELSE    #FUN-910038   add
                   LET l_fee06 = '0'    #FUN-910038 add
                   MESSAGE 'UPDATE O.K' #FUN-910038 add
                   COMMIT WORK          #FUN-910038 add
               #No.FUN-840241---Begin
               #ELSE
               # SELECT feb12 INTO l_feb12_t FROM feb_file
               #    WHERE feb02=g_fef_t.fef03
               #   IF l_feb12_t IS NULL THEN LET l_feb12_t = 0 END IF
               #   UPDATE feb_file SET feb12=l_feb12_t+g_fef_t.fef04
               #    WHERE feb02=g_fef_t.fef03
               #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#              #       CALL cl_err(g_fef[l_ac].fef03,SQLCA.sqlcode,0)               #No.FUN-660127
               #       CALL cl_err3("upd","feb_file",g_fef_t.fef03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
               #      LET g_fef[l_ac].* = g_fef_t.*
               #      LET g_success='N'
               #   ELSE
               #      SELECT feb12 INTO l_feb12 FROM feb_file
               #       WHERE feb02=g_fef[l_ac].fef03
               #      IF l_feb12 IS NULL THEN LET l_feb12 = 0 END IF
               #      UPDATE feb_file SET feb12=l_feb12-
               #                                g_fef[l_ac].fef04
               #       WHERE feb02=g_fef[l_ac].fef03
               #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#              #          CALL cl_err(g_fef[l_ac].fef03,SQLCA.sqlcode,0)                 #No.FUN-660127
               #          CALL cl_err3("upd","feb_file",g_fef[l_ac].fef03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
               #         LET g_fef[l_ac].* = g_fef_t.*
               #         LET g_success='N'
               #      END IF
               #   END IF
               #No.FUN-840241---END
               #FUN-910038---mark----
               #  IF g_success='Y' THEN
               #     MESSAGE 'UPDATE O.K'
               #     COMMIT WORK
               #  ELSE
               #     ROLLBACK WORK
               #  END IF
               #FUN-910038---mark---
 
               END IF
            END IF
#No.FUN-840241---Begin
##FUN-530043
#            IF g_fef[l_ac].fef03 <> g_fef_t.fef03 THEN
#               UPDATE feb_file SET feb09 = feb09 - 1
#                 WHERE feb02 = g_fef_t.fef03
#               UPDATE feb_file SET feb09 = feb09 + 1
#                 WHERE feb02 = g_fef[l_ac].fef03
#            END IF
##END FUN-530043
#No.FUN-840241---End
        AFTER ROW
            LET l_ac = ARR_CURR()
    #       LET l_ac_t = l_ac      #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
            #FUN-D30032--add--str--
               IF p_cmd='u' THEN
                  LET g_fef[l_ac].* = g_fef_t.*
               ELSE
                  CALL g_fef.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
            #FUN-D30032--add--end--
               CLOSE t305_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
           #LET g_fef_t.* = g_fef[l_ac].*
            CLOSE t305_bcl
            COMMIT WORK
            #CKP2
            CALL g_fef.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fef02) AND l_ac > 1 THEN
                LET g_fef[l_ac].* = g_fef[l_ac-1].*
                LET g_fef[l_ac].fef02 = NULL   #TQC-620018
                NEXT FIELD fef02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fef03) #模具編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_feb"
                 LET g_qryparam.default1 = g_fef[l_ac].fef03
                 CALL cl_create_qry() RETURNING g_fef[l_ac].fef03
#                 CALL FGL_DIALOG_SETBUFFER( g_fef[l_ac].fef03 )
                 DISPLAY g_fef[l_ac].fef03 TO fef03
                 CALL  t305_fef03('d')
                 NEXT FIELD fef03
              WHEN INFIELD(fef05)     #領用單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fed"
                 #LET g_qryparam.default1 = g_fef[l_ac].fef05
                 LET g_qryparam.arg1 = g_fef[l_ac].fef03
                 CALL cl_create_qry() RETURNING g_fef[l_ac].fef05
#                 CALL FGL_DIALOG_SETBUFFER( g_fef[l_ac].fef05 )
                 DISPLAY g_fef[l_ac].fef05 TO fef05
                 NEXT FIELD fef05
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fee.feemodu = g_user
    LET g_fee.feedate = g_today
    UPDATE fee_file SET feemodu=g_fee.feemodu,feedate=g_fee.feedate,fee06=l_fee06   #FUN-910038 add fee06
     WHERE fee01 = g_fee.fee01
    LET g_fee.fee06 = l_fee06      #FUN-910038
    DISPLAY BY NAME g_fee.fee06            #FUN-910038 add
    DISPLAY BY NAME g_fee.feemodu,g_fee.feedate
    CALL t305_field_pic()                  #FUN-910038 add
   #end FUN-5A0029
 
    CLOSE t305_cl
    CLOSE t305_bcl
    COMMIT WORK
    SELECT COUNT(*) INTO l_cnt FROM fef_file WHERE fef01=g_fee.fee01
#CHI-C30002 -------- mark -------- begin
#   IF l_cnt = 0 THEN
#      IF cl_delh(0,0) THEN
#         DELETE FROM fee_file WHERE fee01=g_fee.fee01
#         IF STATUS THEN
#             CALL cl_err('b_del_fee',SQLCA.sqlcode,0)         #No.FUN-660127
#             CALL cl_err3("del","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","b_del_fee",1)  #No.FUN-660127
#         END IF
#      END IF
#   END IF
#CHI-C30002 -------- mark -------- end
    CALL t305_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t305_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fee.fee01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fee_file ",
                  "  WHERE fee01 LIKE '",l_slip,"%' ",
                  "    AND fee01 > '",g_fee.fee01,"'"
      PREPARE t305_pb1 FROM l_sql 
      EXECUTE t305_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t305_v()
         CALL t305_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fee_file WHERE fee01 = g_fee.fee01
         INITIALIZE g_fee.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t305_b_askkey()
DEFINE
#   l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
    l_wc2           STRING        #TQC-630166
 
    CONSTRUCT l_wc2 ON fef02,fef03,fea02,fef05,fef04 # 螢幕上取單身條件
            FROM s_fef[1].fef02,s_fef[1].fef03,s_fef[1].fea02,
                 s_fef[1].fef05,s_fef[1].fef04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t305_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t305_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#   p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
    p_wc2           STRING        #TQC-630166
 
    IF cl_null(p_wc2) THEN LET p_wc2='1=1 ' END IF
    LET g_sql =
        " SELECT fef02,fef03,fea02,fef05,fef04 ",
        #No.FUN-850068 --start--
        "       ,fefud01,fefud02,fefud03,fefud04,fefud05,",
        "       fefud06,fefud07,fefud08,fefud09,fefud10,",
        "       fefud11,fefud12,fefud13,fefud14,fefud15", 
        #No.FUN-850068 ---end---
        " FROM fef_file,feb_file LEFT OUTER JOIN fea_file ON feb01=fea01",
        " WHERE fef03 = feb02 AND fef01 ='",g_fee.fee01,"' AND ",  #單頭
        p_wc2 CLIPPED," ORDER BY 1"  #單身
    PREPARE t305_pb FROM g_sql
    DECLARE fef_cs                       #SCROLL CURSOR
        CURSOR FOR t305_pb
 
    CALL g_fef.clear()
    LET g_rec_b = 0
 
    LET g_cnt = 1
    FOREACH fef_cs INTO g_fef[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fef.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t305_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fef TO s_fef.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t305_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t305_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t305_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t305_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t305_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      #No.FUN-840241---Begin
      ON ACTION confirm                                                         
         LET g_action_choice="confirm"                                          
         EXIT DISPLAY   
      ON ACTION undo_confirm                                                         
         LET g_action_choice="undo_confirm"                                          
         EXIT DISPLAY 
      #No.FUN-840241---End
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end  
 #FUN-910038---easyflow---add---start---
     #ON ACTION EasyFlow送簽
      ON ACTION easyflow_approval            
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
     #@ON ACTION 簽核狀況
      ON ACTION approval_status     
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON ACTION agree   #准
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny    #不准
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow  
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
 #FUN-910038---easyflow---add---end---
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
        #CALL cl_set_field_pic("","","","","",g_fee.feeacti) #FUN-910038 mark
         CALL t305_field_pic()                               #FUN-910038 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t305_fef03(p_cmd)  #模具編號
    DEFINE l_fea02    LIKE fea_file.fea02,
           l_feaacti  LIKE fea_file.feaacti,
           p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fea02,feaacti
      INTO l_fea02,l_feaacti
      FROM fea_file WHERE fea01 =(SELECT feb01 FROM feb_file
                                      WHERE feb02=g_fef[l_ac].fef03)
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-907'
                            LET l_fea02 = NULL
         WHEN l_feaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_fef[l_ac].fea02 = l_fea02
        DISPLAY g_fef[l_ac].fea02 TO fea02
    END IF
END FUNCTION
 
FUNCTION t305_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fee.fee01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
 
  #FUN-910038---add---start---     #送簽中和已核准不可變更無效
   IF g_fee.fee06 matches '[Ss1]'  THEN
        CALL cl_err('','mfg3557', 0)
        RETURN
   END IF
  #FUN-910038---add---end---
    
    #No.FUN-840241---Begin
    IF g_fee.feeconf = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    #No.FUN-840241---End
    
    BEGIN WORK
 
    OPEN t305_cl USING g_fee.fee01
    IF STATUS THEN
       CALL cl_err("OPEN t305_cl:", STATUS, 1)
       CLOSE t305_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t305_cl INTO g_fee.*# 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)#資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t305_show()
    IF cl_exp(0,0,g_fee.feeacti) THEN    #確認一下
        LET g_chr=g_fee.feeacti
        IF g_fee.feeacti='Y' THEN
            LET g_fee.feeacti='N'
            LET g_fee.fee06 = '0'    #FUN-910038 add
        ELSE
            LET g_fee.feeacti='Y'
        END IF
        UPDATE fee_file                    #更改有效碼
            SET feeacti=g_fee.feeacti, fee06=g_fee.fee06    #FUN-910038 add fee06
            WHERE fee01=g_fee.fee01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)         #No.FUN-660127
             CALL cl_err3("upd","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
            LET g_fee.feeacti=g_chr
        END IF
        DISPLAY BY NAME g_fee.feeacti
        DISPLAY BY NAME g_fee.fee06   #FUN-910038 add
    END IF
    CLOSE t305_cl
    COMMIT WORK
 
    #CKP
   #CALL cl_set_field_pic("","","","","",g_fee.feeacti)  #FUN-910038 mark
    CALL t305_field_pic()                                #FUN-910038 add
    CALL cl_flow_notify(g_fee.fee01,'V')
END FUNCTION
 
FUNCTION t305_z()
   DEFINE l_cnt    LIKE type_file.num5    
   DEFINE l_cmd    LIKE type_file.chr1000 
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_fef03  LIKE  fef_file.fef03,
          l_fef04  LIKE  fef_file.fef04,
          l_feb12  LIKE  feb_file.feb12    
 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_fee.fee01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_fee.* FROM fee_file
    WHERE fee01=g_fee.fee01
   IF g_fee.feeconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_fee.feeconf = 'N' THEN CALL cl_err('','9002',0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t305_cl USING g_fee.fee01
   IF STATUS THEN
      CALL cl_err("OPEN t305_cl:", STATUS, 1)
      CLOSE t305_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t305_cl INTO g_fee.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t305_cl ROLLBACK WORK RETURN
   END IF
 
   IF g_success = 'Y' THEN
      LET g_fee.feeconf = 'N'
      LET g_fee.fee06 = '0'       #FUN-910038 add
      UPDATE fee_file SET feeconf = g_fee.feeconf, fee06 = g_fee.fee06 WHERE fee01=g_fee.fee01  #FUN-910038 add fee06
      IF sqlca.sqlcode THEN
         CALL cl_err3("upd","fee_file",g_fee.fee01,"",STATUS,"","upd fee",1) 
         LET g_success='N'
      END IF
      MESSAGE ""
   ELSE
      LET g_fee.feeconf='Y' ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_fee.feeconf
   DISPLAY BY NAME g_fee.fee06    #FUN-910038 add
   IF g_success ='Y' THEN
      DECLARE t305_r1 CURSOR FOR
       SELECT fef03,fef04 FROM fef_file WHERE fef01=g_fee.fee01
       CALL s_showmsg_init()  
       FOREACH t305_r1 INTO l_fef03,l_fef04
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
         SELECT feb12 INTO l_feb12 FROM feb_file WHERE feb02=l_fef03
         UPDATE feb_file SET feb12=l_feb12 + l_fef04
          WHERE feb02=l_fef03
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","feb_file",l_fef03,"",SQLCA.sqlcode,"","upd feb",1) #No.FUN-660127 #No.FUN-710028
             CALL s_errmsg('feb02',l_fef03,'upd feb',SQLCA.sqlcode,1)   #No.FUN-710028
             LET g_success='N'
             CONTINUE FOREACH #No.FUN-710028 
          END IF
          UPDATE feb_file SET feb09 = feb09 - 1
                        WHERE feb02 = l_fef03
      END FOREACH
   END IF
   COMMIT WORK
   CALL cl_set_field_pic("N","","","","","")
   CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
#No.FUN-840241---End
#No.FUN-850024 --COMEBACK START--
##No.FUN-7C0043--start-- 
FUNCTION t305_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fef01       LIKE fef_file.fef01,
        fee02       LIKE fee_file.fee02,
        gem02       LIKE gem_file.gem02,
        fef02       LIKE fef_file.fef02,
        fef03       LIKE fef_file.fef03,
        fea02       LIKE fea_file.fea02,
        fef04       LIKE fef_file.fef04,
        fef05       LIKE fef_file.fef05,
        fee04       LIKE fee_file.fee04
                    END RECORD,
    l_fee03         LIKE fee_file.fee03,
    l_fee05         LIKE fee_file.fee05,
    l_name          LIKE type_file.chr20,               #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #       #No.FUN-680070 VARCHAR(40)
DEFINE        l_wc,l_wc2,l_sql     STRING                       #No.FUN-850024   --add--    
 #MOD-580153
    IF cl_null(g_wc) AND g_cmd = 'a' THEN
       LET g_wc = "fee01 ='",g_fee.fee01,"'"
       LET g_wc2 = "1=1"
    END IF
 #END MOD-580153
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#No.FUN-850024 --ADD START--                                                                                                        
     CALL cl_del_data(l_table)                                                                                                      
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?  ) "                                                                              
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211`
        EXIT PROGRAM                                                                                                                
     END IF                                                                                                                         
#No.FUN-850024 --ADD END--  
#    CALL cl_wait()                                        #No.FUN-850024  MARK
#    CALL cl_outnam('afat305') RETURNING l_name             #No.FUN-850024    MARK
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT fef01,fee02,gem02,fef02,fef03,fea02,fef04,fef05,fee04",
              "       ,fee03,fee05 ",
              " FROM fea_file,feb_file,fee_file LEFT OUTER JOIN gem_file ON fee03=gem01,fef_file ",
              " WHERE fee01 = fef01 ",
              "   AND feb02 = fef03 ",
              "   AND fea01 = feb01 ",
              "   AND feeconf <> 'X' ",  #CHI-C80041
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,4 "
 
    PREPARE t305_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t305_co                         # SCROLL CURSOR
         CURSOR FOR t305_p1
 
#    START REPORT t305_rep TO l_name     #No.FUN-850024  --MARK--  
 
    FOREACH t305_co INTO sr.*,l_fee03,l_fee05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_fee05='2' THEN
           SELECT pmc03 INTO sr.gem02
             FROM pmc_file
           WHERE pmc01=l_fee03
        END IF
#        OUTPUT TO REPORT t305_rep(sr.*)    #No.FUN-850024  --MARK--  
#No.FUN-850024  --ADD START-- 
     EXECUTE  insert_prep  USING                                                                                                    
          sr.fef01,sr.fee02,sr.gem02,sr.fef02,sr.fef03,                                                                             
          sr.fea02,sr.fef04,sr.fef05,sr.fee04     
 
    END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   LET g_str = ''                                                                                                                   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(g_wc,'fee01')                                                                                                   
           RETURNING l_wc                                                                                                           
      LET g_str = l_wc                                                                                                              
   END IF                                                                                                                           
   LET g_str = g_str                                                                                                                
   CALL cl_prt_cs3('afat305','afat305',l_sql,g_str)                                                                                 
#No.FUN-850024  --ADD END-- 
#No.FUN-850024  --MARK START--    
#   FINISH REPORT t305_rep
 
#   CLOSE t305_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t305_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#   l_flag          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#   l_sql1          LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
#   l_sql1          STRING,        #TQC-630166
#   l_i 
#No.FUN-850024 --REMARK:本單進入前已有部分程序丟失，但不影響報表轉CR！
#No.FUN-850024  --MARK END--         
#FUN-910038---easyflow---add---start
FUNCTION t305_ef()
 
  CALL t305sub_y_chk(g_fee.fee01)
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()                            #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
   IF aws_efcli2(base.TypeInfo.create(g_fee),base.TypeInfo.create(g_fef) ,'','','','')
   THEN
      LET g_success = 'Y'
      LET g_fee.fee06 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_fee.fee06
   ELSE
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION t305_fee07(p_cmd)  #人員代號
   DEFINE p_cmd     LIKE type_file.chr1,        
          l_gen02   LIKE gen_file.gen02,
          l_genacti LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,genacti
          INTO l_gen02,l_genacti
          FROM gen_file WHERE gen01 = g_fee.fee07
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                           LET l_gen02 = NULL
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02  
   END IF
END FUNCTION
 
FUNCTION t305_field_pic()
DEFINE l_void  LIKE  type_file.chr1  #CHI-C80041

    LET g_approve=NULL
    IF g_fee.fee06 MATCHES '[1]' THEN
       LET g_approve='Y'
    ELSE
       LET g_approve='N'
    END IF
    #CHI-C80041---begin
    IF g_fee.feeconf = 'X' THEN
       LET l_void = 'Y'
    ELSE
       LET l_void = 'N'
    END IF 
    #CHI-C80041---end
    #CALL cl_set_field_pic("",g_approve,"","","",g_fee.feeacti)  #CHI-C80041
    CALL cl_set_field_pic(g_fee.feeconf,g_approve,"","",l_void,g_fee.feeacti)  #CHI-C80041
 
END FUNCTION
#FUN-910038---easyflow---add---end---
#CHI-C80041---begin
FUNCTION t305_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_fee.fee01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t305_cl USING g_fee.fee01
   IF STATUS THEN
      CALL cl_err("OPEN t305_cl:", STATUS, 1)
      CLOSE t305_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t305_cl INTO g_fee.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fee.fee01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t305_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_fee.feeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_fee.feeconf)   THEN 
        LET l_chr=g_fee.feeconf
        IF g_fee.feeconf='N' THEN 
            LET g_fee.feeconf='X' 
        ELSE
            LET g_fee.feeconf='N'
        END IF
        UPDATE fee_file
            SET feeconf=g_fee.feeconf,  
                feemodu=g_user,
                feedate=g_today
            WHERE fee01=g_fee.fee01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fee_file",g_fee.fee01,"",SQLCA.sqlcode,"","",1)  
            LET g_fee.feeconf=l_chr 
        END IF
        DISPLAY BY NAME g_fee.feeconf 
   END IF
 
   CLOSE t305_cl
   COMMIT WORK
   CALL cl_flow_notify(g_fee.fee01,'V')
 
END FUNCTION
#CHI-C80041---end
