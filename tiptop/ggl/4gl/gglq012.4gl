# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: gglq012.4gl
# Descriptions...: 合併個體合併前會計科目餘額查詢作業
# Date & Author..: 10/10/22 FUN-AA0044 BY Summer
# Modify.........: NO.FUN-AA0098 10/11/02 BY yiting 畫面切分為二個頁籤，顯示asm,asn資料
# Modify.........: NO.FUN-AA0097 10/11/05 BY yiting g_action_choice值要給預設
# Modify.........: NO.FUN-AB0027 10/11/09 BY Summer 增加列印功能，提供二種選項列印(1.記帳幣別科餘檢核表 2.記帳幣別異動碼科餘檢核表)
# Modify.........: NO.TQC-AB0048 10/11/12 by Yiting 合併後科目相同者不要重複出現金額
# Modify.........: NO.TQC-AB0055 10/11/15 BY yiting 程式中有dblink寫法CALL cl_replace_sqldb(l_sql) RETURNING l_sql解析出來無法正確,ash_file拆離
# Modify.........: NO.MOD-B10063 10/12/23 BY yiting 執行後需清空 g_action_choice 變數 
# Modify.........: No.FUN-AB0091 11/01/27 By vealxu 跨db調整
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B70103 11/08/19 by zhangweib 因為aglp000 轉入時會有關係人轉換代號的可能，所以要先回頭找agli106是否有設定轉換資料
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C50156 12/05/18 By wujie  双单身汇出excel
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
#模組變數(Module Variables)
DEFINE tm       RECORD                #FUN-BB0036
                 wc       STRING,                  # Head Where condition
                 aag04    LIKE aag_file.aag04      #FUN-AA098
                END RECORD,
       g_asm1  RECORD
                 asm01   LIKE asm_file.asm01,
                 asm00   LIKE asm_file.asm00,
                 asm02   LIKE asm_file.asm02,
                 asm03   LIKE asm_file.asm03,
                 asm05   LIKE asm_file.asm05,
                 asm06   LIKE asm_file.asm06,                 
                 asm11   LIKE asm_file.asm11
                END RECORD,
       g_asm   DYNAMIC ARRAY OF RECORD
                 #--FUN-AA0098 start--
                 #asm04   LIKE asm_file.asm04,
                 #asm07   LIKE asm_file.asm07,
                 #asm08   LIKE asm_file.asm08,
                 #aah01   LIKE aah_file.aah01,
                 #aah04   LIKE aah_file.aah04,
                 #aah05   LIKE aah_file.aah05
                 aah01    LIKE aah_file.aah01,
                 aag02    LIKE aag_file.aag02,
                 aah04    LIKE aah_file.aah04,
                 aah05    LIKE aah_file.aah05,
                 amt1     LIKE type_file.num20_6,
                 asm04    LIKE asm_file.asm04,
                 aag02_1  LIKE aag_file.aag02,
                 asm07    LIKE asm_file.asm07,
                 asm08    LIKE asm_file.asm08,
                 amt2     LIKE type_file.num20_6
                 #--FUN-AA0098 end---
                END RECORD,
#--FUN-AA0098 start--
       g_asn   DYNAMIC ARRAY OF RECORD
                 aed01    LIKE aed_file.aed01,
                 aag02_2  LIKE aag_file.aag02,
                 aed011   LIKE aed_file.aed011,
                 aed02    LIKE aed_file.aed02,
                 aed05    LIKE aed_file.aed05,
                 aed06    LIKE aed_file.aed06,
                 amt3     LIKE type_file.num20_6,
                 asn04    LIKE asn_file.asn04,
                 aag02_3  LIKE aag_file.aag02,
                 asn05    LIKE asn_file.asn05,
                 asn08    LIKE asn_file.asn08,
                 asn09    LIKE asn_file.asn09,
                 amt4     LIKE type_file.num20_6
                END RECORD,
#--FUN-AA0098 end----
       g_asm_b  DYNAMIC ARRAY OF RECORD LIKE asm_file.*,
       g_aah    DYNAMIC ARRAY OF RECORD LIKE aah_file.*,
       g_aed    DYNAMIC ARRAY OF RECORD LIKE aed_file.*,   #FUN-AA0098
       g_asi    DYNAMIC ARRAY OF RECORD LIKE asi_file.*,
       g_ash04  DYNAMIC ARRAY OF LIKE ash_file.ash04,
       g_argv1            LIKE asm_file.asm00,    #INPUT ARGUMENT - 1
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
DEFINE g_asg03            LIKE type_file.chr21
DEFINE g_dbs_gl           LIKE  azp_file.azp03
DEFINE g_rec_b2           LIKE type_file.num5     #FUN-AA0098
MAIN
      DEFINE l_sl         LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q007_w AT p_row,p_col WITH FORM "ggl/42f/gglq012"
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
   CALL g_asm.clear()
   CALL g_asn.clear()   #FUN-AA0098
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_asm1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
      asm01,asm00,asm02,asm03,asm05,asm06,asm11
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asm01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asm"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asm01
                 NEXT FIELD asm01
            WHEN INFIELD(asm11) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_asm1.asm11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asm11
                 NEXT FIELD asm11
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
       "SELECT UNIQUE asm01,asm00,asm02,asm03,asm05,asm06,asm11",
       "  FROM asm_file ",
       " WHERE ",tm.wc CLIPPED
   PREPARE q007_prepare FROM g_sql
   DECLARE q007_cs SCROLL CURSOR WITH HOLD FOR q007_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE asm01,asm00,asm02,asm03,asm05,asm06,asm11",
       "  FROM asm_file ",
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
#               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asm),'','')
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
   CALL g_asm.clear()
   CALL g_asn.clear()   #FUN-AA0098
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
       WHEN 'N' FETCH NEXT     q007_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm05,g_asm1.asm06,
                                            g_asm1.asm11
       WHEN 'P' FETCH PREVIOUS q007_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm05,g_asm1.asm06,
                                            g_asm1.asm11
       WHEN 'F' FETCH FIRST    q007_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm05,g_asm1.asm06,
                                            g_asm1.asm11
       WHEN 'L' FETCH LAST     q007_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm05,g_asm1.asm06,
                                            g_asm1.asm11
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
           FETCH ABSOLUTE g_jump q007_cs INTO g_asm1.asm01,g_asm1.asm00,
                                              g_asm1.asm02,g_asm1.asm03,
                                              g_asm1.asm05,g_asm1.asm06,
                                              g_asm1.asm11
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_asm1.asm02,SQLCA.sqlcode,0)
       INITIALIZE g_asm1.* TO NULL
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

   DISPLAY BY NAME g_asm1.asm01,g_asm1.asm00,
                   g_asm1.asm02,g_asm1.asm03,
                   g_asm1.asm05,g_asm1.asm06,
                   g_asm1.asm11

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
   DEFINE l_asg04   LIKE asg_file.asg04
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_cnt2    LIKE type_file.num10
   DEFINE l_cnt3    LIKE type_file.num10
   DEFINE l_cnt4    LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_aah01   STRING   #FUN-AA0098
   DEFINE i         LIKE type_file.num5   #TQC-AB0048
   DEFINE l_cnt     LIKE type_file.num5   #TQC-AB0055 

   #依輸入合併個體取資料庫代碼
   SELECT asg03 INTO g_asg03 FROM asg_file WHERE asg01 = g_asm1.asm02
   SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_asg03
   IF STATUS THEN
      LET g_dbs_new = NULL
   END IF
   LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)
   
#--FUN-AA0098 mark---
#   LET l_sql = "SELECT  * FROM asm_file",
#               " WHERE asm01 = '",g_asm1.asm01,"'",
#               "   AND asm00 = '",g_asm1.asm00,"' AND asm02 = '",g_asm1.asm02,"'",
#               "   AND asm03 = '",g_asm1.asm03,"' AND asm05 =  ",g_asm1.asm05,
#               "   AND asm06 = ",g_asm1.asm06,"   AND asm11 = '",g_asm1.asm11,"'"
#   PREPARE q007_pb FROM l_sql
#   DECLARE q007_bcs CURSOR FOR q007_pb          #BODY CURSOR
#   
#   LET l_sql2 = "SELECT ash04 FROM ash_file ",
#                " WHERE ash13 = ?",
#                "   AND ash00 = ?", 
#                "   AND ash01 = ?", 
#               "   AND ash06 = ?"
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
#   LET l_sql4 = " SELECT * FROM asi_file ",
#                "  WHERE asi01 = ?", 
#                "    AND asi04 = ?", 
#                "    AND asi041 = ?", 
#                "    AND asi05 = ?", 
#                "    AND asi06 = ?", 
#                "    AND asi07 = ?",
#                "    AND asi12 = ?"
#   PREPARE q007_pb4 FROM l_sql4
#   DECLARE q007_bcs4 CURSOR FOR q007_pb4          #BODY CURSOR
#---FUN-AA0098 mark---------------------
   
   CALL g_asm.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   LET l_cnt1 = 1

#-----------------FUN-AA0098 mark------------------------
#   #1.依asm_file內資料跑迴圈，將每筆資料FOREACH依序抓取資料
#   FOREACH q007_bcs INTO g_asm_b[l_cnt1].*
#      #2.依ash_file取出合併前科目
#      LET l_cnt2 = 1
#      FOREACH q007_bcs2 USING g_asm_b[l_cnt1].asm01,
#                              g_asm_b[l_cnt1].asm03,
#                              g_asm_b[l_cnt1].asm02,
#                              g_asm_b[l_cnt1].asm04 
#         INTO g_ash04[l_cnt2]
#         #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT asi_file (公司科目餘額暫存資料(非TIPTOP公司))
#         SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01= g_asm_b[l_cnt1].asm02
#         IF l_asg04='Y' THEN   #是否屬於TIPTOP公司
#            #4.依取出的合併前科目迴圈，取aah_file(需依照asg_file指定的營運中心SQL要寫跨db寫法)
#            LET l_cnt3 = 1
#            LET l_flag = 'N'
#            FOREACH q007_bcs3 USING g_asm_b[l_cnt1].asm03,g_ash04[l_cnt2],g_asm_b[l_cnt1].asm05,g_asm_b[l_cnt1].asm06 INTO g_aah[l_cnt3].*
#               #將asm_file,aah_file資料塞到ARRAY
#               IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
#                  CALL cl_err('',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               IF l_cnt2 = 1 or l_flag ='N' THEN
#                  LET g_asm[g_cnt].asm04=g_asm_b[l_cnt1].asm04
#                  LET g_asm[g_cnt].asm07=g_asm_b[l_cnt1].asm07
#                  LET g_asm[g_cnt].asm08=g_asm_b[l_cnt1].asm08
#                  LET l_flag = 'Y'
#               ELSE
#                  LET g_asm[g_cnt].asm04=''
#                  LET g_asm[g_cnt].asm07=''
#                  LET g_asm[g_cnt].asm08=''
#               END IF
#               LET g_asm[g_cnt].aah01=g_aah[l_cnt3].aah01
#               LET g_asm[g_cnt].aah04=g_aah[l_cnt3].aah04
#               LET g_asm[g_cnt].aah05=g_aah[l_cnt3].aah05
#               LET g_cnt = g_cnt+1
#               LET l_cnt3 = l_cnt3+1
#            END FOREACH
#         ELSE #(非TIPTOP)
#            LET l_cnt4 = 1
#            LET l_flag = 'N'
#            FOREACH q007_bcs4 USING g_asm_b[l_cnt1].asm01,g_asm_b[l_cnt1].asm02,g_asm_b[l_cnt1].asm03,g_ash04[l_cnt2],g_asm_b[l_cnt1].asm05,g_asm_b[l_cnt1].asm06,g_asm_b[l_cnt1].asm11 INTO g_asi[l_cnt4].*
#               #將asm_file,asi_file資料塞到ARRAY
#               IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
#                  CALL cl_err('',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               IF l_cnt2 = 1 or l_flag ='N' THEN
#                  LET g_asm[g_cnt].asm04=g_asm_b[l_cnt1].asm04
#                  LET g_asm[g_cnt].asm07=g_asm_b[l_cnt1].asm07
#                  LET g_asm[g_cnt].asm08=g_asm_b[l_cnt1].asm08
#                  LET l_flag = 'Y'
#               ELSE
#                  LET g_asm[g_cnt].asm04=''
#                  LET g_asm[g_cnt].asm07=''
#                  LET g_asm[g_cnt].asm08=''
#               END IF
#               LET g_asm[g_cnt].aah01=g_asi[l_cnt4].asi05
#               LET g_asm[g_cnt].aah04=g_asi[l_cnt4].asi08
#               LET g_asm[g_cnt].aah05=g_asi[l_cnt4].asi09
#               LET g_cnt = g_cnt+1
#               LET l_cnt4 = l_cnt4+1
#            END FOREACH
#         END IF
#         LET l_cnt2 = l_cnt2+1
#      END FOREACH
#      LET l_cnt1 = l_cnt1+1
#-----------------FUN-AA0098 mark------------------------

#-----------------FUN-AA0098 start-------------------------
   #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT asi_file (公司科目餘額暫存資料(非TIPTOP公司))
   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01= g_asm1.asm02  
   IF l_asg04='Y' THEN   #是否屬於TIPTOP公司
       LET l_sql = "SELECT UNIQUE aah01,aag02,aah04,aah05,(aah04-aah05)",
#                   " FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",",ash_file",   #TQC-AB0055 mark
                 # " FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055 mod    #FUN-AB0091
                   " FROM ",cl_get_target_table(g_asg03,'aah_file'),",",    #FUN-AB0091
                            cl_get_target_table(g_asg03,'aag_file'),        #FUN-AB0091 
                   " WHERE aag00 = aah00 ",
                   "   AND aag01 = aah01 ",
                   "   AND aag04 = '",tm.aag04,"'",
                   "   AND aah00 = '",g_asm1.asm03,"'",
                   "   AND aah02 = '",g_asm1.asm05,"'",
                   "   AND aah03 = '",g_asm1.asm06,"'",
#                   "   AND aah01 = ash04 ",               #TQC-AB0055  mark
#                   "   AND ash13 = '",g_asm1.asm01,"'",   #TQC-AB0055  mark
#                   "   AND ash01 = '",g_asm1.asm02,"'",   #TQC-AB0055  mark
                   "   AND aag00 = aah00 ",
                   "   AND aag01 = aah01 ",
                   "  ORDER BY aah01 "
   ELSE
       LET l_sql = " SELECT asi05,asi051,asi08,asi09,(asi08-asi09)",
                    " FROM asi_file ",
                    "  WHERE asi01 = '",g_asm1.asm01,"'", 
                    "    AND asi04 = '",g_asm1.asm02,"'", 
                    "    AND asi041 ='",g_asm1.asm03,"'", 
                    "    AND asi06 = '",g_asm1.asm05,"'", 
                    "    AND asi07 = '",g_asm1.asm06,"'",
                    "    AND asi12 = '",g_asm1.asm11,"'",
                    " ORDER BY asi05 "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_asg03) RETURNING l_sql    #FUN-AB0091
   PREPARE q007_asm_p FROM l_sql
   DECLARE q007_asm_c CURSOR FOR q007_asm_p          #BODY CURSOR
   FOREACH q007_asm_c INTO g_asm[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          #--TQC-AB0055 start--
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt
            FROM ash_file
           WHERE ash04= g_asm[g_cnt].aah01
             AND ash13 =g_asm1.asm01
             AND ash01 =g_asm1.asm02
          IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          #--TQC-AB0055 end---
          IF l_asg04 = 'N' THEN 
              LET l_aah01 = g_asm[g_cnt].aah01
              IF tm.aag04 = '1' THEN   #B/S
                  IF l_aah01.substring(1,1) > 3 THEN
                      CONTINUE FOREACH
                  END IF
              ELSE
                  IF l_aah01.substring(1,1) < 4 THEN
                      CONTINUE FOREACH
                  END IF
              END IF
          END IF
          IF NOT cl_null(g_asm[g_cnt].aah01) THEN
             LET l_sql =  "SELECT asm04,aag02,asm07,asm08,(asm07-asm08)",
                          "  FROM asm_file,aag_file,ash_file ",
                          " WHERE aag00 = asm00 ",
                          "   AND aag01 = asm04 ",
                          "   AND ash13 = '",g_asm1.asm01,"'",
                          "   AND ash01 = '",g_asm1.asm02,"'",
                          "   AND ash04 = '",g_asm[g_cnt].aah01,"'",
                          "   AND ash06 = asm04",
                          "   AND ash13 = asm01",
                          "   AND asm00 = '",g_asm1.asm00,"'",
                          "   AND ash01 = asm02",
                          "   AND asm03 = '",g_asm1.asm03,"'",
                          "   AND asm05 = '",g_asm1.asm05,"'",
                          "   AND asm06 = '",g_asm1.asm06,"'"
             PREPARE q007_asm_p2 FROM l_sql
             DECLARE q007_asm_c2 CURSOR FOR q007_asm_p2          #BODY CURSOR
             FOREACH q007_asm_c2 INTO g_asm[g_cnt].asm04,
                                      g_asm[g_cnt].aag02_1,
                                      g_asm[g_cnt].asm07,
                                      g_asm[g_cnt].asm08,
                                      g_asm[g_cnt].amt2
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
       END IF
       IF g_cnt > 1 THEN
           FOR i = 1 TO g_cnt - 1
               IF g_asm[g_cnt].asm04 = g_asm[i].asm04 THEN          #TQC-AB0048
          #    IF g_asm[g_cnt].asm04 = g_asm[g_cnt-1].asm04 THEN    #TQC-AB0048 mark
                   LET g_asm[g_cnt].asm04 = ''
                   LET g_asm[g_cnt].aag02_1 = ''
                   LET g_asm[g_cnt].asm07 = ''
                   LET g_asm[g_cnt].asm08 = ''
                   LET g_asm[g_cnt].amt2 = ''
               END IF   #TQC-AB0048
           END FOR
       END IF
       LET g_cnt = g_cnt + 1
       #--------FUN-AA0098 end-----------------------
   END FOREACH
   CALL g_asm.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   
END FUNCTION

#----FUN-AA0098 start--
FUNCTION q007_b_fill_2()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_sql2    STRING
   DEFINE l_sql3    STRING
   DEFINE l_sql4    STRING
   DEFINE l_asg04   LIKE asg_file.asg04
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_cnt2    LIKE type_file.num10
   DEFINE l_cnt3    LIKE type_file.num10
   DEFINE l_cnt4    LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_aed01   STRING
   DEFINE l_cnt     LIKE type_file.num5   #TQC-AB0055
   DEFINE l_aal03   LIKE aal_file.aal03   #FUN-B70103
   DEFINE l_aed02   LIKE aed_file.aed02   #FUN-B70103

   #依輸入合併個體取資料庫代碼
   SELECT asg03 INTO g_asg03 FROM asg_file WHERE asg01 = g_asm1.asm02
   SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_asg03
   IF STATUS THEN
      LET g_dbs_new = NULL
   END IF
   LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)
   
   CALL g_asn.clear()

   LET g_rec_b2=0
   LET g_cnt = 1

   #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT asi_file (公司科目餘額暫存資料(非TIPTOP公司))
   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01= g_asm1.asm02  
   IF l_asg04='Y' THEN   #是否屬於TIPTOP公司
       LET l_sql = "SELECT UNIQUE aed01,aag02,aed011,aed02,aed05,",
                   "              aed06,(aed05-aed06)",
       #            "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",",ash_file",  #TQC-AB0055 mark
       #          "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055  #FUN-AB0091 mark
                  "  FROM ",cl_get_target_table(g_asg03,'aed_file'),",",              #FUN-AB0091 
                            cl_get_target_table(g_asg03,'aag_file'),                  #FUN-AB0091  
                  " WHERE aag00 =aed00 ",
                  "   AND aag01 =aed01 ",
                  "   AND aag04 = '",tm.aag04,"'",
                  "   AND aed00 = '",g_asm1.asm03,"'",
                  "   AND aed03 = '",g_asm1.asm05,"'",
                  "   AND aed04 = '",g_asm1.asm06,"'",
#                  "   AND aed01 = ash04 ",              #TQC-AB0055 mark
#                  "   AND ash13 = '",g_asm1.asm01,"'",  #TQC-AB0055 mark
#                  "   AND ash01 = '",g_asm1.asm02,"'",  #TQC-AB0055 mark
                  "   AND aed011 = '99'",
                  "  ORDER BY aed01 "
   ELSE
       LET l_sql = " SELECT asi05,asi051,'99',asi13,asi08,asi09,(asi08-asi09)",
                    " FROM asi_file ",
                    "  WHERE asi01 = '",g_asm1.asm01,"'", 
                    "    AND asi04 = '",g_asm1.asm02,"'", 
                    "    AND asi041 ='",g_asm1.asm03,"'", 
                    "    AND asi06 = '",g_asm1.asm05,"'", 
                    "    AND asi07 = '",g_asm1.asm06,"'",
                    "    AND asi12 = '",g_asm1.asm11,"'",
                    "    AND (asi13 IS NOT NULL AND asi13 <> ' ')",
                    " ORDER BY asi05 "
   END IF

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_asg03) RETURNING l_sql   #FUN-AB0091 
   PREPARE q007_aed_p FROM l_sql
   DECLARE q007_aed_c CURSOR FOR q007_aed_p          #BODY CURSOR
   FOREACH q007_aed_c INTO g_asn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
           #--TQC-AB0055 start--
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM ash_file
            WHERE ash04= g_asn[g_cnt].aed01
              AND ash13 =g_asm1.asm01
              AND ash01 =g_asm1.asm02
           IF l_cnt = 0 THEN CONTINUE FOREACH END IF
           #--TQC-AB0055 end---

           IF l_asg04 = 'N' THEN 
               LET l_aed01 = g_asn[g_cnt].aed01
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
            WHERE aal01 = g_asm1.asm02
              AND aal02 = g_asn[g_cnt].aed02
           IF NOT cl_null(l_aal03) THEN 
               LET l_aed02 = l_aal03 
           ELSE                     
               LET l_aed02 = g_asn[g_cnt].aed02 
           END IF                   
        #--FUN-B70103 end---
           LET l_sql =  "SELECT asn04,aag02,asn05,asn08,asn09,(asn08-asn09)",
                        "  FROM asn_file,aag_file,ash_file ",
                        " WHERE aag00 = asn00 ",
                        "   AND aag01 = asn04 ",
                        "   AND ash13 = '",g_asm1.asm01,"'",
                        "   AND ash01 = '",g_asm1.asm02,"'",
                        "   AND ash04 = '",g_asn[g_cnt].aed01,"'",
                        "   AND ash06 = asn04",
                        "   AND ash13 = asn01",
                        "   AND asn00 = '",g_asm1.asm00,"'",
                        "   AND ash01 = asn02",
                       #"   AND asn05 = '",g_asn[g_cnt].aed02,"'",   #FUN-B70103   Mark
                        "   AND asn05 = '",l_aed02,"'",   #FUN-B70103 add
                        "   AND asn03 = '",g_asm1.asm03,"'",
                        "   AND asn06 = '",g_asm1.asm05,"'",
                        "   AND asn07 = '",g_asm1.asm06,"'"
           PREPARE q007_asn_p2 FROM l_sql
           DECLARE q007_asn_c2 CURSOR FOR q007_asn_p2          #BODY CURSOR
           FOREACH q007_asn_c2 INTO g_asn[g_cnt].asn04,
                                    g_asn[g_cnt].aag02_3,
                                    g_asn[g_cnt].asn05,
                                    g_asn[g_cnt].asn08,
                                    g_asn[g_cnt].asn09,
                                    g_asn[g_cnt].amt4
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
           END FOREACH
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_asn.deleteElement(g_cnt)
   LET g_rec_b2= g_cnt -1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
END FUNCTION

FUNCTION q007_bp2_refresh()

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asn TO s_asn.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

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
   DISPLAY ARRAY g_asm TO s_asm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
#No.TQC-C50156 --begin 
      ON ACTION ExportToExcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asm),base.TypeInfo.create(g_asn),'')
         EXIT DISPLAY
#No.TQC-C50156 --end

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q007_bp2()

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asn TO s_asn.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

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

#No.TQC-C50156 --begin 
      ON ACTION ExportToExcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asm),base.TypeInfo.create(g_asn),'')
         EXIT DISPLAY
#No.TQC-C50156 --end

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

    IF g_asm1.asm01 IS NULL THEN
       LET g_action_choice = " "
       RETURN 
    END IF

    CLOSE WINDOW screen

    CALL cl_set_act_visible("accept,cancel", TRUE)
    MENU "" #ATTRIBUTE(STYLE="popup")

       ON ACTION print_aglr015
         #LET g_msg = "aglr015", #FUN-C30085 mark
          LET g_msg = "aglg015", #FUN-C30085 add
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_asm1.asm01,"' '",g_asm1.asm02,"' '",g_asm1.asm03,"' ", 
                      " '",g_asm1.asm05,"' '",g_asm1.asm06,"' '1'" 
          CALL cl_cmdrun(g_msg)

       ON ACTION print_aglr015_1
         #LET g_msg = "aglr015", #FUN-C30085 mark
          LET g_msg = "aglg015", #FUN-C30085 add
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_asm1.asm01,"' '",g_asm1.asm02,"' '",g_asm1.asm03,"' ", 
                      " '",g_asm1.asm05,"' '",g_asm1.asm06,"' '2'" 
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
