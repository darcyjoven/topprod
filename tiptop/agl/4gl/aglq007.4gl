# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: aglq007.4gl
# Descriptions...: 合併個體合併前會計科目餘額查詢作業
# Date & Author..: 10/10/22 FUN-AA0044 BY Summer
# Modify.........: NO.FUN-AA0098 10/11/02 By yiting 畫面切分為二個頁籤，顯示aej,aek資料
# Modify.........: NO.FUN-AA0097 10/11/05 By yiting g_action_choice值要給預設
# Modify.........: NO.FUN-AB0027 10/11/09 By Summer 增加列印功能，提供二種選項列印(1.記帳幣別科餘檢核表 2.記帳幣別異動碼科餘檢核表)
# Modify.........: NO.TQC-AB0048 10/11/12 By Yiting 合併後科目相同者不要重複出現金額
# Modify.........: NO.TQC-AB0055 10/11/15 By yiting 程式中有dblink寫法CALL cl_replace_sqldb(l_sql) RETURNING l_sql解析出來無法正確,axe_file拆離
# Modify.........: NO.FUN-AB0091 11/01/27 By vealxu 跨db調整
# Modify.........: NO.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-B70103 11/08/19 By zhangweib 因為aglp000 轉入時會有關係人轉換代號的可能，所以要先回頭找agli106是否有設定轉換資料
# Modify.........: NO.FUN-BA0012 11/10/05 By belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-B90093 11/10/14 By belle 判斷aaz130是否為'2'，如果是則將axq_file 本期(axq08,axq09) 減掉上期 (axq08,axq09)(追單)
# Modify.........: NO.MOD-BC0052 11/12/07 By Sarah 若同一科目拆成2個關係人,合併前科目餘額有誤
# Modify.........: NO.MOD-B10063 13/03/05 By apo 執行後需清空 g_action_choice 變數 
# Modify.........: NO.FUN-D20043 13/02/22 By apo 增加借貸方金額合計
# Modify.........: NO.CHI-D20029 13/03/12 By apo 要依據axz10的設定來判斷取axe_file or ayf_file

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
#模組變數(Module Variables)
DEFINE tm       RECORD
                 wc       STRING,                  # Head Where condition
                 aag04    LIKE aag_file.aag04      #FUN-AA098
                END RECORD,
       g_aej1  RECORD
                 aej01   LIKE aej_file.aej01,
                 aej00   LIKE aej_file.aej00,
                 aej02   LIKE aej_file.aej02,
                 aej03   LIKE aej_file.aej03,
                 aej05   LIKE aej_file.aej05,
                 aej06   LIKE aej_file.aej06,                 
                 aej11   LIKE aej_file.aej11
                END RECORD,
       g_aej   DYNAMIC ARRAY OF RECORD
                 #--FUN-AA0098 start--
                 #aej04   LIKE aej_file.aej04,
                 #aej07   LIKE aej_file.aej07,
                 #aej08   LIKE aej_file.aej08,
                 #aah01   LIKE aah_file.aah01,
                 #aah04   LIKE aah_file.aah04,
                 #aah05   LIKE aah_file.aah05
                 aah01    LIKE aah_file.aah01,
                 aag02    LIKE aag_file.aag02,
                 aah04    LIKE aah_file.aah04,
                 aah05    LIKE aah_file.aah05,
                 amt1     LIKE type_file.num20_6,
                 aej04    LIKE aej_file.aej04,
                 aag02_1  LIKE aag_file.aag02,
                 aej07    LIKE aej_file.aej07,
                 aej08    LIKE aej_file.aej08,
                 amt2     LIKE type_file.num20_6
                 #--FUN-AA0098 end---
                END RECORD,
#--FUN-AA0098 start--
       g_aek   DYNAMIC ARRAY OF RECORD
                 aed01    LIKE aed_file.aed01,
                 aag02_2  LIKE aag_file.aag02,
                 aed011   LIKE aed_file.aed011,
                 aed02    LIKE aed_file.aed02,
                 aed05    LIKE aed_file.aed05,
                 aed06    LIKE aed_file.aed06,
                 amt3     LIKE type_file.num20_6,
                 aek04    LIKE aek_file.aek04,
                 aag02_3  LIKE aag_file.aag02,
                 aek05    LIKE aek_file.aek05,
                 aek08    LIKE aek_file.aek08,
                 aek09    LIKE aek_file.aek09,
                 amt4     LIKE type_file.num20_6
                END RECORD,
#--FUN-AA0098 end----
       g_aej_b  DYNAMIC ARRAY OF RECORD LIKE aej_file.*,
       g_aah    DYNAMIC ARRAY OF RECORD LIKE aah_file.*,
       g_aed    DYNAMIC ARRAY OF RECORD LIKE aed_file.*,   #FUN-AA0098
       g_axq    DYNAMIC ARRAY OF RECORD LIKE axq_file.*,
       g_axe04  DYNAMIC ARRAY OF LIKE axe_file.axe04,
       g_argv1            LIKE aej_file.aej00,    #INPUT ARGUMENT - 1
       g_wc,g_sql         STRING,                 #WHERE CONDITION
       p_row,p_col        LIKE type_file.num5,
       g_rec_b            LIKE type_file.num5     #單身筆數
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_cnt2             LIKE type_file.num10    #FUN-AA0098
DEFINE g_msg              LIKE ze_file.ze03
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE mi_no_ask          LIKE type_file.num5
DEFINE g_axz03            LIKE type_file.chr21
DEFINE g_dbs_gl           LIKE  azp_file.azp03
DEFINE g_rec_b2           LIKE type_file.num5     #FUN-AA0098
DEFINE g_sumaah04         LIKE type_file.num20_6   #總帳借方金額小計     #FUN-D20043
DEFINE g_sumaah05         LIKE type_file.num20_6   #總帳貸方金額小計     #FUN-D20043
DEFINE g_sumamt1          LIKE type_file.num20_6   #總帳餘額小計         #FUN-D20043
DEFINE g_sumaej07         LIKE type_file.num20_6   #合併帳借方金額小計   #FUN-D20043
DEFINE g_sumaej08         LIKE type_file.num20_6   #合併帳貸方金額小計   #FUN-D20043
DEFINE g_sumamt2          LIKE type_file.num20_6   #合併帳餘額小計       #FUN-D20043

MAIN
      DEFINE l_sl         LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q007_w AT p_row,p_col WITH FORM "agl/42f/aglq007"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL q007_menu()
   CLOSE FORM q007_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q007_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_aej.clear()
   CALL g_aek.clear()   #FUN-AA0098
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_aej1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
      aej01,aej00,aej02,aej03,aej05,aej06,aej11
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aej01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aej"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aej01
                 NEXT FIELD aej01
            WHEN INFIELD(aej11) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aej1.aej11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aej11
                 NEXT FIELD aej11
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help       
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF   #FUN-AA0097 mark
   IF INT_FLAG THEN RETURN END IF   #FUN-AA0097 add

#----FUN-AA0098 start--
   LET tm.aag04 = '1' 
   INPUT BY NAME tm.aag04 WITHOUT DEFAULTS 

      AFTER FIELD aag04 
         IF NOT cl_null(tm.aag04) THEN
            IF tm.aag04 != '1' AND tm.aag04 != '2' THEN
               NEXT FIELD aag04
            END IF 
         END IF

      ON ACTION about 
         CALL cl_about()

      ON ACTION help 
         CALL cl_show_help()

      ON ACTION controlg 
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      #No:FUN-580031 --start--     HCN 
       ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN

   END INPUT 
   IF INT_FLAG THEN RETURN END IF
#---FUN-AA0098 end----------

   LET g_sql=
       "SELECT UNIQUE aej01,aej00,aej02,aej03,aej05,aej06,aej11",
       "  FROM aej_file ",
       " WHERE ",tm.wc CLIPPED,
       " ORDER BY aej01,aej02,aej05,aej06 "   #CHI-D20029
   PREPARE q007_prepare FROM g_sql
   DECLARE q007_cs SCROLL CURSOR WITH HOLD FOR q007_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE aej01,aej00,aej02,aej03,aej05,aej06,aej11",
       "  FROM aej_file ",
       " WHERE ",tm.wc CLIPPED,
       "  INTO TEMP x"
   PREPARE q007_prepare_pre FROM g_sql
   EXECUTE q007_prepare_pre
   DECLARE q007_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q007_menu()
DEFINE   l_cmd        LIKE type_file.chr1000
   WHILE TRUE
      #CALL q007_bp("G")   #FUN-AA0098 mark
      #--FUN-AA0098 start--
      IF cl_null(g_action_choice) THEN
          CALL q007_bp("G")
      END IF
      #--FUN-AA0098 end--
      CASE g_action_choice
         
         #--FUN-AA0098 start-
         WHEN "page2"
            CALL q007_bp("G")
         
         WHEN "page3"
            CALL q007_bp2()
         #--FUN-AA0098 end---
       
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q007_q()
            END IF

         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = NULL   #MOD-B10063
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = NULL   #MOD-B10063
         #FUN-AB0027 add --start--
         WHEN "output"
            CALL q007_out()
         #FUN-AB0027 add --end--

#---FUN-AA0098 mark--
#         WHEN "exporttoexcel"
#            IF cl_chk_act_auth() THEN
#               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aej),'','')
#            END IF
#---FUN-AA0098 mark---
      END CASE
   END WHILE
END FUNCTION

FUNCTION q007_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aej.clear()
   CALL g_aek.clear()   #FUN-AA0098
   CALL q007_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_action_choice = NULL   #FUN-AA0097
      RETURN
   END IF
   OPEN q007_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q007_count
      FETCH q007_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q007_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q007_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q007_cs INTO g_aej1.aej01,g_aej1.aej00,
                                            g_aej1.aej02,g_aej1.aej03,
                                            g_aej1.aej05,g_aej1.aej06,
                                            g_aej1.aej11
       WHEN 'P' FETCH PREVIOUS q007_cs INTO g_aej1.aej01,g_aej1.aej00,
                                            g_aej1.aej02,g_aej1.aej03,
                                            g_aej1.aej05,g_aej1.aej06,
                                            g_aej1.aej11
       WHEN 'F' FETCH FIRST    q007_cs INTO g_aej1.aej01,g_aej1.aej00,
                                            g_aej1.aej02,g_aej1.aej03,
                                            g_aej1.aej05,g_aej1.aej06,
                                            g_aej1.aej11
       WHEN 'L' FETCH LAST     q007_cs INTO g_aej1.aej01,g_aej1.aej00,
                                            g_aej1.aej02,g_aej1.aej03,
                                            g_aej1.aej05,g_aej1.aej06,
                                            g_aej1.aej11
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
 
                 ON ACTION about        
                    CALL cl_about()    
 
                 ON ACTION help       
                    CALL cl_show_help()  
 
                 ON ACTION controlg     
                    CALL cl_cmdask()   
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump q007_cs INTO g_aej1.aej01,g_aej1.aej00,
                                              g_aej1.aej02,g_aej1.aej03,
                                              g_aej1.aej05,g_aej1.aej06,
                                              g_aej1.aej11
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aej1.aej02,SQLCA.sqlcode,0)
       INITIALIZE g_aej1.* TO NULL
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       DISPLAY g_curs_index TO FORMONLY.idx
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    CALL q007_show()
END FUNCTION

FUNCTION q007_show()
   DEFINE l_aag02   LIKE aag_file.aag02

   DISPLAY BY NAME g_aej1.aej01,g_aej1.aej00,
                   g_aej1.aej02,g_aej1.aej03,
                   g_aej1.aej05,g_aej1.aej06,
                   g_aej1.aej11

   CALL q007_b_fill() #單身
   CALL q007_b_fill_2()   #FUN-AA0098
   LET g_action_choice = "page2"   #FUN-AA0098
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q007_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_sql2    STRING
   DEFINE l_sql3    STRING
   DEFINE l_sql4    STRING
   DEFINE l_axz04   LIKE axz_file.axz04
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_cnt2    LIKE type_file.num10
   DEFINE l_cnt3    LIKE type_file.num10
   DEFINE l_cnt4    LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_aah01   STRING   #FUN-AA0098
   DEFINE i         LIKE type_file.num5   #TQC-AB0048
   DEFINE l_cnt     LIKE type_file.num5   #TQC-AB0055 
DEFINE l_month       LIKE axq_file.axq07   #FUN-B90093
DEFINE l_axq08       LIKE axq_file.axq08   #FUN-B90093
DEFINE l_axq09       LIKE axq_file.axq09   #FUN-B90093
DEFINE l_axz10   LIKE axz_file.axz10   #CHI-D20029 
DEFINE l_aeh02   LIKE aeh_file.aeh02   #CHI-D20029 
DEFINE l_ayf10   LIKE ayf_file.ayf10   #CHI-D20029
DEFINE l_ayf11   LIKE ayf_file.ayf11   #CHI-D20029

   #依輸入合併個體取資料庫代碼
   SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01 = g_aej1.aej02
   SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_axz03
   IF STATUS THEN
      LET g_dbs_new = NULL
   END IF
   LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)
   
#--FUN-AA0098 mark---
#   LET l_sql = "SELECT  * FROM aej_file",
#               " WHERE aej01 = '",g_aej1.aej01,"'",
#               "   AND aej00 = '",g_aej1.aej00,"' AND aej02 = '",g_aej1.aej02,"'",
#               "   AND aej03 = '",g_aej1.aej03,"' AND aej05 =  ",g_aej1.aej05,
#               "   AND aej06 = ",g_aej1.aej06,"   AND aej11 = '",g_aej1.aej11,"'"
#   PREPARE q007_pb FROM l_sql
#   DECLARE q007_bcs CURSOR FOR q007_pb          #BODY CURSOR
#   
#   LET l_sql2 = "SELECT axe04 FROM axe_file ",
#                " WHERE axe13 = ?",
#                "   AND axe00 = ?", 
#                "   AND axe01 = ?", 
#               "   AND axe06 = ?"
#   PREPARE q007_pb2 FROM l_sql2
#   DECLARE q007_bcs2 CURSOR FOR q007_pb2          #BODY CURSOR    
#      
#  LET l_sql3 = " SELECT * FROM ",g_dbs_gl,"aah_file ",
#                " WHERE aah00 = ?",
#                "   AND aah01 = ?", 
#                "   AND aah02 = ?",
#                "   AND aah03 = ?"
#   CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3                
#   PREPARE q007_pb3 FROM l_sql3
#   DECLARE q007_bcs3 CURSOR FOR q007_pb3          #BODY CURSOR
#   
#   LET l_sql4 = " SELECT * FROM axq_file ",
#                "  WHERE axq01 = ?", 
#                "    AND axq04 = ?", 
#                "    AND axq041 = ?", 
#                "    AND axq05 = ?", 
#                "    AND axq06 = ?", 
#                "    AND axq07 = ?",
#                "    AND axq12 = ?"
#   PREPARE q007_pb4 FROM l_sql4
#   DECLARE q007_bcs4 CURSOR FOR q007_pb4          #BODY CURSOR
#---FUN-AA0098 mark---------------------
   
   CALL g_aej.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   LET l_cnt1 = 1

#-----------------FUN-AA0098 mark------------------------
#   #1.依aej_file內資料跑迴圈，將每筆資料FOREACH依序抓取資料
#   FOREACH q007_bcs INTO g_aej_b[l_cnt1].*
#      #2.依axe_file取出合併前科目
#      LET l_cnt2 = 1
#      FOREACH q007_bcs2 USING g_aej_b[l_cnt1].aej01,
#                              g_aej_b[l_cnt1].aej03,
#                              g_aej_b[l_cnt1].aej02,
#                              g_aej_b[l_cnt1].aej04 
#         INTO g_axe04[l_cnt2]
#         #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT axq_file (公司科目餘額暫存資料(非TIPTOP公司))
#         SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01= g_aej_b[l_cnt1].aej02
#         IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
#            #4.依取出的合併前科目迴圈，取aah_file(需依照axz_file指定的營運中心SQL要寫跨db寫法)
#            LET l_cnt3 = 1
#            LET l_flag = 'N'
#            FOREACH q007_bcs3 USING g_aej_b[l_cnt1].aej03,g_axe04[l_cnt2],g_aej_b[l_cnt1].aej05,g_aej_b[l_cnt1].aej06 INTO g_aah[l_cnt3].*
#               #將aej_file,aah_file資料塞到ARRAY
#               IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
#                  CALL cl_err('',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               IF l_cnt2 = 1 or l_flag ='N' THEN
#                  LET g_aej[g_cnt].aej04=g_aej_b[l_cnt1].aej04
#                  LET g_aej[g_cnt].aej07=g_aej_b[l_cnt1].aej07
#                  LET g_aej[g_cnt].aej08=g_aej_b[l_cnt1].aej08
#                  LET l_flag = 'Y'
#               ELSE
#                  LET g_aej[g_cnt].aej04=''
#                  LET g_aej[g_cnt].aej07=''
#                  LET g_aej[g_cnt].aej08=''
#               END IF
#               LET g_aej[g_cnt].aah01=g_aah[l_cnt3].aah01
#               LET g_aej[g_cnt].aah04=g_aah[l_cnt3].aah04
#               LET g_aej[g_cnt].aah05=g_aah[l_cnt3].aah05
#               LET g_cnt = g_cnt+1
#               LET l_cnt3 = l_cnt3+1
#            END FOREACH
#         ELSE #(非TIPTOP)
#            LET l_cnt4 = 1
#            LET l_flag = 'N'
#            FOREACH q007_bcs4 USING g_aej_b[l_cnt1].aej01,g_aej_b[l_cnt1].aej02,g_aej_b[l_cnt1].aej03,g_axe04[l_cnt2],g_aej_b[l_cnt1].aej05,g_aej_b[l_cnt1].aej06,g_aej_b[l_cnt1].aej11 INTO g_axq[l_cnt4].*
#               #將aej_file,axq_file資料塞到ARRAY
#               IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
#                  CALL cl_err('',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               IF l_cnt2 = 1 or l_flag ='N' THEN
#                  LET g_aej[g_cnt].aej04=g_aej_b[l_cnt1].aej04
#                  LET g_aej[g_cnt].aej07=g_aej_b[l_cnt1].aej07
#                  LET g_aej[g_cnt].aej08=g_aej_b[l_cnt1].aej08
#                  LET l_flag = 'Y'
#               ELSE
#                  LET g_aej[g_cnt].aej04=''
#                  LET g_aej[g_cnt].aej07=''
#                  LET g_aej[g_cnt].aej08=''
#               END IF
#               LET g_aej[g_cnt].aah01=g_axq[l_cnt4].axq05
#               LET g_aej[g_cnt].aah04=g_axq[l_cnt4].axq08
#               LET g_aej[g_cnt].aah05=g_axq[l_cnt4].axq09
#               LET g_cnt = g_cnt+1
#               LET l_cnt4 = l_cnt4+1
#            END FOREACH
#         END IF
#         LET l_cnt2 = l_cnt2+1
#      END FOREACH
#      LET l_cnt1 = l_cnt1+1
#-----------------FUN-AA0098 mark------------------------

   CALL q007_create_temp_table()   #FUN-D20043    
#-----------------FUN-AA0098 start-------------------------
   #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT axq_file (公司科目餘額暫存資料(非TIPTOP公司))
   #SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01= g_aej1.aej02                 #CHI-D20029 mark
   SELECT axz04,axz10 INTO l_axz04,l_axz10 FROM axz_file WHERE axz01= g_aej1.aej02    #CHI-D20029
   
   #--CHI-D20029 start--
   IF l_axz10 = 'Y' THEN
       SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
         FROM ayf_file    
        WHERE ayf01 = g_aej1.aej02
          AND ayf09 = g_aej1.aej01
          AND ayf10 = g_aej1.aej05
          AND ayf11 = g_aej1.aej06
       IF STATUS  THEN
           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
             FROM ayf_file    
            WHERE ayf01 = g_aej1.aej02
              AND ayf09 = g_aej1.aej01
       END IF
   END IF
   #--CHI-D20029 end--

   IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
       IF l_axz10 = 'N' OR cl_null(l_axz10)  THEN                                         #CHI-D20029 add
      #LET l_sql = "SELECT UNIQUE aah01,aag02,aah04,aah05,(aah04-aah05)",                 #CHI-D20029 mark
       LET l_sql = "SELECT UNIQUE '',aah01,aag02,aah04,aah05,(aah04-aah05)",              #CHI-D20029 add  
#                  " FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",",axe_file",        #TQC-AB0055 mark
                 # " FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055 mod    #FUN-AB0091
                   " FROM ",cl_get_target_table(g_axz03,'aah_file'),",",    #FUN-AB0091
                            cl_get_target_table(g_axz03,'aag_file'),        #FUN-AB0091 
                   " WHERE aag00 = aah00 ",
                   "   AND aag01 = aah01 ",
                   "   AND aag04 = '",tm.aag04,"'",
                   "   AND aah00 = '",g_aej1.aej03,"'",
                   "   AND aag07 IN ('2','3')  ",      #CHI-D20029 ADD
                   "   AND aag09 = 'Y' ",              #CHI-D20029 ADD
                   "   AND aah02 = '",g_aej1.aej05,"'",
                   "   AND aah03 = '",g_aej1.aej06,"'",
#                   "   AND aah01 = axe04 ",               #TQC-AB0055  mark
#                   "   AND axe13 = '",g_aej1.aej01,"'",   #TQC-AB0055  mark
#                   "   AND axe01 = '",g_aej1.aej02,"'",   #TQC-AB0055  mark
                   "   AND aag00 = aah00 ",
                   "   AND aag01 = aah01 ",
                   "  ORDER BY aah01 "
       #---CHI-D20029 add start----------------
       ELSE   
           LET l_sql=" SELECT UNIQUE aeh02,aeh01,aag02,aeh11,aeh12,(aeh11-aeh12)",  
                     "   FROM ",cl_get_target_table(g_axz03,'aeh_file'),",", 
                                cl_get_target_table(g_axz03,'aag_file'),    
                     " WHERE aeh01 = aag01 ",
                     "   AND aeh00 = aag00 ",
                     "   AND aag07 IN ('2','3')  ",      #CHI-D20029 ADD
                     "   AND aag09 = 'Y' ",              #CHI-D20029 ADD
                     "   AND aag04 = '",tm.aag04,"'",
                     "   AND aeh00 = '",g_aej1.aej03,"'",
                     "   AND aeh09 = '",g_aej1.aej05,"'",
                     "   AND aeh10 = '",g_aej1.aej06,"'",
                     " GROUP BY aeh01,aeh02,aeh09,aeh10,aag02,aeh11,aeh12 ",
                     " ORDER BY aeh01"
       END IF
       #---CHI-D20029 add end-------------------
   ELSE
      #LET l_sql = " SELECT axq05,axq051,axq08,axq09,(axq08-axq09)",               #MOD-BC0052 mark
      #LET l_sql = " SELECT axq05,axq051,SUM(axq08),SUM(axq09),SUM(axq08-axq09)",  #MOD-BC0052         #CHI-D20029 MARK
       LET l_sql = " SELECT axq29,axq05,axq051,SUM(axq08),SUM(axq09),SUM(axq08-axq09)",  #MOD-BC0052   #CHI-D20029 
                    " FROM axq_file ",
                    "  WHERE axq01 = '",g_aej1.aej01,"'", 
                    "    AND axq04 = '",g_aej1.aej02,"'", 
                    "    AND axq041 ='",g_aej1.aej03,"'", 
                    "    AND axq06 = '",g_aej1.aej05,"'", 
                    "    AND axq07 = '",g_aej1.aej06,"'",
                    "    AND axq12 = '",g_aej1.aej11,"'",
                    #" GROUP BY axq05,axq051 ",                                     #MOD-BC0052 add    #CHI-D20029 mark
                    " GROUP BY axq29,axq05,axq051 ",                                #MOD-BC0052 add    #CHI-D20029 
                    " ORDER BY axq05 "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_axz03) RETURNING l_sql    #FUN-AB0091
   PREPARE q007_aej_p FROM l_sql
   DECLARE q007_aej_c CURSOR FOR q007_aej_p          #BODY CURSOR
   #FOREACH q007_aej_c INTO g_aej[g_cnt].*           #CHI-D20029 mark
   FOREACH q007_aej_c INTO l_aeh02,g_aej[g_cnt].*    #CHI-D20029 
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
          #--TQC-AB0055 start--
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM axe_file
               WHERE axe04= g_aej[g_cnt].aah01
                 AND axe13 =g_aej1.aej01
                 AND axe01 =g_aej1.aej02
              IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          #---CHI-D20029 start- 
          ELSE
              LET l_cnt = 0
              IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                   SELECT COUNT(*) INTO l_cnt
                     FROM ayf_file    
                    WHERE ayf01 = g_aej1.aej02
	              AND ayf04 = g_aej[g_cnt].aah01
                      AND ayf09 = g_aej1.aej01
                      AND ayf02 = ' '
                      AND ayf03 = ' '
                      AND ayf10 = l_ayf10
                      AND ayf11 = l_ayf11
              ELSE
                   SELECT COUNT(*) INTO l_cnt
                     FROM ayf_file    
                    WHERE ayf01 = g_aej1.aej02
	              AND ayf04 = g_aej[g_cnt].aah01
                      AND ayf09 = g_aej1.aej01
                      AND (ayf02 <= l_aeh02 AND ayf03 >= l_aeh02)
                      AND ayf10 = l_ayf10
                      AND ayf11 = l_ayf11
              END IF        
              IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          END IF 
          #--CHI-D20029 end-----
          #--TQC-AB0055 end---
          IF l_axz04 = 'N' THEN 
              LET l_aah01 = g_aej[g_cnt].aah01
              IF tm.aag04 = '1' THEN   #B/S
                  IF l_aah01.substring(1,1) > 3 THEN
                      CONTINUE FOREACH
                  END IF
              ELSE
                  IF l_aah01.substring(1,1) < 4 THEN
                      CONTINUE FOREACH
                  END IF
              END IF
         #END IF     #CHI-D20029 MARK
            #--FUN-B90093 start-- 
            IF g_aaz.aaz130 = '2' THEN
                LET l_month = 0
                LET l_axq08 = 0
                LET l_axq09 = 0
                SELECT MAX(axq07) INTO l_month
                  FROM axq_file
                 WHERE axq01 = g_aej1.aej01 
                   AND axq04 = g_aej1.aej02 
                   AND axq041 =g_aej1.aej03 
                   AND axq06 = g_aej1.aej05
                   AND axq07 < g_aej1.aej06
                   AND axq12 = g_aej1.aej11
                IF l_month <> 0 THEN
                   #SELECT axq08,axq09            #MOD-BC0052 mark
                    SELECT SUM(axq08),SUM(axq09)  #MOD-BC0052
                      INTO l_axq08,l_axq09
                      FROM axq_file
                     WHERE axq01 = g_aej1.aej01 
                       AND axq04 = g_aej1.aej02 
                       AND axq041 =g_aej1.aej03 
                       AND axq06 = g_aej1.aej05
                       AND axq07 = l_month
                       AND axq12 = g_aej1.aej11
                       AND axq05 = g_aej[g_cnt].aah01
                    LET g_aej[g_cnt].aah04 = g_aej[g_cnt].aah04 - l_axq08
                    LET g_aej[g_cnt].aah05 = g_aej[g_cnt].aah05 - l_axq09
                    LET g_aej[g_cnt].amt1 = g_aej[g_cnt].amt1 -  (l_axq08 - l_axq09)
                END IF
          END IF
          #--FUN-B90093 end----
       END IF           #CHI-D20029  add
          IF NOT cl_null(g_aej[g_cnt].aah01) THEN
             IF l_axz10 = 'N' OR cl_null(l_axz10) THEN            #CHI-D20029 add
                 LET l_sql =  "SELECT aej04,aag02,aej07,aej08,(aej07-aej08)",
                              "  FROM aej_file,aag_file,axe_file ",
                              " WHERE aag00 = aej00 ",
                              "   AND aag01 = aej04 ",
                              "   AND axe13 = '",g_aej1.aej01,"'",
                              "   AND axe01 = '",g_aej1.aej02,"'",
                              "   AND axe04 = '",g_aej[g_cnt].aah01,"'",
                              "   AND axe06 = aej04",
                              "   AND axe13 = aej01",
                              "   AND aej00 = '",g_aej1.aej00,"'",
                              "   AND axe01 = aej02",
                              "   AND aej03 = '",g_aej1.aej03,"'",
                              "   AND aej05 = '",g_aej1.aej05,"'",
                              "   AND aej06 = '",g_aej1.aej06,"'"
             #---CHI-D20029 start---
             ELSE
                 LET l_sql =  "SELECT aej04,aag02,aej07,aej08,(aej07-aej08)",
                              "  FROM aej_file,aag_file,ayf_file ",  
                              " WHERE aag00 = aej00 ",
                              "   AND aag01 = aej04 ",
                              "   AND ayf09 = '",g_aej1.aej01,"'",
                              "   AND ayf01 = '",g_aej1.aej02,"'",
                              "   AND ayf04 = '",g_aej[g_cnt].aah01,"'",
                              "   AND ayf06 = aej04",
                              "   AND ayf09 = aej01",
                              "   AND aej00 = '",g_aej1.aej00,"'",
                              "   AND ayf01 = aej02",     
                              "   AND aej03 = '",g_aej1.aej03,"'",
                              "   AND aej05 = '",g_aej1.aej05,"'",
                              "   AND aej06 = '",g_aej1.aej06,"'",
                              "   AND ayf10 = '",l_ayf10,"'",
                              "   AND ayf11 = '",l_ayf11,"'" 
                 IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                     LET l_sql = l_sql CLIPPED,
                                 "  AND ayf02 = ' ' ",
                                 "  AND ayf03 = ' ' "
                 ELSE
                     LET l_sql = l_sql CLIPPED, " AND (ayf02 <= '",l_aeh02,"' AND ayf03 >= '",l_aeh02,"') "
                 END IF
             END IF 
             #---CHI-D20029 end---

             PREPARE q007_aej_p2 FROM l_sql
             DECLARE q007_aej_c2 CURSOR FOR q007_aej_p2          #BODY CURSOR
             FOREACH q007_aej_c2 INTO g_aej[g_cnt].aej04,
                                      g_aej[g_cnt].aag02_1,
                                      g_aej[g_cnt].aej07,
                                      g_aej[g_cnt].aej08,
                                      g_aej[g_cnt].amt2
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
       END IF
       IF g_cnt > 1 THEN
           FOR i = 1 TO g_cnt - 1
               IF g_aej[g_cnt].aej04 = g_aej[i].aej04 THEN          #TQC-AB0048
          #    IF g_aej[g_cnt].aej04 = g_aej[g_cnt-1].aej04 THEN    #TQC-AB0048 mark
                   LET g_aej[g_cnt].aej04 = ''
                   LET g_aej[g_cnt].aag02_1 = ''
                   LET g_aej[g_cnt].aej07 = ''
                   LET g_aej[g_cnt].aej08 = ''
                   LET g_aej[g_cnt].amt2 = ''
               END IF   #TQC-AB0048
           END FOR
       END IF
      #FUN-D20043--
       INSERT INTO q007_sum_tmp VALUES
         (g_aej[g_cnt].aah04,g_aej[g_cnt].aah05,g_aej[g_cnt].amt1,g_aej[g_cnt].aej07,g_aej[g_cnt].aej08,g_aej[g_cnt].amt2)
      #FUN-D20043--
       LET g_cnt = g_cnt + 1
       #--------FUN-AA0098 end-----------------------
   END FOREACH
   CALL g_aej.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
  #FUN-D20043--
   SELECT SUM(aah04),SUM(aah05),SUM(amt1),SUM(aej07),SUM(aej08),SUM(amt2)
    INTO g_sumaah04,g_sumaah05,g_sumamt1,g_sumaej07,g_sumaej08,g_sumamt2 FROM q007_sum_tmp

   IF cl_null(g_sumaah04) THEN LET g_sumaah04 = 0 END IF
   IF cl_null(g_sumaah05) THEN LET g_sumaah05 = 0 END IF
   IF cl_null(g_sumamt1) THEN LET g_sumamt1 = 0 END IF
   IF cl_null(g_sumaej07) THEN LET g_sumaej07 = 0 END IF
   IF cl_null(g_sumaej08) THEN LET g_sumaej08 = 0 END IF
   IF cl_null(g_sumamt2) THEN LET g_sumamt2 = 0 END IF

   DISPLAY g_sumaah04 TO FORMONLY.sumaah04
   DISPLAY g_sumaah05 TO FORMONLY.sumaah05
   DISPLAY g_sumamt1 TO FORMONLY.sumamt1
   DISPLAY g_sumaej07 TO FORMONLY.sumaej07
   DISPLAY g_sumaej08 TO FORMONLY.sumaej08
   DISPLAY g_sumamt2 TO FORMONLY.sumamt2
  #FUN-D20043--
   DISPLAY g_rec_b TO FORMONLY.cn2
   
END FUNCTION

#----FUN-AA0098 start--
FUNCTION q007_b_fill_2()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_sql2    STRING
   DEFINE l_sql3    STRING
   DEFINE l_sql4    STRING
   DEFINE l_axz04   LIKE axz_file.axz04
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_cnt2    LIKE type_file.num10
   DEFINE l_cnt3    LIKE type_file.num10
   DEFINE l_cnt4    LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_aed01   STRING
   DEFINE l_cnt     LIKE type_file.num5   #TQC-AB0055
   DEFINE l_aal03   LIKE aal_file.aal03   #FUN-B70103
   DEFINE l_aed02   LIKE aed_file.aed02   #FUN-B70103
   DEFINE l_axz10   LIKE axz_file.axz10   #CHI-D20029 
   DEFINE l_aeh02   LIKE aeh_file.aeh02   #CHI-D20029 
   DEFINE l_aed03   LIKE aed_file.aed03   #CHI-D20029
   DEFINE l_aed04   LIKE aed_file.aed04   #CHI-D20029 
   DEFINE l_ayf10   LIKE ayf_file.ayf10   #CHI-D20029
   DEFINE l_ayf11   LIKE ayf_file.ayf11   #CHI-D20029

   #依輸入合併個體取資料庫代碼
   SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01 = g_aej1.aej02
   SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_axz03
   IF STATUS THEN
      LET g_dbs_new = NULL
   END IF
   LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)
   
   CALL g_aek.clear()

   LET g_rec_b2=0
   LET g_cnt = 1

   #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT axq_file (公司科目餘額暫存資料(非TIPTOP公司))
   #SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01= g_aej1.aej02                #CHI-D20029 mark
   SELECT axz04,axz10 INTO l_axz04,l_axz10 FROM axz_file WHERE axz01= g_aej1.aej02   #CHI-D20029 mod
   #--CHI-D20029 start--
   IF l_axz10 = 'Y' THEN
       SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
         FROM ayf_file    
        WHERE ayf01 = g_aej1.aej02
          AND ayf09 = g_aej1.aej01
          AND ayf10 = g_aej1.aej05
          AND ayf11 = g_aej1.aej06
       IF STATUS  THEN
           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
             FROM ayf_file    
            WHERE ayf01 = g_aej1.aej02
              AND ayf09 = g_aej1.aej01
       END IF
   END IF
   #--CHI-D20029 end--
   IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
       IF l_axz10 = 'N' OR cl_null(l_axz10)  THEN                                         #CHI-D20029 add
           #LET l_sql = "SELECT UNIQUE aed01,aag02,aed011,aed02,aed05,",                  #CHI-D20029 mark
           LET l_sql = "SELECT UNIQUE '',aed01,aag02,aed011,aed02,aed05,",                #CHI-D20029 
                   "              aed06,(aed05-aed06)",
       #            "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",",axe_file",  #TQC-AB0055 mark
       #          "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055  #FUN-AB0091 mark
                  "  FROM ",cl_get_target_table(g_axz03,'aed_file'),",",              #FUN-AB0091 
                            cl_get_target_table(g_axz03,'aag_file'),                  #FUN-AB0091  
                  " WHERE aag00 =aed00 ",
                  "   AND aag01 =aed01 ",
                  "   AND aag04 = '",tm.aag04,"'",
                  "   AND aed00 = '",g_aej1.aej03,"'",
                  "   AND aed03 = '",g_aej1.aej05,"'",
                  "   AND aed04 = '",g_aej1.aej06,"'",
#                  "   AND aed01 = axe04 ",              #TQC-AB0055 mark
#                  "   AND axe13 = '",g_aej1.aej01,"'",  #TQC-AB0055 mark
#                  "   AND axe01 = '",g_aej1.aej02,"'",  #TQC-AB0055 mark
                  "   AND aed011 = '99'",
                  "  ORDER BY aed01 "
       #---CHI-D20029 START--
       ELSE
           LET l_sql=" SELECT UNIQUE aeh02,aeh01,aag02,'99',aeh37,aeh11,aeh12,(aeh11-aeh12) ",  
                     "   FROM ",cl_get_target_table(g_axz03,'aeh_file'),",", 
                                cl_get_target_table(g_axz03,'aag_file'),    
                     " WHERE aeh01 = aag01 ",
                     "   AND aeh00 = aag00 ",
                     "   AND aag04 = '",tm.aag04,"'",
                     "   AND aag07 IN ('2','3')  ",    
                     "   AND aag09 = 'Y' ",             
                     "   AND aeh00 = '",g_aej1.aej03,"'",
                     "   AND aeh09 = '",g_aej1.aej05,"'",
                     "   AND aeh10 = '",g_aej1.aej06,"'",
                     "   AND aeh37 <> ' '",      
                     "   AND aeh37 IS NOT NULL ", 
                     " GROUP BY aeh01,aeh02,aag02,aeh37,aeh11,aeh12 ",
                     " ORDER BY aeh01"
       END IF  
       #----CHI-D20029 end---------
   ELSE
       #LET l_sql = " SELECT axq05,axq051,'99',axq13,axq08,axq09,(axq08-axq09)",        #CHI-D20029 mark
       LET l_sql = " SELECT axq29,axq05,axq051,'99',axq13,axq08,axq09,(axq08-axq09)",   #CHI-D20029 
                    " FROM axq_file ",
                    "  WHERE axq01 = '",g_aej1.aej01,"'", 
                    "    AND axq04 = '",g_aej1.aej02,"'", 
                    "    AND axq041 ='",g_aej1.aej03,"'", 
                    "    AND axq06 = '",g_aej1.aej05,"'", 
                    "    AND axq07 = '",g_aej1.aej06,"'",
                    "    AND axq12 = '",g_aej1.aej11,"'",
                    "    AND (axq13 IS NOT NULL AND axq13 <> ' ')",
                    " ORDER BY axq05 "
   END IF

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_axz03) RETURNING l_sql   #FUN-AB0091 
   PREPARE q007_aed_p FROM l_sql
   DECLARE q007_aed_c CURSOR FOR q007_aed_p          #BODY CURSOR
   #FOREACH q007_aed_c INTO g_aek[g_cnt].*           #CHI-D20029 mark
   FOREACH q007_aed_c INTO l_aeh02,g_aek[g_cnt].*    #CHI-D20029 
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
           IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
           #--TQC-AB0055 start--
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM axe_file
            WHERE axe04= g_aek[g_cnt].aed01
              AND axe13 =g_aej1.aej01
              AND axe01 =g_aej1.aej02
           IF l_cnt = 0 THEN CONTINUE FOREACH END IF
           #--TQC-AB0055 end---
           #---CHI-D20029 start- 
           ELSE
               LET l_cnt = 0
               IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                    SELECT COUNT(*) INTO l_cnt
                      FROM ayf_file    
                     WHERE ayf01 = g_aej1.aej02
	               AND ayf04 = g_aek[g_cnt].aed01
                       AND ayf09 = g_aej1.aej01
                       AND ayf02 = ' '
                       AND ayf03 = ' '
                       AND ayf10 = l_ayf10
                       AND ayf11 = l_ayf11
               ELSE
                    SELECT COUNT(*) INTO l_cnt
                      FROM ayf_file    
                     WHERE ayf01 = g_aej1.aej02
	               AND ayf04 = g_aek[g_cnt].aed01
                       AND ayf09 = g_aej1.aej01
                       AND (ayf02 <= l_aeh02 AND ayf03 >= l_aeh02)
                       AND ayf10 = l_ayf10
                       AND ayf11 = l_ayf11
               END IF        
           END IF 
           #---CHI-D20029 end--------------------------
           IF l_axz04 = 'N' THEN 
               LET l_aed01 = g_aek[g_cnt].aed01
               IF tm.aag04 = '1' THEN   #B/S
                   IF l_aed01.substring(1,1) > 3 THEN
                       CONTINUE FOREACH
                   END IF
               ELSE
                   IF l_aed01.substring(1,1) < 4 THEN
                       CONTINUE FOREACH
                   END IF
               END IF
           END IF
        #---FUN-B70103 start--
           LET l_aal03 = NULL
           SELECT aal03 INTO l_aal03  
             FROM aal_file
            WHERE aal01 = g_aej1.aej02
              AND aal02 = g_aek[g_cnt].aed02
           IF NOT cl_null(l_aal03) THEN 
               LET l_aed02 = l_aal03 
           ELSE                     
               LET l_aed02 = g_aek[g_cnt].aed02 
           END IF                   
        #--FUN-B70103 end---
           IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
           LET l_sql =  "SELECT aek04,aag02,aek05,aek08,aek09,(aek08-aek09)",
                        "  FROM aek_file,aag_file,axe_file ",
                        " WHERE aag00 = aek00 ",
                        "   AND aag01 = aek04 ",
                        "   AND axe13 = '",g_aej1.aej01,"'",
                        "   AND axe01 = '",g_aej1.aej02,"'",
                        "   AND axe04 = '",g_aek[g_cnt].aed01,"'",
                        "   AND axe06 = aek04",
                        "   AND axe13 = aek01",
                        "   AND aek00 = '",g_aej1.aej00,"'",
                        "   AND axe01 = aek02",
                       #"   AND aek05 = '",g_aek[g_cnt].aed02,"'",   #FUN-B70103   Mark
                        "   AND aek05 = '",l_aed02,"'",   #FUN-B70103 add
                        "   AND aek03 = '",g_aej1.aej03,"'",
                        "   AND aek06 = '",g_aej1.aej05,"'",
                        "   AND aek07 = '",g_aej1.aej06,"'"
           #---CHI-D20029 start--
           ELSE
               LET l_sql =  "SELECT aek04,aag02,aek05,aek08,aek09,(aek08-aek09)",
                            "  FROM aek_file,aag_file,ayf_file ", 
                            " WHERE aag00 = aek00 ",
                            "   AND aag01 = aek04 ",
                            "   AND ayf09 = '",g_aej1.aej01,"'",
                            "   AND ayf01 = '",g_aej1.aej02,"'",
                            "   AND ayf04 = '",g_aek[g_cnt].aed01,"'",
                            "   AND ayf06 = aek04",
                            "   AND ayf09 = aek01",
                            "   AND aek00 = '",g_aej1.aej00,"'",
                            "   AND ayf01 = aek02",                
                            "   AND aek05 = '",l_aed02,"'",   
                            "   AND aek03 = '",g_aej1.aej03,"'",
                            "   AND aek06 = '",g_aej1.aej05,"'",
                            "   AND aek07 = '",g_aej1.aej06,"'",
                            "   AND ayf10 = '",l_ayf10,"'",
                            "   AND ayf11 = '",l_ayf11,"'" 
               IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                   LET l_sql = l_sql CLIPPED,
                               "  AND ayf02 = ' ' ",
                               "  AND ayf03 = ' ' "
               ELSE
                   LET l_sql = l_sql CLIPPED, " AND (ayf02 <= '",l_aeh02,"' AND ayf03 >= '",l_aeh02,"') "
               END IF
           END IF
           #---CHI-D20029 end---
           PREPARE q007_aek_p2 FROM l_sql
           DECLARE q007_aek_c2 CURSOR FOR q007_aek_p2          #BODY CURSOR
           FOREACH q007_aek_c2 INTO g_aek[g_cnt].aek04,
                                    g_aek[g_cnt].aag02_3,
                                    g_aek[g_cnt].aek05,
                                    g_aek[g_cnt].aek08,
                                    g_aek[g_cnt].aek09,
                                    g_aek[g_cnt].amt4
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
           END FOREACH
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_aek.deleteElement(g_cnt)
   LET g_rec_b2= g_cnt -1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
END FUNCTION

FUNCTION q007_bp2_refresh()

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aek TO s_aek.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
   END DISPLAY

END FUNCTION
#---FUN-AA0098 end------------------

FUNCTION q007_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aej TO s_aej.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()

      ON ACTION page3              #FUN-AA0098
         LET g_action_choice="page3"  #FUN-AA0098 
         EXIT DISPLAY                 #FUN-AA0098 

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q007_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q007_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q007_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q007_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q007_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
      
      #FUN-AB0027 add --start--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-AB0027 add --end--
 
#--FUN-AA0098 mark-- 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#--FUN-AA0098 mark--

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q007_bp2()

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aek TO s_aek.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      ON ACTION page2
         LET g_action_choice="page2"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q007_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q007_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q007_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q007_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q007_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      #FUN-AB0027 add --start--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-AB0027 add --end--

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#--FUN-AA0098 end---

#FUN-AB0027 add --start--
FUNCTION q007_out()

    IF g_aej1.aej01 IS NULL THEN
       LET g_action_choice = " "
       RETURN 
    END IF

    CLOSE WINDOW screen

    CALL cl_set_act_visible("accept,cancel", TRUE)
    MENU "" #ATTRIBUTE(STYLE="popup")

       ON ACTION print_aglr015
          LET g_msg = "aglr015",
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_aej1.aej01,"' '",g_aej1.aej02,"' '",g_aej1.aej03,"' ", 
                      " '",g_aej1.aej05,"' '",g_aej1.aej06,"' '1'" 
          CALL cl_cmdrun(g_msg)

       ON ACTION print_aglr015_1
          LET g_msg = "aglr015",
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_aej1.aej01,"' '",g_aej1.aej02,"' '",g_aej1.aej03,"' ", 
                      " '",g_aej1.aej05,"' '",g_aej1.aej06,"' '2'" 
          CALL cl_cmdrun(g_msg)

       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice = " "
          EXIT MENU

       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CALL cl_set_act_visible("accept,cancel", FALSE)

END FUNCTION
#FUN-AB0027 add --end--
#FUN-AA0044 --------------add end-------------

#FUN-D20043--str
FUNCTION q007_create_temp_table()
   DROP TABLE q007_sum_tmp
   CREATE TEMP TABLE q007_sum_tmp(
   aah04    LIKE aah_file.aah04,
   aah05    LIKE aah_file.aah05,  
   amt1     LIKE type_file.num20_6,
   aej07    LIKE aej_file.aej07, 
   aej08    LIKE aej_file.aej08,
   amt2     LIKE type_file.num20_6)
END FUNCTION
#FUN-D20043--end
