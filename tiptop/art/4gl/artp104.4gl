# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: artp104.4gl 
# Descriptions...:  生成合同費用單
# Date & Author..: FUN-960130 09/09/20 By sunyancun
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No:FUN-A50102 10/07/13 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A80022 10/08/04 By bnlent 接受變量g_plant改为g_allplant 
# Modify.........: No:FUN-A80105 10/08/19 By shaoyong 程式名稱調整"採購合約費用單批次產生作業",加入單別選項
# Modify.........: No:TQC-AA0143 10/10/29 By shiwuying 稅率欄位錯誤
# Modify.........: No:TQC-AB0012 10/11/02 By Carrier lua08/lua08t赋值
# Modify.........: No:TQC-AB0027 10/11/04 By Carrier lua23为含税否字段,非税率字段 & foreach cursor错误
# Modify.........: No:FUN-AB0095 10/11/24 By vealxu 批次產生採購合同費用程序中現在只有處理了固定費用，其他費用邏輯有寫，但沒有CALL
# Modify.........: No:TQC-AC0134 10/12/22 By shiwuying 稅率欄位報錯
# Modify.........: No:FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: No:MOD-B20085 11/02/18 By huangtao  計算保底費用的問題 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B50076 11/05/16 By shiwuying 合同有效期内最后一个月的期末的费用在合同最后一天收取
# Modify.........: No:FUN-B50171 11/05/31 By shiwuying 第一个月期初的费用在合同第一天开始收取
# Modify.........: No:FUN-BA0105 11/10/31 By pauline 加上背景作業功能
# Modify.........: No:FUN-BC0125 11/12/28 By suncx 費用單結構變化，調整對應的零售批處理程序artp104、artp105
# Modify.........: No:FUN-BB0117 12/01/05 By shiwuying lua05内部客户赋值
# Modify.........: No:TQC-C20400 12/02/22 By suncx 1、直接收款欄位賦值調整為N 2、批處理作業條件錄入調整
# Modify.........: No:FUN-C80095 12/08/27 By yangxf 產生週期不固定費用、返利費用以及保底費用，抓出貨銷退的時候，
#                                                   用出貨日期oga02,銷退日期oha02，採購入庫抓異動日期rvu03
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-C80041 13/02/06 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_date            LIKE oga_file.ogacond
DEFINE g_allplant        LIKE type_file.chr1000  #No.FUN-A80022
DEFINE g_vendor          LIKE type_file.chr1000
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_sql             STRING
DEFINE g_change_lang     LIKE type_file.num5
DEFINE g_begin_date      LIKE oga_file.ogacond
DEFINE g_end_date        LIKE oga_file.ogacond
DEFINE g_slip            LIKE rye_file.rye03    #No.FUN-A80105
DEFINE g_judu            LIKE azmm_file.azmm013 #FUN-BC0125 add

MAIN
   DEFINE ls_date  STRING 
   DEFINE l_flag   LIKE type_file.chr1
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

#FUN-BA0105 add START
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_date = ARG_VAL(1)
   LET g_vendor  = ARG_VAL(2)
  #LET g_plant = ARG_VAL(3)    #TQC-C20400 mark
   LET g_allplant = ARG_VAL(3) #TQC-C20400 add
   LET g_slip  = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob='N'
   END IF
#FUN-BA0105 add END
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 5 LET p_col = 30
#FUN-BA0105 mark START 
#   OPEN WINDOW p104_w AT p_row,p_col WITH FORM "art/42f/artp104"
#     ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#FUN-BA0105 mark END
   CALL cl_opmsg('z')
 
   SELECT azmm011,azmm012,azmm013 FROM azmm_file WHERE 1=0 INTO TEMP date_tmp
   WHILE TRUE
      IF g_bgjob='N' THEN       #FUN-BA0105 add
         CALL p104_p1()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init() #TQC-AC0134
            CALL p104_p2()
            CALL s_showmsg()      #TQC-AC0134
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               LET g_allplant=''  #No.FUN-A80022
               DISPLAY g_allplant TO plant  #No.FUN-A80022
               CONTINUE WHILE
            ELSE
       #        CLOSE WINDOW p102_w           #FUN-BA0105 mark
               CLOSE WINDOW p104_w            #FUN-BA0105 add
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
#FUN-BA0105 -------------STA
       ELSE
          LET g_success='Y'
          IF cl_null(g_date) OR g_date = '' THEN   #TQC-C20400
             LET g_date = g_today   #TQC-C20400
          END IF                    #TQC-C20400

          CALL p104_p2()
             IF g_success = 'Y' THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF
          EXIT WHILE
       END IF
#FUN-BA0105 -------------END
   END WHILE
#   CLOSE WINDOW p104_w  #FUN-BA0105 mark

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p104_p1()
DEFINE li_result       LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE lc_cmd          LIKE type_file.chr1000     #FUN-BA0105 add 
DEFINE l_sql           STRING                     #FUN-BA0105 add
#FUN-BA0105 add START
   OPEN WINDOW p104_w AT p_row,p_col WITH FORM "art/42f/artp104"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#FUN-BA0105 add END
  WHILE TRUE
     CLEAR FORM

     #FUN-C90050 mark begin---
     ##FUN-A80105--begin--
     #SELECT rye03 INTO g_slip FROM rye_file 
     # WHERE rye01 = 'art'
     #   AND rye02 = 'B9'
     ##FUN-A80105--end--
     #FUN-C90050 mark end-----
 
     CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_slip      #FUN-C90050 add

#    INPUT g_date,g_vendor,g_allplant WITHOUT DEFAULTS   #FUN-A80105--mark--
     INPUT g_date,g_vendor,g_allplant,g_slip  WITHOUT DEFAULTS   #FUN-A80105--mod--
        FROM moneydate,vendor,plant,slip
 
         BEFORE INPUT
            CALL cl_qbe_init()
            LET g_date = g_today


#FUN-BA0105 add START
         AFTER FIELD plant
            IF NOT cl_null(g_allplant) THEN
               CALL p104_chkplant()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD plant
               END IF
               LET l_sql = cl_replace_str(g_allplant,'|',"','")
               LET l_sql = "('",l_sql,"')"
            END IF
#FUN-BA0105 add END
       
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
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(plant)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azp"
                  LET g_qryparam.form = "q_azw"  #TQC-C20400 add
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = "(azw07='",g_plant,"' OR azw01='",g_plant,"')"  #TQC-C20400 add
                  LET g_qryparam.default1 = g_allplant       #No.FUN-A80022
                  CALL cl_create_qry() RETURNING g_allplant  #No.FUN-A80022
                  DISPLAY g_allplant TO plant                #No.FUN-A80022
                  NEXT FIELD plant
               WHEN INFIELD(vendor)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rty05_3"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_vendor
                  CALL cl_create_qry() RETURNING g_vendor
                  DISPLAY g_vendor TO vendor
                  NEXT FIELD vendor
#FUN-A80105--begin--
               WHEN INFIELD(slip) 
       #FUN-A80105 --------mod by huangtao
       #           CALL cl_init_qry_var()
       #           LET g_qryparam.form = "q_slip"
       #           LET g_qryparam.default1 = g_slip
       #           CALL cl_create_qry() RETURNING g_slip
                  CALL q_oay(FALSE,FALSE,g_slip,'B9','ART') RETURNING g_slip
       #FUN-A80105 --------mod
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
         CLOSE WINDOW p104_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF

 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-BA0105 add START
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
        CLOSE WINDOW p104_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
      END IF
#FUN-BA0105 add END
      EXIT WHILE
  END WHILE
#FUN-BA0105 -------------STA
   IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp104"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('artp104','9031',1)
     ELSE
        LET g_date = NULL   #TQC-C20400
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_date CLIPPED,"'",
                     " '",g_vendor CLIPPED,"'",
                     " '",g_allplant CLIPPED,"'",
                     " '",g_slip  CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('artp104',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p104_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
   END IF
#FUN-BA0105 -------------END
 
END FUNCTION

#FUN-BA0105 add START
FUNCTION p104_chkplant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
DEFINE l_n             LIKE type_file.num5
DEFINE l_str           STRING

        LET g_errno = ''
        LET l_str = g_auth
        LET tok = base.StringTokenizer.createExt(g_allplant,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           IF cl_null(l_ck) THEN CONTINUE WHILE END IF
           SELECT azp01 INTO l_azp01
             FROM azp_file WHERE azp01 = l_ck
           IF SQLCA.sqlcode = 100 THEN
              LET g_errno = 'art-044'
              RETURN
           END IF
           LET l_n = l_str.getindexof(l_ck,1)
           IF l_n = 0 THEN
              LET g_errno = 'art-500'
              RETURN
           END IF
       END WHILE

END FUNCTION
#FUN-BA0105 add END
 
FUNCTION p104_p2()
   #DEFINE l_date      LIKE oga_file.ogacond
   DEFINE l_date      LIKE type_file.num5
   DEFINE l_sql       STRING                  
   DEFINE l_chr       LIKE type_file.chr1
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_count         LIKE type_file.num5     #FUN-A80105
   DEFINE l_no        LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_ck        LIKE type_file.chr50
   DEFINE l_plant     LIKE type_file.chr50
#  DEFINE l_dbs       LIKE azp_file.azp03    #FUN-A50102
   DEFINE tok         base.StringTokenizer
   DEFINE tok1         base.StringTokenizer
   DEFINE l_lua       RECORD LIKE lua_file.*
   DEFINE l_rto01     LIKE rto_file.rto01
   DEFINE l_rto02     LIKE rto_file.rto02
   DEFINE l_rto03     LIKE rto_file.rto03
   DEFINE l_rto04     LIKE rto_file.rto04
   DEFINE l_rtr04     LIKE rtr_file.rtr04
   DEFINE l_vender    LIKE pmc_file.pmc01
   DEFINE l_rtoplant  LIKE rto_file.rtoplant
   DEFINE l_azmm      RECORD LIKE azmm_file.*
   DEFINE l_oaj05     LIKE oaj_file.oaj05   #FUN-AB0095 
   DEFINE l_rto05     LIKE rto_file.rto05    #TQC-AC0134 
   DEFINE l_vendor     LIKE rty_file.rty05        #TQC-C20400 add
   DEFINE l_vendor_str STRING                     #TQC-C20400 add
 
   LET tok = base.StringTokenizer.createExt(g_allplant,"|",'',TRUE)  #No.FUN-A80022
   LET g_cnt = 1
   WHILE tok.hasMoreTokens()
      LET l_plant = tok.nextToken()
#      IF l_plant IS NULL THEN CONTINUE WHILE END IF     #FUN-A80105   mark
#FUN-A80105 -------------start 
     IF cl_null(l_plant) THEN
         CONTINUE WHILE
      ELSE
         SELECT COUNT(*) INTO l_count  FROM azw_file WHERE azw01 = l_plant
         IF l_count = 0 THEN
             CONTINUE WHILE
         END IF
      END IF
#FUN-A80105 --------------end
     #TQC-A10073 MARK&ADD-------------------------------
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant 
#FUN-A50102 -----------------mark start-----------------------
#     LET g_plant_new = l_plant
#     CALL s_gettrandbs()
#     LET  l_dbs = g_dbs_tra
#    #TQC-A10073 MARK&ADD-------------------------------
#FUN-A50102 -----------------mark  end-----------------------
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','sel azp03','',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE WHILE
      END IF
#     LET l_dbs = s_dbstring(l_dbs CLIPPED)      #FUN-A50102
      
      LET l_date = YEAR(g_date)
#     LET l_sql = "SELECT * FROM ",l_dbs,"azmm_file ",                             #FUN-A50102 mark
      LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'azmm_file'),       #FUN-A50102
                  "   WHERE azmm00 = '",g_aza.aza81,"'",
                  "     AND azmm01 = '",l_date,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql          #FUN-A50102
      PREPARE pre_sel_azmm01 FROM l_sql
      EXECUTE pre_sel_azmm01 INTO l_azmm.*
      DELETE FROM date_tmp
      INSERT INTO date_tmp VALUES(l_azmm.azmm011,l_azmm.azmm012,l_azmm.azmm013)
      INSERT INTO date_tmp VALUES(l_azmm.azmm021,l_azmm.azmm022,l_azmm.azmm023)
      INSERT INTO date_tmp VALUES(l_azmm.azmm031,l_azmm.azmm032,l_azmm.azmm033)
      INSERT INTO date_tmp VALUES(l_azmm.azmm041,l_azmm.azmm042,l_azmm.azmm043)
      INSERT INTO date_tmp VALUES(l_azmm.azmm051,l_azmm.azmm052,l_azmm.azmm053)
      INSERT INTO date_tmp VALUES(l_azmm.azmm061,l_azmm.azmm062,l_azmm.azmm063)
      INSERT INTO date_tmp VALUES(l_azmm.azmm071,l_azmm.azmm072,l_azmm.azmm073)
      INSERT INTO date_tmp VALUES(l_azmm.azmm081,l_azmm.azmm082,l_azmm.azmm083)            
      INSERT INTO date_tmp VALUES(l_azmm.azmm091,l_azmm.azmm092,l_azmm.azmm093)
      INSERT INTO date_tmp VALUES(l_azmm.azmm101,l_azmm.azmm102,l_azmm.azmm103)
      INSERT INTO date_tmp VALUES(l_azmm.azmm111,l_azmm.azmm112,l_azmm.azmm113)
      INSERT INTO date_tmp VALUES(l_azmm.azmm121,l_azmm.azmm122,l_azmm.azmm123)
      INSERT INTO date_tmp VALUES(l_azmm.azmm131,l_azmm.azmm132,l_azmm.azmm133)
      #TQC-C20400 add start--------------
      IF cl_null(g_vendor) OR g_vendor='*' THEN
         LET l_vendor_str = NULL
         LET l_sql = "SELECT UNIQUE rto05 FROM ",cl_get_target_table(l_plant,"rto_file"),
                     ",",cl_get_target_table(l_plant,"pmc_file"),
                     " WHERE rto05=pmc01 AND '",g_date,"' BETWEEN rto08 AND rto09",
                     "   AND rtoconf='Y'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE p104_vendor_pre FROM l_sql
         DECLARE p104_vendor_cs CURSOR FOR p104_vendor_pre
         FOREACH p104_vendor_cs INTO l_vendor
            IF cl_null(l_vendor_str) THEN
               LET l_vendor_str=l_vendor
            ELSE
               LET l_vendor_str=l_vendor_str,'|',l_vendor
            END IF
         END FOREACH
      ELSE
         LET l_vendor_str = g_vendor
      END IF
      #TQC-C20400 add end----------------
      # LET tok1 = base.StringTokenizer.createExt(g_vendor,"|",'',TRUE)
       LET tok1 = base.StringTokenizer.createExt(l_vendor_str,"|",'',TRUE)   #TQC-C20400
      WHILE tok1.hasMoreTokens()
         LET l_vender = tok1.nextToken()
         IF l_vender IS NULL THEN CONTINUE WHILE END IF 
#FUN-A80105 ------------------mark------------------------------
#        SELECT rye03 INTO l_lua.lua01 FROM rye_file WHERE rye01 = 'art' AND rye02 = '01'  #FUN-A80105--mark--
#         LET l_lua.lua01 = g_slip                                                          
#        IF SQLCA.sqlcode THEN
#           CALL s_errmsg('','sel rye03','',SQLCA.sqlcode,1)
#           LET g_success='N'
#           CONTINUE WHILE
#        END IF 
#FUN-A80105 ------------------mark ----------------------------
#TQC-AC0134 -----------------STA
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'occ_file'),
                     " WHERE occ01 = '",l_vender,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE pre_sel_occ01 FROM l_sql
         EXECUTE pre_sel_occ01 INTO l_n
         IF l_n = 0 THEN
            CALL s_errmsg('',l_vender,'','art-852',1)
            CONTINUE WHILE
         END IF
#TQC-AC0134 -----------------END            
        #LET l_sql = "SELECT rto01,max(rto02),rto03,rtoplant FROM ",l_dbs,"rto_file ",                        #FUN-A50102 3mark
        #LET l_sql = "SELECT rto01,max(rto02),rto03,rtoplant FROM ",cl_get_target_table(l_plant,'rto_file'),  #FUN-A50102 #FUN-AB0095 mark
        #LET l_sql = "SELECT rto01,max(rto02),rto03,rtoplant,oaj05 FROM ",cl_get_target_table(l_plant,'rto_file'),",",    #FUN-AB0095 #FUN-BC0125 mark
        #             cl_get_target_table(l_plant,'rtr_file'),",",cl_get_target_table(l_plant,'oaj_file'),        #FUN-AB0095         #FUN-BC0125 mark
         LET l_sql = "SELECT rto01,max(rto02),rto03,rtoplant FROM ",cl_get_target_table(l_plant,'rto_file'),",",  #FUN-BC0125 
                      cl_get_target_table(l_plant,'rtr_file'),                                                    #FUN-BC0125
                     "   WHERE '",g_date,"' BETWEEN rto08 AND rto09 ",
                     "     AND rtoconf = 'Y' AND rto05 = '",l_vender,"'",
                     "     AND rto03 = '",l_plant,"' ",
                     "     AND rtoplant ='",l_plant,"'",
                    #"     AND rtr06= oaj01 ",                         #FUN-AB0095 #FUN-BC0125 mark
                     "     AND rtr01 = rto01 AND rtr02 = rto02 AND rtr03 = rto03 AND rtrplant = rtoplant ",   #FUN-AB0095  
                    #"  GROUP BY rto01,rto03,rtoplant,oaj05 "                                                 #FUN-AB0095 add oaj05 #FUN-BC0125 mark
                     "  GROUP BY rto01,rto03,rtoplant"                 #FUN-BC0125 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102 
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql          #FUN-A50102
         PREPARE pre_sel_rto01 FROM l_sql
         DECLARE cur_rto01 CURSOR FOR pre_sel_rto01
        #FOREACH cur_rto01 INTO l_rto01,l_rto02,l_rto03,l_rtoplant,l_oaj05                   #FUN-AB0095 add l_oaj05  #FUN-BC0125 mark
         FOREACH cur_rto01 INTO l_rto01,l_rto02,l_rto03,l_rtoplant           #FUN-BC0125
           #LET l_sql = "SELECT rto08,rto09 FROM ",l_dbs,"rto_file ",                        #FUN-A50102 mark
            LET l_sql = "SELECT rto05,rto08,rto09 FROM ",cl_get_target_table(l_plant,'rto_file'),  #FUN-A50102
                        "  WHERE rto01 = '",l_rto01,"' AND rto02 = '",l_rto02,"'",
                        "    AND rto03 = '",l_rto03,"' AND rtoplant = '",l_rtoplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql          #FUN-A50102 
            PREPARE pre_sel_rto08 FROM l_sql
            EXECUTE pre_sel_rto08 INTO l_rto05,g_begin_date,g_end_date
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('','sel rye03','',SQLCA.sqlcode,1)
               LET g_success='N'
               CONTINUE FOREACH 
            END IF 

            LET l_lua.lua01 = g_slip                                   #FUN-A80105
#           CALL s_auto_assign_no("alm",l_lua.lua01,g_today,'01',"lua_file","lua01","","",l_plant)  #FUN-A80105--mark--
#           CALL s_auto_assign_no("art",l_lua.lua01,g_today,'B9',"lua_file","lua01","","",l_plant)  #FUN-A80105--mod--    #FUN-AB0095 
            CALL s_auto_assign_no("art",l_lua.lua01,g_today,'B9',"lua_file","lua01",l_plant,"","")                   #FUN-AB0095 
               RETURNING li_result,l_lua.lua01
            IF (NOT li_result) THEN CONTINUE FOREACH END IF 
         #  LET l_lua.lua02 = '02'   #FUN-AB0095 mark
         #  LET l_lua.lua02 = l_oaj05   #FUN-AB0095   #FUN-BC0125 mark 
            LET l_lua.lua04 = l_rto01
            LET l_lua.lua06 = l_vender
            LET l_lua.lua08 = 0
            LET l_lua.lua08t = 0
         #  LET l_lua.lua09 = g_today     #FUN-AB0095
            LET l_lua.lua09 = g_date      #FUN-AB0095
            LET l_lua.lua10 = 'Y'
            LET l_lua.lua11 = '1'
            LET l_lua.lua12 = l_rto01
            LET l_lua.lua13 = 'N'
            LET l_lua.lua14 = '0'
            LET l_lua.lua15 = 'N'
            LET l_lua.luauser = g_user
            LET l_lua.luamodu = NULL 
            LET l_lua.luagrup = g_grup
            LET l_lua.luacrat = g_today
            LET l_lua.luaacti = 'Y'
            LET l_lua.lua19 = l_rtoplant #TQC-AA0143 Add lua19
            LET l_lua.lua20 = l_rto02
            LET l_lua.lua35 = 0    #FUN-BC0125
            LET l_lua.lua36 = 0    #FUN-BC0125
            LET l_lua.luaplant = l_rtoplant
            SELECT azw02 INTO l_lua.lualegal FROM azw_file WHERE azw01 = l_rtoplant

#FUN-A80105--begin--
#          #LET l_sql = "INSERT INTO ",l_dbs,"lua_file ",	                    #FUN-A50102 mark
#          LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'lua_file'),      #FUN-A50102 
#                       "(lua01,lua02,lua04,lua06,lua08,",
#                       " lua08t,lua09,lua10,lua12,lua13,",
#                       " lua14,lua15,luauser,luamodu,luagrup,",
##                      " luacrat,luaacti,lua20,luaplant,lualegal)",           #FUN-A80105--mark--
#                       " luacrat,luaacti,lua20,luaplant,lualegal,lua32)",           #FUN-A80105--mod--
#                       "   VALUES(?,?,?,?,?, ?,?,?,?,?, ",
##                      "          ?,?,?,?,?, ?,?,?,?,?)"                      #FUN-A80105--mark--
#                       "          ?,?,?,?,?, ?,?,?,?,?,?)"                      #FUN-A80105--mod--
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql                        #FUN-A50102
#           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                #FUN-A50102  
#           PREPARE pre_ins_lua FROM l_sql
#           EXECUTE pre_ins_lua USING 
#               l_lua.lua01,l_lua.lua02,l_lua.lua04,l_lua.lua06,l_lua.lua08,
#               l_lua.lua08t,l_lua.lua09,l_lua.lua10,l_lua.lua12,l_lua.lua13,
#               l_lua.lua14,l_lua.lua15,l_lua.luauser,l_lua.luamodu,l_lua.luagrup,
##              l_lua.luacrat,l_lua.luaacti,l_lua.lua20,l_lua.luaplant,l_lua.lualegal        #FUN-A80105--mark--
#               l_lua.luacrat,l_lua.luaacti,l_lua.lua20,l_lua.luaplant,l_lua.lualegal,'0'    #FUN-A80105--mod--
#           IF SQLCA.sqlcode THEN 
#              CALL s_errmsg('','ins lua_file','',SQLCA.sqlcode,1)
#              LET g_success='N'
#              CONTINUE FOREACH 
#           END IF
#          #LET l_sql = "SELECT pmc47,gec04,gec07 FROM ",l_dbs,"pmc_file,",l_dbs,"gec_file ",    	  #FUN-A50102 mark
#           LET l_sql = "SELECT pmc47,gec04,gec07 FROM ",cl_get_target_table(l_plant,'pmc_file'),",",     #FUN-A50102
#                                                        cl_get_target_table(l_plant,'gec_file'),         #FUN-A50102
#                       "   WHERE pmc01 = '",l_vender,"' AND pmc47 = gec01 ",
#                       "     AND gec011 = '1' "
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
#           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-A50102
#           PREPARE pre_sel_pmc FROM l_sql
#           EXECUTE pre_sel_pmc INTO l_lua.lua21,l_lua.lua22,l_lua.lua23

#TQC-AC0134 ---------------------STA
#          #LET l_sql = "SELECT pmc47,gec04,gec07 FROM ",l_dbs,"pmc_file,",l_dbs,"gec_file ",             #FUN-A50102 mark
#           LET l_sql = "SELECT pmc47,gec04,gec07 FROM ",cl_get_target_table(l_plant,'pmc_file'),",",     #FUN-A50102
#                                                        cl_get_target_table(l_plant,'gec_file'),         #FUN-A50102
#                       "   WHERE pmc01 = '",l_vender,"' AND pmc47 = gec01 ",
#                       "     AND gec011 = '1' "
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
#           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-A50102
#           PREPARE pre_sel_pmc FROM l_sql
#           EXECUTE pre_sel_pmc INTO l_lua.lua21,l_lua.lua22,l_lua.lua23
#          #TQC-AC0134 Begin---
#           IF cl_null(l_lua.lua21) THEN
#              CALL s_errmsg('','sel pmc47','','art-493',1)
#              LET g_success='N'
#              CONTINUE FOREACH
#           END IF
#          #TQC-AC0134 End-----
            LET l_sql = "SELECT occ41,gec04,gec07 FROM ",cl_get_target_table(l_plant,'occ_file'),",",
                                                         cl_get_target_table(l_plant,'gec_file'), 
                       "   WHERE occ01 = '",l_vender,"' AND occ41 = gec01 ",
                       "     AND gec011 = '2' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE pre_sel_pmc FROM l_sql
            EXECUTE pre_sel_pmc INTO l_lua.lua21,l_lua.lua22,l_lua.lua23
            IF cl_null(l_lua.lua21) THEN
               CALL s_errmsg('','sel occ41','','art-493',1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
#TQC-AC0134 ---------------------END

         #FUN-BB0117 Begin---
          IF s_chk_own(l_lua.lua06) THEN
              LET l_lua.lua05 = 'Y'
              #LET l_lua.lua37 = 'N'   #TQC-C20400 mark
          ELSE
              LET l_lua.lua05 = 'N'
              #LET l_lua.lua37 = 'Y'   #TQC-C20400 mark
          END IF
         #FUN-BB0117 End-----
          LET l_lua.lua37 = 'N'   #TQC-C20400 add

          ##LET l_sql = "INSERT INTO ",l_dbs,"lua_file ",                       #FUN-A50102 mark
           LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'lua_file'),  #FUN-A50102
                       "(lua01,lua02,lua04,lua06,lua08,",
                     # " lua08t,lua09,lua10,lua12,lua13,",                     #FUN-A80105  mark
                       " lua08t,lua09,lua10,lua11,lua12,lua13,",               #FUN-A80105 
                       " lua14,lua15,luauser,luamodu,luagrup,",
                     # " luacrat,luaacti,lua20,luaplant,lualegal)",            #FUN-A80105--mark--
                     # " luacrat,luaacti,lua19,lua20,luaplant,lualegal,lua32,lua21,lua22,lua23,lua05)", #FUN-A80105--mod-- #TQC-AA0143 Add lua19#TQC-AC0134
                       " luacrat,luaacti,lua19,lua20,luaplant,lualegal,",      #FUN-BC0125
                       " lua32,lua21,lua22,lua23,lua05,lua35,lua36,lua37)",    #FUN-BC0125
                       "   VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                     # "          ?,?,?,?,?, ?,?,?,?,?)"                       #FUN-A80105--mark--
                       "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"         #FUN-A80105--mod-- #TQC-AA0143 Add lua19 ##TQC-AC0134
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                        #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                #FUN-A50102
            PREPARE pre_ins_lua FROM l_sql
            EXECUTE pre_ins_lua USING
                l_lua.lua01,l_lua.lua02,l_lua.lua04,l_lua.lua06,l_lua.lua08,
               #l_lua.lua08t,l_lua.lua09,l_lua.lua10,l_lua.lua12,l_lua.lua13,                  #FUN-A80105  mark
                l_lua.lua08t,l_lua.lua09,l_lua.lua10,l_lua.lua11,l_lua.lua12,l_lua.lua13,      #FUN-A80105
                l_lua.lua14,l_lua.lua15,l_lua.luauser,l_lua.luamodu,l_lua.luagrup,
               #l_lua.luacrat,l_lua.luaacti,l_lua.lua20,l_lua.luaplant,l_lua.lualegal        #FUN-A80105--mark--
                l_lua.luacrat,l_lua.luaacti,l_lua.lua19,l_lua.lua20,l_lua.luaplant,l_lua.lualegal,'0',    #FUN-A80105--mod-- #TQC-AA0143 Add lua19
               #l_lua.lua21,l_lua.lua22,l_lua.lua23,'0'    #TQC-AC0134 Add lua05  #FUN-AC0062
               #l_lua.lua21,l_lua.lua22,l_lua.lua23,' '    #FUN-AC0062  #FUN-BB0117
                l_lua.lua21,l_lua.lua22,l_lua.lua23,l_lua.lua05,        #FUN-BB0117
                l_lua.lua35,l_lua.lua36,l_lua.lua37    #FUN-BC0125 
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','ins lua_file','',SQLCA.sqlcode,1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
#FUN-A80105--end--

            LET l_lua.luaplant = l_plant
            SELECT azw02 INTO l_lua.lualegal FROM azw_file WHERE azw01 = l_plant
            
           #LET l_sql = "SELECT DISTINCT rtr04 FROM ",l_dbs,"rtr_file ",                         #FUN-A50102 mark
            LET l_sql = "SELECT DISTINCT rtr04 FROM ",cl_get_target_table(l_plant,'rtr_file'),   #FUN-A50102 
                        "  WHERE rtr01 = '",l_rto01,"'",
                        "    AND rtr02 = '",l_rto02,"'",
                        "    AND rtr03 = '",l_rto03,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                     #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql             #FUN-A50102
            PREPARE pre_sel_rtr04 FROM l_sql
            DECLARE cur_rtr04 CURSOR FOR pre_sel_rtr04
            FOREACH cur_rtr04 INTO l_rtr04
               IF l_rtr04 IS NULL THEN CONTINUE FOREACH END IF 
#FUN-AB0095 ------------mark start ------------
#              IF l_rtr04 = '1' THEN 
#                #CALL create_money1(l_lua.lua01,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_dbs)   #FUN-A50102 mark
#                 CALL create_money1(l_lua.lua01,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant) #FUN-A50102
#              END IF 
#              IF l_rtr04 = '2' THEN 
#                #CALL create_money2(l_lua.lua01,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_dbs)   #FUN-A50102 mark
#                 CALL create_money2(l_lua.lua01,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant) #FUN-A50102
#              END IF
#FUN-AB0095 ------------mark end--------------

#FUN-AB0095 -----------add start--------------
               CASE l_rtr04
                  WHEN '1'
                      CALL create_money1(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  WHEN '2'
                      CALL create_money2(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  WHEN '3'
                      CALL create_money3(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  WHEN '4'
                      CALL create_money4(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  WHEN '5'
                      CALL create_money5(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  WHEN '6'
                      CALL create_money6(l_lua.lua01,l_lua.lua06,l_rto01,l_rto02,l_rto03,l_rtr04,l_lua.luaplant,l_lua.lualegal,l_plant,l_oaj05)   #FUN-AB0095 add l_oaj05
                  OTHERWISE EXIT CASE
               END CASE
#FUN-AB0095 -----------add end-----------------
            END FOREACH 
            CALL p104_delall(l_lua.lua01)      #FUN-AB0095
         END FOREACH
      END WHILE 
   END WHILE
 
END FUNCTION
 
#FUNCTION create_money1(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)     #FUN-A50102 mark
FUNCTION create_money1(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05)  #FUN-A50102   #FUN-AB0095 add oaj05
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_legal      LIKE azw_file.azw02
#DEFINE p_dbs        LIKE azp_file.azp03   #FUN-A50102 mark
DEFINE p_plant1    LIKE azp_file.azp01    #FUN-A50102 
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_rtr05      LIKE rtr_file.rtr05
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr07      LIKE rtr_file.rtr07
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_lub04      LIKE lub_file.lub04    #No.TQC-AB0012
DEFINE l_lub04t     LIKE lub_file.lub04t   #No.TQC-AB0012
DEFINE p_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095 
DEFINE l_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095
DEFINE p_lua06      LIKE lua_file.lua06    #FUN-AB0095
 
   LET l_lub.lub01 = p_no
#  LET g_sql = "SELECT lua21,lua22,lua23 FROM ",p_dbs,"lua_file ",                              #FUN-A50102 mark
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'),      #FUN-A50102
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql       #FUN-A50102
   PREPARE pre_sel_lua21 FROM g_sql
   EXECUTE pre_sel_lua21 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
   
#  LET g_sql = "SELECT rtr05,rtr06,rtr07,rtr10 FROM ",p_dbs,"rtr_file ",                          #FUN-A50102 mark
   LET g_sql = "SELECT rtr05,rtr06,rtr07,rtr10 FROM ",cl_get_target_table(p_plant1,'rtr_file'),  #FUN-A50102    
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'" 
              ,"     AND rtrplant = '",p_plant,"'"                              #FUN-AB0095
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql        #FUN-A50102    
   PREPARE pre_sel_rtr1 FROM g_sql
   DECLARE cur_rtr1 CURSOR FOR pre_sel_rtr1
#  LET l_cnt = 1     #FUN-AB0095
   
   FOREACH cur_rtr1 INTO l_rtr05,l_rtr06,l_rtr07,l_rtr10
      IF l_rtr07 IS NULL THEN CONTINUE FOREACH END IF 
      IF l_rtr07 < g_begin_date OR l_rtr07 > g_end_date THEN 
       # CALL s_errmsg('',l_rtr07,'',SQLCA.sqlcode,1)     #FUN-AB0095 mark
       # LET g_success='N'                                #FUN-AB0095 mark
         CONTINUE FOREACH 
      END IF
      IF l_rtr07 != g_date THEN CONTINUE FOREACH END IF
     #FUN-AB0095 ---------add start----------------
      LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'), 
                  " WHERE oaj01 = '",l_rtr06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel01 FROM g_sql
      EXECUTE pre_sel01 INTO l_oaj05 
     #FUN-BC0125 mark---------------
     #IF l_oaj05 !=  p_oaj05 THEN
     #   CONTINUE FOREACH
     #END IF
     #FUN-BC0125 mark end-----------

      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                          cl_get_target_table(p_plant1,'lua_file'),
                  " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
                  "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
                  "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
                  "   AND lub03 =    '",l_rtr06,"'"                    
      PREPARE pre_sel_count01 FROM g_sql
      EXECUTE pre_sel_count01 INTO g_cnt   
      IF g_cnt != 0 THEN
         CONTINUE FOREACH
      END IF 
     #FUN-AB0095 ---------add end----------------- 
      
      LET l_lub.lub02 = l_cnt
      LET l_lub.lub03 = l_rtr06 
      IF l_lua23 = 'Y' THEN
         LET l_lub.lub04t = l_rtr10
        #LET l_lub.lub04 = l_rtr10/(1+l_lua23/100) #TQC-AA0143
         LET l_lub.lub04 = l_rtr10/(1+l_lua22/100) #TQC-AA0143
      ELSE
      	 LET l_lub.lub04 = l_rtr10
      	#LET l_lub.lub04t = l_rtr10*(1+l_lua23/100) #TQC-AA0143
      	 LET l_lub.lub04t = l_rtr10*(1+l_lua22/100) #TQC-AA0143
      END IF
      LET l_lub.lub07 = g_begin_date #FUN-BC0125
      LET l_lub.lub08 = g_end_date   #FUN-BC0125 
      LET l_lub.lub09 = l_oaj05      #FUN-BC0125
      LET l_lub.lub10 = g_date       #FUN-BC0125
      LET l_lub.lub11 = 0            #FUN-BC0125
      LET l_lub.lub12 = 0            #FUN-BC0125
      LET l_lub.lubplant = p_plant
      LET l_lub.lublegal = p_legal
#FUN-AB0095 ---------------------------add start ----------
      LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),
               "   WHERE lub01 = '",p_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_lub033 FROM g_sql
      EXECUTE pre_sel_lub033 INTO l_lub.lub02
      IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#FUN-AB0095 -------------------------add end ---------------
     #LET g_sql = "INSERT INTO ",p_dbs,"lub_file(",                                #FUN-A50102 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'), "(",   #FUN-A50102
                 #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal)",
                 #" VALUES(?,?,?,?,?, ?,?) "
                  "lub01,lub02,lub03,lub04,lub04t,lub09,lub10,lubplant,lublegal,lub11,lub12,lub07,lub08)",  #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                    #FUN-BC0125 add ?,?,?,?,?,?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql     #FUN-A50102
      PREPARE pre_ins_rub111 FROM g_sql
      EXECUTE pre_ins_rub111 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                                 l_lub.lub04,l_lub.lub04t,l_lub.lub09,l_lub.lub10,  #FUN-BC0125 add lub09,lub10 
                                 l_lub.lubplant,l_lub.lublegal,
                                 l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08    #FUN-BC0125 add lub11,lub12,lub07,lub08
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF

    # LET l_cnt = l_cnt +1    #FUN-AB0095 mark 
   END FOREACH  

   #No.TQC-AB0012  --Begin
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql 
   PREPARE pre_lub04_p1 FROM g_sql
   EXECUTE pre_lub04_p1 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p2 FROM g_sql
   EXECUTE pre_lub04_p2 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   #No.TQC-AB0012  --End  
END FUNCTION
 
#FUNCTION create_money2(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)      #FUN-A50102  mark
FUNCTION create_money2(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05)   #FUN-A50102   #FUN-AB0095 add oaj05
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_legal      LIKE azw_file.azw02
#DEFINE p_dbs        LIKE azp_file.azp03     #FUN-A50102
DEFINE p_plant1     LIKE azp_file.azp01      #FUN-A50102 
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_dbs        LIKE azp_file.azp03
DEFINE l_rtr05      LIKE rtr_file.rtr05
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr08      LIKE rtr_file.rtr08
DEFINE l_rtr09      LIKE rtr_file.rtr09
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_date       LIKE azmm_file.azmm011
DEFINE l_lub04      LIKE lub_file.lub04    #No.TQC-AB0012
DEFINE l_lub04t     LIKE lub_file.lub04t   #No.TQC-AB0012
DEFINE p_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095
DEFINE l_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095
DEFINE p_lua06      LIKE lua_file.lua06    #FUN-AB0095
 
#  LET l_dbs = p_dbs               #FUN-A50102 mark
   LET l_lub.lub01 = p_no
#  LET g_sql = "SELECT lua21,lua22,lua23 FROM ",l_dbs,"lua_file ",                             #FUN-A50102 mark
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'),     #FUN-A50102
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql       #FUN-A50102
   PREPARE pre_sel_lua22 FROM g_sql
   EXECUTE pre_sel_lua22 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
      
#  LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10 FROM ",l_dbs,"rtr_file ",                         #FUN-A50102 mark
   LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10 FROM ",cl_get_target_table(p_plant1,'rtr_file'), #FUN-A50102    
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'"
              ,"     AND rtrplant = '",p_plant,"'"             #FUN-AB0095
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql      #FUN-A50102
   PREPARE pre_sel_rtr2 FROM g_sql
   DECLARE cur_rtr2 CURSOR FOR pre_sel_rtr2
   LET l_cnt = 1
   
#  FOREACH cur_rtr1 INTO l_rtr05,l_rtr06,l_rtr08,l_rtr09,l_rtr10   #No.TQC-AB0027
   FOREACH cur_rtr2 INTO l_rtr05,l_rtr06,l_rtr08,l_rtr09,l_rtr10   #No.TQC-AB0027
      IF l_rtr08 IS NULL THEN CONTINUE FOREACH END IF
      IF l_rtr09 IS NULL THEN CONTINUE FOREACH END IF 
      IF l_rtr10 IS NULL THEN LET l_rtr10 = 0 END IF 
      CALL p104_compute_date(l_rtr08,l_rtr09) RETURNING l_date
     #FUN-AB0095 ---------add start----------------
      LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'),
                  " WHERE oaj01 = '",l_rtr06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel02 FROM g_sql
      EXECUTE pre_sel02 INTO l_oaj05
     #FUN-BC0125 mark---------------
     #IF l_oaj05 !=  p_oaj05 THEN
     #   CONTINUE FOREACH
     #END IF
     #FUN-BC0125 mark end-----------
   
      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                          cl_get_target_table(p_plant1,'lua_file'),
                  " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
                  "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
                  "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
                  "   AND lub03 =    '",l_rtr06,"'"
      PREPARE pre_sel_count02 FROM g_sql
      EXECUTE pre_sel_count02 INTO g_cnt
      IF g_cnt != 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-AB0095 ---------add end-----------------
      
     #IF NOT (l_rtr09 = '2' AND g_end_date = g_date) THEN #TQC-B50076 #FUN-B50171
      IF NOT ((l_rtr09 = '2' AND g_end_date = g_date) OR (l_rtr09 = '1' AND g_begin_date = g_date)) THEN #FUN-B50171
        #第一个月期初的在合同第一天收取，最后一个月期末的在最后一天收取
         IF l_date < g_begin_date OR l_date > g_end_date THEN 
          # CALL s_errmsg('',l_date,'',SQLCA.sqlcode,1)   #FUN-AB0095 mark
          # LET g_success='N'    #FUN-AB0095 mark
            CONTINUE FOREACH 
         END IF
         IF l_date != g_date THEN
            CONTINUE FOREACH 
         END IF
      END IF #TQC-B50076
      
    # LET l_lub.lub02 = l_cnt       #FUN-AB0095 mark      
      LET l_lub.lub03 = l_rtr06  
      IF l_lua23 = 'Y' THEN
         LET l_lub.lub04t = l_rtr10
        #LET l_lub.lub04 = l_rtr10/(1+l_lua23/100)   #No.TQC-AB0027
         LET l_lub.lub04 = l_rtr10/(1+l_lua22/100)   #No.TQC-AB0027
      ELSE
      	 LET l_lub.lub04 = l_rtr10
      	#LET l_lub.lub04t = l_rtr10*(1+l_lua23/100)  #No.TQC-AB0027
      	 LET l_lub.lub04t = l_rtr10*(1+l_lua22/100)  #No.TQC-AB0027
      END IF
      CALL p104_get_lub07_lub08(l_rtr08,'','') RETURNING l_lub.lub07,l_lub.lub08,g_judu #FUN-BC0125 
      LET l_lub.lub09 = l_oaj05      #FUN-BC0125
      LET l_lub.lub10 = g_date       #FUN-BC0125
      LET l_lub.lub11 = 0            #FUN-BC0125
      LET l_lub.lub12 = 0            #FUN-BC0125
      LET l_lub.lubplant = p_plant
      LET l_lub.lublegal = p_legal
#FUN-AB0095 ---------------------------add start ----------
      LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),
               "   WHERE lub01 = '",p_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_lub032 FROM g_sql
      EXECUTE pre_sel_lub032 INTO l_lub.lub02
      IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#FUN-AB0095 -------------------------add end ---------------
#     LET g_sql = "INSERT INTO ",l_dbs,"lub_file(",	                      #FUN-A50102 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",    #FUN-A50102
                 #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal)",
                 #" VALUES(?,?,?,?,?, ?,?) "
                  "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-A50102
      PREPARE pre_ins_rub12 FROM g_sql
      EXECUTE pre_ins_rub12 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                                 l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                                 l_lub.lublegal,l_lub.lub09,l_lub.lub10,             #FUN-BC0125 add lub09,lub10
                                 l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08     #FUN-BC0125 add lub11,lub12,lub07,lub08
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF
    # LET l_cnt = l_cnt +1         #FUN-AB0095  
   END FOREACH  
   #No.TQC-AB0012  --Begin
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql 
   PREPARE pre_lub04_p3 FROM g_sql
   EXECUTE pre_lub04_p3 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p4 FROM g_sql
   EXECUTE pre_lub04_p4 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   #No.TQC-AB0012  --End  
END FUNCTION 
 
#FUN-AB0095-------------取消mark -------------------------
#FUN-A50102 -----------mark start--------------------
#FUNCTION create_money3(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)   #FUN-AB0095 mark
FUNCTION create_money3(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05) #FUN-AB0095 add    #FUN-AB0095 add oaj05
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_plant1     LIKE azp_file.azp01    #FUN-AB0095
DEFINE p_legal      LIKE azw_file.azw02
DEFINE p_dbs        LIKE azp_file.azp03
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_dbs        LIKE azp_file.azp03
DEFINE l_rtr05      LIKE rtr_file.rtr05
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr08      LIKE rtr_file.rtr08
DEFINE l_rtr09      LIKE rtr_file.rtr09
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_rtr11      LIKE rtr_file.rtr12
DEFINE l_rtr12      LIKE rtr_file.rtr12
DEFINE l_rtr13      LIKE rtr_file.rtr13
DEFINE l_rtr14      LIKE rtr_file.rtr14
DEFINE l_rtr15      LIKE rtr_file.rtr15
DEFINE l_get_money  LIKE ogb_file.ogb14
DEFINE l_get_money_sum LIKE ogb_file.ogb14     #MOD-B20085
DEFINE l_exit_money  LIKE ogb_file.ogb14
DEFINE l_exit_money_sum LIKE ogb_file.ogb14    #MOD-B20085
DEFINE l_min_date   LIKE azmm_file.azmm011
DEFINE l_max_date   LIKE azmm_file.azmm012
DEFINE l_date       LIKE azmm_file.azmm012
DEFINE l_lub04      LIKE lub_file.lub04    #No.FUN-AB0095
DEFINE l_lub04t     LIKE lub_file.lub04t   #No.FUN-AB0095
DEFINE p_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095
DEFINE l_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095	
DEFINE p_lua06      LIKE lua_file.lua06    #FUN-AB0095
DEFINE l_rtp05      LIKE rtp_file.rtp05    #MOD-B20085  add
 
   LET l_dbs = p_dbs
   LET l_lub.lub01 = p_no
#  LET g_sql = "SELECT lua21,lua22,lua23 FROM ",l_dbs,"lua_file ",                         #FUN-AB0095 mark
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'),  #FUN-AB0095 
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-AB0095 
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql      #FUN-AB0095 
   PREPARE pre_sel_lua223 FROM g_sql
   EXECUTE pre_sel_lua223 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
      
#  LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10,rtr11,rtr12,rtr14,rtr15 FROM ",l_dbs,"rtr_file ",                       #FUN-AB0095 mark
   LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10,rtr11,rtr12,rtr14,rtr15 FROM ",cl_get_target_table(p_plant1,'rtr_file'),#FUN-AB0095
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'"
              ,"     AND rtrplant = '",p_plant,"'"            #FUN-AB0095 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql      #FUN-AB0095
   PREPARE pre_sel_rtr23 FROM g_sql
   DECLARE cur_rtr23 CURSOR FOR pre_sel_rtr23
   LET l_cnt = 1
   
   FOREACH cur_rtr23 INTO l_rtr05,l_rtr06,l_rtr08,l_rtr09,l_rtr10,l_rtr11,l_rtr12,l_rtr14,l_rtr15
      IF l_rtr08 IS NULL THEN CONTINUE FOREACH END IF
      IF l_rtr09 IS NULL THEN CONTINUE FOREACH END IF 
      IF l_rtr10 IS NULL THEN LET l_rtr10 = 0 END IF
     #FUN-AB0095 ---------add start----------------
      LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'),
                  " WHERE oaj01 = '",l_rtr06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel03 FROM g_sql
      EXECUTE pre_sel03 INTO l_oaj05
     #FUN-BC0125 mark---------------
     #IF l_oaj05 !=  p_oaj05 THEN
     #   CONTINUE FOREACH
     #END IF
     #FUN-BC0125 mark end-----------

      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                          cl_get_target_table(p_plant1,'lua_file'),
                  " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
                  "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
                  "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
                  "   AND lub03 =    '",l_rtr06,"'"
      PREPARE pre_sel_count03 FROM g_sql
      EXECUTE pre_sel_count03 INTO g_cnt
      IF g_cnt != 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-AB0095 ---------add end-----------------
 
      CALL p104_compute_date(l_rtr08,l_rtr09) RETURNING l_date   
      IF NOT (l_rtr09 = '2' AND g_end_date = g_date) THEN #TQC-B50076
         IF l_date < g_begin_date OR l_date > g_end_date THEN 
          # CALL s_errmsg('',l_date,'',SQLCA.sqlcode,1)   #FUN-AB0095 mark
          # LET g_success='N'    #FUN-AB0095 mark
            CONTINUE FOREACH 
         END IF
         IF l_date != g_date THEN
            CONTINUE FOREACH 
         END IF
      END IF #TQC-B50076
   
      #CALL p104_compute_date1(l_rtr08) RETURNING l_min_date,l_max_date  #FUN-BC0125 mark
      CALL p104_get_lub07_lub08(l_rtr08,'','') RETURNING l_min_date,l_max_date,g_judu #FUN-BC0125 add
   
#MOD-B20085 ----------------STA
      LET l_get_money_sum = 0
      LET l_exit_money_sum = 0
      LET  g_sql = " SELECT rtp05 FROM ",cl_get_target_table(p_plant1,'rtp_file'),
                   " WHERE rtp01 = '",p_rto01,"' AND rtp02 = '",p_rto02,"'",
                   "   AND rtp03 = '",p_rto03,"' AND rtpplant = '",p_plant1,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_rtp05_1 FROM g_sql
      DECLARE sel_rtp05_1 CURSOR FOR pre_sel_rtp05_1
      FOREACH sel_rtp05_1 INTO l_rtp05      
#MOD-B20085 ----------------END
         IF l_rtr11 = '3' THEN 
          # LET g_sql = "SELECT sum(rvv39t) FROM ",l_dbs,"rvv_file,",l_dbs,"rvu_file ",                      #FUN-AB0095 mark
#MOD-B20085 ----------------STA
#           LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(p_plant1,'rvv_file'),",",             #FUN-AB0095  
#                                                  cl_get_target_table(p_plant1,'rvu_file'),                 #FUN-AB0095  
             LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(l_rtp05,'rvv_file'),",",                          
                                                  cl_get_target_table(l_rtp05,'rvu_file'),                                
#MOD-B20085 ---------------END
                        "  WHERE rvu00 = rvv03 AND rvuplant = rvvplant ",
                        "    AND rvuconf = 'Y' AND rvu00 = '1' ",
#                        "    AND rvu01 = rvv01 AND rvuplant = '",p_plant,"'",                              #MOD-B20085  mark
                        "    AND rvu01 = rvv01 AND rvuplant = '",l_rtp05,"'",                               #MOD-B20085
                       #"    AND rvucond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                     #FUN-C80095  mark
                        "    AND rvu03 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                       #FUN-C80095  add
#TQC-AC0134 ------------------STA
                        ,"   AND rvv31 IN (",
          #MOD-B20085 --------------STA
          #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",               
          #                                      cl_get_target_table(p_plant1,'rts_file'),                   
                        "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",                
                                                 cl_get_target_table(l_rtp05,'rts_file'),                    
          #MOD-B20085 ---------------END
                        "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                        "      AND rtsconf <> 'X' ",  #CHI-C80041
                        "      AND rtt02 = '",p_plant1,"')"                                                  
#TQC-AC0134 ------------------END
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                             #FUN-AB0095 
#            CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql                    #FUN-AB0095            #MOD-B20085  mark
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                             #MOD-B20085 
            PREPARE pre_sel_rvv39t FROM g_sql
            EXECUTE pre_sel_rvv39t INTO l_get_money
          # LET g_sql = "SELECT sum(rvv39t) FROM ",l_dbs,"rvv_file,",l_dbs,"rvu_file ",                       #FUN-AB0095 mark
#MOD-B20085 ----------------STA
#           LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(p_plant1,'rvv_file'),",",              #FUN-AB0095  
#                                                  cl_get_target_table(p_plant1,'rvu_file'),                  #FUN-AB0095  
            LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(l_rtp05,'rvv_file'),",",                            
                                                   cl_get_target_table(l_rtp05,'rvu_file'),                                
#MOD-B20085 ----------------END
                        "  WHERE rvu00 = rvv03 AND rvuplant = rvvplant ",
                        "    AND rvuconf = 'Y' AND rvu00 = '3' ",
#                        "    AND rvu01 = rvv01 AND rvuplant = '",p_plant,"'",                               #MOD-B20085 mark
                        "    AND rvu01 = rvv01 AND rvuplant = '",l_rtp05,"'",                                #MOD-B20085
                       #"    AND rvucond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                      #FUN-C80095  mark
                        "    AND rvu03 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                        #FUN-C80095  add
#TQC-AC0134 ------------------STA
                        ,"   AND rvv31 IN (",
          #MOD-B20085 ------------------STA
          #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",                
          #                                      cl_get_target_table(p_plant1,'rts_file'),                    
                        "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",                 
                                                 cl_get_target_table(l_rtp05,'rts_file'),                     
          #MOD-B20085 ------------------END
                        "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                        "      AND rtsconf <> 'X' ",  #CHI-C80041
                        "      AND rtt02 = '",p_plant1,"')"                                                  
#TQC-AC0134 ------------------END
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                             #FUN-AB0095
#            CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql                    #FUN-AB0095            #MOD-B20085  mark
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                             #MOD-B20085 
            PREPARE pre_sel_rvv39 FROM g_sql
            EXECUTE pre_sel_rvv39 INTO l_exit_money
         END IF 
         IF l_rtr11 = '2' THEN 
          # LET g_sql = "SELECT sum(ogb14t) FROM ",l_dbs,"ogb_file,",l_dbs,"oga_file ",                  #FUN-AB0095 mark
#MOD-B20085 ------------------STA
#           LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(p_plant1,'ogb_file'),",",         #FUN-AB0095       
#                                                  cl_get_target_table(p_plant1,'oga_file'),             #FUN-AB0095       
            LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(l_rtp05,'ogb_file'),",",                            
                                                   cl_get_target_table(l_rtp05,'oga_file'),                                
#MOD-B20085 ------------------END
                        "    WHERE oga01 = ogb01 AND ogaconf = 'Y' AND ogapost = 'Y' ",
#                        "      AND ogaplant = ogbplant AND ogaplant = '",p_plant,"'",                       #MOD-B20085  mark
                        "      AND ogaplant = ogbplant AND ogaplant = '",l_rtp05,"'",                        #MOD-B20085
                       #"      AND ogacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                    #FUN-C80095  mark
                        "      AND oga02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                      #FUN-C80095  add        
#TQC-AC0134 ------------------STA
                        ,"   AND ogb04 IN (",
          #MOD-B20085 ----------------STA
          #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",                        
          #                                      cl_get_target_table(p_plant1,'rts_file'),                          
                        "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",", 
                                                 cl_get_target_table(l_rtp05,'rts_file'),           
          #MOD-B20085 ----------------END
                        "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                        "      AND rtsconf <> 'X' ",  #CHI-C80041
                        "      AND rtt02 = '",p_plant1,"')"                                             
#TQC-AC0134 ------------------END
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                             #FUN-AB0095
#            CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql                    #FUN-AB0095       #MOD-B20085  mark
            CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                        #MOD-B20085 
            PREPARE pre_sel_ogb14t FROM g_sql
            EXECUTE pre_sel_ogb14t INTO l_get_money
            
          # LET g_sql = "SELECT sum(ohb14t) FROM ",l_dbs,"ohb_file,",l_dbs,"oha_file ",                  #FUN-AB0095 mark
#MOD-B20085 ----------------------STA
#           LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(p_plant1,'ohb_file'),",",         #FUN-AB0095 
#                                                  cl_get_target_table(p_plant1,'oha_file'),             #FUN-AB0095
            LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(l_rtp05,'ohb_file'),",",                       
                                                   cl_get_target_table(l_rtp05,'oha_file'),                        
#MOD-B20085 ----------------------END
                        "   WHERE oha01 = ohb01 AND ohapost = 'Y' ",
                        "     AND ohaconf = 'Y' AND ohaplant = ohbplant ",
#                        "     AND ohaplant = '",p_plant,"'",                                             #MOD-B20085  mark
                        "     AND ohaplant = '",l_rtp05,"'",                                              #MOD-B20085
                       #"     AND ohacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                  #FUN-C80095  mark
                        "     AND oha02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"                    #FUN-C80095  add
#TQC-AC0134 ------------------STA
                        ,"   AND ohb04 IN (",
          #MOD-B20085 ------------------STA
          #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",           
          #                                      cl_get_target_table(p_plant1,'rts_file'),               
                        "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",            
                                                cl_get_target_table(l_rtp05,'rts_file'),                 
          #MOD-B20085 ------------------END
                        "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                        "      AND rtsconf <> 'X' ",  #CHI-C80041
                        "      AND rtt02 = '",p_plant1,"')"                                              
#TQC-AC0134 ------------------END
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                             #FUN-AB0095
#            CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql                    #FUN-AB0095        #MOD-B20085  mark
             CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                        #MOD-B20085 
            PREPARE pre_sel_ohb14t FROM g_sql
            EXECUTE pre_sel_ohb14t INTO l_exit_money
         END IF
         IF l_get_money IS NULL THEN LET l_get_money = 0 END IF
         LET l_get_money_sum = l_get_money_sum + l_get_money                       #MOD-B20085 add
         IF l_exit_money IS NULL THEN LET l_exit_money = 0 END IF 
         LET l_exit_money_sum = l_exit_money_sum + l_exit_money                    #MOD-B20085 add
       END FOREACH                                                                 #MOD-B20085 add
         IF l_rtr12 IS NULL THEN LET l_rtr12 = 100 END IF 
 #        LET l_lub.lub04t = (l_get_money - l_exit_money)*l_rtr12                  #TQC-AC0134  mark
 #        LET l_lub.lub04t = (l_get_money - l_exit_money)*l_rtr12/100               #TQC-AC0134  #MOD-B20085 mark
         LET l_lub.lub04t = (l_get_money_sum - l_exit_money_sum)*l_rtr12/100                     #MOD-B20085
         IF NOT cl_null(l_rtr14) THEN 
            IF l_lub.lub04t <  l_rtr14 THEN LET l_lub.lub04t =  l_rtr14 END IF 
         END IF 
         IF NOT cl_null(l_rtr15) THEN 
            IF l_lub.lub04t >  l_rtr15 THEN LET l_lub.lub04t =  l_rtr15 END IF 
         END IF
         IF l_lub.lub04t IS NULL THEN LET l_lub.lub04t = 0 END IF 
         
#        LET l_lub.lub02 = l_cnt                         #FUN-AB0095
         LET l_lub.lub03 = l_rtr06   
         LET l_rtr10 = l_lub.lub04t                      #FUN-AB0095
         IF l_lua23 = 'Y' THEN
            LET l_lub.lub04t = l_rtr10                             
           #LET l_lub.lub04 = l_rtr10/(1+l_lua23/100)          #FUN-AB0095  mark
            LET l_lub.lub04 = l_rtr10/(1+l_lua22/100)   
         ELSE
            LET l_lub.lub04 = l_rtr10       
           #LET l_lub.lub04t = l_rtr10*(1+l_lua23/100)         #FUN-AB0095
            LET l_lub.lub04t = l_rtr10*(1+l_lua22/100)   
         END IF
        
#FUN-AB0095 ---------------------------add start ----------
         LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),
                  "   WHERE lub01 = '",p_no,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
         PREPARE pre_sel_lub031 FROM g_sql
         EXECUTE pre_sel_lub031 INTO l_lub.lub02
         IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#FUN-AB0095 -------------------------add end ---------------
         LET l_lub.lub07 = l_min_date   #FUN-BC0125
         LET l_lub.lub08 = l_max_date   #FUN-BC0125
         LET l_lub.lub09 = l_oaj05      #FUN-BC0125
         LET l_lub.lub10 = g_date       #FUN-BC0125
         LET l_lub.lub11 = 0            #FUN-BC0125
         LET l_lub.lub12 = 0            #FUN-BC0125
         LET l_lub.lubplant = p_plant
         LET l_lub.lublegal = p_legal
       # LET g_sql = "INSERT INTO ",l_dbs,"lub_file(",                             #FUN-AB0095 mark
         LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",  #FUN-AB0095 
                    #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal)",
                    #" VALUES(?,?,?,?,?, ?,?) "
                     "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                     " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
         CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
         PREPARE pre_ins_rub17 FROM g_sql
         EXECUTE pre_ins_rub17 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                                     l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                                     l_lub.lublegal,l_lub.lub09,l_lub.lub10,           #FUN-BC0125 add lub09,lub10
                                     l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08   #FUN-BC0125 add lub11,lub12,lub07,lub08
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
            LET g_success='N'
            CONTINUE FOREACH 
         END IF
       # LET l_cnt = l_cnt +1      #FUN-AB0095 
      END FOREACH  
  #FUN-AB0095 -----add start---------------
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p5 FROM g_sql
   EXECUTE pre_lub04_p5 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p6 FROM g_sql
   EXECUTE pre_lub04_p6 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
  #FUN-AB0095 --------add end------------- 
END FUNCTION 

#根據返利費用明細產生費用單單身
#FUNCTION create_money4(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)      #FUN-AB0095 mark
FUNCTION create_money4(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05)    #FUN-AB0095   #FUN-AB0095 add oaj05 
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant1     LIKE azp_file.azp01     #FUN-AB0095
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_legal      LIKE azw_file.azw02
DEFINE p_dbs        LIKE azp_file.azp03
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_rtr05      LIKE rtr_file.rtr05
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr08      LIKE rtr_file.rtr08
DEFINE l_rtr09      LIKE rtr_file.rtr09
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_rtr11      LIKE rtr_file.rtr12
DEFINE l_rtr12      LIKE rtr_file.rtr12
DEFINE l_rtr13      LIKE rtr_file.rtr13
DEFINE l_rtr14      LIKE rtr_file.rtr14
DEFINE l_rtr15      LIKE rtr_file.rtr15
DEFINE l_sql        STRING
DEFINE l_get_money  LIKE ogb_file.ogb14
DEFINE l_get_money_sum  LIKE ogb_file.ogb14       #MOD-B20085 add
DEFINE l_exit_money  LIKE ogb_file.ogb14
DEFINE l_exit_money_sum  LIKE ogb_file.ogb14      #MOD-B20085 add
DEFINE l_min_date   LIKE azmm_file.azmm011
DEFINE l_max_date   LIKE azmm_file.azmm012
DEFINE l_date       LIKE azmm_file.azmm012
DEFINE l_lub04      LIKE lub_file.lub04           #FUN-AB0095
DEFINE l_lub04t     LIKE lub_file.lub04t          #fun-ab0095
DEFINE p_oaj05      LIKE oaj_file.oaj05           #FUN-AB0095   
DEFINE l_oaj05      LIKE oaj_file.oaj05           #FUN-AB0095
DEFINE p_lua06      LIKE lua_file.lua06           #FUN-AB0095
DEFINE l_rtp05      LIKE rtp_file.rtp05           #MOD-B20085 add
 
   LET l_lub.lub01 = p_no
 # LET g_sql = "SELECT lua21,lua22,lua23 FROM ",p_dbs,"lua_file ",                            #FUN-AB0095 mark
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'),     #FUN-AB0095 
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql #FUN-AB0095
   PREPARE pre_sel_lua224 FROM g_sql
   EXECUTE pre_sel_lua224 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
      
 # LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10,rtr11,rtr12,rtr13,rtr14,rtr15 FROM ",p_dbs,"rtr_file ",                       #FUN-AB0095 mark
   LET g_sql = "SELECT rtr05,rtr06,rtr08,rtr09,rtr10,rtr11,rtr12,rtr13,rtr14,rtr15 FROM ",cl_get_target_table(p_plant1,'rtr_file'),#FUN-AB0095
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'" 
              ,"     AND rtrplant = '",p_plant,"'"         #FUN-AB0095    
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
   PREPARE pre_sel_rtr4 FROM g_sql
   DECLARE cur_rtr4 CURSOR FOR pre_sel_rtr4
   LET l_cnt = 1
   
   FOREACH cur_rtr4 INTO l_rtr05,l_rtr06,l_rtr08,l_rtr09,l_rtr10,l_rtr11,l_rtr12,l_rtr13,l_rtr14,l_rtr15   
      IF l_rtr08 IS NULL THEN CONTINUE FOREACH END IF
      IF l_rtr09 IS NULL THEN CONTINUE FOREACH END IF 
      IF l_rtr10 IS NULL THEN LET l_rtr10 = 0 END IF
     #FUN-AB0095 ---------add start----------------
      LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'),
                  " WHERE oaj01 = '",l_rtr06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel04 FROM g_sql
      EXECUTE pre_sel04 INTO l_oaj05 
     #FUN-BC0125 mark---------------
     #IF l_oaj05 !=  p_oaj05 THEN    
     #   CONTINUE FOREACH            
     #END IF
     #FUN-BC0125 mark end-----------

      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                          cl_get_target_table(p_plant1,'lua_file'),
                  " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
                  "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
                  "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
                  "   AND lub03 =    '",l_rtr06,"'"
      PREPARE pre_sel_count04 FROM g_sql
      EXECUTE pre_sel_count04 INTO g_cnt
      IF g_cnt != 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-AB0095 ---------add end-----------------

       
      CALL p104_compute_date(l_rtr08,l_rtr09) RETURNING l_date   
      IF NOT (l_rtr09 = '2' AND g_end_date = g_date) THEN #TQC-B50076
         IF l_date < g_begin_date OR l_date > g_end_date THEN 
          # CALL s_errmsg('',l_date,'',SQLCA.sqlcode,1)   #FUN-AB0095 mark
          # LET g_success='N'    #FUN-AB0095 mark
            CONTINUE FOREACH 
         END IF
         IF l_date != g_date THEN
            CONTINUE FOREACH 
         END IF
      END IF #TQC-B50076
   
      #CALL p104_compute_date1(l_rtr08) RETURNING l_min_date,l_max_date  #FUN-BC0125 mark 
      CALL p104_get_lub07_lub08(l_rtr08,'','') RETURNING l_min_date,l_max_date,g_judu #FUN-BC0125 add      
#MOD-B20085 ----------------------STA
      LET l_get_money_sum = 0
      LET l_exit_money_sum = 0
      LET  g_sql = " SELECT rtp05 FROM ",cl_get_target_table(p_plant1,'rtp_file'),
                   " WHERE rtp01 = '",p_rto01,"' AND rtp02 = '",p_rto02,"'",
                   "   AND rtp03 = '",p_rto03,"' AND rtpplant = '",p_plant1,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_rtp05_2 FROM g_sql
      DECLARE sel_rtp05_2 CURSOR FOR pre_sel_rtp05_2
      FOREACH sel_rtp05_2 INTO l_rtp05
#MOD-B20085 ---------------------END
      IF l_rtr11 = '3' THEN 
       # LET g_sql = "SELECT sum(rvv39t) FROM ",p_dbs,"rvv_file,",p_dbs,"rvu_file ",           #FUN-AB0095
#MOD-B20085 ---------------------STA
#        LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(p_plant1,'rvv_file'),",",  #FUN-AB0095    
#                                               cl_get_target_table(p_plant1,'rvu_file'),      #FUN-AB0095    
         LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(l_rtp05,'rvv_file'),",",                  
                                                cl_get_target_table(l_rtp05,'rvu_file'),                      
#MOD-B20085 ---------------------END
                     "  WHERE rvu00 = rvv03 AND rvuplant = rvvplant ",
                     "    AND rvuconf = 'Y' AND rvu00 = '1' ",
#                     "    AND rvu01 = rvv01 AND rvuplant = '",p_plant,"'",                     #MOD-B20085 mark
                     "    AND rvu01 = rvv01 AND rvuplant = '",l_rtp05,"'",                      #MOD-B20085
                    #"    AND rvucond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"            #FUN-C80095 mark
                     "    AND rvu03 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"              #FUN-C80095 add
#TQC-AC0134 ------------------STA
                     ,"   AND rvv31 IN (",
       #MOD-B20085 -----------------STA
       #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",    
       #                                      cl_get_target_table(p_plant1,'rts_file'),       
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",    
                                              cl_get_target_table(l_rtp05,'rts_file'),        
       #MOD-B20085 -----------------END
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "      AND rtsconf <> 'X' ",  #CHI-C80041
                     "      AND rtt02 = '",p_plant1,"')"                                       
#TQC-AC0134 ------------------END
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
#         CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095                  #MOD-B20085 mark
          CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                 #MOD-B20085
         PREPARE pre_sel_rvv39t8 FROM g_sql                      #FUN-AB0095 l_sql -> g_sql
         EXECUTE pre_sel_rvv39t8 INTO l_get_money
          
       # LET g_sql = "SELECT sum(rvv39t) FROM ",p_dbs,"rvv_file,",p_dbs,"rvu_file ",            #FUN-AB0095
#MOD-B20085 --------------------STA
#        LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(p_plant1,'rvv_file'),",",   #FUN-AB0095   
#                                               cl_get_target_table(p_plant1,'rvu_file'),       #FUN-AB0095   
         LET g_sql = "SELECT sum(rvv39t) FROM ",cl_get_target_table(l_rtp05,'rvv_file'),",",                  
                                                cl_get_target_table(l_rtp05,'rvu_file'),                      
#MOD-B20085 --------------------END
                     "  WHERE rvu00 = rvv03 AND rvuplant = rvvplant ",
                     "    AND rvuconf = 'Y' AND rvu00 = '3' ",
#                     "    AND rvu01 = rvv01 AND rvuplant = '",p_plant,"'",                    #MOD-B20085 mark
                     "    AND rvu01 = rvv01 AND rvuplant = '",l_rtp05,"'",                     #MOD-B20085
                    #"    AND rvucond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"           #FUN-C80095 mark
                     "    AND rvu03 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"             #FUN-C80095 add
#TQC-AC0134 ------------------STA
                     ,"   AND rvv31 IN (",
       #MOD-B20085 ------------------STA
       #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",     
       #                                      cl_get_target_table(p_plant1,'rts_file'),         
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",      
                                              cl_get_target_table(l_rtp05,'rts_file'),          
       #MOD-B20085 ------------------END
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "      AND rtsconf <> 'X' ",  #CHI-C80041
                     "      AND rtt02 = '",p_plant1,"')"                                       
#TQC-AC0134 ------------------END
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
#         CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095                  #MOD-B20085 mark
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                  #MOD-B20085
         PREPARE pre_sel_rvv394 FROM g_sql                       #FUN-AB0095 l_sql ->g_sql 
         EXECUTE pre_sel_rvv394 INTO l_exit_money
      END IF 
      IF l_rtr11 = '2' THEN 
       # LET g_sql = "SELECT sum(ogb14t) FROM ",p_dbs,"ogb_file,",p_dbs,"oga_file ",           #FUN-AB0095
#MOD-B20085 --------------------STA
#        LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(p_plant1,'ogb_file'),",",   #FUN-AB0095  
#                                               cl_get_target_table(p_plant1,'oga_file'),       #FUN-AB0095   
         LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(l_rtp05,'ogb_file'),",",               
                                                cl_get_target_table(l_rtp05,'oga_file'),                   
#MOD-B20085 --------------------END
                     "    WHERE oga01 = ogb01 AND ogaconf = 'Y' AND ogapost = 'Y' ",
#                     "      AND ogaplant = ogbplant AND ogaplant = '",p_plant,"'",            #MOD-B20085 mark
                      "      AND ogaplant = ogbplant AND ogaplant = '",l_rtp05,"'",            #MOD-B20085
                    #"      AND ogacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"         #FUN-C80095 mark
                     "      AND oga02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"           #FUN-C80095 add
#TQC-AC0134 ------------------STA
                     ,"   AND ogb04 IN (",
       #MOD-B20085 -----------------STA
       #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",     
       #                                      cl_get_target_table(p_plant1,'rts_file'),         
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",      
                                              cl_get_target_table(l_rtp05,'rts_file'),          
       #MOD-B20085 -----------------END
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "      AND rtsconf <> 'X' ",  #CHI-C80041
                     "      AND rtt02 = '",p_plant1,"')"                                       
#TQC-AC0134 ------------------END
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
#         CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095                   #MOD-B20085 mark
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                   #MOD-B20085
        #PREPARE pre_sel_ogb14t8 FROM l_sql                      #FUN-AB0095
         PREPARE pre_sel_ogb14t8 FROM g_sql                      #FUN-AB0095  
         EXECUTE pre_sel_ogb14t8 INTO l_get_money
         
       # LET g_sql = "SELECT sum(ohb14t) FROM ",p_dbs,"ohb_file,",p_dbs,"oha_file ",           #FUN-AB0095
#MOD-B20085 ------------------STA
#        LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(p_plant1,'ohb_file'),",",  #FUN-AB0095
#                                               cl_get_target_table(p_plant1,'oha_file'),      #FUN-AB0095   
         LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(l_rtp05,'ohb_file'),",",               
                                                cl_get_target_table(l_rtp05,'oha_file'),                  
#MOD-B20085 ------------------END
                     "   WHERE oha01 = ohb01 AND ohapost = 'Y' ",
                     "     AND ohaconf = 'Y' AND ohaplant = ohbplant ",
#                     "     AND ohaplant = '",p_plant,"'",                                       #MOD-B20085 mark
                     "     AND ohaplant = '",l_rtp05,"'",                                        #MOD-B20085
                    #"     AND ohacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'"            #FUN-C80095 mark
                     "     AND oha02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'"              #FUN-C80095 add
#TQC-AC0134 ------------------STA
                     ,"   AND ohb04 IN (",
       #MOD-B20085 ---------------STA
       #             "    SELECT rtt04 FROM ",cl_get_target_table(p_plant1,'rtt_file'),",",    
       #                                      cl_get_target_table(p_plant1,'rts_file'),        
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",     
                                              cl_get_target_table(l_rtp05,'rts_file'),         
       #MOD-B20085 ---------------END
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "      AND rtsconf <> 'X' ",  #CHI-C80041
                     "      AND rtt02 = '",p_plant1,"')"                                         
#TQC-AC0134 ------------------END
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
#         CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095                    #MOD-B20085 mark
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                   #MOD-B20085
         PREPARE pre_sel_ohb14t1 FROM g_sql                      #FUN-AB0095 l_sql -> g_sql
         EXECUTE pre_sel_ohb14t1 INTO l_exit_money
      END IF
      IF l_get_money IS NULL THEN LET l_get_money = 0 END IF
      LET l_get_money_sum = l_get_money_sum + l_get_money        #MOD-B20085 add
      IF l_exit_money IS NULL THEN LET l_exit_money = 0 END IF 
      LET l_exit_money_sum = l_exit_money_sum + l_exit_money     #MOD-B20085 add
      END FOREACH                                                #MOD-B20085 add
      IF l_rtr12 IS NULL THEN LET l_rtr12 = 100 END IF
#      IF l_get_money - l_exit_money > l_rtr13 THEN                      #MOD-B20085 mark
       IF l_get_money_sum - l_exit_money_sum > l_rtr13 THEN              #MOD-B20085
#         LET l_lub.lub04t = (l_get_money - l_exit_money)*l_rtr12
#          LET l_lub.lub04t = (l_get_money - l_exit_money)*l_rtr12/100        #TQC-AC0134    #MOD-B20085 mark
         LET l_lub.lub04t = (l_get_money_sum - l_exit_money_sum)*l_rtr12/100                 #MOD-B20085 add
      ELSE
      	 CONTINUE FOREACH
      END IF
      IF l_lub.lub04t IS NULL THEN LET l_lub.lub04t = 0 END IF 
      
    # LET l_lub.lub02 = l_cnt                            #FUN-AB0095 mark
      LET l_lub.lub03 = l_rtr06       
      LET  l_rtr10 = l_lub.lub04t                        #FUN-AB0095
      IF l_lua23 = 'Y' THEN
         LET l_lub.lub04t = l_rtr10    
       # LET l_lub.lub04 = l_rtr10/(1+l_lua23/100)       #FUN-AB0095
         LET l_lub.lub04 = l_rtr10/(1+l_lua22/100)      
      ELSE
      	 LET l_lub.lub04 = l_rtr10
       # LET l_lub.lub04t = l_rtr10*(1+l_lua23/100)      #FUN-AB0095
         LET l_lub.lub04t = l_rtr10*(1+l_lua22/100)      #FUN-AB0095
      END IF
      LET l_lub.lub07 = l_min_date   #FUN-BC0125
      LET l_lub.lub08 = l_max_date   #FUN-BC0125
      LET l_lub.lub09 = l_oaj05      #FUN-BC0125
      LET l_lub.lub10 = g_date       #FUN-BC0125
      LET l_lub.lub11 = 0            #FUN-BC0125
      LET l_lub.lub12 = 0            #FUN-BC0125
      LET l_lub.lubplant = p_plant
      LET l_lub.lublegal = p_legal
#FUN-AB0095 ---------------------------add start ----------
      LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),
               "   WHERE lub01 = '",p_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_lub030 FROM g_sql
      EXECUTE pre_sel_lub030 INTO l_lub.lub02
      IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#FUN-AB0095 -------------------------add end ---------------
    # LET g_sql = "INSERT INTO ",p_dbs,"lub_file(",                            #FUN-AB0095
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(", #FUN-AB0095
                 #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal)",    
                 #" VALUES(?,?,?,?,?, ?,?) "
                  "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
      CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
      PREPARE pre_ins_rub15 FROM g_sql                        #FUN-AB0095 l_sql - > g_sql
      EXECUTE pre_ins_rub15 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                                 l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                                 l_lub.lublegal,l_lub.lub09,l_lub.lub10,           #FUN-BC0125 add lub09,lub10
                                 l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08  #FUN-BC0125 add lub11,lub12
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF
    # LET l_cnt = l_cnt +1     #FUN-AB0095 mark 
   END FOREACH  
  #FUN-AB0095 ---------------add start-----------------
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p7 FROM g_sql
   EXECUTE pre_lub04_p7 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p8 FROM g_sql
   EXECUTE pre_lub04_p8 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
  #FUN-AB0095 -------------add end-----------------
END FUNCTION

#FUNCTION create_money5(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)     #FUN-AB0095
FUNCTION create_money5(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05)   #FUN-AB0095    #FUN-AB0095 add oaj05
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_plant1     LIKE azp_file.azp01  #FUN-AB0095 
DEFINE p_legal      LIKE azw_file.azw02
DEFINE p_dbs        LIKE azp_file.azp03
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_rtr05      LIKE rtr_file.rtr05
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr07      LIKE rtr_file.rtr07
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_lub04      LIKE lub_file.lub04   #FUN-AB0095
DEFINE l_lub04t     LIKE lub_file.lub04t  #FUN-AB0095 
DEFINE p_oaj05      LIKE oaj_file.oaj05   #FUN-AB0095 
DEFINE l_oaj05      LIKE oaj_file.oaj05   #FUN-AB0095
DEFINE p_lua06      LIKE lua_file.lua06    #FUN-AB0095
 
   LET l_lub.lub01 = p_no
 # LET g_sql = "SELECT lua21,lua22,lua23 FROM ",p_dbs,"lua_file ",                        #FUN-AB0095
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'), #FUN-AB0095
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095  
   PREPARE pre_sel_lua215 FROM g_sql
   EXECUTE pre_sel_lua215 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
   
 # LET g_sql = "SELECT DISTINCT rtr05,rtr06,rtr07,rtr10 FROM ",p_dbs,"rtr_file ",                        #FUN-AB0095
   LET g_sql = "SELECT DISTINCT rtr05,rtr06,rtr07,rtr10 FROM ",cl_get_target_table(p_plant1,'rtr_file'), #FUN-AB0095
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'"
              ,"     AND rtrplant = '",p_plant,"'"         #FUN-AB0095
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
   PREPARE pre_sel_rtr5 FROM g_sql
   DECLARE cur_rtr5 CURSOR FOR pre_sel_rtr5
 # LET l_cnt = 1   #FUN-AB0095
       
   FOREACH cur_rtr5 INTO l_rtr05,l_rtr06,l_rtr07,l_rtr10
      IF l_rtr07 IS NULL THEN CONTINUE FOREACH END IF 
      IF l_rtr07 < g_begin_date OR l_rtr07 > g_end_date THEN 
       # CALL s_errmsg('',l_rtr07,'',SQLCA.sqlcode,1)    #FUN-AB0095 mark
       # LET g_success='N'                               #FUN-AB0095 mark
         CONTINUE FOREACH 
      END IF
     #FUN-AB0095 ---------add start----------------
      LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'),
                  " WHERE oaj01 = '",l_rtr06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel05 FROM g_sql
      EXECUTE pre_sel05 INTO l_oaj05
     #FUN-BC0125 mark---------------
     #IF l_oaj05 !=  p_oaj05 THEN
     #   CONTINUE FOREACH
     #END IF
     #FUN-BC0125 mark end-----------

      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                          cl_get_target_table(p_plant1,'lua_file'),
                  " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
                  "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
                  "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
                  "   AND lub03 =    '",l_rtr06,"'"
      PREPARE pre_sel_count05 FROM g_sql
      EXECUTE pre_sel_count05 INTO g_cnt
      IF g_cnt != 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-AB0095 ---------add end-----------------

      IF l_rtr07 != g_date THEN CONTINUE FOREACH END IF
      
    # LET l_lub.lub02 = l_cnt     #FUN-AB0095 
      LET l_lub.lub03 = l_rtr06  
#FUN-AB0095 ---------------------------add start ----------
      LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),     
               "   WHERE lub01 = '",p_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql       
      PREPARE pre_sel_lub029 FROM g_sql
      EXECUTE pre_sel_lub029 INTO l_lub.lub02
      IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#FUN-AB0095 -------------------------add end ---------------   
      IF l_lua23 = 'Y' THEN
         LET l_lub.lub04t = l_rtr10
       # LET l_lub.lub04 = l_rtr10/(1+l_lua23/100)        #FUN-AB0095
         LET l_lub.lub04 = l_rtr10/(1+l_lua22/100)        #FUN-AB0095
      ELSE
      	 LET l_lub.lub04 = l_rtr10
       # LET l_lub.lub04t = l_rtr10*(1+l_lua23/100)       #FUN-AB0095
         LET l_lub.lub04t = l_rtr10*(1+l_lua22/100)       #FUN-AB0095
      END IF
      LET l_lub.lub07 = g_begin_date #FUN-BC0125
      LET l_lub.lub08 = g_end_date   #FUN-BC0125
      LET l_lub.lub09 = l_oaj05      #FUN-BC0125
      LET l_lub.lub10 = g_date       #FUN-BC0125
      LET l_lub.lub11 = 0            #FUN-BC0125
      LET l_lub.lub12 = 0            #FUN-BC0125
      LET l_lub.lubplant = p_plant
      LET l_lub.lublegal = p_legal
    # LET g_sql = "INSERT INTO ",p_dbs,"lub_file(",                                     #FUN-AB0095
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",          #FUN-AB0095
                 #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal)",    
                 #" VALUES(?,?,?,?,?, ?,?) "
                  "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
      CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
      PREPARE pre_ins_rub10 FROM g_sql
      EXECUTE pre_ins_rub10 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                                 l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                                 l_lub.lublegal,l_lub.lub09,l_lub.lub10,             #FUN-BC0125 add lub09,lub10
                                 l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08     #FUN-BC0125 add lub11,lub12,lub07,lub08
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF
    # LET l_cnt = l_cnt +1    #FUN-AB0095  
   END FOREACH  
  #FUN-AB0095 ---------------add start-------------
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p9 FROM g_sql
   EXECUTE pre_lub04_p9 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p10 FROM g_sql
   EXECUTE pre_lub04_p10 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
  #FUN-AB0095 ------------add end------------------- 
END FUNCTION

#FUNCTION create_money6(p_no,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_dbs)     #FUN-AB0095 
FUNCTION create_money6(p_no,p_lua06,p_rto01,p_rto02,p_rto03,p_rtr04,p_plant,p_legal,p_plant1,p_oaj05)   #FUN-AB0095  
DEFINE p_no         LIKE lua_file.lua01
DEFINE p_rto01      LIKE rto_file.rto01
DEFINE p_rto02      LIKE rto_file.rto02
DEFINE p_rto03      LIKE rto_file.rto03
DEFINE p_rtr04      LIKE rtr_file.rtr04
DEFINE p_plant      LIKE azp_file.azp01
DEFINE p_plant1     LIKE azp_file.azp01    #FUN-AB0095
DEFINE p_legal      LIKE azw_file.azw02
DEFINE p_dbs        LIKE azp_file.azp03
DEFINE l_lub        RECORD LIKE lub_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_dbs        LIKE azp_file.azp03
DEFINE l_rtr10      LIKE rtr_file.rtr10
DEFINE l_rtr06      LIKE rtr_file.rtr06
DEFINE l_rtr08      LIKE rtr_file.rtr08
DEFINE l_lua23      LIKE lua_file.lua23
DEFINE l_lua21      LIKE lua_file.lua21
DEFINE l_lua22      LIKE lua_file.lua22
DEFINE l_wc         LIKE type_file.chr1000
DEFINE l_date       LIKE rtr_file.rtr18
DEFINE l_jidu       LIKE azmm_file.azmm013
DEFINE l_min_date   LIKE azmm_file.azmm011
DEFINE l_max_date   LIKE azmm_file.azmm011
DEFINE l_rtr16      LIKE rtr_file.rtr16
DEFINE l_rtr17      LIKE rtr_file.rtr17
DEFINE l_lub04      LIKE lub_file.lub04    #FUN-AB0095
DEFINE l_lub04t     LIKE lub_file.lub04t   #FUN-AB0095
DEFINE p_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095 
DEFINE l_oaj05      LIKE oaj_file.oaj05    #FUN-AB0095
DEFINE p_lua06      LIKE lua_file.lua06    #FUN-AB0095 
DEFINE l_lang_t     LIKE lua_file.lua06    #FUN-AB0095 Add By shi
DEFINE l_rtr19      LIKE rtr_file.rtr19    #FUN-AB0095 Add By shi
DEFINE l_get_money  LIKE ogb_file.ogb14             #TQC-AC0134 add
DEFINE l_exit_money  LIKE ogb_file.ogb14            #TQC-AC0134 add
DEFINE l_rtp05      LIKE rtp_file.rtp05             #TQC-AC0134

   LET l_dbs = p_dbs
   LET l_lub.lub01 = p_no
 # LET g_sql = "SELECT lua21,lua22,lua23 FROM ",l_dbs,"lua_file ",                            #FUN-AB0095
   LET g_sql = "SELECT lua21,lua22,lua23 FROM ",cl_get_target_table(p_plant1,'lua_file'),     #FUN-AB0095
               "   WHERE lua01 = '",p_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql      #FUN-AB0095 
   PREPARE pre_sel_lua221 FROM g_sql
   EXECUTE pre_sel_lua221 INTO l_lua21,l_lua22,l_lua23
   IF l_lua23 IS NULL THEN LET l_lua23 = 'N' END IF
   IF l_lua22 IS NULL THEN LET l_lua22 = 0 END IF
    
 # LET g_sql = "SELECT DISTINCT rtr06,rtr08,rtr16,rtr17 FROM ",l_dbs,"rtr_file ",                          #FUN-AB0095
   LET g_sql = "SELECT DISTINCT rtr06,rtr08,rtr16,rtr17 FROM ",cl_get_target_table(p_plant1,'rtr_file'),   #FUN-AB0095   
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"'"
              ,"     AND rtrplant = '",p_plant,"'"           #FUN-AB0095
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-AB0095
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql     #FUN-AB0095
   PREPARE pre_sel_rtr6 FROM g_sql
   EXECUTE pre_sel_rtr6 INTO l_rtr06,l_rtr08,l_rtr16,l_rtr17   
   CALL p104_compute_date3(l_rtr08,p_dbs) RETURNING l_date
   IF l_date > g_end_date THEN LET l_date = g_end_date END IF   #FUN-BC0125
   IF l_date < g_begin_date OR l_date > g_end_date THEN 
      #CALL s_errmsg('',l_date,'',SQLCA.sqlcode,1)   #FUN-BC0125 mark
      #LET g_success='N'                             #FUN-BC0125 mark
      RETURN               #FUN-AB0095 add
   END IF 
   IF l_date != g_date THEN RETURN END IF 
  #FUN-AB0095 ---------add start----------------
   LET g_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant1,'oaj_file'),
               " WHERE oaj01 = '",l_rtr06,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_sel06 FROM g_sql
   EXECUTE pre_sel06 INTO l_oaj05
   #FUN-BC0125 mark---------------
   #IF l_oaj05 !=  p_oaj05 THEN
   #   CONTINUE FOREACH
   #END IF
   #FUN-BC0125 mark end-----------

   LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant1,'lub_file'),",",
                                       cl_get_target_table(p_plant1,'lua_file'),
               " WHERE lua01  = lub01 AND lua20 = ",p_rto02,
               "   AND lua04 =    '",p_rto01,"' AND lua06 = '",p_lua06,"'",
               "   AND luaplant = '",p_plant,"' AND lua09 = '",g_date,"'",
               "   AND lub03 =    '",l_rtr06,"'"
   PREPARE pre_sel_count06 FROM g_sql
   EXECUTE pre_sel_count06 INTO g_cnt
   IF g_cnt != 0 THEN
      RETURN  
   END IF
  #FUN-AB0095 ---------add end-----------------
 
  #CALL p104_compute_date6(l_rtr08,l_dbs) RETURNING l_max_date,l_min_date,l_jidu
   CALL p104_get_lub07_lub08(l_rtr08,'6',l_dbs) RETURNING l_min_date,l_max_date,l_jidu
  #FUN-AB0095 Begin--- By shi
  #IF l_rtr08 = '1' THEN
  #   LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
  #   LET l_wc = " AND rtr18 = '",l_date,"'"
  #END IF
  #IF l_rtr08 = '2' THEN
  #   LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
  #   IF l_jidu <= 2 THEN
  #      LET l_date = l_date||cl_getmsg("art-083",g_lang)
  #   ELSE 
  #   	 LET l_date = l_date||cl_getmsg("art-084",g_lang)
  #   END IF
  #   LET l_wc = " AND rtr18 = '",l_date,"'"
  #END IF 
  #IF l_rtr08 = '3' THEN
  #   LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
  #   IF l_jidu = '1' THEN
  #      LET l_date = l_date||cl_getmsg("art-085",g_lang)
  #   END IF
  #   IF l_jidu = '2' THEN
  #      LET l_date = l_date||cl_getmsg("art-086",g_lang)
  #   END IF 
  #   IF l_jidu = '3' THEN
  #      LET l_date = l_date||cl_getmsg("art-087",g_lang)
  #   END IF
  #   IF l_jidu = '4' THEN
  #      LET l_date = l_date||cl_getmsg("art-088",g_lang)
  #   END IF
  #   LET l_wc = " AND rtr18 = '",l_date,"'"
  #END IF
  #IF l_rtr08 = '4' THEN
  #   LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
  #   IF l_jidu = '1' THEN
  #      LET l_date = l_date||cl_getmsg("art-089",g_lang)
  #   END IF
  #   IF l_jidu = '2' THEN
  #      LET l_date = l_date||cl_getmsg("art-090",g_lang)
  #   END IF 
  #   IF l_jidu = '3' THEN
  #      LET l_date = l_date||cl_getmsg("art-091",g_lang)
  #   END IF
  #   IF l_jidu = '4' THEN
  #      LET l_date = l_date||cl_getmsg("art-092",g_lang)
  #   END IF
  #   IF l_jidu = '5' THEN
  #      LET l_date = l_date||cl_getmsg("art-093",g_lang)
  #   END IF
  #   IF l_jidu = '6' THEN
  #      LET l_date = l_date||cl_getmsg("art-094",g_lang)
  #   END IF
  #   IF l_jidu = '7' THEN
  #      LET l_date = l_date||cl_getmsg("art-095",g_lang)
  #   END IF
  #   IF l_jidu = '8' THEN
  #      LET l_date = l_date||cl_getmsg("art-097",g_lang)
  #   END IF
  #   IF l_jidu = '9' THEN
  #      LET l_date = l_date||cl_getmsg("art-098",g_lang)
  #   END IF
  #   IF l_jidu = '10' THEN
  #      LET l_date = l_date||cl_getmsg("art-099",g_lang)
  #   END IF
  #   IF l_jidu = '11' THEN
  #      LET l_date = l_date||cl_getmsg("art-100",g_lang)
  #   END IF
  #   IF l_jidu = '12' THEN
  #      LET l_date = l_date||cl_getmsg("art-101",g_lang)
  #   END IF
  #   LET l_wc = " AND rtr18 = '",l_date,"'"
  #END IF
  #arti130中rtr18組的內容語言別是arti130維護時的語言別，如果語言別有改變，則查詢不到，所以暫時用以下方式處理
   LET l_lang_t=g_lang
   LET l_wc=" rtr18 IN ( "
   
   DECLARE gay_cs CURSOR FOR
    SELECT gay01 FROM gay_file
   FOREACH gay_cs INTO g_lang
      IF l_rtr08 = '1' THEN
         LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
         IF cl_null(l_date) THEN CONTINUE FOREACH END IF
         LET l_wc = l_wc CLIPPED," '",l_date,"',"
      END IF
      IF l_rtr08 = '2' THEN
         LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
         IF l_jidu <= 2 THEN
            LET l_date = l_date||cl_getmsg("art-083",g_lang)
         ELSE 
            LET l_date = l_date||cl_getmsg("art-084",g_lang)
         END IF
         IF cl_null(l_date) THEN CONTINUE FOREACH END IF
         LET l_wc = l_wc CLIPPED," '",l_date,"',"
      END IF 
      IF l_rtr08 = '3' THEN
         LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
         IF l_jidu = '1' THEN
            LET l_date = l_date||cl_getmsg("art-085",g_lang)
         END IF
         IF l_jidu = '2' THEN
            LET l_date = l_date||cl_getmsg("art-086",g_lang)
         END IF 
         IF l_jidu = '3' THEN
            LET l_date = l_date||cl_getmsg("art-087",g_lang)
         END IF
         IF l_jidu = '4' THEN
            LET l_date = l_date||cl_getmsg("art-088",g_lang)
         END IF
         IF cl_null(l_date) THEN CONTINUE FOREACH END IF
         LET l_wc = l_wc CLIPPED," '",l_date,"',"
      END IF
      IF l_rtr08 = '4' THEN
         LET l_date = YEAR(g_date)||cl_getmsg("art-082",g_lang)
         IF l_jidu = '1' THEN
            LET l_date = l_date||cl_getmsg("art-089",g_lang)
         END IF
         IF l_jidu = '2' THEN
            LET l_date = l_date||cl_getmsg("art-090",g_lang)
         END IF 
         IF l_jidu = '3' THEN
            LET l_date = l_date||cl_getmsg("art-091",g_lang)
         END IF
         IF l_jidu = '4' THEN
            LET l_date = l_date||cl_getmsg("art-092",g_lang)
         END IF
         IF l_jidu = '5' THEN
            LET l_date = l_date||cl_getmsg("art-093",g_lang)
         END IF
         IF l_jidu = '6' THEN
            LET l_date = l_date||cl_getmsg("art-094",g_lang)
         END IF
         IF l_jidu = '7' THEN
            LET l_date = l_date||cl_getmsg("art-095",g_lang)
         END IF
         IF l_jidu = '8' THEN
            LET l_date = l_date||cl_getmsg("art-097",g_lang)
         END IF
         IF l_jidu = '9' THEN
            LET l_date = l_date||cl_getmsg("art-098",g_lang)
         END IF
         IF l_jidu = '10' THEN
            LET l_date = l_date||cl_getmsg("art-099",g_lang)
         END IF
         IF l_jidu = '11' THEN
            LET l_date = l_date||cl_getmsg("art-100",g_lang)
         END IF
         IF l_jidu = '12' THEN
            LET l_date = l_date||cl_getmsg("art-101",g_lang)
         END IF
         IF cl_null(l_date) THEN CONTINUE FOREACH END IF
         LET l_wc = l_wc CLIPPED," '",l_date,"',"
      END IF
   END FOREACH
   LET l_wc=l_wc CLIPPED
   LET l_wc=l_wc[1,Length(l_wc)-1]," ) "
   LET g_lang=l_lang_t
  #FUN-AB0095 End----- By shi
      
 # LET g_sql = "SELECT sum(rtr10) FROM ",l_dbs,"rtr_file ",                           #FUN-AB0095
 # LET g_sql = "SELECT sum(rtr10) FROM ",cl_get_target_table(p_plant1,'rtr_file'),    #FUN-AB0095
   LET g_sql = "SELECT rtr19,sum(rtr10) FROM ",cl_get_target_table(p_plant1,'rtr_file'), #FUN-AB0095 By shi
               "   WHERE rtr01 = '",p_rto01,"' AND rtr02 = '",p_rto02,"'",
               "     AND rtr03 = '",p_rto03,"' AND rtr04 = '",p_rtr04,"' AND ",l_wc CLIPPED   #FUN-AB0095 mod 
              ,"  AND rtrplant = '",p_plant1,"'",         #FUN-AB0095 Add By shi
               "GROUP BY rtr19 "                          #FUN-AB0095 Add By shi
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-AB0095
  #CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql #FUN-AB0095 #FUN-AB0095 Mark By shi l_w条件显示乱码，所以去掉这个
   PREPARE pre_sel_rtr61 FROM g_sql
  #FUN-AB0095 Begin--- By shi
  #EXECUTE pre_sel_rtr61 INTO l_rtr10
   DECLARE sel_rtr61 CURSOR FOR pre_sel_rtr61
   FOREACH sel_rtr61 INTO l_rtr19,l_rtr10
  #FUN-AB0095 End-----
#TQC-AC0134 ----------------STA
   IF cl_null(l_rtr19) THEN
      LET  g_sql = " SELECT rtp05 FROM ",cl_get_target_table(p_plant1,'rtp_file'),
                   " WHERE rtp01 = '",p_rto01,"' AND rtp02 = '",p_rto02,"'",
                   "   AND rtp03 = '",p_rto03,"' AND rtpplant = '",p_plant1,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
      CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
      PREPARE pre_sel_rtp05 FROM g_sql
      DECLARE sel_rtp05 CURSOR FOR pre_sel_rtp05
      FOREACH sel_rtp05 INTO l_rtp05
         LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(l_rtp05,'ogb_file'),",",         
                                                cl_get_target_table(l_rtp05,'oga_file'),             
                     "    WHERE oga01 = ogb01 AND ogaconf = 'Y' AND ogapost = 'Y' ",
                     "      AND ogaplant = ogbplant AND ogaplant = '",l_rtp05,"'",
                    #"      AND ogacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'",               #FUN-C80095 mark
                     "      AND oga02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                 #FUN-C80095 add
                     "      AND ogb04 IN (",
                     "      SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",
                                              cl_get_target_table(l_rtp05,'rts_file'),
                     "      WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "        AND rtsconf <> 'X' ",  #CHI-C80041
                    #"        AND rtt02 = '",l_rtp05,"')"                                             #FUN-C80095 mark
                     "        AND rtt02 = '",p_rto03,"')"                                             #FUN-C80095 add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                            
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                    
         PREPARE pre_sel_ogb14t_1 FROM g_sql
         EXECUTE pre_sel_ogb14t_1 INTO l_get_money
         LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(l_rtp05,'ohb_file'),",",  
                                                cl_get_target_table(l_rtp05,'oha_file'),      
                     "   WHERE oha01 = ohb01 AND ohapost = 'Y' ",
                     "     AND ohaconf = 'Y' AND ohaplant = ohbplant ",
                     "     AND ohaplant = '",l_rtp05,"'",
                    #"     AND ohacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                 #FUN-C80095 mark
                     "     AND oha02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                   #FUN-C80095 add
                     "     AND ohb04 IN (",
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtp05,'rtt_file'),",",
                                              cl_get_target_table(l_rtp05,'rts_file'),
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "     AND rtsconf <> 'X' ",  #CHI-C80041
                    #"     AND rtt02 = '",l_rtp05,"')"                                                 #FUN-C80095 mark
                     "     AND rtt02 = '",p_rto03,"')"                                                 #FUN-C80095 add 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-AB0095
         CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   #FUN-AB0095
         PREPARE pre_sel_ohb14t_1 FROM g_sql                      #FUN-AB0095 l_sql -> g_sql
         EXECUTE pre_sel_ohb14t_1 INTO l_exit_money     
         IF l_get_money IS NULL THEN LET l_get_money = 0 END IF
         IF l_exit_money IS NULL THEN LET l_exit_money = 0 END IF
         IF cl_null(l_rtr10) THEN LET l_rtr10 = 0 END IF
    #     IF l_get_money - l_exit_money > l_rtr10 THEN                    #MOD-B20085  mark 
          IF l_get_money - l_exit_money < l_rtr10 THEN                    #MOD-B20085
            LET l_lub.lub04t = l_rtr10*l_rtr16/100
         ELSE
            CONTINUE FOREACH
         END IF
         IF l_lub.lub04t IS NULL THEN LET l_lub.lub04t = 0 END IF
#         LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(l_rtp05,'lub_file'),     #MOD-B20085 mark
          LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),     #MOD-B20085
                     "   WHERE lub01 = '",p_no,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             
          CALL  cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql   
          PREPARE pre_sel_lub028 FROM g_sql
          EXECUTE pre_sel_lub028 INTO l_lub.lub02
          IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
          LET l_lub.lub03 = l_rtr06
          IF l_lua23 = 'Y' THEN
             LET l_lub.lub04 = l_lub.lub04t/(1+l_lua22/100)
          ELSE
             LET l_lub.lub04 = l_lub.lub04t
             LET l_lub.lub04t = l_lub.lub04t*(1+l_lua22/100)
          END IF
          LET l_lub.lub07 = l_min_date   #FUN-BC0125
          LET l_lub.lub08 = l_max_date   #FUN-BC0125
          LET l_lub.lub09 = l_oaj05      #FUN-BC0125
          LET l_lub.lub10 = g_date       #FUN-BC0125
          LET l_lub.lub11 = 0            #FUN-BC0125
          LET l_lub.lub12 = 0            #FUN-BC0125
          LET l_lub.lubplant = p_plant
          LET l_lub.lublegal = p_legal
          LET l_lub.lub05 = cl_getmsg("art-996",g_lang),l_rtr19
#          LET g_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'lub_file'),"(",             #MOD-B20085 mark
          LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",              #MOD-B20085
                     #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub05)", 
                     #" VALUES(?,?,?,?,?, ?,?,?) "                               
                      "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub05,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub11,lub12,lub07,lub08
                      " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
          CALL cl_replace_Sqldb(g_sql) RETURNING g_sql          
          CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql 
          PREPARE pre_ins_rub101 FROM g_sql
          EXECUTE pre_ins_rub101 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                              l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                              l_lub.lublegal,l_lub.lub05,               
                              l_lub.lub09,l_lub.lub10,                           #FUN-BC0125 add lub09,lub10
                              l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08    #FUN-BC0125 add lub11,lub12,lub07,lub08
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
             LET g_success='N'
          END IF

       END FOREACH
 
     ELSE
        LET g_sql = "SELECT sum(ogb14t) FROM ",cl_get_target_table(l_rtr19,'ogb_file'),",",
                                                cl_get_target_table(l_rtr19,'oga_file'),
                     "    WHERE oga01 = ogb01 AND ogaconf = 'Y' AND ogapost = 'Y' ",
                     "      AND ogaplant = ogbplant AND ogaplant = '",l_rtr19,"'",
                    #"      AND ogacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'",               #FUN-C80095 mark
                     "      AND oga02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                 #FUN-C80095 add
                     "      AND ogb04 IN (",
                     "      SELECT rtt04 FROM ",cl_get_target_table(l_rtr19,'rtt_file'),",",
                                              cl_get_target_table(l_rtr19,'rts_file'),
                     "      WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "        AND rtsconf <> 'X' ",  #CHI-C80041
                    #"        AND rtt02 = '",l_rtr19,"')"                                             #FUN-C80095 mark
                     "        AND rtt02 = '",p_rto03,"')"                                             #FUN-C80095 add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_rtr19) RETURNING g_sql
         PREPARE pre_sel_ogb14t_2 FROM g_sql
         EXECUTE pre_sel_ogb14t_2 INTO l_get_money
         LET g_sql = "SELECT sum(ohb14t) FROM ",cl_get_target_table(l_rtr19,'ohb_file'),",",
                                                cl_get_target_table(l_rtr19,'oha_file'),
                     "   WHERE oha01 = ohb01 AND ohapost = 'Y' ",
                     "     AND ohaconf = 'Y' AND ohaplant = ohbplant ",
                     "     AND ohaplant = '",l_rtr19,"'",
                    #"     AND ohacond BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                 #FUN-C80095 mark
                     "     AND oha02 BETWEEN '",l_min_date,"' AND '",l_max_date,"'",                   #FUN-C80095 add
                     "     AND ohb04 IN (",
                     "    SELECT rtt04 FROM ",cl_get_target_table(l_rtr19,'rtt_file'),",",
                                              cl_get_target_table(l_rtr19,'rts_file'),
                     "    WHERE rts01 = rtt01 AND rts04 = '",p_rto01,"'",
                     "     AND rtsconf <> 'X' ",  #CHI-C80041
                    #"     AND rtt02 = '",l_rtr19,"')"                                                 #FUN-C80095 mark
                     "     AND rtt02 = '",p_rto03,"')"                                                 #FUN-C80095 add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
        #CALL cl_parse_qry_sql(g_sql,l_rtp05) RETURNING g_sql                                          #FUN-C80095 mark
         CALL cl_parse_qry_sql(g_sql,l_rtr19) RETURNING g_sql                                          #FUN-C80095 add
         PREPARE pre_sel_ohb14t_3 FROM g_sql                      
         EXECUTE pre_sel_ohb14t_3 INTO l_exit_money
         IF l_get_money IS NULL THEN LET l_get_money = 0 END IF
         IF l_exit_money IS NULL THEN LET l_exit_money = 0 END IF
         IF cl_null(l_rtr10) THEN LET l_rtr10 = 0 END IF
#         IF l_get_money - l_exit_money > l_rtr10 THEN       #MOD-B20085   mark
          IF l_get_money - l_exit_money < l_rtr10 THEN       #MOD-B20085
            LET l_lub.lub04t = l_rtr10*l_rtr16/100
         ELSE
            CONTINUE FOREACH
         END IF
         IF l_lub.lub04t IS NULL THEN LET l_lub.lub04t = 0 END IF
#         LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(l_rtr19,'lub_file'), #FUN-AB0095    #MOD-B20085  mark
          LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'),               #MOD-B20085
                     "   WHERE lub01 = '",p_no,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-AB0095
#          CALL  cl_parse_qry_sql(g_sql,l_rtr19) RETURNING g_sql   #FUN-AB0095                            #MOD-B20085  mark
          CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql                                           #MOD-B20085
          PREPARE pre_sel_lub028_1 FROM g_sql
          EXECUTE pre_sel_lub028_1 INTO l_lub.lub02
          IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
          LET l_lub.lub03 = l_rtr06
          IF l_lua23 = 'Y' THEN
             LET l_lub.lub04 = l_lub.lub04t/(1+l_lua22/100)
          ELSE
             LET l_lub.lub04 = l_lub.lub04t
             LET l_lub.lub04t = l_lub.lub04t*(1+l_lua22/100)
          END IF
          LET l_lub.lub07 = l_min_date   #FUN-BC0125
          LET l_lub.lub08 = l_max_date   #FUN-BC0125
          LET l_lub.lub09 = l_oaj05      #FUN-BC0125
          LET l_lub.lub10 = g_date       #FUN-BC0125
          LET l_lub.lub11 = 0            #FUN-BC0125
          LET l_lub.lub12 = 0            #FUN-BC0125
          LET l_lub.lubplant = p_plant
          LET l_lub.lublegal = p_legal
          LET l_lub.lub05 = cl_getmsg("art-996",g_lang),l_rtr19
#          LET g_sql = "INSERT INTO ",cl_get_target_table(l_rtr19,'lub_file'),"(",                 #MOD-B20085  mark
           LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",                 #MOD-B20085
                      #"lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub05)",
                      #" VALUES(?,?,?,?,?, ?,?,?) "
                       "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub05,lub09,lub10,lub11,lub12,lub07,lub08)",   #FUN-BC0125 add lub09,lub10,lub12,lub07,lub08
                       " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "                                     #FUN-BC0125 add ?,?,?,?,?,?
          CALL cl_replace_Sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
          PREPARE pre_ins_rub101_1 FROM g_sql
          EXECUTE pre_ins_rub101_1 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
                              l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
                              l_lub.lublegal,l_lub.lub05,
                              l_lub.lub09,l_lub.lub10,                           #FUN-BC0125 add lub09,lub10
                              l_lub.lub11,l_lub.lub12,l_lub.lub07,l_lub.lub08    #FUN-BC0125 add lub11,lub12,lub07,lub08
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
             LET g_success='N'
          END IF
      END IF
    END FOREACH
  
#TQC-AC0134 ----------------END


#  IF cl_null(l_rtr10) THEN LET l_rtr10 = 0 END IF        #FUN-AB0095 add
#  # LET g_sql = "SELECT MAX(lub02)+1 FROM ",l_dbs,"lub_file ",                        #FUN-AB0095
#  LET g_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant1,'lub_file'), #FUN-AB0095
#              "   WHERE lub01 = '",p_no,"'"
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-AB0095
#  CALL  cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql   #FUN-AB0095
#  PREPARE pre_sel_lub028 FROM g_sql
#  EXECUTE pre_sel_lub028 INTO l_lub.lub02
#  IF l_lub.lub02 IS NULL THEN LET l_lub.lub02 = 1 END IF
#  LET l_lub.lub03 = l_rtr06 
#  IF l_lua23 = 'Y' THEN
#     LET l_lub.lub04t = l_rtr10
#   # LET l_lub.lub04 = l_rtr10/(1+l_lua23/100)      #FUN-AB0095 mark
#     LET l_lub.lub04 = l_rtr10/(1+l_lua22/100)      #FUN-AB0095
#  ELSE
#     LET l_lub.lub04 = l_rtr10
#   # LET l_lub.lub04t = l_rtr10*(1+l_lua23/100)     #FUN-AB0095 mark
#     LET l_lub.lub04t = l_rtr10*(1+l_lua22/100)     #FUN-AB0095 
#  END IF
#  LET l_lub.lubplant = p_plant
#  LET l_lub.lublegal = p_legal
#  LET l_lub.lub05 = cl_getmsg("art-996",g_lang),l_rtr19
#  # LET g_sql = "INSERT INTO ",l_dbs,"lub_file(",                              #FUN-AB0095
#  LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant1,'lub_file'),"(",   #FUN-AB0095
#              "lub01,lub02,lub03,lub04,lub04t,lubplant,lublegal,lub05)", #FUN-AB0095 By shi Add lub05
#              " VALUES(?,?,?,?,?, ?,?,?) "                               #FUN-AB0095 By shi Add ?
#  CALL cl_replace_Sqldb(g_sql) RETURNING g_sql          #FUN-AB0095
#  CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql #FUN-AB0095
#  PREPARE pre_ins_rub101 FROM g_sql
#  EXECUTE pre_ins_rub101 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,
#                             l_lub.lub04,l_lub.lub04t,l_lub.lubplant,
#                             l_lub.lublegal,l_lub.lub05               #FUN-AB0095 By shi Add lub05
#  IF SQLCA.SQLCODE THEN
#     CALL s_errmsg('','ins lub_file','',SQLCA.sqlcode,1)
#     LET g_success='N'
#  END IF
#  END FOREACH #FUN-AB0095 Add By shi
  #FUN-AB0095 ---------------add start-----------
   LET g_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant1,'lub_file'),
               " WHERE lub01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p11 FROM g_sql
   EXECUTE pre_lub04_p11 INTO l_lub04,l_lub04t
   IF SQLCA.SQLCODE AND SQLCA.sqlcode <> 100 THEN
      CALL s_errmsg('','sel lub_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(p_plant1,'lua_file'),
               "   SET lua08 = ?, lua08t = ? ",
               " WHERE lua01 = '",l_lub.lub01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant1) RETURNING g_sql
   PREPARE pre_lub04_p12 FROM g_sql
   EXECUTE pre_lub04_p12 USING l_lub04,l_lub04t
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','upd lua_file','',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
  #FUN-AB0095 ------------add end-----------------------
END FUNCTION 
#FUN-A50102 ----------------------------mark end ----------------------
#FUN-AB0095 ----------------取消mark -------------------------------
 
FUNCTION p104_compute_date(p_rtr08,p_rtr09)
DEFINE p_rtr08         LIKE rtr_file.rtr08
DEFINE p_rtr09         LIKE rtr_file.rtr09
DEFINE l_date          LIKE azmm_file.azmm011
DEFINE l_max_date      LIKE azmm_file.azmm011
DEFINE l_min_date      LIKE azmm_file.azmm011
DEFINE l_azmm013       LIKE azmm_file.azmm013
 
   IF p_rtr08 = '1' THEN
      IF p_rtr09 = '1' THEN
       # SELECT MIN(azmm011)INTO l_date FROM azmm_file WHERE azmm013 = '1'     #FUN-AB0095 mark
         SELECT MIN(azmm011)INTO l_date FROM date_tmp WHERE azmm013 = '1'      #FUN-AB0095
      END IF
      IF p_rtr09 = '2' THEN 
         SELECT MAX(azmm012) INTO l_date FROM date_tmp WHERE azmm013 = '4'
      END IF
   END IF
   IF p_rtr08 = '2' THEN
      SELECT MAX(azmm012) INTO l_date FROM date_tmp WHERE azmm013 = '2'
      IF l_date >= g_date THEN 
         IF p_rtr09 = '1' THEN
          # SELECT MIN(azmm011)INTO l_date FROM azmm_file WHERE azmm013 = '1'     #FUN-AB0095 mark
            SELECT MIN(azmm011)INTO l_date FROM date_tmp WHERE azmm013 = '1'     #FUN-AB0095
         END IF
         IF p_rtr09 = '2' THEN 
            SELECT MAX(azmm012) INTO l_date FROM date_tmp WHERE azmm013 = '2'
         END IF
      ELSE
         IF p_rtr09 = '1' THEN
            SELECT MIN(azmm012) INTO l_date FROM date_tmp WHERE azmm013 = '3'
         END IF
         IF p_rtr09 = '2' THEN 
            SELECT MAX(azmm012) INTO l_date FROM date_tmp WHERE azmm013 = '4'
         END IF
      END IF  
   END IF
   IF p_rtr08 = '3' THEN
      DECLARE cur_date10 CURSOR FOR 
         SELECT MIN(azmm011),MAX(azmm012),azmm013 
            FROM date_tmp 
           GROUP BY azmm013
      FOREACH cur_date10 INTO l_min_date,l_max_date,l_azmm013
         IF g_date >= l_min_date AND g_date <= l_max_date THEN 
            EXIT FOREACH 
         END IF 
      END FOREACH
      IF p_rtr09 = '1' THEN
         LET l_date = l_min_date
      END IF
      IF p_rtr09 = '2' THEN 
         LET l_date = l_max_date
      END IF
   END IF
   IF p_rtr08 = '4' THEN
      SELECT MIN(azmm011),MAX(azmm012) INTO l_min_date,l_max_date 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
      IF p_rtr09 = '1' THEN
         LET l_date = l_min_date
      END IF
      IF p_rtr09 = '2' THEN 
         LET l_date = l_max_date
      END IF
   END IF
   
   RETURN l_date
END FUNCTION  
 
 
FUNCTION p104_compute_date1(p_rtr08)
DEFINE p_rtr08         LIKE rtr_file.rtr08
DEFINE p_rtr09         LIKE rtr_file.rtr09
DEFINE l_min_date      LIKE azmm_file.azmm011
DEFINE l_max_date      LIKE azmm_file.azmm011
DEFINE l_jidu          LIKE azmm_file.azmm012
 
   IF p_rtr08 = '1' THEN
      SELECT MIN(azmm011)INTO l_min_date FROM date_tmp
      SELECT MAX(azmm012)INTO l_max_date FROM date_tmp
   END IF
   IF p_rtr08 = '2' THEN
      SELECT DISTINCT azmm013 INTO l_jidu 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
      IF l_jidu <= 2 THEN 
         SELECT MIN(azmm011)INTO l_min_date FROM date_tmp WHERE azmm013 = '1'
        #SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '1'   #FUN-BC0125 mark
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '2'   #FUN-BC0125 add
      ELSE 
         SELECT MIN(azmm011)INTO l_min_date FROM date_tmp WHERE azmm013 = '3'
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '4'
      END IF   
   END IF 
   IF p_rtr08 = '3' THEN
      DECLARE cur_date1 CURSOR FOR 
         SELECT MIN(azmm011),MAX(azmm012),azmm013 
            FROM date_tmp 
           GROUP BY azmm013
      FOREACH cur_date1 INTO l_min_date,l_max_date,l_jidu
         IF g_date >= l_min_date AND g_date <= l_max_date THEN 
            EXIT FOREACH 
         END IF 
      END FOREACH
   END IF
   IF p_rtr08 = '4' THEN
      SELECT MIN(azmm011),MAX(azmm012) INTO l_min_date,l_max_date 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
   END IF
   
   RETURN l_min_date,l_max_date
END FUNCTION
 
FUNCTION p104_compute_date3(p_rtr08,p_dbs)
DEFINE p_dbs           LIKE azp_file.azp03
DEFINE p_rtr08         LIKE rtr_file.rtr08
DEFINE l_max_date      LIKE azmm_file.azmm011
DEFINE l_min_date      LIKE azmm_file.azmm011
DEFINE l_jidu          LIKE azmm_file.azmm012
 
   IF p_rtr08 = '1' THEN
      SELECT MAX(azmm012)INTO l_max_date FROM date_tmp
   END IF
   IF p_rtr08 = '2' THEN
      SELECT DISTINCT azmm013 INTO l_jidu 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
      IF l_jidu <= 2 THEN 
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '1'
      ELSE
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '4'
      END IF   
   END IF 
   IF p_rtr08 = '3' THEN
      DECLARE cur_date3 CURSOR FOR 
         SELECT MIN(azmm011),MAX(azmm012),azmm013 
            FROM date_tmp 
           GROUP BY azmm013
      FOREACH cur_date3 INTO l_min_date,l_max_date,l_jidu
         IF g_date >= l_min_date AND g_date <= l_max_date THEN 
            EXIT FOREACH 
         END IF 
      END FOREACH
   END IF
   IF p_rtr08 = '4' THEN
      SELECT MAX(azmm012) INTO l_max_date 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
   END IF
   
   RETURN l_max_date
END FUNCTION
 
FUNCTION p104_compute_date6(p_rtr08,p_dbs)
DEFINE p_dbs           LIKE azp_file.azp03
DEFINE p_rtr08         LIKE rtr_file.rtr08
DEFINE l_max_date      LIKE azmm_file.azmm011
DEFINE l_min_date      LIKE azmm_file.azmm011
DEFINE l_jidu          LIKE azmm_file.azmm013
 
   IF p_rtr08 = '1' THEN
      SELECT MAX(azmm012)INTO l_max_date FROM date_tmp   #爛藺
     #SELECT MAX(azmm011)INTO l_min_date FROM date_tmp   #爛場     #FUN-C80095 mark
      SELECT MIN(azmm011)INTO l_min_date FROM date_tmp             #FUN-C80095 add
   END IF
   IF p_rtr08 = '2' THEN
      SELECT DISTINCT azmm013 INTO l_jidu 
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
      IF l_jidu <= 2 THEN 
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '2'
         SELECT MIN(azmm011)INTO l_min_date FROM date_tmp WHERE azmm013 = '1'
      ELSE
         SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = '4'
         SELECT MIN(azmm011)INTO l_min_date FROM date_tmp WHERE azmm013 = '3'
      END IF   
   END IF 
   IF p_rtr08 = '3' THEN
      DECLARE cur_date6 CURSOR FOR 
         SELECT MIN(azmm011),MAX(azmm012),azmm013 
            FROM date_tmp 
           GROUP BY azmm013
      FOREACH cur_date6 INTO l_min_date,l_max_date,l_jidu
         IF g_date >= l_min_date AND g_date <= l_max_date THEN 
            EXIT FOREACH 
         END IF 
      END FOREACH
      SELECT MAX(azmm012)INTO l_max_date FROM date_tmp WHERE azmm013 = l_jidu
      SELECT MIN(azmm011)INTO l_min_date FROM date_tmp WHERE azmm013 = l_jidu
   END IF
   IF p_rtr08 = '4' THEN
      SELECT MAX(azmm012),MIN(azmm011) INTO l_max_date,l_min_date
          FROM date_tmp
        WHERE g_date BETWEEN azmm011 AND azmm012
      LET l_jidu = MONTH(l_max_date)
   END IF
   
   RETURN l_max_date,l_min_date,l_jidu
END FUNCTION

#FUN-AB0095 --------add start----------
FUNCTION p104_delall(p_lua01)
   DEFINE p_lua01   LIKE lua_file.lua01
   DEFINE l_cnt     LIKE type_file.num5

   SELECT count(*) INTO l_cnt FROM lub_file 
    WHERE lub01 = p_lua01
   #單身無資料，不需要產生單頭
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      DELETE FROM lua_file WHERE lua01 = p_lua01
    # LET g_success = 'N'
   END IF 

END FUNCTION
#FUN-AB0095 -------add end-------------   
#FUN-BC0125 add begin---------------------
FUNCTION p104_get_lub07_lub08(p_rtr08,p_type,p_dbs)
   DEFINE p_rtr08 LIKE rtr_file.rtr08,
          p_type  LIKE type_file.chr10,
          p_dbs   LIKE azp_file.azp03
   DEFINE l_lub07 LIKE lub_file.lub07,
          l_lub08 LIKE lub_file.lub08,
          l_judu  LIKE azmm_file.azmm013
   IF p_type = '6' THEN #當為保底費用是調用p104_compute_date6() 
      CALL p104_compute_date6(p_rtr08,p_dbs) RETURNING l_lub08,l_lub07,l_judu
   ELSE
      CALL p104_compute_date1(p_rtr08) RETURNING l_lub07,l_lub08 
   END IF
   #g_min_date小於合同生效日期時，取同生效日期
   IF l_lub07 < g_begin_date THEN
      LET l_lub07 = g_begin_date
   END IF 
   #g_max_date大於合同終止日期時，取同終止日期
   IF l_lub08 > g_end_date THEN
      LET l_lub08= g_end_date
   END IF
   RETURN l_lub07,l_lub08,l_judu
END FUNCTION
#FUN-BC0125 add end-----------------------
#FUN-870007 PASS NO.
