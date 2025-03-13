# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_outnam
# Descriptions...: 賦予一個報表檔代號 (Disk File Name)
# Input parameter: p_code	報表程式代號
# Return code....: p_name	報表檔代號
# Usage..........: call cl_outnam(p_code) RETURNING l_name
# Date & Author..: 91/06/15 By LYS
# Modify.........: No.MOD-530271 05/05/24 By echo 新增報表備註功能
# Modify.........: No.MOD-560029 05/06/07 By echo 報表行數設定33行，依然會讀取為66行
# Modify.........: No.MOD-570245 05/07/20 By echo 報表樣版若為voucher，可以BY使用者抓取不同的欄位功能
# Modify.........: No.FUN-570264 05/07/28 By CoCo background job don't pop q_zaa window
# Modify.........: No.FUN-560048 05/08/01 By echo 錯誤判斷後，直接離開程式
# Modify.........: No.MOD-580124 05/08/18 By echo 程式使用外部呼叫方式的報表,表頭全部無法列印
# Modify.........: No.MOD-590446 05/09/28 By Echo p_zab的行序為1空白時，執行報表則直接印p_zaa的欄位內容資料
# Modify.........: No.TQC-590051 05/09/29 By CoCo if g_len=0 then no check the real length of report
# Modify.........: No.FUN-630024 06/04/04 By Echo 新增設定動態附檔名代號
# Modify.........: No.FUN-650017 06/06/15 By Echo 新增抓取報表左邊界(zaa19)的值
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.TQC-6B0183 07/01/08 By Echo 判斷如果g_x is null則show message 
# Modify.........: NO.FUN-6C0048 07/01/09 By ching-yuan 新增TOP MARGIN g_top_margin& BOTTOM MARGIN g_bottom_margin設定欄位
# Modify.........: NO.FUN-640161 07/01/16 By yiting cl_err->cl_err3
# Modify.........: NO.MOD-770068 07/07/16 By alex 加入 MSV段
# Modify.........: No.FUN-7C0058 07/12/19 By jacklai 補充lib的說明資料
# Modify.........: NO.FUN-830021 08/03/06 By alex 移除 gay02使用
# Modify.........: NO.FUN-980097 09/08/21 By alex 合併wos至單一4gl
# Modify.........: No:FUN-A20033 10/02/08 By Echo 表頭也顯示營運中心的說明
# Modify.........: NO.FUN-AA0017 10/10/13 By alex 加入 Sybase ASE段
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)

 
IMPORT os      #FUN-980097
DATABASE ds                                     #TQC-6B0183
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_log		LIKE type_file.chr1             #No.FUN-690005 VARCHAR(1)
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04  #FUN-560076
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   
END GLOBALS
 
FUNCTION cl_outnam(p_code)
   DEFINE p_code                LIKE zz_file.zz01,            #No.FUN-690005 VARCHAR(10)
          l_name        	LIKE type_file.chr20,         #No.FUN-690005 VARCHAR(20)
          l_n       	        LIKE type_file.num5,          #No.FUN-690005 SMALLINT
          l_buf           	LIKE type_file.chr6,          #No.FUN-690005 VARCHAR(6)
          l_sw,l_chr    	LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(1)
          l_waitsec,l_cnt       LIKE type_file.num5,          #No.FUN-690005 SMALLINT
          l_zaa02               LIKE type_file.num5,          #No.FUN-690005  SMALLINT
          l_zaa08               LIKE type_file.chr1000,       #No.FUN-690005  VARCHAR(1000)
          l_cmd                 LIKE type_file.chr1000,       #No.FUN-690005  VARCHAR(50)
          l_zaa08_s             STRING,
          l_zaa14               LIKE zaa_file.zaa14,        #No.FUN-690005  VARCHAR(1)
          l_zaa16               LIKE zaa_file.zaa16,        #No.FUN-690005  VARCHAR(1)
          l_cust                LIKE type_file.num5,             #No.FUN-690005  SMALLINT
          l_sql                 STRING,
          l_n2       	        LIKE type_file.num5         #FUN-630024        #No.FUN-690005 SMALLINT
   #TQC-6B0183
   DEFINE l_gay03               LIKE gay_file.gay03
   DEFINE l_str                 STRING
   #END TQC-6B0183
   DEFINE l_azp02               LIKE azp_file.azp02           #No.FUN-A20033
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT zz06 INTO l_sw
     FROM zz_FILE WHERE zz01 = p_code
 
   IF l_sw = '1'   #
      THEN 
           LET l_name = p_code CLIPPED,'.out'
      ELSE 
 
 
           SELECT zz16,zz24  INTO l_n,l_waitsec
                FROM zz_FILE WHERE zz01 = p_code 
           #No.B441 end----
           IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
           LET l_n = l_n + 1
           IF l_n > 30000 THEN  LET l_n = 0  END IF
           UPDATE zz_file SET zz16 = l_n WHERE zz01=p_code
           LET l_buf = l_n USING "&&&&&&"
           #FUN-630024
           #LET l_name = p_code CLIPPED,".",l_buf[5,6],"r"
           IF cl_null(g_aza.aza49) THEN
             UPDATE aza_file set aza49='1' 
             IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","aza_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
                     #CALL cl_err('U',SQLCA.sqlcode,0)
                     RETURN
             END IF
             LET g_aza.aza49 = '1'
           END IF
           IF g_aza.aza49 = '1' THEN   #01r-09r    
              LET l_name = p_code CLIPPED,".0",l_buf[6,6],"r"
           ELSE 
              CASE g_aza.aza49 
               WHEN '2'   #01r-19r    
                    LET l_n2 = l_n MOD 20
               WHEN '3'   #01r-29r    
                    LET l_n2 = l_n MOD 30
               WHEN '4'   #01r-39r    
                    LET l_n2 = l_n MOD 40
               WHEN '5'   #01r-49r    
                    LET l_n2 = l_n MOD 50
              END CASE
              LET l_buf = l_n2 USING "&&&&&&"             
              LET l_name = p_code CLIPPED,".",l_buf[5,6],"r"
           END IF
           #FUN-630024
   END IF
 
  #LET l_cmd = 'rm -f ',l_name CLIPPED,'*'
  #RUN l_cmd
  IF os.Path.delete(l_name CLIPPED||'*') THEN   #FUN-980097
  END IF
 
   LET g_memo = ""
##   SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa11 <> 'voucher'
 
   SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang 
   IF not SQLCA.sqlcode AND l_cnt>0 THEN   ## get data from zaa_file
      SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa11 = 'voucher'
      IF l_cnt > 0 THEN   ## voucher
         SELECT count(*) INTO l_cnt FROM zaa_file
              WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04='default' AND 
                    zaa11 = 'voucher' AND zaa10='Y'
          #MOD-570245
         IF l_cnt > 0 THEN  ## customerize
            LET g_zaa10_value = 'Y'
         ELSE
            LET g_zaa10_value = 'N'
         END IF
         CASE cl_db_get_database_type()       #MOD-770068
            WHEN "ORA" 
               LET l_sql = "SELECT count(*) FROM ",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                           "' OR zaa17= '",g_clas CLIPPED,"'))"  #FUN-560079
            WHEN "IFX"
               LET l_sql = "SELECT count(*) FROM table(multiset",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                           "' OR zaa17= '",g_clas CLIPPED,"')))"  #FUN-560079
            WHEN "MSV"
               LET l_sql = "( SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
  	 		         " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
            WHEN "ASE"       #FUN-AA0017
               LET l_sql = " SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
  	 		         " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
         END CASE         #MOD-770068
         PREPARE zaa_pre1 FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err("prepare zaa_cur4: ", SQLCA.SQLCODE, 0)
            #RETURN FALSE
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
            EXIT PROGRAM                           #FUN-560048
 
         END IF
         EXECUTE zaa_pre1 INTO l_cust
 
          IF cl_null(g_bgjob) OR g_bgjob = 'N' OR      ##FUN-570264 #MOD-580124
            (g_bgjob='Y' AND (cl_null(g_rep_user) OR cl_null(g_rep_clas)
             OR cl_null(g_template)))
         THEN
 
            IF l_cust > 1 THEN
               CALL cl_prt_pos_t()    
            ELSE
               SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
               FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10 =
                   g_zaa10_value AND ((zaa04='default' AND zaa17='default') 
                   OR zaa04 =g_user OR zaa17= g_clas )
            END IF
         ELSE         ###   FUN-570264   ###
            SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
            FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang 
             AND zaa10 = g_zaa10_value AND zaa11 = g_template
             AND zaa04 = g_rep_user AND zaa17 = g_rep_clas
         END IF
 
         DECLARE zaa_cur CURSOR FOR
             SELECT zaa02,zaa08,zaa14,zaa16 FROM zaa_file
              WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND 
                    zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value
              ORDER BY zaa02
         FOREACH zaa_cur INTO l_zaa02,l_zaa08,l_zaa14,l_zaa16
            #FUN-560048
            IF SQLCA.SQLCODE THEN
               CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
               EXIT PROGRAM
            END IF
            #END FUN-560048
             LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)         #MOD-530271
            LET l_zaa08_s = l_zaa08 CLIPPED
            LET g_x[l_zaa02] = l_zaa08_s
         END FOREACH
 
         ### for g_page_line ###
          SELECT unique zaa12,zaa19,zaa20,zaa21 into g_page_line,g_left_margin,g_top_margin,g_bottom_margin  #FUN-650017 #No.FUN-6C0048
          FROM zaa_file   #MOD-560029
          WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND 
                zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value
 
          #END MOD-570245
 
         SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = g_prog
         #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF ## TQC-590051 ##
      ELSE
        LET g_xml_rep = l_name CLIPPED,".xml"
        CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
        CALL cl_prt_pos(p_code)
      END IF
   END IF
 
   #TQC-6B0183
   LET l_str = p_code
   IF l_str.subString(4,4) != 'p' AND g_x.getLength() = 0 THEN
      SELECT gay03 INTO l_gay03 FROM gay_file 
        WHERE gay01 = g_rlang AND gayacti = "Y" #AND gay02 = g_rlang #FUN-830021
      LET l_str = g_rlang CLIPPED, ":",l_gay03 CLIPPED
      CALL cl_err_msg(g_prog,'lib-358',l_str,10)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
   END IF
   #END TQC-6B0183
 
   IF g_page_line = 0 or g_page_line is null THEN
      LET g_page_line = 66
   END IF 
   #FUN-650017
   LET g_line = g_page_line
   IF g_left_margin IS NULL THEN
      #LET g_left_margin = 5 #FUN-6C0048
      LET g_left_margin = 0  #FUN-6C0048
   END IF
   #END FUN-650017
   
   #FUN-6C0048 --start--
   IF g_top_margin IS NULL THEN
      LET g_top_margin = 1 #預設報表上邊界為1
   END IF
   IF g_bottom_margin IS NULL THEN
      LET g_bottom_margin = 5 #預設報表下邊界為5
   END IF
   #FUN-6C0048 --end--
   
   #FUN-A20033 -- start --
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   LET g_company = g_company CLIPPED,"[",g_plant CLIPPED,":",l_azp02 CLIPPED,"]"
   #FUN-A20033 -- end --

   RETURN l_name
END FUNCTION
 
 #MOD-530271
##################################################
# Private Func..: TRUE
# Descriptions...: 傳回欄位備註
# Date & Author..: 07/12/19
# Input Parameter: p_zaa08  欄位內容
#                  p_zaa14  欄位屬性
#                  p_zaa16  列印備註(簽核)否
# Return code....: VARCHAR(1000)   欄位備註
# Usage..........: CALL cl_outnam_zab(p_zaa08,p_zaa14,p_zaa16)
#                   RETURNING l_zaa08
# Memo...........:
# Modify.........: No.FUN-7C0058
##################################################
FUNCTION cl_outnam_zab(p_zaa08,p_zaa14,p_zaa16)
DEFINE p_zaa08 LIKE type_file.chr1000          #No.FUN-690005  VARCHAR(1000)
DEFINE p_zaa14 LIKE zaa_file.zaa14           #No.FUN-690005  VARCHAR(1)
DEFINE p_zaa16 LIKE zaa_file.zaa16           #No.FUN-690005  VARCHAR(1)
DEFINE l_zaa08 LIKE type_file.chr1000          #No.FUN-690005  VARCHAR(1000)
DEFINE l_zab05 LIKE zab_file.zab05
DEFINE l_memo  LIKE zab_file.zab05
DEFINE l_sql   STRING                   #MOD-590446
 
      LET l_zaa08 = p_zaa08 CLIPPED
 
      #MOD-590446
      LET l_sql = " SELECT zab05 from zab_file ",
           "WHERE zab01= ? AND zab04=",g_rlang," AND zab03 = ?"
      PREPARE zab_prepare FROM l_sql
      #MOD-590446
 
      IF p_zaa14 = "H" OR p_zaa14 = "I" THEN##報表備註
         IF p_zaa16 = 'Y' THEN
            IF p_zaa14 = "H" THEN
               LET g_memo_pagetrailer = 1
            ELSE
               LET g_memo_pagetrailer = 0
            END IF
            #MOD-590446
            EXECUTE zab_prepare USING l_zaa08,'1' INTO l_zab05
            EXECUTE zab_prepare USING l_zaa08,'2' INTO l_memo  #FUN-580131
            IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN
                LET l_zaa08 = l_zab05
                LET g_memo = l_memo CLIPPED
            END IF
            #END MOD-590446
         ELSE 
            LET g_memo_pagetrailer = 0
            LET l_zaa08 = ""
            LET g_memo  = ""
         END IF
      END IF
      RETURN l_zaa08
END FUNCTION
                
