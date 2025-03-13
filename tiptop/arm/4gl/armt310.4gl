# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt310.4gl
# Descriptions...: 不良品分析單維護作業
# Date & Author..: 98/04/15 By plum
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-560014 05/06/06 By day  單據編號修改
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: NO.MOD-560053 05/07/15 By Yiting armt310
#                  單身輸入后按確定,顯示update ok,但是重查無法顯示單身
#                  單身未輸入資料則取消單頭,但重新查詢后仍然顯示單頭
# Modify.........: NO.MOD-570366 05/07/26 By Yiting
#                  rmd01 開窗傳回之 項次 值應在 RMA 項次 (rmd03) 而非 rmd02
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.MOD-650083 06/05/22 By Pengu 1.按單身進入刪除單身，會無法刪除。
                             #                     2.單身無法新增
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.TQC-6C0213 06/12/31 By chenl 修正單擊修改時重復報錯的bug 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770022 07/07/06 By Smapmin 修改開窗所帶的變數
# Modify.........: No.FUN-7500300 070709 by TSD.pinky ADD CR report
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840227 08/04/20 By jamie 未開視窗畫面,讓user建入RMA單號/項次等 
# Modify.........: No.MOD-840228 08/04/20 By jamie 輸入RMA單號後,料號/品名相關資料未自動帶出.
# Modify.........: No.FUN-840068 08/04/24 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-920114 09/03/02 By chenyu 在單身的最后，增加CALL t310_delall()
# Modify.........: No.MOD-950065 09/05/27 By Smapmin 修正TQC-920114,g_cnt於_b_fill()的最後給0,導致單頭資料無法存檔
# Modify.........: No.MOD-980068 09/08/11 By Smapmin 判斷是否刪除單頭時,重新計算單身的筆數
#                                                    已有t310_delall()的功能,新增時判斷沒有單身時刪除單頭的程式段就不需要
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10011 10/01/06 By Carrier construct加info字段
# Modify.........: No:TQC-A20026 10/02/08 By lilingyu 分析單號查詢狀態下開窗錯誤
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0078 10/11/19 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/27 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/09 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rmi   RECORD LIKE rmi_file.*,
    g_rmi_t RECORD LIKE rmi_file.*,
    g_rmi_o RECORD LIKE rmi_file.*,
    b_rmd   RECORD LIKE rmd_file.*,
    g_rmd           DYNAMIC ARRAY OF RECORD    #程式變數(Prohram Variables)
                    rmd32     LIKE rmd_file.rmd32,
                    rmd01     LIKE rmd_file.rmd01,
                     rmd03     LIKE rmd_file.rmd03,   #NO.MOD-570366
                    rmd02     LIKE rmd_file.rmd02,
                    rmd04     LIKE rmd_file.rmd04,
                    rmd06     LIKE rmd_file.rmd06,
                    rmd061    LIKE rmd_file.rmd061,
                    rmd05     LIKE rmd_file.rmd05,
                    rmd33     LIKE rmd_file.rmd33,
                    rmdud01   LIKE rmd_file.rmdud01,
                    rmdud02   LIKE rmd_file.rmdud02,
                    rmdud03   LIKE rmd_file.rmdud03,
                    rmdud04   LIKE rmd_file.rmdud04,
                    rmdud05   LIKE rmd_file.rmdud05,
                    rmdud06   LIKE rmd_file.rmdud06,
                    rmdud07   LIKE rmd_file.rmdud07,
                    rmdud08   LIKE rmd_file.rmdud08,
                    rmdud09   LIKE rmd_file.rmdud09,
                    rmdud10   LIKE rmd_file.rmdud10,
                    rmdud11   LIKE rmd_file.rmdud11,
                    rmdud12   LIKE rmd_file.rmdud12,
                    rmdud13   LIKE rmd_file.rmdud13,
                    rmdud14   LIKE rmd_file.rmdud14,
                    rmdud15   LIKE rmd_file.rmdud15
                    END RECORD,
    g_rmd_t         RECORD
                    rmd32     LIKE rmd_file.rmd32,
                    rmd01     LIKE rmd_file.rmd01,
                     rmd03     LIKE rmd_file.rmd03,    #NO.MOD-570366
                    rmd02     LIKE rmd_file.rmd02,
                    rmd04     LIKE rmd_file.rmd04,
                    rmd06     LIKE rmd_file.rmd06,
                    rmd061    LIKE rmd_file.rmd061,
                    rmd05     LIKE rmd_file.rmd05,
                    rmd33     LIKE rmd_file.rmd33,
                    rmdud01   LIKE rmd_file.rmdud01,
                    rmdud02   LIKE rmd_file.rmdud02,
                    rmdud03   LIKE rmd_file.rmdud03,
                    rmdud04   LIKE rmd_file.rmdud04,
                    rmdud05   LIKE rmd_file.rmdud05,
                    rmdud06   LIKE rmd_file.rmdud06,
                    rmdud07   LIKE rmd_file.rmdud07,
                    rmdud08   LIKE rmd_file.rmdud08,
                    rmdud09   LIKE rmd_file.rmdud09,
                    rmdud10   LIKE rmd_file.rmdud10,
                    rmdud11   LIKE rmd_file.rmdud11,
                    rmdud12   LIKE rmd_file.rmdud12,
                    rmdud13   LIKE rmd_file.rmdud13,
                    rmdud14   LIKE rmd_file.rmdud14,
                    rmdud15   LIKE rmd_file.rmdud15
                    END RECORD,
    g_rmd_o         RECORD
                    rmd32     LIKE rmd_file.rmd32,
                    rmd01     LIKE rmd_file.rmd01,
                    rmd02     LIKE rmd_file.rmd02,
                    rmd03     LIKE rmd_file.rmd03,
                    rmd04     LIKE rmd_file.rmd04,
                    rmd06     LIKE rmd_file.rmd06,
                    rmd061    LIKE rmd_file.rmd061,
                    rmd05     LIKE rmd_file.rmd05,
                    rmd33     LIKE rmd_file.rmd33,
                    rmdud01   LIKE rmd_file.rmdud01,
                    rmdud02   LIKE rmd_file.rmdud02,
                    rmdud03   LIKE rmd_file.rmdud03,
                    rmdud04   LIKE rmd_file.rmdud04,
                    rmdud05   LIKE rmd_file.rmdud05,
                    rmdud06   LIKE rmd_file.rmdud06,
                    rmdud07   LIKE rmd_file.rmdud07,
                    rmdud08   LIKE rmd_file.rmdud08,
                    rmdud09   LIKE rmd_file.rmdud09,
                    rmdud10   LIKE rmd_file.rmdud10,
                    rmdud11   LIKE rmd_file.rmdud11,
                    rmdud12   LIKE rmd_file.rmdud12,
                    rmdud13   LIKE rmd_file.rmdud13,
                    rmdud14   LIKE rmd_file.rmdud14,
                    rmdud15   LIKE rmd_file.rmdud15
                    END RECORD,
    g_rmi01_t       LIKE rmi_file.rmi01,
    g_wc,g_wc2          LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(300)
    g_sql,g_wc3,l_sql   LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(500)
    g_t,g_t1            LIKE oay_file.oayslip,  #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_auto              LIKE type_file.chr3,    #No.FUN-690010 VARCHAR(3),
    g_err,p_cmd         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_under_line    LIKE type_file.chr1000,     #No.FUN-690010 VARCHAR(80), #FUN-510044
    l_gem02   LIKE gem_file.gem02,
    l_gen02   LIKE gen_file.gen02,
    l_ac      LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl      LIKE type_file.num5               #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1  LIKE rmi_file.rmi01 #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE   l_table  STRING
DEFINE   g_str    STRING
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql="rmi01.rmi_file.rmi01," ,
             " rmi02.rmi_file.rmi02," ,
             " rmi03.rmi_file.rmi03, ",
             " rmi04.rmi_file.rmi04, ",
             " gen02.gen_file.gen02, ",
             " rmd01.rmd_file.rmd01, ",
             " rmd03.rmd_file.rmd03, ",
             " rmd02.rmd_file.rmd02, ",
             " rmd32.rmd_file.rmd32, ",
             " rmd04.rmd_file.rmd04, ",
             " rmd05.rmd_file.rmd05, ",
             " rmd06.rmd_file.rmd06, ",
             " rmd061.rmd_file.rmd061,",  
             " rmd33.rmd_file.rmd33"
   LET l_table = cl_prt_temptable('armt310',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "  VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
  ##by TSD.pinky CR1 end  #FUN-750030
 
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM rmi_file WHERE rmi01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_cl CURSOR FROM g_forupd_sql

    OPEN WINDOW t310_w WITH FORM "arm/42f/armt310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t310_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t310_a()
             END IF
          OTHERWISE 
                CALL t310_q()
       END CASE
    END IF
 
    CALL t310_menu()
    CLOSE WINDOW t310_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION t310_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_rmd.clear()
  IF cl_null(g_argv1) THEN   #FUN-4A0081
    WHILE TRUE
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rmi.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
          rmi01,rmi02,rmi03,rmi04,rmi05,
          rmiconf,                            #No.TQC-A10011                                              
          rmiuser,rmigrup,rmioriu,rmiorig,    #No.TQC-A10011
          rmimodu,rmidate,rmivoid,            #No.TQC-A10011
          #FUN-840068   ---start---
          rmiud01,rmiud02,rmiud03,rmiud04,rmiud05,
          rmiud06,rmiud07,rmiud08,rmiud09,rmiud10,
          rmiud11,rmiud12,rmiud13,rmiud14,rmiud15
          #FUN-840068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
              CASE
                WHEN INFIELD(rmi03)    # 查詢檢驗人員代號及姓名
#                 CALL q_gen(10,22,g_rmi.rmi03) RETURNING g_rmi.rmi03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmi03
                  NEXT FIELD rmi03
                WHEN INFIELD(rmi05)    # 查詢檢驗部門代號及名稱
#                 CALL q_gem(10,22,g_rmi.rmi05) RETURNING g_rmi.rmi05
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmi05
                  NEXT FIELD rmi05
                WHEN INFIELD(rmi01) #查詢單据
#TQC-A20026 --begin-- 
#                  LET g_t1 = s_get_doc_no(g_rmi.rmi01)     #No.FUN-550064
##                 CALL q_oay(0,0,g_t1,'72',g_sys) RETURNING g_t1
#                  #CALL q_oay(TRUE,TRUE,g_t1,'72',g_sys) RETURNING g_qryparam.multiret #TQC-670008
#                  CALL q_oay(TRUE,TRUE,g_t1,'72','ARM') RETURNING g_qryparam.multiret  #TQC-670008
#                  DISPLAY g_qryparam.multiret TO rmi01
#                  NEXT FIELD rmi01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rmi01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmi01
                  NEXT FIELD rmi01
#TQC-A20026 --end--  
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
    EXIT WHILE
    END WHILE
 
 
    #單身QBE查詢
    CONSTRUCT g_wc2 ON rmd32,rmd01,rmd03,rmd02,rmd04,rmd06,rmd061,rmd05,rmd33
                       #No.FUN-840068 --start--
                       ,rmdud01,rmdud02,rmdud03,rmdud04,rmdud05
                       ,rmdud06,rmdud07,rmdud08,rmdud09,rmdud10
                       ,rmdud11,rmdud12,rmdud13,rmdud14,rmdud15
                       #No.FUN-840068 ---end---
         FROM s_rmd[1].rmd32, s_rmd[1].rmd01, s_rmd[1].rmd03, s_rmd[1].rmd02,
              s_rmd[1].rmd04, s_rmd[1].rmd06, s_rmd[1].rmd061, s_rmd[1].rmd05,s_rmd[1].rmd33
              #No.FUN-840068 --start--
              ,s_rmd[1].rmdud01,s_rmd[1].rmdud02,s_rmd[1].rmdud03
              ,s_rmd[1].rmdud04,s_rmd[1].rmdud05,s_rmd[1].rmdud06
              ,s_rmd[1].rmdud07,s_rmd[1].rmdud08,s_rmd[1].rmdud09
              ,s_rmd[1].rmdud10,s_rmd[1].rmdud11,s_rmd[1].rmdud12
              ,s_rmd[1].rmdud13,s_rmd[1].rmdud14,s_rmd[1].rmdud15
              #No.FUN-840068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(rmd04)
#                  CALL q_ima(9,2,g_rmd[1].rmd04) RETURNING g_rmd[1].rmd04
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO rmd04
                   NEXT FIELD rmd04
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  #FUN-4A0081
  ELSE
      LET g_wc =" rmi01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
  #--
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmiuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmigrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmigrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmiuser', 'rmigrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = " SELECT rmi01 FROM rmi_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rmi01"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = " SELECT UNIQUE rmi01 ",
                   " FROM rmi_file, rmd_file",
                   " WHERE rmi01 = rmd31",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rmi01"
    END IF
 
    PREPARE t310_prepare FROM g_sql
    DECLARE t310_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t310_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rmi_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rmi01) FROM rmi_file,rmd_file WHERE ",
                  "rmd31=rmi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t310_precount FROM g_sql
    DECLARE t310_count CURSOR FOR t310_precount
END FUNCTION
 
FUNCTION t310_menu()
 
   WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t310_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t310_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t310_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t310_b('B')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t310_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "檢驗結果"
         WHEN "result"
            IF cl_chk_act_auth() THEN
               CALL t310_b('T')
            END IF
         #IF cl_chk_act_auth() THEN
         #   CALL t310_t()
         #END IF
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t310_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t310_z()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmd),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rmi.rmi01 IS NOT NULL THEN
                 LET g_doc.column1 = "rmi01"
                 LET g_doc.value1 = g_rmi.rmi01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t310_v()    #CHI-D20010
               CALL t310_v(1)   #CHI-D20010
               IF g_rmi.rmiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmi.rmiconf,"","","",g_void,g_rmi.rmivoid)
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t310_v(2)
               IF g_rmi.rmiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmi.rmiconf,"","","",g_void,g_rmi.rmivoid)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t310_a()
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE l_msg       LIKE type_file.chr1000       #No.FUN-690010 VARCHAR(60)
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rmd.clear()
    INITIALIZE g_rmi.* TO NULL
    LET g_rmi_o.* = g_rmi.*
    LET g_rmi01_t = ''   #FUN-B50026 add
    CALL cl_opmsg('a')
    SELECT * INTO g_oay.* FROM oay_file WHERE oaytype='72'
    WHILE TRUE
        INITIALIZE g_rmi.* TO NULL
        LET p_cmd="a"
        LET g_auto="N"
        LET g_rmi.rmiconf='N'
        LET g_rmi.rmivoid='Y'
        LET g_rmi.rmiuser=g_user
        LET g_rmi.rmioriu = g_user #FUN-980030
        LET g_rmi.rmiorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_rmi.rmigrup=g_grup
        LET g_rmi.rmidate=g_today
        LET g_rmi.rmi01=g_oay.oayslip
        LET g_rmi.rmi02=g_today
       #BEGIN WORK        #MOD-950065
        CALL t310_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        IF g_rmi.rmi01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK  #No:7876
      #No.FUN-550064 --start--
        CALL s_auto_assign_no("arm",g_rmi.rmi01,g_today,"72","rmi_file","rmi01","","","")   #No.FUN-560014
        RETURNING li_result,g_rmi.rmi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rmi.rmi01
#       IF g_oay.oayauno='Y' THEN
#           CALL s_armauno(g_rmi.rmi01,g_today) RETURNING g_i,g_rmi.rmi01
#           IF g_i THEN CONTINUE WHILE END IF       #有問題
#           DISPLAY BY NAME g_rmi.rmi01
#       END IF
   #No.FUN-550064 ---end---
 
        LET g_rmi.rmiplant = g_plant  #FUN-980007
        LET g_rmi.rmilegal = g_legal  #FUN-980007
        INSERT INTO rmi_file VALUES (g_rmi.*)
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
           LET  g_success = 'N'
   #        CALL cl_err(g_rmi.rmi01,STATUS,1)#FUN-660111
           CALL cl_err3("ins","rmi_file",g_rmi.rmi01,"",STATUS,"","",1) #FUN-660111
           ROLLBACK WORK  #No:7876
           EXIT  WHILE
        ELSE
           COMMIT WORK    #No:7876
           CALL cl_flow_notify(g_rmi.rmi01,'I')
        END IF
 
        LET g_rmi_o.* = g_rmi.*
        SELECT rmi01 INTO g_rmi.rmi01 FROM rmi_file WHERE rmi01=g_rmi.rmi01
        CALL g_rmd.clear()
        IF cl_confirm('aap-701') THEN
          #CALL cl_err('','arm-110',1)                      #MOD-840227 mark#NO.MOD-530060
          #CALL cl_getmsg('arm-110',g_lang) RETURNING l_msg
          #MESSAGE l_msg
           LET g_rec_b=0                               #No.FUN-680064
           CALL t310_g_b()     #由不良品分析單(rmi) 依QBE條件產生單身:rmd
           IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
           LET g_auto="Y"
        END IF
        CALL t310_b('B')                #單身的conf
        IF INT_FLAG THEN
           LET INT_FLAG=0
          #CALL cl_err('',9044,0)
          #ROLLBACK WORK     #MOD-950065
           INITIALIZE g_rmi.* TO NULL
          #CLEAR FORM
           EXIT WHILE
        END IF
        #-----MOD-980068---------
        #IF g_success="N" OR g_rec_b = 0 THEN
        #    #NO.MOD-560053
        #   IF g_rec_b = 0 THEN
        #       IF cl_confirm('9042') THEN   #單身無值，單頭是否刪除
        #           DELETE FROM rmi_file WHERE rmi01 = g_rmi.rmi01
        #       END IF
        #   END IF
        #   #--END
        #  #ROLLBACK WORK      #MOD-950065
        #ELSE
        #  #COMMIT WORK     #MOD-950065
        #  # CALL cl_msgany(0,0,'新增OK!')
        #END IF
        #-----END MOD-980068----- 
       #CLEAR FORM
       #INITIALIZE g_rmi.* TO NULL
       #CALL t310_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
#由不良品分析單(rmi)依QBE條件自動產生符合的單身
# (rmd01=rmd01 ,rmd02=rmd02,rmd08="2" and rmd31 is not null )
FUNCTION t310_g_b()
DEFINE l_n LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   OPEN WINDOW t3101_w WITH FORM "arm/42f/armt3101"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("armt3101")
 
   CONSTRUCT g_wc3 ON rmd01,rmd03,rmd02,rmd04
      FROM rmd01,rmd03,rmd02,rmd04              #MOD-840027 add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      ON ACTION CONTROLP
      CASE
        WHEN INFIELD(rmd01)
          CALL cl_init_qry_var()
          #LET g_qryparam.form = "q_rma1"
          LET g_qryparam.form = "q_rmc"
          LET g_qryparam.state = 'c'
          LET g_qryparam.arg1 = "70"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO rmd01
          NEXT FIELD rmd01
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
 
      ON ACTION qbe_select
        CALL cl_qbe_select()
      ON ACTION qbe_save
        CALL cl_qbe_save()
 
   END CONSTRUCT
 
   CLOSE WINDOW t3101_w   #MOD-840227 add
 
   IF INT_FLAG THEN RETURN END IF
  #rmd08='2' 表退料:修復時所換下來的料件
   LET l_sql ="SELECT rmd32,rmd01,rmd03,rmd02,rmd04,",
              "       rmd05,rmd06,rmd061,rmd33 ",
              "  FROM rmd_file",
              " WHERE rmd08='2' AND rmd04 !='MISC' ",
              "   AND (rmd31 IS NULL OR rmd31 = ' ')",
              "   AND rmd21 IS NOT NULL ",
              "   AND rmd12 <0 AND ",g_wc3 CLIPPED,
              " ORDER BY rmd04,rmd01,rmd03,rmd02"
   PREPARE t310_gb_prep FROM l_sql
   DECLARE t310_gb_cs CURSOR FOR t310_gb_prep
   LET l_n = 1
   FOREACH t310_gb_cs INTO g_rmd[l_n].*
      IF STATUS THEN EXIT FOREACH END IF
      UPDATE rmd_file SET rmd31=g_rmi.rmi01,
                          rmd32=l_n,rmd33='0'
         WHERE rmd01=g_rmd[l_n].rmd01 AND rmd02=g_rmd[l_n].rmd02
           AND rmd03=g_rmd[l_n].rmd03
      LET g_rmd[l_n].rmd32 = l_n
      LET l_n = l_n + 1
   END FOREACH
   CLOSE t310_gb_cs
   IF l_n = 0 THEN
      CALL cl_err('gen rmd:','mfg3122',0)
      LET INT_FLAG = 1
      RETURN
   END IF
END FUNCTION
 
FUNCTION t310_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
    IF cl_null(g_rmi.rmi01) THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    LET g_rmi01_t = g_rmi.rmi01   #FUN-B50026 add
    IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rmi.rmiconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_rmi.rmiconf = 'Y' THEN  CALL cl_err('conf=Y',9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET p_cmd="u"
    LET g_rmi_o.* = g_rmi.*
 
    BEGIN WORK
 
    OPEN t310_cl USING g_rmi.rmi01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_rmi.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
    CALL t310_show()
    WHILE TRUE
        LET g_rmi.rmimodu=g_user
        LET g_rmi.rmidate=g_today
        CALL t310_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rmi.*=g_rmi_t.*
            CALL t310_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rmi_file SET * = g_rmi.* WHERE rmi01 = g_rmi.rmi01
        IF STATUS THEN 
  #      CALL cl_err(g_rmi.rmi01,STATUS,0)  #FUN-660111
     CALL cl_err3("upd","rmi_file",g_rmi_o.rmi01,"",STATUS,"","",1) #FUN-660111    
         CONTINUE WHILE END IF
       #IF g_rmi.rmi01 != g_rmi_t.rmi01 THEN CALL t310_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rmi.rmi01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION t310_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    DISPLAY BY NAME
            g_rmi.rmi01,g_rmi.rmi02,g_rmi.rmi03,g_rmi.rmi04,g_rmi.rmi05,
            g_rmi.rmiconf,g_rmi.rmiuser,g_rmi.rmigrup,g_rmi.rmimodu,
            g_rmi.rmidate,g_rmi.rmivoid
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_rmi.rmi01,g_rmi.rmi02,g_rmi.rmi03,g_rmi.rmi04, g_rmi.rmioriu,g_rmi.rmiorig,
                  g_rmi.rmi05,  
                  #FUN-840068     ---start---
                  g_rmi.rmiud01,g_rmi.rmiud02,g_rmi.rmiud03,g_rmi.rmiud04,
                  g_rmi.rmiud05,g_rmi.rmiud06,g_rmi.rmiud07,g_rmi.rmiud08,
                  g_rmi.rmiud09,g_rmi.rmiud10,g_rmi.rmiud11,g_rmi.rmiud12,
                  g_rmi.rmiud13,g_rmi.rmiud14,g_rmi.rmiud15 
                  #FUN-840068     ----end----
    WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t310_set_entry(p_cmd)
            CALL t310_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rmi01")
         #No.FUN-550064 ---end---
 
#No.FUN-570109 --start
#      BEFORE FIELD rmi01
#        IF p_cmd="u" THEN NEXT FIELD rmi02 END IF
#No.FUN-570109 --end
 
       AFTER FIELD rmi01
        #No.FUN-550064 --start--
         IF NOT cl_null(g_rmi.rmi01) THEN       #No.TQC-6C0213   
           #IF p_cmd='a' THEN                   #No.TQC-6C0213   #FUN-B50026 mark更改狀態也應控管
              #IF g_rmi.rmi01 != g_rmi01_t OR g_rmi01_t IS NULL THEN   #No.TQC-6C0213 mark
               CALL s_check_no("arm",g_rmi.rmi01,g_rmi01_t,"72","rmi_file","rmi01","")
               RETURNING li_result,g_rmi.rmi01
               IF (NOT li_result) THEN
                  NEXT FIELD rmi01
               END IF
               DISPLAY BY NAME g_rmi.rmi01
           #END IF       #No.TQC-6C0213  #FUN-B50026 mark
#        IF NOT cl_null(g_rmi.rmi01) THEN
#            LET g_t=g_rmi.rmi01[1,3]
#            CALL s_axmslip(g_t,'72',g_sys)           #檢查 不良品單別: 72
#            IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                  CALL cl_err(g_t,g_errno,0)
#                  NEXT FIELD rmi01
#            END IF
#            IF cl_null(g_rmi.rmi01[5,10]) AND NOT cl_null(g_rmi.rmi01[1,3]) THEN
#               IF g_oay.oayauno = 'N' THEN
#                  CALL cl_err('','aap-011',0)  #此單別無自動編號,需人工
#                  NEXT FIELD rmi01
#               ELSE
#                  NEXT FIELD rmi02
#               END IF
#            END IF
#
#            IF g_rmi.rmi01 != g_rmi01_t OR g_rmi_o.rmi01 IS NULL THEN
#                IF g_oay.oayauno = 'Y' AND NOT cl_chk_data_continue(g_rmi.rmi01[5,10]) THEN
#                   CALL cl_err('','9056',0) NEXT FIELD rmi01
#                END IF
#                SELECT count(*) INTO g_cnt FROM rmi_file
#                    WHERE rmi01 = g_rmi.rmi01
#                IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err(g_rmi.rmi01,-239,0)
#                    LET g_rmi.rmi01 = g_rmi_o.rmi01
#                    DISPLAY BY NAME g_rmi.rmi01
#                    NEXT FIELD rmi01
#                END IF
#            END IF
#            LET g_rmi_o.rmi01 = g_rmi.rmi01
         #No.FUN-550064 ---end---
        END IF
 
      AFTER FIELD rmi03
        IF NOT cl_null(g_rmi.rmi03) THEN
           SELECT gen02,gen03 INTO l_gen02,g_rmi.rmi05 FROM gen_file
                  WHERE gen01=g_rmi.rmi03
           IF STATUS THEN
              LET g_rmi.rmi03=g_rmi_o.rmi03 LET g_rmi.rmi05=g_rmi_o.rmi05
              DISPLAY BY NAME g_rmi.rmi03,g_rmi.rmi05
   #           CALL cl_err('','aap-038',0)
              CALL cl_err3("sel","gen_file",g_rmi.rmi03,"","aap-038","","",1) #FUN-660111
              NEXT FIELD rmi03 END IF
           DISPLAY BY NAME g_rmi.rmi03,g_rmi.rmi05
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_rmi.rmi05
              AND gemacti='Y'   #NO:6950
           DISPLAY l_gen02,l_gem02 TO gen02,gem02
        END IF
 
      AFTER FIELD rmi05
        IF NOT cl_null(g_rmi.rmi05) THEN
          SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_rmi.rmi05
             AND gemacti='Y'   #NO:6950
          IF STATUS THEN
             LET g_rmi.rmi05 = g_rmi_o.rmi05
   #         CALL cl_err('','aap-039',0) #FUN-660111
            CALL cl_err3("sel","gem_file",g_rmi.rmi05,"","aap-039","","",1) #FUN-660111
             DISPLAY BY NAME g_rmi.rmi05
             NEXT FIELD rmi05 END IF
          DISPLAY l_gem02 TO gem02
        END IF
 
      #FUN-840068     ---start---
      AFTER FIELD rmiud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmiud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840068     ----end----
 
      ON ACTION CONTROLP
              CASE
                WHEN INFIELD(rmi03)    # 查詢檢驗人員代號及姓名
#                 CALL q_gen(10,22,g_rmi.rmi03) RETURNING g_rmi.rmi03
#                 CALL FGL_DIALOG_SETBUFFER( g_rmi.rmi03 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_rmi.rmi03
                  CALL cl_create_qry() RETURNING g_rmi.rmi03
#                  CALL FGL_DIALOG_SETBUFFER( g_rmi.rmi03 )
                  DISPLAY BY NAME g_rmi.rmi03
                  NEXT FIELD rmi03
                WHEN INFIELD(rmi05)    # 查詢檢驗部門代號及名稱
#                 CALL q_gem(10,22,g_rmi.rmi05) RETURNING g_rmi.rmi05
#                 CALL FGL_DIALOG_SETBUFFER( g_rmi.rmi05 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_rmi.rmi05
                  CALL cl_create_qry() RETURNING g_rmi.rmi05
#                  CALL FGL_DIALOG_SETBUFFER( g_rmi.rmi05 )
                  DISPLAY BY NAME g_rmi.rmi05
                  NEXT FIELD rmi05
                WHEN INFIELD(rmi01) #查詢單据
                  LET g_t1 = s_get_doc_no(g_rmi.rmi01)     #No.FUN-550064
#                 CALL q_oay(0,0,g_t1,'72',g_sys) RETURNING g_t1
                  #CALL q_oay(FALSE,FALSE,g_t1,'72',g_sys) RETURNING g_t1 #TQC-670008
                  CALL q_oay(FALSE,FALSE,g_t1,'72','ARM') RETURNING g_t1  #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET g_rmi.rmi01[1,3]=g_t1
                  LET g_rmi.rmi01 = g_t1                 #No.FUN-550064
                  DISPLAY BY NAME g_rmi.rmi01
                  NEXT FIELD rmi01
              END CASE
 
    ON ACTION CONTROLF                  #欄位說明
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
 
FUNCTION t310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rmi.* TO NULL              #No.FUN-6A0018
    CALL cl_opmsg('q')
    LET p_cmd="u"
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
    CALL t310_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0
       INITIALIZE g_rmi.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rmi.* TO NULL
    ELSE
        OPEN t310_count
        FETCH t310_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
    LET g_auto="N"
END FUNCTION
 
 
FUNCTION t310_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t310_cs INTO g_rmi.rmi01
        WHEN 'P' FETCH PREVIOUS t310_cs INTO g_rmi.rmi01
        WHEN 'F' FETCH FIRST    t310_cs INTO g_rmi.rmi01
        WHEN 'L' FETCH LAST     t310_cs INTO g_rmi.rmi01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t310_cs INTO g_rmi.rmi01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)
        INITIALIZE g_rmi.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0) #FUN-660111
      CALL cl_err3("sel","rmi_file",g_rmi.rmi01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rmi.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rmi.rmiuser #FUN-4C0055
        LET g_data_group = g_rmi.rmigrup #FUN-4C0055
        LET g_data_plant = g_rmi.rmiplant #FUN-980030
    END IF
 
    CALL t310_show()
END FUNCTION
 
 
FUNCTION t310_show()
    LET g_rmi_t.* = g_rmi.*                #保存單頭舊值
    DISPLAY BY NAME g_rmi.rmioriu,g_rmi.rmiorig,
 
 
        g_rmi.rmi01,g_rmi.rmi02,g_rmi.rmi03,g_rmi.rmi04,g_rmi.rmi05,
        g_rmi.rmiconf,g_rmi.rmivoid,
        g_rmi.rmiuser,g_rmi.rmigrup,g_rmi.rmimodu,g_rmi.rmidate,
        #FUN-840068     ---start---
        g_rmi.rmiud01,g_rmi.rmiud02,g_rmi.rmiud03,g_rmi.rmiud04,
        g_rmi.rmiud05,g_rmi.rmiud06,g_rmi.rmiud07,g_rmi.rmiud08,
        g_rmi.rmiud09,g_rmi.rmiud10,g_rmi.rmiud11,g_rmi.rmiud12,
        g_rmi.rmiud13,g_rmi.rmiud14,g_rmi.rmiud15 
        #FUN-840068     ----end----
 
    #CKP
    #CALL cl_set_field_pic(g_rmi.rmiconf  ,"","","","",g_rmi.rmivoid)  #CHI-C80041
    IF g_rmi.rmiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_rmi.rmiconf,"","","",g_void,g_rmi.rmivoid)  #CHI-C80041
    CALL t310_rmi03()   #顯示參考值
    DISPLAY l_gen02,l_gem02 TO gen02,gem02
    CALL t310_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t310_rmi03()
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rmi.rmi03
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_rmi.rmi05
END FUNCTION
 
FUNCTION t310_b(r_cmd)
DEFINE
    l_ac_t            LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_row,l_col       LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #分段輸入之行,列數
     l_cnt1           LIKE type_file.num5,     #MOD-560053  #No.FUN-690010 SMALLINT
    l_n,l_cnt         LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw         LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    r_cmd             LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               #處理狀態: B,T(檢驗結果)
    g_rmd32,l_i       LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
    IF g_rmi.rmi01 IS NULL THEN RETURN END IF
    IF g_rmi.rmiconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_rmi.rmiconf = 'Y' THEN CALL cl_err('conf=Y',9003,0) RETURN END IF
    IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
    IF g_auto="Y" THEN
       CALL t310_b_fill(g_wc3)
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql =
     " SELECT rmd32,rmd01,rmd03,rmd02,rmd04,rmd06,rmd061,rmd05,rmd33, ",
     "        rmdud01,rmdud02,rmdud03,rmdud04,rmdud05,",
     "        rmdud06,rmdud07,rmdud08,rmdud09,rmdud10,",
     "        rmdud11,rmdud12,rmdud13,rmdud14,rmdud15 ", 
     "  FROM rmd_file ",
     " WHERE rmd31= ? AND rmd32= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_rmd WITHOUT DEFAULTS FROM s_rmd.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,
                      DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL t310_set_entry_b(r_cmd)
            CALL t310_set_no_entry_b(r_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-550064 --start--
            CALL cl_set_docno_format("rmd01")
            #No.FUN-550064 ---end---
 
        BEFORE ROW
            #CKP
        #   LET p_cmd = 'u'   #FUN-D40030 mark
            LET p_cmd = ''    #FUN-D40030 add 
            LET l_ac = ARR_CURR()
            LET g_rec_b = ARR_COUNT()
         #  LET g_rmd_t.* = g_rmd[l_ac].*  #BACKUP    #FUN-D40030 mark
         #  LET g_rmd_o.* = g_rmd[l_ac].*             #新輸入資料 #FUN-D40030 mark
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t310_cl USING g_rmi.rmi01
            IF STATUS THEN
               CALL cl_err("OPEN t310_cl:", STATUS, 1)
               CLOSE t310_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t310_cl INTO g_rmi.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t310_cl ROLLBACK WORK RETURN
            END IF
      #FUN-D40030--add--str--
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_rmd_t.* = g_rmd[l_ac].*  #BACKUP
               LET g_rmd_o.* = g_rmd[l_ac].*  #BACKUP
                OPEN t310_bcl USING g_rmi.rmi01,g_rmd_t.rmd32
                IF STATUS THEN
                    CALL cl_err("OPEN t310_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t310_bcl INTO g_rmd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmd_t.rmd32,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET p_cmd='u'
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
        #   CALL cl_show_fld_cont()     #FUN-550037(smin)   #FUN-D40030 mark
        #   NEXT FIELD rmd32            #FUN-D40030 mark
      #FUN-D40030--add--end--
 
        BEFORE FIELD rmd32                  #default項次
          IF g_auto="N" THEN
             IF g_rmd[l_ac].rmd32 IS NULL OR g_rmd[l_ac].rmd32 = 0 THEN
                SELECT max(rmd32)+1 INTO g_rmd[l_ac].rmd32
                  FROM rmd_file WHERE rmd31 = g_rmi.rmi01
                IF g_rmd[l_ac].rmd32 IS NULL THEN
                   LET g_rmd[l_ac].rmd32 = 1
                END IF
             END IF
          END IF
 
        AFTER FIELD rmd32               #check 項次是否重複
          IF g_auto="N" THEN
              IF NOT cl_null(g_rmd[l_ac].rmd32) THEN
                  IF g_rmd[l_ac].rmd32 != g_rmd_t.rmd32 OR
                     g_rmd_t.rmd32 IS NULL THEN
                     SELECT count(*) INTO l_n FROM rmd_file
                       WHERE rmd31 = g_rmi.rmi01 AND rmd32 = g_rmd[l_ac].rmd32
                     IF l_n > 0 THEN
                        LET g_rmd[l_ac].rmd32 = g_rmd_t.rmd32
                        CALL cl_err('',-239,0) NEXT FIELD rmd32
                     END IF
                  END IF
              END IF
          END IF
 
       AFTER FIELD rmd01
         IF NOT cl_null(g_rmd[l_ac].rmd01) THEN
             SELECT count(*) INTO l_cnt FROM rmc_file #檢查RMA維修明細有無此單號
                  WHERE rmc01 = g_rmd[l_ac].rmd01
             IF l_cnt =0 THEN           #若找不到
                CALL cl_err('','arm-004',0) NEXT FIELD rmd01
               #CKP
             END IF
         END IF
 
       #AFTER FIELD rmd02  應在AFTER FIELD rmd03再處理，不然call t310_get_rmd( )
       AFTER FIELD rmd03
        #NO.MOD-560053
         IF NOT cl_null(g_rmd[l_ac].rmd03) THEN
             LET l_cnt1 = 0
             SELECT count(*) INTO l_cnt1 FROM rmc_file #檢查RMA維修明細有無此單>
                  WHERE rmc01 = g_rmd[l_ac].rmd01
                    AND rmc02 = g_rmd[l_ac].rmd03
             IF l_cnt1 =0 THEN           #若找不到
                CALL cl_err('','arm-004',0) NEXT FIELD rmd01
               #CKP
             END IF
         END IF
       #--END
 
      AFTER FIELD rmd02
          IF g_auto="N" THEN
             IF NOT cl_null(g_rmd[l_ac].rmd02) THEN
                 IF g_rmd_o.rmd01 != g_rmd[l_ac].rmd01 OR
                    g_rmd_o.rmd02 != g_rmd[l_ac].rmd02 OR
                     g_rmd_o.rmd03 != g_rmd[l_ac].rmd03 OR  #MOD-560053
                    g_rmd_o.rmd01 IS NULL OR g_rmd_o.rmd02 IS NULL #THEN
                     OR g_rmd_o.rmd03 IS NULL THEN  #MOD-560053
                    LET g_err="N"
                    CALL t310_get_rmd()
                    IF g_err="Y" OR g_rmd[l_ac].rmd04 = 'MISC' THEN
                       CALL cl_err(g_rmd[l_ac].rmd04,'aap-129',0)
                       LET g_rmd[l_ac].rmd01 = g_rmd_o.rmd01
                       LET g_rmd[l_ac].rmd02 = g_rmd_o.rmd02
                       LET g_rmd[l_ac].rmd03 = g_rmd_o.rmd03
                       LET g_rmd[l_ac].rmd04 = g_rmd_o.rmd04
                       LET g_rmd[l_ac].rmd05 = g_rmd_o.rmd05
                       LET g_rmd[l_ac].rmd06 = g_rmd_o.rmd06
                       LET g_rmd[l_ac].rmd061= g_rmd_o.rmd061
                       LET g_rmd[l_ac].rmd33 = g_rmd_o.rmd33
                       DISPLAY g_rmd[l_ac].* TO s_rmd[l_ac].*
                       NEXT FIELD rmd01
                    END IF
                 END IF
             END IF
          END IF
 
       AFTER FIELD rmd33     # check 判定結果
         IF NOT cl_null(g_rmd[l_ac].rmd33) THEN
             IF g_rmd[l_ac].rmd33 NOT MATCHES '[0123]' THEN
                NEXT FIELD rmd33
             END IF
         END IF
 
       #No.FUN-840068 --start--
       AFTER FIELD rmdud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmdud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_rmd_t.rmd32 > 0 AND g_rmd_t.rmd32 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             UPDATE rmd_file SET rmd31=NULL,rmd32=NULL,rmd33=NULL
                 WHERE rmd01 = g_rmd_t.rmd01 AND
                       rmd02 = g_rmd_t.rmd02 AND
                       rmd03 = g_rmd_t.rmd03
             IF SQLCA.sqlcode THEN
 #                CALL cl_err(g_rmd_t.rmd01,SQLCA.sqlcode,0) # FUN-660111
                 CALL cl_err3("upd","rmd_file",g_rmd_t.rmd01,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                 ROLLBACK WORK
                 CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
 
         ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rmd[l_ac].* = g_rmd_t.*
                CLOSE t310_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmd[l_ac].rmd32,-263,1)
                LET g_rmd[l_ac].* = g_rmd_t.*
             ELSE
                     UPDATE rmd_file SET
                        rmd32=g_rmd[l_ac].rmd32,
                        rmd01=g_rmd[l_ac].rmd01,
                        rmd02=g_rmd[l_ac].rmd02,
                        rmd03=g_rmd[l_ac].rmd03,
                        rmd04=g_rmd[l_ac].rmd04,
                        rmd05=g_rmd[l_ac].rmd05,
                        rmd06=g_rmd[l_ac].rmd06,
                        rmd061=g_rmd[l_ac].rmd061,
                        rmd33=g_rmd[l_ac].rmd33,
                        rmd31=g_rmi.rmi01,
                        #FUN-840068 --start--
                        rmdud01 = g_rmd[l_ac].rmdud01,
                        rmdud02 = g_rmd[l_ac].rmdud02,
                        rmdud03 = g_rmd[l_ac].rmdud03,
                        rmdud04 = g_rmd[l_ac].rmdud04,
                        rmdud05 = g_rmd[l_ac].rmdud05,
                        rmdud06 = g_rmd[l_ac].rmdud06,
                        rmdud07 = g_rmd[l_ac].rmdud07,
                        rmdud08 = g_rmd[l_ac].rmdud08,
                        rmdud09 = g_rmd[l_ac].rmdud09,
                        rmdud10 = g_rmd[l_ac].rmdud10,
                        rmdud11 = g_rmd[l_ac].rmdud11,
                        rmdud12 = g_rmd[l_ac].rmdud12,
                        rmdud13 = g_rmd[l_ac].rmdud13,
                        rmdud14 = g_rmd[l_ac].rmdud14,
                        rmdud15 = g_rmd[l_ac].rmdud15
                       WHERE rmd01=g_rmd_t.rmd01 AND
                             rmd02=g_rmd_t.rmd02 AND rmd03=g_rmd_t.rmd03
                       IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rmd_file",g_rmd_t.rmd01,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111 
                           LET g_rmd[l_ac].* = g_rmd_t.*
                           DISPLAY g_rmd[l_ac].* TO s_rmd[l_sl].*
                       ELSE
                            MESSAGE 'UPDATE O.K'
                            COMMIT WORK
                       END IF
             END IF

         AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rmd[l_ac].* = g_rmd_t.*
                CLOSE t310_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmd[l_ac].rmd32,-263,1)
                LET g_rmd[l_ac].* = g_rmd_t.*
             ELSE
                     UPDATE rmd_file SET
                        rmd32=g_rmd[l_ac].rmd32,
                        rmd01=g_rmd[l_ac].rmd01,
                        rmd02=g_rmd[l_ac].rmd02,
                        rmd03=g_rmd[l_ac].rmd03,
                        rmd04=g_rmd[l_ac].rmd04,
                        rmd05=g_rmd[l_ac].rmd05,
                        rmd06=g_rmd[l_ac].rmd06,
                        rmd061=g_rmd[l_ac].rmd061,
                        rmd33=g_rmd[l_ac].rmd33,
                        rmd31=g_rmi.rmi01,
                        #FUN-840068 --start--
                        rmdud01 = g_rmd[l_ac].rmdud01,
                        rmdud02 = g_rmd[l_ac].rmdud02,
                        rmdud03 = g_rmd[l_ac].rmdud03,
                        rmdud04 = g_rmd[l_ac].rmdud04,
                        rmdud05 = g_rmd[l_ac].rmdud05,
                        rmdud06 = g_rmd[l_ac].rmdud06,
                        rmdud07 = g_rmd[l_ac].rmdud07,
                        rmdud08 = g_rmd[l_ac].rmdud08,
                        rmdud09 = g_rmd[l_ac].rmdud09,
                        rmdud10 = g_rmd[l_ac].rmdud10,
                        rmdud11 = g_rmd[l_ac].rmdud11,
                        rmdud12 = g_rmd[l_ac].rmdud12,
                        rmdud13 = g_rmd[l_ac].rmdud13,
                        rmdud14 = g_rmd[l_ac].rmdud14,
                        rmdud15 = g_rmd[l_ac].rmdud15
                        #FUN-840068 --end-- 
                       WHERE rmd01=g_rmd[l_ac].rmd01 AND
                             rmd02=g_rmd[l_ac].rmd02 AND 
                             rmd03=g_rmd[l_ac].rmd03
                       IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","rmd_file",g_rmd_t.rmd01,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                           LET g_rmd[l_ac].* = g_rmd_t.*
                           DISPLAY g_rmd[l_ac].* TO s_rmd[l_sl].*
                       ELSE
                            MESSAGE 'INSERT O.K'
                            COMMIT WORK
                       END IF
             END IF
     #FUN-D40030--add--str--
         BEFORE INSERT
            LET p_cmd = 'a'
            LET g_rmd_t.* = g_rmd[l_ac].*  #BACKUP
            LET g_rmd_o.* = g_rmd[l_ac].*             #新輸入資料
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont()
            NEXT FIELD rmd32
     #FUN-D40030--add--end--
 
         AFTER ROW
             LET l_ac = ARR_CURR()
         #   LET l_ac_t = l_ac   #FUN-D40030 mark
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                #CKP
                IF p_cmd='u' THEN
                   LET g_rmd[l_ac].* = g_rmd_t.*
            #FUN-D40030--add--str--
                ELSE
                   CALL g_rmd.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
            #FUN-D40030--add--end--
                END IF
                CLOSE t310_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac   #FUN-D40030 add
             #CKP
             #LET g_rmd_t.* = g_rmd[l_ac].*          # 900423
             CLOSE t310_bcl
             COMMIT WORK
 
 
         # ON ACTION CONTROLN
         #    CALL t310_b_askkey()
         #    EXIT INPUT
 
           ON ACTION CONTROLO                        #沿用所有欄位
              IF INFIELD(rmd32) AND l_ac > 1 THEN
                 LET g_rmd[l_ac].* = g_rmd[l_ac-1].*
                 LET g_rmd[l_ac].rmd32 = NULL
                 NEXT FIELD rmd32
              END IF
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(rmd01)
#                  CALL q_rma1(3,2,g_rmd[l_ac].rmd01,'70')
#                       RETURNING g_rmd[l_ac].rmd01,g_rmd[l_ac].rmd02
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rma1"
                   LET g_qryparam.default1 = g_rmd[l_ac].rmd01
                   LET g_qryparam.arg1 = "70"
                   LET g_qryparam.arg2 = g_doc_len   #MOD-770022
                   CALL cl_create_qry()
                        RETURNING g_rmd[l_ac].rmd01,g_rmd[l_ac].rmd03    #No.MOD-650083 modify
                    DISPLAY BY NAME g_rmd[l_ac].rmd03         #No.MOD-490371 #No.MOD-650083 modify
                 WHEN INFIELD(rmd04)
#                  CALL q_ima(9,2,g_rmd[l_ac].rmd04)
#                       RETURNING g_rmd[l_ac].rmd04
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.default1 = g_rmd[l_ac].rmd04
#                   CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd04
                   CALL q_sel_ima(FALSE, "q_ima","",g_rmd[l_ac].rmd04,"","","","","",'' ) 
                      RETURNING  g_rmd[l_ac].rmd04

#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_rmd[l_ac].rmd04         #No.MOD-490371
               END CASE
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG CALL cl_cmdask()
          ON ACTION CONTROLN CALL t310_b_askkey()
 
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
    LET g_rmi.rmimodu = g_user
    LET g_rmi.rmidate = g_today
    UPDATE rmi_file SET rmimodu = g_rmi.rmimodu,rmidate = g_rmi.rmidate
     WHERE rmi01 = g_rmi.rmi01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd rmi',SQLCA.SQLCODE,1) #FUN-660111
      CALL cl_err3("upd","rmi_file",g_rmi.rmi01,"",SQLCA.sqlcode,"","upd rmi",1) #FUN-660111
    END IF
    DISPLAY BY NAME g_rmi.rmimodu,g_rmi.rmidate
   #FUN-5B0113-end
 
    LET g_success="Y"
    IF INT_FLAG THEN
       LET g_success = "N"
       IF p_cmd="a" THEN RETURN
       ELSE LET INT_FLAG=0 CALL cl_err('',9001,1)
            ROLLBACK WORK
            CALL t310_show()
            RETURN END IF
    END IF
#   CALL t310_delall()     #No.TQC-920114 add #CHI-C30002 mark
    CALL t310_delHeader()     #CHI-C30002 add
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t310_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rmi.rmi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rmi_file ",
                  "  WHERE rmi01 LIKE '",l_slip,"%' ",
                  "    AND rmi01 > '",g_rmi.rmi01,"'"
      PREPARE t310_pb1 FROM l_sql 
      EXECUTE t310_pb1 INTO l_cnt       
      
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
        #CALL t310_v()
         CALL t310_v(1)  #CHI-D20010
         IF g_rmi.rmiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_rmi.rmiconf,"","","",g_void,g_rmi.rmivoid)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rmi_file WHERE rmi01 = g_rmi.rmi01
         INITIALIZE g_rmi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t310_get_rmd()
  DEFINE l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
        SELECT rmd04,rmd05,rmd06,rmd061,rmd33
              INTO g_rmd[l_ac].rmd04,g_rmd[l_ac].rmd05,g_rmd[l_ac].rmd06,
                   g_rmd[l_ac].rmd061,g_rmd[l_ac].rmd33
              FROM rmd_file
              WHERE rmd01=g_rmd[l_ac].rmd01 AND rmd02=g_rmd[l_ac].rmd02
                AND rmd03=g_rmd[l_ac].rmd03
             #MOD-840228---mark---str---
             ##-----------No.MOD-650083 modify 
             # #AND rmd31 IS NULL AND rmd08="2" AND rmd12 <0
             #  AND (rmd31 IS NULL OR rmd31 = ' ')
             #  AND rmd08="2" AND rmd12 <0
             ##-----------No.MOD-650083  end
             #MOD-840228---mark---end---
        IF SQLCA.sqlcode THEN LET g_err="Y" RETURN END IF
       #IF SQLCA.sqlcode OR l_cnt =0 THEN LET g_err="Y" RETURN END IF
       #IF g_rmd_o.rmd01 IS NULL THEN LET g_err="Y" END IF
END FUNCTION
 
FUNCTION t310_delall()
    #-----MOD-980068---------
    SELECT count(*) INTO g_cnt FROM rmd_file
        WHERE rmd31 = g_rmi.rmi01
    #-----END MOD-980068-----
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM rmi_file WHERE rmi01 = g_rmi.rmi01
    END IF
END FUNCTION
 
FUNCTION t310_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
 CONSTRUCT l_wc2 ON rmd32,rmd01,rmd04,rmd04,rmd05,rmd06,rmd061,rmd05
                    #No.FUN-840068 --start--
                    ,rmdud01,rmdud02,rmdud03,rmdud04,rmdud05
                    ,rmdud06,rmdud07,rmdud08,rmdud09,rmdud10
                    ,rmdud11,rmdud12,rmdud13,rmdud14,rmdud15
                    #No.FUN-840068 ---end---
     FROM s_rmd[1].rmd32, s_rmd[1].rmd01, s_rmd[1].rmd04,
          s_rmd[1].rmd04, s_rmd[1].rmd05, s_rmd[1].rmd06,
          s_rmd[1].rmd061,s_rmd[1].rmd05
          #No.FUN-840068 --start--
          ,s_rmd[1].rmdud01,s_rmd[1].rmdud02,s_rmd[1].rmdud03,s_rmd[1].rmdud04
          ,s_rmd[1].rmdud05,s_rmd[1].rmdud06,s_rmd[1].rmdud07,s_rmd[1].rmdud08
          ,s_rmd[1].rmdud09,s_rmd[1].rmdud10,s_rmd[1].rmdud11,s_rmd[1].rmdud12
          ,s_rmd[1].rmdud13,s_rmd[1].rmdud14,s_rmd[1].rmdud15
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
    CALL t310_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t310_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
      LET l_sql =
            "SELECT rmd32,rmd01,rmd03,rmd02,rmd04,rmd06,rmd061,rmd05,rmd33, ", #MOD-560053
            #No.FUN-840068 --start--
            "       rmdud01,rmdud02,rmdud03,rmdud04,rmdud05,",
            "       rmdud06,rmdud07,rmdud08,rmdud09,rmdud10,",
            "       rmdud11,rmdud12,rmdud13,rmdud14,rmdud15 ", 
            #No.FUN-840068 ---end---
           " FROM rmi_file,rmd_file ",
           " WHERE rmd31 ='",g_rmi.rmi01,"'",  # 單頭
           " AND rmi01=rmd31 ",
           " AND ",p_wc2 CLIPPED,              # 單身
           " ORDER BY rmd04,rmd01,rmd03,rmd02"
 
    PREPARE t310_pb FROM l_sql
    DECLARE rmd_curs                       #SCROLL CURSOR
        CURSOR FOR t310_pb
 
    CALL g_rmd.clear()
    LET g_cnt = 1
    FOREACH rmd_curs INTO g_rmd[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_rmd[g_cnt].rmd33 is null then let g_rmd[g_cnt].rmd33='0' end if
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
   #LET g_cnt = 0     #MOD-950065
END FUNCTION
 
FUNCTION t310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmd TO s_rmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL t310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t310_fetch('L')
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
         #CALL cl_set_field_pic(g_rmi.rmiconf  ,"","","","",g_rmi.rmivoid)  #CHI-C80041
         IF g_rmi.rmiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_rmi.rmiconf,"","","",g_void,g_rmi.rmivoid)  #CHI-C80041
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 檢驗結果
      ON ACTION result
         LET g_action_choice="result"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
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
 
 
FUNCTION t310_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    sr              RECORD
        rmi01       LIKE rmi_file.rmi01,   #
        rmi02       LIKE rmi_file.rmi02,   #
        rmi03       LIKE rmi_file.rmi03,  #
        rmi04       LIKE rmi_file.rmi04,  #
        gen02       LIKE gen_file.gen02,  #
        rmd01       LIKE rmd_file.rmd01,   #
        rmd03       LIKE rmd_file.rmd03,   #
        rmd02       LIKE rmd_file.rmd02,   #
        rmd32       LIKE rmd_file.rmd32,   #
        rmd04       LIKE rmd_file.rmd04,   #
        rmd05       LIKE rmd_file.rmd05,   #
        rmd06       LIKE rmd_file.rmd06,   #
        rmd061      LIKE rmd_file.rmd061,  #
        rmd33       LIKE rmd_file.rmd33
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #  #No.FUN-690010 VARCHAR(40)
 
      CALL cl_del_data(l_table)  #by TSD.pinky CR2  FUN-750030
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'armt310
'
    IF g_wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    LET l_name = 'armt310.out'
  #  CALL cl_outnam('armt310') RETURNING l_name  #FUN-750030
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT rmi01,rmi02,rmi03,rmi04,gen02,rmd01,rmd03,rmd02, ",
              " rmd32,rmd04,rmd05,rmd06,rmd061,rmd33",
              " FROM rmi_file LEFT JOIN gen_file ON rmi03=gen_file.gen01 ,rmd_file",
              " WHERE rmi01=rmd31 AND rmi03=gen01 ",
              " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
    PREPARE t310_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t310_co                         # SCROLL CURSOR
        CURSOR FOR t310_p1
 
   # START REPORT t310_rep TO l_name  #FUN-750030
    FOR g_i = 1 TO 80 LET g_under_line[g_i,g_i] = '_' END FOR
 
    FOREACH t310_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         EXECUTE insert_prep USING sr.*   #FUN-750030
    END FOREACH
 
  #  FINISH REPORT t310_rep  #FUN-750030
 
    CLOSE t310_co
    ERROR ""
   ##FUN-750030
#    CALL cl_prt(l_name,' ','1',g_len)
   CALL cl_wcchp(g_wc,'rmi01,rmi02,rmi03,rmi04,rmi05') RETURNING g_wc
    LET g_str = g_wc,";",g_zz05
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
    CALL cl_prt_cs3('armt310','armt310',l_sql,g_str)
 #FUN-750030
END FUNCTION
 
#--------確認程式---------
FUNCTION t310_y()         # when g_rmi.rmiconf='N' (Turn to 'Y')
DEFINE l_rmd15     LIKE rmd_file.rmd15                  #FUN-AB0078 add
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------ add --------------- begin 
   IF g_rmi.rmi01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmi.rmiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rmi.rmiconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  
#CHI-C30107 ------------ add --------------- end
   SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
   IF g_rmi.rmi01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmi.rmiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rmi.rmiconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  #CHI-C30107 mark
 
   #add FUN-AB0078
    DECLARE t310_rmd15 CURSOR FOR
     SELECT rmd15 FROM rmd_file
      WHERE rmd31= g_rmi.rmi01
   FOREACH t310_rmd15 INTO l_rmd15
        IF NOT s_chk_ware(l_rmd15) THEN #检查仓库是否属于当前门店
           LET g_success='N'
           RETURN
        END IF
   END FOREACH
   #end FUN-AB0078

   BEGIN WORK
 
    OPEN t310_cl USING g_rmi.rmi01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t310_cl INTO g_rmi.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t310_y1()
   IF g_success = 'Y' THEN
      LET g_rmi.rmiconf="Y"
      LET g_rmi.rmimodu=g_user LET g_rmi.rmidate=g_today
      COMMIT WORK
      CALL cl_flow_notify(g_rmi.rmi01,'Y')
      DISPLAY BY NAME g_rmi.rmiconf
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rmi.rmiconf='N'
      LET g_rmi.rmimodu=g_rmi_t.rmimodu LET g_rmi.rmidate=g_rmi_t.rmidate
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rmi.rmiconf
   MESSAGE ''
   #CKP
   CALL cl_set_field_pic(g_rmi.rmiconf  ,"","","","",g_rmi.rmivoid)
END FUNCTION
 
FUNCTION t310_y1()
   UPDATE rmi_file SET rmiconf = 'Y',rmimodu=g_user,rmidate=g_today
          WHERE rmi01 = g_rmi.rmi01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rmiconf',STATUS,1) #FUN-660111
      CALL cl_err3("upd","rmi_file",g_rmi.rmi01,"",SQLCA.sqlcode,"","upd rmiconf",1) #FUN-660111
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t310_z()    # when g_rmi.rmiconf='Y' (Turn to 'N')
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
   SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
   IF g_rmi.rmi01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmi.rmiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rmi.rmiconf = 'N' THEN
      CALL cl_err('',9025,0)
      RETURN
   END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t310_cl USING g_rmi.rmi01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_rmi.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t310_z1()
   IF g_success = 'Y'
      THEN LET g_rmi.rmiconf='N'
           LET g_rmi.rmimodu=g_user LET g_rmi.rmidate=g_today
           COMMIT WORK
           CALL cl_cmmsg(3) sleep 1
      ELSE LET g_rmi.rmiconf='Y'
           LET g_rmi.rmimodu=g_rmi_t.rmimodu LET g_rmi.rmidate=g_rmi_t.rmidate
           ROLLBACK WORK
           CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rmi.rmiconf
   MESSAGE ''
   #CKP
   CALL cl_set_field_pic(g_rmi.rmiconf  ,"","","","",g_rmi.rmivoid)
END FUNCTION
 
FUNCTION t310_z1()
   UPDATE rmi_file SET rmiconf = 'N',rmiuser=g_user,
                       rmidate=g_today
          WHERE rmi01 = g_rmi.rmi01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('upd rmiconf',STATUS,1) # FUN-660111
      CALL cl_err3("upd","rmi_file",g_rmi.rmi01,"",STATUS,"","upd rmiconf",1) #FUN-660111
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t310_x()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmi.* FROM rmi_file WHERE rmi01 = g_rmi.rmi01
    IF g_rmi.rmi01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rmi.rmivoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rmi.rmiconf = 'Y' THEN CALL cl_err('conf=Y',9023,0)  RETURN END IF
    IF cl_exp(0,0,g_rmi.rmivoid) THEN
       BEGIN WORK
 
       OPEN t310_cl USING g_rmi.rmi01
       IF STATUS THEN
          CALL cl_err("OPEN t310_cl:", STATUS, 1)
          CLOSE t310_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t310_cl INTO g_rmi.*          # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
          CLOSE t310_cl ROLLBACK WORK RETURN
       END IF
 
       CALL t310_show()
       UPDATE rmd_file SET rmd31='',rmd32=0,rmd33=''
        WHERE rmd31 = g_rmi.rmi01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #         CALL cl_err('upd rmd',STATUS,0) # FUN-660111
         CALL cl_err3("upd","rmd_file",g_rmi.rmi01,"",STATUS,"","upd rmd",1) #FUN-660111
       END IF
       LET g_rmi.rmivoid = 'N'
       UPDATE rmi_file                    #更改有效碼
            SET rmivoid=g_rmi.rmivoid,rmimodu=g_user,rmidate=g_today
            WHERE rmi01=g_rmi.rmi01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0) #FUN-660111
          CALL cl_err3("upd","rmi_file",g_rmi.rmi01,"",SQLCA.sqlcode,"","",1) #FUN-660111
          LET g_rmi.rmivoid = 'Y'
       END IF
       DISPLAY BY NAME g_rmi.rmivoid
    END IF
 
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic(g_rmi.rmiconf  ,"","","","",g_rmi.rmivoid)
 
    CALL cl_flow_notify(g_rmi.rmi01,'V')
 
END FUNCTION
#單頭
FUNCTION t310_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rmi01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
#No.FUN-570109 --start
       IF p_cmd = 'u' AND g_chkey='N' THEN
#No.FUN-570109 --end
           CALL cl_set_comp_entry("rmi01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION t310_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rmd01,rmd02,rmd03,rmd32,rmd33",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry_b(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
   IF NOT g_before_input_done THEN
       IF p_cmd = 'T' THEN
           CALL cl_set_comp_entry("rmd01,rmd02,rmd03,rmd32",FALSE)
       ELSE
           CALL cl_set_comp_entry("rmd33",FALSE)
       END IF
   END IF
END FUNCTION
#CHI-C80041---begin
#FUNCTION t310_v()  #CHI-D20010
FUNCTION t310_v(p_type)  #CHI-D20010
DEFINE l_chr     LIKE type_file.chr1
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rmi.rmi01) THEN CALL cl_err('',-400,0) RETURN END IF  

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_rmi.rmiconf ='X' THEN RETURN END IF
   ELSE
      IF g_rmi.rmiconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t310_cl USING g_rmi.rmi01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_rmi.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rmi.rmi01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t310_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rmi.rmiconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_rmi.rmiconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_rmi.rmiconf)   THEN #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #CHI-D20010
        LET l_chr=g_rmi.rmiconf
       #IF g_rmi.rmiconf='N' THEN  #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010
            LET g_rmi.rmiconf='X' 
        ELSE
            LET g_rmi.rmiconf='N'
        END IF
        UPDATE rmi_file
            SET rmiconf=g_rmi.rmiconf,  
                rmimodu=g_user,
                rmidate=g_today
            WHERE rmi01=g_rmi.rmi01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rmi_file",g_rmi.rmi01,"",SQLCA.sqlcode,"","",1)  
            LET g_rmi.rmiconf=l_chr 
        END IF
        DISPLAY BY NAME g_rmi.rmiconf
   END IF
 
   CLOSE t310_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rmi.rmi01,'V')
 
END FUNCTION
#CHI-C80041---end
