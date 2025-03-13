# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglt900.4gl
# Descriptions...: 期間現金活動分類維護作業
# Date & Author..: 04/02/01 Fuli
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0009 06/10/12 By jamie  1.FUNCTION t900_q() 一開始應清空g_tai01的值
#                                                   2.t900_r()增加刪除後出現錯誤訊 息
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730049 07/03/13 By Smapmin 現金異動碼不能維護
# Modify.........: No.FUN-740055 07/04/13 By arman   會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.CHI-850021 08/06/11 By Sarah 單頭新增後,進入單身前先檢查有沒有資料,沒有則顯示axc-034訊息
# Modify.........: No.TQC-980241 09/08/25 By Carrier 刪除后筆數問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0022 09/11/04 By Sarah t9001_gen()段l_sql在組" AND aba00=",g_tia05時前後漏了"'"
# Modify.........: No:FUN-A10088 10/01/20 By wujie 现金变动码预设科目设定的变动码
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-AB0309 10/11/30 By suncx 修改單身不讓新增
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C40069 12/04/11 BY wujie g1900_1画面预设tib09，逻辑参考g1画面的逻辑
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tia01         LIKE tia_file.tia01,
    g_tia02         LIKE tia_file.tia02,
    g_tia03         LIKE tia_file.tia03,
    g_tia04         LIKE tia_file.tia04,
    g_tia05         LIKE tia_file.tia05,
    g_tia01_t       LIKE tia_file.tia01,
    g_tia02_t       LIKE tia_file.tia02,
    g_tia05_t       LIKE tia_file.tia05,
    g_tia           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        tia06       LIKE tia_file.tia06,     #科目編號
        aag02       LIKE aag_file.aag02,     #科目名稱
        tia07       LIKE tia_file.tia07,     #借/貸
        tia08       LIKE tia_file.tia08,     #金額
        tia081      LIKE tia_file.tia081,    #金額
        tia09       LIKE tia_file.tia09      #異動別
                    END RECORD,
    g_tia_t         RECORD                   #程式變數 (舊值)
        tia06       LIKE tia_file.tia06,     #科目編號
        aag02       LIKE aag_file.aag02,     #科目名稱
        tia07       LIKE tia_file.tia07,     #借/貸
        tia08       LIKE tia_file.tia08,     #金額
        tia081      LIKE tia_file.tia081,    #金額
        tia09       LIKE tia_file.tia09      #異動別
                    END RECORD,
     g_wc,g_wc2,g_sql   string,                 #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,    #NO.FUN-690009   SMALLINT     #單身筆數
    g_rec_b2            LIKE type_file.num5,    #NO.FUN-690009   SMALLINT     #單身筆數
    g_rec_b3            LIKE type_file.num5,    #NO FUN-690009   SMALLINT     #單身筆數
    g_cnt2,g_cnt3       LIKE type_file.num5,    #NO FUN-690009   SMALLINT     #單身筆數
    l_ac                LIKE type_file.num5,    #NO FUN-690009   SMALLINT     #目前處理的ARRAY CNT
    p_row,p_col         LIKE type_file.num5,    #NO FUN-690009   SMALLINT     #開窗的位置
    g_tib           DYNAMIC ARRAY OF RECORD
                    aba02	LIKE aba_file.aba02,
                    tib06	LIKE tib_file.tib06,
                    tib07	LIKE tib_file.tib07,
                    abb04	LIKE abb_file.abb04,
                    tib08	LIKE tib_file.tib08,
                    tib09	LIKE tib_file.tib09
    	            END RECORD,
    g_tib_t	    RECORD
                    aba02	LIKE aba_file.aba02,
                    tib06	LIKE tib_file.tib06,
                    tib07	LIKE tib_file.tib07,
                    abb04	LIKE abb_file.abb04,
                    tib08	LIKE tib_file.tib08,
                    tib09	LIKE tib_file.tib09
            	    END RECORD,
    g_tib09_t       LIKE tib_file.tib09,
    l_ac2           LIKE type_file.num5,    #NO.FUN-690009 SMALLINT    #目前處理的ARRAY CNT
    g_abb           DYNAMIC ARRAY OF RECORD
                    sel      LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                    aba02    LIKE aba_file.aba02,
                    abb01    LIKE abb_file.abb01,
                    abb02    LIKE abb_file.abb02,
                    abb04    LIKE abb_file.abb04,
                    abb07    LIKE abb_file.abb07,
                    aba06    LIKE aba_file.aba06,
                    tib09    LIKE tib_file.tib09
                    END RECORD,
    l_ac3           LIKE type_file.num5,    #NO FUN-690009   SMALLINT              #目前處理的ARRAY CNT
    g_bdate,g_edate LIKE type_file.dat      #NO FUN-690009   DATE
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_chr           LIKE type_file.chr1     #NO FUN-690009   VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_before_input_done LIKE type_file.num5     #NO FUN-690009   SMALLINT
DEFINE   g_jump          LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO FUN-690009   SMALLINT
DEFINE   g_sql_tmp       STRING                  #No.TQC-980241
 
#主程式開始
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6A0097
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GGL")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
    LET g_tia01      = NULL                #清除鍵值
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t900_w AT p_row,p_col      #顯示畫面
        WITH FORM "ggl/42f/gglt900"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL t900_menu()
    CLOSE WINDOW t900_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION t900_cs()
    CLEAR FORM                                   #清除畫面
    CALL g_tia.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_tia01 TO NULL    #No.FUN-750051
   INITIALIZE g_tia02 TO NULL    #No.FUN-750051
   INITIALIZE g_tia03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON tia01,tia02,tia03,tia04,tia05,tia06,
                      tia07,tia08,tia09    #螢幕上取條件
                 FROM tia01,tia02,tia03,tia04,tia05,s_tia[1].tia06,
                      s_tia[1].tia07,s_tia[1].tia08,s_tia[1].tia09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            IF INFIELD(tia05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tia05
              NEXT FIELD tia05
            END IF
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tiauser', 'tiagrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT UNIQUE tia01,tia02,tia03,tia04,tia05 ",
              "  FROM tia_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY tia01,tia02,tia03,tia04,tia05"
    PREPARE t900_prepare FROM g_sql              #預備一下
    DECLARE t900_b_cs                            #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR t900_prepare
                                                 #計算本次查詢單頭的筆數
    #No.TQC-980241  --Begin
    #LET g_sql="SELECT DISTINCT tia01,tia02,tia03,tia04,tia05 ",
    LET g_sql_tmp ="SELECT DISTINCT tia01,tia02,tia03,tia04,tia05 ",
                   "  FROM tia_file WHERE ",g_wc CLIPPED,
                   "  INTO TEMP x"
    DROP TABLE x
    #PREPARE t900_precount FROM g_sql
    PREPARE t900_precount FROM g_sql_tmp
    EXECUTE t900_precount
    #DECLARE t900_count CURSOR FOR SELECT COUNT(*) FROM x
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE t900_pc1 FROM g_sql
    DECLARE t900_count CURSOR FOR t900_pc1
    #No.TQC-980241  --End  
END FUNCTION
 
FUNCTION t900_menu()
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t900_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t900_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t900_r()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t900_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_tia01 IS NOT NULL THEN
                  LET g_doc.column1 = "tia01"
                  LET g_doc.value1 = g_tia01
                  LET g_doc.column2 = "tia02"
                  LET g_doc.value2 = g_tia02
                  LET g_doc.column3 = "tia05"
                  LET g_doc.value3 = g_tia05
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tia),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t900_a()
DEFINE   l_n    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
 	 p_sw   LIKE type_file.chr1     #NO FUN-690009   VARCHAR(01)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_tia01 LIKE tia_file.tia01
    INITIALIZE g_tia02 LIKE tia_file.tia02
    INITIALIZE g_tia03 LIKE tia_file.tia03
    INITIALIZE g_tia04 LIKE tia_file.tia04
    INITIALIZE g_tia05 LIKE tia_file.tia05
    LET g_tia01_t = NULL
    LET g_tia02_t = NULL
    LET g_tia05_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t900_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
           LET g_tia01 = NULL
           LET g_tia02 = NULL
           LET g_tia05 = NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        CALL g_tia.clear()
        LET g_rec_b=0
        CALL t900_g_b()
        CALL t900_b()
        LET g_tia01_t = g_tia01
        LET g_tia02_t = g_tia02
        LET g_tia05_t = g_tia05
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t900_i(p_cmd)
DEFINE li_chk_bookno   LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
DEFINE p_cmd           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #a:輸入 u:更改
       l_cnt           LIKE type_file.num5     #NO FUN-690009   SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_tia01,g_tia02,g_tia03,g_tia04,g_tia05 WITHOUT DEFAULTS
          FROM tia01,tia02,tia03,tia04,tia05
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t900_set_entry(p_cmd)
            CALL t900_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         AFTER FIELD tia02
            IF g_tia02 < 1 OR g_tia02 > 13 THEN
               NEXT FIELD tia02
            END IF
 
         AFTER FIELD tia03
            IF NOT cl_null(g_tia03) THEN
               IF g_tia01 != g_tia03 THEN NEXT FIELD tia03 END IF
            END IF
 
         AFTER FIELD tia04
            IF NOT cl_null(g_tia04) THEN
               IF g_tia04 < 1 OR g_tia04 > 13 THEN
                  NEXT FIELD tia04
               END IF
               IF (g_tia03*12+g_tia04)<(g_tia01*12+g_tia02) THEN
                  NEXT FIELD tia04
               END IF
            END IF
 
         AFTER FIELD tia05
            IF NOT cl_null(g_tia05) THEN
               #No.FUN-670004--begin
                  CALL s_check_bookno(g_tia05,g_user,g_plant) 
                  RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  LET g_tia05 = g_tia05_t
                  NEXT FIELD tia05
               END IF 
               #No.FUN-670004--end
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                  (g_tia01 != g_tia01_t OR g_tia02 != g_tia02_t OR
                  g_tia05 != g_tia05_t)) THEN
                  SELECT aaa01 FROM aaa_file WHERE aaa01 = g_tia05
                  IF STATUS THEN
#                    CALL cl_err(g_tia05,'aap-229',0)    #No.FUN-660124
                     CALL cl_err3("sel","aaa_file",g_tia05,"","aap-229","","",1)  #No.FUN-660124
                     NEXT FIELD tia05
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM tia_file
                   WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_tia05,-239,0) NEXT FIELD tia01
                  END IF
               END IF
            END IF
               
               
 
        ON ACTION CONTROLP
            IF INFIELD(tia05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = g_tia05
               CALL cl_create_qry() RETURNING g_tia05
               DISPLAY BY NAME g_tia05
               NEXT FIELD tia05
            END IF
 
#--NO.MOD-860078 start---
  
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
    END INPUT
END FUNCTION
 
FUNCTION t900_g_b()
DEFINE  l_abb03         LIKE abb_file.abb03,
	l_abb06         LIKE abb_file.abb06,
	l_abb07         LIKE abb_file.abb07,
	l_abb00         LIKE abb_file.abb00,    #No.FUN-A10088
        l_tia           RECORD LIKE tia_file.*,
        l_i             LIKE type_file.num5,    #NO FUN-690009   SMALLINT
        l_cnt           LIKE type_file.num5,    #NO FUN-690009   SMALLINT
        l_sql           LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)
        l_bdate,l_edate LIKE type_file.dat      #NO FUN-690009   DATE
 
    SELECT COUNT(*) INTO l_cnt FROM tia_file
     WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
    IF l_cnt > 0 THEN RETURN END IF
 
    CALL s_azn01(g_tia01,g_tia02) RETURNING g_bdate,l_edate
    CALL s_azn01(g_tia03,g_tia04) RETURNING l_bdate,g_edate
 
#   LET l_sql = "SELECT abb03,abb06,SUM(abb07) ",
    LET l_sql = "SELECT abb00,abb03,abb06,SUM(abb07) ",    #No.FUN-A10088
                "  FROM aba_file,abb_file,aag_file",
                " WHERE aba00='",g_tia05,"' AND aag01=abb03",
                "   AND aba02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                "   AND aba01=abb01 AND aba00=abb00",
                "   AND abb00 = aag00 AND aag00 = '",g_tia05,"'",     #NO.FUN-740055
                "   AND abapost='Y' AND aag19 != 1 ",
                "   AND aba01 IN ",
                "       (SELECT UNIQUE abb01 ",
                "          FROM aba_file,abb_file,aag_file",
                "         WHERE aba00='",g_tia05,"'",
                "           AND aba02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                "           AND aag01=abb03 AND aba01=abb01 ",
                "           AND abb00=aag00 AND aag00 = '",g_tia05,"'",   #NO.FUN-740055
                "           AND aba00=abb00 AND abapost='Y'",
                "           AND aag19=1)",
#               " GROUP BY abb03,abb06 "
                " GROUP BY abb00,abb03,abb06 "     #No.FUN-A10088
    PREPARE tia_pre2 FROM l_sql
    IF STATUS THEN CALL cl_err('tia_pre',STATUS,0) RETURN END IF
    DECLARE tia_curs2 CURSOR FOR tia_pre2
 
    INITIALIZE l_tia.* TO NULL
#   FOREACH tia_curs2 INTO l_abb03,l_abb06,l_abb07
    FOREACH tia_curs2 INTO l_abb00,l_abb03,l_abb06,l_abb07    #No.FUN-A10088
       IF STATUS THEN CALL cl_err('tia_curs',STATUS,0) EXIT FOREACH END IF
       LET l_tia.tia01 = g_tia01
       LET l_tia.tia02 = g_tia02
       LET l_tia.tia03 = g_tia03
       LET l_tia.tia04 = g_tia04
       LET l_tia.tia05 = g_tia05
       LET l_tia.tia06 = l_abb03
       LET l_tia.tia07 = l_abb06
       LET l_tia.tia08 = l_abb07
       LET l_tia.tia081= 0
#No.FUN-A10088 --begin
       SELECT aag41 INTO l_tia.tia09 FROM aag_file 
        WHERE aag00 = l_abb00
          AND aag01 = l_abb03
#      LET l_tia.tia09 = ' '
#No.FUN-A10088 --end
       LET l_tia.tiauser = g_user
#      LET g_tia.tiaoriu = g_user #FUN-980030  #09/10/21 xiaofeizhu Mark
#      LET g_tia.tiaorig = g_grup #FUN-980030  #09/10/21 xiaofeizhu Mark
#      LET l_tia.tiaoriu = g_user              #09/10/21 xiaofeizhu Add
#      LET l_tia.tiaorig = g_grup              #09/10/21 xiaofeizhu Add
       LET l_tia.tiagrup = g_grup
       LET l_tia.tiadate = g_today
 
       INSERT INTO tia_file VALUES(l_tia.*)
 
       IF SQLCA.sqlcode THEN
#         CALL cl_err('ins tia',STATUS,0)    #No.FUN-660124
          CALL cl_err3("ins","tia_file",g_tia01,g_tia02,STATUS,"","ins tia",1)  #No.FUN-660124
          EXIT FOREACH
       END IF
    END FOREACH
    CALL t900_b_fill('1=1')
END FUNCTION
 
#Query 查詢
FUNCTION t900_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tia01 TO NULL             #No.FUN-6A0009
    INITIALIZE g_tia02 TO NULL             #No.FUN-6A0009
    INITIALIZE g_tia05 TO NULL             #No.FUN-6A0009
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL t900_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t900_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tia01 TO NULL
        INITIALIZE g_tia02 TO NULL
        INITIALIZE g_tia05 TO NULL
    ELSE
        CALL t900_fetch('F')               #讀出TEMP第一筆并顯示
        OPEN t900_count
        FETCH t900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #處理方式
    l_abso          LIKE type_file.num10    #NO FUN-690009   INTEGER   #絕對的筆數
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t900_b_cs INTO g_tia01,g_tia02,g_tia03,
                                               g_tia04,g_tia05
        WHEN 'P' FETCH PREVIOUS t900_b_cs INTO g_tia01,g_tia02,g_tia03,
                                               g_tia04,g_tia05
        WHEN 'F' FETCH FIRST    t900_b_cs INTO g_tia01,g_tia02,g_tia03,
                                               g_tia04,g_tia05
        WHEN 'L' FETCH LAST     t900_b_cs INTO g_tia01,g_tia02,g_tia03,
                                               g_tia04,g_tia05
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
 
            FETCH ABSOLUTE g_jump t900_b_cs INTO g_tia01,g_tia02,g_tia03,g_tia04,g_tia05  #No.TQC-980241
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tia01,SQLCA.sqlcode,0)
       INITIALIZE g_tia01 TO NULL  #TQC-6B0105
       INITIALIZE g_tia02 TO NULL  #TQC-6B0105
       INITIALIZE g_tia05 TO NULL  #TQC-6B0105
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
    CALL t900_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t900_show()
    DISPLAY g_tia01,g_tia02,g_tia03,g_tia04,g_tia05
         TO tia01,tia02,tia03,tia04,tia05              #單頭
    CALL t900_b_fill(g_wc)                             #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t900_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
#   IF g_tia01 IS NULL THEN RETURN END IF                            #No.FUN-6A0009
    IF g_tia01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF     #No.FUN-6A0009
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tia01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tia01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "tia02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_tia02       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "tia05"      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_tia05       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM tib_file WHERE tib01 = g_tia01 AND tib02 = g_tia02
                               AND tib03=g_tia05
        DELETE FROM tia_file WHERE tia01 = g_tia01 AND tia02 = g_tia02
                               AND tia05=g_tia05
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660124
            CALL cl_err3("del","tia_file",g_tia01,g_tia02,SQLCA.sqlcode,"","body delete:",1)  #No.FUN-660124
        ELSE
            CLEAR FORM
            CALL g_tia.clear()
            LET g_tia01 = NULL
            LET g_tia02 = NULL
            LET g_tia05 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
--mi
            #No.TQC-980241  --Begin
            DROP TABLE x
            PREPARE t900_pre_xx FROM g_sql_tmp
            EXECUTE t900_precount
            #No.TQC-980241  --End  
            OPEN t900_count
#FUN-B50065------begin---
            IF STATUS THEN
               CLOSE t900_count
               COMMIT WORK
               RETURN
            END IF
#FUN-B50065------end------
            FETCH t900_count INTO g_row_count
#FUN-B50065------begin---
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE t900_count
               COMMIT WORK
               RETURN
            END IF
#FUN-B50065------end------

            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN t900_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL t900_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL t900_fetch('/')
            END IF
--#
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #檢查重復用
    l_lock_sw       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #處理狀態
    l_tia_delyn     LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #判斷是否可以刪除單身資料ROW
    l_chr           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #可新增否
    l_allow_delete  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    IF g_tia01 IS NULL THEN RETURN END IF
 
   #str CHI-850021 add
   #檢查單身有沒有資料,若沒有則顯示axc-034訊息
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM tia_file
     WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
    IF l_n = 0 THEN CALL cl_err('','axc-034',1) RETURN END IF
   #end CHI-850021 add
 
    CALL cl_opmsg('b')                #單身處理的操作提示
 
    LET g_forupd_sql =
        "SELECT tia06,'',tia07,tia08,tia081,tia09 FROM tia_file ",
        " WHERE tia01 = ? AND tia02 = ? AND tia05 = ? AND tia06 = ? ",
        "   AND tia07 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    #LET l_allow_insert = cl_detail_input_auth("insert")  #TQC-AB0309 mark
    LET l_allow_insert = FALSE   #TQC-AB0309 add 
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tia WITHOUT DEFAULTS FROM s_tia.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_tia_t.* = g_tia[l_ac].*  #BACKUP
               OPEN t900_b_cl USING g_tia01,g_tia02,g_tia05,
                                    g_tia_t.tia06,g_tia_t.tia07
               IF STATUS THEN
                  CALL cl_err("OPEN t900_b_cl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t900_b_cl INTO g_tia[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock tia',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                      RETURN
                  END IF
                  SELECT aag02 INTO g_tia[l_ac].aag02 FROM aag_file
                   WHERE aag01 = g_tia[l_ac].tia06
                     AND aag00 = g_tia05             #NO.FUN-740055
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
      #str CHI-850021 add
       BEFORE FIELD tia09
           IF cl_null(g_tia[l_ac].tia06) THEN
              CALL cl_err('','axc-034',1) RETURN
           END IF
      #end CHI-850021 add
 
       AFTER FIELD tia09
           IF NOT cl_null(g_tia[l_ac].tia09) THEN
              #No.TQC-980241  --Begin
              #SELECT nml01 FROM nml_file WHERE nml01 = g_tia[l_ac].tia09
              #IF STATUS THEN
#             #   CALL cl_err(g_tia[l_ac].tia09,'anm-140',0)    #No.FUN-660124
              #   CALL cl_err3("sel","nml_file",g_tia[l_ac].tia09,"","anm-140","","",1)  #No.FUN-660124
              #   NEXT FIELD tia09 
              #END IF
              CALL t900_tia09(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tia[l_ac].tia09,g_errno,0)
                 NEXT FIELD tia09
              END IF
              #No.TQC-980241  --End  
              #-----TQC-730049---------
              UPDATE tia_file SET tia09  = g_tia[l_ac].tia09,
                                  tiamodu= g_user,
                                  tiadate= g_today
               WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
                 AND tia06 = g_tia_t.tia06
                 AND tia07 = g_tia_t.tia07
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tia_file",g_tia[l_ac].tia06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660124
              END IF
              #-----END TQC-730049-----
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tia[l_ac].* = g_tia_t.*
              CLOSE t900_b_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tia[l_ac].tia06,-263,1)
              LET g_tia[l_ac].* = g_tia_t.*
           ELSE
              UPDATE tia_file SET tia081 = g_tia[l_ac].tia081,
                                  tia09  = g_tia[l_ac].tia09,
                                  tiamodu= g_user,
                                  tiadate= g_today
               WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
                 AND tia06 = g_tia_t.tia06
                 AND tia07 = g_tia_t.tia07
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_tia[l_ac].tia06,SQLCA.sqlcode,0)   #No.FUN-660124
                 CALL cl_err3("upd","tia_file",g_tia[l_ac].tia06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660124
                 LET g_tia[l_ac].* = g_tia_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tia[l_ac].* = g_tia_t.*
               END IF
               CLOSE t900_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t900_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLP
            IF INFIELD(tia09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_tia[l_ac].tia09
               CALL cl_create_qry() RETURNING g_tia[l_ac].tia09
               NEXT FIELD tia09
            END IF
 
        ON ACTION CONTROLY
            IF INFIELD(tia09) THEN    #設定傳票現金代碼
            	CALL t900_detail()
            	CALL t900_upd_tia081()
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
     #FUN-5B0116-begin
      UPDATE tia_file SET tiamodu = g_user,tiadate = g_today
       WHERE tia01 = g_tia01
         AND tia02 = g_tia02
         AND tia05 = g_tia05
         AND tia06 = g_tia[l_ac].tia06
         AND tia07 = g_tia[l_ac].tia07
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('upd tia',SQLCA.SQLCODE,1)   #No.FUN-660124
         CALL cl_err3("upd","tia_file",g_tia01,g_tia02,SQLCA.sqlcode,"","upd tia",1)  #No.FUN-660124
      END IF
     #FUN-5B0116-end
 
    CLOSE t900_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t900_b_askkey()
    CLEAR FORM
    CALL g_tia.clear()
    CONSTRUCT g_wc2 ON tia06,tia07,tia08,tia09           #螢幕上取條件
                  FROM s_tia[1].tia06,s_tia[1].tia07,s_tia[1].tia08,
                       s_tia[1].tia09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            IF INFIELD(tia09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_tia[1].tia09
               NEXT FIELD tia09
            END IF
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
    CALL t900_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t900_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(300)
    l_flag          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #有無單身筆數
    l_sql           LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(300)
 
    LET l_sql = "SELECT tia06,aag02,tia07,tia08,tia081,tia09,'' ",
                "  FROM tia_file LEFT OUTER JOIN aag_file ON tia_file.tia05=aag_file.aag00 AND tia_file.tia06=aag_file.aag01",
                " WHERE tia01 = ",g_tia01,
                "   AND tia02 = ",g_tia02,
                "   AND tia05 = '",g_tia05,"'",
                "   AND aag00 = '",g_tia05,"'",   #NO.FUN-740055
                "  AND ",p_wc CLIPPED,
                " ORDER BY tia06,tia07"
 
    PREPARE tia_pre FROM l_sql
    DECLARE tia_cs CURSOR FOR tia_pre
 
    CALL g_tia.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH tia_cs INTO g_tia[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tia.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t900_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tia TO s_tia.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
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
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
      ON ACTION last
         CALL t900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #FUN-550037(smin)
      AFTER DISPLAY
        CONTINUE DISPLAY
      #END FUN-550037(smin)
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
#--NO.MOD-860078 start---
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
#--NO.MOD-860078 end------- 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900_detail()
 
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW t9001_w AT p_row,p_col
         WITH FORM "ggl/42f/gglt900_1" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("gglt900_1")
    DISPLAY g_tia01,g_tia02,g_tia03,g_tia04,g_tia05,
            g_tia_t.tia06,g_tia_t.aag02,g_tia_t.tia07
         TO tia01,tia02,tia03,tia04,tia05,tia06,aag02,tia07
    CALL t9001_b_fill()
    CALL t9001_menu()
    CLOSE WINDOW t9001_w
END FUNCTION
 
FUNCTION t9001_menu()
   WHILE TRUE
      CALL t9001_bp("G")
      CASE g_action_choice
     #@ WHEN "G.篩選" HELP 32001
        WHEN "btn01"
           IF cl_chk_act_auth() THEN
                CALL t9001_gen(g_tia_t.tia06,g_tia_t.tia07)
                CALL t9001_b_fill()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t9001_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tib),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t9001_b_fill()
 DEFINE l_flag          LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   DECLARE tib_cs CURSOR FOR
    SELECT aba02,tib06,tib07,abb04,tib08,tib09,''
      FROM tib_file,aba_file,abb_file
     WHERE aba00 = abb00 AND aba01 = abb01
       AND aba00 = tib03 AND aba01 = tib06
       AND abb02 = tib07
       AND tib01 = g_tia01 AND tib02 = g_tia02
       AND tib03 = g_tia05 AND tib04 = g_tia_t.tia06
       AND tib05 = g_tia_t.tia07
 
    CALL g_tib.clear()
    LET g_cnt2 = 1
    LET g_rec_b2 = 0
    FOREACH tib_cs INTO g_tib[g_cnt2].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
        END IF
        LET g_cnt2 = g_cnt2 + 1
        IF g_cnt2 > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tib.deleteElement(g_cnt2)
    LET g_rec_b2 = g_cnt2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt2 = 0
END FUNCTION
 
FUNCTION t9001_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tib TO s_tib.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      ON ACTION btn01
         LET g_action_choice="btn01"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #FUN-550037(smin)
      AFTER DISPLAY
        CONTINUE DISPLAY
      #END FUN-550037(smin)
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
#--NO.MOD-860078 start---
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
#--NO.MOD-860078 end------- 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t9001_b()
DEFINE  l_ac_t          LIKE type_file.num5,    #NO FUN-690009   SMALLINT    #未取消的ARRAY CNT
        l_n             LIKE type_file.num5,    #NO FUN-690009   SMALLINT    #檢查重復用
        p_cmd           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
        l_exit_sw       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
        l_lock_sw       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
        l_allow_insert  LIKE type_file.num5,    #NO FUN-690009   SMALLINT    #可新增否
        l_allow_delete  LIKE type_file.num5     #NO FUN-690009   SMALLINT    #可刪除否
 
    LET g_action_choice = ""
 
    CALL cl_opmsg('b')                #單身處理的操作提示
 
    LET g_forupd_sql = "SELECT '',tib06,tib07,'',tib08,tib09 ",
                       "  FROM tib_file ",
                       " WHERE tib01 = ? AND tib02 = ? AND tib03 = ? ",
                       "   AND tib04 = ? AND tib05 = ? AND tib06 = ? ",
                       "   AND tib07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t9001_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    LET l_ac_t=0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tib WITHOUT DEFAULTS FROM s_tib.*
          ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n = ARR_COUNT()
            IF g_rec_b2 >= l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_tib_t.* = g_tib[l_ac2].*  #BACKUP
               OPEN t9001_b_cl USING g_tia01,g_tia02,g_tia05,g_tia_t.tia06,g_tia_t.tia07,g_tib_t.tib06,g_tib_t.tib07
               IF STATUS THEN
                  CALL cl_err("OPEN t9001_b_cl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t9001_b_cl INTO g_tib[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock tib',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                     RETURN
                  END IF
                  SELECT aba02,abb04 INTO g_tib[l_ac2].aba02,g_tib[l_ac2].abb04
                    FROM aba_file,abb_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND aba00 = g_tia05
                     AND aba01 = g_tib[l_ac2].tib06 AND abb02 = g_tib[l_ac2].tib07
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER FIELD tib09
            IF NOT cl_null(g_tib[l_ac2].tib09) THEN
               SELECT nml01 FROM nml_file WHERE nml01 = g_tib[l_ac2].tib09
               IF STATUS THEN
#                 CALL cl_err(g_tib[l_ac2].tib09,'anm-140',0)    #No.FUN-660124
                  CALL cl_err3("sel","nml_file",g_tib[l_ac2].tib09,"","anm-140","","",1)  #No.FUN-660124
                  NEXT FIELD tib09
               END IF
               #-----TQC-730049---------
               UPDATE tib_file SET tib09  = g_tib[l_ac2].tib09
                WHERE tib01 = g_tia01 AND tib02 = g_tia02 AND tib03 = g_tia05
                  AND tib04 = g_tia_t.tia06 AND tib05 = g_tia_t.tia07
                  AND tib06 = g_tib_t.tib06 AND tib07 = g_tib_t.tib07
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tib_file",g_tib[l_ac].tib06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660124
               END IF
               #-----END TQC-730049-----
            END IF
 
        BEFORE DELETE
            IF g_tib_t.tib06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM tib_file
                WHERE tib01 = g_tia01 AND tib02 = g_tia02 AND tib03 = g_tia05
                  AND tib04 = g_tia_t.tia06 AND tib05 = g_tia_t.tia07
                  AND tib06 = g_tib_t.tib06 AND tib07 = g_tib_t.tib07
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_tib_t.tib06,SQLCA.sqlcode,0)   #No.FUN-660124
                    CALL cl_err3("del","tib_file",g_tib_t.tib06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660124
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b2=g_rec_b2-1
                DISPLAY g_rec_b2 TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tib[l_ac2].* = g_tib_t.*
               CLOSE t9001_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tib[l_ac2].tib06,-263,1)
               LET g_tib[l_ac2].* = g_tib_t.*
            ELSE
                UPDATE tib_file SET tib09  = g_tib[l_ac2].tib09
                 WHERE tib01 = g_tia01 AND tib02 = g_tia02 AND tib03 = g_tia05
                   AND tib04 = g_tia_t.tia06 AND tib05 = g_tia_t.tia07
                   AND tib06 = g_tib_t.tib06 AND tib07 = g_tib_t.tib07
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_tib[l_ac2].tib06,SQLCA.sqlcode,0)   #No.FUN-660124
                   CALL cl_err3("upd","tib_file",g_tib[l_ac].tib06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660124
                   LET g_tib[l_ac2].* = g_tib_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac_t = l_ac2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tib[l_ac].* = g_tib_t.*
               END IF
               CLOSE t9001_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t9001_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            IF INFIELD(tib09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_tib[l_ac2].tib09
               CALL cl_create_qry() RETURNING g_tib[l_ac2].tib09
               NEXT FIELD tib09
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        END INPUT
    CLOSE t9001_b_cl
END FUNCTION
 
FUNCTION t9001_gen(p_tia06,p_tia07)
    DEFINE l_sql             LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)
           p_tia06           LIKE tia_file.tia06,
           p_tia07           LIKE tia_file.tia07,
           l_bdate,l_edate   LIKE type_file.dat      #No.FUN-6A0097 DATE
 
    CALL s_azn01(g_tia01,g_tia02) RETURNING g_bdate,l_edate
    CALL s_azn01(g_tia03,g_tia04) RETURNING l_bdate,g_edate
 
    LET l_sql= "SELECT 'Y',aba02,abb01,abb02,abb04,abb07,aba06,tib09",    #No.TQC-C40069 tib09
               "  FROM aba_file,abb_file,aag_file,tib_file",              #No.TQC-C40069 add tib_file
               " WHERE aba00=abb00 AND aba01=abb01",
               "   AND aba00='",g_tia05,"' AND aag01=abb03",
               "   AND abb00 = aag00 AND aag00 = '",g_tia05,"'",     #NO.FUN-740055
               "   AND aba02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               "   AND abapost='Y' AND aag19!=1",
               "   AND abb03 = '",p_tia06,"'",
               "   AND abb06 = '",p_tia07,"'",
               "   AND aba01 IN (SELECT UNIQUE abb01 ",
               "                   FROM aba_file,abb_file,aag_file ",
               "                  WHERE aba00 = abb00 AND aba01 = abb01 ",
               "                    AND abb00 = aag00 AND aag00 ='",g_tia05,"'",   #NO.FUN-740055
               "                    AND aba00='",g_tia05,"' AND aag01=abb03 ",  #MOD-9B0022 mod
               "                    AND aba02 BETWEEN '",g_bdate,"'",
               "                    AND '",g_edate,"'",
               "                    AND abapost='Y' AND aag19=1)"
#No.TQC-C40069 --begin    
               ,"   AND aba00 = tib03 AND aba01 = tib06 ",
               "   AND abb02 = tib07 ",
               "   AND tib01 = '",g_tia01,"' AND tib02 = '",g_tia02,"'",
               "   AND tib03 = '",g_tia05,"' AND tib04 = '",p_tia06,"'",
               "   AND tib05 = '",p_tia07,"'" 
#No.TQC-C40069 --end 
    PREPARE abb_pre FROM l_sql
    IF STATUS THEN CALL cl_err('abb_pre',STATUS,0) RETURN END IF
    DECLARE abb_curs CURSOR FOR abb_pre
 
    CALL g_abb.clear()
 
    LET g_cnt3 = 1
    FOREACH abb_curs INTO g_abb[g_cnt3].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt3 = g_cnt3 + 1
      IF g_cnt3 > g_max_rec THEN
         CALL cl_err('','9035',0)
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_abb.deleteElement(g_cnt3)
    LET g_rec_b3=g_cnt3-1
 
    LET p_row = 5 LET p_col = 2
    OPEN WINDOW t900_g1 AT 6,2
         WITH FORM "ggl/42f/gglt900_g1" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("gglt900_g1")
    CALL t900g_b()
    CLOSE WINDOW t900_g1
END FUNCTION
 
FUNCTION t900g_b()
 DEFINE   l_n,l_i         LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_lock_sw       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
          l_allow_insert  LIKE type_file.num5,    #NO FUN-690009   SMALLINT       #可新增否
          l_allow_delete  LIKE type_file.num5     #NO FUN-690009   SMALLINT       #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_abb WITHOUT DEFAULTS FROM s_abb.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
      BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
 
        BEFORE ROW
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER FIELD tib09
            IF NOT cl_null(g_abb[l_ac3].tib09) THEN
               SELECT nml01 FROM nml_file WHERE nml01 = g_abb[l_ac3].tib09
               IF STATUS THEN
#                 CALL cl_err(g_abb[l_ac3].tib09,'anm-140',0)    #No.FUN-660124
                  CALL cl_err3("sel","nml_file",g_abb[l_ac3].tib09,"","anm-140","","",1)  #No.FUN-660124
                  NEXT FIELD tib09
               END IF
            END IF
 
        AFTER ROW
            LET l_ac3 = ARR_CURR()
            IF INT_FLAG THEN CALL cl_err('',9001,0) EXIT INPUT END IF
 
        ON ACTION CONTROLP
            IF INFIELD(tib09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_abb[l_ac3].tib09
               CALL cl_create_qry() RETURNING g_abb[l_ac3].tib09
      	       NEXT FIELD tib09
            END IF
 
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
     IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
     BEGIN WORK
     LET g_success = 'Y'
     DELETE FROM tib_file
      WHERE tib01=g_tia01 AND tib02=g_tia02 AND tib03=g_tia05
        AND tib04=g_tia_t.tia06 AND tib05=g_tia_t.tia07
     FOR l_i = 1 TO g_rec_b3
         IF g_abb[l_i].sel='Y' THEN
            INSERT INTO tib_file(tib01,tib02,tib03,tib04,tib05,tib06,
                                 tib07,tib08,tib09)
                          VALUES(g_tia01,g_tia02,g_tia05,g_tia_t.tia06,
                                 g_tia_t.tia07,g_abb[l_i].abb01,
                                 g_abb[l_i].abb02,g_abb[l_i].abb07,
                                 g_abb[l_i].tib09)
            IF STATUS THEN
#              CALL cl_err('ins tib',STATUS,0)    #No.FUN-660124
               CALL cl_err3("ins","tib_file",g_tia01,g_tia02,STATUS,"","ins tib",1)  #No.FUN-660124
               LET g_success = 'N' EXIT FOR
            END IF
         END IF
     END FOR
     IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t900_upd_tia081()
   DEFINE l_tib08     LIKE tib_file.tib08
 
   SELECT SUM(tib08) INTO l_tib08 FROM tib_file
    WHERE tib01 = g_tia01 AND tib02 = g_tia02 AND tib03 = g_tia05
      AND tib04 = g_tia_t.tia06
      AND tib05 = g_tia_t.tia07
      AND tib09 IS NOT NULL AND tib09 != ' '
   IF cl_null(l_tib08) THEN LET l_tib08 = 0 END IF
 
   UPDATE tia_file SET tia081 = l_tib08
    WHERE tia01 = g_tia01 AND tia02 = g_tia02 AND tia05 = g_tia05
      AND tia06 = g_tia_t.tia06 AND tia07 = g_tia_t.tia07
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('upd tia081',STATUS,0)   #No.FUN-660124
      CALL cl_err3("upd","tia_file",g_tia01,g_tia02,STATUS,"","upd tia081",1)  #No.FUN-660124
      RETURN 
   END IF
   LET g_tia[l_ac].tia081 = l_tib08
END FUNCTION
 
FUNCTION t900_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("tia01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t900_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("tia01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
FUNCTION t900g_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac3 = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac3 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #FUN-550037(smin)
      AFTER DISPLAY
        CONTINUE DISPLAY
      #END FUN-550037(smin)
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
#--NO.MOD-860078 start---
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
#--NO.MOD-860078 end------- 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900g_menu()
   WHILE TRUE
      CALL t900g_bp("G")
      CASE g_action_choice
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t900g_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Patch....NO.TQC-610037 <001,002> #
#No.TQC-980241  --Begin
FUNCTION t900_tia09(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_nmlacti  LIKE nml_file.nmlacti
 
   LET g_errno = ' '
   SELECT nmlacti INTO l_nmlacti
     FROM nml_file WHERE nml01 = g_tia[l_ac].tia09
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-140'
        WHEN l_nmlacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#No.TQC-980241  --End  
