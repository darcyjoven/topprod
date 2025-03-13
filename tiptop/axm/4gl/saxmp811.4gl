# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmp811.4gl
# Descriptions...: 多角訂單結案/取消結案
# Date & Author..: FUN-690089 06/10/05 by yiting 
# Modify.........: No.FUN-6A0094 06/11/07 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/24 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-820053 08/06/25 By xiaofeizhu 在結案時或者在取消結案時所有拋轉的訂單、采購單皆需一并結案或取消結案
# Modify.........: No.MOD-870060 08/07/04 By cliare 訂單數量oeb12=0,結案確認後會有錯誤
# Modify.........: No.MOD-870321 08/07/31 By claire 非一單到底設定,下站PO不會被結案
# Modify.........: No.MOD-8C0043 08/12/04 By claire (1)調整 oea63算法
#                                                   (2)結案第二個項次會失敗
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()        
# Modify.........: No.MOD-960218 09/06/19 By Dido 執行確定後畫面刷新畫面
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-A60025 10/07/09 By Summer 1.訂單確認後才可以做單身結案,單身若全結案就將單頭的狀況碼改為結案.
#                                                   2.取消結案時,若單身有項次是未結案的,就將單頭的狀況碼改為已核准. 
# Modify.........: No.FUN-AC0074 11/04/26 BY shenyang 考慮是否有備置未發量，有產生退備單
# Modify.........: No:CHI-B80016 11/08/11 By johung 依s_mpslog判斷是否取消異動
# Modify.........: No:MOD-C30046 12/03/07 By Summer 若單身有一筆以上，採購單單身會全數更新，但是單頭卻不會更新為"6.結案" 
# Modify.........: No:TQC-C70009 12/07/02 By zhuhao 語法問題
# Modify.........: No:MOD-C70133 12/07/11 By Elise 調整Transaction錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_up         LIKE type_file.chr2
DEFINE
      g_oea         DYNAMIC ARRAY OF RECORD
                    oea01     LIKE oea_file.oea01,
                    oea02     LIKE oea_file.oea02,
                    oea03     LIKE oea_file.oea03,
                    oea032    LIKE oea_file.oea032,
                    oea10     LIKE oea_file.oea10,
                    oea14     LIKE oea_file.oea14,
                    gen02     LIKE gen_file.gen02,
                    oea904    LIKE oea_file.oea904,
                    azp02     LIKE azp_file.azp02,
                    oeaconf   LIKE oea_file.oeaconf,
                    oea905    LIKE oea_file.oea905
                    END RECORD,
      g_oeb         DYNAMIC ARRAY OF RECORD
                    sure    LIKE type_file.chr1,
                    oeb03   LIKE oeb_file.oeb03,
                    oeb04   LIKE oeb_file.oeb04,
                    oeb06   LIKE oeb_file.oeb06,
                    oeb092  LIKE oeb_file.oeb092,
                    oeb05   LIKE oeb_file.oeb05,
                    oeb12   LIKE type_file.num10,
                    oeb24   LIKE type_file.num10,
                    oeb25   LIKE type_file.num10,
                    unqty   LIKE type_file.num10,
                    oeb15   LIKE oeb_file.oeb15,
                    oeb70   LIKE oeb_file.oeb70,
                    oeb09   LIKE oeb_file.oeb09,
                    oeb091  LIKE oeb_file.oeb091,
                    oeb16   LIKE oeb_file.oeb16
                    END RECORD,
    g_plant_1       DYNAMIC ARRAY OF RECORD
                    no        LIKE azp_file.azp01,
                    db_name   LIKE azp_file.azp03
                    END RECORD,
    g_wc1           STRING,
    g_rec_b1        LIKE type_file.num10,              #單頭筆數
    g_rec_b         LIKE type_file.num10,               #單身筆數
    g_rec_plant     LIKE type_file.num10,              #工廠個數
    g_sql           STRING,
    l_ac,l_ac_t,l_ac_b  LIKE type_file.num10,
    p_row,p_col     LIKE type_file.num10
 
DEFINE g_argv1        LIKE type_file.chr1    #1.結案 2.取消結案
DEFINE g_poy          RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE l_azp          RECORD LIKE azp_file.*
DEFINE p_last         LIKE type_file.num5                #流程之最后家數
DEFINE p_last_plant   LIKE type_file.chr1000
DEFINE p_first_plant  LIKE type_file.chr1000
DEFINE l_dbs_new      LIKE type_file.chr1000    #New DataBase Name
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num10
DEFINE l_sql          STRING            # RDSQL STATEMENT
DEFINE l_oeb14        LIKE oeb_file.oeb14   #MOD-870060 add
DEFINE l_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
DEFINE l_plant_new  LIKE azp_file.azp01    #FUN-980092 add
 
FUNCTION p811(p_argv1)      
DEFINE p_argv1           LIKE type_file.chr1    #1.結案 2.取消結案
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤   #TQC-C70009 add
   #顯示畫面
   LET p_row = 3 LET p_col = 2
   IF p_argv1 = '1' THEN
       OPEN WINDOW p811_w AT p_row,p_col WITH FORM "axm/42f/axmp811"
            ATTRIBUTE (STYLE = g_win_style)
   ELSE
       OPEN WINDOW p811_w AT p_row,p_col WITH FORM "axm/42f/axmp812"
            ATTRIBUTE (STYLE = g_win_style)
   END IF
 
   CALL cl_ui_init()
   LET g_argv1 = p_argv1 CLIPPED
 
   #DROP TABLE p811_tmp
   CREATE TEMP TABLE p811_tmp(
      oeb03   LIKE type_file.num5);
   DELETE FROM p811_tmp
   CALL p811_menu()
END FUNCTION
 
FUNCTION p811_cs()
  CLEAR FORM                             #清除畫面
  CALL g_oea.clear()
  CALL g_oeb.clear()
 
  CONSTRUCT g_wc1 ON oea01,oea02,oea03,oea032,oea10,oea14,oea904,oeaconf,oea905
                  FROM s_oea[1].oea01,s_oea[1].oea02,s_oea[1].oea03,
                       s_oea[1].oea032,s_oea[1].oea10,s_oea[1].oea14,
                       s_oea[1].oea904,s_oea[1].oeaconf,s_oea[1].oea905
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oea01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oea01_c"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea01
                   NEXT FIELD oea01
 
              WHEN INFIELD(oea03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea03
                   NEXT FIELD oea03
 
              WHEN INFIELD(oea14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea14
                   NEXT FIELD oea14
 
              WHEN INFIELD(oea904)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea904
                   NEXT FIELD oea904
 
              OTHERWISE EXIT CASE
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
 
  END CONSTRUCT
  IF INT_FLAG THEN
     RETURN
  END IF
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
  #End:FUN-980030
 
END FUNCTION
 
FUNCTION p811_menu()
   DEFINE l_no,l_cnt1,l_cnt2    LIKE type_file.num5  
 
   WHILE TRUE
      CALL p811_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p811_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_argv1 = '1' THEN     #結案
                   LET g_success='Y'
                   IF g_rec_b > 0 THEN
                       WHILE TRUE
                           CALL  p811_sure() RETURNING l_cnt1        #確定否
                           IF INT_FLAG THEN
                               LET INT_FLAG = 0
                               EXIT WHILE
                           END IF
                           IF l_cnt1 > 0 THEN
                              IF cl_sure(0,0) THEN
                                  LET g_success = 'Y'
                                 #BEGIN WORK                         #MOD-C70133 mark
                                 #IF g_oeb[l_ac_b].sure = 'Y'  THEN  #MOD-C70133 mark
                                  IF l_cnt1 > 0  THEN                #MOD-C70133
                                     BEGIN WORK                      #MOD-C70133
                                     CALL p811_b3_fill()                  #No.FUN-820053
                                     CALL p811_update()
                                     CALL p811_b2_fill()		  #MOD-960218 
                                     CALL p811_bp2_refresh()              #No.FUN-820053
                                     CALL s_showmsg()                     #No.FUN-710046
                                     IF g_success = 'Y' THEN
                                        CALL cl_cmmsg(1) COMMIT WORK
                                     ELSE
                                        CALL cl_rbmsg(1) ROLLBACK WORK
                                     END IF
                                  END IF
                                  DELETE FROM p811_tmp
                              END IF
                           END IF
                       END WHILE
                   END IF
               ELSE
                   LET g_success='Y'
                   IF g_rec_b > 0 THEN
                       WHILE TRUE
                           CALL p811_cancel() RETURNING l_cnt2        #確定否
                           IF INT_FLAG THEN
                               LET INT_FLAG = 0
                               EXIT WHILE
                           END IF
                           IF l_cnt2 > 0 THEN
                              IF cl_sure(0,0) THEN
                                  LET g_success = 'Y'
                                 #BEGIN WORK                        #MOD-C70133 mark
                                 #IF g_oeb[l_ac_b].sure = 'Y'  THEN #MOD-C70133 mark
                                  IF l_cnt2 > 0  THEN               #MOD-C70133
                                     BEGIN WORK                     #MOD-C70133
                                     CALL p811_b3_fill()                  #No.FUN-820053                                            
                                     CALL p811_z()
                                     CALL p811_b2_fill()		  #MOD-960218 
                                     CALL p811_bp2_refresh()              #No.FUN-820053
                                     CALL s_showmsg()                     #No.FUN-710046
                                     IF g_success = 'Y' THEN
                                        CALL cl_cmmsg(1) COMMIT WORK
                                     ELSE
                                        CALL cl_rbmsg(1) ROLLBACK WORK
                                     END IF
                                  END IF
                                  DELETE FROM p811_tmp
                              END IF
                           END IF
                       END WHILE
                   END IF
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION p811_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_oea.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL p811_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p811_b1_fill(g_wc1)
    LET l_ac = 1
END FUNCTION
 
FUNCTION p811_plant()
DEFINE  l_poy02  LIKE poy_file.poy02
DEFINE  l_flag   LIKE type_file.chr1
 
    IF cl_null(g_oea[l_ac].oea01) THEN
       RETURN 0
    END IF
 
    LET g_rec_plant = 1
    LET l_flag = 'Y'
    CALL g_plant_1.clear()
 
    SELECT poy04 INTO g_plant_1[g_rec_plant].no
      FROM poy_file
     WHERE poy01 = g_oea[l_ac].oea904
       AND poy02 = '0'
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("sel","poy_file",g_oea[l_ac].oea904,"","TSD0004","","",0)   #No.FUN-660167
       RETURN 0
    ELSE
       SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
          FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
 
       LET g_rec_plant = g_rec_plant + 1
 
       DECLARE p811_plant_cs CURSOR FOR
         SELECT poy02,poy04 FROM poy_file
          WHERE poy01 = g_oea[l_ac].oea904
          ORDER BY poy02
 
       FOREACH p811_plant_cs INTO l_poy02,g_plant_1[g_rec_plant].no
         IF STATUS THEN
            CALL cl_err(g_oea[l_ac].oea904,'TSD0004',0) 
            LET l_flag = 'N'
            EXIT FOREACH
         END IF
 
         SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
           FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
 
         LET g_rec_plant = g_rec_plant + 1
       END FOREACH
       LET g_rec_plant = g_rec_plant - 1
    END IF
    IF l_flag = 'Y' THEN
       RETURN 1
    ELSE
       RETURN 0
    END IF
 
END FUNCTION
 
FUNCTION p811_b1_fill(p_wc1)
DEFINE  p_wc1   STRING
DEFINE  l_last       LIKE poy_file.poy02,
        l_last_plant LIKE poy_file.poy04,
        l_oea01      LIKE oea_file.oea01
 
    IF cl_null(p_wc1) THEN
       LET p_wc1 = ' 1=1'
    END IF
 
    IF g_argv1 = '1' THEN    #結案
        LET g_sql = " SELECT oea01 " , 
                    "   FROM oea_file,oeb_file ",
                    "  WHERE oeb70 = 'N' ",
                    "    AND oea01 = oeb01 ",
                    "    AND oeb70 IS NOT NULL ",
                    "    AND ",p_wc1 CLIPPED,
                    "  GROUP BY oea01  "
    ELSE
        LET g_sql = " SELECT oea01 " , 
                    "   FROM oea_file,oeb_file ",
                    "  WHERE oeb70 = 'Y' ",
                    "    AND oea01 = oeb01 ",
                    "    AND oeb70 IS NOT NULL ",
                    "    AND ",p_wc1 CLIPPED,
                    "  GROUP BY oea01  "
    END IF
    LET g_rec_b1 = 1
    DISPLAY ' ' TO FORMONLY.cnt
    CALL g_oea.clear()
    PREPARE p811_p_1 FROM g_sql
    DECLARE p811_c_1 CURSOR FOR p811_p_1
    FOREACH p811_c_1 INTO l_oea01
    IF SQLCA.sqlcode THEN
       CALL cl_err('Foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
        LET g_sql = "SELECT oea01,oea02,oea03,oea032,oea10,oea14,",
                    "       ' ',oea904,' ',oeaconf,oea905 ",
                    "  FROM oea_file ",
                    " WHERE oea01 = '",l_oea01,"'",
                    "   AND oea901 = 'Y' ",   #多角訂單
                    "   AND oea11  <> '6'",   #不包含(6.多角代採買)
                    "   AND oea905 = 'Y' ",
                    "   AND oeaconf = 'Y'",
                    " ORDER BY oea01"
        PREPARE p811_pre1 FROM g_sql
        DECLARE p811_cs1 CURSOR FOR p811_pre1
 
        OPEN p811_cs1
        FETCH p811_cs1 INTO g_oea[g_rec_b1].*   #單身 ARRAY 填充
            IF SQLCA.sqlcode THEN
               CONTINUE FOREACH
            END IF
 
            # ---抓業務姓名-------
            SELECT gen02 INTO g_oea[g_rec_b1].gen02
              FROM gen_file WHERE gen01 = g_oea[g_rec_b1].oea14
 
            # ---抓出貨工廠(最後一站的工廠名稱)-------
            LET l_last_plant = NULL
            CALL s_tri_last(g_oea[g_rec_b1].oea904)
                 RETURNING l_last,l_last_plant
            SELECT azp02 INTO g_oea[g_rec_b1].azp02
               FROM azp_file
              WHERE azp01 = l_last_plant
 
            LET g_rec_b1 = g_rec_b1 + 1
            IF g_rec_b1 > g_max_rec THEN
               CALL cl_err('', 9035, 0)
               EXIT FOREACH
            END IF
    END FOREACH
    CALL g_oea.deleteElement(g_rec_b1)
    LET g_rec_b1 = g_rec_b1 - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
END FUNCTION
 
FUNCTION p811_b2_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
 
   CALL g_oeb.clear()
   IF g_argv1 = '1' THEN   #結案
       LET l_sql =
            "SELECT '',oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
            "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb70,",
            "             oeb09,oeb091,oeb16,' ' ",
            "  FROM oeb_file ",
            " WHERE oeb01 = '",g_oea[l_ac].oea01,"'",
            "   AND oeb70 = 'N'",
            " ORDER BY 1"
   ELSE
       LET l_sql =
            "SELECT '',oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
            "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb70,",
            "             oeb09,oeb091,oeb16,' ' ",
            "  FROM oeb_file ",
            " WHERE oeb01 = '",g_oea[l_ac].oea01,"'",
            "   AND oeb70 = 'Y'",
            " ORDER BY 1"
   END IF
   PREPARE p811_pb FROM l_sql
   DECLARE p811_bcs CURSOR WITH HOLD FOR p811_pb
 
   CALL g_oeb.clear()
 
   LET g_cnt = 1
 
   FOREACH p811_bcs INTO g_oeb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF g_oeb[g_cnt].oeb12 IS NULL THEN
         LET g_oeb[g_cnt].oeb12 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb24 IS NULL THEN
         LET g_oeb[g_cnt].oeb24 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb25 IS NULL THEN
         LET g_oeb[g_cnt].oeb25 = 0
      END IF
 
      IF g_oeb[g_cnt].unqty IS NULL THEN
         LET g_oeb[g_cnt].unqty = 0
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_oeb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
#No.FUN-820053--Add-Begin--#
FUNCTION p811_b3_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_no      LIKE type_file.num5
   DEFINE l_sie11 LIKE sie_file.sie11          #FUN-AC0074
   DEFINE g_oeb_t   DYNAMIC ARRAY OF RECORD
                    sure    LIKE type_file.chr1,
                    oeb03   LIKE oeb_file.oeb03,
                    oeb04   LIKE oeb_file.oeb04,
                    oeb06   LIKE oeb_file.oeb06,
                    oeb092  LIKE oeb_file.oeb092,
                    oeb05   LIKE oeb_file.oeb05,
                    oeb12   LIKE type_file.num10,
                    oeb24   LIKE type_file.num10,
                    oeb25   LIKE type_file.num10,
                    unqty   LIKE type_file.num10,
                    oeb15   LIKE oeb_file.oeb15,
                    oeb70   LIKE oeb_file.oeb70,
                    oeb09   LIKE oeb_file.oeb09,
                    oeb091  LIKE oeb_file.oeb091,
                    oeb16   LIKE oeb_file.oeb16
                    END RECORD
                    
   FOR l_no=1 TO g_rec_b
      IF g_argv1 = '1' THEN 
        IF g_oeb[l_no].sure = 'Y' THEN
          LET g_oeb_t[l_no].sure = 'Y'
          LET g_oeb_t[l_no].oeb70 = 'Y'
        ELSE
          LET g_oeb_t[l_no].sure = 'N'
          LET g_oeb_t[l_no].oeb70 = 'N'
        END IF
      ELSE
        IF g_oeb[l_no].sure = 'Y' THEN
          LET g_oeb_t[l_no].sure = 'Y'   
          LET g_oeb_t[l_no].oeb70 = 'N'
        ELSE
          LET g_oeb_t[l_no].sure = 'N'
          LET g_oeb_t[l_no].oeb70 = 'Y'
        END IF
      END IF  
   END FOR                    
 
   CALL g_oeb.clear()
   
   IF g_argv1 = '1' THEN   
       LET l_sql =
            "SELECT '',oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
            "      (oeb12-oeb24+oeb25-oeb26),oeb15,'',",
            "             oeb09,oeb091,oeb16,' ' ",
            "  FROM oeb_file ",
            " WHERE oeb01 = '",g_oea[l_ac].oea01,"'",
            "   AND oeb70 = 'N'",
            " ORDER BY 1"
   ELSE
       LET l_sql =
            "SELECT '',oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
            "      (oeb12-oeb24+oeb25-oeb26),oeb15,'',",
            "             oeb09,oeb091,oeb16,' ' ",
            "  FROM oeb_file ",
            " WHERE oeb01 = '",g_oea[l_ac].oea01,"'",
            "   AND oeb70 = 'Y'",
            " ORDER BY 1"
   END IF
   PREPARE p811_pb1 FROM l_sql
   DECLARE p811_bcs1 CURSOR WITH HOLD FOR p811_pb
 
 
   LET g_cnt = 1
 
   FOREACH p811_bcs1 INTO g_oeb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     
 
      LET g_oeb[g_cnt].sure = g_oeb_t[g_cnt].sure
      LET g_oeb[g_cnt].oeb70 = g_oeb_t[g_cnt].oeb70
 
      IF g_oeb[g_cnt].oeb12 IS NULL THEN
         LET g_oeb[g_cnt].oeb12 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb24 IS NULL THEN
         LET g_oeb[g_cnt].oeb24 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb25 IS NULL THEN
         LET g_oeb[g_cnt].oeb25 = 0
      END IF
 
      IF g_oeb[g_cnt].unqty IS NULL THEN
         LET g_oeb[g_cnt].unqty = 0
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_oeb.deleteElement(g_cnt)
 
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
#No.FUN-820053--Add-End--#
 
#FUN-AC0074--add--begin
FUNCTION p811_yes(p_oeb01,p_oeb03)
DEFINE  l_sia  RECORD LIKE sia_file.*
DEFINE  p_oeb01 LIKE oeb_file.oeb01
DEFINE  p_oeb03 LIKE oeb_file.oeb03
DEFINE  l_sie   DYNAMIC ARRAY OF RECORD
                sie01   LIKE sie_file.sie01,
                sie02   LIKE sie_file.sie02,
                sie03   LIKE sie_file.sie03,
                sie04   LIKE sie_file.sie04,
                sie05   LIKE sie_file.sie05,
                sie06   LIKE sie_file.sie06,
                sie07   LIKE sie_file.sie07,
                sie08   LIKE sie_file.sie08,
                sie09   LIKE sie_file.sie09,
                sie10   LIKE sie_file.sie10,
                sie11   LIKE sie_file.sie11,
                sie12   LIKE sie_file.sie12,
                sie13   LIKE sie_file.sie13,
                sie14   LIKE sie_file.sie14,
                sie15   LIKE sie_file.sie15,
                sie16   LIKE sie_file.sie16,
                sie012  LIKE sie_file.sie012,
                sie013  LIKE sie_file.sie013
                END RECORD
DEFINE l_ac             LIKE type_file.num5
DEFINE g_sql            STRING
DEFINE li_result    LIKE type_file.num5
DEFINE l_err        STRING
DEFINE l_flag      LIKE type_file.chr1 
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE ima_file.ima31_fac
DEFINE l_sic07_fac LIKE sic_file.sic07_fac      
DEFINE l_sic02     LIKE sic_file.sic02

      LET l_sia.sia04 ='2'
      LET l_sia.sia05 = '3'
      LET l_sia.sia06 = g_grup
      LET l_sia.sia02 =g_today
      LET l_sia.sia03 =g_today
      LET l_sia.siaacti = 'Y'
      LET l_sia.siaconf = 'N'
      LET l_sia.siauser = g_user
      LET l_sia.siaplant = g_plant
      LET l_sia.siadate = g_today
      LET l_sia.sialegal = g_legal
      LET l_sia.siagrup = g_grup
      LET l_sia.siaoriu = g_user
      LET l_sia.siaorig = g_grup
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='5' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE p410_smy FROM g_sql
         EXECUTE p410_smy INTO l_sia.sia01
        CALL s_auto_assign_no("asf",l_sia.sia01,l_sia.sia02,"","sia_file","sia01","","","")
            RETURNING li_result,l_sia.sia01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
        END IF
      INSERT INTO sia_file(sia01,sia02,sia03,sia04,sia05,sia06,siaacti,
                    siaconf,siauser,siaplant,
                     siadate,sialegal,siagrup,siaoriu,siaorig)
             VALUES (l_sia.sia01,l_sia.sia02,l_sia.sia03,l_sia.sia04,l_sia.sia05,g_grup,l_sia.siaacti,
                     l_sia.siaconf,l_sia.siauser,l_sia.siaplant,
                     l_sia.siadate,l_sia.sialegal,l_sia.siagrup,l_sia.siaoriu ,l_sia.siaorig)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sia_file",l_sia.sia01,l_sia.sia02,l_err,"","ins sia:",1)  
         LET g_success='N'
         RETURN
      END IF
      LET l_ac =1
      LET g_sql =
             "SELECT sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie09,sie10,sie11,sie12,sie13,sie14,sie15,sie16,sie012.sie013", 
             " FROM sie_file",
             " WHERE sie05 = '",p_oeb01,"' AND sie15 = '",p_oeb03,"'  AND sie11 > 0 "
      PREPARE p400_pb2 FROM g_sql
      DECLARE sie_curs2 CURSOR FOR p400_pb2
      FOREACH sie_curs2  INTO l_sie[l_ac].*
         SELECT ima25 INTO l_ima25 FROM ima_file
           WHERE ima01 = l_sie[l_ac].sie08
         CALL s_umfchk(l_sie[l_ac].sie08,l_sie[l_ac].sie07,l_ima25)
               RETURNING l_flag,l_fac
         IF l_flag THEN
            CALL cl_err('','',0)
            LET g_success = 'N'
            RETURN
         ELSE
           LET l_sic07_fac = l_fac
         END IF
         SELECT max(sic02)+1 INTO l_sic02 FROM sic_file
           WHERE sic01 = l_sia.sia01
         IF cl_NULL(l_sic02) THEN
            LET l_sic02 =1
         END IF
         INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,
                    sic06,sic07,sic08,sic09,
                     sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac)
             VALUES (l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie08,
                     l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
                     l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
                     l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sic_file",l_sia.sia01,l_sie[l_ac].sie15,l_err,"","ins sic:",1)  
         LET g_success='N'
         RETURN
      END IF
      LET l_ac= l_ac+1
     END  FOREACH
     CALL i610sub_y_chk(l_sia.sia01)
     IF g_success = "Y" THEN
        CALL i610sub_y_upd(l_sia.sia01,'',TRUE)  RETURNING l_sia.*
     END IF
END FUNCTION
#FUN-AC0074 --add--end


FUNCTION p811_bp()
   DEFINE p_ud            LIKE type_file.chr1
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         IF p811_plant() THEN
            CALL p811_b2_fill()
         ELSE
            CALL g_oeb.clear()
            DISPLAY 0 TO FORMONLY.cn2
         END IF
         CALL p811_bp2_refresh()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p811_sure()
   DEFINE l_no,l_cnt    LIKE type_file.num5  
   DEFINE l_i     LIKE type_file.num5 
   DEFINE l_c     LIKE type_file.num5
 
   IF cl_null(g_oea[l_ac].oea01) THEN
      CALL cl_err('',-400,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF #MOD-4A0247
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac_b)
          END IF
 
      BEFORE ROW
           LET l_ac_b = ARR_CURR()
 
      AFTER FIELD sure
          IF NOT cl_null(g_oeb[l_ac_b].sure) THEN
              IF g_oeb[l_ac_b].sure NOT MATCHES "[YN]" THEN
                  NEXT FIELD sure
               END IF
          END IF
          IF g_oeb[l_ac_b].sure = 'Y' THEN
              IF g_oeb[l_ac].oeb16 MATCHES '[678]' THEN   #己經結案
                  CALL cl_err(g_oeb[l_ac_b].oeb03,'axm-202',0)
                  LET g_success='N' 
                  NEXT FIELD sure
              END IF
          END IF
 
       AFTER INPUT
          LET l_cnt  = 0
         #FOR l_i =1 TO g_rec_b1  #MOD-8C0043 mark
          FOR l_i =1 TO g_rec_b   #MOD-8C0043
             IF g_oeb[l_i].sure MATCHES "[Yy]" AND
                NOT cl_null(g_oeb[l_i].oeb03)  THEN
                LET l_cnt = l_cnt + 1
                SELECT COUNT(*) INTO l_c FROM p811_tmp
                 WHERE oeb03 = g_oeb[l_i].oeb03
                IF l_c = 0 THEN
                    INSERT INTO p811_tmp VALUES(g_oeb[l_i].oeb03)
                END IF
             END IF
          END FOR
 
      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
             LET g_oeb[l_i].sure="Y"
         END FOR
         LET l_cnt = g_rec_b
 
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b    #將所有的設為選擇
             LET g_oeb[l_i].sure="N"
         END FOR
         LET l_cnt = 0
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   RETURN l_cnt
 
   MESSAGE ''
END FUNCTION
 
FUNCTION p811_cancel()
   DEFINE l_no,l_cnt    LIKE type_file.num5  
   DEFINE l_i     LIKE type_file.num5 
   DEFINE l_c     LIKE type_file.num5
 
   IF cl_null(g_oea[l_ac].oea01) THEN
      CALL cl_err('',-400,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF #MOD-4A0247
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac_b)
          END IF
 
      BEFORE ROW
           LET l_ac_b = ARR_CURR()
 
      AFTER FIELD sure
          IF NOT cl_null(g_oeb[l_ac_b].sure) THEN
              IF g_oeb[l_ac_b].sure NOT MATCHES "[YN]" THEN
                  NEXT FIELD sure
               END IF
          END IF
          IF g_oeb[l_ac_b].sure = 'Y' THEN
              IF g_oeb[l_ac_b].oeb70='N' THEN
                  CALL cl_err(g_oeb[l_ac_b].oeb03,'axm-203',0)
                  LET g_success='N' #MOD-550166
                  NEXT FIELD sure
              END IF
          END IF
 
       AFTER INPUT
          LET l_cnt  = 0
          FOR l_i =1 TO g_rec_b
             IF g_oeb[l_i].sure MATCHES "[Yy]" AND
                NOT cl_null(g_oeb[l_i].oeb03)  THEN
                LET l_cnt = l_cnt + 1
                SELECT COUNT(*) INTO l_c FROM p811_tmp
                 WHERE oeb03 = g_oeb[l_i].oeb03
                IF l_c = 0 THEN
                    INSERT INTO p811_tmp VALUES(g_oeb[l_i].oeb03)
                END IF
             END IF
          END FOR
 
      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
             LET g_oeb[l_i].sure="Y"
         END FOR
         LET l_cnt = g_rec_b
 
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b    #將所有的設為選擇
             LET g_oeb[l_i].sure="N"
         END FOR
         LET l_cnt = 0
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   RETURN l_cnt
 
   MESSAGE ''
END FUNCTION
 
FUNCTION p811_update()
   DEFINE l_oeb         RECORD LIKE oeb_file.*
   DEFINE l_pmm         RECORD LIKE pmm_file.*   #MOD-870321 add
   DEFINE l_oea         RECORD LIKE oea_file.*,
          l_oea99       LIKE oea_file.oea99,
          l_poy04_s     LIKE poy_file.poy04,
          i             LIKE type_file.num5,
          j,k           LIKE type_file.num5,
          l_oeb03       LIKE oeb_file.oeb03
   DEFINE l_no,l_cnt    LIKE type_file.num5
   DEFINE l_cnt1        LIKE type_file.num5               #FUN-820053 
   DEFINE l_n           LIKE type_file.num5     #CHI-A60025 add
   DEFINE l_sie11       LIKE sie_file.sie11          #FUN-AC0074
 
 
     IF g_oea[l_ac].oea905 = 'N' THEN
         CALL cl_err('','axm-322',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF cl_null(g_oea[l_ac].oea01) THEN
        CALL cl_err('',-400,0)
        LET g_success='N' #MOD-550166
        RETURN
     END IF #MOD-4A0247
 
     IF INT_FLAG THEN
        LET INT_FLAG=0
        LET g_success='N' #MOD-550166
        RETURN
     END IF
 
     SELECT oea99 INTO l_oea99
       FROM oea_file
      WHERE oea01= g_oea[l_ac].oea01
     CALL s_mtrade_last_plant(g_oea[l_ac].oea904)
           RETURNING p_last,p_last_plant
     IF NOT cl_null(p_last) THEN         #有最後一站站別資料
         #找出起始站別工廠
         SELECT poy04 INTO l_poy04_s
           FROM poy_file
          WHERE poy01 = g_oea[l_ac].oea904
            AND poy02 = '0'
         LET p_first_plant = l_poy04_s
         IF p_first_plant != g_plant THEN    #只能從起始站做結案動作
             CALL cl_err('','apm-012',1)
             LET g_success = 'N'
             RETURN
         END IF
         CALL s_showmsg_init()           #No.FUN-710046
         FOR k = 0 TO p_last
           #No.FUN-710046  --Begin                                                                                                        
            IF g_success = "N" THEN                                                                                                        
               LET g_totsuccess = "N"                                                                                                      
               LET g_success = "Y"                                                                                                         
            END IF                                                                                                                         
           #No.FUN-710046  --End
             CALL p811_azp(k)
             IF cl_null(l_dbs_new) THEN
                LET g_success ='N'
#               RETURN                   #No.FUN-710046
                CONTINUE FOR             #No.FUN-710046
             END IF
             LET l_cnt = 1
             LET l_oeb14 = 0             #MOD-870060 add
             LET l_cnt1 = 0              #MOD-C30046 add 
             FOR i = 1 TO g_rec_b
                 IF g_oeb[i].sure = 'Y' THEN 
                     INITIALIZE l_oeb.* TO NULL
                     #------抓出每站工廠訂單資料------#
                     #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"oea_file",#FUN-980092 mark 
                     #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file", #FUN-980092 add
                     LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102
                                " WHERE oea99 = '",l_oea99,"'"    #三角流程序號
               	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE p811_oea_p FROM l_sql
                     DECLARE oea_c CURSOR FOR p811_oea_p
                     OPEN oea_c
                     FETCH oea_c INTO l_oea.*
                     IF SQLCA.sqlcode<>0 THEN
#                        CALL cl_err('sel oea:',SQLCA.sqlcode,1)         #No.FUN-710046
                         CALL s_errmsg('','',"SEL oea:",SQLCA.sqlcode,1) #No.FUN-710046
                         LET g_success = 'N'
#                        RETURN             #No.FUN-710046
                         EXIT FOR           #No.FUN-710046
                     END IF
                     #MOD-870321-begin-add
                     #------抓出每站工廠採購資料------#
                      #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"pmm_file", #FUN-980092 mark
                      #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add
                      LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102
                                 " WHERE pmm99 = '",l_oea99,"'"    #三角流程序號
 	                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                      PREPARE p811_pmm_p FROM l_sql
                      DECLARE pmm_c CURSOR FOR p811_pmm_p
                      OPEN pmm_c
                      FETCH pmm_c INTO l_pmm.*
                     #MOD-870321-end-add
                     #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"oeb_file", #FUN-980092 mark
                     #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
                     LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102
                                " WHERE oeb01 = '",l_oea.oea01,"'",
                                "   AND oeb03 = '",g_oeb[i].oeb03,"'",    #採購單項次
                                " ORDER BY oeb03 "
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE p811_oeb_p FROM l_sql
                     DECLARE oeb_c CURSOR FOR p811_oeb_p
                     OPEN oeb_c
                     FETCH oeb_c INTO l_oeb.*
                         LET l_oeb.oeb70 = 'Y'
                         LET l_oeb.oeb70d = g_today
                         LET l_oeb.oeb26 = l_oeb.oeb12 - l_oeb.oeb24 + l_oeb.oeb25
                         IF l_oeb.oeb19 = 'Y' THEN
                             LET l_oeb.oeb905 = 0
                         END IF
                         #FUN-820053 -Add--Begin--#                                                                                 
                         #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"pmn_file ", #FUN-980092 mark
                         #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092 add
                         LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),  #FUN-A50102 
                                    "   SET pmn16 = '8'",                                                                           
                                   #" WHERE pmn01 = '",l_oeb.oeb01,"'",   #MOD-870321 mark
                                    " WHERE pmn01 = '",l_pmm.pmm01,"'",   #MOD-870321
                                    "   AND pmn02 = '",l_oeb.oeb03,"'"                                                              
 	                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE upd_pmn FROM l_sql                                                                                 
                         EXECUTE upd_pmn
                        #LET l_cnt1 = 0 #MOD-C30046 mark 
                         #FUN-820053 -Add--End--#
                         #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"oeb_file ", #FUN-980092 mark
                         #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ",  #FUN-980092 add
                         LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102 
                                    "   SET oeb70 = 'Y',",
                                    "       oeb70d = '",g_today,"',",
                                    "       oeb26 = ",l_oeb.oeb26,",",
                                    "       oeb905= ",l_oeb.oeb905,"",
                                    " WHERE oeb01 = '",l_oeb.oeb01,"'",
                                    "   AND oeb03 = '",l_oeb.oeb03,"'"
 	                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE upd_oeb FROM l_sql
                         EXECUTE upd_oeb
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_success='N'
#                           CALL cl_err3("upd","oeb_file",g_oea[l_ac].oea01,g_oeb[l_cnt].oeb03,SQLCA.sqlcode,"","(p811:ckp#3)",1)  #No.FUN-710046
#                           RETURN                                                   #No.FUN-710046
                            LET g_showmsg=l_oeb.oeb01,"/",l_oeb.oeb03                #No.FUN-710046
                            CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1) #No.FUN-710046
                            EXIT FOR                                                 #No.FUN-710046
                         ELSE                                                        #No.FUN-820053
                            LET l_cnt1 = l_cnt1 + 1                                  #No.FUN-820053
                         END IF
 
                         #-->產生MPS異動log
                         IF g_oaz.oaz06 = 'Y' THEN
                            CALL s_mpslog('C',l_oeb.oeb04,l_oeb.oeb26,l_oeb.oeb15,
                                          '','','',g_oea[l_ac].oea01,l_oeb03,l_oeb03)
                            IF g_success = 'N' THEN EXIT FOR END IF   #CHI-B80016 add
                         END IF
 
                        #LET l_sql = "SELECT SUM(oeb14/oeb12*oeb26) ",  #MOD-870060  mark
                         LET l_sql = "SELECT oeb14,oeb12,oeb26 ",       #MOD-870060 
                                     #"  FROM ",l_dbs_new,"oeb_file", #FUN-980092 mark
                                     #"  FROM ",l_dbs_tra,"oeb_file",  #FUN-980092 add
                                     "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102 
                                     " WHERE oeb01= '",l_oeb.oeb01,"'", #MOD-870060 add,
                                     "   AND oeb03= '",l_oeb.oeb03,"'"  #MOD-870060 add
 	                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE p811_sum_p FROM l_sql
                         DECLARE oeb_sum_c CURSOR FOR p811_sum_p
                         OPEN oeb_sum_c
                        #MOD-870060-begin-modify
                        #FETCH oeb_sum_c INTO l_oeb.oeb04   
                         FETCH oeb_sum_c INTO l_oeb.oeb14,l_oeb.oeb12,l_oeb.oeb26
                        #MOD-870060-end-modify
                         IF SQLCA.sqlcode<>0 THEN
#                            CALL cl_err('sel oeb04:',SQLCA.sqlcode,1)         #No.FUN-710046
                             LET g_success = 'N'
#                            RETURN               #No.FUN-710046
                             CALL s_errmsg("oeb01",l_oeb.oeb01,"SEL oeb04",SQLCA.sqlcode,1)  #No.FUN-710046
                             EXIT FOR             #No.FUN-710046
                         END IF
                        #LET l_oeb14 = l_oeb14 + (l_oeb.oeb14/l_oeb.oeb12*l_oeb.oeb26)  #MOD-870060  #MOD-8C0043 mark
                         LET l_oeb14 = (l_oeb.oeb14/l_oeb.oeb12*l_oeb.oeb26)            #MOD-8C0043  #by項次不是整張訂單故不需累計
                         LET l_oeb.oeb14 = l_oeb14 #MOD-870060 add
                         IF cl_null(l_oeb.oeb14) THEN
                            LET l_oeb.oeb14 = 0
                         END IF
 
                         #LET l_sql = "UPDATE ",l_dbs_new, "oea_file ", #FUN-980092 mark
                         #LET l_sql = "UPDATE ",l_dbs_tra, "oea_file ",  #FUN-980092 add
                         LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102 
                                    #"   SET oea63 = ",l_oeb.oeb14,"",           #MOD-8C0043 mark
                                     "   SET oea63 = oea63 + ",l_oeb.oeb14,"",   #MOD-8C0043
                                     " WHERE oea01 = '",l_oeb.oeb01,"'"
 	                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE upd_oea14 FROM l_sql
                         EXECUTE upd_oea14
                         IF STATUS OR SQLCA.SQLCODE THEN
#                            CALL cl_err('upd oea63:',SQLCA.SQLCODE,0)             #No.FUN-710046
                             LET g_success='N' #MOD-550166
#                            RETURN                       #No.FUN-710046
                             CALL s_errmsg("oea01",l_oeb.oeb01,"UPD oea63:",SQLCA.sqlcode,1)   #No.FUN-710046
                             EXIT FOR                     #No.FUN-710046
                         END IF  
 
                         FOR j = 1 TO g_oeb.getLength()
                            IF g_oeb[j].oeb03=g_oeb[i].oeb03 THEN
                               LET g_oeb[j].oeb70='Y'
                            END IF
                         END FOR 
                         #CHI-A60025 add --start--
                         #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED," oeb_file ",
                         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102
                                     " WHERE oeb01 = '",l_oeb.oeb01,"'", 
                                     " AND oeb70 = 'N'" 
                         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                         PREPARE p811_oeb70_p1 FROM l_sql 
                         IF SQLCA.SQLCODE THEN
                             LET g_success='N'
                             CALL s_errmsg("oea01",l_oeb.oeb01,"SEL oeb_file:",SQLCA.sqlcode,1)
                             EXIT FOR
                         END IF
                         DECLARE p811_oeb70_c1 CURSOR FOR p811_oeb70_p1
                         OPEN p811_oeb70_c1
                         FETCH p811_oeb70_c1 INTO l_n

                         IF l_n = 0  THEN
                            #LET l_sql = "UPDATE ",l_dbs_new, "oea_file ",
                            LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102
                                        "   SET oea49 = '2'", 
                                        " WHERE oea01 = '",l_oeb.oeb01,"'"
	                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                            PREPARE upd_oea49_1 FROM l_sql
                            EXECUTE upd_oea49_1
                            IF STATUS OR SQLCA.SQLCODE THEN
                                LET g_success='N'
                                CALL s_errmsg("oea01",l_oeb.oeb01,"UPD oea49:",SQLCA.sqlcode,1)
                                EXIT FOR
                            END IF  
                         END IF
                         #CHI-A60025 add --end--
   #FUN-AC0074--add--begin
                         SELECT  SUM(sie11) INTO l_sie11 FROM sie_file
                           WHERE  sie05 =l_oeb.oeb01  AND sie15 = l_oeb.oeb03 
                         IF l_sie11 >0 THEN
                            CALL p811_yes(l_oeb.oeb01,l_oeb.oeb03)
                            IF  g_success='N' THEN
                                EXIT  FOR
                            END IF
                         END IF
   #FUN-AC0074--add--end
                 END IF
             END FOR
             IF k <> p_last THEN                                                               #No.FUN-820053
               CALL p811_hu(l_oea99,l_cnt1)                                                    #No.FUN-820053
             END IF                                                                            #No.FUN-820053
         END FOR
#No.FUN-710046  -------------------Begin----------------------                                                                                                          
         IF g_totsuccess = 'N' THEN                                                                                                       
            LET g_success = 'N'                                                                                                           
         END IF                                                                                                                           
#No.FUN-710046  -------------------End----------------------
     END IF
END FUNCTION
 
FUNCTION p811_z()
   DEFINE l_oeb         RECORD LIKE oeb_file.*
   DEFINE l_pmm         RECORD LIKE pmm_file.*  #MOD-870321 add
   DEFINE l_oea         RECORD LIKE oea_file.*,
          l_oea99       LIKE oea_file.oea99,
          l_poy04_s     LIKE poy_file.poy04,
          i             LIKE type_file.num5,
          j,k           LIKE type_file.num5,
          l_oeb03       LIKE oeb_file.oeb03
   DEFINE l_no,l_cnt    LIKE type_file.num5 
   DEFINE l_update_sw   LIKE type_file.chr1                                                   #FUN-820053
   DEFINE l_n           LIKE type_file.num5 #CHI-A60025 add
 
     LET l_update_sw = 'N'  #當單身有一筆開啟則單頭必需開啟                                   #FUN-820053    
 
     IF g_oea[l_ac].oea905 = 'N' THEN
         CALL cl_err('','axm-322',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF cl_null(g_oea[l_ac].oea01) THEN
        CALL cl_err('',-400,0)
        LET g_success='N' #MOD-550166
        RETURN
     END IF #MOD-4A0247
 
     IF INT_FLAG THEN
        LET INT_FLAG=0
        LET g_success='N' #MOD-550166
        RETURN
     END IF
 
     SELECT oea99 INTO l_oea99
       FROM oea_file
      WHERE oea01= g_oea[l_ac].oea01
     CALL s_mtrade_last_plant(g_oea[l_ac].oea904)
           RETURNING p_last,p_last_plant
     IF NOT cl_null(p_last) THEN         #有最後一站站別資料
         #找出起始站別工廠
         SELECT poy04 INTO l_poy04_s
           FROM poy_file
          WHERE poy01 = g_oea[l_ac].oea904
            AND poy02 = '0'
         LET p_first_plant = l_poy04_s
         IF p_first_plant != g_plant THEN    #只能從起始站做結案動作
             CALL cl_err('','apm-012',1)
             LET g_success = 'N'
             RETURN
         END IF
         CALL s_showmsg_init()              #No.FUN-710046
         FOR k = 0 TO p_last
#No.FUN-710046  --Begin                                                                                                        
         IF g_success = "N" THEN                                                                                                        
            LET g_totsuccess = "N"                                                                                                      
            LET g_success = "Y"                                                                                                         
         END IF                                                                                                                         
#No.FUN-710046  --End
             CALL p811_azp(k)
             IF cl_null(l_dbs_new) THEN
                LET g_success ='N' 
#               RETURN                     #No.FUN-710046
                CONTINUE FOR               #No.FUN-710046
             END IF 
             LET l_cnt = 1
             LET l_oeb14 = 0               #MOD-870060 add
             #-------依據單身選取的項次做update------
             LET l_sql ="SELECT oeb03 FROM p811_tmp",
                        " ORDER BY oeb03 "
             PREPARE p811_tmp_p1 FROM l_sql
             DECLARE oeb_tmp_c1 CURSOR FOR p811_tmp_p1
             FOREACH oeb_tmp_c1 INTO l_oeb03
                 INITIALIZE l_oeb.* TO NULL
                 #------抓出每站工廠訂單資料------#
                 #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"oea_file", #FUN-980092 mark
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
                 LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102
                            " WHERE oea99 = '",l_oea99,"'"    #三角流程序號
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE p811_oea_p1 FROM l_sql
                 DECLARE oea_c1 CURSOR FOR p811_oea_p1
                 OPEN oea_c1
                 FETCH oea_c1 INTO l_oea.*
                 IF SQLCA.sqlcode<>0 THEN
#                    CALL cl_err('sel oea:',SQLCA.sqlcode,1)   #No.FUN-710046
                     CALL s_errmsg('','',"SEL oea:",SQLCA.sqlcode,1) #No.FUN-710046
                     LET g_success = 'N'
#                    RETURN         #No.FUN-710046
                     EXIT FOREACH   #No.FUN-710046
                 END IF
                #MOD-870321-begin-add
                #------抓出每站工廠採購資料------#
                 #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"pmm_file", #FUN-980092 mark
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add
                 LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102
                            " WHERE pmm99 = '",l_oea99,"'"    #三角流程序號
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE p811_pmm_p1 FROM l_sql
                 DECLARE pmm_c1 CURSOR FOR p811_pmm_p1
                 OPEN pmm_c1
                 FETCH pmm_c1 INTO l_pmm.*
                #MOD-870321-end-add
                 #LET l_sql ="SELECT * FROM ",l_dbs_new CLIPPED,"oeb_file", #FUN-980092 mark
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
                 LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102
                            " WHERE oeb01 = '",l_oea.oea01,"'",
                            "   AND oeb03 = '",l_oeb03,"'",    #採購單項次
                            " ORDER BY oeb03 "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
 	             PREPARE p811_oeb_p1 FROM l_sql
                 DECLARE oeb_c1 CURSOR FOR p811_oeb_p1
                 OPEN oeb_c1
                 FETCH oeb_c1 INTO l_oeb.*
                     LET l_oeb.oeb70 = 'N'
                     LET l_oeb.oeb70d = NULL
                     LET l_oeb.oeb26 = 0
                     IF l_oeb.oeb19 = 'Y' THEN
#                       CALL cl_err('','axm-809',1)      #No.FUN-710046
                        CALL s_errmsg('','','',"axm-809",0)  #No.FUN-710046
                     END IF  #no.7182
 
                     #No.FUN-820053 -Add--Begin--#                                                                                  
                     #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"pmn_file ",  #FUN-980092 mark 
                     #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmn_file ",   #FUN-980092 add
                     LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),  #FUN-A50102 
                                "   SET pmn16 = '2'",                                                                               
                               #" WHERE pmn01 = '",l_oeb.oeb01,"'",   #MOD-870321 mark
                                " WHERE pmn01 = '",l_pmm.pmm01,"'",   #MOD-870321
                                "   AND pmn02 = '",l_oeb.oeb03,"'"                                                                  
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE upd_pmn1 FROM l_sql                                                                                    
                     EXECUTE upd_pmn1                                                                                               
                     #No.FUN-820053 -Add--End--#
 
                     #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"oeb_file ",#FUN-980092 mark
                     #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ", #FUN-980092 add
                     LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102 
                                "   SET oeb70 = '",l_oeb.oeb70,"',",
                                "       oeb70d = '',",
                                "       oeb26 = ",l_oeb.oeb26,",",
                                "       oeb905= ",l_oeb.oeb905,"",
                                " WHERE oeb01 = '",l_oeb.oeb01,"'",
                                "   AND oeb03 = '",l_oeb.oeb03,"'"
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE upd_oeb1 FROM l_sql
                     EXECUTE upd_oeb1
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        LET g_success='N'
#                       CALL cl_err3("upd","oeb_file",l_oeb.oeb01,l_oeb.oeb03,SQLCA.sqlcode,"","(p811:ckp#3)",1)  #No.FUN-710046
                        LET g_showmsg=l_oeb.oeb01,"/",l_oeb.oeb03                                 #No.FUN-710046
                        CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)     #No.FUN-710046 
                        EXIT FOREACH
                     ELSE                                                                         #No.FUN-820053
                        LET l_update_sw = 'Y'                                                     #No.FUN-820053 
                     END IF
 
                     #-->產生MPS異動log
                     IF g_oaz.oaz06 = 'Y' THEN
                        CALL s_mpslog('C',l_oeb.oeb04,l_oeb.oeb26,l_oeb.oeb15,
                                      '','','',l_oeb.oeb01,l_oeb03,l_oeb03)
                        IF g_success = 'N' THEN EXIT FOREACH END IF   #CHI-B80016 add
                     END IF
 
                    #LET l_sql = "SELECT SUM(oeb14/oeb12*oeb26) ",  #MOD-870060 mark
                     LET l_sql = "SELECT oeb14,oeb12,oeb26 ",       #MOD-870060 
                                 #"  FROM ",l_dbs_new,"oeb_file", #FUN-980092 mark
                                 #"  FROM ",l_dbs_tra,"oeb_file",  #FUN-980092 add
                                 "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102 
                                 " WHERE oeb01 = '",l_oeb.oeb01,"'", #MOD-8C0043 modify,
                                 "   AND oeb03 = '",l_oeb.oeb03,"'"  #項次  #MOD-8C0043 add
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE p811_sum_p1 FROM l_sql
                     DECLARE oeb_sum_c1 CURSOR FOR p811_sum_p1
                     OPEN oeb_sum_c1
                    #MOD-870060-begin-modify
                    #FETCH oeb_sum_c1 INTO l_oeb.oeb04   
                     FETCH oeb_sum_c1 INTO l_oeb.oeb14,l_oeb.oeb12,l_oeb.oeb26
                    #MOD-870060-end-modify
                     IF SQLCA.sqlcode<>0 THEN
#                        CALL cl_err('sel oeb04:',SQLCA.sqlcode,1)         #No.FUN-710046
                         CALL s_errmsg('','',"SEL oeb04:",SQLCA.sqlcode,1) #No.FUN-710046
                         LET g_success = 'N'
#                        RETURN                 #No.FUN-710046
                         EXIT FOREACH           #No.FUN-710046
                     END IF
                     #MOD-870060-begin-add
                    #LET l_oeb14 = l_oeb14 + (l_oeb.oeb14/l_oeb.oeb12*l_oeb.oeb26)  #MOD-870060  #MOD-8C0043 mark
                     LET l_oeb14 = (l_oeb.oeb14/l_oeb.oeb12*l_oeb.oeb26)            #MOD-8C0043
                     LET l_oeb.oeb14 = l_oeb14 
                     #MOD-870060-end-add
                     IF cl_null(l_oeb.oeb14) THEN
                        LET l_oeb.oeb14 = 0
                     END IF
 
                     #LET l_sql = "UPDATE ",l_dbs_new, "oea_file ", #FUN-980092 mark
                     #LET l_sql = "UPDATE ",l_dbs_tra, "oea_file ",  #FUN-980092 add
                     LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102 
                                #"   SET oea63 = ",l_oeb.oeb14,"",          #MOD-8C0043 mark
                                 "   SET oea63 = oea63 - ",l_oeb.oeb14,"",  #MOD-8C0043
                                 " WHERE oea01 = '",l_oeb.oeb01,"'"
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE upd_oea14_p FROM l_sql
                     EXECUTE upd_oea14_p
                     IF STATUS OR SQLCA.SQLCODE THEN
#                        CALL cl_err('upd oea63:',SQLCA.SQLCODE,0)           #No.FUN-710046
                         CALL s_errmsg('','',"UPD oea63:",SQLCA.sqlcode,1)   #No.FUN-710046
                         LET g_success='N' #MOD-550166 
#                        RETURN            #No.FUN-710046
                         EXIT FOREACH      #No.FUN-710046
                     END IF
 
                     FOR j = 1 TO g_oeb.getLength()
                        IF g_oeb[j].oeb03=l_oeb03 THEN
                           LET g_oeb[j].oeb70='N'
                        END IF
                     END FOR
                     #CHI-A60025 add --start--
                     #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED," oeb_file ",
                     LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102 
                                 " WHERE oeb01 = '",l_oeb.oeb01,"'", 
                                 " AND oeb70 = 'N'" 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                     PREPARE p811_oeb70_p2 FROM l_sql 
                     IF SQLCA.SQLCODE THEN
                        LET g_success='N'
                        CALL s_errmsg("oea01",l_oeb.oeb01,"SEL oeb_file:",SQLCA.sqlcode,1)
                        EXIT FOREACH
                     END IF
                     DECLARE p811_oeb70_c2 CURSOR FOR p811_oeb70_p2
                     OPEN p811_oeb70_c2
                     FETCH p811_oeb70_c2 INTO l_n

                     IF l_n > 0  THEN
                        #LET l_sql = "UPDATE ",l_dbs_new, "oea_file ",
                        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102 
                                    "   SET oea49 = '1'", 
                                    " WHERE oea01 = '",l_oeb.oeb01,"'"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                        PREPARE upd_oea49_2 FROM l_sql
                        EXECUTE upd_oea49_2
                        IF STATUS OR SQLCA.SQLCODE THEN
                           LET g_success='N'
                           CALL s_errmsg("oea01",l_oeb.oeb01,"UPD oea49:",SQLCA.sqlcode,1)
                           EXIT FOREACH
                        END IF  
                     END IF
                     #CHI-A60025 add --end--
             END FOREACH
             #No.FUN-820053--Add--Begin--#
             IF l_update_sw = 'Y' THEN             #當單身有一筆開啟則單頭必需開啟
                IF k <> p_last THEN                      
                      #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"pmm_file ",
                      #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmm_file ",
                      LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102 
                                         "   SET pmm25 = '2' ,pmm27 = '",g_today,"'",
                                         " WHERE pmm99 = '",l_oea99,"'"     #MOD-870321
                                        #" WHERE pmm01 = '",l_oea.oea01,"'" #MOD-870321 mark
 	                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                      PREPARE upd_pmm25_p FROM l_sql
                      EXECUTE upd_pmm25_p
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         LET g_success='N'
                         IF g_bgerr THEN
                            CALL s_errmsg("pmm01",l_oea.oea01,"cannot update pmm_file",SQLCA.sqlcode,1)
                         ELSE
                            CALL cl_err3("upd","pmm_file",l_oea.oea01,"",SQLCA.sqlcode,"","cannot update pmm_file",1)
                         END IF
                      END IF
                 END IF
              END IF
             #No.FUN-820053--Add--End--#             
         END FOR
#No.FUN-710046  -----------------Begin----------------------                                                                                                          
         IF g_totsuccess = 'N' THEN                                                                                                       
            LET g_success = 'N'                                                                                                           
         END IF                                                                                                                           
#No.FUN-710046  -----------------End----------------------- 
     END IF
END FUNCTION
 
FUNCTION p811_bp2_refresh()
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 
FUNCTION p811_azp(i)
DEFINE i LIKE type_file.num5
 
    SELECT * INTO g_poy.* FROM poy_file
     WHERE poy01 = g_oea[l_ac].oea904 AND poy02 = i
    IF NOT cl_null(g_poy.poy04) THEN
        SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
       #LET l_dbs_new = l_azp.azp03 CLIPPED,"."           #TQC-950032 MARK                                                          
        LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)  #TQC-950032 ADD     
 
      #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
       LET g_plant_new = l_azp.azp01
       LET l_plant_new = g_plant_new
       CALL s_gettrandbs()
       LET l_dbs_tra = g_dbs_tra
       #--End   FUN-980092 add-------------------------------------
    END IF
 
 
END FUNCTION
 
#No.FUN-820053-Add--Begin--#
FUNCTION p811_hu(l_oea99,l_cnt1)
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_cnt1    LIKE type_file.num5
   DEFINE l_oea99   LIKE oea_file.oea99
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_pmm01   LIKE pmm_file.pmm01
   DEFINE l_pmn16_cnt LIKE type_file.num5
 
      LET l_pmn16_cnt = 0
      #LET l_sql = "SELECT pmm01 FROM ",l_dbs_new CLIPPED,"pmm_file ", #FUN-980092 mark
      #LET l_sql = "SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add
      LET l_sql = "SELECT pmm01 FROM ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102 
                  " WHERE pmm99 = '",l_oea99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p811_99_p FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p811_99',SQLCA.SQLCODE,1)
      END IF
      DECLARE p811_99_c CURSOR FOR p811_99_p
      OPEN p811_99_c
      FETCH p811_99_c INTO l_pmm01   #採購單號
 
      LET l_cnt = 0
      #-----該張採購單單身筆數----
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED," pmn_file ", #FUN-980092 mark
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," pmn_file ",  #FUN-980092 add
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),  #FUN-A50102 
                  " WHERE pmn01 = '",l_pmm01,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p811_cnt_p FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p811_cnt',SQLCA.SQLCODE,1)
      END IF
      DECLARE p811_cnt_c CURSOR FOR p811_cnt_p
      OPEN p811_cnt_c
      FETCH p811_cnt_c INTO l_cnt
 
      #該張採購單身己結案筆數
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED," pmn_file ",
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," pmn_file ",
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),  #FUN-A50102 
                  " WHERE pmn01 = '",l_pmm01,"'", 
                 #"   AND pmn16 MATCHES '[678]'"   #MOD-C30046 mark
                  "   AND pmn16 IN ('6','7','8')"  #MOD-C30046
                  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p811_cnt_p1 FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p811_cnt',SQLCA.SQLCODE,1)
      END IF
      DECLARE p811_cnt_c1 CURSOR FOR p811_cnt_p1
      OPEN p811_cnt_c1
      FETCH p811_cnt_c1 INTO l_pmn16_cnt
 
      IF l_cnt = l_cnt1 OR l_pmn16_cnt = l_cnt THEN
          #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"pmm_file ", #FUN-980092 mark
          #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add
          LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102 
                     "   SET pmm25 = '6',pmm27 = '",g_today,"'",
                     " WHERE pmm01 = '",l_pmm01,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
          PREPARE upd_pmn25 FROM l_sql
          EXECUTE upd_pmn25
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success='N'
             CALL cl_err3("upd","pmm_file",l_pmm01,"",SQLCA.sqlcode,"","(p811_hu)",1) 
          END IF
      END IF
END FUNCTION
#No.FUN-820053-Add--End--#
 
 
