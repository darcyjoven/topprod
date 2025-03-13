# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: ggli004.4gl
# Descriptions...: 合併報表歷史匯率維護
# Date & Author..: 07/05/15 By kim (FUN-750058)
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760053 07/06/25 By Sarah key值增加異動日期asf06
# Modify.........: No.FUN-780013 07/08/20 By kim 增加三個欄位
# Modify.........: No.FUN-780068 07/09/14 By Sarah 1.單頭增加asf10(異動年度)、asf11(異動期別)，
#                                                    單身原來的asf08異動年度改成歷史年度，asf09異動期別改成歷史期別
#                                                    key值加上asf10,asf11
#                                                  2.增加"0期資料產生"ACTION
# Modify.........: NO.FUN-970049 09/07/14 BY hongmei ggli004單頭 "異動年度asf10" "異動期別 asf11",單身 "歷史年度 asf08"
#                                                     "歷史期別asf09",從畫面上移除，單身加入新欄位"異動日期" (asf06)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/01/02 By hongmei 1.以asf07(公司科目)到agli001帶出ash06(合併財報科目)到asf03,畫面移除asf03、aag02
#                                                  2.串ash_file時,增加串ash13(族群代號)=asf01
# Modify.........: No.FUN-930018 09/05/20 By hongmei 畫面增加"歷史匯率(asf12)"及"合併幣別金額(asf13)"
# Modify.........: No:TQC-960337 09/12/24 By dxfwo 1. 历史年度 的字段说明 变                                                        
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
#                                                  成公司科目                                                                       
#                                                  2. 公司科目输入时的开窗显示的科目名称不对
# Modify.........: No:MOD-A30095 10/03/15 By Smapmin aaz64-->aaz641
# Modify.........: No:CHI-9C0044 10/06/09 By Summer AFTER FIELD asf12增加判斷,若合併金額>0則不再重新計算
# Modify.........: NO.FUN-A70086 10/07/15 by Yiting add asf14,asf15,asf16/公司科目開窗應調整為取下層公司取agli001來源科目 , 中間層公司(已合併公司)取agli0011來源科目
# Modify.........: No.MOD-B30382 11/03/17 By lutingting q_ash2加传参数ash13
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO.TQC-D40119 13/07/17 By yangtt 在取合并帐套时，用的是aaz641，应改为大陆版的参数asz01

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
#FUN-750058
#模組變數(Module Variables)
DEFINE
    g_asf01           LIKE asf_file.asf01,
    g_asf01_t         LIKE asf_file.asf01,
    g_asf02           LIKE asf_file.asf02,
    g_asf02_t         LIKE asf_file.asf02,   
#   g_asf10           LIKE asf_file.asf10,    #FUN-780068 add 10/19 #FUN-970049 mark
#   g_asf10_t         LIKE asf_file.asf10,    #FUN-780068 add 10/19 #FUN-970049 mark 
#   g_asf11           LIKE asf_file.asf11,    #FUN-780068 add 10/19 #FUN-970049 mark
#   g_asf11_t         LIKE asf_file.asf11,    #FUN-780068 add 10/19 #FUN-970049 mark 
    g_asf             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        asf07         LIKE asf_file.asf07,
        aag02a        LIKE aag_file.aag02,
        asf03         LIKE asf_file.asf03,
        aag02         LIKE aag_file.aag02,
        asf06         LIKE asf_file.asf06,    #FUN-A70086
        asf04         LIKE asf_file.asf04,
        asf05         LIKE asf_file.asf05,
#       asf08         LIKE asf_file.asf08,    #FUN-970049 mark 
#       asf09         LIKE asf_file.asf09,    #FUN-970049 mark
#       asf06         LIKE asf_file.asf06,    #FUN-970049 add  #FUN-A70086 mark
        asf15         LIKE asf_file.asf15,    #FUN-A70086
        asf14         LIKE asf_file.asf14,    #FUN-A70086
        asf16         LIKE asf_file.asf16,    #FUN-A70086
        asf12         LIKE asf_file.asf12,    #FUN-930018 add
        asf13         LIKE asf_file.asf13     #FUN-930018 add
                      END RECORD,
    g_asf_t           RECORD                 #程式變數 (舊值)
        asf07         LIKE asf_file.asf07,
        aag02a        LIKE aag_file.aag02,
        asf03         LIKE asf_file.asf03,
        aag02         LIKE aag_file.aag02,
        asf06         LIKE asf_file.asf06,    #FUN-A70086
        asf04         LIKE asf_file.asf04,
        asf05         LIKE asf_file.asf05,
#       asf08         LIKE asf_file.asf08,    #FUN-970049 mark 
#       asf09         LIKE asf_file.asf09,    #FUN-970049 mark
#       asf06         LIKE asf_file.asf06,    #FUN-970049 add  #FUN-A70086 mark
        asf15         LIKE asf_file.asf15,    #FUN-A70086
        asf14         LIKE asf_file.asf14,    #FUN-A70086
        asf16         LIKE asf_file.asf16,    #FUN-A70086
        asf12         LIKE asf_file.asf12,    #FUN-930018 add
        asf13         LIKE asf_file.asf13     #FUN-930018 add
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE asf_file.asf01,
    g_argv2           LIKE asf_file.asf02
#   g_argv3           LIKE asf_file.asf10,   #FUN-780068 add 10/19 #FUN-970049 mark
#   g_argv4           LIKE asf_file.asf11    #FUN-780068 add 10/19 #FUN-970049 mark
DEFINE p_row,p_col    LIKE type_file.num5    
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10
DEFINE   g_asz01       LIKE asz_file.asz01          #TQC-D40119 add
 
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
#  LET g_argv3 =ARG_VAL(3)   #FUN-780068 add 10/19 #FUN-970049 mark
#  LET g_argv4 =ARG_VAL(4)   #FUN-780068 add 10/19 #FUN-970049 mark

   #抓取账套
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'    #TQC-D40119 add
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i011_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli004"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
#  CALL cl_set_comp_visible("asf03",FALSE)        #FUN-910001 add
   CALL cl_set_comp_visible("asf03,aag02",FALSE)  #No.TQC-960337 
   
  #IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN   #FUN-780068 mark 10/19
   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN   #FUN-780068      10/19
       #   cl_null(g_argv3) AND cl_null(g_argv4)) THEN   #FUN-780068      10/19 #FUN-970049
      CALL i011_q()
   END IF   
   CALL i011_menu()
 
   CLOSE WINDOW i011_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i011_cs()
DEFINE l_sql STRING
DEFINE l_cnt   LIKE type_file.num5  #FUN-A70086
DEFINE l_cnt1  LIKE type_file.num5  #FUN-A70086
 
  #IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN   #FUN-780068 mark 10/19
   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN    #AND     #FUN-780068      10/19
        # cl_null(g_argv3) AND cl_null(g_argv4)) THEN   #FUN-780068      10/19 #FUN-970049 mark
      LET g_wc = " asf01 = '",g_argv1,"'",
                 " AND asf02 = '",g_argv2,"'" 
             #   " AND asf10 = '",g_argv3,"'",   #FUN-780068 add 10/19 #FUN-970049 mark
             #   " AND asf11 = '",g_argv4,"'"    #FUN-780068 add 10/19 #FUN-970049 mark
   ELSE
      CLEAR FORM                            #清除畫面
      CALL g_asf.clear()
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
      INITIALIZE g_asf01 TO NULL    #No.FUN-750051
      INITIALIZE g_asf02 TO NULL    #No.FUN-750051
#     INITIALIZE g_asf10 TO NULL    #No.FUN-780068 add 10/19
#     INITIALIZE g_asf11 TO NULL    #No.FUN-780068 add 10/19
     #CONSTRUCT g_wc ON asf01,asf02,asf07,asf03,asf04,               #FUN-780068 mark 10/19
#---FUN-A70086 start---
#      CONSTRUCT g_wc ON asf01,asf02,asf07,asf03,asf04,   #FUN-780068      10/19  #FUN-970049 asf10,asf11,
#                        asf05,asf12,asf13                #FUN-930018 add asf12,asf13 #FUN-780013 #FUN-970049 asf08,asf09,
#          #FROM asf01,asf02,s_asf[1].asf07,s_asf[1].asf03,               #FUN-780068 mark 10/19
#           FROM asf01,asf02,s_asf[1].asf07,s_asf[1].asf03,   #FUN-780068      10/19  #FUN-970049 asf10,asf11,
#                s_asf[1].asf04,s_asf[1].asf05,               ##FUN-970049 s_asf[1].asf08,
#               # s_asf[1].asf09, #FUN-970049
#                s_asf[1].asf12,s_asf[1].asf13  #FUN-930018 add asf12,asf13  #FUN-780013
      CONSTRUCT g_wc ON asf01,asf02,asf07,asf03,asf06,asf04, 
                        asf05,asf15,asf14,asf16,asf12,asf13              
           FROM asf01,asf02,s_asf[1].asf07,s_asf[1].asf03, 
                s_asf[1].asf06,s_asf[1].asf04,s_asf[1].asf05,             
                s_asf[1].asf15,s_asf[1].asf14,s_asf[1].asf16,
                s_asf[1].asf12,s_asf[1].asf13 
#---FUN-A70086 end----               

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asf01) #族群編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_asa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asf01
                  NEXT FIELD asf01
               WHEN INFIELD(asf02) #公司編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_asg"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asf02
                  NEXT FIELD asf02
               WHEN INFIELD(asf03) #科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ash1"   #FUN-760053 q_ash->q_ash1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asf03
                  NEXT FIELD asf03
               WHEN INFIELD(asf04) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = g_asf[1].asf04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asf04
                  NEXT FIELD asf04
               WHEN INFIELD(asf07) #科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  #--FUN-A70086 start---
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt
                    FROM asa_file
                   WHERE asa01 = g_asf01  
                     AND asa02 = g_asf02 
                  IF l_cnt > 0 THEN   #屬上層公司
                      LET l_cnt1 = 0
                      SELECT COUNT(*) INTO l_cnt1
                        FROM asb_file
                       WHERE asb01 = g_asf01  
                         AND asb02 = g_asf02 
                      IF l_cnt1 > 0 THEN   #屬中間層公司
                          LET g_qryparam.form ="q_ashh"
                      ELSE
                          LET g_qryparam.form ="q_ash2"
                      END IF
                  ELSE
                      LET g_qryparam.form ="q_ash2"
                  END IF
                  #-------FUN-A70086 end---------
#                 LET g_qryparam.form ="q_ash2"   #FUN-A70086 mark
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asf07
                  NEXT FIELD asf07
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
            CALL cl_qbe_select()
            
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
       
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF cl_null(g_wc) THEN LET g_wc="1=1" END IF
    
  #LET l_sql="SELECT UNIQUE asf01,asf02 FROM asf_file ",               #FUN-780068 mark 10/19
  #LET l_sql="SELECT UNIQUE asf01,asf02,asf10,asf11 FROM asf_file ",   #FUN-780068  10/19 #FUN-970049 mark
   LET l_sql="SELECT UNIQUE asf01,asf02 FROM asf_file ", #FUN-970049 add
              " WHERE ", g_wc CLIPPED
  #LET g_sql= l_sql," ORDER BY asf01"                     #FUN-780068 mark 10/19
  #LET g_sql= l_sql," ORDER BY asf10,asf11,asf01,asf02"    #FUN-780068      10/19 #FUN-970049 mark
   LET g_sql= l_sql," ORDER BY asf01,asf02" #FUN-970049 add
   PREPARE i011_prepare FROM g_sql      #預備一下
   DECLARE i011_bcs                     #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i011_prepare
 
   DROP TABLE i011_cnttmp
#  LET l_sql=l_sql," INTO TEMP i011_cnttmp"      #No.TQC-720019
   LET g_sql_tmp=l_sql," INTO TEMP i011_cnttmp"  #No.TQC-720019
   
#  PREPARE i011_cnttmp_pre FROM l_sql       #No.TQC-720019
   PREPARE i011_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
   EXECUTE i011_cnttmp_pre    
   
   LET g_sql="SELECT COUNT(*) FROM i011_cnttmp"      
   
   PREPARE i011_precount FROM g_sql
   DECLARE i011_count CURSOR FOR i011_precount
 
   IF NOT cl_null(g_argv1) THEN LET g_asf01=g_argv1 END IF
   IF NOT cl_null(g_argv2) THEN LET g_asf02=g_argv2 END IF
#  IF NOT cl_null(g_argv3) THEN LET g_asf10=g_argv3 END IF   #FUN-780068 add 10/19 #FUN-970049 mark
#  IF NOT cl_null(g_argv4) THEN LET g_asf11=g_argv4 END IF   #FUN-780068 add 10/19 #FUN-970049 mark
 
   CALL i011_show()
END FUNCTION
 
FUNCTION i011_menu()
 
   WHILE TRUE
      CALL i011_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL i011_a()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i011_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i011_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i011_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-970049---Beatk mark--            
#        #str FUN-780068 add 10/19
#         WHEN "generate"   #0期資料產生
#            IF cl_chk_act_auth() THEN
#               CALL i011_g()
#            END IF
#        #end FUN-780068 add 10/19
#FUN-970049---End mark--
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i011_out()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_asf),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_asf01 IS NOT NULL THEN
                LET g_doc.column1 = "asf01"
                LET g_doc.column2 = "asf02"
             #  LET g_doc.column3 = "asf10"   #FUN-780068 add 10/19 #FUN-970049 mark
             #  LET g_doc.column4 = "asf11"   #FUN-780068 add 10/19 #FUN-970049 mark
                LET g_doc.value1 = g_asf01
                LET g_doc.value2 = g_asf02
             #  LET g_doc.value3 = g_asf10    #FUN-780068 add 10/19 #FUN-970049 mark
             #  LET g_doc.value4 = g_asf11    #FUN-780068 add 10/19 #FUN-970049 mark
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i011_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_asf.clear()
   LET g_asf01_t  = NULL
   LET g_asf02_t  = NULL
#  LET g_asf10_t  = NULL   #FUN-780068 add 10/19 #FUN-970049 mark
#  LET g_asf11_t  = NULL   #FUN-780068 add 10/19 #FUN-970049 mark
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i011_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_asf01=NULL
         LET g_asf02=NULL
#        LET g_asf10=NULL   #FUN-780068 add 10/19 #FUN-970049 mark
#        LET g_asf11=NULL   #FUN-780068 add 10/19 #FUN-970049 mark
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_asf.clear()
      ELSE
         CALL i011_b_fill('1=1')            #單身
      END IF
 
      CALL i011_b()                      #輸入單身
 
      LET g_asf01_t = g_asf01
      LET g_asf02_t = g_asf02
#     LET g_asf10_t = g_asf10   #FUN-780068 add 10/19 #FUN-970049 mark
#     LET g_asf11_t = g_asf11   #FUN-780068 add 10/19 #FUN-970049 mark
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i011_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
    l_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER    
 
    LET g_ss='Y'
 
    LET g_asf01=NULL
    LET g_asf02=NULL
#   LET g_asf10=NULL   #FUN-780068 add 10/19 #FUN-970049 mark
#   LET g_asf11=NULL   #FUN-780068 add 10/19 #FUN-970049 mark
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
   #str FUN-780068 mod 10/19
   #INPUT g_asf01,g_asf02 WITHOUT DEFAULTS
   #    FROM asf01,asf02
   #INPUT g_asf01,g_asf02,g_asf10,g_asf11 WITHOUT DEFAULTS  #FUN-970049 mark
    INPUT g_asf01,g_asf02 WITHOUT DEFAULTS  #FUN-970049
        FROM asf01,asf02                    #FUN-970049 ,asf10,asf11
   #end FUN-780068 mod 10/19
 
       AFTER FIELD asf01
          IF NOT cl_null(g_asf01) THEN
             LET g_cnt=0
             SELECT COUNT(*) INTO g_cnt FROM asa_file
                                       WHERE asa01=g_asf01
             IF SQLCA.sqlcode OR (g_cnt=0) THEN
                CALL cl_err3("sel","asa_file",g_asf01,"",100,"","",1)
                LET g_asf01=g_asf01_t
                DISPLAY g_asf01 TO asf01
                NEXT FIELD CURRENT
             END IF
          END IF
 
       AFTER FIELD asf02
          IF NOT cl_null(g_asf02) THEN
             LET g_cnt=0
             SELECT COUNT(*) INTO g_cnt FROM asg_file
                                       WHERE asg01=g_asf02
             IF SQLCA.sqlcode OR (g_cnt=0) THEN
                CALL cl_err3("sel","asg_file",g_asf02,"",100,"","",1)
                LET g_asf02=g_asf02_t
                DISPLAY g_asf02 TO asf02
                DISPLAY i011_set_asg02() TO FORMONLY.asg02
                NEXT FIELD CURRENT
             END IF
             DISPLAY i011_set_asg02() TO FORMONLY.asg02
          ELSE
             DISPLAY NULL TO FORMONLY.asg02
          END IF
 
       AFTER INPUT
          IF (NOT cl_null(g_asf01)) AND (NOT cl_null(g_asf02)) THEN
             LET g_cnt=0
             SELECT COUNT(*) INTO g_cnt FROM asg_file 
                                       WHERE asg01=g_asf02
             IF SQLCA.sqlcode THEN LET g_cnt=0 END IF
             IF g_cnt=0 THEN
                CALL cl_err3("sel","asg_file",g_asf01,g_asf02,"agl-094","","",1)
                NEXT FIELD asf02
             END IF
          END IF
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(asf01) OR INFIELD(asf02)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_asb4"
                CALL cl_create_qry() RETURNING g_asf01,g_asf02
                DISPLAY g_asf01 TO asf01
                DISPLAY g_asf02 TO asf02
                NEXT FIELD asf02
          END CASE
 
       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i011_q()
   LET g_asf01 = ''
   LET g_asf02 = ''
#  LET g_asf10 = ''   #FUN-780068 add 10/19 #FUN-970049 mark
#  LET g_asf11 = ''   #FUN-780068 add 10/19 #FUN-970049 mark
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_asf01,g_asf02 TO NULL       #No.FUN-6B0040
#  INITIALIZE g_asf10,g_asf11 TO NULL       #No.FUN-780068 add 10/19 #FUN-970049 mark
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asf.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i011_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_asf01,g_asf02 TO NULL
#     INITIALIZE g_asf10,g_asf11 TO NULL   #FUN-780068 add 10/19 #FUN-970049 mark
      RETURN
   END IF
 
   OPEN i011_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_asf01,g_asf02 TO NULL
#     INITIALIZE g_asf10,g_asf11 TO NULL   #FUN-780068 add 10/19 #FUN-970049
   ELSE
      OPEN i011_count
      FETCH i011_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i011_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i011_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
#FUN-970049---Beatk   
#      WHEN 'N' FETCH NEXT     i011_bcs INTO g_asf01,g_asf02,g_asf10,g_asf11   #FUN-780068 mod 10/19 g_asf10,g_asf11
#      WHEN 'P' FETCH PREVIOUS i011_bcs INTO g_asf01,g_asf02,g_asf10,g_asf11   #FUN-780068 mod 10/19 g_asf10,g_asf11
#      WHEN 'F' FETCH FIRST    i011_bcs INTO g_asf01,g_asf02,g_asf10,g_asf11   #FUN-780068 mod 10/19 g_asf10,g_asf11
#      WHEN 'L' FETCH LAST     i011_bcs INTO g_asf01,g_asf02,g_asf10,g_asf11   #FUN-780068 mod 10/19 g_asf10,g_asf11
       WHEN 'N' FETCH NEXT     i011_bcs INTO g_asf01,g_asf02  
       WHEN 'P' FETCH PREVIOUS i011_bcs INTO g_asf01,g_asf02  
       WHEN 'F' FETCH FIRST    i011_bcs INTO g_asf01,g_asf02  
       WHEN 'L' FETCH LAST     i011_bcs INTO g_asf01,g_asf02
#FUN-970049---End       
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
        #   FETCH ABSOLUTE l_abso i011_bcs INTO g_asf01,g_asf02,g_asf10,g_asf11   #FUN-780068 mod 10/19 g_asf10,g_asf11 #FUN-970049 mark
            FETCH ABSOLUTE l_abso i011_bcs INTO g_asf01,g_asf02  #FUN-970049 add
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_asf01,SQLCA.sqlcode,0)
      INITIALIZE g_asf01 TO NULL  #TQC-6B0105
      INITIALIZE g_asf02 TO NULL  #TQC-6B0105
#     INITIALIZE g_asf10 TO NULL  #FUN-780068 add 10/19 #FUN-970049 mark
#     INITIALIZE g_asf11 TO NULL  #FUN-780068 add 10/19 #FUN-970049 mark
   ELSE 
      CALL i011_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i011_show()
 
   DISPLAY g_asf01 TO asf01
   DISPLAY g_asf02 TO asf02
#  DISPLAY g_asf10 TO asf10   #FUN-780068 add 10/19 #FUN-970049 mark
#  DISPLAY g_asf11 TO asf11   #FUN-780068 add 10/19 #FUN-970049 mark
   DISPLAY i011_set_asg02() TO FORMONLY.asg02
   CALL i011_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i011_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680098 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098    VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680098 SMALLINT
   l_cnt           LIKE type_file.num10,         #No.FUN-680098  INTEGER
   l_asg           RECORD LIKE asg_file.*
DEFINE l_yy        LIKE type_file.num5           #FUN-970049 add
DEFINE l_mm        LIKE type_file.num5           #FUN-970049 add
DEFINE l_ase06     LIKE ase_file.ase06,          #FUN-930018 add
       l_asa02     LIKE asa_file.asa02,          #FUN-930018 add  
       l_asg06_up  LIKE asg_file.asg06           #FUN-930018 add  
DEFINE l_asg07_up  LIKE asg_file.asg07           #FUN-A70086
DEFINE l_cnt1      LIKE type_file.num5           #FUN-A70086
       
   LET g_action_choice = ""
 
  #IF cl_null(g_asf01) OR cl_null(g_asf02) THEN   #FUN-780068 mark 10/19
   IF cl_null(g_asf01) OR cl_null(g_asf02) THEN   #FUN-970049 OR #FUN-780068      10/19
  #   cl_null(g_asf10) OR cl_null(g_asf11) THEN   #FUN-780068      10/19
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
      #"SELECT asf07,'',asf03,'',asf04,asf05,asf08,asf09 FROM asf_file",               #FUN-930018 mark
      #"SELECT asf07,'',asf03,'',asf04,asf05,asf08,asf09,asf12,asf13 FROM asf_file",   #FUN-930018 mod #FUN-970049 mark   
      #"SELECT asf07,'',asf03,'',asf04,asf05,asf06,asf12,asf13 FROM asf_file",         #FUN-970049 
       "SELECT asf07,'',asf03,'',asf06,asf04,asf05,asf15,asf14,asf16,asf12,asf13 FROM asf_file",  #FUN-A70086
       "  WHERE asf01 = ? AND asf02 = ? ",
     # "   AND asf10 = ? AND asf11 = ? ",   #FUN-780068 add 10/19 FUN-970049 mark
       "   AND asf07 = ? AND asf03 = ? ",
       "   AND asf06 = ? ",                 #FUN-970049 add
     # "   AND asf08 = ? AND asf09 = ?",    #FUN-970049 mark
       " FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i011_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_asf.clear() END IF
 
   SELECT * INTO l_asg.* FROM asg_file
                        WHERE asg01=g_asf02
   IF SQLCA.sqlcode THEN
      INITIALIZE l_asg.* TO NULL
   END IF
 
   INPUT ARRAY g_asf WITHOUT DEFAULTS FROM s_asf.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
        #str FUN-910001 add
         LET g_before_input_done = FALSE
         CALL i011_set_entry(p_cmd)
         CALL i011_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
        #end FUN-910001 add
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_asf_t.* = g_asf[l_ac].*  #BACKUP
            BEGIN WORK
          # OPEN i011_bcl USING g_asf01,g_asf02,g_asf10,g_asf11,    #FUN-780068 mod 10/19 g_asf10,g_asf11 #FUN-970049 mark
            OPEN i011_bcl USING g_asf01,g_asf02,                    #FUN-970049 add
                                g_asf[l_ac].asf07,g_asf[l_ac].asf03,
                                g_asf[l_ac].asf06   #FUN-970049  
                            #   g_asf[l_ac].asf08,g_asf[l_ac].asf09 #FUN-970049 mark
            IF STATUS THEN 
               CALL cl_err("OPEN i011_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i011_bcl INTO g_asf[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i011_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i011_set_asf07(g_asf[l_ac].asf07) RETURNING g_asf[l_ac].aag02a
                  CALL i011_set_asf03(g_asf[l_ac].asf03) RETURNING g_asf[l_ac].aag02
                  LET g_asf_t.*=g_asf[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asf[l_ac].* TO NULL            #900423
         LET g_asf_t.* = g_asf[l_ac].*               #新輸入資料
         LET g_asf[l_ac].asf04=l_asg.asg06
         LET g_asf[l_ac].asf14=l_asg.asg07     #FUN-A70086
#        LET g_asf[l_ac].asf08=YEAR(g_today)   #FUN-970049 mark
#        LET g_asf[l_ac].asf09=MONTH(g_today)  #FUN-970049 mark
         CALL cl_show_fld_cont()
         NEXT FIELD asf07
 
      AFTER FIELD asf03                         # check data 是否重複
         IF NOT cl_null(g_asf[l_ac].asf03) THEN
            IF g_asf[l_ac].asf03 != g_asf_t.asf03 OR g_asf_t.asf03 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ash_file
               #WHERE ash04=g_asf[l_ac].asf03   #FUN-760053 mark
                WHERE ash06=g_asf[l_ac].asf03   #FUN-760053
                  AND ash00=l_asg.asg05
                  AND ash01=g_asf02
                  AND ash13=g_asf01   #FUN-910001 add
               IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
                  CALL cl_err3("sel","ash_file",g_asf[l_ac].asf03,"",100,"","",1)
                  LET g_asf[l_ac].asf03=g_asf_t.asf03
                  LET g_asf[l_ac].aag02=g_asf_t.aag02
                  DISPLAY BY NAME g_asf[l_ac].asf03,g_asf[l_ac].aag02
                  NEXT FIELD CURRENT
               END IF
 
              #str FUN-760053 mark
              #LET l_cnt=0
              #SELECT COUNT(*) INTO l_cnt FROM asf_file
              #                          WHERE asf01 = g_asf01
              #                            AND asf02 = g_asf02
              #                            AND asf03 = g_asf[l_ac].asf03
              #IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
              #   CALL cl_err(g_asf[l_ac].asf03,-239,0)
              #   LET g_asf[l_ac].asf03 = g_asf_t.asf03
              #   LET g_asf[l_ac].aag02 = g_asf_t.aag02
              #   DISPLAY BY NAME g_asf[l_ac].asf03,g_asf[l_ac].aag02
              #   NEXT FIELD CURRENT
              #END IF
              #end FUN-760053 mark
               CALL i011_set_asf03(g_asf[l_ac].asf03) 
                   RETURNING g_asf[l_ac].aag02
               DISPLAY BY NAME g_asf[l_ac].aag02
               IF NOT i011_chk_data() THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         ELSE
            LET g_asf[l_ac].aag02 = null
            DISPLAY BY NAME g_asf[l_ac].aag02
         END IF
 
      AFTER FIELD asf07                         # check data 是否重複
         IF NOT cl_null(g_asf[l_ac].asf07) THEN
            IF g_asf[l_ac].asf07 != g_asf_t.asf07 OR g_asf_t.asf07 IS NULL THEN
               #--FUN-A70086 start---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM asa_file
                WHERE asa01 = g_asf01  
                  AND asa02 = g_asf02 
               IF l_cnt > 0 THEN   #屬上層公司
                   LET l_cnt1 = 0
                   SELECT COUNT(*) INTO l_cnt1
                     FROM asb_file
                    WHERE asb01 = g_asf01  
                      AND asb02 = g_asf02 
                   IF l_cnt1 > 0 THEN   #屬中間層公司
                       LET l_cnt=0
                       SELECT COUNT(*) INTO l_cnt FROM ashh_file
                        WHERE ashh04=g_asf[l_ac].asf07
                         #AND ashh00=g_aaz.aaz641     #TQC-D40119 mark
                          AND ashh00=g_asz01          #TQC-D40119 add
                          AND ashh01=g_asf02
                          AND ashh13=g_asf01 
                       IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
                          CALL cl_err3("sel","ashh_file",g_asf[l_ac].asf07,"",100,"","",1)
                          LET g_asf[l_ac].asf07=g_asf_t.asf07
                          LET g_asf[l_ac].aag02a=g_asf_t.aag02a
                          DISPLAY BY NAME g_asf[l_ac].asf07,g_asf[l_ac].aag02a
                          NEXT FIELD CURRENT
                       END IF

                       CALL i011_set_asf07(g_asf[l_ac].asf07) 
                           RETURNING g_asf[l_ac].aag02a
                       DISPLAY BY NAME g_asf[l_ac].aag02a

                       #以asf07(公司科目)到agli0011帶出ash06(合併財報科目)到asf03
                       SELECT ashh06 INTO g_asf[l_ac].asf03 FROM ashh_file
                        WHERE ashh04=g_asf[l_ac].asf07
                         #AND ashh00=g_aaz.aaz641     #TQC-D40119 mark
                          AND ashh00=g_asz01          #TQC-D40119 add
                          AND ashh01=g_asf02
                          AND ashh13=g_asf01  
                       DISPLAY BY NAME g_asf[l_ac].asf03
                       IF NOT i011_chk_data() THEN
                          NEXT FIELD CURRENT
                       END IF
                   END IF
                ELSE
                #------FUN-A70086 end-------------------
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM ash_file
                     WHERE ash04=g_asf[l_ac].asf07
                       AND ash00=l_asg.asg05
                       AND ash01=g_asf02
                       AND ash13=g_asf01   #FUN-910001 add
                    IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
                       CALL cl_err3("sel","ash_file",g_asf[l_ac].asf07,"",100,"","",1)
                       LET g_asf[l_ac].asf07=g_asf_t.asf07
                       LET g_asf[l_ac].aag02a=g_asf_t.aag02a
                       DISPLAY BY NAME g_asf[l_ac].asf07,g_asf[l_ac].aag02a
                       NEXT FIELD CURRENT
                    END IF

                    CALL i011_set_asf07(g_asf[l_ac].asf07) 
                        RETURNING g_asf[l_ac].aag02a
                    DISPLAY BY NAME g_asf[l_ac].aag02a
                    #str FUN-910001 add

                    #以asf07(公司科目)到agli001帶出ash06(合併財報科目)到asf03
                    SELECT ash06 INTO g_asf[l_ac].asf03 FROM ash_file
                     WHERE ash04=g_asf[l_ac].asf07
                       AND ash00=l_asg.asg05
                       AND ash01=g_asf02
                       AND ash13=g_asf01   #FUN-910001 add
                    DISPLAY BY NAME g_asf[l_ac].asf03
                    #end FUN-910001 add
                    IF NOT i011_chk_data() THEN
                       NEXT FIELD CURRENT
                    END IF
                END IF
            END IF
         ELSE
            LET g_asf[l_ac].aag02a = null
            DISPLAY BY NAME g_asf[l_ac].aag02a
         END IF

      AFTER FIELD asf05
         IF NOT cl_null(g_asf[l_ac].asf05) THEN
           #str FUN-760053 mark
           #允許輸入負值,當正值表示為正常科目餘額方,若為負值表示為另一餘額方
           #IF g_asf[l_ac].asf05<0 THEN
           #   CALL cl_err('','aim-391',1)
           #   NEXT FIELD CURRENT
           #END IF
           #end FUN-760053 mark
            LET t_azi04 = ''  #FUN-A70086
            SELECT azi04 INTO t_azi04 FROM azi_file
                                     WHERE azi01=g_asf[l_ac].asf04
            LET g_asf[l_ac].asf05=cl_digcut(g_asf[l_ac].asf05,t_azi04)
            DISPLAY BY NAME g_asf[l_ac].asf05
         END IF
#FUN-970049---Beatk mark 
#      AFTER FIELD asf08
#         IF NOT cl_null(g_asf[l_ac].asf08) THEN            
#            IF MDY('1','1',g_asf[l_ac].asf08) IS NULL THEN
#               CALL cl_err('','afa-370',1)
#               NEXT FIELD CURRENT
#            END IF
#            IF (g_asf_t.asf08 IS NULL) OR 
#               (g_asf_t.asf08 <> g_asf[l_ac].asf08) THEN
#               IF NOT i011_chk_data() THEN
#                  NEXT FIELD CURRENT
#               END IF
#            END IF
#         END IF
#
#      AFTER FIELD asf09
#         IF NOT cl_null(g_asf[l_ac].asf09) THEN
#            IF g_asf[l_ac].asf09<>0 THEN #可以輸入0
#               IF MDY(g_asf[l_ac].asf09,'1',YEAR(g_today)) IS NULL THEN
#                  CALL cl_err('','agl-317',1)
#                  NEXT FIELD CURRENT
#               END IF
#            END IF
#            IF (g_asf_t.asf09 IS NULL) OR 
#               (g_asf_t.asf09 <> g_asf[l_ac].asf09) THEN
#               IF NOT i011_chk_data() THEN
#                  NEXT FIELD CURRENT
#               END IF
#            END IF
#         END IF
#FUN-970049---End
 
     #FUN-930018---add---str---
     BEFORE FIELD asf12
         LET l_ase06=0
         LET g_asf[l_ac].asf12=0
         SELECT DISTINCT asa02 INTO l_asa02 
           FROM asa_file,asb_file
          WHERE asb04=g_asf02
            AND asb01=g_asf01
            AND asb02=asa02
            AND asb01=asa01
            AND asb03=asa03
         
         SELECT asg06 INTO l_asg06_up
           FROM asg_file
          WHERE asg01=l_asa02
         IF SQLCA.sqlcode THEN
            LET l_asg06_up = NULL 
         END IF
         
         #--FUN-970049 start---
         LET l_yy = year(g_asf[l_ac].asf06)
         LET l_mm = month(g_asf[l_ac].asf06)
         #--FUN-970049 end------
         
         SELECT ase06 INTO l_ase06 
           FROM ase_file
        # WHERE ase01 = g_asf[l_ac].asf08 #FUN-970049
        #   AND ase02 = g_asf[l_ac].asf09 #FUN-970049
          WHERE ase01 = l_yy   #FUN-970049 mod
            AND ase02 = l_mm   #FUN-970049 mod
            #AND ase03 = g_asf[l_ac].asf04
            AND ase03 = g_asf[l_ac].asf14      #FUN-A70086
            AND ase04 = l_asg06_up
         IF cl_null(l_ase06) THEN LET l_ase06=0 END IF
 
         LET g_asf[l_ac].asf12 = l_ase06    
         DISPLAY BY NAME g_asf[l_ac].asf12   
 
     AFTER FIELD asf12
         IF g_asf[l_ac].asf13 <= 0 OR cl_null(g_asf[l_ac].asf13) THEN #CHI-9C0044 add
            IF NOT cl_null(g_asf[l_ac].asf12) AND g_asf[l_ac].asf12 > 0  THEN
               #LET g_asf[l_ac].asf13= g_asf[l_ac].asf05 * g_asf[l_ac].asf12
               LET g_asf[l_ac].asf13= g_asf[l_ac].asf16 * g_asf[l_ac].asf12  #FUN-A70086
            ELSE 
               LET g_asf[l_ac].asf13=0
            END IF 
         END IF #CHI-9C0044 add
         DISPLAY BY NAME g_asf[l_ac].asf13         
 
     AFTER FIELD asf13
         IF cl_null(g_asf[l_ac].asf13) THEN LET g_asf[l_ac].asf13= 0 END IF
         DISPLAY BY NAME g_asf[l_ac].asf13         
     #FUN-930018---add---end---
      
#---FUN-A70086 start---
     BEFORE FIELD asf15
         LET g_asf[l_ac].asf04=l_asg.asg06     
         LET g_asf[l_ac].asf14=l_asg.asg07    
         DISPLAY BY NAME g_asf[l_ac].asf04    
         DISPLAY BY NAME g_asf[l_ac].asf14   
         LET l_ase06=0
         LET l_yy = year(g_asf[l_ac].asf06)
         LET l_mm = month(g_asf[l_ac].asf06)
      
         LET l_ase06 = 1
         IF g_asf[l_ac].asf04 ! = g_asf[l_ac].asf14 THEN
             SELECT ase06 INTO l_ase06 
               FROM ase_file
              WHERE ase01 = l_yy 
                AND ase02 = l_mm 
                AND ase03 = g_asf[l_ac].asf04
                AND ase04 = g_asf[l_ac].asf14
         END IF

         LET g_asf[l_ac].asf15 = l_ase06    
         DISPLAY BY NAME g_asf[l_ac].asf15   

     AFTER FIELD asf15
         IF g_asf[l_ac].asf16 <= 0 OR cl_null(g_asf[l_ac].asf16) THEN 
            IF NOT cl_null(g_asf[l_ac].asf15) AND g_asf[l_ac].asf15 > 0  THEN
               LET g_asf[l_ac].asf16= g_asf[l_ac].asf05 * g_asf[l_ac].asf15
            ELSE 
               LET g_asf[l_ac].asf16=0
            END IF 
         END IF 
         DISPLAY BY NAME g_asf[l_ac].asf16        

      AFTER FIELD asf16
         IF cl_null(g_asf[l_ac].asf16) THEN 
             LET g_asf[l_ac].asf16= 0
             DISPLAY BY NAME g_asf[l_ac].asf16         
         ELSE
            LET t_azi04 = ''
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01=g_asf[l_ac].asf14
            LET g_asf[l_ac].asf16=cl_digcut(g_asf[l_ac].asf16,t_azi04)
            DISPLAY BY NAME g_asf[l_ac].asf16
         END IF
#---FUN-A70086 end-----

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_asf[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_asf[l_ac].* TO s_asf.*
            CALL g_asf.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
        #str FUN-910001 add
        #以asf07(公司科目)到agli001帶出ash06(合併財報科目)到asf03
         IF cl_null(g_asf[l_ac].asf03) THEN
            SELECT ash06 INTO g_asf[l_ac].asf03 FROM ash_file
             WHERE ash04=g_asf[l_ac].asf07
               AND ash00=l_asg.asg05
               AND ash01=g_asf02
               AND ash13=g_asf01   #FUN-910001 add
            DISPLAY BY NAME g_asf[l_ac].asf03
         END IF
        #end FUN-910001 add 

         INSERT INTO asf_file(asf01,asf02,asf03,asf04,asf05,
                          #   asf07,asf08,asf09,asf10,asf11)   #FUN-780068 mod 10/19 asf10,asf11 FUN-970049 mark
                              asf06,asf07,asf12,asf13,         #FUN-970049 add #FUN-930018 add asf12,asf13
                              asf14,asf15,asf16)         #FUN-A70086
              VALUES(g_asf01,g_asf02,g_asf[l_ac].asf03,
                     g_asf[l_ac].asf04,g_asf[l_ac].asf05,
                     g_asf[l_ac].asf06,  #FUN-970049 add
                     g_asf[l_ac].asf07,
                     g_asf[l_ac].asf12,g_asf[l_ac].asf13,      #FUN-930018 add
                     g_asf[l_ac].asf14,                       #FUN-A70086
                     g_asf[l_ac].asf15,                       #FUN-A70086
                     g_asf[l_ac].asf16)                        #FUN-A70086
                   # ,g_asf[l_ac].asf08,g_asf[l_ac].asf09,g_asf10,g_asf11)        #FUN-780068 mod 10/19 asf10,asf11 FUN-970049 mark
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asf_file",g_asf[l_ac].asf03,'',
                         SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_asf_t.asf03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM asf_file WHERE asf01 = g_asf01
                                   AND asf02 = g_asf02
                                   AND asf03 = g_asf_t.asf03
                                   AND asf06 = g_asf_t.asf06   #FUN-970049 add
                                   AND asf07 = g_asf_t.asf07
                                 # AND asf08 = g_asf_t.asf08   #FUN-970049 mark
                                 # AND asf09 = g_asf_t.asf09   #FUN-970049 mark
                                 # AND asf10 = g_asf10   #FUN-780068 add 10/19 #FUN-970049 mark
                                 # AND asf11 = g_asf11   #FUN-780068 add 10/19 #FUN-970049 mark
                                   AND asf12 = g_asf_t.asf12   #FUN-930018 add
                                   AND asf13 = g_asf_t.asf13   #FUN-930018 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asf_file",g_asf[l_ac].asf03,"",
                            SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_asf[l_ac].* = g_asf_t.*
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_asf[l_ac].asf03,-263,1)
            LET g_asf[l_ac].* = g_asf_t.*
         ELSE
            UPDATE asf_file SET asf03 = g_asf[l_ac].asf03,
                                asf04 = g_asf[l_ac].asf04,
                                asf05 = g_asf[l_ac].asf05,
                                asf06 = g_asf[l_ac].asf06,  #FUN-970049 add
                                asf07 = g_asf[l_ac].asf07,
                             #  asf08 = g_asf[l_ac].asf08,  #FUN-970049 mark
                             #  asf09 = g_asf[l_ac].asf09   #FUN-970049 mark
                                asf12 = g_asf[l_ac].asf12,  #FUN-930018 add
                                asf13 = g_asf[l_ac].asf13,   #FUN-930018 add
                                asf14 = g_asf[l_ac].asf14,  #FUN-A70086
                                asf15 = g_asf[l_ac].asf15,  #FUN-A70086
                                asf16 = g_asf[l_ac].asf16   #FUN-A70086
                          WHERE asf01 = g_asf01
                            AND asf02 = g_asf02
                            AND asf03 = g_asf_t.asf03
                            AND asf06 = g_asf_t.asf06   #FUN-970049 add
                            AND asf07 = g_asf_t.asf07
                         #  AND asf08 = g_asf_t.asf08   #FUN-970049 mark
                         #  AND asf09 = g_asf_t.asf09   #FUN-970049 mark
                         #  AND asf10 = g_asf10   #FUN-780068 add 10/19 #FUN-970049 mark
                         #  AND asf11 = g_asf11   #FUN-780068 add 10/19 #FUN-970049 mark
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","asf_file",g_asf[l_ac].asf03,"",
                            SQLCA.sqlcode,"","",1)
               LET g_asf[l_ac].* = g_asf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_asf[l_ac].* = g_asf_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_asf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i011_bcl
         COMMIT WORK
         #CKP2
          CALL g_asf.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asf03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ash1"   #FUN-760053 q_ash->q_ash1
               LET g_qryparam.default1 = g_asf[l_ac].asf03
               LET g_qryparam.arg1 = l_asg.asg05
               LET g_qryparam.arg2 = g_asf02
               CALL cl_create_qry() RETURNING g_asf[l_ac].asf03
               DISPLAY BY NAME g_asf[l_ac].asf03
               NEXT FIELD asf03
            WHEN INFIELD(asf04) #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_asf[1].asf04
               CALL cl_create_qry() RETURNING g_asf[l_ac].asf04
               DISPLAY BY NAME g_asf[l_ac].asf04
            WHEN INFIELD(asf07)
               CALL cl_init_qry_var()
               #--FUN-A70086 start---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM asa_file
                WHERE asa01 = g_asf01  
                  AND asa02 = g_asf02 
               IF l_cnt > 0 THEN   #屬上層公司
                   LET l_cnt1 = 0
                   SELECT COUNT(*) INTO l_cnt1
                     FROM asb_file
                    WHERE asb01 = g_asf01  
                      AND asb02 = g_asf02 
                   IF l_cnt1 > 0 THEN   #屬中間層公司
                       LET g_qryparam.form ="q_ashh"
                      #LET g_qryparam.arg1 = g_aaz.aaz641     #TQC-D40119 mark
                       LET g_qryparam.arg1 = g_asz01          #TQC-D40119 add
                   ELSE
                       LET g_qryparam.form ="q_ash2"
                       LET g_qryparam.arg1 = l_asg.asg05
                   END IF
               ELSE
                   LET g_qryparam.form ="q_ash2"
                   LET g_qryparam.arg1 = l_asg.asg05
               END IF
               #-------FUN-A70086 end---------
#              LET g_qryparam.form ="q_ash2"   #FUN-A70086 mark
               LET g_qryparam.default1 = g_asf[l_ac].asf07
               LET g_qryparam.arg1 = l_asg.asg05   #FUN-A70086 mark   #MOD-B30382 取消mark
               LET g_qryparam.arg2 = g_asf02
               LET g_qryparam.arg3 = g_asf01    #MOD-B30382 add
               CALL cl_create_qry() RETURNING g_asf[l_ac].asf07
               DISPLAY BY NAME g_asf[l_ac].asf07
               NEXT FIELD asf07
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asf02) AND l_ac > 1 THEN
            LET g_asf[l_ac].* = g_asf[l_ac-1].*
            LET g_asf[l_ac].asf03=null
            LET g_asf[l_ac].asf07=null
            NEXT FIELD asf07
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i011_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i011_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
  #LET g_sql = "SELECT asf07,'',asf03,'',asf04,asf05,asf08,asf09", #FUN-970049 mark
   #LET g_sql = "SELECT asf07,'',asf03,'',asf04,asf05,asf06,asf12,asf13",  #FUN-970049 add #FUN-930018 add asf12,asf13
   LET g_sql = "SELECT asf07,'',asf03,'',asf06,asf04,asf05,asf15,asf14,asf16,asf12,asf13", #FUN-A70086 
               " FROM asf_file ",
               " WHERE asf01 = '",g_asf01,"'",
               "   AND asf02 = '",g_asf02,"'",
            #  "   AND asf10 =  ",g_asf10,   #FUN-780068 add 10/19 #FUN-970049 mark
            #  "   AND asf11 =  ",g_asf11,   #FUN-780068 add 10/19 #FUN-970049 mark
               "   AND ",p_wc CLIPPED ,
            #  " ORDER BY asf03,asf08,asf09" #FUN-780068 mod 10/19 asf08,asf09 #FUN-970049 mark
               " ORDER BY asf03"             #FUN-970049 add
   PREPARE i011_prepare2 FROM g_sql       #預備一下
   DECLARE asf_cs CURSOR FOR i011_prepare2
 
   CALL g_asf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH asf_cs INTO g_asf[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i011_set_asf03(g_asf[g_cnt].asf03) RETURNING g_asf[g_cnt].aag02
      CALL i011_set_asf07(g_asf[g_cnt].asf07) RETURNING g_asf[g_cnt].aag02a
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_asf.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i011_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asf TO s_asf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first
         CALL i011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#FUN-970049---Beatk mark
#     #str FUN-780068 add 10/19
#      ON ACTION generate   #0期資料產生
#         LET g_action_choice="generate"
#         EXIT DISPLAY
#     #end FUN-780068 add 10/19
#FUN-970049---End amrk
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i011_set_asf03(p_asf03)
DEFINE p_asf03 LIKE asf_file.asf03,
       l_aag02 LIKE aag_file.aag02
 
  #str FUN-760053 mod
  #SELECT aag02 INTO l_aag02 FROM aag_file,asg_file
  # WHERE aag00=asg05
  #   AND asg01=g_asf02
  #   AND aag01=p_asf03
   SELECT aag02 INTO l_aag02 FROM aag_file
   #WHERE aag00=g_aaz.aaz641   #MOD-A30095 aaz64-->aaz641   #TQC-D40119 mark
    WHERE aag00=g_asz01         #TQC-D40119 add
      AND aag01=p_asf03
  #end FUN-760053 mod
   IF SQLCA.sqlcode THEN
      LET l_aag02=NULL
   END IF
   RETURN l_aag02
END FUNCTION
 
FUNCTION i011_set_asf07(p_asf07)
DEFINE p_asf07 LIKE asf_file.asf07,
       l_ash05 LIKE ash_file.ash05
DEFINE l_cnt   LIKE type_file.num5  #FUN-A70086
DEFINE l_cnt1  LIKE type_file.num5  #FUN-A70086   
 
   #---FUN-A70086 start------
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM asa_file
    WHERE asa01 = g_asf01  
      AND asa02 = g_asf02 
   IF l_cnt > 0 THEN   #屬上層公司
       LET l_cnt1 = 0
       SELECT COUNT(*) INTO l_cnt1
         FROM asb_file
        WHERE asb01 = g_asf01  
          AND asb02 = g_asf02 
       IF l_cnt1 > 0 THEN   #屬中間層公司
           SELECT ashh05 INTO l_ash05 
             FROM ashh_file
           #WHERE ashh00=g_aaz.aaz641     #TQC-D40119 mark
            WHERE ashh00=g_asz01          #TQC-D40119 add
              AND ashh01=g_asf02
              AND ashh04=p_asf07
              AND ashh13=g_asf01  
       ELSE
           SELECT ash05 INTO l_ash05 
             FROM ash_file,asg_file
            WHERE ash00=asg05
              AND ash01=asg01
              AND ash01=g_asf02
              AND ash04=p_asf07
              AND ash13=g_asf01  
       END IF
   ELSE
   #---FUN-A70086 end---------    
       SELECT ash05 INTO l_ash05 FROM ash_file,asg_file
        WHERE ash00=asg05
          AND ash01=g_asf02
          AND asg01=ash01
          AND ash04=p_asf07
          AND ash13=g_asf01   #FUN-910001 add
   END IF     #FUN-A70086 add

   IF SQLCA.sqlcode THEN
      LET l_ash05=NULL
   END IF
   RETURN l_ash05
END FUNCTION
 
FUNCTION i011_r()
   IF cl_null(g_asf01) OR cl_null(g_asf02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "asf01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "asf02"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_asf01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_asf02       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM asf_file WHERE asf01=g_asf01
                          AND asf02=g_asf02
                     #    AND asf10=g_asf10   #FUN-780068 add 10/19 #FUN-970049 mark
                     #    AND asf11=g_asf11   #FUN-780068 add 10/19 #FUN-970049 amrk
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","asf_file",g_asf01,g_asf02,SQLCA.sqlcode,"","del asf",1)
      RETURN      
   END IF   
 
   INITIALIZE g_asf01,g_asf02 TO NULL
#  INITIALIZE g_asf10,g_asf11 TO NULL   #FUN-780068 add 10/19 #FUN-970049 mark
   MESSAGE ""
   DROP TABLE i011_cnttmp
   PREPARE i011_precount_x2 FROM g_sql_tmp
   EXECUTE i011_precount_x2
   OPEN i011_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i011_bcs
      CLOSE i011_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   FETCH i011_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i011_bcs
      CLOSE i011_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i011_bcs
      CALL i011_fetch('F') 
   ELSE
      DISPLAY g_asf01 TO asf01
      DISPLAY g_asf02 TO asf02
#     DISPLAY g_asf10 TO asf10   #FUN-780068 add 10/19 #FUN-970049 mark
#     DISPLAY g_asf11 TO asf11   #FUN-780068 add 10/19 #FUN-970049 mark
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_asf.clear()
      CALL i011_menu()
   END IF                      
END FUNCTION
 
#str FUN-780068 add 10/19
FUNCTION i011_g()   #0期資料產生
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
DEFINE l_flag      LIKE type_file.chr1
DEFINE tm          RECORD
                    yy     LIKE asf_file.asf10,
                    mm     LIKE asf_file.asf11
                   END RECORD
 
   OPEN WINDOW i011_g_w AT p_row,p_col WITH FORM "ggl/42f/ggli004_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("ggli004_g")
 
   WHILE TRUE
      INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
            INITIALIZE tm.* TO NULL
            LET tm.yy = YEAR(g_today)    #現行年度
            LET tm.mm = 0                #預設產生0期
            DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD yy
            END IF
            IF tm.yy < 0 THEN NEXT FIELD yy END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i011_g_w
         RETURN
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i011_g_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
         CALL i011_g1(tm.*)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE
 
   CLOSE WINDOW i011_g_w
END FUNCTION
 
FUNCTION i011_g1(tm)
DEFINE tm    RECORD
              yy     LIKE asx_file.asx01,
              mm     LIKE asx_file.asx02
             END RECORD,
       l_cnt LIKE type_file.num5
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM asf_file
    WHERE asf10=tm.yy AND asf11=0
   IF l_cnt > 0 THEN
      #先刪除舊資料,再重新產生
      DELETE FROM asf_file WHERE asf10=tm.yy AND asf11=0
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("del","asf_file",tm.yy,0,SQLCA.sqlcode,"","del asf",1)
         RETURN      
      END IF   
   END IF
 
   DROP TABLE x
 
   #抓上一年度資料產生
   SELECT * FROM asf_file WHERE asf10 = tm.yy-1 INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x", tm.yy-1,"",SQLCA.sqlcode,"","",1)
      LET g_success='N'
      RETURN
   END IF
 
   #產生0期資料
   UPDATE x SET asf10 = tm.yy,asf11 = 0      
 
   INSERT INTO asf_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","asf_file",tm.yy,0,SQLCA.sqlcode,"","asf",1)
      LET g_success='N'
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',tm.yy,') O.K'
 
END FUNCTION
#end FUN-780068 add 10/19
 
{
FUNCTION i011_out()
    DEFINE
        sr              RECORD LIKE asf_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
        l_za05          LIKE za_file.za05       # #No.FUN-680098 VARCHAR(40)
   
    IF g_wc IS NULL THEN 
       IF (NOT cl_null(g_asf01)) AND (NOT cl_null(g_asf02)) THEN
          LET g_wc=" asf01=",g_asf01,
                   " AND asf02=",g_asf02
       ELSE
          CALL cl_err('',-400,0)
          RETURN 
       END IF
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM asf_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY asf01,asf02,asf03"
    PREPARE i011_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i011_co                         # SCROLL CURSOR
         CURSOR FOR i011_p1
 
    CALL cl_outnam('ggli004') RETURNING l_name
    START REPORT i011_rep TO l_name
 
    FOREACH i011_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i011_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i011_rep
 
    CLOSE i011_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i011_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1),
        sr RECORD LIKE asf_file.*,
        l_asg02   LIKE asg_file.asg02,
        l_aag02   LIKE aag_file.aag02,
        l_aag02a  LIKE aag_file.aag02
 
   OUTPUT
       TOP MARGIN g_top_maratk
       LEFT MARGIN g_left_maratk
       BOTTOM MARGIN g_bottom_maratk
       PAGE LENGTH g_page_line
 
    ORDER BY sr.asf01,sr.asf02,sr.asf03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,
                         g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[38],g_x[39],g_x[36],g_x[37]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            SELECT asg02 INTO l_asg02 FROM asg_file WHERE asg01=sr.asf02
            IF SQLCA.sqlcode THEN
               LET l_asg02 =NULL
            END IF
            LET l_aag02 =i011_set_asf03(sr.asf03)
            LET l_aag02a=i011_set_asf03(sr.asf07)
            SELECT azi04 INTO t_azi04 FROM azi_file
                                     WHERE azi01=sr.asf04
            PRINT COLUMN g_c[31],sr.asf01,
                  COLUMN g_c[32],sr.asf02,                  
                  COLUMN g_c[33],l_asg02,
                  COLUMN g_c[34],sr.asf07,
                  COLUMN g_c[35],l_aag02a,
                  COLUMN g_c[38],sr.asf03,
                  COLUMN g_c[39],l_aag02,
                  COLUMN g_c[36],sr.asf04,
                  COLUMN g_c[37],cl_numfor(sr.asf05,37,t_azi04)
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
FUNCTION i011_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i011_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
   CALL cl_set_comp_entry("asf03",FALSE)   #FUN-910001 add  
END FUNCTION
 
FUNCTION i011_set_asg02()
   DEFINE l_asg02 LIKE asg_file.asg02
   SELECT asg02 INTO l_asg02 FROM asg_file
                            WHERE asg01=g_asf02
   IF SQLCA.sqlcode THEN
      LET l_asg02=NULL
   END IF
   RETURN l_asg02
END FUNCTION
 
#FUN-780013
FUNCTION i011_chk_data()
   IF (NOT cl_null(g_asf[l_ac].asf07)) AND
      (NOT cl_null(g_asf[l_ac].asf03)) THEN   #FUN-970049 #AND
    # (NOT cl_null(g_asf[l_ac].asf08)) AND    #FUN-970049 mark
    # (NOT cl_null(g_asf[l_ac].asf09)) THEN   #FUN-970049 mark
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM asf_file 
                                WHERE asf01=g_asf01
                                  AND asf02=g_asf02
                                  AND asf06=g_asf[l_ac].asf06  #FUN-970049 add
                                  AND asf07=g_asf[l_ac].asf07
                                  AND asf03=g_asf[l_ac].asf03
                                # AND asf08=g_asf[l_ac].asf08  #FUN-970049 mark 
                                # AND asf09=g_asf[l_ac].asf09  #FUN-970049 mark
                                # AND asf10=g_asf10   #FUN-780068 add 10/19 #FUN-970049 mark
                                # AND asf11=g_asf11   #FUN-780068 add 10/19 #FUN-970049 mark
                                  AND asf12=g_asf[l_ac].asf12   #FUN-930018 add
                                  AND asf13=g_asf[l_ac].asf13   #FUN-930018 add
      IF g_cnt>0 THEN
         CALL cl_err('',-239,1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i011_out()
   DEFINE l_wc STRING
   DEFINE l_ash00 LIKE ash_file.ash00
 
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'ggli004'
 
   #組合出 SQL 指令
 # LET g_sql="SELECT DISTINCT A.asf01,A.asf02,A.asf10,A.asf11,",   #FUN-780068 add 10/19 A.asf10,A.asf11 #FUN-970049 mark
   LET g_sql="SELECT DISTINCT A.asf01,A.asf02,", #FUN-970049 add
             "                B.asg02 as asf02_d,",
             "                A.asf07,C.ash05 as asf07_d,A.asf03,",
             "                D.aag02 as asf03_d,A.asf04,A.asf05,",
         #   "                A.asf08,A.asf09,E.azi04 ", #FUN-970049 mark
             "                E.azi04 ",                 #FUN-970049 
             "  FROM asf_file A,asg_file B,ash_file C,",
             "       aag_file D,azi_file E,asg_file F",
             " WHERE A.asf02 = B.asg01",
             "   AND A.asf02 = C.ash01",
             "   AND A.asf07 = C.ash04",
             "   AND A.asf01 = C.ash13",   #FUN-910001 add
             "   AND C.ash00 = F.asg05",
             "   AND F.asg01 = A.asf02",
             "   AND A.asf03 = D.aag01",
            #"   AND D.aag00 = '",g_aaz.aaz641,"'",   #MOD-A30095 aaz64-->aaz641    #TQC-D40119 mark
             "   AND D.aag00 = '",g_asz01,"'",   #MOD-A30095 aaz64-->aaz641         #TQC-D40119 add
             "   AND E.azi01 = A.asf04",
             "   AND ",g_wc CLIPPED,
            #" ORDER BY A.asf01,A.asf02,A.asf07,A.asf03,A.asf08,A.asf09"                   #FUN-780068 mark 10/19
            #" ORDER BY A.asf01,A.asf02,A.asf10,A.asf11,A.asf07,A.asf03,A.asf08,A.asf09"   #FUN-780068      10/19 #FUN-970049 mark
             " ORDER BY A.asf01,A.asf02,A.asf07,A.asf03," #FUN-970049
   PREPARE i011_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i011_co CURSOR FOR i011_p1
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
     #CALL cl_wcchp(g_wc,'asf01,asf02,asf07,asf03,asf04,asf05,asf08,asf09')               #FUN-780068 mark 10/19
     #CALL cl_wcchp(g_wc,'asf01,asf02,asf10,asf11,asf07,asf03,asf04,asf05,asf08,asf09')   #FUN-780068      10/19 #FUN-970049 mark
      CALL cl_wcchp(g_wc,'asf01,asf02,asf07,asf03,asf04,asf05,asf06') #FUN-970049
           RETURNING l_wc
   ELSE
      LET l_wc = ''
   END IF
 
   CALL cl_prt_cs1('ggli004','ggli004',g_sql,l_wc)
END FUNCTION   #FUN-BB0036
