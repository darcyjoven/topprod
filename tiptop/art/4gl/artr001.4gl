# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artr001.4gl
# Descriptions...: 條碼列印作業
# Date & Author..: FUN-A30113 10/03/29 By chenmoyan
# Modify.........: No.FUN-A50012 10/06/23 By shaoyong 在服飾行業中隱藏"普通查詢"中的廠商編號，
#                                                     在單身中增加字段rta06、rta07、rta08、rta09、rta10、rta11、ima1004、
#                                                     ima1005、ima1006、ima1007、ima1008、ima1009、agd03_a、agd03_b、
#                                                     rtaud01、rtaud02、rtaud03、rtaud04、rtaud05、rtaud06、rtaud07、
#                                                     rtaud08、rtaud09、rtaud10
# Modify.........: No:TQC-AC0331 10/12/24 By chenying 修改單頭產品編號、條碼開窗；若當前營運中心有維護商品策略(arti200-rtz04)時，資料需按商品策略過濾
# Modify.........: No:TQC-AC0331 10/12/27 By chenying mark FUN-A50012
# Modify.........: No:MOD-B10240 11/01/27 By shiwuying Bug修改
# Modify.........: No:TQC-B20159 11/02/23 By huangtao 規格、單位、打印數量未賦值
# Modify.........: No:FUN-B30031 11/03/23 By shiwuying 增加生效范围判断
# Modify.........: No:FUN-B90103 11/11/10 By xjll     將FUN-A50012被mark的懷遠

DATABASE ds 
GLOBALS "../../config/top.global"
 
DEFINE
   tm     RECORD
           ima01       LIKE ima_file.ima01,
           rta05       LIKE rta_file.rta05,
           pmc01       LIKE pmc_file.pmc01,
           rva01       LIKE rva_file.rva01,
           rva06       LIKE rva_file.rva06
        END RECORD,

#FUN-A50012--begin--
g_rta_ima01 DYNAMIC ARRAY OF RECORD
           ima01       LIKE ima_file.ima01
                     END RECORD,
#FUN-A50012--end--

   g_rta  DYNAMIC ARRAY OF RECORD
           sel         LIKE type_file.chr1,
           ima01_1     LIKE ima_file.ima01,
           ima02       LIKE ima_file.ima02,
           rta05_1     LIKE rta_file.rta05,
           rta04       LIKE rta_file.rta04,
#FUN-B90103------unmark--str------------------
#TQC-AC0331-----mark-----str------------------
#FUN-A50012--begin--
           rta06       LIKE rta_file.rta06,
           rta07       LIKE rta_file.rta07,
           rta08       LIKE rta_file.rta08,
           rta09       LIKE rta_file.rta09,
           rta10       LIKE rta_file.rta10,
           rta11       LIKE rta_file.rta11,
           ima1004     LIKE ima_file.ima1004,
           ima1005     LIKE ima_file.ima1005,
           ima1006     LIKE ima_file.ima1006,
           ima1007     LIKE ima_file.ima1007,
           ima1008     LIKE ima_file.ima1008,
           ima1009     LIKE ima_file.ima1009,
           agd03_a     LIKE agd_file.agd03,
           agd03_b     LIKE agd_file.agd03,
           rtaud01     LIKE rta_file.rtaud01,
           rtaud02     LIKE rta_file.rtaud02,
           rtaud03     LIKE rta_file.rtaud03,
           rtaud04     LIKE rta_file.rtaud04,
           rtaud05     LIKE rta_file.rtaud05,
           rtaud06     LIKE rta_file.rtaud06,
           rtaud07     LIKE rta_file.rtaud07,
           rtaud08     LIKE rta_file.rtaud08,
           rtaud09     LIKE rta_file.rtaud09,
           rtaud10     LIKE rta_file.rtaud10,
# FUN-A50012--end--
#TQC-AC0331------------mark--------------end---------
#FUN-B90103--------end-------------------------------
           ima021      LIKE ima_file.ima021,
           rta03       LIKE rta_file.rta03,
           qty         LIKE type_file.num10
       END RECORD 
#FUN-A50012--begin--

#TQC-AC0331-------mark---------str---------------
#FUN-B90103-------unmark-------str---------------
 DEFINE   g_rta_son    DYNAMIC ARRAY OF RECORD
           mother      LIKE ima_file.ima01,
           son         DYNAMIC ARRAY OF RECORD
                       sel         LIKE type_file.chr1,
                       ima01_1     LIKE ima_file.ima01,
                       ima02       LIKE ima_file.ima02,
                       rta05_1     LIKE rta_file.rta05,
                       rta04       LIKE rta_file.rta04,
                       rta06       LIKE rta_file.rta06,
                       rta07       LIKE rta_file.rta07,
                       rta08       LIKE rta_file.rta08,
                       rta09       LIKE rta_file.rta09,
                       rta10       LIKE rta_file.rta10,
                       rta11       LIKE rta_file.rta11,
                       ima1004     LIKE ima_file.ima1004,
                       ima1005     LIKE ima_file.ima1005,
                       ima1006     LIKE ima_file.ima1006,
                       ima1007     LIKE ima_file.ima1007,
                       ima1008     LIKE ima_file.ima1008,
                       ima1009     LIKE ima_file.ima1009,
                       agd03_a     LIKE agd_file.agd03,
                       agd03_b     LIKE agd_file.agd03,
                       rtaud01     LIKE rta_file.rtaud01,
                       rtaud02     LIKE rta_file.rtaud02,
                       rtaud03     LIKE rta_file.rtaud03,
                       rtaud04     LIKE rta_file.rtaud04,
                       rtaud05     LIKE rta_file.rtaud05,
                       rtaud06     LIKE rta_file.rtaud06,
                       rtaud07     LIKE rta_file.rtaud07,
                       rtaud08     LIKE rta_file.rtaud08,
                       rtaud09     LIKE rta_file.rtaud09,
                       rtaud10     LIKE rta_file.rtaud10,
                       ima021      LIKE ima_file.ima021,
                       rta03       LIKE rta_file.rta03,
                       qty         LIKE type_file.num10
                       END RECORD
          END RECORD
#FUN-A50012--end--
#TQC-AC0331-------mark---------end--------------
#FUN-B90103-------unmark-------end--------------
DEFINE   g_rta04             LIKE rta_file.rta04 
DEFINE   g_method            LIKE type_file.chr1 
DEFINE   g_pt1               LIKE type_file.chr1 
DEFINE   g_pt2               LIKE type_file.chr1 
DEFINE   g_sql               STRING 
DEFINE   g_name         STRING
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_msg          LIKE type_file.chr1000,
         l_ac           LIKE type_file.num5
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_xml_out      STRING
DEFINE   g_time1        LIKE type_file.chr8
DEFINE   g_wc1,g_wc2    LIKE type_file.chr1000
DEFINE   g_rza01        LIKE rza_file.rza01
DEFINE   field_array    DYNAMIC ARRAY OF LIKE type_file.chr100       #FUN-A50012 #TQC-AC0331 mark #FUN-B90103unmark
DEFINE   g_ps           LIKE type_file.chr1                          #FUN-A50012 #TQC-AC0331 mark #FUN-B90103unmark

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   LET g_time1 = g_time
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 3 LET p_col = 2
#FUN-B90103-----unmark-----str--------
#TQC-AC0331-----mark-------str--------
#FUN-A50012--begin--
   SELECT sma46 INTO g_ps FROM sma_file
   IF cl_null(g_ps) THEN
       LET g_ps=' '
   END IF
#FUN-A50012--end--
#TQC-AC0331-----mark-------end---------
#FUN-B90103-----unmark-----end---------
   OPEN WINDOW r001_w AT p_row,p_col WITH FORM "art/42f/artr001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   INITIALIZE tm.* TO NULL
   LET g_rta04 = 0
   LET g_pt1   = 'Y'
   LET g_pt2   = 'N'
   LET g_method= '1'
   CALL r001_set_visible()
   CALL r001_set_no_visible(g_method)
  #CALL s_get_rza01()            #FUN-B30031
   CALL s_get_rza01('1',g_plant) #FUN-B30031
   CALL r001_menu()
   CLOSE WINDOW r001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION r001_search()
DEFINE l_ac           LIKE type_file.num5
DEFINE l_i            LIKE type_file.num5
DEFINE l_img10        LIKE img_file.img10
DEFINE l_y            LIKE ima_file.ima151
#FUN-B90103------unmark--str------------------
#TQC-AC0331------mark---str-------------------
DEFINE l_ima151       LIKE ima_file.ima151       #FUN-A50012
DEFINE l_ima01       LIKE ima_file.ima01         #FUN-A50012
DEFINE l_agd03        LIKE agd_file.agd03        #FUN-A50012  
#TQC-AC0331------mark---end--------------------
#FUN-B90103------unmark--end-------------------
DEFINE l_agd03_sum        STRING #FUN-A50012
DEFINE   l_rtz04           LIKE rtz_file.rtz04    #TQC-AC0331
DEFINE   l_rtz04_except  LIKE type_file.num5    #TQC-AC0331
 
   IF g_pt1 = 'N' THEN
      CALL g_rta.clear()
      LET g_rec_b = 0
      LET l_ac = 1
   ELSE
      LET l_ac = g_rec_b+1
   END IF
   CALL cl_opmsg('q')
   CALL cl_set_head_visible("","YES")
 
   MESSAGE ' WAIT '
   LET  l_i = 1        #FUN-A50012 #TQC-AC0331 mark #FUN-B90103unmark
   #TQC-AC0331-----add----str--------
   CALL s_rtz04_except(g_plant) RETURNING l_rtz04_except,l_rtz04
#FUN-B90103---------------mod------str-------------
   IF NOT cl_null(l_rtz04) THEN 
       LET g_sql = " SELECT 'Y',ima01,ima02,rta05,rta04,",        #TQC-B20159 mark
#      LET g_sql = " SELECT 'Y',ima01,ima02,rta05,rta04,ima021,rta03,1 ",  #TQC-B20159 add #FUN-B90103--add
#TQC-AC0331------mod-------str-----------------
             "rta06,rta07,rta08,rta09,rta10,rta11,",                      
             "ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,",        
             "'','',rtaud01,rtaud02,rtaud03,rtaud04,",            
             "rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10,",
             "ima021,rta03,1",
            " FROM ima_file,rta_file,rte_file ",
            " WHERE ima01 = rta01 AND rte03 = rta01 AND rte01 = '",l_rtz04,"'" 
#              "   FROM ima_file,rta_file ",   #mark by FUN-B90103
#              " WHERE ima01 = rta01 "         #mark by FUN-B90103
#TQC-AC0331-----mod-----------end--------------------
   ELSE  
   #TQC-AC0331-----add----end-------- 
   LET g_sql=" SELECT 'Y',ima01,ima02,rta05,rta04,",            #TQC-B20159 mark
#  LET g_sql=" SELECT 'Y',ima01,ima02,rta05,rta04,ima021,rta03,1",            #TQC-B20159 add
#TQC-AC0331------mod-------str-----------------
             "rta06,rta07,rta08,rta09,rta10,rta11,",                      #FUN-A50012
             "ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,",          #FUN-A50012
             "'','',rtaud01,rtaud02,rtaud03,rtaud04,",              #FUN-A50012
             "rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10,",  #FUN-A50012  
             "ima021,rta03,1",
#TQC-AC0331------mod-------end-----------------
             " FROM ima_file,rta_file ",
             " WHERE ima01 = rta01 "
   END IF   #TQC-AC0331

   IF g_method = '1' THEN
      IF g_wc1<>" 1=1" THEN
         LET g_sql = g_sql," AND ",g_wc1 
      END IF
      IF g_wc2<>" 1=1" THEN
         LET g_sql = g_sql," AND ima01 in ",
                           " (SELECT rty02 FROM rty_file WHERE rty01 = '",g_plant,"'",
                           " AND rty05 in (SELECT pmc01 FROM pmc_file WHERE 1=1 AND ",
                           g_wc2," ))"
      END IF
   END IF
   IF g_method = '2' THEN
      IF g_wc1<>" 1=1" THEN
         LET g_sql = g_sql," AND ima01 in ",
                           " (SELECT rvb05 FROM rvb_file WHERE rvbplant = '",g_plant,"' AND rvb01 in ",
                           " (SELECT rva01 FROM rva_file WHERE 1=1 AND ",g_wc1,"))"
      END IF
   END IF
  
   PREPARE r001_prepare FROM g_sql
   DECLARE r001_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR r001_prepare
   FOREACH r001_cs INTO g_rta[l_ac].*
#FUN-B90103----------unmark---------str--------------
#TQC-AC0331------------mod--------str--------------
##     FUN-A50012--begin--
      IF s_industry("slk") THEN
         
         SELECT ima151 INTO l_ima151 FROM ima_file 
          WHERE ima01 = g_rta[l_ac].ima01_1

         IF  l_ima151 = 'N' THEN
             CALL s_detail_parse(l_ac)
             IF field_array.getLength() != 3 THEN
                LET l_ima01 = field_array[1],g_ps,field_array[2]
                SELECT agd03 INTO g_rta[l_ac].agd03_a FROM agd_file,ima_file,agc_file,rta_file
                 WHERE ima01 = l_ima01
                   AND ima940 = agc01
                   AND agc01 = agd01
                   AND ima01 = rta01 
                   AND agd02 = field_array[3]
                DISPLAY g_rta[l_ac].agd03_a TO agd03_a
                SELECT agd03 INTO g_rta[l_ac].agd03_b FROM agd_file,ima_file,agc_file,rta_file
                 WHERE ima01 = l_ima01
                   AND ima941 = agc01
                   AND agc01 = agd01
                   AND ima01 = rta01 
                   AND agd02 = field_array[4]
                DISPLAY g_rta[l_ac].agd03_b TO agd03_b
             ELSE  
                LET l_ima01 = field_array[1]
                SELECT agd03 INTO g_rta[l_ac].agd03_a FROM agd_file,ima_file,agc_file,rta_file
                 WHERE ima01 = l_ima01
                   AND ima940 = agc01
                   AND agc01 = agd01
                   AND ima01 = rta01 
                   AND agd02 = field_array[2]
                DISPLAY g_rta[l_ac].agd03_a TO agd03_a
                SELECT agd03 INTO g_rta[l_ac].agd03_b FROM agd_file,ima_file,agc_file,rta_file
                 WHERE ima01 = l_ima01
                   AND ima941 = agc01
                   AND agc01 = agd01
                   AND ima01 = rta01 
                   AND agd02 = field_array[3]
                DISPLAY g_rta[l_ac].agd03_b TO agd03_b
             END IF  
             
         ELSE  

            LET l_agd03_sum ='' 
            LET l_agd03 ='' 
            LET g_cnt = 1
            LET g_sql=" SELECT DISTINCT agd03 FROM agd_file,ima_file,agc_file,rta_file ",
                      "  WHERE ima01 = '",g_rta[l_ac].ima01_1,"' ",
                      "    AND ima940=agc01 ",
                      "    AND agc07 = '1' ",
                      "    AND agc01 = agd01 ",
                      "    AND ima01 = rta01 "
            PREPARE r001_agd03 FROM g_sql
            DECLARE r001_agd03_cs CURSOR FOR r001_agd03
        
            FOREACH r001_agd03_cs INTO l_agd03
               IF g_cnt = 1 THEN
                  LET l_agd03_sum = l_agd03 CLIPPED
               ELSE
                  LET l_agd03_sum = l_agd03_sum,",",l_agd03 CLIPPED
               END IF
               LET g_cnt = g_cnt + 1
            END FOREACH

            LET g_cnt = 0 
            LET g_rta[l_ac].agd03_a = l_agd03_sum
            DISPLAY g_rta[l_ac].agd03_a TO agd03_a
            
            LET l_agd03_sum =''
            LET l_agd03 =''
            LET g_cnt = 1
            LET g_sql=" SELECT DISTINCT agd03 FROM agd_file,ima_file,agc_file,rta_file ",
                      "  WHERE ima01 = '",g_rta[l_ac].ima01_1,"' ",
                      "    AND ima941=agc01 ",
                      "    AND agc07 = '2' ",
                      "    AND agc01 = agd01 ",
                      "    AND ima01 = rta01 "
            PREPARE r001_agd03_b FROM g_sql
            DECLARE r001_agd03_cs_b CURSOR FOR r001_agd03_b
        
            FOREACH r001_agd03_cs_b INTO l_agd03
               IF g_cnt = 1 THEN
                  LET l_agd03_sum = l_agd03 CLIPPED
               ELSE
                  LET l_agd03_sum = l_agd03_sum,",",l_agd03 CLIPPED
               END IF
               LET g_cnt = g_cnt + 1
            END FOREACH

            LET g_cnt = 0
            LET g_rta[l_ac].agd03_b = l_agd03_sum
            DISPLAY g_rta[l_ac].agd03_b TO agd03_b

           #根據母料號，將所有子料號的信息收集
            LET g_rta_son[l_i].mother = g_rta[l_ac].ima01_1
            LET g_sql = "SELECT ima01 FROM ima_file,rta_file ",
                        " WHERE ima01 = rta01 ",
                        "   AND ima01 LIKE '",g_rta[l_ac].ima01_1,g_ps,"%' " 
            PREPARE r001_son FROM g_sql
            DECLARE r001_son_cs CURSOR FOR r001_son
            LET g_cnt = 1

            FOREACH r001_son_cs INTO g_rta_son[l_i].son[g_cnt].ima01_1
               LET g_sql=" SELECT 'Y',ima01,ima02,rta05,rta04,",
                         "rta06,rta07,rta08,rta09,rta10,rta11,",                      
                         "ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,",          
                         "'','',rtaud01,rtaud02,rtaud03,rtaud04,",              
                         "rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10,",  
                         "ima021,rta03,1",
                        " FROM ima_file,rta_file ",
                        " WHERE ima01 = rta01 ",
                        "   AND ima01 = '",g_rta_son[l_i].son[g_cnt].ima01_1,"' "
               PREPARE r001_son_prepare FROM g_sql
               DECLARE r001_son_prepare_cs CURSOR FOR r001_son_prepare   #SCROLL CURSOR
               FOREACH r001_son_prepare_cs INTO g_rta_son[l_i].son[g_cnt].*
              
                  CALL s_detail_parse_2(l_i,g_cnt)
                  IF field_array.getLength() != 3 THEN
                     LET l_ima01 = field_array[1],g_ps,field_array[2]
                     SELECT agd03 INTO g_rta_son[l_i].son[g_cnt].agd03_a FROM agd_file,ima_file,agc_file,rta_file
                      WHERE ima01 = l_ima01
                        AND ima940 = agc01
                        AND agc01 = agd01
                        AND ima01 = rta01
                        AND agd02 = field_array[3]
                     SELECT agd03 INTO g_rta_son[l_i].son[g_cnt].agd03_b FROM agd_file,ima_file,agc_file,rta_file
                      WHERE ima01 = l_ima01
                        AND ima941 = agc01
                        AND agc01 = agd01
                        AND ima01 = rta01
                        AND agd02 = field_array[4]
                  ELSE
                     LET l_ima01 = field_array[1]
                     SELECT agd03 INTO g_rta_son[l_i].son[g_cnt].agd03_a FROM agd_file,ima_file,agc_file,rta_file
                      WHERE ima01 = l_ima01
                        AND ima940 = agc01
                        AND agc01 = agd01
                        AND ima01 = rta01
                        AND agd02 = field_array[2]
                     SELECT agd03 INTO g_rta_son[l_i].son[g_cnt].agd03_b FROM agd_file,ima_file,agc_file,rta_file
                      WHERE ima01 = l_ima01
                        AND ima941 = agc01
                        AND agc01 = agd01
                        AND ima01 = rta01
                        AND agd02 = field_array[3]
                  END IF
               END FOREACH

               LET g_cnt = g_cnt + 1
            END FOREACH

            CALL g_rta_son[l_i].son.deleteElement(g_cnt)
            LET l_i = l_i + 1
            END IF
      END IF
##     FUN-A50012--end--
#TQC-AC0331-----mark--------------end---------- 
#FUN-B90103-----unmak-------------end----------
      IF g_rta04 <> 0 THEN
         IF g_rta[l_ac].rta04 <> g_rta04 THEN
            CALL g_rta.DeleteElement(l_ac)
            CONTINUE FOREACH
         END IF
      END IF
      SELECT SUM(img10) INTO l_img10 
        FROM img_file 
       WHERE img01=g_rta[l_ac].ima01_1
      IF g_pt2 = 'Y' AND (l_img10 <= 0 OR cl_null(l_img10)) THEN
         CALL g_rta.DeleteElement(l_ac)
         CONTINUE FOREACH
      END IF
      IF g_method = '2' THEN
         LET g_sql=" SELECT SUM(rvb07) FROM rvb_file,rva_file ",
                   "  WHERE rva01 = rvb01",
                   "    AND rvb05 = '",g_rta[l_ac].ima01_1,"'"
         IF NOT cl_null(tm.rva06) THEN
            LET g_sql=g_sql,"AND rvb06 in ('",tm.rva06,"')"
         END IF
         IF NOT cl_null(tm.rva01) THEN
            LET g_sql = g_sql,"AND rvbplant='",g_plant,"' ",
                              "AND rvb01 in ('",tm.rva01,"')"
         END IF
         PREPARE r001_prepare1 FROM g_sql
         DECLARE r001_cs1 CURSOR FOR r001_prepare1
         OPEN r001_cs1
         FETCH r001_cs1 INTO g_rta[l_ac].qty
         CLOSE r001_cs1
         IF cl_null(g_rta[l_ac].qty) THEN
            LET g_rta[l_ac].qty = 1
         END IF
      END IF
      LET l_ac = l_ac+1
          
   END FOREACH
   CALL g_rta.deleteElement(l_ac)
   LET l_ac = l_ac - 1
   LET g_rec_b = l_ac
 
END FUNCTION
 
FUNCTION r001_menu()
   WHILE TRUE
      CALL r001_bp("G")
      CASE g_action_choice
         WHEN "search"
            IF cl_chk_act_auth() THEN
               CALL r001_search()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "clear"
            IF cl_chk_act_auth() THEN
               CALL g_rta.clear()
               LET g_rec_b = 0
            END IF
         WHEN "sel_none" 
            IF cl_chk_act_auth() THEN
               CALL r001_sel('N')
            END IF
         WHEN "sel_all" 
            IF cl_chk_act_auth() THEN
               CALL r001_sel('Y')
            END IF
         WHEN "print"
            IF cl_chk_act_auth() THEN
               CALL r001_print()
            END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION r001_sel(p_type)
DEFINE p_type     LIKE type_file.chr1
DEFINE i          LIKE type_file.num5
   FOR i=1 TO g_rec_b
      LET g_rta[i].sel = p_type
   END FOR
END FUNCTION
 
 
FUNCTION r001_bp(p_ud)
   DEFINE   p_ud              LIKE type_file.chr1
   DEFINE   l_rtz04           LIKE rtz_file.rtz04    #TQC-AC0331    
   DEFINE   l_rtz04_except    LIKE type_file.num5    #TQC-AC0331 
   DEFINE   l_n               LIKE type_file.num5    #TQC-AC0331 

 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL r001_set_visible()
   CALL r001_set_no_visible(g_method)
   LET g_action_choice = " "
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME g_method,g_rza01,g_rta04,g_pt1,g_pt2
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         ON CHANGE g_method
            CALL r001_set_visible()
            CALL r001_set_no_visible(g_method)
            IF g_method = '1' THEN
               NEXT FIELD ima01
            ELSE
               NEXT FIELD rva01
            END IF
      END INPUT
      CONSTRUCT BY NAME g_wc2 ON pmc01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
               WHEN INFIELD(pmc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_pmc18'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD pmc01
                  OTHERWISE EXIT CASE 
            END CASE
      END CONSTRUCT        

      CONSTRUCT BY NAME g_wc1 ON ima01,rta05,
                    rva01,rva06
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION CONTROLP 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
               WHEN INFIELD(ima01)
#TQC-AC0331----------mod---------------str--------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = 'c'
#                 LET g_qryparam.form ="q_ima"   
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'') 
                      RETURNING  g_qryparam.multiret
#TQC-AC0331----------mod---------------end----------------
                  DISPLAY g_qryparam.multiret TO ima01 
                  NEXT FIELD ima01 
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD ima01
               WHEN INFIELD(rta05)
                  CALL s_rtz04_except(g_plant) RETURNING l_rtz04_except,l_rtz04    #TQC-AC0331 add
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'       
                  IF  l_rtz04_except THEN                               #TQC-AC0331 add      
                      LET g_qryparam.form = 'q_rta2'                    #TQC-AC0331 add
                      LET g_qryparam.arg1 = l_rtz04                     #TQC-AC0331 add                 
                  ELSE                                                  #TQC-AC0331 add 
                      LET g_qryparam.form = 'q_rta1'                    #TQC-AC0331 add
                  END IF                                                #TQC-AC0331 add 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rta05
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rta05
               WHEN INFIELD(rva01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_rva01'
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rva01
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rva01
                  OTHERWISE EXIT CASE 
            END CASE
      END CONSTRUCT
      INPUT ARRAY g_rta FROM s_rta.*
           ATTRIBUTES(WITHOUT DEFAULTS=TRUE,COUNT=g_rta.getLength(),MAXCOUNT=g_rta.getLength(),
                     INSERT ROW=FALSE,DELETE ROW=FALSE,
                     APPEND ROW=FALSE)
 
         BEFORE INPUT
            DISPLAY "BEFORE INPUT ARRAY!"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            DISPLAY "BEFORE ROW!"
            LET l_ac = ARR_CURR()
            LET g_rec_b = ARR_COUNT()
         AFTER FIELD qty
            IF l_ac>0 THEN
               IF g_rta[l_ac].qty<=0 THEN
                  CALL cl_err('','art-096',0)
                  NEXT FIELD qty
               END IF
            END IF

         AFTER INPUT
            IF l_ac>0 THEN
               IF g_rta[l_ac].qty<=0 THEN
                  CALL cl_err('','art-096',0)
                  NEXT FIELD qty
               END IF
            END IF
      END INPUT
      
      ON ACTION search
         IF cl_null(GET_FLDBUF(ima01)) AND cl_null(GET_FLDBUF(rta05)) AND cl_null(GET_FLDBUF(pmc01))
            AND cl_null(GET_FLDBUF(rva01)) AND cl_null(GET_FLDBUF(rva06)) THEN
            CALL cl_err('','art-121',0)
            NEXT FIELD ima01
         ELSE 
            LET g_action_choice="search"
            EXIT DIALOG
         END IF

      ON ACTION clear
         LET g_action_choice="clear"
         EXIT DIALOG
 
      ON ACTION sel_all
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="sel_all"
         EXIT DIALOG

      ON ACTION sel_none
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="sel_none"
         EXIT DIALOG

      ON ACTION print
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="print"
         EXIT DIALOG

      ON ACTION help
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
 
   END DIALOG
      
 
 
END FUNCTION

FUNCTION r001_xml()
DEFINE l_channel       base.Channel
DEFINE l_time     LIKE type_file.chr20                                                                                           
DEFINE l_date1    LIKE type_file.chr20                                                                                           
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_cmd      LIKE type_file.chr1000
    LET l_date1 = g_today                                                                                                            
    LET l_time = g_time1                                                                                                              
    LET l_dt   = l_date1[1,2],l_date1[4,5],l_date1[7,8],                                                                             
                 l_time[1,2],l_time[4,5],l_time[7,8]
    LET g_name = FGL_GETENV("TEMPDIR") CLIPPED,'/',"artr001",l_dt,".xml"
    LET l_cmd  = "rm -f ",g_name
    RUN l_cmd
    LET l_channel = base.Channel.create()
    CALL l_channel.openFile(g_name,"a" )
    CALL l_channel.setDelimiter("")

    CALL l_channel.write(g_xml_out)
    CALL l_channel.close()
END FUNCTION

FUNCTION r001_xml_out()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_i,l_j,l_k,l_kk   LIKE type_file.num10                  
DEFINE l_ima151           LIKE ima_file.ima151
 
   IF g_rta.getLength() = 0 THEN
      RETURN
   END IF
#FUN-B90103-------MOD-----str----------------------
  IF s_industry("slk") THEN 
     LET l_str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>", ASCII 10,
                 "<Data>", ASCII 10,
                 "       <DataSet Field=\"ima01|ima02|rta05|ima021|rta07|rta08|rta09|rta10|agd03_a|agd03_b\">", ASCII 10    #FUN-A50012  #TQC-AC0331 mark  #FUN-B90103--unmark
                #"       <DataSet Field=\"ima01|ima02|rta05|ima021|qty\">", ASCII 10    #TQC-AC0331 add   #FUN-B90103--mark
  ELSE
     LET l_str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>", ASCII 10,
                 "<Data>", ASCII 10,
                 "       <DataSet Field=\"ima01|ima02|rta05|ima021|qty\">", ASCII 10    #TQC-AC0331 add 
  END IF
#FUN-B90103----------end-------------------------
##MOD-B10240 Begin---
  IF s_industry("slk") THEN                    #TQC-AC0331 mark  #FUN-B90103 unmark 
      FOR l_i = 1 TO g_rta.getLength()         #FUN-B90103 unmark
          IF g_rta[l_i].sel = 'Y' THEN         #FUN-B90103 unmark
            FOR l_j = 1 TO g_rta[l_i].qty      #TQC-AC0331 mark  #FUN-B90103 unmark

#FUN-B90103-----------------unmark---------str--------------
##TQC-AC0331----------------mark------------str-------------- 
##               #FUN-A50012--begin--
  
                 SELECT ima151 INTO l_ima151 FROM ima_file 
                  WHERE ima01 = g_rta[l_i].ima01_1
                 IF l_ima151 = 'Y' THEN
                    FOR l_k = 1 TO g_rta_son.getLength()
                        IF g_rta_son[l_k].mother = g_rta[l_i].ima01_1 THEN
                           FOR l_kk = 1 TO g_rta_son[l_k].son.getLength()
                              LET l_str2 = "          <Row Data=\"",g_rta_son[l_k].mother,"|",g_rta_son[l_k].son[l_kk].ima02,"|",                           #FUN-A50012
                                           g_rta_son[l_k].son[l_kk].rta05_1,"|",g_rta_son[l_k].son[l_kk].ima021,"|",g_rta_son[l_k].son[l_kk].rta07,"|",                              #FUN-A50012
                                           g_rta_son[l_k].son[l_kk].rta08,"|",g_rta_son[l_k].son[l_kk].rta09,"|",g_rta_son[l_k].son[l_kk].rta10,"|",                                 #FUN-A50012
                                           g_rta_son[l_k].son[l_kk].agd03_a,"|",g_rta_son[l_k].son[l_kk].agd03_b,"\"/>", ASCII 10                                      #FUN-A50012
                              LET l_str = l_str, l_str2
                           END FOR
                        END IF
                    END FOR
                 ELSE
##TQC-AC0331----------mark----------------end---------------- 
                    LET l_str2 = "          <Row Data=\"",g_rta_ima01[l_i].ima01,"|",g_rta[l_i].ima02,"|",                           #FUN-A50012
                                #TQC-AC0331------mod---------str-------------------
                                 g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].rta07,"|",                              #FUN-A50012
                                 g_rta[l_i].rta08,"|",g_rta[l_i].rta09,"|",g_rta[l_i].rta10,"|",                                 #FUN-A50012
                                 g_rta[l_i].agd03_a,"|",g_rta[l_i].agd03_b,"\"/>", ASCII 10                                      #FUN-A50012
                            #    g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].qty,"\"/>", ASCII 10                    #FUN-B90103--mark
                                #TQC-AC0331------mod---------end--------------------
                    LET l_str = l_str, l_str2
                 END IF
  
                #FUN-A50012--end--
              END FOR
 #TQC-AC0331---------mark------str----------
           END IF  
       END FOR
    ELSE
       FOR l_i = 1 TO g_rta.getLength()
           IF g_rta[l_i].sel = 'Y' THEN
              FOR l_j = 1 TO g_rta[l_i].qty
#FUN-B90103----add--begin----------------------------
               LET l_str2 = "          <Row Data=\"",g_rta[l_i].ima01_1,"|",g_rta[l_i].ima02,"|",              
                             g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].qty,"\"/>", ASCII 10
               LET l_str = l_str, l_str2
#FUN-B90103----end-----------------------------------
#FUN-B90103------mark----begin--------
#                  LET l_str2 = "          <Row Data=\"",g_rta[l_i].ima01_1,"|",g_rta[l_i].ima02,"|",                           #FUN-A50012
#                               g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].rta07,"|",                              #FUN-A50012
#                               g_rta[l_i].rta08,"|",g_rta[l_i].rta09,"|",g_rta[l_i].rta10,"|",                                 #FUN-A50012
#                               g_rta[l_i].agd03_a,"|",g_rta[l_i].agd03_b,"\"/>", ASCII 10                                      #FUN-A50012
#                  LET l_str = l_str, l_str2
#FUN-B90103-----mark---end-------------
              END FOR
           END IF
       END FOR
    END IF
##TQC-AC0331---------mark------end-------------
#FUN-B90103----------unmark----end-------------
#FUN-B90103----------mark------begin-----------
#   FOR l_i = 1 TO g_rta.getLength()
#       IF g_rta[l_i].sel = 'Y' THEN
#          FOR l_j = 1 TO g_rta[l_i].qty
#              LET l_str2 = "          <Row Data=\"",g_rta[l_i].ima01_1,"|",g_rta[l_i].ima02,"|",                           #FUN-A50012
#                            g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].qty,"\"/>", ASCII 10
#              LET l_str = l_str, l_str2
#          END FOR
#       END IF
#   END FOR
#FUN-B90103------mark-----end-----------------
#MOD-B10240 End-----

   LET l_str = l_str,
               "       </DataSet>", ASCII 10,
               "</Data>", ASCII 10
 
   LET g_xml_out = l_str
   DISPLAY g_xml_out TO FORMONLY.out
END FUNCTION
FUNCTION r001_print()
   CALL r001_xml_out()
   CALL r001_xml()
   IF NOT p_pricetag_print(g_rza01,g_name) THEN END IF
END FUNCTION

FUNCTION r001_set_visible()
   CALL cl_set_comp_visible("gb1,gb7",TRUE)
#FUN-B90103---------unmark------str----------------------
#TQC-AC0331---------mark--------str----------------------
##  FUN-A50012--begin--
 IF s_industry("slk") THEN
         CALL cl_set_comp_visible("pmc01",FALSE)
 ELSE
         CALL cl_set_comp_visible("rta06,rta07,rta08,rta09,rta10,rta11,
                                   ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,
                                   agd03_a,agd03_b,rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,
                                   rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",FALSE)
                                  
 END IF
#  FUN-A50012--end--
#TQC-AC0331---------mark--------end--------------------
#FUN-B90103---------unmark------end--------------------

END FUNCTION
FUNCTION r001_set_no_visible(p_type)
DEFINE p_type LIKE type_file.chr1
   IF p_type = '1' THEN
      CALL cl_set_comp_visible("gb7",FALSE)
   ELSE
      CALL cl_set_comp_visible("gb1",FALSE)
   END IF
END FUNCTION

#FUN-B90103------unmark-----str----------
#TQC-AC0331-----add----str---------------
#FUN-A50012--begin--
FUNCTION s_detail_parse(p_ac)
   DEFINE l_str  STRING
   DEFINE l_str1 STRING
   DEFINE l_tok  base.stringTokenizer
   DEFINE l_i    LIKE type_file.num5
   DEFINE p_ac    LIKE type_file.num5
 # DEFINE l_ima01 LIKE ima_file.ima01
   DEFINE l_ima01 STRING

   LET l_str  = g_rta[p_ac].ima01_1

   LET l_tok = base.StringTokenizer.createExt(l_str,g_ps,'',TRUE)
   IF l_tok.countTokens() > 0 THEN
      LET l_i=0
      WHILE l_tok.hasMoreTokens()
            LET l_i=l_i+1
            LET field_array[l_i] = l_tok.nextToken()
      END WHILE
   END IF
   LET l_ima01 = field_array[2],field_array[3]
   LET g_rta_ima01[p_ac].ima01 = l_str.subString(1,l_str.getLength() - l_ima01.getLength()) 
   
 END FUNCTION

 FUNCTION s_detail_parse_2(l_ac1,l_ac2)
   DEFINE l_str  STRING
   DEFINE l_str1 STRING
   DEFINE l_tok  base.stringTokenizer
   DEFINE l_i    LIKE type_file.num5
   DEFINE p_ac    LIKE type_file.num5
   DEFINE l_ac1   LIKE type_file.num5
   DEFINE l_ac2   LIKE type_file.num5

   LET l_str  = g_rta_son[l_ac1].son[l_ac2].ima01_1

   LET l_tok = base.StringTokenizer.createExt(l_str,g_ps,'',TRUE)
   IF l_tok.countTokens() > 0 THEN
      LET l_i=0
      WHILE l_tok.hasMoreTokens()
            LET l_i=l_i+1
            LET field_array[l_i] = l_tok.nextToken()
      END WHILE
   END IF
 END FUNCTION
##FUN-A50012--end--
#TQC-AC0331------------mark--------end--------------
#FUN-B90103------------unmark------end--------------
#FUN-A30113
