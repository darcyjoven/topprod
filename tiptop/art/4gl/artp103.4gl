# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artp103.4gl 
# Descriptions...: ICD出貨通知單轉出貨單作業
# Date & Author..: FUN-7B0077 08/11/20 By lala
# Modify.........: NO.FUN-870100 09/08/26 By Cockroach 超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.TQC-A60116 10/06/28 By liuxqa 修改g_xxxplant宣告
# Modify.........: No.FUN-A50102 10/07/13 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B30047 11/03/07 By huangtao 計算補貨點異常 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BA0105 11/10/31 By pauline 加上背景作業功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_xxxdate       	 LIKE oga_file.ogacond
DEFINE g_xxxdate_t       LIKE oga_file.ogacond
#DEFINE g_xxxplant        LIKE oga_file.ogaplant   #NO.TQC-A60116 mark
#DEFINE g_xxxplant_t      LIKE oga_file.ogaplant   #No.TQC-A60116 mark
DEFINE g_xxxplant        STRING                    #NO.TQC-A60116 mod
DEFINE g_xxxplant_t      STRING                    #NO.TQC-A60116 mod
DEFINE g_t1       	 LIKE oay_file.oayslip
DEFINE g_buf             LIKE type_file.chr2
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_idd             RECORD LIKE idd_file.*
DEFINE g_idb             RECORD LIKE idb_file.*
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE l_ac              LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品類中的商品
DEFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品牌中的商品
DEFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放廠商中的商品
DEFINE g_no                  DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品編號中的商品
DEFINE g_result              DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE l_flag            LIKE type_file.chr1


MAIN
   DEFINE ls_date  STRING 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

#FUN-BA0105 -------------STA
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_xxxdate = ARG_VAL(1)
   LET g_xxxplant  = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob='N'
   END IF

#FUN-BA0105 -------------END
 
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
#   OPEN WINDOW p103_w AT p_row,p_col WITH FORM "art/42f/artp103"
#     ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#FUN-BA0105 mark END
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF g_bgjob='N' THEN  #FUN-BA0105 add  
         CALL p103_p1()
         IF cl_sure(18,20) THEN
   
            BEGIN WORK
            LET g_success = 'Y'
            CALL p103_p2()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               LET g_xxxplant=''
               DISPLAY g_xxxplant TO xxxplant
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p102_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
#FUN-BA0105 add START
       ELSE
          BEGIN WORK
          LET g_success='Y'
          CALL p103_p2()
          IF g_success = 'Y' THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK
          END IF
          EXIT WHILE
       END IF
#FUN-BA0105 add END
   END WHILE
#   CLOSE WINDOW p103_w    #FUN-BA0105 mark

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p103_p1()
DEFINE li_result       LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_sql           STRING
DEFINE lc_cmd          LIKE type_file.chr1000         #FUN-BA0105  add

#FUN-BA0105 add
   OPEN WINDOW p103_w AT p_row,p_col WITH FORM "art/42f/artp103"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#FUN-BA0105 add

  WHILE TRUE
      CLEAR FORM
 
     INPUT g_xxxdate,g_xxxplant  WITHOUT DEFAULTS
        FROM xxxdate,xxxplant
 
         BEFORE INPUT
            CALL cl_qbe_init()
            LET g_xxxdate = g_today
 
         AFTER FIELD xxxplant
            IF NOT cl_null(g_xxxplant) THEN
               IF g_xxxplant IS NOT NULL THEN
                  CALL p103_chkplant()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD xxxplant                 
                  END IF
                  LET l_sql = cl_replace_str(g_xxxplant,'|',"','")
                  LET l_sql = "('",l_sql,"')"
               END IF              
            END IF
            
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(xxxplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_xxxplant
                  CALL cl_create_qry() RETURNING g_xxxplant
                  DISPLAY g_xxxplant TO xxxplant
                  NEXT FIELD xxxplant
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
         CLOSE WINDOW p103_w
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
        CLOSE WINDOW p103_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
      END IF
#FUN-BA0105 add END
      EXIT WHILE
  END WHILE
#FUN-BA0105 -------------STA
   IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp103"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('artp103','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_xxxdate CLIPPED,"'",
                     " '",g_xxxplant CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('artp103',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p103_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
   END IF
#FUN-BA0105 -------------END 
END FUNCTION
 
FUNCTION p103_chkplant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
DEFINE l_n             LIKE type_file.num5
DEFINE l_str           STRING
 
        LET g_errno = ''
        LET l_str = g_auth
        LET tok = base.StringTokenizer.createExt(g_xxxplant,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           IF l_ck IS NULL THEN CONTINUE WHILE END IF
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
 
FUNCTION p103_p2()
   DEFINE l_date      LIKE oga_file.ogacond
   DEFINE l_date1     LIKE oga_file.ogacond
   DEFINE l_rty02     LIKE rty_file.rty02
   DEFINE l_rty05     LIKE rty_file.rty05
#TQC-B30047 ----------------STA
#  DEFINE l_sma129    LIKE sma_file.sma129
#  DEFINE l_sma130    LIKE sma_file.sma130
   DEFINE l_sma136    LIKE sma_file.sma136
   DEFINE l_sma137    LIKE sma_file.sma137
#TQC-B30047 ----------------END
   DEFINE l_rtz09     LIKE rtz_file.rtz09
   DEFINE l_ogb12     LIKE type_file.num5
   DEFINE l_ohb12     LIKE type_file.num5
   DEFINE l_pmc58     LIKE pmc_file.pmc58
   DEFINE l_pmc59     LIKE pmc_file.pmc59
   DEFINE l_pmc60     LIKE pmc_file.pmc60
   DEFINE l_sql       STRING                  
   DEFINE l_chr       LIKE type_file.chr1
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_no        LIKE type_file.num5
   DEFINE l_avg       LIKE type_file.num5
   DEFINE l_day       LIKE type_file.num5
   DEFINE l_newno     LIKE ruw_file.ruw01
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_count     LIKE type_file.num5
   DEFINE l_period    LIKE type_file.num5
   DEFINE l_period1   LIKE type_file.num5
   DEFINE l_ck        LIKE type_file.chr50
   DEFINE l_plant     LIKE type_file.chr50
#  DEFINE l_dbs       LIKE azp_file.azp03      #FUN-A50102
   DEFINE tok         base.StringTokenizer
 
 
   LET tok = base.StringTokenizer.createExt(g_xxxplant,"|",'',TRUE)
   LET g_cnt = 1
   WHILE tok.hasMoreTokens()
   LET l_plant = tok.nextToken()
#TQC-A10073 MARK&ADD--------------------------------
 # SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant 
#FUN-A50102 ------------------mark start---------------------
#  LET g_plant_new = l_plant
#  CALL s_gettrandbs()
#  LET l_dbs = g_dbs_tra
#  LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102 -----------------mark end-----------------------
#TQC-A10073 MARK&ADD--------------------------------
   IF SQLCA.sqlcode THEN
      CALL cl_err('foreach:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
 
#     LET l_sql = " SELECT sma129,sma130 FROM ",l_dbs CLIPPED,"sma_file "                  #FUN-A50102  mark
#      LET l_sql = " SELECT sma129,sma130 FROM ",cl_get_target_table(l_plant,'sma_file')    #FUN-A50102  #TQC-B30047 mark
      LET l_sql = " SELECT sma136,sma137 FROM ",cl_get_target_table(l_plant,'sma_file')                  #TQC-B30047 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
      PREPARE p103_foreach  FROM l_sql
#      EXECUTE p103_foreach INTO l_sma129,l_sma130                                    #TQC-B30047 mark 
      EXECUTE p103_foreach INTO l_sma136,l_sma137                                     #TQC-B30047 add
 
#     LET l_sql = " SELECT rtz09 FROM ",l_dbs CLIPPED,"rtz_file ",               #FUN-A50102 mark
      LET l_sql = " SELECT rtz09 FROM ",cl_get_target_table(l_plant,'rtz_file'), #FUN-A50102 
                  "  WHERE rtz01= '",l_plant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
      DECLARE p103_foreach1 CURSOR FROM l_sql
      FOREACH p103_foreach1 INTO l_rtz09
         IF STATUS THEN
            CALL cl_err('p103_foreach1:',STATUS,1)
            LET l_chr='N'
            EXIT FOREACH
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
 
#     LET l_sql = " SELECT rty02,rty05 FROM ",l_dbs CLIPPED,"rty_file ",                #FUN-A50102  mark
      LET l_sql = " SELECT rty02,rty05 FROM ",cl_get_target_table(l_plant,'rty_file'),  #FUN-A50102
                  "  WHERE rty01= '",l_plant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
      DECLARE p103_foreach2 CURSOR FROM l_sql
      FOREACH p103_foreach2 INTO l_rty02,l_rty05
         IF STATUS THEN
            CALL cl_err('p103_foreach2:',STATUS,1)
            LET l_chr='N'
            EXIT FOREACH
            LET g_success='N'
            RETURN
         END IF
 
#        LET l_sql = " SELECT pmc58,pmc59,pmc60 FROM ",l_dbs CLIPPED,"pmc_file ",               #FUN-A50102 mark
         LET l_sql = " SELECT pmc58,pmc59,pmc60 FROM ",cl_get_target_table(l_plant,'pmc_file'), #FUN-A50102   
                     "  WHERE pmc01= '",l_rty05,"'",
                     "    AND pmc05='1' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
         DECLARE p103_foreach3 CURSOR FROM l_sql
         FOREACH p103_foreach3 INTO l_pmc58,l_pmc59,l_pmc60
            IF STATUS THEN
               CALL cl_err('p103_foreach3:',STATUS,1)
               LET l_chr='N'
               EXIT FOREACH
               LET g_success='N'
               RETURN
            END IF
         END FOREACH
 
         IF cl_null(l_pmc59) THEN LET l_pmc59=1 END IF
#         LET l_date=g_xxxdate-l_sma130                   #TQC-B30047 mark
         LET l_date=g_xxxdate-l_sma137                    #TQC-B30047
         LET l_date1=g_xxxdate-1
 
#        LET l_sql = " SELECT SUM(ogb12) FROM ",l_dbs CLIPPED,"oga_file, ",                  #FUN-A50102  mark
#                                               l_dbs CLIPPED,"ogb_file ",                   #FUN-A50102  mark
         LET l_sql = " SELECT SUM(ogb12) FROM ",cl_get_target_table(l_plant,'oga_file'),",", #FUN-A50102  
                                                cl_get_target_table(l_plant,'ogb_file'),     #FUN-A50102 
                     "  WHERE oga01=ogb01 ",
                     "    AND ogaconf= 'Y' ",
                     "    AND ogacond>= '",l_date,"'",
                     "    AND ogacond<= '",l_date1,"'",
                     "    AND ogb04= '",l_rty02,"'",
                     "    AND ogaplant=ogbplant ",
                     "    AND ogaplant= '",l_plant,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
        DECLARE p103_foreach4 CURSOR FROM l_sql
        FOREACH p103_foreach4 INTO l_ogb12
           IF STATUS THEN
               CALL cl_err('p103_foreach4:',STATUS,1)
               LET l_chr='N'
               EXIT FOREACH
               LET g_success='N'
               RETURN
           END IF
        END FOREACH
 
#        LET l_sql = " SELECT SUM(ohb12) FROM ",l_dbs CLIPPED,"oha_file, ",                     #FUN-A50102 amrk
#                                               l_dbs CLIPPED,"ohb_file ",                      #FUN-A50102 mark
         LET l_sql = " SELECT SUM(ohb12) FROM ",cl_get_target_table(l_plant,'oha_file'),",",    #FUN-A50102
                                                cl_get_target_table(l_plant,'ohb_file'),        #FUN-A50102 
                     "  WHERE oha01=ohb01 ",
                     "    AND ohaconf= 'Y' ",
                     "    AND ohacond>= '",l_date,"'",
                     "    AND ohacond<= '",l_date1,"'",
                     "    AND ohb04= '",l_rty02,"'",
                     "    AND ohaplant=ohbplant ",
                     "    AND ohaplant= '",l_plant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102 
         DECLARE p103_foreach5 CURSOR FROM l_sql
         FOREACH p103_foreach5 INTO l_ohb12
            IF STATUS THEN
               CALL cl_err('p103_foreach5:',STATUS,1)
               LET l_chr='N'
               EXIT FOREACH
               LET g_success='N'
               RETURN
            END IF
         END FOREACH
 
   LET l_day=0
   IF l_pmc60[1,1]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[2,2]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[3,3]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[4,4]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[5,5]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[6,6]=1 THEN LET l_day=l_day+1 END IF
   IF l_pmc60[7,7]=1 THEN LET l_day=l_day+1 END IF
   IF cl_null(l_ogb12) THEN LET l_ogb12=0 END IF
   IF cl_null(l_ohb12) THEN LET l_ohb12=0 END IF
#   LET l_avg=(l_ogb12-l_ohb12)/l_sma130                  #TQC-B30047 mark
    LET l_avg=(l_ogb12-l_ohb12)/l_sma137                  #TQC-B30047
   LET l_period=l_pmc58+l_rtz09
   LET l_period1=l_pmc59*7/l_day
#  IF l_sma129='1' THEN                  #TQC-B30047  mark
   IF l_sma136='1' THEN                  #TQC-B30047
      LET l_no=l_avg*l_period
   ELSE
      LET l_no=l_avg*l_period1
   END IF
 
   UPDATE rty_file SET rty09=l_no WHERE rty01=l_plant AND rty02=l_rty02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins rty',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   LET g_cnt = g_cnt + 1
   END FOREACH
   END WHILE
 
   IF g_success = 'N' THEN
      RETURN
   END IF
 
END FUNCTION
#FUN-870100
