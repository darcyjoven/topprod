# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: s_diy_barcode.4gl
# Descriptions...: 手動條碼產生副程式 
# Date & Author..: No:DEV-D30042 13/03/21 By TSD.sophy 
# Usage..........: CALL s_diy_barcode(p_no,p_ln,p_seq,p_point)
# Input Parameter: p_no      單據編號
#                  p_ln      單據項次 (for IQC之來源項次)
#                  p_seq     順序     (for IQC之分批順序)
#                  p_point   條碼產生時機點(A~L)
#                            A:工單(asfi301)
#                            B:FQC 品質記錄(aqct410)
#                            C:工單生產報工單(asft300)
#                            D:生產日報(asft700)
#                            E:採購入庫(apmt720)
#                            F:採購單(apmt540)
#                            G:委外採購單(apmt590)
#                            H:訂單包裝單(abai140)
#                            I:倉庫雜項收料(aimt302)
#                            J:交接單(abat630)
#                            K:採購收貨作業(apmt110)
#                            L:IQC 品質記錄維護作業(aqct110)
# Return Code....: TRUE/FALSE
#                  TRUE      條碼產生成功          
#                  FALSE     條碼產生失敗                               
# Modiy..........: No:DEV-D30046 13/04/18 By TSD.sophy 調整輸入之批序號檢查是否重複


DATABASE ds

GLOBALS "../../config/top.global"  

DEFINE g_no         LIKE type_file.chr20       #單據編號
DEFINE g_ln         LIKE type_file.num5        #單據項次
DEFINE g_seq        LIKE type_file.num5        #順序
DEFINE g_point      LIKE type_file.chr1        #條碼產生時機點
DEFINE g_diy        DYNAMIC ARRAY OF RECORD 
          ln           LIKE type_file.num5,    #項次 
          ima01        LIKE ima_file.ima01,    #料件編號
          ima02        LIKE ima_file.ima02,    #品名
          ima021       LIKE ima_file.ima021,   #規格
          lot          LIKE type_file.chr30,   #製造批號
          seq          LIKE type_file.chr30,   #起始序號
          end_seq      LIKE type_file.chr30,   #截止序號
          qty          LIKE type_file.num15_3, #數量
          ima918       LIKE ima_file.ima918,   #製造批號管理否
          ima919       LIKE ima_file.ima919,   #製造批號自動編碼否
          ima920       LIKE ima_file.ima920,   #製造批號編碼原則
          ima921       LIKE ima_file.ima921,   #序號管理否
          ima922       LIKE ima_file.ima922,   #序號自動編碼否
          ima923       LIKE ima_file.ima923    #序號編碼原則
                    END RECORD 
DEFINE g_rec_b      LIKE type_file.num5
DEFINE l_ac         LIKE type_file.num5
DEFINE g_cnt        LIKE type_file.num5
DEFINE g_sql        STRING 
DEFINE g_msg        STRING 
DEFINE g_code       LIKE iba_file.iba01
DEFINE g_complete   LIKE type_file.chr1
DEFINE g_code_exist LIKE type_file.chr1
DEFINE g_tmp        DYNAMIC ARRAY OF RECORD 
          ln           LIKE type_file.num5,    #項次 
          lot          LIKE type_file.chr30,   #製造批號
          seq          DYNAMIC ARRAY OF LIKE type_file.chr30,    #起始序號
          exist        LIKE type_file.chr1
                    END RECORD 

FUNCTION s_diy_barcode(p_no,p_ln,p_seq,p_point)
DEFINE p_no       LIKE type_file.chr20       #單據編號
DEFINE p_ln       LIKE type_file.num5        #單據項次
DEFINE p_seq      LIKE type_file.num5        #順序
DEFINE p_point    LIKE type_file.chr1        #條碼產生時機點
DEFINE l_i        LIKE type_file.num5

   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_no = p_no
   LET g_ln = p_ln
   LET g_seq = p_seq
   LET g_point = p_point

   IF g_no IS NULL OR g_point IS NULL THEN 
      RETURN 
   END IF  

   #訂單包裝單、交接單可手動產生條碼
   IF g_point MATCHES '[HJ]' THEN 
      RETURN
   END IF 
   
   OPEN WINDOW s_diy_barcode_w WITH FORM "sub/42f/s_diy_barcode"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("s_diy_barcode")

   DISPLAY g_no TO FORMONLY.no
   CALL s_diy_barcode_b_fill()
   DISPLAY g_rec_b TO FORMONLY.cnt
    
   #無手動產生條碼資料
   IF g_rec_b = 0 THEN 
      CLOSE WINDOW s_diy_barcode_w
      RETURN TRUE  
   END IF 

   CALL s_diy_barcode_b()
   CLOSE WINDOW s_diy_barcode_w
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN FALSE  
   END IF 

   LET g_complete = 'Y' 
   
   LET g_barcode_no = g_no 
   FOR l_i=1 TO g_rec_b
      LET g_barcode_ln = g_diy[l_i].ln
      CALL s_diy_barcode_gen_data(l_i)
   END FOR

   IF g_complete = 'N' THEN 
      RETURN FALSE
   END IF 
   
   RETURN TRUE 
END FUNCTION 

FUNCTION s_diy_barcode_b_fill()
DEFINE l_geh04_1      LIKE geh_file.geh04
DEFINE l_geh04_2      LIKE geh_file.geh04
DEFINE l_desc         LIKE type_file.chr50
DEFINE l_iba01        LIKE iba_file.iba01
DEFINE l_i            LIKE type_file.num10
DEFINE l_qty          LIKE type_file.num10

   CALL g_diy.clear()
   CALL g_tmp.clear()
   LET g_rec_b = 0 
   LET g_cnt = 1
   LET g_barcode_no = g_no 

   CASE g_point
      WHEN 'A'   #工單(asfi301)
         LET g_sql = "SELECT '',sfb05,ima02,ima021,'','','',sfb08,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,sfb_file ",
                     " WHERE ima01 = sfb05 ",
                     "   AND sfb01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'B'   #FQC品質記錄(aqct410)
         LET g_sql = "SELECT '',qcf021,ima02,ima021,'','','',qcf22,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,qcf_file ",
                     " WHERE ima01 = qcf021 ",
                     "   AND qcf01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'C'   #工單生產報工單(asft300) 
         LET g_sql = "SELECT srg02,srg03,ima02,ima021,'','','',srg05,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,srg_file ",
                     " WHERE ima01 = srg03 ",
                     "   AND srg01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'D'   #生產日報(asft700)
         LET g_sql = "SELECT '',shb10,ima02,ima021,'','','',shb111,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,shb_file ",
                     " WHERE ima01 = shb10 ",
                     "   AND shb01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'E'   #採購入庫(apmt720)
         LET g_sql = "SELECT rvv02,rvv31,rvv031,ima021,'','','',rvv17,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,rvv_file ",
                     " WHERE ima01 = rvv31 ",
                     "   AND rvv01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'F'   #採購單(apmt540)
         LET g_sql = "SELECT pmn02,pmn04,pmn041,ima021,'','','',pmn20,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,pmn_file ",
                     " WHERE ima01 = pmn04 ",
                     "   AND pmn01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'G'   #委外採購單(apmt590)
         LET g_sql = "SELECT pmn02,pmn04,pmn041,ima021,'','','',pmn20,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,pmn_file ",
                     " WHERE ima01 = pmn04 ",
                     "   AND pmn01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'I'   #倉庫雜項收料(aimt302)
         LET g_sql = "SELECT inb03,inb04,ima02,ima021,'','','',inb09,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,inb_file ",
                     " WHERE ima01 = inb04 ",
                     "   AND inb01 = '",g_no,"'" 
                     #"   AND ima932 = '",g_point,"'"  #雜收不限定時機點
      WHEN 'K'   #採購收貨作業(apmt110)
         LET g_sql = "SELECT rvb02,rvb05,rvb051,ima021,'','','',rvb07,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,rvb_file ",
                     " WHERE ima01 = rvb05 ",
                     "   AND rvb01 = '",g_no,"'",
                     "   AND ima932 = '",g_point,"'"
      WHEN 'L'   #IQC品質記錄維護作業(aqct110)
         LET g_sql = "SELECT '',qcs021,ima02,ima021,'','','',qcs091,",
                     "       ima918,ima919,ima920,",
                     "       ima921,ima922,ima923 ",
                     "  FROM ima_file,qcs_file ",
                     " WHERE ima01 = qcs021 ",
                     "   AND qcs01 = '",g_no,"'",
                     "   AND qcs02 = '",g_ln,"'",
                     "   AND gcs05 = '",g_seq,"'",
                     "   AND ima932 = '",g_point,"'"
      OTHERWISE 
         EXIT CASE  
   END CASE 
   
   IF cl_null(g_sql) THEN RETURN END IF 

   LET g_sql = g_sql CLIPPED,
               "   AND ima930 = 'Y' ",
               "   AND (ima918 = 'Y' OR ima921 = 'Y') ",
               "   AND ((ima918 = 'Y' AND ima919 = 'N') OR ",
               "        (ima921 = 'Y' AND ima922 = 'N'))"
   PREPARE s_diy_b_pre FROM g_sql
   DECLARE s_diy_b_cs CURSOR FOR s_diy_b_pre

   #TSD.sophy add ==============(S)
   IF cl_null(g_seq) THEN LET g_seq = 0 END IF 
   LET g_sql = "SELECT iba01 FROM iba_file,ibb_file ", 
               " WHERE iba01 = ibb01 ",
               "   AND ibb02 = '",g_point,"'",
               "   AND ibb03 = '",g_no,"'",
               "   AND ibb04 = ? ",
               "   AND ibb13 = ",g_seq,
               "   AND iba02 = ? ",
               " ORDER BY iba01"
   DECLARE iba_cs SCROLL CURSOR FROM g_sql
   #TSD.sophy add ==============(E)
   
   FOREACH s_diy_b_cs INTO g_diy[g_cnt].*
      IF SQLCA.SQLCODE THEN 
         LET g_complete = 'N' 
         CALL cl_err('foreach s_diy_b_cs:',SQLCA.SQLCODE,1)        
         EXIT FOREACH  
      END IF 

      LET g_barcode_ln = g_diy[g_cnt].ln
      
      IF cl_null(g_diy[g_cnt].ima918) THEN LET g_diy[g_cnt].ima918 = 'N' END IF 
      IF cl_null(g_diy[g_cnt].ima919) THEN LET g_diy[g_cnt].ima919 = 'N' END IF 
      IF cl_null(g_diy[g_cnt].ima921) THEN LET g_diy[g_cnt].ima921 = 'N' END IF 
      IF cl_null(g_diy[g_cnt].ima922) THEN LET g_diy[g_cnt].ima922 = 'N' END IF 
      
      LET l_geh04_1 = ''
      SELECT geh04 INTO l_geh04_1 FROM geh_file,gei_file
       WHERE geh01 = gei03 AND gei01 = g_diy[g_cnt].ima920
      
      LET l_geh04_2 = ''
      SELECT geh04 INTO l_geh04_2 FROM geh_file,gei_file
       WHERE geh01 = gei03 AND gei01 = g_diy[g_cnt].ima923
      
     #IF g_diy[g_cnt].ima918 = 'Y' AND g_diy[g_cnt].ima919 = 'Y' THEN 
     #   CALL s_auno(g_diy[g_cnt].ima920,l_geh04_1,g_diy[g_cnt].ima01)
     #      RETURNING g_diy[g_cnt].lot,l_desc
     #END IF 
     # 
     #IF g_diy[g_cnt].ima921 = 'Y' AND g_diy[g_cnt].ima922 = 'Y' THEN 
     #   CALL s_auno(g_diy[g_cnt].ima923,l_geh04_2,g_diy[g_cnt].ima01)
     #      RETURNING g_diy[g_cnt].seq,l_desc
     #END IF 
     
      #TSD.sophy add ===========(s)
      LET l_qty = g_diy[g_cnt].qty
      IF g_diy[g_cnt].ima918 = 'Y' AND g_diy[g_cnt].ima919 = 'Y' THEN 
         LET g_tmp[g_cnt].ln = g_diy[g_cnt].ln
         LET g_tmp[g_cnt].exist = 'N' 
         LET l_iba01 = NULL
         OPEN iba_cs USING g_diy[g_cnt].ln,l_geh04_1
         FETCH FIRST iba_cs INTO l_iba01 
         IF NOT cl_null(l_iba01) THEN  
            LET g_tmp[g_cnt].lot = l_iba01
            LET g_tmp[g_cnt].exist = 'Y' 
         ELSE
            CALL s_auno(g_diy[g_cnt].ima920,l_geh04_1,g_diy[g_cnt].ima01)
               RETURNING g_tmp[g_cnt].lot,l_desc
         END IF 
         LET g_diy[g_cnt].lot = g_tmp[g_cnt].lot
      END IF  
      
      IF g_diy[g_cnt].ima921 = 'Y' AND g_diy[g_cnt].ima922 = 'Y' THEN 
         LET g_tmp[g_cnt].ln = g_diy[g_cnt].ln
         LET g_tmp[g_cnt].exist = 'N' 
         FOR l_i=1 TO l_qty 
            LET l_iba01 = NULL
            OPEN iba_cs USING g_diy[g_cnt].ln,l_geh04_2
            FETCH ABSOLUTE l_i iba_cs INTO l_iba01 
            IF NOT cl_null(l_iba01) THEN  
               LET g_tmp[g_cnt].seq[l_i] = l_iba01
               LET g_tmp[g_cnt].exist = 'Y' 
            ELSE 
               CALL s_auno(g_diy[g_cnt].ima923,l_geh04_2,g_diy[g_cnt].ima01)
                  RETURNING g_tmp[g_cnt].seq[l_i],l_desc
            END IF 
            CASE  
               WHEN l_i=1   
                  LET g_diy[g_cnt].seq = g_tmp[g_cnt].seq[l_i]
               WHEN l_i=l_qty   
                  LET g_diy[g_cnt].end_seq = g_tmp[g_cnt].seq[l_i]
            END CASE 
         END FOR
      END IF 
      #TSD.sophy add ===========(E)
      
      LET g_cnt = g_cnt + 1
   END FOREACH  

   CALL g_diy.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1 
   LET g_cnt = 0 
   LET l_ac = 1

   DISPLAY ARRAY g_diy TO s_diy.* 
      BEFORE DISPLAY 
         EXIT DISPLAY  
   END DISPLAY
END FUNCTION 
   
FUNCTION s_diy_barcode_b()
DEFINE l_exit_sw     LIKE type_file.chr1
DEFINE l_seq_str     LIKE type_file.chr30
DEFINE l_seq_num     LIKE type_file.chr30
DEFINE l_endnum_str  LIKE type_file.chr30
DEFINE l_flag        LIKE type_file.num5
DEFINE l_i           LIKE type_file.num5

   WHILE TRUE 
      CALL cl_set_comp_visible("ln",NOT cl_null(g_diy[l_ac].ln))
      
      LET l_exit_sw = 'Y'
      
      INPUT ARRAY g_diy WITHOUT DEFAULTS FROM s_diy.* 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

         BEFORE INPUT 
            IF g_rec_b <> 0 THEN 
               CALL fgl_set_arr_curr(l_ac)
            END IF  
            
         BEFORE ROW 
            LET l_ac = ARR_CURR()
            CALL s_diy_barcode_set_entry()
            CALL s_diy_barcode_set_no_entry()
            CALL s_diy_barcode_set_no_required()
            CALL s_diy_barcode_set_required()

         AFTER FIELD lot 
            IF NOT cl_null(g_diy[l_ac].lot) THEN 
               IF NOT cl_null(g_diy[l_ac].seq) THEN 
                  CALL s_diy_barcode_chk_seq(l_ac,'Y') 
                     RETURNING l_flag,l_seq_str,l_seq_num,l_endnum_str
                  IF NOT l_flag THEN 
                     NEXT FIELD seq
                  END IF 
               END IF 
               #DEV-D30046 --add--str
               IF NOT s_diy_barcode_chk_code(l_ac) THEN 
                  NEXT FIELD lot
               END IF  
               #DEV-D30046 --add--end
            END IF 
            
         AFTER FIELD seq
            IF NOT cl_null(g_diy[l_ac].seq) THEN 
               CALL s_diy_barcode_chk_seq(l_ac,'Y') 
                  RETURNING l_flag,l_seq_str,l_seq_num,l_endnum_str
               IF NOT l_flag THEN 
                  NEXT FIELD seq
               END IF 
               #DEV-D30046 --add--str
               IF NOT s_diy_barcode_chk_code(l_ac) THEN 
                  NEXT FIELD seq
               END IF  
               #DEV-D30046 --add--end
            END IF 
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()   
      END INPUT 

      IF INT_FLAG THEN 
         EXIT WHILE  
      END IF  

      #檢查單身是否還有未輸入的批序號資料 
      FOR l_i=1 TO g_rec_b
         IF g_diy[l_i].ima918 = 'Y' AND g_diy[l_i].ima919 = 'N' THEN 
            IF cl_null(g_diy[l_i].lot) THEN 
               LET l_ac = l_i
               LET l_exit_sw = 'N'
               EXIT FOR 
            END IF 
         END IF 
         IF g_diy[l_i].ima921 = 'Y' AND g_diy[l_i].ima922 = 'N' THEN 
            IF cl_null(g_diy[l_i].seq) THEN 
               LET l_ac = l_i
               LET l_exit_sw = 'N'
               EXIT FOR 
            END IF 
         END IF 
      END FOR 
      
      IF l_exit_sw = 'Y' THEN 
         EXIT WHILE 
      ELSE 
         CONTINUE WHILE 
      END IF
   END WHILE 
END FUNCTION 

FUNCTION s_diy_barcode_chk_seq(p_li,p_err_show)
DEFINE p_li          LIKE type_file.num5
DEFINE p_err_show    LIKE type_file.chr1
DEFINE l_str         STRING 
DEFINE l_cnt         LIKE type_file.num10
DEFINE l_seq_str     LIKE type_file.chr30  #序號固定值字串
DEFINE l_seq_num     LIKE type_file.chr30  #序號流水號字串
DEFINE l_i           LIKE type_file.num10
DEFINE l_j           LIKE type_file.num10
DEFINE l_num_len     LIKE type_file.num10 
DEFINE l_num_len2    LIKE type_file.num10 
DEFINE l_num         LIKE type_file.num20
DEFINE l_num_str     LIKE type_file.chr30
DEFINE l_seqstr_end  LIKE type_file.num5
DEFINE l_endnum_str  LIKE type_file.chr30 
DEFINE l_len         LIKE type_file.num5
DEFINE l_zero_str    LIKE type_file.chr30

   LET l_str = g_diy[p_li].seq
   LET l_str = l_str.trim()
   LET l_cnt = l_str.getLength()

   LET l_seq_str = NULL
   LET l_seq_num = NULL
   LET l_num_str = NULL
   LET l_endnum_str = NULL

   ##先找出數字起點
   #FOR l_i=1 TO l_cnt
   #   IF l_str.getCharAt(l_i) MATCHES '[0-9]' THEN 
   #      EXIT FOR
   #   ELSE 
   #      LET l_seq_str = l_seq_str CLIPPED,l_str.getCharAt(l_i) 
   #   END IF 
   #END FOR 
   #
   ##檢查數字字串中是否含非數字的字元
   #FOR l_j=l_i TO l_cnt
   #   IF l_str.getCharAt(l_j) MATCHES '[0-9]' THEN 
   #      LET l_seq_num = l_seq_num CLIPPED,l_str.getCharAt(l_j) 
   #   ELSE 
   #      CALL cl_err('','aba-172',0)
   #      RETURN FALSE,l_seq_str,l_seq_num,l_endnum_str  
   #   END IF 
   #END FOR

   #找出固定值的結束點
   FOR l_i=l_cnt TO 1 STEP -1
      IF l_str.getCharAt(l_i) NOT MATCHES '[0-9]' THEN
         LET l_seqstr_end = l_i
         EXIT FOR
      END IF
   END FOR

   #固定值部分
   FOR l_i=1 TO l_seqstr_end
      LET l_seq_str = l_seq_str CLIPPED,l_str.getCharAt(l_i)
   END FOR
   
   #流水號部分
   FOR l_i=l_seqstr_end+1 TO l_cnt
      LET l_seq_num = l_seq_num CLIPPED,l_str.getCharAt(l_i)
   END FOR
   IF cl_null(l_seq_num) THEN 
      IF p_err_show = 'Y' THEN 
         CALL cl_err('','aba-172',0)
      END IF 
      RETURN FALSE,l_seq_str,l_seq_num,l_endnum_str  
   END IF 

   #檢查流水號碼數是否充足
   LET l_num_len = LENGTH(l_seq_num)
   LET l_num = l_seq_num + g_diy[p_li].qty - 1
   LET l_num_str = l_num
   LET l_num_len2 = LENGTH(l_num_str)

   IF l_num_len2 > l_num_len THEN 
      IF p_err_show = 'Y' THEN 
         CALL cl_err('','aba-173',0)
      END IF 
      RETURN FALSE,l_seq_str,l_seq_num,l_endnum_str  
   END IF  
   
   LET l_zero_str = NULL
   LET l_len = l_num_len - l_num_len2
   IF l_len > 0 THEN 
      FOR l_i=1 TO l_len
         LET l_zero_str = l_zero_str CLIPPED,'0'
      END FOR
   END IF 
   LET l_endnum_str = l_zero_str CLIPPED,l_num_str CLIPPED
   
   LET g_diy[p_li].end_seq = l_seq_str,l_endnum_str
   
   #檢查序號與目前畫面已輸入的序號資料是否有重情形
   FOR l_i=1 TO g_rec_b
      IF NOT cl_null(g_diy[l_i].seq) AND l_i <> p_li THEN 
         IF g_diy[p_li].seq >= g_diy[l_i].seq AND 
            g_diy[p_li].seq <= g_diy[l_i].end_seq THEN 
            
            CALL cl_err(g_diy[p_li].end_seq,'aoo-279',0)
            RETURN FALSE,l_seq_str,l_seq_num,l_endnum_str  
         END IF  
      END IF 
   END FOR 
   
   RETURN TRUE,l_seq_str,l_seq_num,l_endnum_str  
END FUNCTION 
#DEV-D30046 --add--str
FUNCTION s_diy_barcode_chk_code(p_li)
DEFINE p_li          LIKE type_file.num5
DEFINE l_seq_str     LIKE type_file.chr30
DEFINE l_seq_num     LIKE type_file.chr30
DEFINE l_endnum_str  LIKE type_file.chr30 
DEFINE l_flag        LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num10
DEFINE l_str         STRING 
DEFINE l_i           LIKE type_file.num5
DEFINE l_len         LIKE type_file.num5
DEFINE l_num_len     LIKE type_file.num5
DEFINE l_code_min    LIKE iba_file.iba01   #以目前批序號組成之條碼起始值
DEFINE l_code_max    LIKE iba_file.iba01   #以目前批序號組成之條碼截止值
DEFINE l_code1       LIKE iba_file.iba01
DEFINE l_code2       LIKE iba_file.iba01

      
   IF g_diy[p_li].ima918 = 'Y' THEN 
      IF cl_null(g_diy[p_li].lot) THEN 
         RETURN TRUE 
      END IF 
   END IF 
   IF g_diy[p_li].ima921 = 'Y' THEN 
      IF cl_null(g_diy[p_li].seq) THEN 
         RETURN TRUE 
      END IF 
   END IF  
   
   CALL s_diy_barcode_chk_seq(p_li,'N') 
      RETURNING l_flag,l_seq_str,l_seq_num,l_endnum_str
   
   LET l_str = l_seq_str CLIPPED,l_seq_num CLIPPED  #起始序號
   LET l_i = l_str.getIndexOf(l_seq_num,1)  #流水號起始位置
   LET l_len = l_str.getLength()
   LET l_num_len = LENGTH(l_seq_num)
   
   #檢查組成的條碼是否會與目前已存在的條碼重複
   LET l_cnt = 0 
   LET l_code_min = NULL
   LET l_code_max = NULL
   LET l_code1 = NULL
   LET l_code2 = NULL
   CASE 
      #批序號管理
      WHEN g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' 
         CASE
            #批號自動編碼、序號手動編碼
            WHEN g_diy[p_li].ima919 = 'Y' AND g_diy[p_li].ima922 = 'N'  
               LET l_code_min = "Z",g_diy[p_li].lot CLIPPED,
                                "Y",l_seq_str CLIPPED,l_seq_num CLIPPED
               LET l_code_max = "Z",g_diy[p_li].lot CLIPPED,
                                "Y",l_seq_str CLIPPED,l_endnum_str CLIPPED
            #批號手動編碼、序號自動編碼
            WHEN g_diy[p_li].ima919 = 'N' AND g_diy[p_li].ima922 = 'Y'  
               LET l_code_min = "Z","X",g_diy[p_li].lot CLIPPED,
                                g_diy[p_li].seq CLIPPED
               LET l_code_max = "Z","X",g_diy[p_li].lot CLIPPED,
                                g_diy[p_li].end_seq CLIPPED
            #批序號手動編碼
            WHEN g_diy[p_li].ima919 = 'N' AND g_diy[p_li].ima922 = 'N'  
               LET l_code_min = "Z","X",g_diy[p_li].lot CLIPPED,
                                "Y",l_seq_str CLIPPED,l_seq_num CLIPPED
               LET l_code_max = "Z","X",g_diy[p_li].lot CLIPPED,
                                "Y",l_seq_str CLIPPED,l_endnum_str CLIPPED
         END CASE 
         SELECT COUNT(*),MIN(ibb01),MAX(ibb01) INTO l_cnt,l_code1,l_code2  
           FROM ibb_file
          WHERE ibb01 BETWEEN l_code_min AND l_code_max
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
         IF l_cnt > 0 THEN 
            CALL cl_err_msg("","aba-174",l_code_min||"|"||l_code_max||"|"||l_code1||"|"||l_code2,0)
            RETURN FALSE
         END IF    
      #批號管理
      WHEN g_diy[p_li].ima918 = 'Y' 
         LET l_code_min = "X",g_diy[p_li].lot CLIPPED
         LET l_code_max = "X",g_diy[p_li].lot CLIPPED
         SELECT COUNT(*),MIN(ibb01),MAX(ibb01) INTO l_cnt,l_code1,l_code2  
           FROM ibb_file
          WHERE ibb01 BETWEEN l_code_min AND l_code_max
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
         IF l_cnt > 0 THEN 
            CALL cl_err_msg("","aba-175",l_code_min||"|"||l_code1,0)
            RETURN FALSE
         END IF    
      #序號管理
      WHEN g_diy[p_li].ima921 = 'Y' 
         LET l_code_min = "Y",l_seq_str CLIPPED,l_seq_num CLIPPED
         LET l_code_max = "Y",l_seq_str CLIPPED,l_endnum_str CLIPPED
         SELECT COUNT(*),MIN(ibb01),MAX(ibb01) INTO l_cnt,l_code1,l_code2  
           FROM ibb_file
          WHERE ibb01 BETWEEN l_code_min AND l_code_max
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
         IF l_cnt > 0 THEN 
            CALL cl_err_msg("","aba-176",l_code_min||"|"||l_code_max||"|"||l_code1||"|"||l_code2,0)
            RETURN FALSE
         END IF    
   END CASE 
   
   RETURN TRUE 
END FUNCTION 
#DEV-D30046 --add--end

FUNCTION s_diy_barcode_set_entry()
   CALL cl_set_comp_entry("lot",TRUE)
   CALL cl_set_comp_entry("seq",TRUE)
END FUNCTION 

FUNCTION s_diy_barcode_set_no_entry()
   IF g_diy[l_ac].ima918 = 'N' THEN 
      CALL cl_set_comp_entry("lot",FALSE)
   ELSE 
      IF g_diy[l_ac].ima919 = 'Y' THEN 
         CALL cl_set_comp_entry("lot",FALSE)
      END IF 
   END IF 
   IF g_diy[l_ac].ima921 = 'N' THEN 
      CALL cl_set_comp_entry("seq",FALSE)
   ELSE 
      IF g_diy[l_ac].ima922 = 'Y' THEN 
         CALL cl_set_comp_entry("seq",FALSE)
      END IF 
   END IF 
END FUNCTION 

FUNCTION s_diy_barcode_set_no_required()
   CALL cl_set_comp_required("lot",FALSE)
   CALL cl_set_comp_required("seq",FALSE)
END FUNCTION 

FUNCTION s_diy_barcode_set_required()
   IF g_diy[l_ac].ima918 = 'Y' THEN 
      IF g_diy[l_ac].ima919 = 'N' THEN 
         CALL cl_set_comp_required("lot",TRUE)
      END IF 
   END IF 
   IF g_diy[l_ac].ima921 = 'Y' THEN 
      IF g_diy[l_ac].ima922 = 'N' THEN 
         CALL cl_set_comp_required("seq",TRUE)
      END IF 
   END IF 
END FUNCTION 

FUNCTION s_diy_barcode_gen_data(p_li)
DEFINE p_li       LIKE type_file.num5
DEFINE l_i        LIKE type_file.num10
DEFINE l_geh04_1  LIKE geh_file.geh04
DEFINE l_geh04_2  LIKE geh_file.geh04

   LET l_geh04_1 = ''
   SELECT geh04 INTO l_geh04_1 FROM geh_file,gei_file
    WHERE geh01 = gei03 AND gei01 = g_diy[p_li].ima920
   IF g_diy[p_li].ima919 = 'N' THEN 
      LET l_geh04_1 = 'X' 
   END IF 
   
   LET l_geh04_2 = ''
   SELECT geh04 INTO l_geh04_2 FROM geh_file,gei_file
    WHERE geh01 = gei03 AND gei01 = g_diy[p_li].ima923
   IF g_diy[p_li].ima922 = 'N' THEN 
      LET l_geh04_2 = 'Y'
   END IF 
   
   #IF cl_null(g_seq) THEN LET g_seq = 0 END IF 
   #LET g_sql = "SELECT iba01 FROM iba_file,ibb_file ", 
   #            " WHERE iba01 = ibb01 ",
   #            "   AND ibb02 = '",g_point,"'",
   #            "   AND ibb03 = '",g_no,"'",
   #            "   AND ibb04 = ? ",
   #            "   AND ibb13 = '",g_seq,"'",
   #            "   AND iba02 = ? ",
   #            " ORDER BY iba01"
   #DECLARE iba_cs SCROLL CURSOR FROM g_sql
   
   CASE 
      WHEN g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y'
         CALL s_diy_barcode_ins_iba(l_geh04_1,p_li,1)
         CALL s_diy_barcode_ins_ibb(l_geh04_1,p_li)
         FOR l_i=1 TO g_diy[p_li].qty
            CALL s_diy_barcode_ins_iba(l_geh04_2,p_li,l_i)
            CALL s_diy_barcode_ins_ibb(l_geh04_2,p_li)
            CALL s_diy_barcode_ins_iba('Z',p_li,l_i)
            CALL s_diy_barcode_ins_ibb('Z',p_li)
         END FOR
      WHEN g_diy[p_li].ima918 = 'Y' 
         CALL s_diy_barcode_ins_iba(l_geh04_1,p_li,1)
         CALL s_diy_barcode_ins_ibb(l_geh04_1,p_li)
      WHEN g_diy[p_li].ima921 = 'Y' 
         FOR l_i=1 TO g_diy[p_li].qty
            CALL s_diy_barcode_ins_iba(l_geh04_2,p_li,l_i)
            CALL s_diy_barcode_ins_ibb(l_geh04_2,p_li)
         END FOR
   END CASE 
END FUNCTION 
   
FUNCTION s_diy_barcode_ins_iba(p_type,p_li,p_qty)
DEFINE p_type        LIKE type_file.chr1
DEFINE p_li          LIKE type_file.num5
DEFINE p_qty         LIKE type_file.num10
DEFINE l_seq_str     LIKE type_file.chr30
DEFINE l_seq_num     LIKE type_file.chr30
DEFINE l_endnum_str  LIKE type_file.chr30
DEFINE l_flag        LIKE type_file.num5
DEFINE l_seqno       LIKE type_file.num20
DEFINE l_seqno_str   LIKE type_file.chr30
DEFINE l_len         LIKE type_file.num5
DEFINE l_i           LIKE type_file.num10
DEFINE l_zero_str    LIKE type_file.chr30
DEFINE l_iba         RECORD LIKE iba_file.*
DEFINE l_desc        LIKE type_file.chr50
DEFINE l_iba01       LIKE iba_file.iba01
   
   LET g_code = NULL
   LET g_code_exist = 'N'
   
   IF p_type NOT MATCHES '[XYZ]' THEN 
      #LET l_iba01 = NULL
      #OPEN iba_cs USING g_diy[p_li].ln,p_type
      #FETCH ABSOLUTE p_qty iba_cs INTO l_iba01 
      #IF NOT cl_null(l_iba01) THEN  
      #   LET g_code_exist = 'Y'
      #   LET g_code = l_iba01 
      #   IF p_type = '6' THEN 
      #      LET g_diy[p_li].seq = l_iba01
      #   ELSE 
      #      LET g_diy[p_li].lot = l_iba01
      #   END IF 
      #ELSE 
      #   CASE p_type
      #      WHEN '5'
      #         CALL s_auno(g_diy[p_li].ima920,p_type,g_diy[p_li].ima01)
      #            RETURNING g_diy[p_li].lot,l_desc
      #         LET g_code = g_diy[p_li].lot
      #      WHEN 'F'
      #         CALL s_auno(g_diy[p_li].ima920,p_type,g_diy[p_li].ima01)
      #            RETURNING g_diy[p_li].lot,l_desc
      #         LET g_code = g_diy[p_li].lot
      #      WHEN 'G'
      #         CALL s_auno(g_diy[p_li].ima920,p_type,g_diy[p_li].ima01)
      #            RETURNING g_diy[p_li].lot,l_desc
      #         LET g_code = g_diy[p_li].lot
      #      WHEN '6'  
      #         CALL s_auno(g_diy[p_li].ima923,p_type,g_diy[p_li].ima01)
      #            RETURNING g_diy[p_li].seq,l_desc
      #         LET g_code = g_diy[p_li].seq
      #   END CASE  
      #END IF 
      IF p_type = '6' THEN 
         LET g_diy[p_li].seq = g_tmp[p_li].seq[p_qty]
         LET g_code_exist = g_tmp[p_li].exist
         LET g_code = g_diy[p_li].seq
      ELSE 
         LET g_diy[p_li].lot = g_tmp[p_li].lot
         LET g_code_exist = g_tmp[p_li].exist
         LET g_code = g_diy[p_li].lot
      END IF 
   ELSE 
      INITIALIZE l_iba.* TO NULL
      
      LET l_iba.iba02 = p_type
      
      CALL s_diy_barcode_chk_seq(p_li,'N') 
         RETURNING l_flag,l_seq_str,l_seq_num,l_endnum_str
      LET l_seqno = l_seq_num + p_qty - 1 
      LET l_seqno_str = l_seqno
      LET l_len = LENGTH(l_seq_num) - LENGTH(l_seqno_str)
      LET l_zero_str = NULL
      IF l_len > 0 THEN 
         FOR l_i=1 TO l_len
            LET l_zero_str = l_zero_str CLIPPED,'0'
         END FOR
      END IF 
      LET l_seqno_str = l_zero_str CLIPPED,l_seqno_str CLIPPED
      
      CASE p_type
         WHEN 'X'
            LET l_iba.iba03 = g_diy[p_li].lot
         WHEN 'Y'
            LET l_iba.iba03 = l_seq_str CLIPPED,l_seqno_str CLIPPED
         WHEN 'Z'
            IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima919 = 'N' THEN 
               LET l_iba.iba03 = 'X',g_diy[p_li].lot
            ELSE 
               LET l_iba.iba03 = g_diy[p_li].lot
            END IF 
            IF g_diy[p_li].ima921 = 'Y' AND g_diy[p_li].ima922 = 'N' THEN 
               LET l_iba.iba04 = 'Y',l_seq_str CLIPPED,l_seqno_str CLIPPED
            ELSE 
               LET l_iba.iba04 = g_diy[p_li].seq
            END IF 
      END CASE 
 
      LET g_code = l_iba.iba02 CLIPPED,l_iba.iba03 CLIPPED,l_iba.iba04 CLIPPED
      
      LET l_iba.iba01 = g_code
 
      INSERT INTO iba_file VALUES (l_iba.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
         #iba_file若已存在則重複塞入 
         IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            IF g_bgerr THEN
               CALL s_errmsg('iba01',l_iba.iba01,'ins iba_file',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","iba_file",l_iba.iba01,"",SQLCA.SQLCODE,"","",1)
            END IF
            LET g_complete = 'N'
            RETURN
         END IF 
      END IF
   END IF 
END FUNCTION 
 
FUNCTION s_diy_barcode_ins_ibb(p_type,p_li)
DEFINE p_type        LIKE type_file.chr1
DEFINE p_li          LIKE type_file.num5
DEFINE l_ibb         RECORD LIKE ibb_file.* 
  
   IF g_code_exist = 'Y' THEN RETURN END IF 
   
   INITIALIZE l_ibb.* TO NULL 
   LET l_ibb.ibb01 = g_code   #編碼 
   LET l_ibb.ibb02 = g_point   
   LET l_ibb.ibb03 = g_no
   LET l_ibb.ibb04 = g_diy[p_li].ln
   IF cl_null(l_ibb.ibb04) THEN LET l_ibb.ibb04 = 0 END IF 
   LET l_ibb.ibb05 = 0
   LET l_ibb.ibb06 = g_diy[p_li].ima01
   LET l_ibb.ibb08 = NULL
   LET l_ibb.ibb09 = NULL
   LET l_ibb.ibb10 = 0
   LET l_ibb.ibb12 = 0
   IF g_point = 'L' THEN 
      LET l_ibb.ibb13 = g_seq 
   ELSE 
      LET l_ibb.ibb13 = 0 
   END IF 
   IF cl_null(l_ibb.ibb13) THEN LET l_ibb.ibb13 = 0 END IF 
   LET l_ibb.ibbacti = 'Y'
   
   CASE p_type
      WHEN '5'
         LET l_ibb.ibb07 = g_diy[p_li].qty
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN 'F'
         LET l_ibb.ibb07 = g_diy[p_li].qty
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN 'G'
         LET l_ibb.ibb07 = g_diy[p_li].qty
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN 'X'
         LET l_ibb.ibb07 = g_diy[p_li].qty
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN '6'
         LET l_ibb.ibb07 = 1
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN 'Y'
         LET l_ibb.ibb07 = 1
         LET l_ibb.ibb11 = 'Y'
         IF g_diy[p_li].ima918 = 'Y' AND g_diy[p_li].ima921 = 'Y' THEN 
            LET l_ibb.ibb11 = 'N'
         END IF   
      WHEN 'Z'
         LET l_ibb.ibb07 = 1
         LET l_ibb.ibb11 = 'Y'
   END CASE
   INSERT INTO ibb_file VALUES(l_ibb.*)	
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ibb01',l_ibb.ibb01,'ins ibb_file',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","ibb_file",l_ibb.ibb01,"",SQLCA.SQLCODE,"","",1)
      END IF
      LET g_complete = 'N'
      RETURN
   END IF
END FUNCTION 
#DEV-D30042--add

