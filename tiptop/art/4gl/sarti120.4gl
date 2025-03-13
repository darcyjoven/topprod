# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: sarti120.4gl
# Descriptions...: 商品策略維護作業
# Date & Author..: NO.FUN-960130 08/07/07 By  Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:MOD-A80135 10/08/18 By lilingyu 單身"商品編號"開窗時,當資料超過g_max_rec時,程式會宕
# Modify.........: No:FUN-A70132 10/09/18 By huangtao 單身增加開窗選擇默認稅別 
# Modify.........: No:FUN-AA0037 10/10/27 By huangtao  去掉rvyacti
# Modify.........: No:FUN-AB0039 10/11/10 By huangtao 修改insert into rvy_file
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B50160 11/05/31 By lixia 修改價格策略維護作業中產品編號的開窗
# Modify.........: No:TQC-B90158 11/09/22 By pauline 判斷當前營運中心是否為資料中心下的營運中心
# Modify.........: No:FUN-C60086 12/06/25 By xjll   修改服飾流通行業開窗問題
# Modify.........: No:FUN-C80049 12/08/13 By xumeimei 開窗多選時給rtg11，rtg12賦值
# Modify.........: No:FUN-D30050 13/03/18 By dongsz 產品為券時,增加稅種的檢查

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_rtg    DYNAMIC ARRAY OF RECORD
         status   LIKE type_file.chr1,
         rtg03    LIKE rtg_file.rtg03,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         rtg04    LIKE rtg_file.rtg04
                END RECORD
DEFINE g_sql    STRING
DEFINE g_rec_b  LIKE type_file.num5
DEFINE g_cnt    LIKE type_file.num5
DEFINE g_flag   LIKE type_file.chr1
DEFINE g_wc     STRING
DEFINE g_curr_method  LIKE rtz_file.rtz04
DEFINE g_org          LIKE azp_file.azp01
 
FUNCTION s_query(p_flag,p_org,p_curr_method)
DEFINE p_flag     LIKE type_file.chr1
DEFINE p_org      LIKE tqb_file.tqb01
DEFINE p_shop     LIKE ima_file.ima01
DEFINE l_no       LIKE type_file.chr1000
DEFINE l_i        LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_cnt      LIKE type_file.num5
DEFINE p_curr_method LIKE rtz_file.rtz04
DEFINE l_first_line  LIKE type_file.num5
#NO.FUN-A70132 ----START--------
DEFINE l_rte08    LIKE rte_file.rte08
DEFINE l_rte04    LIKE rte_file.rte04
DEFINE l_rte05    LIKE rte_file.rte05
DEFINE l_rte06    LIKE rte_file.rte06
DEFINE l_gec02    LIKE gec_file.gec02
DEFINE l_gecacti  LIKE gec_file.gecacti
DEFINE l_rvy03    LIKE rvy_file.rvy03
DEFINE l_count    LIKE type_file.num5
DEFINE l_ima154   LIKE ima_file.ima154     #FUN-D30050 add
DEFINE l_lpx33    LIKE lpx_file.lpx33      #FUN-D30050 add
DEFINE l_gec011   LIKE gec_file.gec011     #FUN-D30050 add
DEFINE l_gec04    LIKE gec_file.gec04      #FUN-D30050 add
DEFINE g_lpx38    LIKE lpx_file.lpx38      #FUN-D30050 add
#NO.FUN-A70132 ------END --------
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_org IS NULL THEN RETURN '' END IF
 
   OPEN WINDOW s120_w1 AT 8,15 WITH FORM "art/42f/sarti120"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   LET g_flag = p_flag
   LET g_curr_method = p_curr_method
   LET g_org = p_org
 
   IF p_flag = '1' THEN
      CALL cl_Set_comp_visible("rtg04",FALSE)
   ELSE
      CALL cl_Set_comp_visible("rtg04",TRUE)
   END IF
   
   CALL s_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN 0 END IF
   CALL s_b_fill(g_sql)
   INPUT ARRAY g_rtg WITHOUT DEFAULTS FROM s_rtg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
      ON ACTION all
         FOR l_i = 1 TO g_rtg.getLength()
             LET g_rtg[l_i].status = 'Y'
         END FOR
      ON ACTION no_all   
         FOR l_i = 1 TO g_rtg.getLength()
             LET g_rtg[l_i].status = 'N'
         END FOR
      ON ACTION re_query
         CALL g_rtg.clear()
         CALL s_bp_refresh()
         CALL s_cs() 
         IF INT_FLAG THEN LET INT_FLAG = 0 RETURN 0 END IF    
         CALL s_b_fill(g_sql)
   END INPUT
   IF INT_FLAG THEN
      CALL g_rtg.clear()
      LET INT_FLAG = 0
      CLOSE WINDOW s120_w1
      RETURN 0 
   END IF
#NO.FUN-A70132 ------START------
   IF p_flag = '1' THEN
      LET l_rte04 = 'Y'
      LET l_rte05 = 'Y'
      LET l_rte06 = 'Y'
      OPEN WINDOW i120_w1 AT 8,15 WITH FORM "art/42f/arti120_1"
        ATTRIBUTE (STYLE = g_win_style)
      CALL cl_ui_init()
      DISPLAY l_rte04 TO FORMONLY.rte04
      DISPLAY l_rte05 TO FORMONLY.rte05
      DISPLAY l_rte06 TO FORMONLY.rte06
      INPUT l_rte08,l_rte04,l_rte05,l_rte06  WITHOUT DEFAULTS
         FROM FORMONLY.rte08,FORMONLY.rte04,FORMONLY.rte05,FORMONLY.rte06
         BEFORE INPUT
            
         AFTER FIELD rte08
             IF NOT cl_null(l_rte08) THEN
                SELECT gec02 ,gecacti INTO l_gec02,l_gecacti FROM gec_file
                 WHERE gec01 = l_rte08 AND gec011 = '2' 
                CASE  WHEN SQLCA.sqlcode = 100  
                         LET g_errno = 'art-931'
                      WHEN l_gecacti = 'N'  
                         LET g_errno = '9028'
                      OTHERWISE   
                         LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rte08
                END IF
             END IF   

         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
  
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

         ON ACTION controlp        
            CASE
               WHEN INFIELD(rte08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gec011"
                     LET g_qryparam.default1 = l_rte08
                     CALL cl_create_qry() RETURNING l_rte08
                     DISPLAY BY NAME l_rte08                   
                     NEXT FIELD rte08
              OTHERWISE EXIT CASE
            END CASE 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION HELP
            CALL cl_show_help()
      END INPUT
      IF INT_FLAG THEN
          CALL g_rtg.clear()
          LET INT_FLAG = 0
          CLOSE WINDOW i120_w1
          CLOSE WINDOW s120_w1
          RETURN 0
      END IF
   END IF
#NO.FUN-A70132 -------END -------   
   IF p_flag = '1' THEN
      SELECT MAX(rte02) INTO l_n FROM rte_file WHERE rte01 = p_curr_method
      IF l_n IS NULL THEN LET l_n = 0 END IF
   END IF
   IF p_flag = '2' THEN
      SELECT MAX(rtg02) INTO l_n FROM rtg_file WHERE rtg01 = p_curr_method
      IF l_n IS NULL THEN LET l_n = 0 END IF
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
   LET l_cnt = 0
   LET l_first_line = 0
   FOR l_i = 1 TO g_rtg.getLength()
       IF g_rtg[l_i].rtg03 IS NULL THEN CONTINUE FOR END IF
       IF g_rtg[l_i].status = 'Y' THEN
          IF p_flag = '1' THEN
            #FUN-D30050--add--str---
             SELECT ima154 INTO l_ima154 FROM ima_file WHERE ima01 = g_rtg[l_i].rtg03
             IF l_ima154 = 'Y' THEN
                INITIALIZE g_lpx38 TO NULL
                SELECT lpx38 INTO g_lpx38 FROM lpx_file WHERE lpx32 = g_rtg[l_i].rtg03 
                IF g_lpx38 = 'Y' THEN
                   SELECT lpx33 INTO l_lpx33 FROM lpx_file WHERE lpx32 = g_rtg[l_i].rtg03 
                   IF NOT cl_null(l_lpx33) THEN
                      IF l_rte08 != l_lpx33 THEN
                         LET g_errno = 'art1129'
                         CALL s_errmsg('rte03',g_rtg[l_i].rtg03,'',g_errno,1)
                         CONTINUE FOR
                      END IF
                   END IF
                ELSE 
                   IF g_lpx38 = 'N' THEN
                      SELECT gec011,gec04 INTO l_gec011,l_gec04 FROM gec_file WHERE gec01 = l_rte08
                      IF NOT (l_gec011 = '2' AND l_gec04 = 0) THEN
                         LET g_errno = 'art1130'
                         CALL s_errmsg('rte03',g_rtg[l_i].rtg03,'',g_errno,1)
                         CONTINUE FOR
                      END IF
                   END IF
                END IF
             END IF
            #FUN-D30050--add--end---
             LET l_n = l_n + 1
             LET l_cnt = l_cnt + 1
             IF l_cnt = 1 THEN 
                LET l_first_line = l_n
             END IF
          #   INSERT INTO rte_file VALUES(p_curr_method,l_n,g_rtg[l_i].rtg03,'Y','Y','Y','Y','N',' ','2')
             IF NOT s_internal_item(g_rtg[l_i].rtg03,g_plant ) THEN
                LET l_rte04 = 'N'
             END IF
             INSERT INTO rte_file 
              VALUES(p_curr_method,l_n,g_rtg[l_i].rtg03,l_rte04,l_rte05,l_rte06,'Y','1',l_rte08,'2')   #NO.FUN-A70132 #FUN-B40071
             IF SQLCA.SQLCODE THEN
                LET g_success = 'N'
                CALL s_errmsg('rte03',g_rtg[l_i].rtg03,'for',SQLCA.sqlcode,1)
             END IF
             SELECT COUNT(rvy03) INTO l_count FROM rvy_file
              WHERE rvy01 =  p_curr_method
                AND rvy02 =  l_n
              IF l_count = 0 THEN
                 LET l_rvy03 = 1
              ELSE
                 SELECT MAX(rvy03)+1 INTO l_rvy03 FROM rvy_file
                  WHERE rvy01 =  p_curr_method
                    AND rvy02 =  l_n
              END IF
      #       INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvyacti)       #FUN-AA0037   mark
      #         VALUES(p_curr_method,l_n,l_rvy03,l_rte08,'2','Y')               #FUN-AA0037   mark
#FUN-AB0039 ------------------STA
#              INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05)               #FUN-AA0037
#                VALUES(p_curr_method,l_n,l_rvy03,l_rte08,'2')                   #FUN-AA0037
               INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvygrup,rvyorig,rvyoriu,rvyuser) 
                    VALUES(p_curr_method,l_n,l_rvy03,l_rte08,'2',g_grup,g_grup,g_user,g_user) 
#FUN-AB0039 ------------------END
             IF SQLCA.SQLCODE THEN
                LET g_success = 'N'
             END IF
          END IF
          IF p_flag = '2' THEN
             LET l_n = l_n + 1
             LET l_cnt = l_cnt + 1
             IF l_cnt = 1 THEN 
                LET l_first_line = l_n
             END IF
             CALL s_ins_rtg(p_curr_method,l_n,g_rtg[l_i].rtg03,g_rtg[l_i].rtg04,p_org)
          END IF
       END IF
   END FOR
   
   CALL s_showmsg()
   CLOSE WINDOW i120_w1
   CLOSE WINDOW s120_w1
   RETURN l_first_line
END FUNCTION
FUNCTION s_cs()
DEFINE l_method      LIKE rtz_file.rtz04
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
DEFINE l_method1     LIKE rtz_file.rtz04   #TQC-B50160
 
   IF g_flag = '1' THEN   #商品策略
      SELECT rtz04 INTO l_method FROM rtz_file 
         WHERE rtz01 = g_org
      IF cl_null(l_method) THEN  #總部
         CONSTRUCT g_wc ON ima01 FROM s_rtg[1].rtg03
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
         IF INT_FLAG THEN RETURN END IF
         LET g_sql = "SELECT 'N',ima01,ima02,ima021,'' FROM ima_file ",
                     " WHERE imaacti = 'Y' AND ima1010 = '1' ",
                     "   AND ima01 NOT IN (SELECT rte03 FROM rte_file ",
                     "   WHERE rte01 = '",g_curr_method,"')"
#FUN-C60086----add--begin-----------
         IF s_industry("slk") THEN
            IF g_prog = "arti120" AND g_azw.azw04 = '2' THEN
               LET g_sql = g_sql CLIPPED," AND ima151 <> 'Y' "
            END IF
         END IF
#FUN-C60086---add---end-------------
      ELSE                   #非總部    
         CONSTRUCT g_wc ON rte03 FROM s_rtg[1].rtg03
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
         LET g_sql = "SELECT 'N',rte03,ima02,ima021,'' ",
                     "FROM rte_file ,ima_file ",
                     " WHERE rte01 ='",l_method,"' AND rte07 = 'Y' ",
                     "   AND rte03 = ima01 ",
                     "   AND rte03 NOT IN (SELECT rte03 FROM rte_file WHERE ",
                     "   rte01 = '",g_curr_method,"')"
#FUN-C60086----add--begin-----------
         IF s_industry("slk") THEN
            IF g_prog = "arti120" AND g_azw.azw04 = '2' THEN
               LET g_sql = g_sql CLIPPED," AND ima151 <> 'Y' "
            END IF
         END IF
#FUN-C60086---add---end-------------
      END IF
   END IF
 
   IF g_flag = '2' THEN   #價格策略
      #SELECT rtz05 INTO l_method FROM rtz_file 
      SELECT rtz05,rtz04 INTO l_method,l_method1 FROM rtz_file   #TQC-B50160
       WHERE rtz01 = g_org
      IF cl_null(l_method) THEN  #總部
         CONSTRUCT g_wc ON ima01,ima25 FROM s_rtg[1].rtg03,s_rtg[1].rtg04
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
         LET g_sql = "SELECT 'N',ima01,ima02,ima021,ima25 ",
                     " FROM ima_file ",
                     "  WHERE imaacti = 'Y' AND ima1010 = '1' ",
                     "    AND (ima01,ima25) NOT IN ",
                     " (SELECT rtg03,rtg04 FROM rtg_file ",
                     "    WHERE rtg01 ='",g_curr_method,"')"
         #TQC-B50160--add--str--
         IF NOT cl_null(l_method1) THEN 
            LET g_sql = g_sql,"     AND ima01 IN (SELECT rte03 FROM rte_file ",
                              "   WHERE rte01 = '",l_method1,"')"                        
         END IF
         #TQC-B50160--add--end--
#FUN-C60086----add--begin-----------
         IF s_industry("slk") THEN
            IF g_prog = "arti121" AND g_azw.azw04 = '2' THEN
               LET g_sql = g_sql CLIPPED," AND ima151 <> 'Y' "
            END IF
         END IF
#FUN-C60086---add---end-------------
      ELSE
         CONSTRUCT g_wc ON rtg03,rtg04 FROM s_rtg[1].rtg03,s_rtg[1].rtg04
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         LET g_sql = "SELECT 'N',rtg03,ima02,ima021,rtg04 ",
                     " FROM rtg_file ,ima_file ",
                     " WHERE rtg03=ima01 AND rtg01 = '",l_method,"'AND rtg09 = 'Y' ",
                     "   AND (rtg03,rtg04) NOT IN (SELECT rtg03,rtg04 ",
                     " FROM rtg_file WHERE rtg01 ='",g_curr_method,"')"
#FUN-C60086----add--begin-----------
         IF s_industry("slk") THEN
            IF g_prog = "arti121" AND g_azw.azw04 = '2' THEN
               LET g_sql = g_sql CLIPPED," AND ima151 <> 'Y' "
            END IF
         END IF
#FUN-C60086---add---end-------------
      END IF
   END IF
END FUNCTION 
 
FUNCTION s_b_fill(p_sql)
DEFINE p_sql   STRING
 
   IF g_wc IS NULL THEN LET g_wc = " 1=1 " END IF
   LET p_sql = p_sql," AND ",g_wc 
   PREPARE pre_rtg FROM p_sql
   DECLARE cur_rtg CURSOR FOR pre_rtg
 
   LET g_cnt = 1
   CALL g_rtg.clear()
 
   FOREACH cur_rtg INTO g_rtg[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 #MOD-A80135 --begin--
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF 
 #MOD-A80135 --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
 
   CALL g_rtg.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   CALL s_bp_refresh()
END FUNCTION
FUNCTION s_bp_refresh()
   DISPLAY ARRAY g_rtg TO s_rtg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          IF g_flag = '1' THEN
             CALL cl_set_comp_visible("rtg04",FALSE)
          ELSE
             CALL cl_set_comp_visible("rtg04",TRUE)
          END IF
          EXIT DISPLAY
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION s_ins_rtg(p_style,p_line,p_shop,p_unit,p_org)
DEFINE  p_style     LIKE   rtg_file.rtg01
DEFINE  p_line      LIKE   rtg_file.rtg02
DEFINE  p_shop      LIKE   rtg_file.rtg03
DEFINE  p_unit      LIKE   rtg_file.rtg04
DEFINE  p_org       LIKE   tqb_file.tqb01
DEFINE  l_rtz05     LIKE   rtz_file.rtz05
DEFINE  l_rtg05     LIKE   rtg_file.rtg05
DEFINE  l_rtg06     LIKE   rtg_file.rtg06
DEFINE  l_rtg07     LIKE   rtg_file.rtg07
DEFINE  l_rtg08     LIKE   rtg_file.rtg08
DEFINE  l_rtg11     LIKE   rtg_file.rtg11   #FUN-C80049 add

 
     SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01 = p_org
     IF NOT cl_null(l_rtz05) THEN
        #SELECT rtg05,rtg06,rtg07,rtg08                     #FUN-C80049 mark
        #    INTO l_rtg05,l_rtg06,l_rtg07,l_rtg08           #FUN-C80049 mark
        SELECT rtg05,rtg06,rtg07,rtg08,rtg11                #FUN-C80049 add
          INTO l_rtg05,l_rtg06,l_rtg07,l_rtg08,l_rtg11      #FUN-C80049 add
          FROM rtg_file
         WHERE rtg03 = p_shop AND rtg04 = p_unit
           AND rtg09 = 'Y' AND rtg01 = l_rtz05
        IF SQLCA.SQLCODE THEN
           LET g_success = 'N'
           CALL s_errmsg('rth01',p_shop,'for',SQLCA.sqlcode,1)
        END IF
     ELSE
        LET l_rtg05 = 0 
        LET l_rtg06 = 0 
        LET l_rtg07 = 0 
        LET l_rtg08 = 'Y'
        LET l_rtg11 = 0              #FUN-C80049 add
     END IF 
     IF cl_null(l_rtg05) THEN LET l_rtg05 = 0 END IF
     IF cl_null(l_rtg06) THEN LET l_rtg06 = 0 END IF
     IF cl_null(l_rtg07) THEN LET l_rtg07 = 0 END IF
     IF cl_null(l_rtg08) THEN LET l_rtg08 = 'N' END IF
     IF cl_null(l_rtg11) THEN LET l_rtg11 = 0 END IF   #FUN-C80049 add
     IF g_success = 'Y' THEN
        INSERT INTO rtg_file(rtg01,rtg02,rtg03,rtg04,rtg05,rtg06,
        #                     rtg07,rtg08,rtg09,rtgpos)             #FUN-C80049 mark
                             rtg07,rtg08,rtg09,rtg11,rtg12,rtgpos)  #FUN-C80049 add
                      VALUES(p_style,p_line,p_shop,p_unit,l_rtg05,
        #                     l_rtg06,l_rtg07,l_rtg08,'Y','1') #FUN-B40071    #FUN-C80049 mark
                             l_rtg06,l_rtg07,l_rtg08,'Y',l_rtg11,g_today,'1') #FUN-C80049 add
        IF SQLCA.SQLCODE THEN
           LET g_success = 'N'
           CALL s_errmsg('rtg',p_shop,'for',SQLCA.sqlcode,1)
        END IF
     END IF
END FUNCTION
 
# Descriptions...: 檢查營運中心是否為資料中心
# Date & Author..: NO.FUN-960130 09/06/19 By Sunyanchun
#傳入參數：p_plant   營運中心
#返回值  ：TRUE--->是資料中心
#          FALSE-->不是資料中心
 
FUNCTION s_data_center(p_plant)
DEFINE p_plant        LIKE azp_file.azp01
DEFINE l_cnt          LIKE type_file.num5
 
   
#   SELECT COUNT(*) INTO l_cnt FROM geu_file WHERE geu00 = '1'           #TQC-B90158 add
#      AND geu01 = g_plant AND geuacti = 'Y'                             #TQC-B90158 add
    SELECT count(*) INTO l_cnt FROM gev_file,geu_file              #TQC-B90158 add
           WHERE geu01 = gev04  AND  geu00 = '1'                   #TQC-B90158 add
             AND geuacti = 'Y'  AND  gev02 = p_plant               #TQC-B90158 add
   IF l_cnt IS NULL OR l_cnt = 0 THEN
      CALL cl_err('','art-906',1)
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
#FUN-960130
