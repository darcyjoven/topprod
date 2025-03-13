# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artp211.4gl 
# Descriptions...: 盤點清單生成盤點單
# Date & Author..: FUN-960130 08/10/08 By sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10036 10/01/07 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.TQC-A10050 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/07/12 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No.FUN-AB0103 10/11/25 By wangxin 盤點清單BUG修改
# Modify.........: No.TQC-B20084 11/02/18 By baogc 生成盤點單時相同料件的資料進行匯總
# Modify.........: No.TQC-B20082 11/02/21 By huangtao rut07掛賬數量改為No Use
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C20181 12/02/16 By fanbj  rux_file INSERT 欄位數量與value值不符
# Modify.........: No:TQC-C20317 12/02/21 By fanbj  報錯信息內容修改，且修改為提示
# Modify.........: No:TQC-C20488 12/02/28 By huangrh 服飾行業，生成盤點單ruxslk資料
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruu           RECORD LIKE ruu_file.*,
       g_ruu_t         RECORD LIKE ruu_file.*,
       g_rus1  DYNAMIC ARRAY OF RECORD
                status  LIKE type_file.chr1,
                rus01   LIKE rus_file.rus01,
                rus04   LIKE rus_file.rus04,
                rusplant  LIKE rus_file.rusplant,
                azp02   LIKE azp_file.azp02
               END RECORD,
       g_ruv   DYNAMIC ARRAY OF RECORD 
                ruv02   LIKE ruv_file.ruv02,
                ruv03   LIKE ruv_file.ruv03,
                ruv04   LIKE ruv_file.ruv04,
                ruv04_desc   LIKE ima_file.ima02,
                ruv05   LIKE ruv_file.ruv05,
                ruv05_desc   LIKE ima_file.ima25,
                ruv06   LIKE ruv_file.ruv06,
                ruv07   LIKE ruv_file.ruv07,
                ruv08   LIKE ruv_file.ruv08,
                ruv09   LIKE ruv_file.ruv09,
                ruv10   LIKE ruv_file.ruv10
                        END RECORD,
       g_ruv_t  RECORD
                ruv02   LIKE ruv_file.ruv02,
                ruv03   LIKE ruv_file.ruv03,
                ruv04   LIKE ruv_file.ruv04,
                ruv04_desc   LIKE ima_file.ima02,
                ruv05   LIKE ruv_file.ruv05,
                ruv05_desc   LIKE ima_file.ima25,
                ruv06   LIKE ruv_file.ruv06,
                ruv07   LIKE ruv_file.ruv07,
                ruv08   LIKE ruv_file.ruv08,
                ruv09   LIKE ruv_file.ruv09,
                ruv10   LIKE ruv_file.ruv10
                        END RECORD
DEFINE g_rus		RECORD LIKE rus_file.*,
       g_rus_t          RECORD LIKE rus_file.*
DEFINE g_ruw	        RECORD LIKE ruw_file.*,
       g_rux   DYNAMIC ARRAY OF RECORD 
                rux02   LIKE rux_file.rux02,
                rux03   LIKE rux_file.rux03,
                rux03_desc LIKE ima_file.ima02,
                rux04   LIKE rux_file.rux04,
                rux04_desc LIKE ima_file.ima25,
                rux05   LIKE rux_file.rux05,
                rux06   LIKE rux_file.rux06,
                rux07   LIKE rux_file.rux07,
                rux08   LIKE rux_file.rux08,
                rux09   LIKE rux_file.rux09
                        END RECORD,
       g_rux_t  RECORD
                rux02   LIKE rux_file.rux02,
                rux03   LIKE rux_file.rux03,
                rux03_desc LIKE ima_file.ima02,
                rux04   LIKE rux_file.rux04,
                rux04_desc LIKE ima_file.ima25,
                rux05   LIKE rux_file.rux05,
                rux06   LIKE rux_file.rux06,
                rux07   LIKE rux_file.rux07,
                rux08   LIKE rux_file.rux08,
                rux09   LIKE rux_file.rux09
                        END RECORD
DEFINE g_ruu02       	 LIKE type_file.chr1000
DEFINE g_ruu03       	 LIKE ruu_file.ruu03
DEFINE g_ruuplant      	 LIKE type_file.chr1000
DEFINE g_t1       	 LIKE oay_file.oayslip     
DEFINE g_buf             LIKE type_file.chr2
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_idd             RECORD LIKE idd_file.*
DEFINE g_idb             RECORD LIKE idb_file.*
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE l_ac              LIKE type_file.num5
DEFINE g_rec_b           LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10050
 
MAIN
   DEFINE l_flag   LIKE type_file.chr1
   DEFINE ls_date  STRING 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_ruu02 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
           
   SELECT * INTO g_ruu.* FROM ruu_file WHERE ruu02=g_ruu02 
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   OPEN WINDOW p211_w WITH FORM "art/42f/artp211"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
       LET g_ruw.ruw00 = '1'
       LET g_ruw.ruw02 = g_ruu02
       LET g_ruw.ruw03 = ''
       LET g_ruw.ruw06 = g_user
       LET g_ruw.ruw07 = ''
       LET g_ruw.ruw08 = 'N'
       LET g_ruw.ruw09 = ''
       LET g_ruw.ruwconf = 'N'
       LET g_ruw.ruwcond = ''
       LET g_ruw.ruwconu = ''
       LET g_ruw.ruwmksg = 'N'
       LET g_ruw.ruwsign = ''
       LET g_ruw.ruwdays = ''
       LET g_ruw.ruwprit = ''
       LET g_ruw.ruwsseq = ''
       LET g_ruw.ruwsmax = ''
       LET g_ruw.ruw900 = '0'
       LET g_ruw.ruwplant= g_plant
       LET g_ruw.ruwlegal= g_legal
       LET g_ruw.ruwuser = g_user
       LET g_ruw.ruwgrup = g_grup
       LET g_ruw.ruwcrat = g_today
       LET g_ruw.ruwmodu = ''
       LET g_ruw.ruwdate = ''
       LET g_ruw.ruwacti = 'Y'
       CALL p211_p1()
       IF cl_sure(18,20) THEN
          CALL s_showmsg_init()
          BEGIN WORK
          LET g_success = 'Y'
          CALL p211_p2()
          CALL s_showmsg()
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             LET g_ruu02=''
             DISPLAY g_ruu02 TO ruu02
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p211_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
   END WHILE
   CLOSE WINDOW p211_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION p211_ruu02()         
DEFINE l_ck1            LIKE type_file.chr50
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE tok1             base.StringTokenizer
DEFINE l_n             LIKE type_file.num5
#DEFINE l_dbs           LIKE azp_file.azp03   #FUN-A50102
DEFINE l_success       LIKE type_file.chr1
 
   LET l_success = 'N'
   LET g_errno = ""
   
   IF g_ruuplant IS NULL OR g_ruu03 IS NULL THEN 
      LET g_errno = '1'
      RETURN ''
   END IF
   LET tok = base.StringTokenizer.createExt(g_ruu02,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()   #盤點計劃
      IF l_ck IS NULL THEN CONTINUE WHILE END IF
      
      LET tok1 = base.StringTokenizer.createExt(g_ruuplant,"|",'',TRUE)
      WHILE tok1.hasMoreTokens()
         LET l_ck1 = tok1.nextToken()  #機構
         IF l_ck1 IS NULL THEN CONTINUE WHILE END IF
         #NO.TQC-A10050-- begin
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_ck
#FUN-A50102 ---------------mark start---------------------------
#        LET g_plant_new = l_ck          
#        CALL s_gettrandbs()               
#        LET l_dbs=g_dbs_tra                
#        #NO.TQC-A10050--end
#        LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102 --------------mark  end----------------------------
         
        #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"rus_file ",                    #FUN-A50102  mark
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ck1,'rus_file'), #FUN-A50102
                     "  WHERE rus01 = '",l_ck,"' AND rus04 ='",g_ruu03,"'",
                     "   AND rusconf ='Y' AND rusplant = '",l_ck1,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_ck) RETURNING g_sql         #FUN-A50102   
         PREPARE pre_sel_count FROM g_sql
         EXECUTE pre_sel_count INTO l_n 
         IF l_n IS NULL THEN LET l_n = 0 END IF
         IF l_n != 0 THEN
            LET l_success = 'Y'
            EXIT WHILE
         END IF
      END WHILE
      IF l_success = 'N' THEN
         EXIT WHILE
      END IF
   END WHILE
 
  IF l_success = 'N' THEN
     LET g_errno = 'art-586'
  END IF
 
  RETURN l_ck
END FUNCTION
 
FUNCTION p211_p1()
DEFINE li_result  LIKE type_file.num5,
       l_n        LIKE type_file.num5
DEFINE l_ck       LIKE type_file.chr50
DEFINE tok        base.StringTokenizer
DEFINE l_rus01    LIKE rus_file.rus01
DEFINE l_flag     LIKE type_file.chr1
 
  WHILE TRUE
     CLEAR FORM
     LET g_ruu03 = g_today
     INPUT g_ruuplant,g_ruu03,g_ruu02  WITHOUT DEFAULTS
        FROM ruuplant,ruu03,ruu02
 
         BEFORE INPUT
            CALL cl_qbe_init()
 
         AFTER FIELD ruu02
           IF NOT cl_null(g_ruu02) THEN
              CALL p211_ruu02() RETURNING l_rus01
              IF NOT cl_null(g_errno) THEN
                 IF g_errno = '1' THEN
                    CALL cl_err('','art-585',0)
                    LET g_ruu.ruu02 = ''
                 ELSE
                    CALL cl_err(l_rus01,g_errno,0)
                    LET g_ruu.ruu02=g_ruu_t.ruu02
                    DISPLAY BY NAME g_ruu.ruu02
                    NEXT FIELD ruu02
                 END IF
              END IF
           END IF
 
         AFTER FIELD ruuplant
            IF NOT cl_null(g_ruuplant) THEN
               LET l_flag = 'Y'
               LET tok = base.StringTokenizer.createExt(g_ruuplant,"|",'',TRUE)
               WHILE tok.hasMoreTokens()
                  LET l_ck = tok.nextToken()
                  IF l_ck IS NULL THEN CONTINUE WHILE END IF
                  LET g_sql = "SELECT COUNT(*) FROM azp_file ",
                              "  WHERE azp01 = '",l_ck,"' AND azp01 IN ",g_auth
                  PREPARE pre_sel_tqb FROM g_sql
                  EXECUTE pre_sel_tqb INTO l_n
                  IF l_n IS NULL THEN LET l_n = 0 END IF
                  IF l_n = 0 THEN
                     CALL cl_err(l_ck,'art-500',0)
                     LET l_flag = 'N'
                     EXIT WHILE
                  END IF
               END WHILE
               IF l_flag = 'N' THEN 
                  NEXT FIELD ruuplant
               END IF
            END IF
 
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about 
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION CONTROLP                  
            CASE
              WHEN INFIELD(ruu02)
                 IF g_ruuplant IS NULL OR g_ruu03 IS NULL THEN
                    CALL cl_err('','art-585',0)
                    NEXT FIELD ruu02
                 END IF
                 CALL p211_query() RETURNING g_ruu02
                 DISPLAY g_ruu02 TO ruu02
                 NEXT FIELD ruu02
              WHEN INFIELD(ruuplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_azp"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1=g_ruuplant
                 CALL cl_create_qry() RETURNING g_ruuplant
                 DISPLAY g_ruuplant TO ruuplant
                 NEXT FIELD ruuplant
           END CASE
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p211_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
 
END FUNCTION
FUNCTION p211_query()
DEFINE l_no       LIKE type_file.chr1000
DEFINE l_i        LIKE type_file.num5
 
   OPEN WINDOW p211_w1 WITH FORM "art/42f/artp211_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("artp211_1")
 
   CALL p211_b_fill()
   INPUT ARRAY g_rus1 WITHOUT DEFAULTS FROM s_rus.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
      ON ACTION all
         FOR l_i = 1 TO g_rus1.getLength()
             LET g_rus1[l_i].status = 'Y'
         END FOR
      ON ACTION no_all
         FOR l_i = 1 TO g_rus1.getLength()
             LET g_rus1[l_i].status = 'N'
         END FOR
   END INPUT
   IF INT_FLAG THEN
      CALL g_rus1.clear()
      LET INT_FLAG = 0
      CLOSE WINDOW p211_w1
      RETURN ''
   END IF
 
   LET l_no = "1"
   FOR l_i = 1 TO g_rus1.getLength()
       IF g_rus1[l_i].rus01 IS NULL THEN CONTINUE FOR END IF
       IF g_rus1[l_i].status = 'Y' THEN
          LET l_no = l_no,g_rus1[l_i].rus01,"|"
       END IF
   END FOR
 
   IF LENGTH(l_no) > 1 THEN
      LET l_no = l_no[2,LENGTH(l_no)-1]
   ELSE
      LET l_no = ' '
   END IF
   CLOSE WINDOW p211_w1
   RETURN l_no
END FUNCTION
FUNCTION p211_b_fill()
DEFINE l_azp01    LIKE azp_file.azp01
#DEFINE l_dbs      LIKE azp_file.azp03  #FUN-A50102
DEFINE l_where    LIKE type_file.chr1000
DEFINE l_flag     LIKE type_file.num5
  
   CALL p211_plant() RETURNING l_where,l_flag
   #NO.TQC-A10050-- begin
   #LET g_sql = "SELECT azp01,azp03 FROM azp_file WHERE azp01 IN ",l_where 
   LET g_sql = "SELECT azp01 FROM azp_file WHERE azp01 IN ",l_where
   PREPARE pre_tqb3 FROM g_sql
   DECLARE cur_tqb3 CURSOR FOR pre_tqb3
 
   LET g_cnt = 1
   CALL g_rus1.clear()
 
   #FOREACH cur_tqb3 INTO l_azp01,l_dbs
   FOREACH cur_tqb3 INTO l_azp01
      IF l_azp01 IS NULL THEN CONTINUE FOREACH END IF
#FUN-A50102---------------mark start------------------- 
#     LET g_plant_new = l_azp01          
#     CALL s_gettrandbs()               
#     LET l_dbs=g_dbs_tra                
#     #NO.TQC-A10050--end
#     LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102 -------------mark end-----------------------
 
#     LET g_sql = "SELECT DISTINCT 'N',rus01,rus04,rusplant FROM ",l_dbs,"rus_file ",                       #FUN-A50102 mark
      LET g_sql = "SELECT DISTINCT 'N',rus01,rus04,rusplant FROM ",cl_get_target_table(l_azp01,'rus_file'), #FUN-A50102 
                  "   WHERE rus04 = '",g_ruu03,"' AND rusconf = 'Y' ",
                  "     AND rusplant = '",l_azp01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql               #FUN-A50102 
      PREPARE p101_rtm FROM g_sql
      DECLARE p101_curs CURSOR FOR p101_rtm
      FOREACH p101_curs INTO g_rus1[g_cnt].*   
         SELECT azp02 INTO g_rus1[g_cnt].azp02 FROM azp_file
             WHERE azp01 = g_rus1[g_cnt].rusplant
         LET g_cnt = g_cnt + 1
      END FOREACH    
   END FOREACH
 
   CALL g_rus1.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   CALL p211_bp_refresh()
END FUNCTION
FUNCTION p211_bp_refresh()
   DISPLAY ARRAY g_rus1 TO s_rus.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
         EXIT DISPLAY
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION p211_jihua()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_where         LIKE type_file.chr1000
 
   IF cl_null(g_ruu02) THEN
      LET l_where = " 1=1 "
      RETURN l_where
   ELSE
      LET g_cnt = 1
      LET tok = base.StringTokenizer.createExt(g_ruu02,"|",'',TRUE)
      LET l_where = "('"
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         LET l_where = l_where,l_ck,"','"
      END WHILE
      LET l_where = "rus01 IN ",l_where[1,LENGTH(l_where)-2],")"
      RETURN l_where
   END IF
END FUNCTION
FUNCTION p211_plant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_where         LIKE type_file.chr1000
DEFINE l_count         LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
 
   LET g_cnt = 0
   LET tok = base.StringTokenizer.createExt(g_ruuplant,"|",'',TRUE)
   LET l_where = "('"
   WHILE tok.hasMoreTokens()
      LET g_cnt = g_cnt + 1
      LET l_ck = tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01 = l_ck
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n = 0 THEN
         CALL s_errmsg(l_ck,'','sel azp_file',100,1)
         LET l_count = l_count + 1
         CONTINUE WHILE
      END IF
      LET l_where = l_where,l_ck,"','"
   END WHILE
   LET l_where = l_where[1,LENGTH(l_where)-2],")"
 
   IF g_cnt = l_count THEN
      RETURN '',FALSE
   END IF
 
   RETURN l_where,TRUE
END FUNCTION
FUNCTION p211_p2()
   DEFINE l_rus01     LIKE rus_file.rus01
   DEFINE l_rus900    LIKE rus_file.rus900
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_count     LIKE type_file.num5
   DEFINE l_ck        LIKE type_file.chr50
   DEFINE tok         base.StringTokenizer
   DEFINE l_where     LIKE type_file.chr1000
   DEFINE l_azp01     LIKE azp_file.azp01
#  DEFINE l_azp03     LIKE azp_file.azp03  #FUN-A50102 mark
   DEFINE l_success   LIKE type_file.num5
 
   CALL p211_plant() RETURNING l_where,l_success
   IF NOT l_success THEN
      LET g_success = 'N'
   END IF
   #NO.TQC-A10050-- begin
   #LET g_sql = "SELECT DISTINCT azp01,azp03 FROM azp_file ",
   #            "   WHERE azp01 IN ",l_where
   LET g_sql = "SELECT DISTINCT azp01 FROM azp_file WHERE azp01 IN ",l_where            
   PREPARE pre_sel_tqb5 FROM g_sql
   DECLARE cur_tqb5 CURSOR FOR pre_sel_tqb5
 
   CALL p211_jihua() RETURNING l_where
   #FOREACH cur_tqb5 INTO l_azp01,l_azp03
   FOREACH cur_tqb5 INTO l_azp01
#FUN-A50102------------------------mark start-------------------------------
#     LET g_plant_new = l_azp01          
#     CALL s_gettrandbs()               
#     LET l_azp03=g_dbs_tra                
#     #NO.TQC-A10050--end
#     LET l_azp03 = s_dbstring(l_azp03)
#FUN-A50102-----------------------mark end-------------------------------------
         
     #LET g_sql = "SELECT rus01,rus900 FROM ",l_azp03,"rus_file ",                        #FUN-A50102 mark
      LET g_sql = "SELECT rus01,rus900 FROM ",cl_get_target_table(l_azp01,'rus_file'),    #FUN-A50102  
                  "   WHERE rus04 = '",g_ruu03,"' ",
                  "     AND ",l_where,
                  "     AND rusplant = '",l_azp01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql      #FUN-A50102  
      PREPARE pre_sel_rus01 FROM g_sql
      DECLARE cur_rus01 CURSOR FOR pre_sel_rus01
      FOREACH cur_rus01 INTO l_rus01,l_rus900
        #LET g_sql = "SELECT COUNT(*) FROM ",l_azp03,"ruu_file ",                         #FUN-A50102 mark
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'ruu_file'),     #FUN-A50102 
                     "   WHERE ruu02 = '",l_rus01,"' ",
                     "     AND ruuplant = '",l_azp01,"' AND ruuconf='N' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
         PREPARE pre_sel_count1 FROM g_sql
         EXECUTE pre_sel_count1 INTO l_n
         IF l_n IS NULL THEN LET l_n = 0 END IF
         IF l_n>0 THEN
            CALL s_errmsg(l_rus01,'','sel ruu_file','art-400',1)
            LET g_success = 'N'
         END IF
         IF l_rus900 = '2' THEN
            CALL s_errmsg(l_rus01,'','sel rus_file','art-401',1)
            LET g_success = 'N'
         END IF
        #CALL p211_create(l_rus01,l_azp01,l_azp03)                            #FUN-A50102 mark
         CALL p211_create(l_rus01,l_azp01)                                    #FUN-A50102 
        #LET g_sql = "UPDATE ",l_azp03,"ruu_file SET ruu900 = '2' ",          #FUN-A50102 mark
        #LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'ruu_file'),       #FUN-A50102 #FUN-AB0103 mark
         LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'ruu_file')," SET ruu900 = '2' ",  #FUN-AB0103 add
                     " WHERE ruu02 = '",l_rus01,"' ",
                     "   AND ruu03 = '",g_ruu03,"' ",
                     "   AND ruuplant = '",l_azp01,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102
         PREPARE pre_upd_ruu FROM g_sql
         EXECUTE pre_upd_ruu
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET l_count = l_count + 1
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg(l_rus01,'','sel ruu_file','art-347',1)
            ELSE
               CALL s_errmsg('','','upd ruu_file',SQLCA.SQLCODE,1)
            END IF
            LET g_success = 'N'
         END IF
        #LET g_sql = "UPDATE ",l_azp03,"rus_file SET rus900 = '2' ",                          #FUN-A50102 mark
         LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rus_file')," SET rus900 = '2' ",  #FUN-A50102
                     " WHERE rus01 = '",l_rus01,"' ",
                     "   AND rusplant = '",l_azp01,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102
         PREPARE pre_upd_rus FROM g_sql
         EXECUTE pre_upd_rus
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','upd rus_file',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
      END FOREACH
   END FOREACH
 
END FUNCTION

#FUNCTION p211_create(p_rus01,p_plant,p_dbs)   #FUN-A50012 mark
FUNCTION p211_create(p_rus01,p_plant)          #FUN-A50012 
DEFINE p_rus01      LIKE rus_file.rus01
DEFINE p_plant      LIKE azp_file.azp01
#DEFINE p_dbs        LIKE azp_file.azp03   #FUN-A50102  mark
DEFINE l_ruwcont    LIKE ruw_file.ruwcont
DEFINE l_ruv04     LIKE ruv_file.ruv04
DEFINE l_ruv05     LIKE ruv_file.ruv05
DEFINE l_ruv06     LIKE ruv_file.ruv06
DEFINE l_newno     LIKE ruw_file.ruw01
DEFINE li_result   LIKE type_file.num5
DEFINE l_ruu04     LIKE ruu_file.ruu04
DEFINE l_rut       RECORD LIKE rut_file.*
DEFINE l_rux05     LIKE rux_file.rux05
DEFINE l_rux08     LIKE rux_file.rux08
DEFINE l_legal     LIKE azw_file.azw02
DEFINE l_cnt       LIKE type_file.num10      #TQC-C20488
DEFINE l_ima25     LIKE ima_file.ima25       #TQC-C20488
DEFINE l_ima151    LIKE ima_file.ima151      #TQC-C20488
DEFINE l_ruxslk03  LIKE ruxslk_file.ruxslk03 #TQC-C20488
DEFINE l_ruxslk06  LIKE ruxslk_file.ruxslk06 #TQC-C20488
 
#  LET g_sql = " SELECT DISTINCT ruu04 FROM ",p_dbs,"ruu_file ",                        #FUN-A50102  mark
   LET g_sql = " SELECT DISTINCT ruu04 FROM ",cl_get_target_table(p_plant,'ruu_file'),  #FUN-A50102
               "  WHERE ruu02='",p_rus01,"'",
               "    AND ruuplant='",p_plant,"'",
               "    AND ruuconf='Y'",
               "    ORDER BY ruu04 "
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
   DECLARE p211_foreach CURSOR FROM g_sql
 
   FOREACH p211_foreach INTO l_ruu04
      IF STATUS THEN
         CALL cl_err('p211_foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO l_newno FROM rye_file 
      #   WHERE rye01 = 'art' AND rye02 = 'J4' AND ryeacti = 'Y'    #FUN-A70130
      #IF SQLCA.sqlcode = 100 THEN
      #   CALL s_errmsg('','','sel rye03',SQLCA.sqlcode,1)
      #   LET g_success = 'N'
      #END IF
      #FUN-C90050 mark end----

      #FUN-C90050 add begin---    
      CALL s_get_defslip('art','J4',g_plant,'N') RETURNING l_newno 
      IF cl_null(l_newno) THEN
         CALL s_errmsg('','','sel rye03','art-330',1)
         LET g_success = 'N'
      END IF
      #FUN-C90050 add end-----

#     CALL s_auto_assign_no("art",l_newno,g_today,"J","ruw_file","ruw01",p_plant,"","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno,g_today,"J4","ruw_file","ruw01",p_plant,"","") #FUN-A70130 mod
         RETURNING li_result,l_newno
      LET l_ruwcont=TIME
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = p_plant
     #LET g_sql = "INSERT INTO ",p_dbs,"ruw_file(",                           #FUN-A50102 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'ruw_file'),"(", #FUN-A50102
                  " ruw00,ruw01,ruw02,ruw03,ruw04,ruw05,",
                  " ruw06,ruw07,ruw08,ruw09,ruw900,ruwacti,", 
                  " ruwcond,ruwconf,ruwcont,ruwconu,ruwcrat,",
                  " ruwdate,ruwdays,ruwgrup,ruwlegal,ruwmksg,",
                  " ruwmodu,ruwplant,ruwpos,ruwprit,ruwsign,",
                  " ruwsmax,ruwsseq,ruwuser,ruworiu,ruworig) VALUES (",  #FUN-A10036
                  "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                  "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"   #FUN-A10036
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102  
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102    
      PREPARE pre_ins_ruw FROM g_sql
      EXECUTE pre_ins_ruw USING '1',l_newno,p_rus01,'',g_ruu03,
                                l_ruu04,g_user,'','N','',
                                '0','Y','','N','','',g_today,'','',g_grup,
                                l_legal,'N','',p_plant,'N',
                                '0','','0','0',g_user,g_user,g_grup #FUN-A10036
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','','insert ruw_file',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
 
     #LET g_sql = " SELECT ruv04,ruv05,ruv06 FROM ",p_dbs,"ruu_file,",p_dbs,"ruv_file ",         #FUN-A50102  mark
     #LET g_sql = " SELECT ruv04,ruv05,ruv06 FROM ",cl_get_target_table(p_plant,'ruu_file'),",", #FUN-A50102  #TQC-B20084 MARK
      LET g_sql = " SELECT ruv04,ruv05,SUM(ruv06) FROM ",cl_get_target_table(p_plant,'ruu_file'),",", #FUN-A50102  #TQC-B20084 ADD
                                                    cl_get_target_table(p_plant,'ruv_file'),     #FUN-A50012   
                  "  WHERE ruu01=ruv01 ",
                  "    AND ruu02='",p_rus01,"'",
                  "    AND ruu04='",l_ruu04,"'",
                  "    AND ruuplant=ruvplant ",
                  "    AND ruuplant='",p_plant,"'",
                  "  GROUP BY ruv04,ruv05 ",                   #TQC-B20084 ADD
                  "    ORDER BY ruv04 "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql         #FUN-A50102 
      DECLARE p211_foreach1 CURSOR FROM g_sql
      LET g_cnt = 1
      FOREACH p211_foreach1 INTO l_ruv04,l_ruv05,l_ruv06
         IF STATUS THEN
            CALL cl_err('p211_foreach1:',STATUS,1)
            EXIT FOREACH
         END IF
        #LET g_sql = " SELECT rut06-COALESCE(rut07,0) FROM ",p_dbs,"rut_file ",                        #FUN-A50102 mark
        #LET g_sql = " SELECT rut06-COALESCE(rut07,0) FROM ",cl_get_target_table(p_plant,'rut_file'),  #FUN-A50102     #TQC-B20082 mark
         LET g_sql = " SELECT rut06 FROM ",cl_get_target_table(p_plant,'rut_file'),                                    #TQC-B20082
                     "  WHERE rut01 = '",p_rus01,"'",
                     "    AND rut03 = '",l_ruu04,"'",
                     "    AND rut04 = '",l_ruv04,"'",
                     "    AND rut05 = '",l_ruv05,"'",
                     "    AND rutplant = '",p_plant,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                     #FUN-A50102  
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql             #FUN-A50102
         PREPARE pre_sel_rut1 FROM g_sql
         EXECUTE pre_sel_rut1 INTO l_rux05 
         IF SQLCA.SQLCODE  THEN 
            #CALL s_errmsg('','','sel rut_file',SQLCA.sqlcode,1)     #TQC-C20317 mark
            CALL s_errmsg('',l_ruv04,'','art1052',2)      #TQC-C20317 add
         END IF
 
         IF l_rux05 IS NULL THEN LET l_rux05 = 0 END IF
         IF l_ruv06 IS NULL THEN LET l_ruv06 = 0 END IF
         LET l_rux08 = l_ruv06-l_rux05
        #LET g_sql = "INSERT INTO ",p_dbs,"rux_file VALUES (",                                #FUN-A50102 mark
        #LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'rus_file')," VALUES(",       #FUN-A50102   #FUN-AB0103 mark
        LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'rux_file')," VALUES(",        #FUN-AB0103 add
        #           "?,?,?,?,?, ?,?,?,?,?, ?,?)"                #TQC-C20181   mark
                    "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"            #TQC-C20181   add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
         PREPARE pre_ins_rux FROM g_sql
         EXECUTE pre_ins_rux USING '1',l_newno,g_cnt,l_ruv04,l_ruv05,
                                   l_rux05,l_ruv06,'0',l_rux08,'',l_legal,
         #                         p_plant             #TQC-C20181   mark
                                   p_plant,'',''       #TQC-C20181   add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','insert rux_file',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         LET g_cnt = g_cnt + 1
      END FOREACH

      IF s_industry("slk") THEN
#TQC-C20488 add--begin---
      LET g_sql = " SELECT DISTINCT(COALESCE(imx00,rux03))",
                  "   FROM ",cl_get_target_table(p_plant,'rux_file'),
                  "   LEFT JOIN ",cl_get_target_table(p_plant,'imx_file'),
                  "     ON imx000=rux03",
                  "  WHERE rux00='1' ",
                  "    AND rux01='",l_newno,"'",
                  "    AND ruxplant='",p_plant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql       
      DECLARE p211_slk CURSOR FROM g_sql

      LET g_sql = " SELECT ima25,ima151 FROM ",cl_get_target_table(p_plant,'ima_file'), 
                  "  WHERE ima01 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql       
      PREPARE pre_ima_slk FROM g_sql

      LET g_sql = " SELECT SUM(rux06) FROM ",cl_get_target_table(p_plant,'rux_file'),
                  "  WHERE rux00='1' ",
                  "    AND rux03=?",
                  "    AND rux01='",l_newno,"'",
                  "    AND ruxplant='",p_plant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE pre_rux_slk FROM g_sql

      LET g_sql = " SELECT SUM(rux06)",
                  "   FROM ",cl_get_target_table(p_plant,'rux_file'),",",
                             cl_get_target_table(p_plant,'imx_file'),
                  "  WHERE rux00='1' ",
                  "    AND rux03=imx000",
                  "    AND imx00=?",
                  "    AND rux01='",l_newno,"'",
                  "    AND ruxplant='",p_plant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE pre_rux_slk2 FROM g_sql

      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'ruxslk_file')," VALUES(",
                  "?,?,?,?,?, ?,?,?,?)"          
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql 
      PREPARE pre_ins_ruxslk FROM g_sql

      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'rux_file'),
                  "   SET rux10s =? ,",
                  "       rux11s =? ",
                  "  WHERE rux00='1' ",
                  "    AND rux01='",l_newno,"'",
                  "    AND ruxplant='",p_plant,"'",
                  "    AND rux03 IN ( SELECT imx000",
                  "                     FROM imx_file",
                  "                    WHERE imx00=? )"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql     
      PREPARE pre_upd_rux2 FROM g_sql

      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'rux_file'),
                  "   SET rux10s =? ,",
                  "       rux11s =? ",
                  "  WHERE rux00='1' ",
                  "    AND rux01='",l_newno,"'",
                  "    AND ruxplant='",p_plant,"'",
                  "    AND rux03=? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE pre_upd_rux FROM g_sql

      LET l_cnt=1
      FOREACH p211_slk INTO l_ruxslk03

         LET l_ima25=NULL
         EXECUTE pre_ima_slk INTO l_ima25,l_ima151 USING l_ruxslk03
         IF l_ima151='Y' THEN
            EXECUTE pre_rux_slk2 INTO l_ruxslk06 USING l_ruxslk03
         ELSE
            EXECUTE pre_rux_slk INTO l_ruxslk06 USING l_ruxslk03
         END IF

         EXECUTE pre_ins_ruxslk USING '1',l_newno,l_cnt,l_ruxslk03,l_ima25,l_ruxslk06,'',l_legal,p_plant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            CALL s_errmsg('','','insert rux_file',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         IF l_ima151='Y' THEN
            EXECUTE pre_upd_rux2 USING l_ruxslk03,l_cnt,l_ruxslk03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('','','upd rux_file',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF

         ELSE
            EXECUTE pre_upd_rux USING l_ruxslk03,l_cnt,l_ruxslk03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('','','upd rux_file',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END IF

         LET l_cnt=l_cnt+1

      END FOREACH
      END IF
#TQC-C20488 add--end---


   END FOREACH
 
END FUNCTION
 
FUNCTION p211_delall(p_plant,p_newno)
DEFINE p_plant       LIKE azp_file.azp01
DEFINE p_newno       LIKE ruw_file.ruw01
 
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM ruu_file
    WHERE ruu02 = g_ruu02
 
   IF g_cnt <= 0 THEN
      DELETE FROM ruw_file WHERE ruw00 = '1'  AND ruw01 = p_newno
      DELETE FROM rux_file WHERE rux00 = '1'  AND rux01 = p_newno
 
      CALL cl_err('','art-424',1)
      LET g_success = 'N'
   END IF
 
END FUNCTION
#NO.FUN-960130-----------end---------------------- 
