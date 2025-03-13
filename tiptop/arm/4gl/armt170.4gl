# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt170.4gl
# Descriptions...: RMA轉銷退單作業
# Date & Author..: 98/05/07 plum
# Modify.........: 03/08/22 By Wiky Bugno:7690 轉銷退單時 ,無法帶出單身資料
# Modify.........: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-560014 05/06/10 By wujie 單據編號修改
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.MOD-590284 05/11/23 By Mandy 拋轉銷退單不成功
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-590006 05/11/25 BY yiting 新增一筆,執行更改動作再查詢沒有資料
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.TQC-630149 06/03/15 By  RMA單號^P查無單號
# Modify.........: No.MOD-640452 06/04/18 By Sarah 依雙單位參數給相關值,找不到出貨單,oha09='5'
# Modify.........: No.MOD-640551 06/04/24 By Alexstar 若未輸入單身資料，取消單頭資料 
# Modify.........: No.FUN-640232 06/04/24 By Alexstar 新增刪除資料功能
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-690052 06/12/06 By Claire 僅產生銷退單
# Modify.........: No.TQC-6A0018 06/12/06 By Claire "[3]"->'[3]'
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760040 07/06/05 By Mandy 自動產生單身資料進入單身後會出現-239的err
# Modify.........: No.MOD-770022 07/07/06 By Smapmin 修改開窗所帶的變數
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/24 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-860018 08/06/18 BY TSD.lucasyeh 轉Crystal Report
# Modify.........: No.FUN-890102 08/09/23 By baofei  CR 追單到31區
# Modify.........: No.MOD-920159 09/02/11 By chenyu 剛拋轉過去的銷退單，賬單編號置為空值
# Modify.........: No.MOD-920172 09/02/12 By chenyu 拋轉過去的出貨單，ohb16不能直接給0，要用ohb12*ohb15_fac
# Modify.........: No.MOD-920175 09/02/12 By chenyu 拋轉過去的出貨單，ohb61應該根據出貨單中的檢驗否賦值
# Modify.........: No.MOD-950064 09/05/27 By Smapmin 當有客訴單但沒有出貨單號時,也要抓取客戶主檔的資料defalut到銷退單
#                                                    補上有些欄位沒給預設值
#                                                    銷退方式改為一律為銷退折讓
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/09/08 by huangtao 
# Modify.........: No.TQC-AA0102 10/10/18 By zhangll 修正查询问题
# Modify.........: No.TQC-AA0108 10/10/19 By zhangll 修正审核产生销退单处单别判断错误
# Modify.........: No.TQC-AA0110 10/10/20 By zhangll ohb71非空栏位赋值
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70070 11/07/08 By Vampire 註解 CALL s_check_no()
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:CHI-B70039 11/08/17 By johung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-BB0085 11/12/20 By xianghui 增加數量欄位小數取位
# Modify.........: No:MOD-C30894 12/04/02 By Elise l_ohb.ohb05_fac(銷售/庫存單位換算率)為空值時，單位換算率預設給1
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:MOD-B90097 12/07/03 By Elise 成功寫入oha_file後rma19要回壓g_today 
# Modify.........: No:MOD-C70071 12/07/06 By Sakura 取消確認時，加判斷，需為確認狀態才可取消確認
# Modify.........: No:FUN-CB0087 12/12/20 By qiull 庫存單據理由碼改善
# Modify.........: No:MOD-D30151 13/03/19 By ck2yaun 重抓oaz52,oaz70資料
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rml   RECORD LIKE rml_file.*,
    l_rmp   RECORD LIKE rmp_file.*,
    t_rmp   RECORD
            rmp01      LIKE rmp_file.rmp01,
            rmp05      LIKE rmp_file.rmp05,
            rmp03      LIKE rmp_file.rmp03,
            rmp11      LIKE rmp_file.rmp11,
            rmp10      LIKE rmp_file.rmp10,
            rmc03      LIKE rmc_file.rmc03,
            rmp04      LIKE rmp_file.rmp04,
            rmp07      LIKE rmp_file.rmp07,
            rmp08      LIKE rmp_file.rmp08
            END RECORD,
    g_rml_t RECORD LIKE rml_file.*,
    g_rml_o RECORD LIKE rml_file.*,
    g_rmf   RECORD LIKE rmf_file.*,
    l_rmp14         LIKE rmp_file.rmp14,
    g_rma03         LIKE rma_file.rma03,
    g_rma04         LIKE rma_file.rma04,
    g_rmp_paconfo   LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #頁數
    g_rmp02    LIKE rmp_file.rmp02,
    g_rml01_t  LIKE rml_file.rml01,
    g_rmp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp07     LIKE rmp_file.rmp07
                  #FUN-840068 --start---
                   ,rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmp_t         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp07     LIKE rmp_file.rmp07
                  #FUN-840068 --start---
                   ,rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmp_o         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp07     LIKE rmp_file.rmp07
                  #FUN-840068 --start---
                   ,rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
    
             g_wc,g_wc2,g_sql,g_wc3,w_sql   string,  #No.FUN-580092 HCN
    g_t,g_t1        LIKE oay_file.oayslip,      #No.FUN-550064  #No.FUN-690010 VARCHAR(5)
    p_cmd,g_auto,g_err LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_rmp10         LIKE rmp_file.rmp10,
    g_cmd           LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_tmp           LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    g_count,g_cnt1  LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_cn            LIKE type_file.num5     #No.FUN-690010 SMALLINT               #符合單身條件筆數
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1	        LIKE rml_file.rml01    #No.FUN-690010 VARCHAR(16) #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE g_ivalue_rml01   LIKE rml_file.rml01 #MOD-640551
DEFINE g_ivalue_rml03   LIKE rml_file.rml03 #MOD-640551
DEFINE g_str, l_table   STRING              #No.FUN-860018 add FOR C.R.
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0085
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
  
    LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
    #No.FUN-860018 add---start                                                                                                      
    ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                         
    LET g_sql = "rml01.rml_file.rml01,",                                                                                            
                "rml03.rml_file.rml03,",                                                                                            
                "rml02.rml_file.rml02,",                                                                                            
                "rma03.rma_file.rma03,",                                                                                            
                "rma04.rma_file.rma04,",                                                                                            
                "rma13.rma_file.rma13,",                                                                                            
                "gen02.gen_file.gen02,",                                                                                            
                "rma16.rma_file.rma16,",                                                                                            
                "rmp11.rmp_file.rmp11,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "rmp07.rmp_file.rmp07"                                                                                              
                                         #12 items                                                                                  
    LET l_table = cl_prt_temptable('armt170',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                         
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,? )"                                                                               
    PREPARE insert_prep FROM g_sql            
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
    #------------------------------ CR (1) ------------------------------#                                                          
    #No.FUN-860018 add---end  
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_rmp_paconfo = 1                   #現在單身頁次
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW t170_w AT p_row,p_col WITH FORM "arm/42f/armt170"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_forupd_sql =
     "SELECT * FROM rml_file WHERE rml01 = ? AND rml03 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t170_cl CURSOR FROM g_forupd_sql
 
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t170_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t170_a()
             END IF
          OTHERWISE 
                CALL t170_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
    CALL t170_menu()
    CLOSE WINDOW t170_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t170_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                             #清除畫面
  CALL g_rmp.clear()
  IF cl_null(g_argv1) THEN   #FUN-4A0081
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rml.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rml01,rml03,rml04,rml02,rmlconf,rmluser,rmlgrup,rmlmodu,rmldate,rmlvoid,
      #FUN-840068   ---start---
        rmlud01,rmlud02,rmlud03,rmlud04,rmlud05,
        rmlud06,rmlud07,rmlud08,rmlud09,rmlud10,
        rmlud11,rmlud12,rmlud13,rmlud14,rmlud15
      #FUN-840068    ----end----
 
          #--No.MOD-4A0248--------
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
           ON ACTION CONTROLP
           CASE WHEN INFIELD(rml01) #RMA單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_rml"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rml01
                     NEXT FIELD rml01
           OTHERWISE EXIT CASE
           END CASE
         #--END---------------
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
 
    CONSTRUCT g_wc2 ON rmp02,rmp06,rmp11,rmp13,rmp12,rmp07
                   #No.FUN-840068 --start--
                      ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                      ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                      ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                   #No.FUN-840068 ---end---
         FROM s_rmp[1].rmp02, s_rmp[1].rmp06, s_rmp[1].rmp11,
              s_rmp[1].rmp13, s_rmp[1].rmp12, s_rmp[1].rmp07
           #No.FUN-840068 --start--
             ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
             ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
             ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
             ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
             ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
           #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
  #FUN-4A0081
  ELSE
      LET g_wc =" rml01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
  #--
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmluser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmlgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmlgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmluser', 'rmlgrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
      #LET g_sql = "SELECT rml01 FROM rml_file",
       LET g_sql = "SELECT rml01,rml03 FROM rml_file",  #No.TQC-AA0102
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rml01"
     ELSE                                         # 若單身有輸入條件
      #LET g_sql = "SELECT UNIQUE rml01 ",
       LET g_sql = "SELECT UNIQUE rml01,rml03 ",  #No.TQC-AA0102
                   "  FROM rml_file, rmp_file",
                   " WHERE rml01 = rmp01 AND rmp00='2' ",
                   "   AND rml03 = rmp011 ", #MOD-590006
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rml01"
    END IF
    PREPARE t170_prepare FROM g_sql
    DECLARE t170_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t170_prepare
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rml_file WHERE ",g_wc CLIPPED
    ELSE
       #LET g_sql="SELECT COUNT(DISTINCT rml01) FROM rml_file,rmp_file WHERE ",
        LET g_sql="SELECT COUNT(DISTINCT rml01,rml03) FROM rml_file,rmp_file WHERE ",  #No.TQC-AA0102
                  "rmp01=rml01 AND ",g_wc CLIPPED," AND ", g_wc2 CLIPPED
    END IF
    PREPARE t170_precount FROM g_sql
    DECLARE t170_count CURSOR FOR t170_precount
END FUNCTION
 
FUNCTION t170_menu()
 
   WHILE TRUE
      CALL t170_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t170_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t170_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t170_u()
            END IF
         #FUN-640232
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t170_r()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t170_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t170_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output "
            IF cl_chk_act_auth() THEN
               CALL t170_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            CALL t170_y()
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            CALL t170_z()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmp),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                #IF g_rml.rml01 IS NOT NULL THEN
                 IF g_rml.rml01 IS NOT NULL AND g_rml.rml03 IS NOT NULL THEN  #No.TQC-AA0102
                    LET g_doc.column1 = "rml01"
                    LET g_doc.value1 = g_rml.rml01
                    #TQC-AA0102---add begin
                    LET g_doc.column1 = "rml03"
                    LET g_doc.value1 = g_rml.rml03
                    #TQC-AA0102---add end
                    CALL cl_doc()
                 END IF
              END IF
         #No.FUN-6A0018-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t170_a()
    DEFINE    g_i      LIKE type_file.num10         #No.FUN-690010 INTEGER
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rmp.clear()
    LET g_wc=NULL
    LET g_wc2=NULL
    INITIALIZE g_rml.* TO NULL
    LET g_rml_o.* = g_rml.*
    LET g_rml01_t = NULL
    CALL cl_opmsg('a')
   #SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_rmz.rmz10
    WHILE TRUE
        INITIALIZE g_rml.* TO NULL
        LET g_auto="N"
        LET g_success = 'Y'
        LET g_rml.rml02  =g_today
        LET g_rml.rmlconf='N'
        LET g_rml.rmlpost='N'
        LET g_rml.rmlvoid="Y"
        LET g_rml.rmluser=g_user
        LET g_rml.rmloriu = g_user #FUN-980030
        LET g_rml.rmlorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_rml.rmlgrup=g_grup
        LET g_rml.rmldate=g_today
        LET p_cmd="a"
        BEGIN WORK
        CALL t170_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 #CALL cl_err('',9044,0)  #CHI-C30002 mark
           EXIT WHILE
        END IF
        IF g_rml.rml01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK  #No:7876
 
      #No.FUN-560014--begin
#       IF g_oay.oayauno='Y' THEN
#           CALL s_armauno(g_rml.rml01,g_today) RETURNING g_i,g_rml.rml01
#           IF g_i THEN CONTINUE WHILE END IF       #有問題
#           DISPLAY BY NAME g_rml.rml01
#       END IF
      #No.FUN-560014--end
 
        LET g_rml.rmlplant = g_plant #FUN-980007
        LET g_rml.rmllegal = g_legal #FUN-980007
 
        INSERT INTO rml_file VALUES (g_rml.*)
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
           LET  g_success = 'N'
  #         CALL cl_err(g_rml.rml01,STATUS,1)# FUN-660111 
           CALL cl_err3("ins","rml_file",g_rml.rml01,g_rml.rml03,STATUS,"","",1) #FUN-660111
           ROLLBACK WORK  #No:7876
           EXIT  WHILE
        ELSE
           CALL cl_flow_notify(g_rml.rml01,'I')
           COMMIT WORK    #No:7876
        END IF
        LET g_ivalue_rml01=g_rml.rml01   #MOD-640551
        LET g_ivalue_rml03=g_rml.rml03   #MOD-640551
 
        CALL g_rmp.clear()
       #由 RMA單(rmc)依單頭所輸入: rml03 (rmp01) 產生單身:rmp
        IF cl_confirm('aap-701') THEN
          CALL t170_g_b()
          IF g_rec_b=0 OR g_success="N" THEN ROLLBACK WORK CONTINUE WHILE END IF
          LET g_auto='Y'
        END IF
        LET g_rml_t.* = g_rml.*
        SELECT rml01 INTO g_rml.rml01 FROM rml_file
               WHERE rml01=g_rml_t.rml01 AND rml03=g_rml_t.rml03
       #LET g_rec_b=0                   #No.FUN-680064 #TQC-760040 mark 
        CALL t170_b()                   #單身的conf
        IF INT_FLAG THEN
           LET INT_FLAG=0
#          CALL cl_err('',9044,0)  #CHI-C30002    #此處並沒有進行刪除單頭的動作，故将提示mark
           CLEAR FORM
           CALL g_rmp.clear()
           CALL t170_show()
           EXIT WHILE
        END IF
        IF g_success="N" OR g_rec_b = 0 THEN
           ROLLBACK WORK
#          CALL cl_err('',9044,0)  #CHI-C30002 mark
           IF cl_confirm("9042") THEN   #CHI-C30002 add
           #MOD-640551---start--- 
           DELETE FROM rml_file WHERE rml01= g_rml.rml01 AND rml03= g_rml.rml03  
           #MOD-640551---end---
           END IF #CHI-C30002 add
        ELSE
            COMMIT WORK
           #CALL cl_msgany(0,0,'新增OK!')
        END IF
       #INITIALIZE g_rml.* TO NULL
       #CALL t170_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
#由RMA單(rmp)依單頭所輸入的:rml01產生符合的單身(rmc01=rml01 and
#     rmc23 is null and rmc14 matches "012" )
FUNCTION t170_g_b()
    DEFINE g_n   LIKE type_file.num5    #No.FUN-690010 smallint
 
       LET g_sql =" SELECT '2','','','','','',rmc01,rmc02, ",
                  " rmc31-rmc311-rmc312-rmc313,0,'',rmc14,rmc04, ",
                  " rmc05,rmc06,rmc061,rmc07 ",
                  " FROM rmc_file,rma_file ",
                  " WHERE rmc01='",g_rml.rml01,"' AND rmc23 IS NULL",
                  "   AND rmc04 != 'MISC' AND rma01=rmc01 ",
                  "   AND rmc14 IN ('3') ",  #CHI-690052 add #TQC-6A0018
                  "   AND rmaconf='Y' AND rmavoid='Y' ORDER BY rmc02 "
 
    PREPARE t170_rmppb FROM g_sql
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('pre1:',SQLCA.sqlcode,0)
       LET g_success="N"
       RETURN
    END IF
    DECLARE rmc_curs                       #SCROLL CURSOR
        CURSOR FOR t170_rmppb
 
    LET g_cnt = 1
    LET g_rec_b = 0
    INITIALIZE l_rmp.* TO NULL
    FOREACH rmc_curs INTO l_rmp.*          #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        ELSE
           LET g_n=0
           SELECT COUNT(*) INTO g_n FROM rml_file,rmp_file
               WHERE rmp01 <> g_rml.rml01  AND rmp011 <> g_rml.rml03
                 AND rmp01=rml01 AND rmp011=rml03 AND rmlvoid='Y'
                 AND rmp00='1' AND rmp05=l_rmp.rmp05
                 AND rmp06=l_rmp.rmp06 AND rmlvoid='Y'
           IF g_n >= 1 THEN CONTINUE FOREACH END IF
           IF l_rmp.rmp07 IS NULL THEN LET l_rmp.rmp07=0 END IF
           #NO.TQC-790003 start--
           IF cl_null(l_rmp.rmp01) THEN LET l_rmp.rmp01 = ' ' END IF
           IF cl_null(l_rmp.rmp011) THEN LET l_rmp.rmp011 = 0 END IF
           IF cl_null(l_rmp.rmp02) THEN LET l_rmp.rmp02 = 0 END IF
           #no.TQC-790003 end----
           INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,rmp05,
                                rmp06,rmp07,rmp08,rmp09,rmp10,rmp11,rmp12,
                                rmp13,rmp14,rmp15,rmp909, #No.MOD-470041
                                rmpplant,rmplegal)       #FUN-980007
           VALUES ('2',g_rml.rml01,g_rml.rml03,g_cnt,'','',l_rmp.rmp05,
                   l_rmp.rmp06, l_rmp.rmp07,0,'',l_rmp.rmp10,l_rmp.rmp11,
                   l_rmp.rmp12,l_rmp.rmp13,l_rmp.rmp14,l_rmp.rmp15,'',
                   g_plant,g_legal) #FUN-980007
 
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
 #             CALL cl_err('ins rmp',STATUS,1)# FUN-660111 
              CALL cl_err3("ins","rmp_file",g_rml.rml01,g_rml.rml03,STATUS,"","ins rmp",1) #FUN-660111
              ROLLBACK WORK
              LET g_success="N"
              EXIT FOREACH
           END IF
           LET g_rec_b = g_rec_b + 1
           LET g_cnt = g_cnt + 1
        END IF
    END FOREACH
    IF g_rec_b =0 THEN
       CALL cl_err('body: ','aap-129',0)
       LET g_success="N"
       ROLLBACK WORK
       #MOD-640551---start---
       DELETE FROM rml_file WHERE rml01= g_ivalue_rml01 AND rml03= g_ivalue_rml03
       #MOD-640551---end---
       RETURN
    ELSE
       IF g_success="N" THEN
          ROLLBACK WORK
          RETURN
       ELSE
          COMMIT WORK
       END IF
    END IF
    CALL t170_b_fill(" 1=1")
    LET g_rmp_paconfo = 0
END FUNCTION
 
#處理INPUT
FUNCTION t170_i(r_cmd)
 DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE r_cmd        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),              #a:輸入 u:更改
         g_t          LIKE type_file.chr5,    #No.FUN-690010 VARCHAR(5),               #No.FUN-550064
         g_tmp  LIKE rmc_file.rmc02
 
    DISPLAY BY NAME g_rml.rml01,g_rml.rml03, g_rml.rml04,g_rml.rml02,g_rml.rmlconf,
                    g_rml.rmluser,g_rml.rmlgrup,g_rml.rmlmodu,g_rml.rmldate,
                    g_rml.rmlvoid
                  #FUN-840068     ---start---
                   ,g_rml.rmlud01,g_rml.rmlud02,g_rml.rmlud03,g_rml.rmlud04,
                    g_rml.rmlud05,g_rml.rmlud06,g_rml.rmlud07,g_rml.rmlud08,
                    g_rml.rmlud09,g_rml.rmlud10,g_rml.rmlud11,g_rml.rmlud12,
                    g_rml.rmlud13,g_rml.rmlud14,g_rml.rmlud15 
                  #FUN-840068     ----end----
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME   g_rml.rml01,g_rml.rml03, g_rml.rml02,g_rml.rmloriu,g_rml.rmlorig,
                  #FUN-840068     ---start---
                    g_rml.rmlud01,g_rml.rmlud02,g_rml.rmlud03,g_rml.rmlud04,
                    g_rml.rmlud05,g_rml.rmlud06,g_rml.rmlud07,g_rml.rmlud08,
                    g_rml.rmlud09,g_rml.rmlud10,g_rml.rmlud11,g_rml.rmlud12,
                    g_rml.rmlud13,g_rml.rmlud14,g_rml.rmlud15 
                  #FUN-840068     ----end----
                    WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t170_set_entry(r_cmd)
           CALL t170_set_no_entry(r_cmd)
           LET g_before_input_done = TRUE
 
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rml01")
         #No.FUN-550064 ---end---
 
        AFTER FIELD rml01           #RMA 銷退單號=RMA單號
        #No.FUN-550064 --start--
         IF g_rml.rml01 != g_rml01_t OR g_rml01_t IS NULL THEN
#           CALL s_check_no("axm",g_rml.rml01,"","70","","","")
#MOD-B70070 --- mark --- start ---
#           CALL s_check_no("arm",g_rml.rml01,g_rml_o.rml01,"70","","","")  #No.FUN-560014  #FUN-A70130 modify
#           RETURNING li_result,g_rml.rml01
#           DISPLAY BY NAME g_rml.rml01
#           IF (NOT li_result) THEN
#              LET g_rml.rml01=g_rml_o.rml01
#              NEXT FIELD rml01
#           END IF
#MOD-B70070 --- mark ---  end   ---
 
#           IF NOT cl_null(g_rml.rml01) THEN
#               LET g_t=g_rml.rml01[1,3]
#               CALL s_axmslip(g_t,'70',g_sys)           #檢查RMA單單別:70
#               IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                     CALL cl_err(g_t,g_errno,0)
#                     NEXT FIELD rml01
#               END IF
                 SELECT rma03,rma04 INTO g_rma03,g_rma04 FROM rma_file
                    WHERE rma01 = g_rml.rml01 AND rma09!='6' AND rmavoid='Y'
                          AND rmaconf='Y'
                IF STATUS=0    THEN     #若有此資料者
#NO.MOD-590006 START-----
                    IF p_cmd = 'a' THEN  #MOD-590006
                        SELECT MAX(rml03)+1 INTO g_rml.rml03 FROM rml_file
                         WHERE rml01 = g_rml.rml01
                    END IF               #MOD-590006
                   #SELECT MAX(rml03)+1 INTO g_rml.rml03 FROM rml_file
                   #       WHERE rml01 = g_rml.rml01
#NO.MOD-590006 END-------
                   IF g_rml.rml03 IS NULL THEN LET g_rml.rml03=1 END IF
                ELSE                    #無此資料 : let rml03=1
                   CALL cl_err(g_rml.rml03,'mfg0044',0) NEXT FIELD rml01
                END IF
                DISPLAY BY NAME g_rml.rml03
                DISPLAY g_rma03,g_rma04 TO FORMONLY.rma03,FORMONLY.rma04
                LET g_rml_o.rml01 = g_rml.rml01
             END IF
 
        AFTER FIELD rml03                     #批號
            IF NOT cl_null(g_rml.rml03) THEN
                SELECT count(*) INTO g_cnt FROM rml_file
                    WHERE rml01 = g_rml.rml01 AND rml03=g_rml.rml03
                IF g_cnt >= 1 THEN           #表RMA單已有此批號
                    CALL cl_err(g_rml.rml03,-239,0)
                    LET g_rml.rml03 = g_rml_t.rml03
                    DISPLAY BY NAME g_rml.rml03
                    NEXT FIELD rml03
                END IF
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD rmlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rml01)             #查詢RMA單單別
#                CALL q_rma(0,0,'70') RETURNING g_rml.rml01
#                CALL FGL_DIALOG_SETBUFFER( g_rml.rml01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rma"
                 LET g_qryparam.arg1 = '70'
                 LET g_qryparam.arg2 = g_doc_len   #No:TTQC-630149 add
                 CALL cl_create_qry() RETURNING g_rml.rml01
#                 CALL FGL_DIALOG_SETBUFFER( g_rml.rml01 )
                 DISPLAY BY NAME g_rml.rml01
                 NEXT FIELD rml01
            END CASE
 
        ON ACTION CONTROLF                     #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t170_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rml01,rml03",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t170_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rml01,rml03",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t170_u()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
    IF g_rml.rml01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rml.rmlconf = 'Y' THEN  CALL cl_err('conf=Y',9023,0) RETURN END IF
    IF g_rml.rmlpost = 'Y' THEN  CALL cl_err('post=Y','aap-730',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET p_cmd="u"
    LET g_rml_o.* = g_rml.*
    BEGIN WORK
 
    OPEN t170_cl USING g_rml.rml01,g_rml.rml03
    IF STATUS THEN
       CALL cl_err("OPEN t170_cl:", STATUS, 1)
       CLOSE t170_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t170_cl INTO g_rml.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t170_cl ROLLBACK WORK RETURN
    END IF
    CALL t170_show()
    WHILE TRUE
        LET g_rml.rmlmodu=g_user
        LET g_rml.rmldate=g_today
        CALL t170_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rml.*=g_rml_t.*
            CALL t170_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rml_file SET * = g_rml.* WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
        IF STATUS THEN
#        CALL cl_err(g_rml.rml01,STATUS,0) # FUN-660111 
        CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,STATUS,"","",1) #FUN-660111
        CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t170_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rml.rml01,'U')
 
END FUNCTION
 
FUNCTION t170_r()    #FUN-640232
 
  IF s_shut(0) THEN
    RETURN
  END IF
 
  IF cl_null(g_rml.rml01) or cl_null(g_rml.rml03) THEN
    CALL cl_err("",-400,0)
    RETURN 
  END IF
 
  IF g_rml.rmlconf = 'Y' THEN
    CALL cl_err("",'anm-105',0)
    RETURN
  END IF
 
  SELECT * INTO g_rml.* FROM rml_file
  WHERE rml01=g_rml.rml01 AND rml03=g_rml.rml03
  IF g_rml.rmlvoid = 'N' THEN
    CALL cl_err(NULL,'mfg1000',0)
    RETURN
  END IF
  BEGIN WORK
 
  OPEN t170_cl USING g_rml.rml01,g_rml.rml03
  IF STATUS THEN
     CALL cl_err("OPEN t170_cl:", STATUS, 1)
     CLOSE t170_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH t170_cl INTO g_rml.*               # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(NULL,SQLCA.sqlcode,0)          #資料被他人LOCK
     ROLLBACK WORK
     RETURN
  END IF
 
  CALL t170_show()
 
  IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "rml01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_rml.rml01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
     DELETE FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
     DELETE FROM rmp_file WHERE rmp01 = g_rml.rml01 AND rmp011 = g_rml.rml03
     CLEAR FORM
     CALL g_rmp.clear()
     OPEN t170_count
     #FUN-B50064-add-start--
     IF STATUS THEN
        CLOSE t170_cs
        CLOSE t170_count
        COMMIT WORK
        RETURN
     END IF
     #FUN-B50064-add-end--
     FETCH t170_count INTO g_row_count
     #FUN-B50064-add-start--
     IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
        CLOSE t170_cs
        CLOSE t170_count
        COMMIT WORK
        RETURN
     END IF
     #FUN-B50064-add-end--
     DISPLAY g_row_count TO FORMONLY.cnt
     OPEN t170_cs
     IF g_curs_index = g_row_count + 1 THEN
        LET g_jump = g_row_count
        CALL t170_fetch('L')
     ELSE
        LET g_jump = g_curs_index
        LET mi_no_ask = TRUE
        CALL t170_fetch('/')
     END IF
  END IF
 
  CLOSE t170_cl
  COMMIT WORK
END FUNCTION
 
FUNCTION t170_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rml.* TO NULL             #NO.FUN-6A0018       
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    LET p_cmd="u"
    CALL t170_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_rml.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t170_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rml.* TO NULL
    ELSE
        OPEN t170_count
        FETCH t170_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t170_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
    LET g_auto="N"
END FUNCTION
 
FUNCTION t170_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t170_cs INTO g_rml.rml01,g_rml.rml03  #No.TQC-AA0102 add rml03
        WHEN 'P' FETCH PREVIOUS t170_cs INTO g_rml.rml01,g_rml.rml03  #No.TQC-AA0102 add rml03
        WHEN 'F' FETCH FIRST    t170_cs INTO g_rml.rml01,g_rml.rml03  #No.TQC-AA0102 add rml03
        WHEN 'L' FETCH LAST     t170_cs INTO g_rml.rml01,g_rml.rml03  #No.TQC-AA0102 add rml03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump t170_cs INTO g_rml.rml01,g_rml.rml03  #No.TQC-AA0102 add rml03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rml.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)# FUN-660111 
        CALL cl_err3("sel","rml_file",g_rml.rml01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rml.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rml.rmluser #FUN-4C0055
        LET g_data_group = g_rml.rmlgrup #FUN-4C0055
        LET g_data_plant = g_rml.rmlplant #FUN-980030
    END IF
 
    CALL t170_show()
END FUNCTION
 
FUNCTION t170_show()
 
    LET g_rml_t.* = g_rml.*                #保存單頭舊值
    DISPLAY BY NAME g_rml.rmloriu,g_rml.rmlorig,
        g_rml.rml01,g_rml.rml03,g_rml.rml02,g_rml.rml04,
        g_rml.rmlconf,g_rml.rmluser,g_rml.rmlgrup,g_rml.rmlmodu,g_rml.rmldate,
        g_rml.rmlvoid,
      #FUN-840068     ---start---
        g_rml.rmlud01,g_rml.rmlud02,g_rml.rmlud03,g_rml.rmlud04,
        g_rml.rmlud05,g_rml.rmlud06,g_rml.rmlud07,g_rml.rmlud08,
        g_rml.rmlud09,g_rml.rmlud10,g_rml.rmlud11,g_rml.rmlud12,
        g_rml.rmlud13,g_rml.rmlud14,g_rml.rmlud15 
      #FUN-840068     ----end----
 
    #CKP
    CALL cl_set_field_pic(g_rml.rmlconf,"","","","",g_rml.rmlvoid)
 
 
    CALL t170_get_rma()
    CALL t170_b_fill(g_wc2)
    LET g_rmp_paconfo = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t170_get_rma()
    SELECT rma03,rma04 INTO g_rma03,g_rma04 FROM rma_file
          WHERE rma01=g_rml.rml01
    DISPLAY g_rma03,g_rma04 TO FORMONLY.rma03,FORMONLY.rma04
 
END FUNCTION
 
FUNCTION t170_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    g_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    g_tmp           LIKE rmc_file.rmc01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    g_rmp07,g_rmp311,l_total,l_i  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
    IF g_rml.rml01 IS NULL THEN
       CALL cl_err('','aap-105',0) RETURN
    END IF
    IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
    IF g_rml.rmlpost = 'Y' THEN CALL cl_err('post=Y','aap-730',0) RETURN END IF
    IF g_rml.rmlconf = 'Y' THEN CALL cl_err('conf=Y',9003,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT rmp02,rmp06,rmp11,rmp13,rmp12,rmp07",
   #No.FUN-840068 --start--
      "       ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
      "        rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
      "        rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
   #No.FUN-840068 ---end---
      " FROM rmp_file ",
      "  WHERE rmp00 = ? ",
      "   AND rmp01 = ? ",
      "   AND rmp011= ? ",
      "   AND rmp02 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t170_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET g_rmp_paconfo = 1
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rmp
              WITHOUT DEFAULTS
              FROM s_rmp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_total=ARR_COUNT()
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN t170_cl USING g_rml.rml01,g_rml.rml03
            IF STATUS THEN
               CALL cl_err("OPEN t170_cl:", STATUS, 1)
               CLOSE t170_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t170_cl INTO g_rml.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t170_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmp_t.* = g_rmp[l_ac].*  #BACKUP
               LET g_rmp_o.* = g_rmp[l_ac].*  #BACKUP
 
                OPEN t170_bcl USING '2',g_rml.rml01,g_rml.rml03,g_rmp_t.rmp02
                IF STATUS THEN
                    CALL cl_err("OPEN t170_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t170_bcl INTO g_rmp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET p_cmd='u'
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmp02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,
                                 rmp05,rmp06,rmp07,rmp08,rmp09,
                                 rmp10,rmp11,rmp12,rmp13,rmp14,
                                 rmp15, #)
                               #FUN-840068 --start--
                                 rmpud01,rmpud02,rmpud03,
                                 rmpud04,rmpud05,rmpud06,
                                 rmpud07,rmpud08,rmpud09,
                                 rmpud10,rmpud11,rmpud12,
                                 rmpud13,rmpud14,rmpud15,
                                 rmpplant,rmplegal) #FUN-980007
                                #FUN-840068 --end--
            VALUES('2',g_rml.rml01,g_rml.rml03,g_rmp[l_ac].rmp02,
              '','',g_rml.rml01,g_rmp[l_ac].rmp06,g_rmp[l_ac].rmp07,
               0,'',g_rmp10,g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,
               g_rmp[l_ac].rmp13,l_rmp14,'', #)
             #FUN-840068 --start---
               g_rmp[l_ac].rmpud01,
               g_rmp[l_ac].rmpud02,
               g_rmp[l_ac].rmpud03,
               g_rmp[l_ac].rmpud04,
               g_rmp[l_ac].rmpud05,
               g_rmp[l_ac].rmpud06,
               g_rmp[l_ac].rmpud07,
               g_rmp[l_ac].rmpud08,
               g_rmp[l_ac].rmpud09,
               g_rmp[l_ac].rmpud10,
               g_rmp[l_ac].rmpud11,
               g_rmp[l_ac].rmpud12,
               g_rmp[l_ac].rmpud13,
               g_rmp[l_ac].rmpud14,
               g_rmp[l_ac].rmpud15,
               g_plant,g_legal)             #FUN-980007
             #FUN-840068 --end--
 
            IF SQLCA.sqlcode THEN
 #              CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0)# FUN-660111 
               CALL cl_err3("ins","rmp_file",g_rml.rml01,g_rmp[l_ac].rmp02,SQLCA.sqlcode,"","",1) #FUN-660111
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rmp[l_ac].* TO NULL      #900423
            LET g_rmp[l_ac].rmp07 = 0        #Body default
            LET g_rmp_t.* = g_rmp[l_ac].*         #新輸入資料
            LET g_rmp_o.* = g_rmp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmp02
 
        BEFORE FIELD rmp02                        #default 序號
            IF g_rmp[l_ac].rmp02 IS NULL OR
               g_rmp[l_ac].rmp02 = 0 THEN
                SELECT max(rmp02)+1
                   INTO g_rmp[l_ac].rmp02
                   FROM rmp_file
                   WHERE rmp00='2'
                     AND rmp01 = g_rml.rml01 AND rmp011=g_rml.rml03
                IF g_rmp[l_ac].rmp02 IS NULL THEN
                    LET g_rmp[l_ac].rmp02 = 1
                END IF
#               DISPLAY g_rmp[l_ac].rmp02 TO s_rmp[l_sl].rmp02 #No.FUN-570273預設值不可使用
           END IF
           IF NOT cl_null(g_rmp[l_ac].rmp06) THEN
              CALL t170_rmp10()
           END IF
 
        AFTER FIELD rmp02                        #check 序號是否重複
          IF NOT cl_null(g_rmp[l_ac].rmp02) THEN
              IF g_rmp[l_ac].rmp02 != g_rmp_o.rmp02 OR
                 g_rmp_o.rmp02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM rmp_file
                      WHERE rmp00  ="2" AND rmp01 = g_rml.rml01
                        AND rmp011 =g_rml.rml03 AND rmp02=g_rmp[l_ac].rmp02
                  IF l_n > 0 THEN
                      LET g_rmp[l_ac].rmp02 = g_rmp_t.rmp02
                      CALL cl_err('',-239,0) NEXT FIELD rmp02
                  END IF
              END IF
              #IF g_auto="Y" THEN NEXT FIELD rmp03 END IF
              LET g_rmp_o.rmp02=g_rmp[l_ac].rmp02
          END IF
 
       AFTER FIELD rmp06
             IF NOT cl_null(g_rmp[l_ac].rmp06) THEN
                LET g_n=0
                SELECT count(*) INTO g_n FROM rmp_file
                  WHERE rmp00="2" AND rmp02<> g_rmp[l_ac].rmp02
                    AND rmp01 = g_rml.rml01 AND rmp011=g_rml.rml03
                    AND rmp05 = g_rml.rml01 AND rmp06 = g_rmp[l_ac].rmp06
                IF g_n >= 1 THEN
                    LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                    DISPLAY g_rmp[l_ac].rmp06 TO s_rmp[l_sl].rmp06
                    CALL cl_err('',-239,0) NEXT FIELD rmp06
                END IF
                LET g_n=0
                SELECT count(*) INTO g_n FROM rml_file,rmp_file
                  WHERE rmp00="2" AND rmp01=g_rml.rml01
                    AND rmp011 <> g_rml.rml03 AND rmp01=rml01
                    AND rmp011=rml03 AND rmlvoid='Y'
                    AND rmp05 = g_rml.rml01 AND rmp06 = g_rmp[l_ac].rmp06
                IF g_n >= 1 THEN
                    LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                    DISPLAY g_rmp[l_ac].rmp06 TO s_rmp[l_sl].rmp06
                    CALL cl_err('',-239,0) NEXT FIELD rmp06
                END IF
                LET g_err="N"
                CALL t170_get_rmc()
                IF g_err="Y" THEN
                   CALL cl_err('','aap-129',0)
                   DISPLAY g_rmp[l_ac].* TO s_rmp[l_sl].*
                   NEXT FIELD rmp06
                END IF
                LET g_rmp_o.rmp06 = g_rmp[l_ac].rmp06
              END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD rmpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmp_t.rmp02 > 0 AND
               g_rmp_t.rmp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmp_file
                    WHERE rmp00='2'
                      AND rmp01 = g_rml.rml01
                      AND rmp011=g_rml.rml03
                      AND rmp02 = g_rmp_t.rmp02
                IF SQLCA.sqlcode THEN
    #                CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,0)# FUN-660111 
                    CALL cl_err3("del","rmp_file",g_Rml.rml01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmp[l_ac].* = g_rmp_t.*
               CLOSE t170_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmp[l_ac].rmp02,-263,1)
                LET g_rmp[l_ac].* = g_rmp_t.*
            ELSE
                UPDATE rmp_file SET
                       rmp02=g_rmp[l_ac].rmp02,
                       rmp06=g_rmp[l_ac].rmp06,
                       rmp10=g_rmp10,
                       rmp11=g_rmp[l_ac].rmp11,
                       rmp13=g_rmp[l_ac].rmp13,
                       rmp12=g_rmp[l_ac].rmp12,
                       rmp07=g_rmp[l_ac].rmp07,
                       rmp14=l_rmp14
                     #FUN-840068 --start--
                      ,rmpud01 = g_rmp[l_ac].rmpud01,
                       rmpud02 = g_rmp[l_ac].rmpud02,
                       rmpud03 = g_rmp[l_ac].rmpud03,
                       rmpud04 = g_rmp[l_ac].rmpud04,
                       rmpud05 = g_rmp[l_ac].rmpud05,
                       rmpud06 = g_rmp[l_ac].rmpud06,
                       rmpud07 = g_rmp[l_ac].rmpud07,
                       rmpud08 = g_rmp[l_ac].rmpud08,
                       rmpud09 = g_rmp[l_ac].rmpud09,
                       rmpud10 = g_rmp[l_ac].rmpud10,
                       rmpud11 = g_rmp[l_ac].rmpud11,
                       rmpud12 = g_rmp[l_ac].rmpud12,
                       rmpud13 = g_rmp[l_ac].rmpud13,
                       rmpud14 = g_rmp[l_ac].rmpud14,
                       rmpud15 = g_rmp[l_ac].rmpud15
                     #FUN-840068 --end-- 
                 WHERE rmp00="2"
                   AND rmp01=g_rml.rml01
                   AND rmp011=g_rml.rml03
                   AND rmp02=g_rmp_t.rmp02
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
    #                CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0)# FUN-660111 
                    CALL cl_err3("upd","rmp_file",g_rml.rml01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rmp[l_ac].* = g_rmp_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmp[l_ac].* = g_rmp_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t170_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D40030 add
           #CKP
           #LET g_rmp_t.* = g_rmp[l_ac].*          # 900423
            CLOSE t170_bcl
            COMMIT WORK
 
 
      # ON ACTION CONTROLN
      #     CALL t170_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmp02) AND l_ac > 1 THEN
                LET g_rmp[l_ac].* = g_rmp[l_ac-1].*
                LET g_rmp[l_ac].rmp02 = NULL
                DISPLAY g_rmp[l_ac].* TO s_rmp[l_sl].*
                NEXT FIELD rmp02
            END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmp06) #項次
#                 CALL q_rma1(3,3,g_rml.rml01,'70') RETURNING g_tmp,g_rmp[l_ac].rmp06
#                 CALL FGL_DIALOG_SETBUFFER( g_tmp )
#                 CALL FGL_DIALOG_SETBUFFER( g_rmp[l_ac].rmp06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rma1"
                  IF NOT cl_null(g_rml.rml01) THEN
                      LET g_qryparam.construct = "N"
                      LET g_qryparam.where = " rmc01 = '",g_rml.rml01,"'"
                  END IF
                  LET g_qryparam.default1 = g_rml.rml01
                  LET g_qryparam.arg1 = '70'
                  LET g_qryparam.arg2 = g_doc_len   #MOD-770022
                  CALL cl_create_qry() RETURNING g_tmp,g_rmp[l_ac].rmp06
#                  CALL FGL_DIALOG_SETBUFFER( g_tmp )
#                  CALL FGL_DIALOG_SETBUFFER( g_rmp[l_ac].rmp06 )
                  DISPLAY g_rmp[l_ac].rmp06 TO rmp06
                  NEXT FIELD rmp06
               OTHERWISE EXIT CASE
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
        END INPUT
 
 
   #FUN-5B0113-begin
    LET g_rml.rmlmodu = g_user
    LET g_rml.rmldate = g_today
    UPDATE rml_file SET rmlmodu = g_rml.rmlmodu,rmldate = g_rml.rmldate
     WHERE rml01 = g_rml.rml01
       AND rml03 = g_rml.rml03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
  #     CALL cl_err('upd rml',SQLCA.SQLCODE,1)# FUN-660111 
       CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,SQLCA.sqlcode,"","upd rml",1) #FUN-660111
    END IF
    DISPLAY BY NAME g_rml.rmlmodu,g_rml.rmldate
   #FUN-5B0113-end
 
    CLOSE t170_bcl
    LET g_success="Y"
    IF INT_FLAG THEN
       LET g_success = "N"
       IF p_cmd="a" THEN
          IF g_rec_b =0 THEN
              IF cl_confirm("9042") THEN        #CHI-C30002 ad
                 DELETE FROM rml_file WHERE rml01=g_rml.rml01 and rml03=g_rml.rml03
              END IF
          END IF
          RETURN
       ELSE LET INT_FLAG=0 CALL cl_err('',9001,1)
            ROLLBACK WORK
            CALL t170_show()
            RETURN END IF
    END IF
    COMMIT WORK
 
#   LET g_t1 = g_rml.rml01[1,3]
    LET g_t1 = s_get_doc_no(g_rml.rml01)     #No.FUN-550064
 
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
    IF g_oay.oayconf = 'Y' THEN CALL t170_y() END IF
 
END FUNCTION
 
FUNCTION t170_rmp10()  #修復狀況
    DEFINE l_rmp10     LIKE type_file.chr50   #No.FUN-690010 VARCHAR(30)
 
     SELECT rmp10 INTO g_rmp10 FROM rmp_file
      WHERE rmp00='2'          AND rmp01=g_rml.rml01
        AND rmp011=g_rml.rml03 AND rmp02=g_rmp[l_ac].rmp02
     LET l_rmp10 = ' '
     CASE g_lang
       WHEN '0'
         CASE
            WHEN g_rmp10='0' LET l_rmp10='未修復'
            WHEN g_rmp10='1' LET l_rmp10='修復  '
            WHEN g_rmp10='2' LET l_rmp10='不修  '
            OTHERWISE EXIT CASE
         END CASE
       WHEN '2'
         CASE
            WHEN g_rmp10='0' LET l_rmp10='未修復'
            WHEN g_rmp10='1' LET l_rmp10='修復  '
            WHEN g_rmp10='2' LET l_rmp10='不修  '
            OTHERWISE EXIT CASE
         END CASE
       OTHERWISE
         CASE
            WHEN g_rmp10='0' LET l_rmp10='Waiting Repair'
            WHEN g_rmp10='1' LET l_rmp10='Repaired'
            WHEN g_rmp10='2' LET l_rmp10='No Repaired'
            OTHERWISE EXIT CASE
         END CASE
     END CASE
     ERROR 'Ori-repaired status:',l_rmp10
END FUNCTION
 
FUNCTION t170_get_rmc()
        SELECT rmc04,rmc05,rmc06,rmc31-rmc311-rmc312-rmc313,rmc061,rmc14
           INTO g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,g_rmp[l_ac].rmp13,
                g_rmp[l_ac].rmp07,l_rmp14,g_rmp10
           FROM rmc_file,rma_file
           WHERE rmc01=g_rml.rml01 AND rmc02=g_rmp[l_ac].rmp06
             AND rmc23 IS NULL AND rmc14 IN ('3')  #CHI-690052 012->3  #TQC-6A0018
             AND rma01=rmc01   AND rmaconf='Y' AND rmavoid='Y'
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
           LET g_rmp[l_ac].rmp11 = g_rmp_t.rmp11
           LET g_rmp[l_ac].rmp12 = g_rmp_t.rmp12
           LET g_rmp[l_ac].rmp13 = g_rmp_t.rmp13
           LET g_rmp[l_ac].rmp07 = g_rmp_t.rmp07
           RETURN
        END IF
        #------MOD-5A0095 START----------
        DISPLAY BY NAME g_rmp[l_ac].rmp06
        DISPLAY BY NAME g_rmp[l_ac].rmp11
        DISPLAY BY NAME g_rmp[l_ac].rmp12
        DISPLAY BY NAME g_rmp[l_ac].rmp13
        DISPLAY BY NAME g_rmp[l_ac].rmp07
        #------MOD-5A0095 END------------
END FUNCTION
 
FUNCTION t170_b_askkey()
DEFINE           l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmp02,rmp06,rmp11,rmp13,rmp12,rmp07
                    #No.FUN-840068 --start--
                      ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                      ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                      ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                    #No.FUN-840068 ---end---
            FROM s_rmp[1].rmp02, s_rmp[1].rmp06, s_rmp[1].rmp11,
                 s_rmp[1].rmp13, s_rmp[1].rmp12, s_rmp[1].rmp07
              #No.FUN-840068 --start--
                ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
	        ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
                ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
                ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
	        ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
              #No.FUN-840068 ---end---
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t170_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t170_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
       LET g_sql =" SELECT rmp02,rmp06,rmp11,rmp13,rmp12,rmp07  ",
              #No.FUN-840068 --start--
                  "       ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
                  "        rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
                  "        rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
              #No.FUN-840068 ---end---
                  " FROM rml_file,rmp_file ",
                  " WHERE rmp01=rml01 AND rmp011=rml03 AND rmp00='2' ",
                  " AND rmp011=",g_rml.rml03,
                  " AND rmp01= '",g_rml.rml01,"'"," AND ",p_wc2 CLIPPED,
                  " ORDER BY rmp02 "
    PREPARE t170_pb FROM g_sql
    DECLARE rmp_curs                       #SCROLL CURSOR
        CURSOR FOR t170_pb
 
    CALL g_rmp.clear()
    LET g_cnt = 1
    FOREACH rmp_curs INTO g_rmp[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_rmp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t170_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmp TO s_rmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      #FUN-640232
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL t170_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t170_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t170_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t170_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t170_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
         CALL cl_set_field_pic(g_rml.rmlconf,"","","","",g_rml.rmlvoid)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t170_x()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
    IF g_rml.rml01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rml.rmlconf = 'Y' THEN CALL cl_err('conf=Y',9023,0)  RETURN END IF
    IF g_rml.rmlpost='Y' THEN CALL cl_err('post=Y:','aap-730',0)
       RETURN END IF
 
    IF cl_exp(0,0,g_rml.rmlvoid) THEN
       LET g_rml_t.* = g_rml.*
 
       BEGIN WORK
 
       OPEN t170_cl USING g_rml.rml01,g_rml.rml03
       IF STATUS THEN
          CALL cl_err("OPEN t170_cl:", STATUS, 1)
          CLOSE t170_cl
          ROLLBACK WORK
          RETURN
       END IF
 
       FETCH t170_cl INTO g_rml.*          # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)     # 資料被他人LOCK
           CLOSE t170_cl ROLLBACK WORK RETURN
       END IF
 
       CALL t170_show()
       UPDATE rml_file                    #更改有效碼
           SET rmlvoid="N",rmlmodu=g_user,rmldate=g_today
           WHERE rml01=g_rml.rml01 AND rml03=g_rml.rml03
       IF SQLCA.SQLERRD[3]=0 THEN
 #         CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)# FUN-660111 
          CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,SQLCA.sqlcode,"","",1) #FUN-660111
       END IF
 
       LET g_rml.rmlvoid='N' LET g_rml.rmlmodu=g_user
       LET g_rml.rmldate=g_today
       DISPLAY BY NAME g_rml.rmlvoid,g_rml.rmlmodu,g_rml.rmldate
 
       COMMIT WORK
       CALL cl_flow_notify(g_rml.rml01,'V')
 
    END IF
    #CKP
    CALL cl_set_field_pic(g_rml.rmlconf,"","","","",g_rml.rmlvoid)
 
END FUNCTION
 
FUNCTION t170_y()         # when g_rml.rmlconf ='N' (Turn to 'Y')
DEFINE l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------- add -------------- begin 
   IF g_rml.rml01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rml.rmlconf  = 'Y' THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF 
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
   IF g_rml.rml01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rml.rmlconf  = 'Y' THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   IF g_rmp[1].rmp02 IS NULL THEN
      CALL cl_err(g_rml.rml01,'mfg3122',1) RETURN END IF
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmp_file
    WHERE rmp01=g_rml.rml01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#---BUGNO:7379 END---------------
 
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  #CHI-C30107 mark
   LET g_rml_t.* = g_rml.*
   BEGIN WORK
 
 
    OPEN t170_cl USING g_rml.rml01,g_rml.rml03
    IF STATUS THEN
       CALL cl_err("OPEN t170_cl:", STATUS, 1)
       CLOSE t170_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t170_cl INTO g_rml.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t170_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t170_up_rmpbc('Y')      #UPDATE rmp,rmc,rmb
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
      RETURN
   END IF
   UPDATE rml_file SET rmlconf = 'Y',rmlmodu=g_user,rmldate=g_today
          WHERE rml01 = g_rml.rml01 AND rml03=g_rml.rml03
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('upd rmlconf ',STATUS,1)# FUN-660111 
      CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,STATUS,"","upd rmlconf",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF cl_confirm('arm-523') THEN  #NO:7224
       CALL t170_ins_oha()         #產生銷退單
   END IF
   IF g_success = 'Y' THEN
     #MOD-B90097---add---start---
      CALL t170_up_rma()
      IF g_success = 'N' THEN
         LET g_rml.rmlconf='N'
         ROLLBACK WORK
         CALL cl_rbmsg(3) sleep 1
      ELSE
     #MOD-B90097---add---end---
         LET g_rml.rmlconf ="Y"
         LET g_rml.rmlmodu=g_user LET g_rml.rmldate=g_today
         COMMIT WORK
         CALL cl_flow_notify(g_rml.rml01,'Y')
 
         DISPLAY BY NAME g_rml.rmlconf
         CALL cl_cmmsg(3) sleep 1 
      END IF     #MOD-B90097 add
   ELSE
      LET g_rml.rmlconf ='N'
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rml.rmlconf,g_rml.rmlmodu,g_rml.rmldate
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rml.rmlconf,"","","","",g_rml.rmlvoid)
END FUNCTION
 
FUNCTION t170_ins_oha()            #NO:7224 產生銷退單新增
DEFINE li_result    LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE l_a          LIKE type_file.chr5    #No.FUN-690010 VARCHAR(05)                   #No.FUN-550064
DEFINE l_b          LIKE type_file.dat     #No.FUN-690010 DATE                         #日期
DEFINE l_oayauno    LIKE oay_file.oayauno        #自動編號
DEFINE l_oha01      LIKE oha_file.oha01          #銷退單
 
 
    LET p_row = 8 LET p_col = 20
    OPEN WINDOW t170_oha_w AT p_row,p_col WITH FORM "arm/42f/armt170a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("armt170a")
 
 
    LET l_b=g_today
    DISPLAY l_b TO FORMONLY.b
 
    INPUT l_a,l_b WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.b
 
    AFTER FIELD a             #單別
         #No.FUN-550064 --start--
         IF NOT cl_null(l_a) THEN
           #CALL s_check_no("arm",l_a,"","60","","","")    #FUN-A70130
            CALL s_check_no("axm",l_a,"","60","","","")    #FUN-A70130 #No.TQC-AA0108
            RETURNING li_result,l_a
            DISPLAY BY NAME l_a
            IF (NOT li_result) THEN
               NEXT FIELD a
            END IF
            DISPLAY g_smy.smydesc TO smydesc
#       IF NOT cl_null(l_a) THEN
#           CALL s_axmslip(l_a,'60','AXM')            #檢查單別
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD a
#           END IF
#           SELECT oayauno INTO l_oayauno FROM oay_file
#            WHERE oayslip=l_a
#           IF l_oayauno = 'N' THEN
#              CALL cl_err('','aap-011',0)
#              NEXT FIELD a
#           END IF
        END IF
#No.FUN-550064 --end--
 
     ON ACTION CONTROLP
         CASE
             WHEN INFIELD(a) #查詢單据
#                 CALL q_oay(0,0,l_a,'60','AXM') RETURNING l_a
                  CALL q_oay(FALSE,FALSE,l_a,'60','AXM') RETURNING l_a
#                  CALL FGL_DIALOG_SETBUFFER( l_a )
                  DISPLAY l_a TO FORMONLY.a
                  NEXT FIELD a
         END CASE
     AFTER INPUT
       #IF l_oayauno='Y' THEN #MOD-590284 MARK IF 判斷
#           LET l_oha01[1,3]=l_a
            LET l_oha01[1,g_doc_len]=l_a          #No.FUN-550064
      #No.FUN-550064 --start--
#       CALL s_auto_assign_no("axm",l_oha01,l_b,"","","","","","")
        CALL s_auto_assign_no("axm",l_oha01,l_b,"60","oha_file","oha01","","","")  #No.FUN-560014
        RETURNING li_result,l_oha01
      IF (NOT li_result) THEN
#           CALL s_axmauno(l_oha01,l_b)
#                RETURNING g_i,l_oha01
#           IF g_i THEN                      #有問題
      #No.FUN-550064 ---end---
                  DISPLAY l_a TO FORMONLY.a
                  LET l_oha01=NULL
                  NEXT FIELD a
            END IF
       #END IF #MOD-590284 MARK IF 判斷
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     END INPUT
     CLOSE WINDOW t170_oha_w            #結束畫面
     IF NOT cl_null(l_oha01) THEN
         CALL ins_oha_file(l_oha01,l_b)
     END IF
END FUNCTION
 
FUNCTION ins_oha_file(p_oha01,p_oha02)    #oha_file單頭default
DEFINE
      l_rma   RECORD LIKE rma_file.*,
      l_oha   RECORD LIKE oha_file.*,
      l_oga   RECORD LIKE oga_file.*,
      l_ogb   RECORD LIKE ogb_file.*,
      l_occ   RECORD LIKE occ_file.*,
      p_oha01 LIKE oha_file.oha01,
      p_oha02 LIKE oha_file.oha02,
      l_ohc04 LIKE ohc_file.ohc04,
      l_rma03 LIKE rma_file.rma03,      #客戶編號
      l_rma22 LIKE rma_file.rma22       #客訴單
 
        LET l_oha.oha01  =p_oha01
        LET l_oha.oha02  =p_oha02
        LET l_oha.oha09  ='1'         #銷退折讓
       #-----MOD-950064---------
       #LET l_oha.oha02  =g_today
        LET l_oha.oha05  = '1'
        LET l_oha.oha55 = '0'
        LET g_t1 = s_get_doc_no(l_oha.oha01)
        SELECT oayapr INTO l_oha.ohamksg FROM oay_file
         WHERE oayslip = g_t1
       #-----END MOD-950064-----
        LET l_oha.oha14  =g_user
        LET l_oha.oha15  =g_grup
        LET l_oha.oha211 =0
        LET l_oha.oha50  =0
        LET l_oha.oha53  =0
        LET l_oha.oha54  =0
        LET l_oha.ohaconf='N'
        LET l_oha.ohapost='N'
        LET l_oha.ohaprsw=0
        LET l_oha.ohauser=g_user
        LET l_oha.ohagrup=g_grup
        LET l_oha.ohadate=g_today
        SELECT * INTO l_rma.*
          FROM rma_file
         WHERE rma01=g_rml.rml01
       #-----MOD-950064---------
        SELECT ohc04 INTO l_ohc04 FROM ohc_file
         WHERE ohc01=l_rma.rma22
        IF NOT cl_null(l_rma.rma22) AND NOT cl_null(l_ohc04) THEN
       #IF NOT cl_null(l_rma.rma22) THEN             #抓客訴單
       #    SELECT ohc04 INTO l_ohc04 FROM ohc_file  #抓出貨單
       #     WHERE ohc01=l_rma.rma22
       #    IF NOT cl_null(l_ohc04) THEN
       #-----END MOD-950064-----
                SELECT * INTO l_oga.* FROM oga_file  #抓出貨單頭資料default
                 WHERE oga01=l_ohc04
                IF SQLCA.SQLCODE  THEN
                    LET g_success='N'
#                    CALL cl_err(l_ohc04,SQLCA.SQLCODE,1)# FUN-660111 
                    CALL cl_err3("sel","oga_file",l_ohc04,"",SQLCA.sqlcode,"","",1) #FUN-660111
                    RETURN
                END IF
                LET l_oha.oha08  =l_oga.oga08       #內外銷
                LET l_oha.oha03  =l_oga.oga03       #客戶編號
                LET l_oha.oha032 =l_oga.oga032      #帳款客戶簡稱
                LET l_oha.oha04  =l_oga.oga04       #送貨客戶
               #LET l_oha.oha10  =l_oga.oga10       #帳單編號   #No.MOD-920159 mark
                LET l_oha.oha10  =NULL              #帳單編號   #No.MOD-920159 add
                LET l_oha.oha14  =l_oga.oga14       #業務人員
                LET l_oha.oha15  =l_oga.oga15       #業務部門
                LET l_oha.oha16  =l_oga.oga01       #出貨單號
                LET l_oha.oha17  =g_rml.rml01       #RMA單號
                LET l_oha.oha21  =l_oga.oga21       #稅別
                LET l_oha.oha211 =l_oga.oga211      #稅率
                LET l_oha.oha212 =l_oga.oga212      #聯數
                LET l_oha.oha213 =l_oga.oga213      #含稅否
                LET l_oha.oha23  =l_oga.oga23       #幣別
                LET l_oha.oha24  =l_oga.oga24       #匯率
                LET l_oha.oha25  =l_oga.oga25       #銷售分類一
           #END IF    #MOD-950064 mark
        ELSE
            SELECT * INTO l_occ.* FROM occ_file     #抓客戶資料
             WHERE occ01=l_rma.rma03
             IF SQLCA.SQLCODE THEN
                 LET g_success='N'
   #              CALL cl_err(l_occ.occ01,SQLCA.SQLCODE,1)# FUN-660111 
                 CALL cl_err3("sel","occ_file",l_rma.rma03,"",SQLCA.sqlcode,"","",1) #FUN-660111
                 RETURN
             END IF
            #LET l_oha.oha09  ='5'                  #折讓   #MOD-640452 add    #MOD-950064 mark
             LET l_oha.oha08  =l_rma.rma08          #內外銷
             LET l_oha.oha03  =l_rma.rma03          #客戶編號
             LET l_oha.oha032 =l_occ.occ02          #帳款客戶簡稱
             LET l_oha.oha04  =l_occ.occ09          #送貨客戶
             LET l_oha.oha17  =g_rml.rml01          #RMA單號
             LET l_oha.oha14  =l_rma.rma13          #業務人員
             LET l_oha.oha15  =l_rma.rma14          #業務部門
             LET l_oha.oha21  =l_occ.occ41          #
             SELECT gec04,gec05,gec07 
               INTO l_oha.oha211,
                    l_oha.oha212,
                    l_oha.oha213 
               FROM gec_file
              WHERE gec01=l_oha.oha21
            #LET l_oha.oha23  =l_occ.occ631         #幣別  #MOD-950064 mark
             LET l_oha.oha23  =l_occ.occ42         #幣別   #MOD-950064
             SELECT oaz52,oaz70 INTO g_oaz.oaz52,g_oaz.oaz70 FROM oaz_file    #MOD-D30151 add
             IF l_oha.oha08='1' THEN
                 LET l_oha.oha24 =
                   s_curr3(l_oha.oha23,l_oha.oha02,g_oaz.oaz52)         #幣別
             ELSE
                 LET l_oha.oha24 =
                   s_curr3(l_oha.oha23,l_oha.oha02,g_oaz.oaz70)         #幣別
             END IF
             LET l_oha.oha25  =l_occ.occ43          #
        END IF
        LET l_oha.oha85=' ' #No.FUN-870007
        LET l_oha.oha94='N' #No.FUN-870007
        LET l_oha.ohaplant = g_plant #FUN-980007
        LET l_oha.ohalegal = g_legal #FUN-980007
        LET l_oha.ohaoriu = g_user      #No.FUN-980030 10/01/04
        LET l_oha.ohaorig = g_grup      #No.FUN-980030 10/01/04
        IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
        INSERT INTO oha_file VALUES (l_oha.*)
        IF STATUS OR SQLCA.SQLCODE THEN
  #           CALL cl_err(l_oha.oha01,SQLCA.SQLCODE,1)# FUN-660111 
             CALL cl_err3("ins","oha_file",l_oha.oha01,"",SQLCA.sqlcode,"","",1) #FUN-660111
             LET g_success='N'
        END IF
        UPDATE rml_file SET rml04=l_oha.oha01
         WHERE rml01 = g_rml.rml01 AND rml03=g_rml.rml03
        IF STATUS OR SQLCA.SQLCODE THEN
   #          CALL cl_err('up_rml04',SQLCA.SQLCODE,1)# FUN-660111 
             CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,SQLCA.sqlcode,"","up_rml04",1) #FUN-660111
             LET g_success='N'
             LET g_rml.rml04=NULL
        END IF
        LET g_rml.rml04=l_oha.oha01
        DISPLAY BY NAME g_rml.rml04
        IF g_success='Y' THEN
           CALL ins_ohb_file(l_oha.*,l_ohc04)
        END IF
END FUNCTION
 
FUNCTION ins_ohb_file(p_oha,p_ohc04)             #ohb_file單身default
    DEFINE l_ohb     RECORD LIKE ohb_file.*
    DEFINE p_oha     RECORD LIKE oha_file.*
    DEFINE l_ogb     RECORD LIKE ogb_file.*
    DEFINE l_rmp     RECORD LIKE rmp_file.*
    DEFINE l_rmp11   LIKE rmp_file.rmp11
    DEFINE l_rmp12   LIKE rmp_file.rmp12
    DEFINE l_rmp13   LIKE rmp_file.rmp13   #No:7690
    DEFINE p_ohc04   LIKE ohc_file.ohc04
    DEFINE l_tot     LIKE rmo_file.rmo08    #No.FUN-690010 dec(8,3) #數量
    DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
    DEFINE l_n       LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_ima31   LIKE ima_file.ima31   #MOD-640452 add
    DEFINE l_ima55   LIKE ima_file.ima55   #MOD-640452 add
    DEFINE l_ima906  LIKE ima_file.ima906  #MOD-640452 add
    DEFINE l_ima907  LIKE ima_file.ima907  #MOD-640452 add
    DEFINE l_factor  LIKE img_file.img21   #MOD-640452 add
    DEFINE l_ohbi    RECORD LIKE ohbi_file.* #FUN-B70074 add
 
    LET l_sql =" SELECT rmp11,rmp12,rmp13,SUM(rmp07)  ",   #抓相同料號,單位為同一筆
               " FROM rml_file,rmp_file ",
               " WHERE rmp01=rml01 AND rmp011=rml03 AND rmp00='2' ",
               " AND rmp011=",g_rml.rml03,
               " AND rmp01= '",g_rml.rml01,"'",
               " GROUP BY rmp11,rmp12,rmp13 "
    PREPARE t170_rmp FROM l_sql
    DECLARE rmp_ins_b                      #SCROLL CURSOR
        CURSOR FOR t170_rmp
    LET g_cnt=0
    FOREACH rmp_ins_b INTO l_rmp11,l_rmp12,l_rmp13,l_tot   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF NOT cl_null(p_ohc04) THEN
           SELECT * INTO l_ogb.* FROM ogb_file
            WHERE ogb01=p_ohc04
              AND ogb04=l_rmp11
              AND ogb05=l_rmp12
        END IF
        INITIALIZE l_ohb.* TO NULL
        LET l_ohb.ohb01     = p_oha.oha01
        LET l_ohb.ohb03     = g_cnt
        LET l_ohb.ohb04     = l_ogb.ogb04
        LET l_ohb.ohb05     = l_ogb.ogb05
        LET l_ohb.ohb05_fac = l_ogb.ogb05_fac
        LET l_ohb.ohb06     = l_ogb.ogb06
        LET l_ohb.ohb07     = l_ogb.ogb07
        LET l_ohb.ohb08     = l_ogb.ogb08
        LET l_ohb.ohb09     = l_ogb.ogb09
        LET l_ohb.ohb091    = l_ogb.ogb091
        LET l_ohb.ohb092    = l_ogb.ogb092
        LET l_ohb.ohb12     = l_tot
        LET l_ohb.ohb13     = l_ogb.ogb13
        LET l_ohb.ohb37     = l_ogb.ogb37  #FUN-AB0061
        LET l_ohb.ohb15     = l_ogb.ogb15
        LET l_ohb.ohb15_fac = l_ogb.ogb15_fac
       #LET l_ohb.ohb16     = 0                            #No.MOD-920172 mark
        LET l_ohb.ohb16     = l_ohb.ohb12*l_ohb.ohb15_fac  #No.MOD-920172 add
        LET l_ohb.ohb60     = 0
        LET l_ohb.ohb31     = l_ogb.ogb01
        LET l_ohb.ohb32     = l_ogb.ogb03
        LET l_ohb.ohb33     = l_ogb.ogb31   #訂單單號
        LET l_ohb.ohb34     = l_ogb.ogb32   #訂單項次
        #No.MOD-920175 add --begin
        SELECT ogb19 INTO l_ohb.ohb61 FROM ogb_file
         WHERE ogb01 = l_ohb.ohb31 AND ogb03 = l_ohb.ohb32
        IF cl_null(l_ohb.ohb61) THEN
           SELECT ima24 INTO l_ohb.ohb61 FROM ima_file
            WHERE ima01 = l_ohb.ohb04
        END IF
        #No.MOD-920175 add --end
       #start MOD-640452 add
        IF g_sma.sma115 = 'Y' THEN
           LET l_ohb.ohb910 = l_rmp12       #單位一
           SELECT ima55,ima906,ima907 
             INTO l_ima55,l_ima906,l_ima907    #生產單位,單位使用方式,第二單位
             FROM ima_file 
            WHERE ima01=l_ohb.ohb04 
           CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb910,l_ima55)
                RETURNING g_errno,l_factor
           LET l_ohb.ohb911 = l_factor
           LET l_ohb.ohb912 = l_tot         #單位一數量 
           IF l_ima906 = '1' THEN  #不使用雙單位
              LET l_ohb.ohb913 = NULL
              LET l_ohb.ohb914 = NULL
              LET l_ohb.ohb915 = NULL
           ELSE
              LET l_ohb.ohb913 = l_ima907
              CALL s_du_umfchk(l_ohb.ohb04,'','','',l_ima55,l_ima907,l_ima906)
                   RETURNING g_errno,l_factor
              LET l_ohb.ohb914 = l_factor
              LET l_ohb.ohb915 = 0
           END IF
        END IF
        LET l_ohb.ohb916    = l_rmp12       #計價單位
        LET l_ohb.ohb917    = l_tot         #計價數量
       #end MOD-640452 add
        IF cl_null(l_ohb.ohb04) THEN        #No:7690
            LET l_ohb.ohb04=l_rmp11
        END IF
        IF cl_null(l_ohb.ohb05) THEN        #No:7690
            LET l_ohb.ohb05=l_rmp12
        END IF
        IF cl_null(l_ohb.ohb06) THEN        #No:7690
            LET l_ohb.ohb06=l_rmp13
        END IF
        IF cl_null(l_ohb.ohb05_fac) THEN
           #LET l_ohb.ohb05_fac = 0  #MOD-C30894 mark
            LET l_ohb.ohb05_fac = 1  #MOD-C30894 
        END IF
        IF p_oha.oha213 = 'N' THEN
#           LET l_ohb.ohb14 =l_ohb.ohb12*l_ohb.ohb13    #CHI-B70039 mark
            LET l_ohb.ohb14 =l_ohb.ohb917*l_ohb.ohb13   #CHI-B70039
            LET l_ohb.ohb14t=l_ohb.ohb14*(1+p_oha.oha211/100)
        ELSE
#           LET l_ohb.ohb14t=l_ohb.ohb12*l_ohb.ohb13    #CHI-B70039 mark
            LET l_ohb.ohb14t=l_ohb.ohb917*l_ohb.ohb13   #CHI-B70039
            LET l_ohb.ohb14 =l_ohb.ohb14t/(1+p_oha.oha211/100)
        END IF
        IF cl_null(l_ohb.ohb12)  THEN LET l_ohb.ohb12=0 END IF #No:7690
        IF cl_null(l_ohb.ohb13)  THEN LET l_ohb.ohb13=0 END IF #No:7690
        IF cl_null(l_ohb.ohb14)  THEN LET l_ohb.ohb14=0 END IF
        IF cl_null(l_ohb.ohb14t) THEN LET l_ohb.ohb14t=0 END IF
        IF cl_null(l_ohb.ohb15_fac) THEN LET l_ohb.ohb15_fac=0 END IF
        IF cl_null(l_ohb.ohb16) THEN LET l_ohb.ohb16=0 END IF
        IF cl_null(l_ohb.ohb60) THEN LET l_ohb.ohb60=0 END IF
 
        IF p_oha.oha09='5' THEN
           LET l_ohb.ohb12  = 0
           LET l_ohb.ohb16  = 0
           LET l_ohb.ohb912 = 0
           LET l_ohb.ohb915 = 0
           LET l_ohb.ohb917 = 0
        END IF
        #FUN-680006...............begin
        IF g_aaz.aaz90='Y' THEN
           SELECT ogb930 INTO l_ohb.ohb930 FROM ogb_file 
                                          WHERE ogb01=l_ogb.ogb31
                                            AND ogb03=l_ogb.ogb32
           IF SQLCA.sqlcode THEN
              LET l_ohb.ohb930=NULL
           END IF
        END IF
        #FUN-680006...............end
        LET l_ohb.ohb64='1' #No.FUN-870007
        LET l_ohb.ohb67=0   #No.FUN-870007
        LET l_ohb.ohb68='N' #No.FUN-870007
        LET l_ohb.ohbplant = g_plant #FUN-980007
        LET l_ohb.ohblegal = g_legal #FUN-980007
        LET l_ohb.ohb16 = s_digqty(l_ohb.ohb16,l_ohb.ohb15)    #FUN-BB0085
        #No.TQC-AA0110 --begin
        #IF cl_null(l_ohb.ohb71) THEN    #FUN-AC0055 mark
        #   LET l_ohb.ohb71 = ' '
        #END IF
        #No.TQC-AA0110 --end
        #FUN-AB0061----------add---------------str----------------
        IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
           LET l_ohb.ohb37 = l_ohb.ohb13
        END IF  
        #FUN-AB0061----------add---------------end----------------   
        #FUN-AB0096 ---------add start--------------------
        #IF cl_null(l_ohb.ohb71) THEN    #FUN-AC0055 mark
        #   LET l_ohb.ohb71 = '1'
        #END IF 
        #FUN-AB0096 ------------add end-------------------
        #FUN-CB0087---add---str---
        IF g_aza.aza115 = 'Y' THEN
           CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,p_oha.oha14,p_oha.oha15) RETURNING l_ohb.ohb50
           IF cl_null(l_ohb.ohb50) THEN
              CALL cl_err('','aim-425',1)
              LET g_success = 'N'
           END IF
        END IF
        #FUN-CB0087---add---end---
        INSERT INTO ohb_file VALUES (l_ohb.*)
        IF STATUS OR SQLCA.SQLCODE THEN
    #         CALL cl_err(l_ohb.ohb01,SQLCA.SQLCODE,1)# FUN-660111 
             CALL cl_err3("ins","ohb_file",l_ohb.ohb01,l_ohb.ohb03,SQLCA.sqlcode,"","",1) #FUN-660111
             LET g_success='N'
#FUN-B70074--add--insert--
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_ohbi.* TO NULL
              LET l_ohbi.ohbi01 = l_ohb.ohb01
              LET l_ohbi.ohbi03 = l_ohb.ohb03
              IF NOT s_ins_ohbi(l_ohbi.*,l_ohb.ohbplant ) THEN
                 LET g_success = 'N'  
              END IF
           END IF 
#FUN-B70074--add--insert--
        END IF
    END FOREACH
    IF SQLCA.SQLCODE THEN
        CALL cl_err('rmp_ins_b',SQLCA.SQLCODE,1)
        LET g_success='N'
    END IF
    IF g_success='Y' THEN
       CALL up_oha50(l_ohb.ohb01)
    END IF
 
END FUNCTION
 
FUNCTION up_oha50(p_ohb01)       #更新單頭金額
DEFINE p_ohb01 LIKE ohb_file.ohb01
DEFINE l_oha50 LIKE oha_file.oha50
DEFINE l_oha53 LIKE oha_file.oha53
    LET l_oha50 = NULL
    SELECT SUM(ohb14) INTO l_oha50 FROM ohb_file WHERE ohb01 = p_ohb01
    IF cl_null(l_oha50) THEN LET l_oha50 = 0 END IF
    LET l_oha53 = l_oha50
    IF cl_null(l_oha53) THEN LET l_oha53 = 0 END IF
    UPDATE oha_file SET oha50=l_oha50,
                        oha53=l_oha53
     WHERE oha01 = p_ohb01
    IF STATUS OR SQLCA.SQLCODE THEN
  #     CALL cl_err('_bu():upd oha',SQLCA.SQLCODE,0)# FUN-660111 
       CALL cl_err3("upd","oha_file",p_ohb01,"",SQLCA.sqlcode,"","_bu():upd oha",1) #FUN-660111
    END IF
END FUNCTION
 
FUNCTION t170_z()    # when g_rml.rmlconf='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rml.* FROM rml_file WHERE rml01 = g_rml.rml01 AND rml03 = g_rml.rml03
   IF g_rml.rml01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF NOT cl_null(g_rml.rml04) THEN CALL cl_err('','arm-522',1) RETURN END IF  #NO:7224
   IF g_rml.rmlvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rml.rmlpost='Y' THEN
      CALL cl_err('rmlpost=Y:','aap-730',0)
     #IF g_rml.rmlconf  = 'N' THEN CALL cl_err('conf=N',9025,0) RETURN END IF #MOD-C70071 mark
      RETURN 
   END IF                                                        
   IF g_rml.rmlconf  = 'N' THEN CALL cl_err('conf=N',9025,0) RETURN END IF #MOD-C70071 add
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   LET g_rml_t.* = g_rml.*
   BEGIN WORK
 
 
    OPEN t170_cl USING g_rml.rml01,g_rml.rml03
    IF STATUS THEN
       CALL cl_err("OPEN t170_cl:", STATUS, 1)
       CLOSE t170_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t170_cl INTO g_rml.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rml.rml01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t170_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t170_up_rmpbc('Z')
   IF g_success="N" THEN
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE rml_file SET rmlconf  = 'N',rmlmodu=g_user,
                       rmldate=g_today
          WHERE rml01 = g_rml.rml01 AND rml03=g_rml.rml03
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
 #     CALL cl_err('upd rmlconf',STATUS,1)# FUN-660111 
      CALL cl_err3("upd","rml_file",g_rml.rml01,g_rml.rml03,STATUS,"","upd rmlconf",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN LET g_rml.rmlconf ='N'
           LET g_rml.rmlmodu=g_user LET g_rml.rmldate=g_today
           COMMIT WORK
           CALL cl_cmmsg(3) sleep 1
      ELSE LET g_rml.rmlconf ='Y'
           ROLLBACK WORK
           CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rml.rmlconf,g_rml.rmlmodu,g_rml.rmldate
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rml.rmlconf,"","","","",g_rml.rmlvoid)
END FUNCTION
 
 
FUNCTION t170_up_rmpbc(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_i   LIKE type_file.num5    #No.FUN-690010 SMALLINT
         #g_rmp10 LIKE rmp_file.rmp10
 
   INITIALIZE l_rmp.* TO NULL
   DECLARE t170_pbc CURSOR FOR
     SELECT * FROM rmp_file WHERE rmp00='2' AND rmp01=g_rml.rml01
                              AND rmp011=g_rml.rml03
   FOREACH t170_pbc INTO l_rmp.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('FOREACH rmp:',SQLCA.sqlcode,1)
        LET g_success="N"
        EXIT FOREACH
     END IF
     IF p_cmd="Y" THEN             #當執行 Y.確認時
        UPDATE rmc_file SET rmc21="2",rmc22=g_rml.rml02,
                            rmc23=g_rml.rml01,rmc24=l_rmp.rmp02,
                            rmc231=g_rml.rml03,rmc14="3",
                            rmc312=rmc312+l_rmp.rmp07
               WHERE rmc01=g_rml.rml01 AND rmc02=l_rmp.rmp06
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
  #         CALL cl_err('up rmc:',SQLCA.sqlcode,1)# FUN-660111 
           CALL cl_err3("upd","rmc_file",g_rml.rml01,l_rmp.rmp06,SQLCA.sqlcode,"","up rmc:",1) #FUN-660111
           LET g_success="N"
           EXIT FOREACH
        END IF
       #update rmb: by RMA單,料號
        UPDATE rmb_file SET rmb111=rmb111+l_rmp.rmp07,
                            rmb121=rmb121+l_rmp.rmp07
               WHERE rmb01=g_rml.rml01 AND rmb03=l_rmp.rmp11
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#           CALL cl_err('up rmb:',SQLCA.sqlcode,1)# FUN-660111 
           CALL cl_err3("upd","rmb_file",g_rml.rml01,l_rmp.rmp11,SQLCA.sqlcode,"","up rmb:",1) #FUN-660111
           LET g_success="N"
           EXIT FOREACH
        END IF
        UPDATE rmp_file SET rmp09='3'
               WHERE rmp01 = g_rml.rml01 AND rmp011=g_rml.rml03 AND
                     rmp02 = l_rmp.rmp02 AND rmp00="2"
     ELSE
        IF p_cmd="Z" THEN           #當執行 Z.取消確認時
          UPDATE rmc_file SET rmc21="0",rmc22=NULL,rmc23=NULL,
                              rmc24=NULL,rmc231=NULL,rmc14=l_rmp.rmp10,
                              rmc312=rmc312-l_rmp.rmp07
                WHERE rmc01=g_rml.rml01 AND rmc02=l_rmp.rmp06
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
 #            CALL cl_err('up rmc:',SQLCA.sqlcode,1)# FUN-660111 
             CALL cl_err3("upd","rmc_file",g_rml.rml01,l_rmp.rmp06,SQLCA.sqlcode,"","up rmc:",1) #FUN-660111
             LET g_success="N"
             EXIT FOREACH
          END IF
          #update rmb: by RMA單,料號
          UPDATE rmb_file SET rmb111=rmb111-l_rmp.rmp07,
                              rmb121=rmb121-l_rmp.rmp07
                WHERE rmb01=g_rml.rml01 AND rmb03=l_rmp.rmp11
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
 #            CALL cl_err('up rmb:',SQLCA.sqlcode,1)# FUN-660111 
             CALL cl_err3("upd","rmb_file",g_rml.rml01,l_rmp.rmp11,SQLCA.sqlcode,"","up rmb:",1) #FUN-660111
             LET g_success="N"
             EXIT FOREACH
          END IF
          UPDATE rmp_file SET rmp09=NULL
           WHERE rmp01 = g_rml.rml01 AND rmp011=g_rml.rml03 AND
                 rmp02 = l_rmp.rmp02 AND rmp00="2"
        END IF
     END IF
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('up rmp:',SQLCA.sqlcode,1)
        LET g_success="N"
        EXIT FOREACH
     END IF
   END FOREACH
END FUNCTION

#MOD-B90097---add---start---
FUNCTION t170_up_rma()  # update rma
    UPDATE rma_file SET rma19 = g_today
           WHERE rma01=g_rml.rml01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","rma_file",g_rml.rml01,"",SQLCA.sqlcode,"","up rma 失敗!",1)
          LET g_success = 'N'
          RETURN
       END IF
END FUNCTION
#MOD-B90097---add---end---
 
FUNCTION t170_out()
DEFINE
    sr              RECORD
        rml01       LIKE rml_file.rml01,   # RMA單號
        rml03       LIKE rml_file.rml03,   # 批號
        rml02       LIKE rml_file.rml02,   # 銀退日期
        rma03       LIKE rma_file.rma03,   # 客戶編號
        rma04       LIKE rma_file.rma04,   # 客戶簡稱
        rma13       LIKE rma_file.rma13,   # 業務人員
        gen02       LIKE gen_file.gen02,   # 部門名稱
        rma16       LIKE rma_file.rma16,   # 幣別
        rmp11       LIKE rmp_file.rmp11,   # 料號
        ima02       LIKE ima_file.ima02,   # 品名
        ima021      LIKE ima_file.ima021,  # 規格
        rmp07       LIKE rmp_file.rmp07    # 數量
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
 
DEFINE  l_sql       STRING                 #No.FUN-860018 add                                                                       
                                                                                                                                    
#No.FUN-860018 add---start                                                                                                          
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                          
     CALL cl_del_data(l_table)                                                                                                      
     #------------------------------ CR (2) ------------------------------#                                                         
                                                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-860018 add---end  
    IF cl_null(g_wc) THEN
         LET g_wc=" rml01='",g_rml.rml01,"'"
    END IF
    IF cl_null(g_rml.rml01) THEN
        CALL cl_err('','arm-019',0)
        RETURN
    END IF
    IF cl_null(g_wc2) THEN LET g_wc2=" 1=1 "  END IF    #No:7947
    CALL cl_wait()
#    LET l_name = 'armt170.out'
#    CALL cl_outnam('armt170') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT rml01,rml03,rml02,rma03,rma04,rma13,gen02,rma16, ",
              "        rmp11,ima02,ima021,sum(rmp07) ",
              " FROM rml_file,rmp_file,ima_file,rma_file LEFT JOIN gen_file ON rma13=gen_file.gen01",
              " WHERE rml01=rmp01 AND rmp05=rma01 AND rmp11=ima01 ",
              " AND ",g_wc CLIPPED,
              " GROUP BY rml01,rml03,rml02,rma03,rma04,rma13,gen02,rma16,rmp11,ima02,ima021 ",
              " ORDER BY rml01,rml03 "
 
    PREPARE t170_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t170_co                         # SCROLL CURSOR
        CURSOR FOR t170_p1
 
#    START REPORT t170_rep TO l_name
 
    FOREACH t170_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-860018 add---start                                                                                                  
        ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR-11 **** ##                                                      
        EXECUTE insert_prep USING sr.*                                                                                              
                                                                                                                                    
        IF SQLCA.sqlcode  THEN                                                                                                      
           CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH                                                                        
        END IF                                                                                                                      
        #-----------------------------------CR (3)---------------------------#                                                      
        #No.FUN-860018 add---end 
#        OUTPUT TO REPORT t170_rep(sr.*)
    END FOREACH
    #No.FUN-860018 add---start                                                                                                      
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    #是否列印選擇條件                                                                                                               
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'')                                                                                                       
            RETURNING g_str                                                                                                         
    ELSE                                                                                                                            
       LET g_str = ''                                                                                                               
    END IF                                                                                                                          
    LET g_str = g_str                                                                                                               
    CALL cl_prt_cs3('armt170','armt170',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
    #No.FUN-860018 add---end   
#    FINISH REPORT t170_rep
    CLOSE t170_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---begin
#REPORT t170_rep(sr)
#DEFINE
#   l_last_sw       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#   sr              RECORD
#       rml01       LIKE rml_file.rml01,   # RMA單號
#       rml03       LIKE rml_file.rml03,   # 批號
#       rml02       LIKE rml_file.rml02,   # 銀退日期
#       rma03       LIKE rma_file.rma03,   # 客戶編號
#       rma04       LIKE rma_file.rma04,   # 客戶簡稱
#       rma13       LIKE rma_file.rma13,   # 業務人員
#       gen02       LIKE gen_file.gen02,   # 部門名稱
#       rma16       LIKE rma_file.rma16,   # 幣別
#       rmp11       LIKE rmp_file.rmp11,   # 料號
#       ima02       LIKE ima_file.ima02,   # 品名
#       ima021      LIKE ima_file.ima021,  # 規格
#       rmp07       LIKE rmp_file.rmp07    # 數量
#                   END RECORD
 
#  OUTPUT
#  TOP MARGIN g_top_margin
#  LEFT MARGIN g_left_margin
#  BOTTOM MARGIN g_bottom_margin
#  PAGE LENGTH g_page_line
 
#  ORDER BY sr.rml01,sr.rml03,sr.rmp11
 
#   FORMAT
#     PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<',"/pageno"
#       PRINT COLUMN 01,g_x[9] CLIPPED,sr.rml01,
#             COLUMN 54,g_x[11] CLIPPED,sr.rml02
#       PRINT COLUMN 01,g_x[10] CLIPPED,sr.rml03,
#             COLUMN 54,g_x[14] CLIPPED,sr.rma16
#       PRINT g_x[12] CLIPPED,sr.rma03,"(",sr.rma04,")"
#       PRINT g_x[13] CLIPPED,sr.rma13,"(",sr.gen02,")"
#       PRINT g_head CLIPPED,pageno_total
#       PRINT g_dash
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#       PRINT g_dash1
#       LET l_last_sw = 'n'
 
#       BEFORE GROUP OF sr.rml01
#          SKIP TO TOP OF PAGE
 
#       BEFORE GROUP OF sr.rml03
#          SKIP TO TOP OF PAGE
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[31],sr.rmp11,
#                COLUMN g_c[32],sr.ima02,
#                COLUMN g_c[33],sr.ima021,
#                COLUMN g_c[34],cl_numfor(sr.rmp07,34,0)
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7] CLIPPED
#           LET l_last_sw = 'y'
 
#       PAGE TRAILER
#           IF l_last_sw = 'n' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-860018---end
#No.FUN-890102
#Patch....NO.MOD-5A0095 <001> #
