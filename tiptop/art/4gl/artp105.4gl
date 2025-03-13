# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Descriptions...: 批次生成促銷費用單
# Pattern name...: artp105.4gl 
# Date & Author..: FUN-870007 09/09/27 By Zhangyajun
# Modify.........: No.TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/07/13 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80105 10/08/19 By shaoyong 程式名稱調整"促銷費用單批次產生作業",加入單別選項
# Modify.........: No.FUN-AA0046 10/10/26 By huangtao 添加費用單別的參數 
# Modify.........: No.TQC-AB0021 10/11/02 By Carrier lua08/lua08t赋值
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BA0105 11/10/28 By pauline 修改背景處理寫法
# Modify.........: No.FUN-BC0125 11/12/29 By suncx 費用單結構變化，調整對應的零售批處理程序artp104、artp105
# Modify.........: No:FUN-BB0117 12/01/05 By shiwuying lua05内部客户赋值
# Modify.........: No:TQC-C20400 12/02/22 By suncx 1、直接收款欄位賦值調整為N 2、批處理作業條件錄入調整
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE g_sql             STRING
DEFINE g_wc STRING
DEFINE g_date LIKE type_file.dat
DEFINE g_vendor STRING
DEFINE g_org STRING
DEFINE ga_dbs DYNAMIC ARRAY OF RECORD
     # dbs LIKE azp_file.azp03,    #FUN-A50102  mark
       plant LIKE azp_file.azp01   #FUN-A50102 
     # dbstr STRING                #FUN-A50102  mark
       END RECORD
DEFINE g_slip LIKE rye_file.rye03    #No.FUN-A80105--add--

MAIN
   DEFINE l_flag   LIKE type_file.chr1
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_date = ARG_VAL(1)
   LET g_vendor = ARG_VAL(2)
   LET g_org = ARG_VAL(3)
   LET g_slip = ARG_VAL(4)                        #FUN-AA0046
#   LET g_bgjob = ARG_VAL(4)                      #FUN-AA0046 mark
   LET g_bgjob = ARG_VAL(5)                       #FUN-AA0046 
#   IF g_bgjob IS NULL THEN                       #FUN-BA0105 mark
   IF cl_null(g_bgjob) THEN                       #FUN-BA0105 add
      LET g_bgjob='N'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 5 LET p_col = 28
#FUN-BA0105 mark START 
#   OPEN WINDOW p105_w AT p_row,p_col WITH FORM "art/42f/artp105"
#      ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#FUN-BA0105 mark END
   WHILE TRUE
      IF g_bgjob='N' THEN
         LET g_success = 'Y'
         CALL p105_p1()
         IF g_success = 'Y' THEN
            CALL cl_end2(1) RETURNING l_flag
            IF l_flag != 1 THEN
               EXIT WHILE
            END IF 
         ELSE
            IF g_success = 'N' THEN
               CALL cl_err('','abm-020',1)
            END IF
         END IF
         CLOSE WINDOW p105_w   #FUN-BA0105 add
      ELSE
         LET g_success='Y'
         IF cl_null(g_date) OR g_date = '' THEN  #TQC-C20400 add
            LET g_date = g_today  #TQC-C20400 add
         END IF                   #TQC-C20400 add
         CALL p105_p2()
         EXIT WHILE            #FUN-BA0105 add
      END IF
   END WHILE
#   CLOSE WINDOW p105_w         #FUN-BA0105 mark
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p105_p1()
DEFINE lc_cmd LIKE type_file.chr1000
DEFINE l_n    LIKE type_file.num5    #No.FUN-A80105--add--

#FUN-BA0105 add START
   OPEN WINDOW p105_w AT p_row,p_col WITH FORM "art/42f/artp105"
      ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#FUN-BA0105 add END 
  WHILE TRUE

     #FUN-A80105--begin--
     #FUN-C90050 mark begin---
     #SELECT rye03 INTO g_slip FROM rye_file
     # WHERE rye01 = 'art'
     #   AND rye02 = 'B9'
     #FUN-C90050 mark end----

     CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_slip    #FUN-C90050 add

#    INPUT g_date,g_vendor,g_org
#      WITHOUT DEFAULTS
#       FROM date,vendor,plant
 
     INPUT g_date,g_vendor,g_org,g_slip
       WITHOUT DEFAULTS
        FROM date,vendor,plant,slip
     #FUN-A80105--begin--

        BEFORE INPUT
           DISPLAY g_today TO FORMONLY.date
 
        #FUN-A80105--begin--
        AFTER FIELD slip
           SELECT COUNT(*) INTO l_n FROM oay_file
            WHERE oayslip = g_slip
              AND  oaysys = 'art'
              AND oaytype = 'B9'
           IF l_n = 0  THEN
              CALL cl_err("",'slip',0)
              NEXT FIELD slip
           END IF
        #FUN-A80105--end--

        ON ACTION controlp
           CASE
               WHEN INFIELD(vendor)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET g_vendor=g_qryparam.multiret
                 DISPLAY g_vendor TO vendor
                 NEXT FIELD vendor
              WHEN INFIELD(plant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET g_org=g_qryparam.multiret
                 DISPLAY g_org TO plant
                 NEXT FIELD plant
#FUN-A80105--begin--
               WHEN INFIELD(slip)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_slip"
                  LET g_qryparam.default1 = g_slip
                  CALL cl_create_qry() RETURNING g_slip
                  DISPLAY g_slip TO slip
                  NEXT FIELD slip
#FUN-A80105--end--
            END CASE
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
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
        ON ACTION about
           CALL cl_about()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION controlp
           CALL cl_cmdask()
        ON ACTION exit
           LET INT_FLAG=1
           EXIT INPUT
        ON ACTION qbe_save
           CALL cl_qbe_save()
        ON ACTION locale
           LET g_change_lang=TRUE
           EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p105_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
      END IF
      EXIT WHILE
  END WHILE
  IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp105"
#     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN           #FUN-BA0105 mark
     IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN           #FUN-BA0105 add
        CALL cl_err('artp105','9031',1)
     ELSE
        LET g_date = NULL  #TQC-C20400 add
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_date CLIPPED,"'",
                     " '",g_vendor CLIPPED,"'",
                     " '",g_plant CLIPPED,"'",
                     " '",g_slip CLIPPED,"'",                    #FUN-AA0046
                     " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('artp105',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p105_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  IF cl_sure(18,20) THEN
     CALL p105_p2()
  ELSE
     LET g_success = 'K'
  END IF
END FUNCTION
 
FUNCTION p105_p2()
DEFINE l_dbs LIKE type_file.chr21
DEFINE l_dbstr STRING
DEFINE l_plantstr STRING 
DEFINE li_result LIKE type_file.num5
DEFINE tok       base.StringTokenizer   
DEFINE tok1      base.StringTokenizer   #TQC-C20400
DEFINE l_tok STRING
DEFINE l_n  LIKE type_file.num5                     #FUN-AA0046
DEFINE li_i,l_cnt,l_pos LIKE type_file.num5
DEFINE l_no,l_lua01 LIKE lua_file.lua01
DEFINE l_lua RECORD LIKE lua_file.*
DEFINE l_azp01 LIKE azp_file.azp01    #TQC-A10073  add     
DEFINE l_lub01       LIKE lub_file.lub01    #No.TQC-AB0021
DEFINE l_lub04       LIKE lub_file.lub04    #No.TQC-AB0021
DEFINE l_lub04t      LIKE lub_file.lub04t   #No.TQC-AB0021
DEFINE l_azw02       LIKE azw_file.azw02    #FUN-BB0117
DEFINE l_vendor        LIKE rty_file.rty05        #TQC-C20400 add
DEFINE l_vender        LIKE rty_file.rty05        #TQC-C20400 add
DEFINE l_sql           STRING                     #TQC-C20400 add
DEFINE l_vendor_str    STRING                     #TQC-C20400 add

   DROP TABLE lua_temp
   DROP TABLE lub_temp
   SELECT lua_file.* FROM lua_file WHERE 1 = 0 INTO TEMP lua_temp
   SELECT lub_file.* FROM lub_file WHERE 1 = 0 INTO TEMP lub_temp
   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success = 'Y'
   LET tok = base.StringTokenizer.create(g_org,"|")
   LET l_cnt = 1                               #FUN-A50102
   WHILE tok.hasMoreTokens()
      LET l_tok=tok.nextToken()
      LET ga_dbs[l_cnt].plant = l_tok          #FUN-A50102
#FUN-A80105 ----------STA
      SELECT COUNT(*) INTO l_n  FROM azw_file WHERE azw01 = ga_dbs[l_cnt].plant
      IF l_n = 0 THEN
            CONTINUE WHILE
      END IF
#FUN-A80105 ----------END
      LET l_cnt = l_cnt + 1                    #FUN-A50102
     #FUN-A50102 -----------------------mark start------------------- 
     #CALL p105_azp(l_tok) RETURNING l_dbs
     #IF NOT cl_null(g_errno) THEN
     #   LET g_success='N'
     #   CONTINUE WHILE
     #END IF
     #CALL p105_find(l_dbs) RETURNING l_cnt
     #IF l_cnt=0 THEN
     #   LET l_pos=ga_dbs.getLength()
     #   LET ga_dbs[l_pos+1].dbs=l_dbs
     #   LET ga_dbs[l_pos+1].dbstr="'"||l_tok||"'"    
     #ELSE
     #   LET ga_dbs[l_cnt].dbs=l_dbs
     #   LET ga_dbs[l_cnt].dbstr=ga_dbs[l_cnt].dbstr||",'",l_tok||"'"   
     #END IF
     #FUN-A50102-----------------------mark  end---------------------
   END WHILE
 
   FOR li_i=1 TO ga_dbs.getlength()
     #LET l_dbs = ga_dbs[li_i].dbs      #FUN-A50102 mark
     #LET l_dbs = s_dbstring(l_dbs)     #FUN-A50102 mark
     #LET l_dbstr = ga_dbs[li_i].dbstr  #FUN-A50102 mark 
      LET l_plantstr= ga_dbs[li_i].plant  #FUN-A50102
    #FUN-A80105 Begin---  By shi #改的太亂,整理一下;加上occ061的賦值
    ##LET g_sql="INSERT INTO lua_temp(lua01,lua04,lua05,lua06,lua08,lua08t,lua10,",   
    # LET g_sql="INSERT INTO lua_temp(lua01,lua04,lua05,lua06,lua08,lua08t,lua10,lua11,",                       #FUN-A80105
    ##          "                     lua12,lua13,lua14,lua15,lua19,lua23,luaacti,luaplant,lualegal) ",          #FUN-A80105--mark--
    #           "                     lua12,lua13,lua14,lua15,lua19,lua23,luaacti,luaplant,lualegal,lua32) ",    #FUN-A80105--mod--
    #          #"SELECT ROWNUM,rxc14,' ',rxc13,0,0,'Y',",
    #           "SELECT ROWNUM,rxc14,' ',rxc13,0,0,'Y','1',",                                              #FUN-A80105
    #          #"       rxc04,'N',' ','N',rxc12,' ','Y',rxcplant,rxclegal",                                #FUN-A80105--mark--
    #           "       rxc04,'N',' ','N',rxc12,' ','Y',rxcplant,rxclegal,'0'",                            #FUN-A80105--mod--
    #           "  FROM (SELECT DISTINCT rxc14,rxc13,rxc04,rxc12,rxcplant,rxclegal",
    #          #"          FROM ",l_dbs,"rxc_file",                          #FUN-A50102 mark
    #           "          FROM ",cl_get_target_table(l_plantstr,'rxc_file'),   #FUN-A50102   
    #          # "         WHERE rxcplant IN (",l_plantstr,")",                                         #FUN-A80105--mark--
    #           "         WHERE rxcplant IN ('",l_plantstr,"')",                                        #FUN-A80105
    #          #"           AND EXISTS (SELECT 1 FROM ",l_dbs,"rtu_file",                               #FUN-A50102 mark
    #           "           AND EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plantstr,'rtu_file'),     #FUN-A50102           
    #           "                        WHERE rtu10 = '",g_date,"'",
    #           "                          AND rtuconf = 'Y'",
    #           "                          AND rtu08=rxc04",
    #           "                          AND rtuplant= rxcplant))"
     #TQC-C20400 add start--------------
      IF cl_null(g_vendor) OR g_vendor='*' THEN
         LET l_vendor_str = NULL
         LET l_sql = "SELECT UNIQUE rtu05 FROM ",cl_get_target_table(l_plantstr,"rtu_file"),
                                             ",",cl_get_target_table(l_plantstr,"pmc_file"),
                     " WHERE rtu05=pmc01 AND '",g_date,"' BETWEEN rtu09 AND rtu10",
                     "   AND rtuconf='Y'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plantstr) RETURNING l_sql
         PREPARE p105_vendor_pre FROM l_sql
         DECLARE p105_vendor_cs CURSOR FOR p105_vendor_pre
         FOREACH p105_vendor_cs INTO l_vendor
            IF cl_null(l_vendor_str) THEN
               LET l_vendor_str=l_vendor
            ELSE
               LET l_vendor_str=l_vendor_str,'|',l_vendor
            END IF
         END FOREACH
      ELSE 
         LET l_vendor_str = g_vendor
      END IF
      LET tok1 = base.StringTokenizer.createExt(l_vendor_str,"|",'',TRUE) 
      WHILE tok1.hasMoreTokens()
         LET l_vender = tok1.nextToken()
         IF l_vender IS NULL THEN CONTINUE WHILE END IF
      #TQC-C20400 add end----------------
      LET g_sql="INSERT INTO lua_temp(lua01,lua04,lua05,lua06,lua061,lua08,lua08t,lua10,lua11,",
               #"                     lua12,lua13,lua14,lua15,lua19,lua23,luaacti,luaplant,lualegal,lua32) ",
                "                     lua12,lua13,lua14,lua15,lua19,lua23,luaacti,luaplant,lualegal,lua32,lua35,lua36,lua37) ", #FUN-BC0125 add lua35,lua36,lua37
               #"SELECT ROWNUM,rxc14,' ',rxc13,occ02,0,0,'Y','1',",     #FUN-BB0117
                "SELECT ROWNUM,rxc14,'N',rxc13,occ02,0,0,'Y','1',",     #FUN-BB0117
               #"       rxc04,'N',' ','N',rxc12,' ','Y',rxcplant,rxclegal,'0'",
                "       rxc04,'N',' ','N',rxc12,' ','Y',rxcplant,rxclegal,'0',0,0,'N'",    #FUN-BC0125 add 0,0,'N'
                "  FROM (SELECT DISTINCT rxc14,rxc13,occ02,rxc04,rxc12,rxcplant,rxclegal",
                "          FROM ",cl_get_target_table(l_plantstr,'rxc_file')," LEFT OUTER JOIN ",
                                  cl_get_target_table(l_plantstr,'occ_file')," ON rxc13=occ01",
                "         WHERE rxcplant IN ('",l_plantstr,"')",
                "           AND EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plantstr,'rtu_file'),
                "                        WHERE rtu10 = '",g_date,"'",
                "                          AND rtuconf = 'Y'",
                "                          AND rtu05 = '",l_vender,"'",    #TQC-C20400
                "                          AND rtu08=rxc04",
                "                          AND rtuplant= rxcplant))"
    #FUN-A80105 End----- By shi
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102 
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql         #FUN-A50102 
      EXECUTE IMMEDIATE g_sql
     #FUN-BB0117 Begin---
      SELECT azw02 INTO l_azw02 FROM azw_file
       WHERE azw01 = ga_dbs[li_i].plant
      LET g_sql="UPDATE lua_temp ",
                "   SET lua05='Y',",
                "       lua37='N'", #FUN-BC0125 add
                " WHERE lua06 IN (SELECT DISTINCT occ01 FROM occ_file,azw_file ",
                "                  WHERE occ930 = azw01 ",
                "                    AND occ930 = '",l_plantstr,"'",
                "                    AND occ930 IS NOT NULL",
                "                    AND azw02 = '",l_azw02,"')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql
      EXECUTE IMMEDIATE g_sql
     #FUN-BB0117 End-----
      LET g_sql="UPDATE lua_temp ",
               #"   SET lua20=(SELECT DISTINCT rto02 FROM ",l_dbs,"rto_file",                        #FUN-A50102 mark
                "   SET lua20=(SELECT DISTINCT rto02 FROM ",cl_get_target_table(l_plantstr,'rto_file'), #FUN-A50102
                "               WHERE rto01 = lua04",
                "                 AND rtoconf='Y')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql         #FUN-A50102
      EXECUTE IMMEDIATE g_sql
     #FUN-A80105 Begin--- By shi
     #LET g_sql="UPDATE lua_temp ",
     #         #"   SET lua08=(SELECT SUM(rxc06*COALESCE(rxc07,1)) FROM ",l_dbs,"rxc_file",                         #FUN-A50102 mark
     #          "   SET lua08=(SELECT SUM(rxc06*COALESCE(rxc07,1)) FROM ",cl_get_target_table(l_plantstr,'rxc_file'),  #FUN-A50102
     #          "               WHERE rxc04 = lua12)"
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
     #CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql         #FUN-A50102
     #EXECUTE IMMEDIATE g_sql
     #LET g_sql="UPDATE lua_temp ",
     #         #"   SET (lua21,lua22)=(SELECT DISTINCT rtu17,rtu18 FROM ",l_dbs,"rtu_file",                         #FUN-A50102 
     #          "   SET (lua21,lua22)=(SELECT DISTINCT rtu17,rtu18 FROM ",cl_get_target_table(l_plantstr,'rtu_file'),  #FUN-A50102  
     #          "                       WHERE rtu08=lua12",
     #          "                         AND rtuconf='Y')"
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
     #CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql         #FUN-A50102
     #EXECUTE IMMEDIATE g_sql
      LET g_sql="UPDATE lua_temp ",
                "   SET lua08t=(SELECT SUM(rxc06*COALESCE(rxc07,100)/100) ", #rxc06应该是含税金额
                "  FROM ",cl_get_target_table(l_plantstr,'rxc_file'),
                "               WHERE rxc04 = lua12)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql
      EXECUTE IMMEDIATE g_sql

      LET g_sql="UPDATE lua_temp ",
                "   SET lua21=(SELECT DISTINCT rtu17 FROM ",cl_get_target_table(l_plantstr,'rtu_file'),
                "               WHERE rtu08=lua12",
                "                 AND rtuconf='Y')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql
      EXECUTE IMMEDIATE g_sql
      LET g_sql="UPDATE lua_temp ",
                "   SET lua22=(SELECT DISTINCT rtu18 FROM ",cl_get_target_table(l_plantstr,'rtu_file'),
                "               WHERE rtu08=lua12",
                "                 AND rtuconf='Y')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql
      EXECUTE IMMEDIATE g_sql
     #FUN-A80105 End---- By shi
      LET g_sql="UPDATE lua_temp ",
                "   SET lua23=(SELECT gec07 FROM gec_file",
                "               WHERE gec01=lua21)"
      EXECUTE IMMEDIATE g_sql
     #UPDATE lua_temp SET lua02="02",
     #                    lua09=g_today,
      UPDATE lua_temp SET lua09=g_today,
                          lua11='2',
                          lua13='N',
                          lua14='0',
                          lua16=g_user,
                          lua17=g_today,
                          lua19=luaplant,
                          luauser=g_user,
                          luagrup=g_grup,
                          luacrat=g_today
   END WHILE  #TQC-C20400
   END FOR
   
   INSERT INTO lub_temp
  #SELECT lua01,1,'',lua08,lua08t,'',lua19,g_today,g_date,lualegal,luaplant
   SELECT lua01,1,'',lua08,lua08t,'',lua19,g_today,g_date,lualegal,luaplant,'',g_today,0,0,'N','','',''  #FUN-BC0125 add '',g_today,0,0,'N','','','' ->lub09,lub10,lub11,lub12,lub13,lub14,lub15,lub16
     FROM lua_temp
   UPDATE lub_temp SET lub03=(SELECT oaz83 FROM oaz_file)
   #FUN-BC0125 add begin--------------------------------------------
   LET g_sql="UPDATE lub_temp a",
             "   SET lub09=(SELECT DISTINCT oaj05 FROM ",cl_get_target_table(l_plantstr,'oaj_file'),
             "               WHERE oaj01 = a.lub03)"   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_plantstr) RETURNING g_sql
   EXECUTE IMMEDIATE g_sql
   #FUN-BC0125 add end----------------------------------------------
#  CALL p105_def_no('alm','01') RETURNING l_no   #FUN-A80105--mark--
   LET l_no = g_slip                             #FUN-A80105--mod--
   DECLARE lua_temp_cs CURSOR FOR SELECT * FROM lua_temp
   FOREACH lua_temp_cs INTO l_lua.*
#     CALL s_auto_assign_no("alm",l_no,g_today,"01","lua_file","lua01",l_lua.luaplant,"","")  #FUN-A80105--mark--
      CALL s_auto_assign_no("art",l_no,g_today,"B9","lua_file","lua01",l_lua.luaplant,"","")  #FUN-A80105--mod--
           RETURNING li_result,l_lua01
      IF (NOT li_result) THEN                                                                           
         LET g_success = 'N'
         CALL s_errmsg('lua01',l_no,'','sub-145',1)
      END IF  
     #FUN-A80105 Begin--- By shi
     #UPDATE lua_temp SET lua01=l_lua01 WHERE lua01=l_lua.lua01
     #UPDATE lub_temp SET lub01=l_lua01 WHERE lub01=l_lua.lua01
      LET l_lua.lua08 = l_lua.lua08t/(1+l_lua.lua22/100)
      UPDATE lua_temp SET lua01=l_lua01,lua08=l_lua.lua08
       WHERE lua01=l_lua.lua01
      UPDATE lub_temp SET lub01=l_lua01,lub04=l_lua.lua08 #只有一筆單身
       WHERE lub01=l_lua.lua01
     #FUN-A80105 End-----
   END FOREACH

   DECLARE ins_lua CURSOR FOR SELECT azp01 FROM lua_temp,azp_file  #TQC-A10073 azp03-->azp01
                               WHERE azp01=luaplant
   FOREACH ins_lua INTO l_azp01

      #TQC-A10073 ADD---------
       LET g_plant_new = l_azp01
       CALL s_gettrandbs()
       LET l_dbs = g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #TQC-A10073 ADD---------
     #LET g_sql="INSERT INTO ",s_dbstring(l_dbs),"lua_file ",              #FUN-A50102 mark
      LET g_sql="INSERT INTO ",cl_get_target_table(l_azp01,'lua_file'),    #FUN-A50102
                " SELECT lua_temp.* FROM lua_temp,azp_file ",
                " WHERE luaplant=azp01",
               #"   AND azp03='",l_dbs,"'"    #FUN-A80105 By shi
                "   AND azp01='",l_azp01,"'"  #FUN-A80105 By shi
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql         #FUN-A50102
      EXECUTE IMMEDIATE g_sql
     #LET g_sql="INSERT INTO ",s_dbstring(l_dbs),"lub_file ",              #FUN-A50102 mark
      LET g_sql="INSERT INTO ",cl_get_target_table(l_azp01,'lub_file'),    #FUN-A50102
                " SELECT lub_temp.* FROM lub_temp,azp_file ",
                " WHERE lubplant=azp01",
               #"   AND azp03='",l_dbs,"'"    #FUN-A80105 By shi
                "   AND azp01='",l_azp01,"'"  #FUN-A80105 By shi
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql         #FUN-A50102
      EXECUTE IMMEDIATE g_sql
   END FOREACH                           

  #FUN-A80105 Begin--- By shi
  ##No.TQC-AB0021  --Begin
  #DECLARE p105_p1 CURSOR FOR SELECT UNIQUE lubplant,lub01 FROM lub_file,azp_file
  #                            WHERE azp01 = lubplant
  #FOREACH p105_p1 INTO l_azp01,l_lub01
  #   LET g_sql="SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(l_azp01,'lub_file'),
  #             " WHERE lubplant = '",l_azp01,"'",
  #             "   AND lub01 = '",l_lub01,"'"
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
  #   PREPARE p105_p11 FROM g_sql
  #   EXECUTE p105_p11 INTO l_lub04,l_lub04t
  #   IF SQLCA.sqlcode THEN
  #      LET g_success = 'N'
  #      CALL s_errmsg('lub01',l_lub01,'sel lub04',SQLCA.sqlcode,1)
  #   END IF
  #   IF cl_null(l_lub04 ) THEN LET l_lub04  = 0 END IF
  #   IF cl_null(l_lub04t) THEN LET l_lub04t = 0 END IF

  #   LET g_sql="UPDATE ",cl_get_target_table(l_azp01,'lua_file'),
  #             "   SET lua08 = ?,lua08t = ? ",
  #             " WHERE luaplant = '",l_azp01,"'",
  #             "   AND lua01 = '",l_lub01,"'"
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
  #   PREPARE p105_p12 FROM g_sql
  #   EXECUTE p105_p12 USING l_lub04,l_lub04t
  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #      LET g_success = 'N'
  #      CALL s_errmsg('lua01',l_lub01,'upd lua08',SQLCA.sqlcode,1)
  #   END IF
  #END FOREACH
  ##No.TQC-AB0021  --End  
  #FUN-A80105 End-----

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION
 
#FUN-A50102 ------------------mark------------
#FUNCTION p105_find(p_dbs)
#DEFINE p_dbs LIKE azp_file.azp03
#DEFINE li_i LIKE type_file.num5    
#    
#    FOR li_i=1 TO ga_dbs.getLength()
#       IF ga_dbs[li_i].dbs=p_dbs THEN
#          RETURN li_i
#       END IF
#    END FOR
#    RETURN 0
#   
#ND FUNCTION
#FUN-A50102--------------------mark------------
 
#FUN-A50102 ----------------mark---------------
#FUNCTION p105_azp(l_azp01)
#DEFINE l_azp01  LIKE azp_file.azp01
#DEFINE l_azp03  LIKE azp_file.azp03
# 
#    LET g_errno=' '
#    SELECT azp03 INTO l_azp03 FROM azp_file 
#     WHERE azp01=l_azp01
#    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
#         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    RETURN l_azp03 CLIPPED
#END FUNCTION
#FUN-A50102 ---------------mark --------------
 
#FUN-C90050 mark begin---
#FUNCTION p105_def_no(l_rye01,l_rye02)
#DEFINE l_dbs   LIKE azp_file.azp03
#DEFINE l_rye01 LIKE rye_file.rye01
#DEFINE l_rye02 LIKE rye_file.rye02
#DEFINE l_sql STRING
#DEFINE l_no LIKE rva_file.rva01
#   LET l_sql = "SELECT rye03 FROM rye_file",
#               " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'",
#   PREPARE rye_trans FROM l_sql
#   EXECUTE rye_trans USING l_rye01,l_rye02 INTO l_no
#   IF cl_null(l_no) THEN
#      CALL s_errmsg('rye03',l_no,'rye_file','art-330',1)
#      LET g_success = 'N'
#      RETURN ''
#   END IF
#   
#   RETURN l_no
#END FUNCTION
#FUN-C90050 mark end-----
#FUN-870007-
 
