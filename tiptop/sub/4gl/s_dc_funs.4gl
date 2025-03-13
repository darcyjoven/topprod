# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Program name...: s_dc_funs.4gl
# Descriptions...: 資料中心的FUNCTIONS
# Date & Author..: 08/02/19 By Carrier FUN-7C0010 FUN-830085
# Modify.........: FUN-830090 08/03/24 By Carrier -239的錯誤不做收集
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 依gew03共三個選項做開窗狀態判斷
# Modify.........: NO.FUN-840138 08/04/21 BY xiaofeizhu ECN新增bmy14,bmz02的管控
# Modify.........: NO.MOD-880245 08/09/02 BY claire 背景出現訊息卻不影響執行結果
# Modify.........: NO.MOD-8B0051 08/11/06 BY claire 背景出現訊息卻不影響執行結果
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-920098 09/02/12 By alex 新增MSV段function
# Modify.........: No.MOD-950002 09/05/04 By Sarah IFX環境,s_dc_cre_temp_table()建立Temptable語法失敗
# Modify.........: NO.MOD-960112 09/06/19 By Carrier CREATE TEMP TABLE時效率太慢
# Modify.........: NO.FUN-960132 09/07/02 By Kevin 調整成 msv 架構
# Modify.........: NO.MOD-970195 09/07/22 By mike 於料件資料拋轉中若是由手動拋轉設定的話挑選拋轉資料庫部分并無呼叫LINK資料庫替換語法
# Modify.........: NO.FUN-990069 09/10/12 By baofei GP5.2資料中心修改
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No:MOD-980228 09/11/24 By sabrina gew03 = '1' or '2' or '3'時 都要自動抓aooi602設定
# Modify.........: No:CHI-A60011 10/07/27 By Summer 多人同時做拋轉,造成ins gex異常的問題
# Modify.........: No.FUN-A70145 10/07/30 By alex 新增ASE段function
# Modify.........: No.FUN-A80036 10/08/11 By Carrier 临时表改名非固定命名方式
# Modify.........: No.FUN-950057 10/09/02 By vealxu gew03 = '1' or '2' or '3'時 都要自動抓aooi602設定
# Modify.........: No.MOD-AA0179 10/10/27 By Carrier 临时表名命名修改
# Modify.........: No.FUN-AC0038 10/12/21 By Carrier 将临时表l_tabname变成TEMP TABLE
# Modify.........: No:MOD-B50237 11/05/30 By Vampire 將CHI-A60011 Mark 還原
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----str-----
# Modify.........: No.FUN-AC0026 10/12/20 By Mandy PLM-資料中心功能
#                                11/07/05 By Mandy TEMP TABLE的名稱太長原本ex:aws_ttsrv2_ima_1018 改成:aws_ima_1018
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----end-----
# Modify.........: No:TQC-B90071 11/09/08 By jan temp table name長度不能超過18碼
# Modify.........: No:MOD-C90021 12/09/04 By Summer 修正子公司權限控卡 
# Modify.........: No:MOD-D30049 13/03/06 By zhangll 修正gew06、gew07用途

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global" 
GLOBALS "../4gl/s_data_center.global"
 
DEFINE g_sql      STRING
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_gew01    LIKE gew_file.gew01
DEFINE g_gew02    LIKE gew_file.gew02
DEFINE g_cnt      LIKE type_file.num10
DEFINE i          LIKE type_file.num10
 
##################################################
# Descriptions...: 多行的資料內容組合成where子句
# Date & Author..: 07/12/07 By Carrier FUN-7C0010
# Usage..........: CALL s_cond_combine(p_cond)
# Input PARAMETER: p_cond   array contains conditions
# RETURN Code....: l_cond1  real sub where clause 
#                  l_cond2  symbolized where clause
##################################################
FUNCTION s_cond_combine(p_cond)
  DEFINE p_cond              DYNAMIC ARRAY OF RECORD
                             field_no    LIKE gaq_file.gaq01,       #
                             field_name  LIKE gaq_file.gaq03,       #名稱
                             condition   LIKE type_file.chr2,       #
                             value       LIKE ze_file.ze03,         #
                             data_type   LIKE type_file.chr50
                             END RECORD
  DEFINE l_cond1             LIKE type_file.chr1000
  DEFINE l_cond2             LIKE type_file.chr1000
  DEFINE l_i                 LIKE type_file.num5
  DEFINE l_option            LIKE type_file.chr20
  DEFINE l_oa                LIKE type_file.chr3
  DEFINE l_b                 LIKE type_file.chr1
  DEFINE l_e                 LIKE type_file.chr1
  DEFINE l_chr               LIKE type_file.chr1
  DEFINE where_conditions    STRING
  DEFINE conditions_total    base.StringTokenizer
  DEFINE sub_conditions      STRING
 
  LET l_cond1=NULL
  LET l_cond2=NULL
  FOR l_i = 1 TO p_cond.getlength()
      IF NOT cl_null(p_cond[l_i].field_no) THEN
         CALL s_get_option(p_cond[l_i].condition) RETURNING l_option,l_oa,l_b,l_e
 
         #aag24 is numeric, and others are characters
         #IF p_cond[l_i].field_no = 'aag24' THEN LET l_chr =' ' ELSE LET l_chr = "'"  END IF
         IF p_cond[l_i].data_type = '2' THEN LET l_chr =' ' ELSE LET l_chr = "'"  END IF
 
         #symbolized where clause
         #ima01+1+2+a;b;c)ima06+3+01
         IF l_cond2 IS NULL THEN
            LET l_cond2 = p_cond[l_i].field_no CLIPPED,'+',p_cond[l_i].condition CLIPPED,'+',p_cond[l_i].data_type,'+',p_cond[l_i].value CLIPPED
         ELSE
            LET l_cond2 = l_cond2 CLIPPED,')',p_cond[l_i].field_no CLIPPED,'+',p_cond[l_i].condition CLIPPED,'+',p_cond[l_i].data_type,'+',p_cond[l_i].value CLIPPED
         END IF
 
         #where_conditions = "(ima01 <> '1' AND ima01 <> '2' AND ima01 <> '3') AND (ima06>='01')"
         LET where_conditions=NULL
         LET conditions_total = base.StringTokenizer.create(p_cond[l_i].value CLIPPED, ";")
         WHILE conditions_total.hasMoreTokens()
            LET sub_conditions = conditions_total.nextToken()
            IF cl_null(where_conditions) THEN
                                        #ima01>'a'   # aag24>1
               LET where_conditions= "(",p_cond[l_i].field_no CLIPPED," ",l_option CLIPPED," ",l_chr,l_b CLIPPED,sub_conditions.trim(),l_e CLIPPED,l_chr
            ELSE
               LET where_conditions= where_conditions CLIPPED," ",l_oa," ",p_cond[l_i].field_no CLIPPED," ",l_option CLIPPED," ",l_chr,l_b CLIPPED,sub_conditions.trim(),l_e CLIPPED,l_chr
            END IF
         END WHILE
         LET where_conditions=where_conditions CLIPPED,')'
 
         #where clause
         IF l_cond1 IS NULL THEN
            LET l_cond1 = where_conditions
         ELSE
            LET l_cond1 = l_cond1 CLIPPED," AND ",where_conditions.trim()
         END IF
      END IF
  END FOR
  IF cl_null(l_cond1) THEN LET l_cond1 = " 1=1" END IF
  RETURN l_cond1,l_cond2
END FUNCTION
 
##################################################
# Descriptions...: 資料中心下載時路徑選擇
# Date & Author..: 08/01/30 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_download_path()
# RETURN Code....: l_path   回傳下載的路徑
##################################################
FUNCTION s_dc_download_path()
 
   DEFINE l_path       LIKE ze_file.ze03
 
   OPEN WINDOW s_dc_download_path_w WITH FORM "sub/42f/s_dc_download_path"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("s_dc_download_path")
 
   LET l_path = "C:/TIPTOP"
   DISPLAY l_path TO FORMONLY.path
 
   INPUT l_path WITHOUT DEFAULTS FROM FORMONLY.path
 
       AFTER FIELD path
          IF cl_null(l_path) THEN
             NEXT FIELD path
          END IF
 
       ON ACTION browse
          LET l_path = cl_browse_dir()
          IF cl_null(l_path) THEN
             LET l_path = "C:/TIPTOP"
          END IF
          DISPLAY l_path TO FORMONLY.path
          NEXT FIELD path
 
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       CLOSE WINDOW s_dc_download_path_w
       RETURN NULL
    END IF
 
    CLOSE WINDOW s_dc_download_path_w
    RETURN l_path
 
END FUNCTION
 
##################################################
# Descriptions...: 資料中心拋轉時DB選擇作業
# Date & Author..: 08/01/30 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_sel_db(p_gew01,p_gew02)
# Input PARAMETER: p_gew01  資料中心
#                  p_gew02  資料類型
##################################################
FUNCTION s_dc_sel_db(p_gew01,p_gew02)  #No.FUN-830090
   DEFINE p_gew01              LIKE gew_file.gew01
   DEFINE p_gew02              LIKE gew_file.gew02
   DEFINE l_gew03              LIKE gew_file.gew03
   DEFINE l_gev04              LIKE gev_file.gev04
   DEFINE l_geu02              LIKE geu_file.geu02
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_gew01 = p_gew01
   LET g_gew02 = p_gew02
 
   CALL g_azp.clear()
   LET g_rec_dc = 0
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
     WHERE gew01 = g_gew01 AND gew02 = g_gew02
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode = -284 THEN
          LET l_gew03 = 'N'
       END IF
    END IF
    #IF l_gew03 = 'Y' THEN
    IF l_gew03 = '1' OR l_gew03 = '2' OR l_gew03 = '3'THEN    #NO.FUN-840033 mod  #MOD-980228 add l_gew03='3'
       DECLARE s_dc_sel_azp CURSOR FOR
        SELECT 'Y',gew04,azp02,azp03 FROM gew_file,OUTER azp_file
         WHERE gew01 = g_gew01
           AND gew02 = g_gew02
           AND gew_file.gew04 = azp_file.azp01
           AND gew04 <> g_plant
       LET g_cnt = 1
       FOREACH s_dc_sel_azp INTO g_azp[g_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET g_cnt = g_cnt + 1
       END FOREACH
       CALL g_azp.deleteElement(g_cnt)
       LET g_rec_dc = g_cnt - 1
    END IF
 
    IF l_gew03 = '3' THEN    #NO.FUN-840033 add   #MOD-980228 del l_gew03='2'
       OPEN WINDOW s_dc_1_w WITH FORM "sub/42f/s_dc_sel_db"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
       CALL cl_ui_locale("s_dc_sel_db")
 
        SELECT gev04 INTO l_gev04 FROM gev_file
         WHERE gev01 = p_gew02 AND gev02 = g_plant
        SELECT geu02 INTO l_geu02 FROM geu_file
         WHERE geu01 = l_gev04
        DISPLAY l_gev04 TO FORMONLY.gev04
        DISPLAY l_geu02 TO FORMONLY.geu02
 
        CALL s_check_gev04(l_gev04,p_gew02)
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(l_gev04,g_errno,1)
           CLOSE WINDOW s_dc_1_w
           RETURN
        END IF
 
        DISPLAY ARRAY g_azp TO s_azp.* ATTRIBUTE(COUNT=g_rec_dc,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY
 
        CALL cl_set_act_visible("accept", TRUE)
        INPUT ARRAY g_azp WITHOUT DEFAULTS FROM s_azp.*
              ATTRIBUTE(COUNT=g_rec_dc,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
           BEFORE INPUT
              IF g_rec_dc!=0 THEN
                 CALL fgl_set_arr_curr(i)
              END IF
 
           BEFORE ROW
              LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
 
           BEFORE INSERT
              LET g_azp[i].sel = 'N'
 
           AFTER FIELD azp01
              IF NOT cl_null(g_azp[i].azp01) THEN
                 CALL s_dc_sel_db_azp01()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_azp[i].azp01,g_errno,0)
                    NEXT FIELD azp01
                 END IF
              ELSE
                 LET g_azp[i].azp02 = NULL
                 LET g_azp[i].azp03 = NULL
              END IF
 
           AFTER ROW
              LET i = ARR_CURR()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(azp01)        #azp_file
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gew04"
                      LET g_qryparam.arg1     = g_gew01
                      LET g_qryparam.arg2     = g_gew02
                      LET g_qryparam.where    = " gew04 <> '",g_plant,"'"
                      LET g_qryparam.default1 = g_azp[i].azp01
                      CALL cl_create_qry() RETURNING g_azp[i].azp01
                      CALL s_dc_sel_db_azp01()
                      NEXT FIELD azp01
              END CASE
 
           ON ACTION select_all
              CALL s_dc_sel_all("Y")
 
           ON ACTION select_non
              CALL s_dc_sel_all("N")
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
        END INPUT
        IF INT_FLAG THEN
           CLOSE WINDOW s_dc_1_w
           RETURN
        END IF
        LET g_rec_dc = g_azp.getLength()
        CLOSE WINDOW s_dc_1_w
    END IF                      #NO.FUN-840033 add
 
END FUNCTION
 
FUNCTION s_dc_sel_all(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_azp.getLength()
       LET g_azp[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION s_dc_sel_all1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_azp1.getLength()
       LET g_azp1[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION s_dc_sel_db_azp01()
    DEFINE l_azp02   LIKE azp_file.azp02
    DEFINE l_azp03   LIKE azp_file.azp03
    DEFINE l_gew04   LIKE gew_file.gew04
    DEFINE l_i       LIKE type_file.num10
 
    LET g_errno = ' '
    SELECT azp02,azp03 INTO l_azp02,l_azp03
      FROM azp_file WHERE azp01=g_azp[i].azp01
    CASE
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF cl_null(g_errno) THEN
       SELECT gew04 INTO l_gew04 FROM gew_file
        WHERE gew01 = g_gew01
          AND gew02 = g_gew02
          AND gew04 = g_azp[i].azp01
       CASE
           WHEN STATUS=100        LET g_errno = 'aoo-034'
           WHEN l_gew04 = g_plant LET g_errno = 'aoo-035'
           OTHERWISE              LET g_errno = SQLCA.sqlcode USING'-------'
       END CASE
    END IF
    #相同的DB不要能KEY多次
    IF cl_null(g_errno) THEN
       FOR l_i = 1 TO g_azp.getLength()
           IF l_i = i THEN
              CONTINUE FOR
           END IF
           IF g_azp[i].azp01 = g_azp[l_i].azp01 THEN
              LET g_errno = '-239'
           END IF
       END FOR
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_azp03 = NULL
       LET l_azp02 = NULL
    END IF
    IF cl_null(g_errno) THEN
       LET g_azp[i].azp02 = l_azp02
       LET g_azp[i].azp03 = l_azp03
    END IF
 
END FUNCTION
 
FUNCTION s_dc_sel_db_azp01_1()
    DEFINE l_azp02   LIKE azp_file.azp02
    DEFINE l_azp03   LIKE azp_file.azp03
    DEFINE l_gew04   LIKE gew_file.gew04
    DEFINE l_i       LIKE type_file.num10
 
    LET g_errno = ' '
    SELECT azp02,azp03 INTO l_azp02,l_azp03
      FROM azp_file WHERE azp01=g_azp1[i].azp01
    CASE
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF cl_null(g_errno) THEN
       SELECT gew04 INTO l_gew04 FROM gew_file
        WHERE gew01 = g_gew01
          AND gew02 = g_gew02
          AND gew04 = g_azp1[i].azp01
       CASE
           WHEN STATUS=100        LET g_errno = 'aoo-034'
           WHEN l_gew04 = g_plant LET g_errno = 'aoo-035'
           OTHERWISE              LET g_errno = SQLCA.sqlcode USING'-------'
       END CASE
    END IF
    #相同的DB不要能KEY多次
    IF cl_null(g_errno) THEN
       FOR l_i = 1 TO g_azp1.getLength()
           IF l_i = i THEN
              CONTINUE FOR
           END IF
           IF g_azp1[i].azp01 = g_azp1[l_i].azp01 THEN
              LET g_errno = '-239'
           END IF
       END FOR
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_azp03 = NULL
       LET l_azp02 = NULL
    END IF
    IF cl_null(g_errno) THEN
       LET g_azp1[i].azp02 = l_azp02
       LET g_azp1[i].azp03 = l_azp03
    END IF
 
END FUNCTION
 
##################################################
# Descriptions...: 資料中心拋轉時DB選擇作業
# Date & Author..: 08/01/30 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_sel_db1(p_gew01,p_gew02,p_sql)
# Input PARAMETER: p_gew01  資料中心
#                  p_gew02  資料類型
#                  p_sql    查詢資料的sql語句
##################################################
FUNCTION s_dc_sel_db1(p_gew01,p_gew02,p_sql)
   DEFINE p_gew01    LIKE gew_file.gew01
   DEFINE p_gew02    LIKE gew_file.gew02
   DEFINE p_sql      STRING                   #NO.FUN-910082
   DEFINE l_gew03    LIKE gew_file.gew03
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_dbs_sep  LIKE type_file.chr50
   DEFINE l_gev04    LIKE gev_file.gev04
   DEFINE l_geu02    LIKE geu_file.geu02
   DEFINE l_n        LIKE type_file.num5  #FUN-990069
   DEFINE l_azw01    LIKE azw_file.azw01  #FUN-990069 
   DEFINE l_azw06    LIKE azw_file.azw06  #FUN-990069 
   DEFINE l_str      STRING               #FUN-990069   
 
   WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_gew01 = p_gew01
    LET g_gew02 = p_gew02
 
    CALL g_azp1.clear()
    LET g_rec_dc = 0
 
    SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
     WHERE gew01 = g_gew01 AND gew02 = g_gew02
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode = -284 THEN
          LET l_gew03 = 'N'
       END IF
    END IF
 
    #IF l_gew03 = 'Y' THEN
   #IF l_gew03 = '1' OR l_gew03 = '2' THEN    #NO.FUN-840033 mod      #FUN-950057 mark
    IF l_gew03 = '1' OR l_gew03 = '2' OR l_gew03 = '3' THEN           #FUN-950057 add
       DECLARE s_dc_sel_azp1 CURSOR FOR
#        SELECT 'Y',gew04,azp02,azp03,'N' FROM gew_file,OUTER azp_file   #FUN-990069
        SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,OUTER azp_file   #FUN-990069   
         WHERE gew01 = g_gew01
           AND gew02 = g_gew02
           AND gew_file.gew04 = azp_file.azp01
           AND gew04 <> g_plant
 
       LET g_cnt = 1
       FOREACH s_dc_sel_azp1 INTO g_azp1[g_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          CALL s_dbstring(g_azp1[g_cnt].azp03) RETURNING l_dbs_sep
          LET g_sql = cl_replace_str(p_sql,"&",l_dbs_sep)
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql #MOD-970195     
          PREPARE exist_p1 FROM g_sql
          EXECUTE exist_p1 INTO l_cnt
          IF l_cnt > 0 THEN
             LET g_azp1[g_cnt].exist = 'Y'
          ELSE
             LET g_azp1[g_cnt].exist = 'N'
          END IF
#FUN-990069---BEGIN                                                                                                                 
          LET l_azw06 = NULL                                                                                                 
          LET l_azw01 = NULL                                                                                                 
          LET l_str = ''                                                                                                     
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_azp1[g_cnt].azp01                                               
          DECLARE s_dc_db1  CURSOR  FOR                                                                                      
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                           
          FOREACH s_dc_db1  INTO l_azw01                                                                                     
            IF STATUS THEN                                                                                                   
               CALL cl_err('foreach:',STATUS,1)                                                                              
               EXIT FOREACH                                                                                                  
            END IF                                                                                                           
            IF l_azw01 = g_azp1[g_cnt].azp01 THEN                                                                                 
               LET l_azw01 = NULL                                                                                            
               CONTINUE FOREACH                                                                                              
            END IF                                                                                                           
            IF cl_null(l_str)  THEN                                                                                               
               LET l_str = l_azw01                                                                                           
            ELSE                                                                                                             
               LET l_str = l_str,",",l_azw01                                                                                 
            END IF     
          END FOREACH               
          LET g_azp1[g_cnt].plant = l_str                                                                                         
#FUN-990069---END 
          LET g_cnt = g_cnt + 1 
       END FOREACH
       CALL g_azp1.deleteElement(g_cnt)
       LET g_rec_dc = g_cnt - 1
    END IF
  # IF l_gew03 = '2' OR l_gew03 = '3' THEN   #NO.FUN-840033 add    #FUN-950057 mark
    IF l_gew03 = '3' THEN                                          #FUN-950057 add 
        OPEN WINDOW s_dc_1_w1 WITH FORM "sub/42f/s_dc_sel_db1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
        CALL cl_ui_locale("s_dc_sel_db1")
 
        SELECT gev04 INTO l_gev04 FROM gev_file
         WHERE gev01 = p_gew02 AND gev02 = g_plant
        SELECT geu02 INTO l_geu02 FROM geu_file
         WHERE geu01 = l_gev04
        DISPLAY l_gev04 TO FORMONLY.gev04
        DISPLAY l_geu02 TO FORMONLY.geu02
        CALL s_check_gev04(l_gev04,p_gew02)
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(l_gev04,g_errno,1)
           CLOSE WINDOW s_dc_1_w1
           RETURN
        END IF
#FUN-990069---BEGIN            
    LET l_n = 0                                                                                                       
    SELECT COUNT(*) INTO l_n FROM azw_file                                                                                          
     WHERE azw05 <> azw06                                                                                                           
    IF l_n  = 0  THEN                                                                                                              
       CALL cl_set_comp_visible("plant",FALSE)                                                                                
    END IF                                                                                                                          
#FUN-990069---END 
 
        DISPLAY ARRAY g_azp1 TO s_azp.* ATTRIBUTE(COUNT=g_rec_dc,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY
 
        CALL cl_set_act_visible("accept", TRUE)
        INPUT ARRAY g_azp1 WITHOUT DEFAULTS FROM s_azp.*
              ATTRIBUTE(COUNT=g_rec_dc,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
           BEFORE INPUT
              IF g_rec_dc!=0 THEN
                 CALL fgl_set_arr_curr(i)
              END IF
 
           BEFORE ROW
              LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
 
           BEFORE INSERT
              LET g_azp1[i].sel = 'N'
              LET g_azp1[i].exist = 'N'
 
           AFTER FIELD azp01
              IF NOT cl_null(g_azp1[i].azp01) THEN
                 CALL s_dc_sel_db_azp01_1()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_azp1[i].azp01,g_errno,0)
                    NEXT FIELD azp01
                 END IF
                 CALL s_dbstring(g_azp1[i].azp03) RETURNING l_dbs_sep
                 LET g_sql = cl_replace_str(p_sql,"&",l_dbs_sep)
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql #MOD-970195     
                 PREPARE exist_p2 FROM g_sql
                 EXECUTE exist_p2 INTO l_cnt
                 IF l_cnt > 0 THEN
                    LET g_azp1[i].exist = 'Y'
                 ELSE
                    LET g_azp1[i].exist = 'N'
                 END IF
#FUN-990069---BEGIN
                 LET l_azw06 = NULL
                 LET l_azw01 = NULL
                 LET l_str = ''
                 SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_azp1[i].azp01
                 DECLARE s_dc_db2  CURSOR  FOR
                         SELECT azw01 FROM azw_file WHERE azw06 = l_azw06
                 FOREACH s_dc_db2  INTO l_azw01
                   IF STATUS THEN
                      CALL cl_err('foreach:',STATUS,1)
                      EXIT FOREACH
                   END IF
                   IF l_azw01 = g_azp1[i].azp01 THEN 
                      LET l_azw01 = NULL
                      CONTINUE FOREACH
                   END IF 
                   IF cl_null(l_str)  THEN 
                      LET l_str = l_azw01
                   ELSE
                      LET l_str = l_str,",",l_azw01
                   END IF
                 END FOREACH  
                 DISPLAY l_str TO formonly.plant  
#FUN-990069---END
              ELSE
                 LET g_azp1[i].azp02 = NULL
                 LET g_azp1[i].azp03 = NULL
                 DISPLAY '' TO formonly.plant   #FUN-990069
              END IF
 
           AFTER ROW
              LET i = ARR_CURR()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(azp01)        #azp_file
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gew04"
                      LET g_qryparam.arg1     = g_gew01
                      LET g_qryparam.arg2     = g_gew02
                      LET g_qryparam.where    = " gew04 <> '",g_plant,"'"
                      LET g_qryparam.default1 = g_azp1[i].azp01
                      CALL cl_create_qry() RETURNING g_azp1[i].azp01
                      CALL s_dc_sel_db_azp01_1()
                      NEXT FIELD azp01
              END CASE
 
           ON ACTION select_all
              CALL s_dc_sel_all1("Y")
 
           ON ACTION select_non
              CALL s_dc_sel_all1("N")
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
        END INPUT
 
        CLOSE WINDOW s_dc_1_w1
 
        IF INT_FLAG THEN
           RETURN
        END IF
 
        LET g_rec_dc = g_azp1.getLength()
    END IF    #NO.FUN-840033 add
END FUNCTION
 
##################################################
# Descriptions...: 建立data center TABLE (download)
# Date & Author..: 08/02/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_cre_temp_table(p_tabn)
# Input PARAMETER: p_tabn     要參考的正式 table name
# Return Code....: l_tabname  建立後的臨時 table name  (_bak)
##################################################
FUNCTION s_dc_cre_temp_table(p_tabn)
   DEFINE p_tabn            STRING
   DEFINE l_tabname         STRING       #No.FUN-A80036
   DEFINE l_p1              LIKE type_file.num5
   DEFINE l_n               LIKE type_file.num5
   DEFINE l_i               LIKE type_file.num5
   DEFINE l_tempdir         STRING       #LIKE ze_file.ze03
   DEFINE l_temp_file       STRING       #LIKE ze_file.ze03                                    
   DEFINE l_temp_file1      STRING       #LIKE ze_file.ze03                                    
   DEFINE l_result          STRING
   #No.FUN-A80036  --Begin                                                      
   DEFINE l_str             STRING                                              
   DEFINE l_time            STRING
   DEFINE l_str1            STRING                                              
   #No.FUN-A80036  --End
   DEFINE l_tabn            STRING       #No.MOD-AA0179
   DEFINE l_len             LIKE type_file.num10 #TQC-B90071
   DEFINE l_str2,l_prog     STRING               #TQC-B90071
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log

   #No.FUN-A80036  --Begin                                                      
   LET l_result = NULL                                                          
   LET g_db_type=cl_db_get_database_type()                                      
   #No.FUN-A80036  --End
 
   LET l_tempdir = FGL_GETENV("TEMPDIR")    #FUN-920098
 
   LET l_temp_file  = os.Path.join(l_tempdir.trim(),"create_table.sql")
   LET l_temp_file1 = os.Path.join(l_tempdir.trim(),"create_table.tmp")
 
   #p_tabn=ima_file
   #l_tabname=ima_file_bak
   #No.FUN-A80036  --Begin                                                      
   #LET l_tabname = p_tabn CLIPPED,"_bak"                                       
                                                                                
   LET g_db_type=cl_db_get_database_type()                                      
   #CASE g_db_type                                                               
   #   WHEN 'IFX'                                                                
   #        LET g_sql = "SELECT FIRST 1 REPLACE(CURRENT HOUR TO FRACTION,':','') FROM zx_file"
   #                                                                             
   #   WHEN 'ORA'                                                                
   #        LET g_sql = "SELECT TO_CHAR(SYSDATE, 'HH24MI.SS') FROM DUAL"         

   #   WHEN 'MSV'
   #        LET g_sql = "SELECT CAST(DATEPART(hh,getdate()) AS VARCHAR)+ CAST(DATEPART(mi,GETDATE()) AS VARCHAR)+CAST(DATEPART(ss,GETDATE()) AS VARCHAR)+'.'+ CAST(DATEPART(ms,GETDATE()) AS VARCHAR)"
   #END CASE                                                                     
   #                                                                             
   #PREPARE time_p1 FROM g_sql                                                   
   #IF SQLCA.sqlcode THEN                                                        
   #   LET l_result = SQLCA.sqlcode                                              
   #END IF                                                                       
   #DECLARE time_cs1 CURSOR FOR time_p1                                          
   #OPEN time_cs1                                                                
   #FETCH time_cs1 INTO l_time                                                   
   #IF SQLCA.sqlcode THEN                                                        
   #   LET l_result = SQLCA.sqlcode                                              
   #END IF
   LET l_time = CURRENT HOUR TO FRACTION(2)
   CALL cl_replace_str(l_time,':','') RETURNING l_time
   LET l_str     = l_time.subString(1,4),l_time.subString(7,FGL_WIDTH(l_time))
                                                                                
   #No.MOD-AA0179  --Begin                                                      
   LET l_tabn    = NULL                                                         
   IF NOT cl_null(p_tabn) THEN                                                  
      LET l_tabn = p_tabn.subString(1,3)                                        
   END IF                                                                       
   #No.MOD-AA0179  --End
   #LET l_str     = l_time CLIPPED                                               
   LET l_n       = l_str.getIndexOf(".",1)                                      
   LET l_str1    = FGL_GETPID()       #使用GETPID抓PID的值                      
   LET l_str1    = l_str1.trimLeft()  #使用trim函式，变数型态需为STRING         
  #LET l_tabname = g_prog CLIPPED,"_",p_tabn CLIPPED,"_",        #No.MOD-AA0179 
   #No.FUN-AC0038  --Begin                                                      
   #LET l_tabname = g_prog CLIPPED,"_",l_tabn CLIPPED,"_",        #No.MOD-AA0179
   #                l_str.subString(1,l_n-1),"_",                               
   #                l_str.subString(l_n+1,FGL_WIDTH(l_str)),"_",                
   #                l_str1 CLIPPED                                              

   #TQC-B90071--begin--add---
   LET l_prog=g_prog
   LET l_len = length(l_prog)
   LET l_str2= l_prog.subString(l_len-4+1,l_len)
   IF l_str2='_icd' OR l_str2='_slk' THEN
      LET l_prog = l_prog.subString(1,l_len-4)
   END IF
   #TQC-B90071--end--add----

   LET l_tabname = l_prog CLIPPED,"_",l_tabn CLIPPED,"_",        #No.MOD-AA0179 #TQC-B90071 g_prog==>l_prog
                   l_str.subString(1,l_n-1)                                     
   #FUN-AC0026(110705)---add----str----
   IF g_prog = 'aws_ttsrv2' THEN
       LET l_tabname = "aws_",l_tabn CLIPPED,"_",   
                       l_str.subString(1,l_n-1)                                     
   END IF
   #FUN-AC0026(110705)---add----end----
   #No.FUN-AC0038  --End 
   #No.FUN-A80036  --End
 
   LET g_sql = "DROP TABLE ",l_tabname
   PREPARE drop_p1 FROM g_sql
   EXECUTE drop_p1
 
   CASE g_db_type 
      WHEN "IFX"      #FUN-920098
       #str MOD-950002 mod
       #修改建立Temptable語法
         LET g_sql = " SELECT * FROM ",p_tabn," WHERE 1!=1 INTO TEMP ",l_tabname CLIPPED
         PREPARE create_p0 FROM g_sql
         EXECUTE create_p0
         IF STATUS THEN
            LET l_result = STATUS
         END IF
         LET g_sql = " DELETE FROM ",l_tabname
         PREPARE delete_p0 FROM g_sql
         EXECUTE delete_p0
         IF STATUS THEN
            LET l_result = STATUS
         END IF
       #end MOD-950002 mod
 
      WHEN "ORA"      #FUN-920098
         #No.FUN-AC0038  --Begin
         #LET g_sql = " CREATE TABLE ",l_tabname CLIPPED," AS SELECT * FROM ",p_tabn CLIPPED," WHERE 1<>1"   #No.MOD-960112
         LET g_sql = " SELECT * FROM ",p_tabn CLIPPED," WHERE 1<>1 INTO TEMP ",l_tabname CLIPPED
         #No.FUN-AC0038  --End  
         PREPARE create_p1 FROM g_sql
         EXECUTE create_p1
         IF STATUS THEN
            LET l_result = STATUS
         END IF
         LET g_sql = " DELETE FROM ",l_tabname
         PREPARE delete_p1 FROM g_sql
         EXECUTE delete_p1
         IF STATUS THEN
            LET l_result = STATUS
         END IF
 
      WHEN "MSV"      #FUN-920098
         LET g_sql = " SELECT *  INTO ",l_tabname CLIPPED, " FROM ",p_tabn," WHERE 1=2 " #FUN-960132
         PREPARE create_p1m FROM g_sql
         EXECUTE create_p1m
         #FUN-960132 start
         #IF STATUS THEN
         #   LET l_result = STATUS
         #END IF
         #LET g_sql = " DELETE FROM ",l_tabname
         #PREPARE delete_p1m FROM g_sql
         #EXECUTE delete_p1m
         #IF STATUS THEN
         #   LET l_result = STATUS
         #END IF
         #FUN-960132 end

      WHEN "ASE"      #FUN-A70145
         LET g_sql = " SELECT *  INTO ",l_tabname CLIPPED, " FROM ",p_tabn," WHERE 1=2 " #FUN-960132
         PREPARE create_p1ase FROM g_sql
         EXECUTE create_p1ase
   END CASE
 
  #MOD-880245-begin-mark
  # LET g_sql = 'rm ',l_temp_file1
  # RUN g_sql
  # LET g_sql = 'rm ',l_temp_file
  # RUN g_sql
  #MOD-880245-end-mark
 
   IF l_result THEN
      RETURN NULL
   ELSE
      RETURN l_tabname
   END IF
END FUNCTION
 
##################################################
# Descriptions...: DROP data center TABLE
# Date & Author..: 08/02/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_drop_temp_table(p_tabname)
# Input PARAMETER: p_tabname  DROP的表名稱
##################################################
FUNCTION s_dc_drop_temp_table(p_tabname)
   DEFINE p_tabname         LIKE type_file.chr50
 
   LET g_sql = "DROP TABLE ",p_tabname
   PREPARE drop_p2 FROM g_sql
   EXECUTE drop_p2
 
END FUNCTION
 
##################################################
# Descriptions...: 拋轉過來的資料,修改,刪除時權限檢查
# Date & Author..: 08/02/18 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_ud_flag(p_gev01,p_gev02,p_gew04,p_ud)
# Input PARAMETER: p_gev01    資料類型
#                  p_gev02    資料來源的營運中心
#                  p_gew04    修改資料的營運中心
#                  p_ud       修改'u' 刪除 'r'
# Return Code....: l_flag     1 有權限修改 0 無權限修改
##################################################
FUNCTION s_dc_ud_flag(p_gev01,p_gev02,p_gew04,p_ud)
   DEFINE p_gev01    LIKE gev_file.gev01
   DEFINE p_gev02    LIKE gev_file.gev02
   DEFINE p_gew04    LIKE gew_file.gew04
   DEFINE p_ud       LIKE type_file.chr1
   DEFINE l_gew06    LIKE gew_file.gew06
  #DEFINE l_gew07    LIKE gew_file.gew07   #MOD-D30049 mark
   DEFINE l_gew10    LIKE gew_file.gew10   #FUN-990069
   DEFINE l_azw06    LIKE azw_file.azw06   #FUN-990069
 
   #LET l_gew07 = 'Y'  #MOD-D30049 mark
    LET l_gew06 = 'Y'
#FUN-990069---begin  
    LET l_gew10 = 'Y'                                                                                                    
    SELECT azw06 INTO l_azw06 FROM azw_file                                                                             
     WHERE azw01 = p_gew04                                                                                                                
    IF p_ud = 'a' THEN 
       SELECT gew10 INTO l_gew10 FROM gew_file                                   
       #MOD-C90021 mark --start--
       #WHERE gew01 = (SELECT gev04 FROM gev_file                                                                                   
       #                WHERE gev01 = p_gev01                                                                                       
       #                  AND gev02 = p_gev02                                                                                       
       #                  AND gev03 = 'Y')                                                                                          
       #  AND gew02 = p_gev01                                                                                                       
       #MOD-C90021 mark --end--
        WHERE gew02 = p_gev01 #MOD-C90021 add
          AND gew04  IN (SELECT azw01 FROM azw_file WHERE azw06= l_azw06)                                             
       IF cl_null(l_gew10) THEN LET l_gew10 = 'Y' END IF                                                                                                                   
       IF l_gew10 = 'Y' THEN                                                                                                        
          RETURN 1                                                                                                                  
       ELSE                                                                                                                         
          RETURN 0                                                                                                                  
       END IF                                                                                                                       
    END IF                                                                                                                          
#FUN-990069---end    
   IF p_gew04 <> p_gev02 THEN
      #SELECT gew06,gew07 INTO l_gew06,l_gew07 FROM gew_file  
       SELECT gew06 INTO l_gew06 FROM gew_file   #MOD-D30049 mod
       #MOD-C90021 mark --start--
       #WHERE gew01 = (SELECT gev04 FROM gev_file
       #                WHERE gev01 = p_gev01
       #                  AND gev02 = p_gev02
       #                  AND gev03 = 'Y')
       #  AND gew02 = p_gev01
       #MOD-C90021 mark --end--
        WHERE gew02 = p_gev01 #MOD-C90021 add
#          AND gew04 = p_gew04    #FUN-990069
          AND gew04  IN (SELECT azw01 FROM azw_file WHERE azw06= l_azw06)   #FUN-990069
      #IF cl_null(l_gew07) THEN LET l_gew07 = 'Y' END IF   #MOD-D30049 mark
       IF cl_null(l_gew06) THEN LET l_gew06 = 'Y' END IF
    END IF
 
   #MOD-D30049 mark
   #IF p_ud = 'u' THEN
   #   IF l_gew07 = 'Y' THEN
   #      RETURN 1 
   #   ELSE 
   #      RETURN 0 
   #   END IF
   #END IF
   #MOD-D30049 mark--end
   #IF p_ud = 'r' THEN
    IF p_ud = 'r' OR p_ud = 'u' THEN  #MOD-D30049 mod
       IF l_gew06 = 'Y' THEN
          RETURN 1 
       ELSE 
          RETURN 0 
       END IF
    END IF
END FUNCTION
 
##################################################
# Descriptions...: 字段值檢查
# Date & Author..: 08/01/28 By Carrier FUN-7C0010
# Usage..........: CALL s_field_chk(p_value,p_gey01,p_gey02,p_gey03)
# Input PARAMETER: p_value  字段輸入值
#                  p_gey01  資料類型
#                  p_gey02  營運中心
#                  p_gey03  字段編號
# RETURN Code....: l_flag '1' -ok  '0' -fail
##################################################
FUNCTION s_field_chk(p_value,p_gey01,p_gey02,p_gey03)
  DEFINE p_value             LIKE ze_file.ze03
  DEFINE p_gey01             LIKE gey_file.gey01
  DEFINE p_gey02             LIKE gey_file.gey02
  DEFINE p_gey03             LIKE gey_file.gey03
  DEFINE l_gey               RECORD LIKE gey_file.*
  DEFINE l_option            LIKE type_file.chr20
  DEFINE l_oa                LIKE type_file.chr3
  DEFINE l_b                 LIKE type_file.chr1
  DEFINE l_e                 LIKE type_file.chr1
  DEFINE l_chr               LIKE type_file.chr1
  DEFINE where_conditions    STRING
  DEFINE conditions_total    base.StringTokenizer
  DEFINE sub_conditions      STRING
  DEFINE l_sql               STRING
  DEFINE l_cnt               LIKE type_file.num5
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(p_value) THEN RETURN '1' END IF
   SELECT * INTO l_gey.* FROM gey_file
    WHERE gey01 = p_gey01
      AND gey02 = p_gey02
      AND gey03 = p_gey03
 
   IF SQLCA.sqlcode = 100 THEN
      RETURN '1'
   END IF
 
   CALL s_get_option(l_gey.gey04) RETURNING l_option,l_oa,l_b,l_e
 
   #aag24 is numeric, and others are characters
   IF l_gey.gey03 = 'aag24' THEN LET l_chr =' ' ELSE LET l_chr = "'"  END IF
 
   LET where_conditions=NULL
   LET conditions_total = base.StringTokenizer.create(l_gey.gey05 CLIPPED, ";")
   WHILE conditions_total.hasMoreTokens()
      LET sub_conditions = conditions_total.nextToken()
      IF cl_null(where_conditions) THEN
         LET where_conditions= "(",l_chr,p_value CLIPPED,l_chr," ",l_option CLIPPED," ",l_chr,l_b CLIPPED,sub_conditions.trim(),l_e CLIPPED,l_chr
      ELSE
         LET where_conditions= where_conditions CLIPPED," ",l_oa," ",l_chr,p_value CLIPPED,l_chr," ",l_option CLIPPED," ",l_chr,l_b CLIPPED,sub_conditions.trim(),l_e CLIPPED,l_chr
      END IF
   END WHILE
   LET where_conditions=where_conditions CLIPPED,')'
 
   LET l_sql = "SELECT COUNT(*) FROM aza_file WHERE ",where_conditions
   PREPARE pp1 FROM l_sql
   EXECUTE pp1 INTO l_cnt
   IF l_cnt = 1 THEN
      RETURN '1'
   ELSE
      RETURN '0'
   END IF
  
END FUNCTION
 
##################################################
# Descriptions...: 根據條件類型,得到組WHERE子句的必要信息
# Date & Author..: 07/12/07 By Carrier FUN-7C0010
# Usage..........: CALL s_get_option(p_option)
# Input PARAMETER: p_option symbolized option 1/2/3...
# RETURN Code....: l_option <> > >= matches...
#                  l_oa     OR/AND
#                  l_b      NULL/*
#                  l_e      NULL/*
##################################################
FUNCTION s_get_option(p_option)
    DEFINE p_option    LIKE type_file.chr2     #1/2/....
    DEFINE l_option    LIKE type_file.chr20    #<>/>=...
    DEFINE l_oa        LIKE type_file.chr3     #AND/OR
    DEFINE l_b         LIKE type_file.chr1
    DEFINE l_e         LIKE type_file.chr1
    
    LET l_oa = ''
    LET l_b  = ''
    LET l_e  = ''
    CASE p_option
       WHEN '1'  LET l_option = '<>'
                 LET l_oa     = 'AND'
       WHEN '2'  LET l_option = '>'
       WHEN '3'  LET l_option = '>='
       WHEN '4'  LET l_option = '<'
       WHEN '5'  LET l_option = '<='
       WHEN '6'  LET l_option = 'MATCHES'
                 LET l_oa     = 'OR'
                 LET l_e      = '*'
       WHEN '8'  LET l_option = 'MATCHES'
                 LET l_oa     = 'OR'
                 LET l_b      = '*'
       WHEN '10' LET l_option = 'MATCHES'
                 LET l_oa     = 'OR'
                 LET l_b      = '*'
                 LET l_e      = '*'
       WHEN '7'  LET l_option = 'NOT MATCHES'
                 LET l_oa     = 'AND'
                 LET l_e      = '*'
       WHEN '9'  LET l_option = 'NOT MATCHES'
                 LET l_oa     = 'AND'
                 LET l_b      = '*'
       WHEN '11' LET l_option = 'NOT MATCHES'
                 LET l_oa     = 'AND'
                 LET l_b      = '*'
                 LET l_e      = '*'
    END CASE
    RETURN l_option,l_oa,l_b,l_e
END FUNCTION
 
##################################################
# Descriptions...: 資料中心拋轉時DB選擇作業
# Date & Author..: 08/02/14 By Carrier FUN-7C0010
# Usage..........: CALL s_input_gev04(p_gew02)
# Input PARAMETER: p_gew02  資料類型
# Return Code....: l_gev04  資料中心
##################################################
FUNCTION s_input_gev04(p_gew02)
 
   DEFINE p_gew02     LIKE gew_file.gew02
   DEFINE l_gev04     LIKE gev_file.gev04
   DEFINE l_geu02     LIKE geu_file.geu02
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW s_input_gev04_1_w WITH FORM "sub/42f/s_input_gev04"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("s_input_gev04")
 
   SELECT gev04 INTO l_gev04 FROM gev_file
    WHERE gev01 = p_gew02 AND gev02 = g_plant
   SELECT geu02 INTO l_geu02 FROM geu_file
    WHERE geu01 = l_gev04
   DISPLAY l_gev04 TO FORMONLY.gev04
   DISPLAY l_geu02 TO FORMONLY.geu02
 
   CALL cl_set_act_visible("accept", TRUE)
   INPUT l_gev04 WITHOUT DEFAULTS FROM FORMONLY.gev04
 
      AFTER FIELD gev04
         IF NOT cl_null(l_gev04) THEN
            CALL s_check_gev04(l_gev04,p_gew02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_gev04,g_errno,0)
               NEXT FIELD gev04
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gev04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gev04"
               LET g_qryparam.arg1 = p_gew02
               LET g_qryparam.arg2 = g_plant
               CALL cl_create_qry() RETURNING l_gev04
               DISPLAY l_gev04 TO FORMONLY.gev04
               CALL s_check_gev04(l_gev04,p_gew02)
               NEXT FIELD gev04
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT 
 
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT INPUT 
 
   END INPUT
   CALL cl_set_act_visible("accept", FALSE)
   IF INT_FLAG THEN
      CLOSE WINDOW s_input_gev04_1_w
      RETURN NULL
   END IF
 
   CLOSE WINDOW s_input_gev04_1_w
   RETURN l_gev04
 
END FUNCTION
 
FUNCTION s_check_gev04(p_gev04,p_gew02)
  DEFINE p_gev04    LIKE gev_file.gev04
  DEFINE p_gew02    LIKE gew_file.gew02
  DEFINE l_geu00    LIKE geu_file.geu00
  DEFINE l_geu02    LIKE geu_file.geu02
  DEFINE l_geuacti  LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
      FROM geu_file WHERE geu01=p_gev04
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    ELSE
      #SELECT * FROM gew_file
      # WHERE gew01 = p_gev04 
      #   AND gew02 = p_gew02
      #   AND gew04 = g_plant
      #IF SQLCA.sqlcode THEN
      #   LET g_errno = 'aoo-034'   #gev_file沒有維護,不能拋轉
      #END IF
 
       IF cl_null(g_errno) THEN
          #是否為資料中心的拋轉DB
          SELECT * FROM gev_file WHERE gev01 = p_gew02 AND gev02 = g_plant
                                   AND gev03 = 'Y' AND gev04 = p_gev04
          IF SQLCA.sqlcode THEN
             LET g_errno = 'aoo-036'
          END IF
       END IF
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    END IF
    DISPLAY l_geu02 TO FORMONLY.geu02
END FUNCTION
 
##################################################
# Descriptions...: 設置字段編號中出現的選項值
# Date & Author..: 07/12/07 By Carrier FUN-7C0010
# Usage..........: CALL s_set_combo_all(p_type,p_field)
# Input PARAMETER: p_type   1~7
#                  p_field  gey03/gez04..
# Return Code....: NULL
##################################################
FUNCTION s_set_combo_all(p_type,p_field)
   DEFINE p_type    LIKE type_file.chr1
   DEFINE p_field   LIKE gaq_file.gaq01
   DEFINE cb        ui.ComboBox                                                       
   DEFINE l_items   LIKE type_file.chr1000
   
   LET cb = ui.ComboBox.forName(p_field)
   CALL cb.clear()
   IF p_type = '1' OR cl_null(p_type) THEN
      LET l_items = 'ima01:',cl_get_feldname('ima01',g_lang)
      CALL cb.addItem("ima01",l_items)
      LET l_items = 'ima06:',cl_get_feldname('ima06',g_lang)
      CALL cb.addItem("ima06",l_items)
      LET l_items = 'ima109:',cl_get_feldname('ima109',g_lang)
      CALL cb.addItem("ima109",l_items)
   END IF
   IF p_type = '2' OR cl_null(p_type) THEN
      LET l_items = 'bma01:',cl_get_feldname('bma01',g_lang)
      CALL cb.addItem("bma01",l_items)
   END IF
   IF p_type = '3' OR cl_null(p_type) THEN
      LET l_items = 'bmx01:',cl_get_feldname('bmx01',g_lang) #No.FUN-830090
      CALL cb.addItem("bmx01",l_items)                       #No.FUN-830090
      LET l_items = 'bmz02:',cl_get_feldname('bmz02',g_lang) #No.FUN-840138                                                         
      CALL cb.addItem("bmz02",l_items)                       #No.FUN-840138
#     LET l_items = 'bmy14:',cl_get_feldname('bmy14',g_lang) #No.FUN-840138                                                         
#     CALL cb.addItem("bmy14",l_items)                       #No.FUN-840138
   END IF
   IF p_type = '4' OR cl_null(p_type) THEN
      LET l_items = 'occ01:',cl_get_feldname('occ01',g_lang)
      CALL cb.addItem("occ01",l_items)
      LET l_items = 'occ03:',cl_get_feldname('occ03',g_lang)
      CALL cb.addItem("occ03",l_items)
   END IF
   IF p_type = '5' OR cl_null(p_type) THEN
      LET l_items = 'pmc01:',cl_get_feldname('pmc01',g_lang)
      CALL cb.addItem("pmc01",l_items)
      LET l_items = 'pmc14:',cl_get_feldname('pmc14',g_lang)
      CALL cb.addItem("pmc14",l_items)
   END IF
   IF p_type = '6' OR cl_null(p_type) THEN
      LET l_items = 'aag01:',cl_get_feldname('aag01',g_lang)
      CALL cb.addItem("aag01",l_items)
      LET l_items = 'aag24:',cl_get_feldname('aag24',g_lang)
      CALL cb.addItem("aag24",l_items)
   END IF
   IF p_type = '7' OR cl_null(p_type) THEN
      LET l_items = 'tqm01:',cl_get_feldname('tqm01',g_lang)
      CALL cb.addItem("tqm01",l_items)
      LET l_items = 'tqm06:',cl_get_feldname('tqm06',g_lang)
      CALL cb.addItem("tqm06",l_items)
   END IF
 
END FUNCTION
 
##################################################
# Descriptions...: 檢查輸入值是否符合設定
# Date & Author..: 07/12/07 By Carrier FUN-7C0010
# Usage..........: CALL s_value_chk(p_str)
# Input PARAMETER: p_str    Conditions To Check
# Return Code....: NULL
##################################################
FUNCTION s_value_chk(p_str)
    DEFINE p_str     STRING
    DEFINE l_p1      LIKE type_file.num5  
    DEFINE l_p2      LIKE type_file.num5  
    DEFINE l_p3      LIKE type_file.num5  
    DEFINE l_p4      LIKE type_file.num5  
    DEFINE l_p5      LIKE type_file.num5  
    DEFINE l_p6      LIKE type_file.num5  
    DEFINE l_p7      LIKE type_file.num5  
 
    LET g_errno = ' '
    #error symbol ' " ) + > < = *
    LET l_p1=p_str.getIndexOf("'",1)
    LET l_p2=p_str.getIndexOf('"',1)
    LET l_p3=p_str.getIndexOf(")",1)
    LET l_p4=p_str.getIndexOf("+",1)
    LET l_p5=p_str.getIndexOf(">",1)
    LET l_p6=p_str.getIndexOf("<",1)
    LET l_p7=p_str.getIndexOf("=",1)
    LET l_p7=p_str.getIndexOf("*",1)
    
    IF l_p1 = 0 AND l_p2 = 0 AND l_p3 = 0 AND l_p4 = 0 AND
       l_p5 = 0 AND l_p6 = 0 AND l_p7 = 0 THEN
    ELSE
       LET g_errno = 'aoo-031'
    END IF
END FUNCTION
 
##################################################
# Descriptions...: 拋轉發MAIL部份1
# Date & Author..: 08/03/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_carry_send_mail_1(p_azp01,p_i,p_gew01,p_gew02)
# Input PARAMETER: p_azp01  DB 
#                  p_i      項次
#                  p_gew01  資料中心
#                  p_gew02  資料類型
# RETURN Code....: l_flag   'Y'|'N' 是否要發MAIL
#                  l_path   附件全路徑
##################################################
FUNCTION s_dc_carry_send_mail_1(p_azp01,p_i,p_gew01,p_gew02,p_hist_tab)
   DEFINE p_azp01        LIKE azp_file.azp01
   DEFINE p_i            LIKE type_file.num5
   DEFINE p_gew01        LIKE gew_file.gew01
   DEFINE p_gew02        LIKE gew_file.gew02
   DEFINE p_hist_tab     LIKE type_file.chr50
   DEFINE l_gew08        LIKE gew_file.gew08
   DEFINE l_tempdir      LIKE type_file.chr20
   DEFINE lc_channel     base.Channel
   DEFINE l_str          LIKE type_file.chr1000
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_cmd1         LIKE type_file.chr1000
   DEFINE l_path         LIKE ze_file.ze03
   DEFINE l_azw06        LIKE azw_file.azw06  #FUN-990069
   DEFINE l_azw01        LIKE azw_file.azw01  #FUN-990069
   DEFINE l_str1         STRING               #FUN-990069 
   DEFINE i              LIKE type_file.num5
 
   #for s_dc_carry_record 
   #for efficiency difine gex here
   LET l_cmd = "DELETE FROM ",p_hist_tab
   PREPARE del_gex FROM l_cmd
   EXECUTE del_gex
   LET l_cmd = "INSERT INTO ",p_hist_tab CLIPPED,"(gex01,gex02,gex03,gex04,",
                                                 " gex05,gex06,gex07,gex08,",
                                                 " gex09)",
               "   VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE ins_gex FROM l_cmd
 
   #mail list
   SELECT gew08 INTO l_gew08 FROM gew_file
    WHERE gew01 = p_gew01
      AND gew02 = p_gew02
      AND gew04 = p_azp01
   IF SQLCA.sqlcode OR cl_null(l_gew08) THEN
      RETURN 'N',NULL
   END IF
   
   INITIALIZE g_xml.* TO NULL
   
   #Subject
   LET l_cmd = g_prog CLIPPED,' ',g_today
   CALL cl_getmsg('aoo-037',g_lang) RETURNING l_cmd1
   LET g_xml.subject = l_cmd CLIPPED,' ',l_cmd1
 
   #抓相關應通知人員email
   LET g_xml.recipient =  l_gew08
 
   IF cl_null(g_xml.recipient) THEN
      RETURN 'N',NULL
   END IF
#FUN-990069---begin
   LET l_azw06 = NULL
   LET l_azw01 = NULL
   LET l_str1  = ''
   SELECT azw06 INTO l_azw06 FROM azw_file WHERE  azw01 = p_azp01
   DECLARE s_dc_azw CURSOR FOR  SELECT azw01 FROM  azw_file
                                 WHERE azw06 = l_azw06
   FOREACH s_dc_azw INTO l_azw01
     IF STATUS THEN                                                                                                          
        CALL cl_err('foreach:',STATUS,1)      
        EXIT FOREACH                                                                                   
     END IF      
     IF l_str = '' THEN 
        LET l_str1 = l_azw01 CLIPPED
     ELSE 
        LET l_str1 = l_str1,",",l_azw01 CLIPPED
     END IF
   END FOREACH
#FUN-990069---end
 
   # 產生xml文本檔    #FUN-920098
   LET l_tempdir = FGL_GETENV("TEMPDIR")
   LET l_cmd = g_prog CLIPPED,'-',p_azp01,'-',p_i USING "<<<<<",'.htm'
   LET l_cmd = os.Path.join(l_tempdir CLIPPED,l_cmd CLIPPED)
#  LET l_cmd = l_tempdir CLIPPED,'/',g_prog CLIPPED,'-',
#              p_azp01,'-',p_i USING "<<<<<",'.htm'
 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(l_cmd,"w")
   CALL lc_channel.setDelimiter("")
 
   LET l_str = "<html>"
   CALL lc_channel.write(l_str)
   LET l_str = "<head>"
   CALL lc_channel.write(l_str)
 
   LET l_str = "<title>",g_xml.subject CLIPPED,"</title>"
   CALL lc_channel.write(l_str)
   LET l_str = "</head>"
   CALL lc_channel.write(l_str)
   LET l_str = "<body>"
   CALL lc_channel.write(l_str)
 
   #本文
   LET l_str = 'Dear ALL:',"<br>"
   CALL lc_channel.write(l_str)
 
   LET l_str = ' ',"<br>"
   CALL lc_channel.write(l_str)
 
#   LET l_str = p_azp01 CLIPPED,' ',cl_getmsg('aoo-038',g_lang) #FUN-990069
   LET l_str = l_str1 CLIPPED,' ',cl_getmsg('aoo-038',g_lang)   #FUN-990069
   LET l_str = l_str CLIPPED,"<br>"
   CALL lc_channel.write(l_str)
 
   LET l_str = "</body>"
   CALL lc_channel.write(l_str)
   LET l_str = "</html>"
   CALL lc_channel.write(l_str)
   CALL lc_channel.close()
 
#  LET l_cmd1 = "chmod 777 ",l_cmd CLIPPED
#  RUN l_cmd1
   IF os.Path.chrwx(l_cmd CLIPPED,511) THEN END IF
 
   LET g_xml.body = l_cmd
 
   #抓附件
   LET g_xml.attach=''
   LET l_path = os.Path.join(l_tempdir CLIPPED,g_prog CLIPPED||".txt")
#  LET l_path = l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
 
#  LET l_cmd = "rm ",l_path CLIPPED      #MOD-8B0051 mark
 
   IF os.Path.delete(l_path CLIPPED) THEN END IF
#  LET l_cmd = "rm ",l_path,'>/dev/null'  #MOD-8B0051
#  RUN l_cmd
 
#  LET l_cmd = "cat /dev/null >",l_path CLIPPED
#  RUN l_cmd
   CALL cl_null_cat_to_file(l_path CLIPPED)     #FUN-9B0113
 
   LET l_cmd = "echo 'Data Center\tData Type\tCarry Logestic\t",
               "Program ID\tKey Value\t",
               "Carry Counts\tCarry Date\tCarry Time\t",
               "Carry Person' >>",l_path CLIPPED
   RUN l_cmd
   
   RETURN 'Y',l_path
       
END FUNCTION
 
 
##################################################
# Descriptions...: 拋轉發MAIL部份1
# Date & Author..: 08/03/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_carry_send_mail_2(p_flag,p_gew08,p_path)
# Input PARAMETER: p_flag   'Y'|'N' 是否要發MAIL
#                  p_gew08  MAIL LIST
#                  p_path   附件全路徑
# RETURN Code....: NULL
##################################################
FUNCTION s_dc_carry_send_mail_2(p_flag,p_gew08,p_path,p_hist_tab)
   DEFINE p_flag         LIKE type_file.chr1
   DEFINE p_gew08        LIKE gew_file.gew08
   DEFINE p_path         LIKE ze_file.ze03
   DEFINE p_hist_tab     LIKE type_file.chr50
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_gex          RECORD LIKE gex_file.*
   DEFINE l_cnt          LIKE type_file.num10
       
       LET l_cmd = "SELECT * FROM ",p_hist_tab," ORDER BY gex05"
       PREPARE hist_p1 FROM l_cmd
       DECLARE hist_cur CURSOR FOR hist_p1
 
       FOREACH hist_cur INTO l_gex.*
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('gex01',l_gex.gex01,'hist_cur',SQLCA.sqlcode,1)
          END IF
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM gex_file
           WHERE gex01 = l_gex.gex01
             AND gex02 = l_gex.gex02
             AND gex03 = l_gex.gex03
             AND gex04 = l_gex.gex04
             AND gex05 = l_gex.gex05
             AND gex07 = l_gex.gex07
             AND gex08 = l_gex.gex08
             AND gex09 = l_gex.gex09
          IF l_cnt = 0 THEN
             INSERT INTO gex_file VALUES(l_gex.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('gex01',l_gex.gex05,'ins gex',SQLCA.sqlcode,1)
             END IF
             IF p_flag = 'Y' THEN
                LET l_cmd = "echo ",l_gex.gex01 CLIPPED,"\t",l_gex.gex02 CLIPPED,"\t",
                                    l_gex.gex03 CLIPPED,"\t",l_gex.gex04 CLIPPED,"\t",
                                    l_gex.gex05 CLIPPED,"\t1\t",
                                    l_gex.gex07,"\t",l_gex.gex08,"\t",
                             l_gex.gex09 CLIPPED," >>",p_path
                RUN l_cmd
             END IF
          ELSE
             UPDATE gex_file SET gex06 = l_cnt + 1
              WHERE gex01 = l_gex.gex01
                AND gex02 = l_gex.gex02
                AND gex03 = l_gex.gex03
                AND gex04 = l_gex.gex04
                AND gex05 = l_gex.gex05
                AND gex07 = l_gex.gex07
                AND gex08 = l_gex.gex08
                AND gex09 = l_gex.gex09
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('gex01',l_gex.gex05,'ins/upd gex',SQLCA.sqlcode,1)
             END IF
             IF p_flag = 'Y' THEN
                LET l_cmd = "echo ",l_gex.gex01 CLIPPED,"\t",l_gex.gex02 CLIPPED,"\t",
                                    l_gex.gex03 CLIPPED,"\t",l_gex.gex04 CLIPPED,"\t",
                                    l_gex.gex05 CLIPPED,"\t",l_cnt+1 USING "<<<<&","\t",
                                    l_gex.gex07,"\t",l_gex.gex08,"\t",
                             l_gex.gex09 CLIPPED," >>",p_path
                RUN l_cmd
             END IF
          END IF
       END FOREACH
 
       IF p_flag = 'N' THEN RETURN END IF
       
       MESSAGE "Sending Mail:",p_gew08 CLIPPED
       CALL ui.Interface.refresh()
       
       LET g_xml.attach =p_path
 
       DISPLAY g_xml.subject
       DISPLAY "Mail 收件人清單：" , g_xml.recipient
       CALL cl_jmail()
 
#      LET l_cmd = "rm ",p_path CLIPPED
#      RUN l_cmd
       IF os.Path.delete(p_path CLIPPED) THEN END IF
 
       LET p_path = g_xml.body
#      LET l_cmd = "rm ",p_path CLIPPED
#      RUN l_cmd
       IF os.Path.delete(p_path CLIPPED) THEN END IF
       
END FUNCTION       
 
##################################################
# Descriptions...: 記錄拋轉歷史資料
# Date & Author..: 08/03/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_carry_record(p_gev04,p_azp01,p_prog,p_gex05,p_gex02)
# Input PARAMETER: p_gev04  資料中心
#                  p_azp01  DB
#                  p_prog   程序代號
#                  p_gex05  拋轉主鍵值
#                  p_gex02  資料類型
# RETURN Code....: NULL
##################################################
FUNCTION s_dc_carry_record(p_gev04,p_azp01,p_prog,p_gex05,p_gex02)
 
   DEFINE p_gev04        LIKE gev_file.gev04
   DEFINE p_azp01        LIKE azp_file.azp01
   DEFINE p_prog         LIKE gaz_file.gaz01
   DEFINE p_gex05        LIKE gex_file.gex05
   DEFINE p_gex02        LIKE gex_file.gex02
   DEFINE p_hist_tab     LIKE type_file.chr50
   DEFINE l_cnt          LIKE type_file.num10
   DEFINE l_time         LIKE type_file.chr20
   DEFINE l_cmd          LIKE type_file.chr1000
 
   IF g_success = 'N' THEN RETURN END IF
 
   LET l_time = TIME
   #MOD-B50237 remove mark --start--
   #CHI-A60011 mark --start--
   EXECUTE ins_gex USING p_gev04,p_gex02,p_azp01,
               p_prog,p_gex05,'1',g_today,l_time,g_user
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('gex05',p_gex05,'ins gex',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #CHI-A60011 mark --end--
   #MOD-B50237 remove mark --end--
   #CHI-A60011 add --start--
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM gex_file
    WHERE gex01 = p_gev04
      AND gex02 = p_gex02
      AND gex03 = p_azp01
      AND gex04 = p_prog
      AND gex05 = p_gex05
      AND gex07 = g_today
      AND gex08 = l_time
      AND gex09 = g_user
   IF l_cnt = 0 THEN
      INSERT INTO gex_file VALUES(p_gev04,p_gex02,p_azp01,
                  p_prog,p_gex05,1,g_today,l_time,g_user)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'ins gex',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   ELSE
      UPDATE gex_file SET gex06 = l_cnt + 1
       WHERE gex01 = p_gev04
         AND gex02 = p_gex02
         AND gex03 = p_azp01
         AND gex04 = p_prog
         AND gex05 = p_gex05
         AND gex07 = g_today
         AND gex08 = l_time
         AND gex09 = g_user
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'upd gex',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #CHI-A60011 add --end--
END FUNCTION
 
##################################################
# Descriptions...: ata center TABLE  (upload)
# Date & Author..: 08/02/17 By Carrier FUN-7C0010
# Usage..........: CALL s_dc_cre_temp_table1(p_tabn)
# Input PARAMETER: p_tabn     要參考的正式 table name
# Return Code....: l_tabname  建立後的臨時 table name  (_bak1)
##################################################
FUNCTION s_dc_cre_temp_table1(p_tabn)
   DEFINE p_tabn            STRING
   DEFINE l_tabname         LIKE type_file.chr50
   DEFINE l_p1              LIKE type_file.num5
   DEFINE l_n               LIKE type_file.num5
   DEFINE l_i               LIKE type_file.num5
   DEFINE l_tempdir         STRING     #LIKE ze_file.ze03
   DEFINE l_temp_file       STRING     #LIKE ze_file.ze03                                    
   DEFINE l_temp_file1      STRING     #LIKE ze_file.ze03                                    
   DEFINE l_result          STRING
   DEFINE l_cnt             LIKE type_file.num5   #No.FUN-A80036
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_tempdir = FGL_GETENV("TEMPDIR")    #FUN-920098
 
   LET l_temp_file  = os.Path.join(l_tempdir.trim(),"create_table.sql")
   LET l_temp_file1 = os.Path.join(l_tempdir.trim(),"create_table.tmp")
 
   #p_tabn=ima_file
   #l_tabname=ima_file_bak1
   LET l_tabname = p_tabn CLIPPED,"_bak1"

   #No.FUN-A80036  --Begin                                                      
   LET l_cnt = 0                                                                
   LET g_db_type=cl_db_get_database_type()                                      
   CASE g_db_type
        WHEN 'IFX'
           SELECT COUNT(*) INTO l_cnt FROM systables                                 
            WHERE tabname=l_tabname                                                  
        WHEN 'MSV'
           SELECT COUNT(*) INTO l_cnt FROM sys.objects
            WHERE name = l_tabname
        WHEN 'ORA'
           SELECT COUNT(*) INTO l_cnt FROM user_objects                           
            WHERE LOWER(object_name)=l_tabname                                    
   END CASE                                                                     
   IF l_cnt > 0 THEN                                                            
      CALL cl_err(l_tabname,'sub-222',1)                                        
      RETURN NULL                                                               
   END IF                                                                       
   #No.FUN-A80036  --End
 
   LET g_sql = "DROP TABLE ",l_tabname
   PREPARE drop_p3 FROM g_sql
   EXECUTE drop_p3
 
   LET l_result = NULL
   LET g_db_type=cl_db_get_database_type()
 
   CASE g_db_type 
      WHEN "IFX"     #FUN-920098
         LET g_sql = "dbschema -d ds -t ",p_tabn CLIPPED," -q > ",l_temp_file
         RUN g_sql
         LET g_sql = 'sed "/revoke/d" ',l_temp_file CLIPPED,'>',l_temp_file1 CLIPPED
         RUN g_sql
         LET g_sql = 'sed "s:\".*\"\.:.dbo.g" ',l_temp_file1 CLIPPED,'|sed "s:_file:_file_bak1:g" |sed "s:_pk:_pk1:g" >',l_temp_file CLIPPED
         RUN g_sql
         LET g_sql = 'dbaccess ',g_dbs CLIPPED,' <',l_temp_file CLIPPED
         RUN g_sql RETURNING l_result
 
      WHEN "ORA"     #FUN-920098
         LET g_sql = " CREATE TABLE ",l_tabname CLIPPED," AS SELECT * FROM ",p_tabn CLIPPED," WHERE 1<>1"   #No.MOD-960112
         PREPARE create_p2 FROM g_sql
         EXECUTE create_p2
         IF STATUS THEN
            LET l_result = STATUS
         END IF
         LET g_sql = " DELETE FROM ",l_tabname
         PREPARE delete_p2 FROM g_sql
         EXECUTE delete_p2
         IF STATUS THEN
            LET l_result = STATUS
         END IF
 
      WHEN "MSV"     #FUN-920098
         LET g_sql = " SELECT *  INTO ",l_tabname CLIPPED, " FROM ",p_tabn," WHERE 1=2 " #FUN-960132
         PREPARE create_p2m FROM g_sql
         EXECUTE create_p2m
         #FUN-960132 start
         #IF STATUS THEN
         #   LET l_result = STATUS
         #END IF
         #LET g_sql = " DELETE FROM ",l_tabname
         #PREPARE delete_p2m FROM g_sql
         #EXECUTE delete_p2m
         #IF STATUS THEN
         #   LET l_result = STATUS
         #END IF
         #FUN-960132 end

      WHEN "ASE"     #FUN-A70145
         LET g_sql = " SELECT *  INTO ",l_tabname CLIPPED, " FROM ",p_tabn," WHERE 1=2 " #FUN-960132
         PREPARE create_p2ase FROM g_sql
         EXECUTE create_p2ase
   END CASE
 
#  LET g_sql = 'rm ',l_temp_file1
#  RUN g_sql
   IF os.Path.delete(l_temp_file1 CLIPPED) THEN END IF
#  LET g_sql = 'rm ',l_temp_file
#  RUN g_sql
   IF os.Path.delete(l_temp_file CLIPPED) THEN END IF
 
   IF l_result THEN
      RETURN NULL
   ELSE
      RETURN l_tabname
   END IF
END FUNCTION
 
#FUN-AC0026--add---str---
FUNCTION s_dc_del_tmp(p_tabname)
  DEFINE p_tabname            LIKE type_file.chr50 

  LET g_sql = " DELETE FROM ",p_tabname
  PREPARE s_dc_del_tmp_p FROM g_sql
  EXECUTE s_dc_del_tmp_p
  IF SQLCA.sqlcode THEN
      CALL s_errmsg('DELET TABLE',g_sql,'s_dc_del_tmp_p',SQLCA.sqlcode,1)  
  END IF
END FUNCTION
#FUN-AC0026--add---end---
