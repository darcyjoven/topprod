# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name ..: s_ins_coe                  
# DESCRIPTION....: 產生合同進口材料檔(coe_file)
# Parmeter.......: p_key  申請單號(coc01)
#                  p_cmd  0->acoi300 1->acoi301
# Date & Autor...: 00/05/04 By Kammy
# Modify.........: No.MOD-490398 04/11/17 By Danny  
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-740287 07/04/30 By Carol p_zaa未建立資料會出現error->不用cl_outname() 了  
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910088 12/01/11 By chenjing 增加数量栏位小数取位
# Modify.........: No.TQC-C20547 12/03/02 By yuhuabao 點選Action[進口材料資料維護]後,會自動關閉程式

 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE 
   g_key  LIKE coc_file.coc01,
   l_coc  RECORD LIKE coc_file.*,
   l_coe  RECORD LIKE coe_file.*,
   l_name LIKE type_file.chr20                  #No.FUN-680069 VARCHAR(20)
DEFINE g_zaa04_value  LIKE zaa_file.zaa04   #TQC-C20547 add
DEFINE g_zaa10_value  LIKE zaa_file.zaa10   #TQC-C20547 add
DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #TQC-C20547 add
DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #TQC-C20547 add
 
FUNCTION s_ins_coe(p_key,p_cmd)
   DEFINE p_key    LIKE coc_file.coc01
   DEFINE p_cmd    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   DEFINE l_cod03  LIKE cod_file.cod03 
   DEFINE l_cod041 LIKE cod_file.cod041       
   DEFINE l_cod04  LIKE cod_file.cod04          #No.MOD-490398
   DEFINE l_cod05  LIKE cod_file.cod05
   DEFINE l_cod10  LIKE cod_file.cod10
   DEFINE l_coc08  LIKE coc_file.coc08
   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
   DEFINE sr  RECORD 
              con03  LIKE con_file.con03,
              con04  LIKE con_file.con04,
              con05  LIKE con_file.con05,
              con06  LIKE con_file.con06,
              con07  LIKE con_file.con07,
              con08  LIKE con_file.con08,       #No.MOD-490398
              qty    LIKE oeb_file.oeb12        #No.FUN-680069 DEC(12,3)
              END RECORD
 
   SELECT MAX(coe01) INTO g_key FROM coe_file WHERE coe01=p_key
   IF p_cmd='1' AND NOT cl_null(g_key) THEN
      IF NOT cl_confirm('aco-003') THEN RETURN END IF
   END IF
#  IF p_cmd='0' AND NOT cl_null(g_key) THEN RETURN END IF   
 
   WHENEVER ERROR CONTINUE
   DROP TABLE coe_tmp
#No.FUN-680069-begin
   CREATE TEMP TABLE coe_tmp(
              con03  LIKE con_file.con03,
              con04  LIKE con_file.con04,
              con05  LIKE con_file.con05,
              con06  LIKE con_file.con06,
              con07  LIKE con_file.con07,
              con08  LIKE con_file.con08,
              qty    LIKE coe_file.coe09)
#No.FUN-680069-end
   IF STATUS THEN                                                               
      CALL cl_err('create tmp',STATUS,0) RETURN             
   END IF      
   #-----------------------------------------------------------------
   SELECT * INTO l_coc.* FROM coc_file WHERE coc01=p_key
                                         AND cocacti !='N' #010807 增
    
   INITIALIZE l_coe.* TO NULL
   LET g_success='Y' 
   LET g_key = p_key
    
   BEGIN WORK
    #No.MOD-490398
   IF p_cmd = '1' THEN 
      DELETE FROM coe_file WHERE coe01=p_key
   END IF
    #No.MOD-490398 END 
 
    #No.MOD-490398
   LET l_sql = " SELECT con03,con04,con05,con06,con07,con08,0  ",
               "  FROM con_file,com_file ",
               "  WHERE con01 = com01 ",
               "    AND con013= com02",      
               "    AND con08 = com03",      
               "    AND con01 = ? ",
               "    AND com02 = ? ",
               "    AND com03 = ? ",        
               "    AND comacti !='N' ",  #010806增
               " ORDER BY con03"
    #No.MOD-490398 END
   PREPARE con_pre FROM l_sql
   DECLARE con_cs CURSOR FOR con_pre
   
    #No.MOD-490398
   DECLARE cod_cs CURSOR FOR 
    SELECT cod03,cod041,cod04,cod05,cod10 FROM cod_file WHERE cod01=p_key
   FOREACH cod_cs INTO l_cod03,l_cod041,l_cod04,l_cod05,l_cod10
      IF SQLCA.sqlcode THEN 
         CALL cl_err('cod_cs',SQLCA.sqlcode,0) EXIT FOREACH 
      END IF
      FOREACH con_cs USING l_cod03,l_cod041,l_cod04 INTO sr.*   
          IF SQLCA.sqlcode THEN 
             CALL cl_err('con_cs',SQLCA.sqlcode,0) EXIT FOREACH 
          END IF
          LET sr.qty = l_cod05 * (sr.con05/(1-(sr.con06/100)))
          INSERT INTO coe_tmp VALUES(sr.*)
      END FOREACH
   END FOREACH
    #No.MOD-490398 END
 
#  CALL cl_outnam('acoi300') RETURNING l_name   #TQC-740287 mark
   CALL acoi300_outnam() RETURNING l_name       #TQC-C20547 add
   START REPORT inscoe_rep TO 'acoi300.out'     #TQC-740287 l_name->acoi300.out
   DECLARE coe_tmp_cs CURSOR FOR 
    SELECT * FROM coe_tmp  ORDER BY con03,con04,con05,con06,con07
   FOREACH coe_tmp_cs INTO sr.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('coe_cs',SQLCA.sqlcode,0) EXIT FOREACH 
      END IF
      OUTPUT TO REPORT inscoe_rep(sr.*)
   END FOREACH
   FINISH REPORT inscoe_rep
 
   #回寫單頭進口總值
   SELECT SUM(coe08) INTO l_coc08 FROM coe_file
    WHERE coe01=p_key
   IF cl_null(l_coc08) THEN LET l_coc08=0 END IF
   UPDATE coc_file SET coc08=l_coc08
    WHERE coc01=p_key
      AND cocacti !='N' #010807 增
   IF STATUS THEN
#      CALL cl_err('upd coc08:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",p_key,"",STATUS,"","upd coc08:",0) #NO.TQC-660045
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE 
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
END FUNCTION
 
REPORT inscoe_rep(sr)
   DEFINE sr  RECORD
              con03  LIKE con_file.con03,
              con04  LIKE con_file.con04,
              con05  LIKE con_file.con05,
              con06  LIKE con_file.con06,
              con07  LIKE con_file.con07,
              con08  LIKE con_file.con08,        #No.MOD-490398
              qty    LIKE oeb_file.oeb12         #No.FUN-680069 DEC(12,3)
              END RECORD 
    DEFINE m_coe      RECORD LIKE coe_file.*      #No.MOD-490398
 
   OUTPUT TOP MARGIN g_top_margin 
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr.con03
 
   FORMAT  
      AFTER GROUP OF sr.con03
         INITIALIZE l_coe.* TO NULL
         LET l_coe.coe01= g_key
         SELECT MAX(coe02)+1 INTO l_coe.coe02 FROM coe_file
          WHERE coe01=l_coe.coe01
         IF cl_null(l_coe.coe02) THEN LET l_coe.coe02=1 END IF
         LET l_coe.coe03=sr.con03
          LET l_coe.coe04=sr.con08              #No.MOD-490398
         LET l_coe.coe05= GROUP SUM(sr.qty)
         LET l_coe.coe06=sr.con04
         LET l_coe.coe05 = s_digqty(l_coe.coe05,l_coe.coe06)     #FUN-910088--add--
 
         SELECT cof03 INTO l_coe.coe07 FROM cof_file
          WHERE cof01 = sr.con03
            AND cof02 = l_coc.coc02
         IF cl_null(l_coe.coe07) THEN LET l_coe.coe07 = 0 END IF
  
         LET l_coe.coe051= 0
         LET l_coe.coe08 = l_coe.coe05 * l_coe.coe07
         LET l_coe.coe09 = 0 
         LET l_coe.coe091= 0 
         LET l_coe.coe10 = 0 
         LET l_coe.coe101= 0 
         LET l_coe.coe102= 0 
         LET l_coe.coe103= 0 
         LET l_coe.coe104= 0 
         LET l_coe.coe105= 0  
         LET l_coe.coe106= 0  
         LET l_coe.coe107= 0               #No.MOD-490398
         LET l_coe.coe108= 0               #No.MOD-490398
         LET l_coe.coe109= 0               #No.MOD-490398
         LET l_coe.coe11 = sr.con07
         LET l_coe.coeplant = g_plant  #FUN-980002
         LET l_coe.coelegal = g_legal  #FUN-980002
  
          #No.MOD-490398
         SELECT * INTO m_coe.* FROM coe_file 
          WHERE coe01 = g_key AND coe03 = sr.con03
         IF STATUS THEN 
            INSERT INTO coe_file VALUES (l_coe.*)
            IF STATUS THEN 
 #              CALL cl_err('ins coe',STATUS,1) #No.TQC-660045
                CALL cl_err3("ins","coe_file",l_coe.coe01,l_coe.coe02,STATUS,"","ins coe",1) #NO.TQC-660045
                LET g_success='N'  
            END IF
         ELSE
            LET l_coe.coe08 = (l_coe.coe05 + m_coe.coe10) * l_coe.coe07
 
            UPDATE coe_file SET coe05 = l_coe.coe05,
                                coe08 = l_coe.coe08
             WHERE coe01 = l_coe.coe01 AND coe03 = sr.con03
            IF STATUS THEN 
#               CALL cl_err('upd coe',STATUS,1)  #No.TQC-660045
                CALL cl_err3("upd","coe_file",l_coe.coe01,sr.con03,STATUS,"","upd coe",1) #NO.TQC-660045
                LET g_success='N'  
            END IF
         END IF
          #No.MOD-490398 END 
END REPORT 
#TQC-C20547 ----------- ADD ------------ BEGIN
FUNCTION acoi300_outnam()
   DEFINE l_name            LIKE type_file.chr20,
          l_sw              LIKE type_file.chr1,
          l_n               LIKE type_file.num5,
          l_waitsec         LIKE type_file.num5,
          l_buf             LIKE type_file.chr6,
          l_n2              LIKE type_file.num5
   DEFINE p_code                LIKE zz_file.zz01,
          l_chr                 LIKE type_file.chr1,
          l_cnt                 LIKE type_file.num5,
          l_zaa02               LIKE type_file.num5,
          l_zaa08               LIKE type_file.chr1000,
          l_cmd                 LIKE type_file.chr1000,
          l_zaa08_s             STRING,
          l_zaa14               LIKE zaa_file.zaa14,
          l_zaa16               LIKE zaa_file.zaa16,
          l_cust                LIKE type_file.num5,
          l_sql                 STRING
   DEFINE l_gay03               LIKE gay_file.gay03
   DEFINE l_str                 STRING
   DEFINE l_azp02               LIKE azp_file.azp02


   SELECT zz06 INTO l_sw FROM zz_FILE WHERE zz01 = g_prog
   IF l_sw = '1' THEN
      LET l_name = g_prog CLIPPED,'.out'
   ELSE
      SELECT zz16,zz24  INTO l_n,l_waitsec FROM zz_FILE WHERE zz01 = g_prog
      IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
      LET l_n = l_n + 1
      IF l_n > 30000 THEN  LET l_n = 0  END IF
      LET l_buf = l_n USING "&&&&&&"
      IF g_aza.aza49 = '1' THEN   #01r-09r
         LET l_name = g_prog CLIPPED,".0",l_buf[6,6],"r"
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
         LET l_name = g_prog CLIPPED,".",l_buf[5,6],"r"
      END IF
   END IF
   UPDATE zz_file SET zz16 = l_n WHERE zz01 = g_prog
   LET g_memo = ""
   SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang
   IF not SQLCA.sqlcode AND l_cnt>0 THEN   ## get data from zaa_file
      SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa11 = 'voucher'
      IF l_cnt > 0 THEN   ## voucher
         SELECT count(*) INTO l_cnt FROM zaa_file
              WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04='default' AND
                    zaa11 = 'voucher' AND zaa10='Y'
         IF l_cnt > 0 THEN  ## customerize
            LET g_zaa10_value = 'Y'
         ELSE
            LET g_zaa10_value = 'N'
         END IF
         CASE cl_db_get_database_type()
            WHEN "ORA"
               LET l_sql = "SELECT count(*) FROM ",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"'))"
            WHEN "IFX"
               LET l_sql = "SELECT count(*) FROM table(multiset",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"')))"
            WHEN "MSV"
               LET l_sql = "( SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
            WHEN "ASE"
               LET l_sql = " SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
         END CASE
         PREPARE zaa_pre1 FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err("prepare zaa_cur4: ", SQLCA.SQLCODE, 0)
            #RETURN FALSE
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         END IF
         EXECUTE zaa_pre1 INTO l_cust
          IF cl_null(g_bgjob) OR g_bgjob = 'N' OR
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
         ELSE
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
            IF SQLCA.SQLCODE THEN
               CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
               EXIT PROGRAM
            END IF
            LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)
            LET l_zaa08_s = l_zaa08 CLIPPED
            LET g_x[l_zaa02] = l_zaa08_s
         END FOREACH
         ### for g_page_line ###
          SELECT unique zaa12,zaa19,zaa20,zaa21 into g_page_line,g_left_margin,g_top_margin,g_bottom_margin
          FROM zaa_file   #MOD-560029
          WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND
                zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value

         SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = g_prog
      ELSE
        LET g_xml_rep = l_name CLIPPED,".xml"
        CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
        CALL cl_prt_pos(p_code)
      END IF
   END IF
   LET l_str = p_code
   IF l_str.subString(4,4) != 'p' AND g_x.getLength() = 0 THEN
      SELECT gay03 INTO l_gay03 FROM gay_file
        WHERE gay01 = g_rlang AND gayacti = "Y"
      LET l_str = g_rlang CLIPPED, ":",l_gay03 CLIPPED
      CALL cl_err_msg(g_prog,'lib-358',l_str,10)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF g_page_line = 0 or g_page_line is null THEN
      LET g_page_line = 66
   END IF
   LET g_line = g_page_line
   IF g_left_margin IS NULL THEN
      LET g_left_margin = 0
   END IF

   IF g_top_margin IS NULL THEN
      LET g_top_margin = 1 #預設報表上邊界為1
   END IF
   IF g_bottom_margin IS NULL THEN
      LET g_bottom_margin = 5 #預設報表下邊界為5
   END IF

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   LET g_company = g_company CLIPPED,"[",g_plant CLIPPED,":",l_azp02 CLIPPED,"]"
   RETURN l_name
END FUNCTION
#TQC-C20547 ----------- ADD ------------ END
