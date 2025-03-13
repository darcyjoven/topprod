# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: artp102.4gl 
# Descriptions...: 存份作
# Date & Author..: FUN-7B0077 08/10/08 By lala
# Modify.........: FUN-870007 09/06/01 根据期末存,tlf10重新算存
# Modify.........: NO.FUN-870100 09/08/26 By Cockroach 超市移植 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/21 By douzh GP5.2集團架構的sub相關設定修改
# Modify.........: No.FUN-9B0068 09/11/10 By lilingyu 臨時表的字段改成LIKE的形式
# Modify.........: No.TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/07/13 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B10067 11/01/10 By huangtao 修改bug
# Modify.........: No.TQC-B20082 11/02/21 By huangtao rut07掛賬數量改為No Use 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BA0105 11/11/09 By pauline 加上背景作業功能
# Modify.........: No.TQC-BC0001 11/12/01 By suncx 本期異動庫存需要根據asms230設置的庫存帳務基礎日期方式區分抓取方式
# Modify.........: No.FUN-BB0085 11/12/27 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-C70022 12/07/06 By yangxf 重寫FUNCTION p102_p2()
# Modify.........: No.CHI-CB0046 12/12/10 By Lori 訊息axc-096，若選"否"應返回，不可繼續執行下去，不然必定跳出-268的錯誤
# Modify.........: No.FUN-CC0064 12/12/20 By xumeimei 增加判斷:POS未日結,不允許執行！ 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rus           RECORD LIKE rus_file.*,
       g_rus_t         RECORD LIKE rus_file.*
DEFINE g_rus04       	 LIKE rus_file.rus04
DEFINE g_rus04_t         LIKE rus_file.rus04
DEFINE g_rusplant       	 STRING
DEFINE g_rusplant_t        STRING
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
DEFINE g_sort            DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品類中的商品
DEFINE g_sign            DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品牌中的商品
DEFINE g_factory         DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放廠商中的商品
DEFINE g_no              DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品編號中的商品
DEFINE g_result          DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE l_flag            LIKE type_file.chr1
DEFINE l_ok              LIKE type_file.chr1
DEFINE g_num             LIKE type_file.num10                    #FUN-C70022 add 
DEFINE g_wc              STRING                                  #FUN-C70022 add
DEFINE g_wc1             STRING                                  #FUN-C70022 add
DEFINE g_success_num     LIKE type_file.num10                    #FUN-C70022 add

MAIN
   DEFINE ls_date  STRING 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

#FUN-BA0105 -------------STA
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_rus04 = ARG_VAL(1)
   LET g_rusplant  = ARG_VAL(2)
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
 
   LET p_row = 5 LET p_col = 28

#FUN-BA0105 mark START 
#   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "art/42f/artp102"
#     ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#FUN-BA0105 mark END
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF g_bgjob='N' THEN       #FUN-BA0105 add     
         CALL p102_p1()
         IF cl_sure(18,20) THEN
#           BEGIN WORK          #FUN-C70002 mark
            LET g_success = 'Y'
            CALL p102_p2()
#           IF g_success = 'Y' THEN                     #FUN-C70002 mark
#              COMMIT WORK                              #FUN-C70002 mark
            IF g_success_num > 0 THEN                   #FUN-C70002 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
#              ROLLBACK WORK    #FUN-C70002 mark
               IF l_ok=0 THEN 
                  CALL cl_err('','art-534',1)
               END IF
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               LET g_rusplant=''
               DISPLAY g_rusplant TO rusplant
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
         LET g_success = 'Y'
         CALL p102_p2()
         EXIT WHILE
      END IF
#FUN-BA0105 add END
   END WHILE
#   CLOSE WINDOW p102_w   #FUN-BA0105 mark

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p102_p1()
DEFINE li_result       LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_sql           STRING
DEFINE lc_cmd          LIKE type_file.chr1000     #FUN-BA0105 add 
#FUN-BA0105 add START
   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "art/42f/artp102"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#FUN-BA0105 add END
  WHILE TRUE
      CLEAR FORM
 
     INPUT g_rus04,g_rusplant  WITHOUT DEFAULTS
        FROM rus04,rusplant
 
         BEFORE INPUT
            CALL cl_qbe_init()
            LET g_rus04 = g_today
 
         AFTER FIELD rusplant
            IF NOT cl_null(g_rusplant) THEN
               IF g_rusplant IS NOT NULL THEN
                  CALL p102_chkplant()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rusplant                 
                  END IF
                  LET l_sql = cl_replace_str(g_rusplant,'|',"','")
                  LET l_sql = "('",l_sql,"')"
               END IF              
            END IF
 
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rusplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_rusplant
                  CALL cl_create_qry() RETURNING g_rusplant
                  DISPLAY g_rusplant TO rusplant
                  NEXT FIELD rusplant
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
         CLOSE WINDOW p102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-BA0105 -------------STA
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
        CLOSE WINDOW p102_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
      END IF
#FUN-BA0105 -------------END
      EXIT WHILE
  END WHILE

#FUN-BA0105 -------------STA
   IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp102"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('artp102','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_rus04 CLIPPED,"'",
                     " '",g_rusplant CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('artp102',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p102_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
   END IF
#FUN-BA0105 -------------END
 
END FUNCTION
 
FUNCTION p102_chkplant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
DEFINE l_n             LIKE type_file.num5
DEFINE l_str           STRING
 
        LET g_errno = ''
        LET l_str = g_auth
        LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
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
 
#FUN-C70022 MARK BEGIN ---
#FUNCTION p102_p2()
#   DEFINE l_rus01     LIKE rus_file.rus01
#   DEFINE l_rus05     LIKE rus_file.rus05
#   DEFINE l_rus07     LIKE rus_file.rus07
#   DEFINE l_rus09     LIKE rus_file.rus09
#   DEFINE l_rus11     LIKE rus_file.rus11
#   DEFINE l_rus13     LIKE rus_file.rus13
#   DEFINE l_img09     LIKE img_file.img09
#   DEFINE l_img10     LIKE img_file.img10
##  DEFINE l_tqa05     LIKE tqa_file.tqa05
#   DEFINE l_rutlegal  LIKE rut_file.rutlegal
#   DEFINE l_rtz04     LIKE rtz_file.rtz04
#   DEFINE l_rte03     LIKE rte_file.rte03
#   DEFINE l_n1        LIKE type_file.num5
#   DEFINE l_n2        LIKE type_file.num5
#   DEFINE l_n3        LIKE type_file.num5   
#   DEFINE l_n4        LIKE type_file.num5
#   DEFINE l_sql       STRING                  
#   DEFINE l_chr       LIKE type_file.chr1
#   DEFINE l_n         LIKE type_file.num5
#   DEFINE l_newno     LIKE ruw_file.ruw01
#   DEFINE li_result   LIKE type_file.num5
#   DEFINE l_count     LIKE type_file.num5
#   DEFINE l_ck        LIKE type_file.chr50
#   DEFINE l_sort      LIKE type_file.chr50
#   DEFINE l_sign      LIKE type_file.chr50
#   DEFINE l_factory   LIKE type_file.chr50
#   DEFINE l_no        LIKE type_file.chr50
#   DEFINE l_store     LIKE type_file.chr50
#   DEFINE l_plant     LIKE type_file.chr50
##  DEFINE l_dbs       LIKE azp_file.azp03       #FUN-A50102
##  DEFINE l_dbs1      LIKE azp_file.azp03       #FUN-A50102
#   DEFINE tok,tok1,tok2,tok3,tok4,tok5  base.StringTokenizer
##   DEFINE l_sum       LIKE oeb_file.oeb12      #TQC-B20082  mark
##   DEFINE l_sum1      LIKE oeb_file.oeb12      #TQC-B20082  mark
#   DEFINE l_ruj04     LIKE ruj_file.ruj04
#   DEFINE l_ruj08     LIKE ruj_file.ruj08
#   DEFINE l_flag      LIKE type_file.num5
#   DEFINE l_fac       LIKE oeb_file.oeb05_fac
#DEFINE l_month LIKE type_file.num5
#DEFINE l_tlf10 LIKE tlf_file.tlf10
#DEFINE l_imk09 LIKE imk_file.imk09
#DEFINE l_plant1       LIKE azp_file.azp01        #FUN-980020
#DEFINE l_count1    LIKE type_file.num5           #TQC-B20082
#DEFINE l_count2    LIKE type_file.num5           #TQC-B20082
#DEFINE l_ruwconf   LIKE ruw_file.ruwconf         #TQC-B20082
# 
#    LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
#    LET g_cnt = 1
#    WHILE tok.hasMoreTokens()
#       LET l_plant = tok.nextToken()
#       #TQC-A10073 MARK&ADD---------------------------
#       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant 
##FUN-A50102 ----------mark start---------------------
##       LET g_plant_new = l_plant
##       CALL s_gettrandbs()
##       LET l_dbs = g_dbs_tra
##       LET l_dbs = s_dbstring(l_dbs CLIPPED)
##      #TQC-A10073 MARK&ADD---------------------------
##FUN-A50102 ---------mark end------------------------
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           LET g_success='N'
#           RETURN
#        END IF
# 
##       LET l_sql = " SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rus_file ",                  #FUN-A50102  mark
#        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rus_file'),    #FUN-A50102 
#                    "  WHERE rus04='",g_rus04,"'",
#                    "    AND rusplant='",l_plant,"'",
#                    "    AND rusconf='Y'",
#                    "    ORDER BY rus01 "
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql       #FUN-A50102
#        PREPARE p102_foreach2  FROM l_sql
#        EXECUTE p102_foreach2 INTO l_count
# 
#        IF l_count>0 THEN LET l_ok=1 END IF
# 
##       LET l_sql = " SELECT DISTINCT rus01,rus05,rus07,rus09,rus11,rus13 FROM ",l_dbs CLIPPED,"rus_file ",               #FUN-A50102 mark
#        LET l_sql = " SELECT DISTINCT rus01,rus05,rus07,rus09,rus11,rus13 FROM ",cl_get_target_table(l_plant,'rus_file'), #FUN-A50102 
#                    "  WHERE rus04='",g_rus04,"'",
#                    "    AND rusplant='",l_plant,"'",
#                    "    AND rusconf='Y'",
#                    "    ORDER BY rus01 "
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql       #FUN-A50102
#        DECLARE p102_foreach CURSOR FROM l_sql
# 
#        FOREACH p102_foreach INTO l_rus01,l_rus05,l_rus07,l_rus09,l_rus11,l_rus13
#           IF STATUS THEN
#              CALL cl_err('p102_foreach:',STATUS,1)
#              LET l_chr='N'
#              EXIT FOREACH
#              LET g_success='N'
#              RETURN
#           END IF
# 
##TQC-B20082 ----------STA
#           LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rut_file'),
#                       "  WHERE rut02='",g_rus04,"'",
#                       "    AND rutplant = '",l_plant,"'",
#                       "    AND rut01 = '",l_rus01,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
#           PREPARE p102_rut  FROM l_sql
#           EXECUTE p102_rut  INTO l_count1
#           IF l_count1 > 0 THEN
#              LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ruw_file'),        
#                          " WHERE ruw02 = '",l_rus01,"'",
#                          "  AND ruw00 = '1'",
#                          "  AND ruwconf = 'Y'"
#              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
#              PREPARE p102_ruw  FROM l_sql
#              EXECUTE p102_ruw INTO l_count2
#              IF l_count2 = 0 THEN
#                IF  cl_confirm('axc-096') THEN
#                   LET l_sql = " DELETE FROM ",cl_get_target_table(l_plant,'rut_file'),
#                               " WHERE rut01 = '",l_rus01,"'",
#                               "   AND rutplant = '",l_plant,"'"
#                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#                   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
#                   PREPARE p102_del_ruw  FROM l_sql
#                   EXECUTE p102_del_ruw
#                ELSE
#                   LET g_success='N'
#                   RETURN
#                END IF
#              END IF
#           END IF
##TQC-B20082 ----------END
##shop
#           LET g_errno = ''
#           IF cl_null(l_rus07) AND cl_null(l_rus09)
#             AND cl_null(l_rus11) AND cl_null(l_rus13) THEN
#            #SELECT tqa05 INTO l_tqa05 FROM tqa_file,rtz_file WHERE tqa03='14' AND tqa01=rtz02
#            #   AND rtz01 = l_plant
#            #IF l_tqa05 IS NULL THEN LET l_tqa05 = ' ' END IF
#            #IF l_tqa05 <> 'Y' THEN
#             SELECT rtz04 INTO l_rtz04 FROM tqa_file,rtz_file WHERE tqa03='14' AND tqa01=rtz02
#                AND rtz01 = l_plant
#             IF l_rtz04 IS NULL THEN LET l_rtz04 = ' ' END IF 
#             IF NOT cl_null(l_rtz04) THEN  
#                SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = l_plant
#               #LET l_sql = "SELECT rte03 FROM ",l_dbs CLIPPED,"rte_file WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' " #FUN-A50102 mark
#                LET l_sql = "SELECT rte03 FROM ",cl_get_target_table(l_plant,'rte_file'),        #FUN-A50102
#                            " WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' "                      #FUN-A50102  
#                CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                     #FUN-A50102
#                CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                             #FUN-A50102 
#                PREPARE rte_pb1 FROM l_sql
#                DECLARE rte_cs1 CURSOR FOR rte_pb1
#                LET g_cnt = 1
#                FOREACH rte_cs1 INTO l_rte03
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                      EXIT FOREACH
#                      LET g_success='N'
#                      RETURN
#                   END IF
#                   IF l_rte03 IS NULL THEN CONTINUE FOREACH END IF
#                   LET g_result[g_cnt] = l_rte03
#                   LET g_cnt = g_cnt + 1
#                END FOREACH
#                CALL g_result.deleteElement(g_cnt)
#             END IF
#          END IF
#
##FUN-9B0068 --BEGIN-- 
##        CREATE TEMP TABLE sort(ima01 varchar(40))
##        CREATE TEMP TABLE sign(ima01 varchar(40))
##        CREATE TEMP TABLE factory(ima01 varchar(40))
##        CREATE TEMP TABLE no(ima01 varchar(40))
#
#         CREATE TEMP TABLE sort(
#                     ima01 LIKE ima_file.ima01)
#         CREATE TEMP TABLE sign(
#                     ima01 LIKE ima_file.ima01)
#         CREATE TEMP TABLE factory(
#                     ima01 LIKE ima_file.ima01)
#         CREATE TEMP TABLE no(
#               ima01 LIKE ima_file.ima01)
##FUN-9B0068 --END--
# 
##sort
#         CALL g_sort.clear()
#          IF NOT cl_null(l_rus07) THEN
#             LET tok1 = base.StringTokenizer.createExt(l_rus07,"|",'',TRUE)
#             LET g_cnt = 1
#             WHILE tok1.hasMoreTokens()
#                LET l_sort = tok1.nextToken()
#               #LET g_sql = "SELECT ima01 FROM ",l_dbs CLIPPED,"ima_file WHERE ima131 = '",l_sort,"'"    #FUN-A50102 mark
#                LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(l_plant,'ima_file'),                #FUN-A50102
#                            " WHERE ima131 = '",l_sort,"'"                                               #FUN-A50102 
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql    #FUN-A50102  
#                PREPARE p102_pb1 FROM g_sql
#                DECLARE rus_cs1 CURSOR FOR p102_pb1
#                FOREACH rus_cs1 INTO g_sort[g_cnt]
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                      EXIT FOREACH
#                      LET g_success='N'
#                      RETURN
#                   END IF
#                   INSERT INTO sort VALUES(g_sort[g_cnt])
#                   LET g_cnt = g_cnt + 1
#                END FOREACH
#             END WHILE
#             CALL g_sort.deleteElement(g_cnt)
#          END IF
##sort
# 
##sign
#          CALL g_sign.clear()
#          IF NOT cl_null(l_rus09) THEN
#             LET tok2 = base.StringTokenizer.createExt(l_rus09,"|",'',TRUE)
#             LET g_cnt = 1
#             WHILE tok2.hasMoreTokens()
#                LET l_sign = tok2.nextToken()
#               #LET g_sql = "SELECT ima01 FROM ",l_dbs CLIPPED,"ima_file WHERE ima1005 = '",l_sign,"'"     #FUN-A50102 mark
#                LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(l_plant,'ima_file'),                  #FUN-A50102
#                            " WHERE ima1005 = '",l_sign,"'"                                                #FUN-A50102 
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql            #FUN-A50102         
#                PREPARE p102_pb2 FROM g_sql
#                DECLARE rus_cs2 CURSOR FOR p102_pb2
#                FOREACH rus_cs2 INTO g_sign[g_cnt]
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                      EXIT FOREACH
#                      LET g_success='N'
#                      RETURN
#                   END IF
#                   INSERT INTO sign VALUES(g_sign[g_cnt])
#                   LET g_cnt = g_cnt + 1
#                END FOREACH
#             END WHILE
#             CALL g_sign.deleteElement(g_cnt)
#          END IF
##sign
# 
##factory
#          CALL g_factory.clear()
#          IF NOT cl_null(l_rus11) THEN
#             LET tok3 = base.StringTokenizer.createExt(l_rus11,"|",'',TRUE)
#             LET g_cnt = 1
#             WHILE tok3.hasMoreTokens()
#                LET l_factory = tok3.nextToken()
#               #LET g_sql = "SELECT rty02 FROM ",l_dbs CLIPPED,"rty_file ",                #FUN-A50102  mark
#                LET g_sql = "SELECT rty02 FROM ",cl_get_target_table(l_plant,'rty_file'),  #FUN-A50102
#                            " WHERE rty05 = '",l_factory,"' AND rty01 = '",l_plant,"'" 
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql  #FUN-A50102 
#                PREPARE p102_pb3 FROM g_sql
#                DECLARE rus_cs3 CURSOR FOR p102_pb3
#                FOREACH rus_cs3 INTO g_factory[g_cnt]
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                      EXIT FOREACH
#                      LET g_success='N'
#                      RETURN
#                   END IF
#                   INSERT INTO factory VALUES(g_factory[g_cnt])
#                   LET g_cnt = g_cnt + 1
#                END FOREACH
#             END WHILE
#             CALL g_factory.deleteElement(g_cnt)
#          END IF
##factory
# 
##no
#          CALL g_no.clear()
#          IF NOT cl_null(l_rus13) THEN
#             LET tok4 = base.StringTokenizer.createExt(l_rus13,"|",'',TRUE)
#             LET g_cnt = 1
#             WHILE tok4.hasMoreTokens()
#                LET l_no = tok4.nextToken()
#                LET g_no[g_cnt] = l_no
#                INSERT INTO no VALUES(g_no[g_cnt]) 
#                LET g_cnt = g_cnt + 1
#             END WHILE
#             CALL g_no.deleteElement(g_cnt)
#          END IF
##no
# 
#          SELECT count(*) INTO l_n1 FROM sort
#          SELECT count(*) INTO l_n2 FROM sign
#          SELECT count(*) INTO l_n3 FROM factory
#          SELECT count(*) INTO l_n4 FROM no
#        
#          CALL g_result.clear()
#          LET l_sql = ''                    #TQC-B10067 add
#          IF l_n1 != 0 THEN
#             IF l_n2 != 0 THEN
#                IF l_n3 != 0 THEN
#                   IF l_n4 != 0 THEN
#                      LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
#                                 " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
#                                 " AND C.ima01 = D.ima01 "
#                  ELSE
#                     LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
#                                 " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
#                  END IF
#               ELSE                     
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
#                                 " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
#                  ELSE
#                     LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
#                                 " WHERE A.ima01 = B.ima01 "
#                  END IF
#               END IF
#            ELSE
#               IF l_n3 != 0 THEN
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
#                                 " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
#                  ELSE
#                     LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
#                                 " WHERE A.ima01 = C.ima01 "
#                  END IF
#               ELSE
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
#                                 " WHERE A.ima01 = D.ima01"
#                  ELSE
#                     LET l_sql = "SELECT A.ima01 FROM sort A "
#                  END IF
#               END IF
#            END IF
#         ELSE
#            IF l_n2 != 0 THEN
#               IF l_n3 != 0 THEN
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
#                                 " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 " 
#                  ELSE
#                     LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
#                                 " WHERE B.ima01 = C.ima01 "
#                  END IF
#               ELSE
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
#                                 " WHERE B.ima01 = D.ima01 "
#                  ELSE
#                     LET l_sql = "SELECT B.ima01 FROM sign B "
#                  END IF
#               END IF
#            ELSE
#               IF l_n3 != 0 THEN
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
#                                 " WHERE C.ima01 = D.ima01 "
#                  ELSE
#                     LET l_sql = "SELECT C.ima01 FROM factory C "
#                  END IF
#               ELSE
#                  IF l_n4 != 0 THEN
#                     LET l_sql = "SELECT D.ima01 FROM no D "
#                  END IF
#               END IF
#            END IF
#         END IF
#   
#         IF l_sql IS NULL THEN 
#       #TQC-B10067 ----------------STA
#       #     RETURN 
#            LET l_sql = " SELECT ima01 FROM ",cl_get_target_table(l_plant,'ima_file')
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
#            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
#       #TQC-B10067 ----------------END
#         END IF
#         PREPARE p102_get_pb FROM l_sql
#         DECLARE rus_get_cs1 CURSOR FOR p102_get_pb
#         LET g_cnt = 1
#         FOREACH rus_get_cs1 INTO g_result[g_cnt]
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#               LET g_success='N'
#               RETURN
#            END IF
#            
#            LET g_cnt = g_cnt + 1
#         END FOREACH  
#         CALL g_result.deleteElement(g_cnt)
#       
#         DROP TABLE sort
#         DROP TABLE sign
#         DROP TABLE factory
#         DROP TABLE NO
#       
#         IF g_result.getLength() = 0 THEN
#            LET g_success='N'
#            RETURN
#         ELSE
#            IF cl_null(g_result[1]) THEN
#               LET g_success='N'
#               RETURN
#            END IF
#         END IF
##shop
# 
#         LET tok5 = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
#         LET g_cnt = 1
#         WHILE tok5.hasMoreTokens()
#            LET l_store = tok5.nextToken()
#               FOR g_cnt=1 TO g_result.getLength()
#      #No.FUN-870007-start-
#      #         LET l_sql = " SELECT img09,img10 FROM ",l_dbs CLIPPED,"img_file ",
#      #                     "  WHERE img01 = '",g_result[g_cnt],"'",
#      #                     "    AND img02 = '",l_store,"'",
#      #                     "    AND img03 = ' ' ",
#      #                     "    AND img04 = ' ' ",
#      #                     "    AND imgplant= '",l_plant,"'",
#      #                     "    ORDER BY img09,img10 "
#      #
#      #         DECLARE p102_foreach1 CURSOR FROM l_sql
#      #
#      #         FOREACH p102_foreach1 INTO l_img09,l_img10
#      #            IF STATUS THEN
#      #               CALL cl_err('p102_foreach1:',STATUS,1)
#      #               LET l_chr='N'
#      #               EXIT FOREACH
#      #               LET g_success='N'
#      #               RETURN
#      #            END IF
#              LET l_month = MONTH(g_rus04)
#             #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"tlf_file",                   #FUN-A50102 mark
#              LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'tlf_file'),    #FUN-A50102
#                          " WHERE tlf01 = '",g_result[g_cnt],"'",
#                          "   AND (tlf907 <> 0)  AND tlf902 = '",l_store,"'",
#                          "   AND tlf903 = ' '",
#                          "   AND tlf904 = ' '"
#              CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
#              CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
#              PREPARE tlf_cs FROM g_sql
#              EXECUTE tlf_cs INTO l_n
#              IF l_n=0 THEN
#                 CONTINUE FOR
#             END IF
#             IF g_sma.sma892 = '2' THEN  #TQC-BC0001 add
#               #LET g_sql = "SELECT COALESCE(SUM(tlf10*tlf12*tlf907),0) FROM ",l_dbs CLIPPED,"tlf_file",                 #FUN-A50102 mark
#                LET g_sql = "SELECT COALESCE(SUM(tlf10*tlf12*tlf907),0) FROM ",cl_get_target_table(l_plant,'tlf_file'),  #FUN-A50102 
#                            " WHERE tlf01 = '",g_result[g_cnt],"'",
#                            "   AND (tlf907 <> 0)  AND tlf902 = '",l_store,"'",
#                            "   AND tlf903 = ' '",
#                            "   AND tlf904 = ' '",
#                           #"   AND to_char(tlf07,'mm')>",l_month-1,         #FUN-A50102  mark
#                           #"   AND to_char(tlf07,'mm')<=",l_month           #FUN-A50102  mark
#                            "   AND MONTH(tlf07)>",l_month-1,                #FUN-A50102 add
#                            "   AND MONTH(tlf07)<=",l_month                  #FUN-A50102 ADD
#                            ,"  AND tlf07 <='",g_rus04,"'"                   #TQC-B10067 add 
#            #TQC-BC0001 add begin---------------------------------------------
#             ELSE
#                LET g_sql = "SELECT COALESCE(SUM(tlf10*tlf12*tlf907),0) FROM ",cl_get_target_table(l_plant,'tlf_file'),
#                            " WHERE tlf01 = '",g_result[g_cnt],"'",
#                            "   AND (tlf907 <> 0)  AND tlf902 = '",l_store,"'",
#                            "   AND tlf903 = ' '",
#                            "   AND tlf904 = ' '",
#                            "   AND MONTH(tlf06)>",l_month-1,
#                            "   AND MONTH(tlf06)<=",l_month
#                            ,"  AND tlf06 <='",g_rus04,"'"
#             END IF
#            #TQC-BC0001 add end-----------------------------------------------
#             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
#             CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql         #FUN-A50102
#             PREPARE tlf_sum FROM g_sql
#             EXECUTE tlf_sum INTO l_tlf10
#             IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF              #TQC-B10067
#            #LET g_sql = "SELECT COALESCE(imk09,0) FROM ",l_dbs CLIPPED,"imk_file",                     #FUN-A50102 mark
##TQC-B10067 -------------STA
#             IF l_month-1 = 0 THEN
#                LET g_sql = "SELECT COALESCE(imk09,0) FROM ",cl_get_target_table(l_plant,'imk_file'),      #FUN-A50102
#                            " WHERE imk01 = '",g_result[g_cnt],"'",
#                            "   AND imk02 = '",l_store,"'",
#                            "   AND imk03 = ' '",
#                            "   AND imk04 = ' '",
#                            "   AND imk05 = ",YEAR(g_rus04)-1,
#                            "   AND imk06 = 12 "
#             ELSE     
##TQC-B10067 -------------END
#                LET g_sql = "SELECT COALESCE(imk09,0) FROM ",cl_get_target_table(l_plant,'imk_file'),      #FUN-A50102
#                            " WHERE imk01 = '",g_result[g_cnt],"'",
#                            "   AND imk02 = '",l_store,"'",
#                            "   AND imk03 = ' '",
#                            "   AND imk04 = ' '",
#                            "   AND imk05 = ",YEAR(g_rus04),
#                            "   AND imk06 = ",l_month-1
#             END IF                                                    #TQC-B10067  add
#             CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
#             CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql      #FUN-A50102
#             PREPARE imk09_cs FROM g_sql
#             EXECUTE imk09_cs INTO l_imk09
#             IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF                #TQC-B10067 
#             LET l_img10 = l_tlf10 + l_imk09
#            #LET g_sql = " SELECT img09 FROM ",l_dbs CLIPPED,"img_file ",                #FUN-A50102  mark
#             LET g_sql = " SELECT img09 FROM ",cl_get_target_table(l_plant,'img_file'),  #FUN-A50102
#                         "  WHERE img01 = '",g_result[g_cnt],"'",
#                         "    AND img02 = '",l_store,"'",
#                         "    AND img03 = ' ' ",
#                         "    AND img04 = ' ' "
#             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                   #FUN-A50102
#             CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql           #FUN-A50102
#             PREPARE img09_cs FROM g_sql
#             EXECUTE img09_cs INTO l_img09
#                 #bnl 090410 -begin
##TQC-B20082 --------------------mark
##                LET l_sum = 0
##                LET l_sum1 = 0
#       
##               #LET l_sql = " SELECT SUM((oeb12*oeb05_fac- COALESCE(oeb24,0)*oeb05_fac)) FROM ",l_dbs CLIPPED,"oea_file,",                    #FUN-A50102 mark
##               #            " ",l_dbs CLIPPED,"oeb_file, ",l_dbs CLIPPED,"rtz_file ",                                                         #FUN-A50102 mark
##                LET l_sql = " SELECT SUM((oeb12*oeb05_fac- COALESCE(oeb24,0)*oeb05_fac)) FROM ",cl_get_target_table(l_plant,'oea_file'),",",  #FUN-A50102
##                                                                                                cl_get_target_table(l_plant,'oeb_file'),",",  #FUN-A50102
##                                                                                                cl_get_target_table(l_plant,'rtz_file'),      #FUN-A50102
##                            " WHERE oea01 = oeb01 ",
##                            "   AND oeaplant = oebplant ",
##                            "   AND oeaplant = rtz01 ",
##                            "   AND oeaplant = '",l_plant,"' ",
##                            "   AND oea02 <= '",g_rus04,"'",
##                            "   AND oeb04 = '",g_result[g_cnt],"' ",
##                 #          "   AND oeb67 = '2' ",                       #TQC-B10067 mark
##                            "   AND oeb48 = '2' ",                       #TQC-B10067
##                            "   AND (oeb12 - oeb24) > 0  ",
##                            "   AND oeaconf = 'Y' ",
##                            "   AND ((oeb09 = '",l_store,"' AND oeb09 is not null) ", 
##                            "   OR (oeb09 IS NULL AND (( rtz07 = '",l_store,"' AND oeb44 ='1') ",
##                            "   OR (rtz08 = '",l_store,"' AND oeb44 <> '1' )))) ",
##                            "   AND oeb091 = ' ' ", 
##                            "   AND oeb092 = ' ' "
##                CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
##         #       CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102          #TQC-B10067  mark
##                 CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                         #TQC-B10067
##                PREPARE p102_foreach4 FROM l_sql
##                EXECUTE p102_foreach4 INTO l_sum
##                IF cl_null(l_sum) THEN LET l_sum = 0 END IF                                  #TQC-B10067
##               #LET l_sql = " SELECT DISTINCT ruj04 FROM ",l_dbs CLIPPED,"rui_file, ",                   #FUN-A50102 mark
##                LET l_sql = " SELECT DISTINCT ruj04 FROM ",cl_get_target_table(l_plant,'rui_file'),",",  #FUN-A50102 
##                                                           cl_get_target_table(l_plant,'ruj_file'),      #FUN-A50102 
##               #            " ",l_dbs CLIPPED,"ruj_file  ",                                              #FUN-A50102 mark
##                            "  WHERE rui01 = ruj01 ",
##                            "    AND rui00 = '",l_plant,"' ",
##                            "    AND rui04 <='",g_rus04,"'",
##                            "    AND ruiconf = 'N' ",
##                            "    AND ruj03 = '",g_result[g_cnt],"' ",
##                            "    AND ruj05 = '",l_store,"' "
##                CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
##                CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql       #FUN-A50102
##                DECLARE p102_ruj04_foreach CURSOR FROM l_sql
##                FOREACH p102_ruj04_foreach INTO l_ruj04
##                IF STATUS THEN
##                   CALL cl_err('p102_ruj04_foreach:',STATUS,1)
##                   EXIT FOREACH
##                   LET g_success='N'
##                   RETURN
##                END IF
##                   LET l_plant1 = l_plant                            #FUN-980020
##              #    LET l_dbs1 = l_dbs CLIPPED                        #FUN-A50102 mark
##              #    CALL s_umfchkm(g_result[g_cnt],l_ruj04,l_img09,l_dbs1) RETURNING l_flag,l_fac     #FUN-980020 mark
##                   CALL s_umfchkm(g_result[g_cnt],l_ruj04,l_img09,l_plant1) RETURNING l_flag,l_fac   #FUN-980020
##                   IF l_flag <> 0 THEN 
##                      CALL cl_err(l_ruj04,'abm-731',1) 
##                      LET g_success = 'N'
##                      EXIT FOREACH
##                      RETURN
##                   END IF
##                   IF cl_null(l_fac) THEN LET l_fac = 1 END IF
##                   SELECT SUM(COALESCE(ruj08,0)) INTO l_ruj08
##                     FROM ruj_file,rui_file
##                    WHERE rui01 = ruj01
##                      AND rui00 = l_plant
##                      AND ruiconf = 'N' 
##                      AND ruj03 = g_result[g_cnt]
##                      AND ruj05 = l_store
##                      AND ruj04 = l_ruj04
##                   IF cl_null(l_ruj08) THEN LET l_ruj08 = 0 END IF                            #TQC-B10067
##                   LET l_ruj08 = l_ruj08 * l_fac
##                   LET l_sum1 = l_sum1 + l_ruj08
##                END FOREACH 
##                 IF cl_null(l_sum) THEN LET l_sum = 0 END IF
##                 IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
##                 LET l_sum = l_sum + l_sum1
##TQC-B20082 ------------------mark
#                 #bnl 090410 -end
#                     
#                #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rut_file ",               #FUN-A50102 mark
#                 LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rut_file'), #FUN-A50102
#                             "  WHERE rut01 = '",l_rus01,"'",
#                             "    AND rut02 = '",g_rus04,"'",
#                             "    AND rut03 = '",l_store,"'",
#                             "    AND rut04 = '",g_result[g_cnt],"'",
#                             "    AND rut05 = '",l_img09,"'",
#                             "    AND rut06 = '",l_img10,"'",
#                             "    AND rutplant= '",l_plant,"'",
#                             "    ORDER BY rut01 "
#                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
#           #      CALL cl_get_target_table(l_sql,l_plant) RETURNING l_sql    #FUN-A50102       #TQC-B10067  mark
#                 CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                          #TQC-B10067
#                 PREPARE p102_foreach3  FROM l_sql
#                 EXECUTE p102_foreach3 INTO l_n
#                 IF l_n=0 THEN
#                    #bnl 090410 begin
#                   #LET l_sql = "INSERT INTO ",l_dbs,"rut_file VALUES (",                                #FUN-A50102 mark
#                    LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rut_file')," VALUES (",      #FUN-A50102
#                                      "?,?,?,?,?, ?,0,?,?)"
#                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
#                    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-A50102
#                    PREPARE pre_ins_rut FROM l_sql
#                    SELECT azw02 INTO l_rutlegal FROM azw_file WHERE azw01 =l_plant  #add by cock090831
#                    IF l_img10 IS NULL THEN LET l_img10=0 END IF
#                    LET l_img10 = s_digqty(l_img10,l_img09)                                #FUN-BB0085 
#        #            IF l_sum IS NULL THEN LET l_sum=0 END IF                              #TQC-B20082  mark
#                    EXECUTE pre_ins_rut USING l_rus01,g_rus04,l_store,g_result[g_cnt],
#        #                                      l_img09,l_img10,l_sum,l_rutlegal,l_plant    #TQC-B20082 mark
#                                              l_img09,l_img10,l_rutlegal,l_plant         #TQC-B20082
#                    #INSERT INTO rut_file VALUES(l_rus01,g_rus04,l_store,
#                    #                            g_result[g_cnt],l_img09,l_img10,l_plant,l_sum
#                    #bnl 090410 end
#                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#                       CALL cl_err('ins rut',SQLCA.SQLCODE,1)
#                       LET g_success='N'
#                       RETURN
#                    END IF
#                 ELSE
#                    CALL cl_err('','art-536',1)
#                    LET g_success = 'N'
#                    RETURN 
#                 END IF
#        #        END FOREACH
#              END FOR
#        END WHILE
#   END FOREACH
#   LET g_cnt = g_cnt + 1
#   END WHILE
# 
#   IF cl_null(l_ok) THEN LET l_ok=0 END IF
#   IF l_ok=0 THEN
#      LET g_success = 'N'
#      RETURN
#   END IF
# 
#   IF g_success = 'N' THEN
#      RETURN
#   END IF
# 
#END FUNCTION
#FUN-C70022 MARK END ----
#FUN-C70022 add begin ---
FUNCTION p102_p2()
   DEFINE tok      base.StringTokenizer
   DEFINE l_sql    STRING 
   DEFINE l_rus01  LIKE rus_file.rus01
   DEFINE l_rus05  LIKE rus_file.rus05
   DEFINE l_rus07  LIKE rus_file.rus07
   DEFINE l_rus09  LIKE rus_file.rus09
   DEFINE l_rus11  LIKE rus_file.rus11
   DEFINE l_rus13  LIKE rus_file.rus13
   DEFINE l_plant  LIKE azp_file.azp01 
   DEFINE l_year   LIKE type_file.num10
   DEFINE l_month  LIKE type_file.num10
   DEFINE l_date   LIKE type_file.dat 
   #FUN-CC0064----add-----str
   DEFINE l_pos         LIKE type_file.num10
   DEFINE l_posdb       LIKE ryg_file.ryg00
   DEFINE l_posdb_link  LIKE ryg_file.ryg02
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_aza88       LIKE aza_file.aza88
   DEFINE l_date1       STRING 
   #FUN-CC0064-----add----end

   LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
   LET g_success_num = 0 
   CALL s_showmsg_init()
   #門店
   DROP TABLE rut_temp; 
   SELECT * FROM rut_file WHERE 1=0 INTO TEMP rut_temp
   CREATE INDEX cs_rut_temp_pk ON rut_temp(rut01,rut03,rut04)
   WHILE tok.hasMoreTokens()
      DELETE FROM rut_temp
      LET g_success = 'Y'
      LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'sma_file'),
                  " WHERE sma00 = '0'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE p102_sel_sma FROM l_sql
      EXECUTE p102_sel_sma INTO g_sma.*
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_plant,'/',g_sma.sma892[1,1]
         CALL s_errmsg('',g_showmsg,'sel sma_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE WHILE
      END IF
#FUN-CC0064----add-----str
      LET l_plant = tok.nextToken()
      LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(l_plant,'aza_file')
      PREPARE p102_aza88_pre FROM l_sql
      EXECUTE p102_aza88_pre INTO l_aza88
      IF l_aza88 = 'Y' THEN                  
         SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
         LET l_n = 0
         SELECT COUNT(*) INTO l_n  FROM ryg_file 
          WHERE ryg00 = l_posdb
            AND ryg02 = l_posdb_link
            AND ryg01 = l_plant
         LET l_posdb=s_dbstring(l_posdb)
         LET l_posdb_link=p102_dblinks(l_posdb_link)
         LET l_date1 = g_rus04 USING 'yyyymmdd' 
         IF l_n > 0 THEN
            LET l_pos = 0
            LET l_sql = " SELECT COUNT(*)",
                        "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
                        "  WHERE SHOP = '",l_plant,"'",
                        "    AND EDATE > = '",l_date1,"'"
            PREPARE p102_pos_pre FROM l_sql
            EXECUTE p102_pos_pre INTO l_pos
            IF l_pos = 0 THEN
               CALL s_errmsg('',l_plant,'','art1099',1)
               LET g_success = 'N'
               CONTINUE WHILE
            END IF
         END IF
      END IF
#FUN-CC0064----add-----end
      BEGIN WORK 
      LET g_num = 0
      #LET l_plant = tok.nextToken()   #FUN-CC0064 mark
      LET l_rus01 = ''
      LET l_rus05 = ''
      LET l_rus07 = ''
      LET l_rus09 = ''
      LET l_rus11 = ''
      LET l_rus13 = ''
      LET l_sql = " SELECT DISTINCT rus01,rus05,rus07,rus09,rus11,rus13 FROM ",cl_get_target_table(l_plant,'rus_file'), 
                  "  WHERE rus04='",g_rus04,"'",           #盘点日期
                  "    AND rusplant='",l_plant,"'",
                  "    AND rusconf='Y'",
                  "    ORDER BY rus01 "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      DECLARE p102_foreach CURSOR FROM l_sql
      #盤點計劃
      FOREACH p102_foreach INTO l_rus01,l_rus05,l_rus07,l_rus09,l_rus11,l_rus13
         IF STATUS THEN
            CALL cl_err('p102_foreach:',STATUS,1)
            EXIT FOREACH
            LET g_success='N'
            RETURN
         END IF
         #檢查是否有備份
         LET g_cnt = 0
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rut_file'),
                     "  WHERE rut02='",g_rus04,"'",          #盘点日期
                     "    AND rutplant = '",l_plant,"'",
                     "    AND rut01 = '",l_rus01,"'"         #盘点计划单
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE p102_rut  FROM l_sql
         EXECUTE p102_rut  INTO g_cnt
         #如果有備份檢查是否有已確認的盤點單，沒有則詢問是否刪除，否則continue foreach
         IF g_cnt > 0 THEN
            LET g_cnt = 0
            LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ruw_file'),        
                        " WHERE ruw02 = '",l_rus01,"'",
                        "  AND ruw00 = '1'",
                        "  AND ruwconf = 'Y'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE p102_ruw FROM l_sql
            EXECUTE p102_ruw INTO g_cnt
            IF g_cnt = 0 THEN
               IF cl_confirm('axc-096') THEN
                  LET l_sql = " DELETE FROM ",cl_get_target_table(l_plant,'rut_file'),
                              " WHERE rut01 = '",l_rus01,"'",
                              "   AND rutplant = '",l_plant,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                  PREPARE p102_del_ruw  FROM l_sql
                  EXECUTE p102_del_ruw
                  IF SQLCA.sqlcode THEN
                     LET g_showmsg = l_plant,'/',l_rus01
                     CALL s_errmsg('rusplant,rus01',g_showmsg,'del rut_file',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     CONTINUE FOREACH
                  END IF
               #CHI-CB0046 add begin---
               ELSE
                  LET g_success = 'N'
                  CONTINUE FOREACH
               #CHI-CB0046 add end-----
               END IF
            ELSE
               LET g_showmsg = l_plant,'/',l_rus01
               CALL s_errmsg('rusplant,rus01',g_showmsg,'','art1074',2)
               CONTINUE FOREACH
            END IF
         END IF    
         LET g_wc = ' 1=1'
         LET g_wc1 = ''
         IF NOT cl_null(l_rus05) THEN #仓库
            LET g_wc1  = "('",cl_replace_str(l_rus05,"|","','"),"')"
            LET g_wc = g_wc CLIPPED," AND img02 IN ",g_wc1
         END IF
         IF NOT cl_null(l_rus07) THEN #品类
            LET g_wc1  = "('",cl_replace_str(l_rus07,"|","','"),"')"
            LET g_wc = g_wc CLIPPED," AND ima131 IN ",g_wc1
         END IF
         IF NOT cl_null(l_rus09) THEN #品牌
            LET g_wc1  = "('",cl_replace_str(l_rus09,"|","','"),"')"
            LET g_wc = g_wc CLIPPED," AND ima1005 IN ",g_wc1
         END IF
         IF NOT cl_null(l_rus11) THEN #厂商
            LET g_wc1  = "('",cl_replace_str(l_rus11,"|","','"),"')"
            LET g_wc = g_wc CLIPPED," AND rty05 IN ",g_wc1
         END IF
         IF NOT cl_null(l_rus13) THEN #产品
            LET g_wc1  = "('",cl_replace_str(l_rus13,"|","','"),"')"
            LET g_wc = g_wc CLIPPED," AND ima01 IN ",g_wc1
         END IF
         IF MONTH(g_rus04) > 1 THEN 
             LET l_year = YEAR(g_rus04)
             LET l_month = MONTH(g_rus04) - 1
         ELSE 
             LET l_year =  YEAR(g_rus04) - 1
             LET l_month  = 12    
         END IF  
         #根据盘点计划的条件关联imk_file抓产品，抓盘点日期上一个月的imk_file中的期末库存imk09，并写入rut_file
         LET l_sql = " INSERT INTO ",cl_get_target_table(l_plant,'rut_file')," (rut01,rut02,rut03,rut04,rut05,rut06,rut07,rutlegal,rutplant)",
                     " SELECT '",l_rus01,"','",g_rus04,"',imk02,ima01,img09,COALESCE(SUM(imk09),0),0,imklegal,imkplant",
                     "   FROM ",cl_get_target_table(l_plant,'ima_file'),
                     "   LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
                     "     ON (rty02 = ima01 AND rty01 = '",l_plant,"')",
                     ",",cl_get_target_table(l_plant,'imk_file'),
                     ",",cl_get_target_table(l_plant,'img_file'),
                     "  WHERE ima01 = imk01 AND ima01 = img01 ",
                     "    AND imk02 = img02 AND imk03 = img03 AND imk04 = img04",
                     "    AND imk03 = ' ' AND imk04 = ' ' ",
                     "    AND imk05 = '",l_year,"' AND imk06 = '",l_month,"'",
                     "    AND ",g_wc CLIPPED,
                     " GROUP BY imk02,ima01,img09,imklegal,imkplant" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE rut_pre FROM l_sql
         EXECUTE rut_pre 
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_plant,'/',l_rus01
            CALL s_errmsg('rusplant,rus01',g_showmsg,'ins rut_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         LET g_num = g_num + SQLCA.sqlerrd[3]
         #根据盘点计划关联tlf_file抓产品，抓盘点日期当月，且小于等于盘点日期的所有tlf_file，求异动库存COALESCE(SUM(tlf10*tlf12*tlf907),0)，的条件写入rut_file，如果已存在则UPDATE
         LET l_date = MDY(MONTH(g_rus04),1,YEAR(g_rus04)) #取盘点日期这个月的1号
         IF g_sma.sma892[1,1] = '2' THEN
            LET g_wc = g_wc CLIPPED," AND tlf07 >= '",l_date,"' AND tlf07 <='",g_rus04,"' AND (tlf907 <> 0)"
         ELSE
            LET g_wc = g_wc CLIPPED," AND tlf06 >= '",l_date,"' AND tlf06 <='",g_rus04,"' AND (tlf907 <> 0)"
         END IF
         
         LET l_sql = " INSERT INTO rut_temp (rut01,rut02,rut03,rut04,rut05,rut06,rut07,rutlegal,rutplant)",
                     " SELECT '",l_rus01,"','",g_rus04,"',img02,ima01,img09,COALESCE(SUM(tlf10*tlf12*tlf907),0),0,imglegal,imgplant",
                     "   FROM ",cl_get_target_table(l_plant,'ima_file'),
                     "   LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
                     "     ON (rty02 = ima01 AND rty01 = '",l_plant,"')",
                     ",",cl_get_target_table(l_plant,'tlf_file'),
                     ",",cl_get_target_table(l_plant,'img_file'),
                     "  WHERE ima01 = tlf01 AND ima01 = img01",
                     "    AND tlf902 = img02 AND tlf903 = img03 AND tlf904 = img04",
                     "    AND tlf903 = ' ' AND tlf904 = ' '",
                     "    AND ",g_wc CLIPPED,
                     "    AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'rut_file'),
                     "                     WHERE rut01 = '",l_rus01,"' AND rut03 = img01 AND rut04 = ima01)",
                     " GROUP BY img02,ima01,img09,imglegal,imgplant"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE rut_temp_ins FROM l_sql
         EXECUTE rut_temp_ins 
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_plant,'/',l_rus01
            CALL s_errmsg('rusplant,rus01',g_showmsg,'ins rut_temp',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         #更改在临时表里存在rut_file的资料 
         LET l_sql = "UPDATE ",cl_get_target_table(l_plant,'rut_file')," a SET a.rut06 = a.rut06 + (SELECT b.rut06 FROM rut_temp b",
                     "                                            WHERE b.rut01 = '",l_rus01,"' AND a.rut01 = b.rut01 AND a.rut03 = b.rut03 AND a.rut04 = b.rut04) ",
                     " WHERE EXISTS (SELECT 1 FROM rut_temp c WHERE c.rut01 = '",l_rus01,"' AND a.rut01 = c.rut01 AND a.rut03 = c.rut03 AND a.rut04 = c.rut04)"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE rut_upd FROM l_sql
         EXECUTE rut_upd 
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_plant,'/',l_rus01
            CALL s_errmsg('rusplant,rus01',g_showmsg,'upd rut_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         #新增在临时表里不存在rut_file里的资料
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rut_file')," (rut01,rut02,rut03,rut04,rut05,rut06,rut07,rutlegal,rutplant) ",
                     "SELECT * ",
                     "  FROM rut_temp a",
                     " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'rut_file')," b ",
                     "                    WHERE b.rut01 = '",l_rus01,"' AND a.rut01 = b.rut01 AND a.rut03 = b.rut03 AND a.rut04 = b.rut04)"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE rut_ins FROM l_sql
         EXECUTE rut_ins
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_plant,'/',l_rus01
            CALL s_errmsg('rusplant,rus01',g_showmsg,'ins rut_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         LET g_num = g_num + SQLCA.sqlerrd[3]
      END FOREACH
      IF g_success <> 'Y' THEN 
          ROLLBACK WORK 
      ELSE 
          IF g_num > 0 THEN
             LET g_success_num = g_success_num + 1     #备份成功笔数！
             COMMIT WORK 
          ELSE
             LET g_showmsg = l_plant,'/',l_rus01
             CALL s_errmsg('rusplant,rus01',g_showmsg,'','art1075',2)
          END IF 
      END IF 
   END WHILE
   CALL s_showmsg()
END FUNCTION 
#FUN-C70022 add end ----
#FUN-CC0064----add-----str
FUNCTION p102_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

   IF l_db_links IS NULL OR l_db_links = ' ' THEN
      RETURN ' '
   ELSE
      LET l_db_links = '@',l_db_links CLIPPED
      RETURN l_db_links
   END IF
END FUNCTION
#FUN-CC0064----add-----end
#FUN-870100 MODIFY

