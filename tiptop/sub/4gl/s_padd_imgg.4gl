# Prog. Version..: '5.30.06-13.03.14(00003)'     #
#
# Pattern name...: s_padd_imgg.4gl
# Descriptions...: 
# Date & Author..: No:FUN-C70087 12/08/01 By Bart
# Modify.........: No.FUN-CC0095 12/12/18 By Bart 使用array
# Modify.........: No.MOD-D30005 13/03/04 By bart insert imgg前判斷是否已存在
# Modify.........: No.MOD-DA0147 13/10/22 By suncx insert imgg時，存在imgg211為空的情況
 
DATABASE ds       
 
GLOBALS "../../config/top.global"  
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE g_sql       STRING 
DEFINE l_table     STRING 
DEFINE g_rec_b     LIKE type_file.num5

#FUN-CC0095---begin
FUNCTION s_padd_imgg_init()
   CALL g_padd_imgg.clear()
END FUNCTION 

FUNCTION s_padd_imgg_data1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg05,p_imgg06)
   DEFINE p_imgg01      LIKE imgg_file.imgg01
   DEFINE p_imgg02      LIKE imgg_file.imgg02
   DEFINE p_imgg03      LIKE imgg_file.imgg03
   DEFINE p_imgg04      LIKE imgg_file.imgg04
   DEFINE p_imgg05      LIKE imgg_file.imgg05
   DEFINE p_imgg06      LIKE imgg_file.imgg06
   DEFINE p_imgg09      LIKE imgg_file.imgg09
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_imgg21      LIKE imgg_file.imgg21
   DEFINE l_ima906      LIKE ima_file.ima906
   DEFINE l_ima907      LIKE ima_file.ima907
   DEFINE l_sw          LIKE type_file.num5
   DEFINE l_newno       LIKE type_file.num5
   DEFINE l_img09       LIKE img_file.img09
   DEFINE l_imgg211     LIKE imgg_file.imgg211

   IF p_imgg01[1,4] = 'MISC' THEN
      RETURN 
   END IF 

   IF cl_null(p_imgg01) OR cl_null(p_imgg09) THEN
      RETURN 
   END IF
   IF s_joint_venture(p_imgg01 ,g_plant) OR NOT s_internal_item(p_imgg01,g_plant) THEN
      RETURN   
   END IF 
   IF cl_null(p_imgg02) THEN LET p_imgg02 = ' ' END IF 
   IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF 
   IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF

   LET l_newno = g_padd_imgg.getLength() + 1
   
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
      CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","",0) 
      RETURN
   END IF
      
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR l_ima25 IS NULL THEN 
      #CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","",0)  
      RETURN
   END IF
   CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
        RETURNING l_sw,l_imgg21 
   IF l_sw  = 1 AND NOT(l_ima906='3' AND p_imgg09 = l_ima907) THEN
      #CALL cl_err('imgg09/ima25','mfg3075',0)
      RETURN
   END IF
   LET g_padd_imgg[l_newno].imgg21 = l_imgg21

   IF cl_null(g_padd_imgg[l_newno].imgg21) THEN LET g_padd_imgg[l_newno].imgg21 = 1 END IF
   IF cl_null(g_padd_imgg[l_newno].imgg211) THEN LET g_padd_imgg[l_newno].imgg211 = 1 END IF
   IF l_ima906 = '2' THEN LET g_padd_imgg[l_newno].imgg00='1' END IF
   IF l_ima906 = '3' THEN LET g_padd_imgg[l_newno].imgg00='2' END IF
   LET g_padd_imgg[l_newno].imgg01 = p_imgg01             
   LET g_padd_imgg[l_newno].imgg02 = p_imgg02             
   LET g_padd_imgg[l_newno].imgg03 = p_imgg03             
   LET g_padd_imgg[l_newno].imgg04 = p_imgg04              
   LET g_padd_imgg[l_newno].imgg05 = p_imgg05            
   LET g_padd_imgg[l_newno].imgg06 = p_imgg06 
   LET g_padd_imgg[l_newno].imgg09 = p_imgg09 
   LET g_padd_imgg[l_newno].imgg10=0
   LET g_padd_imgg[l_newno].imgg20=1
   LET g_padd_imgg[l_newno].imggplant = g_plant
   LET g_padd_imgg[l_newno].imgglegal = g_legal
END FUNCTION 

FUNCTION s_padd_imgg_show1()
   DEFINE l_imgg       RECORD LIKE imgg_file.*
   DEFINE l_success    LIKE type_file.chr1 
   DEFINE l_imgg211    LIKE imgg_file.imgg211
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_ima907     LIKE ima_file.ima907
   DEFINE l_sw         LIKE type_file.num5
   DEFINE l_rowno      LIKE type_file.num5
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_cnt        LIKE type_file.num5  #MOD-D30005
   
   LET l_success = 'Y'
   LET g_rec_b = 0

   CALL s_showmsg_init()
   LET l_rowno = g_padd_imgg.getLength()
   IF l_rowno = 0 THEN RETURN END IF 
   FOR l_i = 1 TO l_rowno 
      SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file WHERE ima01=g_padd_imgg[l_i].imgg01
      IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
         #CALL cl_err3("sel","ima_file",l_imgg.imgg01,"",SQLCA.sqlcode,"","",0) 
         LET l_success = 'N'
         EXIT FOR
      END IF
      
      INITIALIZE l_imgg.* TO NULL
      LET l_imgg.imgg00 = g_padd_imgg[l_i].imgg00
      LET l_imgg.imgg01 = g_padd_imgg[l_i].imgg01
      LET l_imgg.imgg02 = g_padd_imgg[l_i].imgg02
      LET l_imgg.imgg03 = g_padd_imgg[l_i].imgg03
      LET l_imgg.imgg04 = g_padd_imgg[l_i].imgg04
      LET l_imgg.imgg05 = g_padd_imgg[l_i].imgg05
      LET l_imgg.imgg06 = g_padd_imgg[l_i].imgg06
      LET l_imgg.imgg09 = g_padd_imgg[l_i].imgg09
      LET l_imgg.imgg10 = g_padd_imgg[l_i].imgg10
      LET l_imgg.imgg20 = g_padd_imgg[l_i].imgg20
      LET l_imgg.imgg21 = g_padd_imgg[l_i].imgg21
      #LET l_imgg.imgg211 = g_padd_imgg[l_i].imgg211
      LET l_imgg.imggplant = g_padd_imgg[l_i].imggplant
      LET l_imgg.imgglegal = g_padd_imgg[l_i].imgglegal

      SELECT img09 INTO l_img09 
        FROM img_file
       WHERE img01 = g_padd_imgg[l_i].imgg01 AND img02 = g_padd_imgg[l_i].imgg02
         AND img03 = g_padd_imgg[l_i].imgg03  AND img04 = g_padd_imgg[l_i].imgg04
      IF SQLCA.sqlcode OR cl_null(l_img09) THEN
         #CALL cl_err3("sel","img_file",l_imgg.imgg01,l_imgg.imgg02,SQLCA.sqlcode,"","",0) 
         LET l_success = 'N'
         EXIT FOR
      END IF
      CALL s_umfchk(g_padd_imgg[l_i].imgg01,g_padd_imgg[l_i].imgg09,l_img09)
           RETURNING l_sw,l_imgg211
      IF l_sw = 1 AND NOT(l_ima906='3' AND g_padd_imgg[l_i].imgg09 = l_ima907) THEN
         #CALL cl_err('imgg09/img09','mfg3075',0)
         LET l_success = 'N'
         EXIT FOR
      END IF
      IF cl_null(l_imgg211) THEN LET l_imgg211 = 1 END IF      #MOD-DA0147 add
      LET l_imgg.imgg211 = l_imgg211
      #MOD-D30005---begin
      SELECT COUNT(*) INTO l_cnt
        FROM imgg_file
       WHERE imgg01 = l_imgg.imgg01
         AND imgg02 = l_imgg.imgg02
         AND imgg03 = l_imgg.imgg03
         AND imgg04 = l_imgg.imgg04
         AND imgg09 = l_imgg.imgg09
      IF l_cnt = 0 THEN 
      #MOD-D30005---end
         INSERT INTO imgg_file VALUES (l_imgg.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
            CALL s_errmsg('imgg01',l_imgg.imgg01,'inset imgg_file:',SQLCA.sqlcode,1)
            LET l_success = 'N' 
         END IF
       END IF  #MOD-D30005
   END FOR 
          
   CALL s_showmsg()
   IF l_success <> 'Y' THEN
      RETURN FALSE 
   ELSE
      RETURN TRUE 
   END IF 
END FUNCTION
#FUN-CC0095---end

FUNCTION s_padd_imgg_create()
DEFINE l_time       STRING 
DEFINE l_sql        STRING 
DEFINE l_tok_table  base.StringTokenizer
DEFINE l_cnt_dot    LIKE type_file.num5
DEFINE l_cnt_comma  LIKE type_file.num5
DEFINE l_name       STRING
DEFINE l_p          LIKE type_file.num5
DEFINE l_p2         LIKE type_file.num5
DEFINE l_datatype   LIKE ztb_file.ztb04
DEFINE l_length     STRING
DEFINE l_table_name LIKE gac_file.gac05
DEFINE l_field_name LIKE gac_file.gac06
DEFINE l_alias_name LIKE gac_file.gac06
           
   LET g_sql = "imgg00.imgg_file.imgg00,",
               "imgg01.imgg_file.imgg01,",
	           "imgg02.imgg_file.imgg02,",
	           "imgg03.imgg_file.imgg03,",
	           "imgg04.imgg_file.imgg04,",
               "imgg05.imgg_file.imgg05,",
               "imgg06.imgg_file.imgg06,",
               "imgg09.imgg_file.imgg09,",
               "imgg10.imgg_file.imgg10,",
               "imgg20.imgg_file.imgg20,",
               "imgg21.imgg_file.imgg21,",
               "imgg211.imgg_file.imgg211,",
               "imggplant.imgg_file.imggplant,",
               "imgglegal.imgg_file.imgglegal"

   LET l_time = CURRENT HOUR TO FRACTION(5)
   CALL cl_replace_str(l_time, ":", "") RETURNING l_time
   CALL cl_replace_str(l_time, ".", "_") RETURNING l_time
   #LET l_table = 's_padd_imgg',l_time
   LET l_table = 's_imgg',g_prog,l_time

   LET l_tok_table = base.StringTokenizer.create(g_sql,".")
   LET l_cnt_dot = l_tok_table.countTokens()
   LET l_tok_table = base.StringTokenizer.create(g_sql,",")
   LET l_cnt_comma = l_tok_table.countTokens()

   LET l_sql = ""
   WHILE l_tok_table.hasMoreTokens()
       LET l_name = l_tok_table.nextToken()
       LET l_p = l_name.getIndexOf(".",1)
       LET l_p2 = l_name.getIndexOf(".",l_p+1)
       LET l_alias_name = l_name.subString(1,l_p-1)
       LET l_table_name = l_name.subString(l_p+1,l_p2-1)
       LET l_field_name = l_name.subString(l_p2+1,l_name.getLength())

       CALL cl_get_column_info('ds',l_table_name,l_field_name)
       RETURNING l_datatype,l_length
       
       IF NOT cl_null(l_sql) THEN
          LET l_sql = l_sql,","
       END IF
       IF l_datatype = "smallint" OR l_datatype = "integer" OR l_datatype = "date"
          OR l_datatype = "datetime"  
          OR l_datatype = "blob"  OR l_datatype = "byte"   
       THEN
           LET l_sql = l_sql, l_alias_name CLIPPED," ",l_datatype
       ELSE
           LET l_sql = l_sql, l_alias_name CLIPPED," ",l_datatype,
                       "(",l_length,")"
       END IF
   END WHILE
   LET l_sql = "(",l_sql,")"
   
   LET g_sql = " CREATE TABLE ",l_table,l_sql CLIPPED
   PREPARE create_prep FROM g_sql 
   EXECUTE create_prep   
   IF SQLCA.SQLCODE THEN
      CALL cl_err('Create_imgg_tmp_fail','',0)     
      RETURN '' 
   END IF

   RETURN l_table
END FUNCTION

FUNCTION s_padd_imgg_data(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg05,p_imgg06,p_table)
   DEFINE p_imgg01      LIKE imgg_file.imgg01
   DEFINE p_imgg02      LIKE imgg_file.imgg02
   DEFINE p_imgg03      LIKE imgg_file.imgg03
   DEFINE p_imgg04      LIKE imgg_file.imgg04
   DEFINE p_imgg05      LIKE imgg_file.imgg05
   DEFINE p_imgg06      LIKE imgg_file.imgg06
   DEFINE p_imgg09      LIKE imgg_file.imgg09
   DEFINE p_table       STRING 
   DEFINE l_check       LIKE type_file.chr1
   DEFINE l_imgg        RECORD LIKE imgg_file.*
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_imgg21      LIKE imgg_file.imgg21
   DEFINE l_ima906      LIKE ima_file.ima906
   DEFINE l_ima907      LIKE ima_file.ima907
   DEFINE l_sw          LIKE type_file.num5

   IF p_imgg01[1,4] = 'MISC' THEN
      RETURN 
   END IF 
   
   LET g_sql="SELECT 'Y' ",
	     "  FROM ",p_table CLIPPED,  #g_cr_db_str,
	     " WHERE imgg01 = '",p_imgg01,"'",
	     "   AND imgg02 = '",p_imgg02,"'",
	     "   AND imgg03 = '",p_imgg03,"'",
         "   AND imgg04 = '",p_imgg04,"'",
         "   AND imgg09 = '",p_imgg09,"'"
   PREPARE check_imgg FROM g_sql
   IF STATUS THEN
      CALL cl_err('check_img:',status,1)
      RETURN
   END IF

   LET g_sql = "INSERT INTO ",p_table CLIPPED, #g_cr_db_str,
	       " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      RETURN
   END IF

   IF cl_null(p_imgg01) OR cl_null(p_imgg09) THEN
      RETURN 
   END IF
   IF s_joint_venture(p_imgg01 ,g_plant) OR NOT s_internal_item(p_imgg01,g_plant) THEN
      RETURN   
   END IF 
   IF cl_null(p_imgg02) THEN LET p_imgg02 = ' ' END IF 
   IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF 
   IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF
   
   LET l_check = 'N'
   EXECUTE check_imgg INTO l_check
   
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
      CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","",0) 
      RETURN
   END IF

   INITIALIZE l_imgg.* TO NULL
   IF l_check <> 'Y' THEN 
      SELECT ima25 INTO l_ima25 FROM ima_file
       WHERE ima01=p_imgg01
      IF SQLCA.sqlcode OR l_ima25 IS NULL THEN 
         CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","",0)  
         RETURN
      END IF
      CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
           RETURNING l_sw,l_imgg21 
      IF l_sw  = 1 AND NOT(l_ima906='3' AND p_imgg09 = l_ima907) THEN
         CALL cl_err('imgg09/ima25','mfg3075',0)
         RETURN
      END IF
      LET l_imgg.imgg21 = l_imgg21

      IF cl_null(l_imgg.imgg21) THEN LET l_imgg.imgg21 = 1 END IF
      IF cl_null(l_imgg.imgg211) THEN LET l_imgg.imgg211 = 1 END IF
      IF l_ima906 = '2' THEN LET l_imgg.imgg00='1' END IF
      IF l_ima906 = '3' THEN LET l_imgg.imgg00='2' END IF
      LET l_imgg.imgg01 = p_imgg01             
      LET l_imgg.imgg02 = p_imgg02             
      LET l_imgg.imgg03 = p_imgg03             
      LET l_imgg.imgg04 = p_imgg04              
      LET l_imgg.imgg05 = p_imgg05            
      LET l_imgg.imgg06 = p_imgg06 
      LET l_imgg.imgg09 = p_imgg09 
      LET l_imgg.imgg10=0
      LET l_imgg.imgg20=1
      LET l_imgg.imggplant = g_plant
      LET l_imgg.imgglegal = g_legal

      EXECUTE insert_prep USING l_imgg.imgg00,l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,l_imgg.imgg05,
                                l_imgg.imgg06,l_imgg.imgg09,l_imgg.imgg10,l_imgg.imgg20,l_imgg.imgg21,l_imgg.imgg211,
                                l_imgg.imggplant,l_imgg.imgglegal

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
	     CALL cl_err('insert cho2_tmp fail:',SQLCA.sqlcode,1)
	     RETURN
      END IF
   END IF 
END FUNCTION 

FUNCTION s_padd_imgg_show(p_table)
   DEFINE p_table      STRING
   DEFINE l_imgg       RECORD
                       imgg00 LIKE imgg_file.imgg00,
                       imgg01 LIKE imgg_file.imgg01,
                       imgg02 LIKE imgg_file.imgg02,
                       imgg03 LIKE imgg_file.imgg03,
                       imgg04 LIKE imgg_file.imgg04,
                       imgg05 LIKE imgg_file.imgg05,
                       imgg06 LIKE imgg_file.imgg06,
                       imgg09 LIKE imgg_file.imgg09,
                       imgg10 LIKE imgg_file.imgg10,
                       imgg20 LIKE imgg_file.imgg20,
                       imgg21 LIKE imgg_file.imgg21,
                       imgg211 LIKE imgg_file.imgg211,
                       imggplant LIKE imgg_file.imggplant,
                       imgglegal LIKE imgg_file.imgglegal
                       END RECORD
   DEFINE l_imgg_i     RECORD LIKE imgg_file.*
   DEFINE l_success    LIKE type_file.chr1 
   DEFINE l_imgg211     LIKE imgg_file.imgg211
   DEFINE l_img09       LIKE img_file.img09
   DEFINE l_ima906      LIKE ima_file.ima906
   DEFINE l_ima907      LIKE ima_file.ima907
   DEFINE l_sw          LIKE type_file.num5
   
   LET l_success = 'Y'

      LET g_sql="SELECT imgg00,imgg01,imgg02,imgg03,imgg04,imgg05,imgg06, ",
                "  imgg09,imgg10,imgg20,imgg21,imgg211,imggplant,imgglegal ",
	            "  FROM ",p_table CLIPPED, #g_cr_db_str CLIPPED,
                "  ORDER BY imgg01,imgg02 DESC "
               
      PREPARE imgg_tmp_p FROM g_sql
      DECLARE imgg_tmp_cur CURSOR FOR imgg_tmp_p
      
      LET g_rec_b = 0

      CALL s_showmsg_init()
      FOREACH imgg_tmp_cur INTO l_imgg.*
         IF SQLCA.sqlcode THEN
            #CALL cl_err('foreach_tmp:',SQLCA.sqlcode,1)
            CALL s_errmsg('','','foreach tmp:',SQLCA.sqlcode,1)
            LET l_success = 'N'
            EXIT FOREACH
         END IF

         SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file WHERE ima01=l_imgg.imgg01
         IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
            #CALL cl_err3("sel","ima_file",l_imgg.imgg01,"",SQLCA.sqlcode,"","",0) 
            LET l_success = 'N'
            EXIT FOREACH
         END IF
         
         INITIALIZE l_imgg_i.* TO NULL
         LET l_imgg_i.imgg00 = l_imgg.imgg00
         LET l_imgg_i.imgg01 = l_imgg.imgg01
         LET l_imgg_i.imgg02 = l_imgg.imgg02
         LET l_imgg_i.imgg03 = l_imgg.imgg03
         LET l_imgg_i.imgg04 = l_imgg.imgg04
         LET l_imgg_i.imgg05 = l_imgg.imgg05
         LET l_imgg_i.imgg06 = l_imgg.imgg06
         LET l_imgg_i.imgg09 = l_imgg.imgg09
         LET l_imgg_i.imgg10 = l_imgg.imgg10
         LET l_imgg_i.imgg20 = l_imgg.imgg20
         LET l_imgg_i.imgg21 = l_imgg.imgg21
         #LET l_imgg_i.imgg211 = l_imgg.imgg211
         LET l_imgg_i.imggplant = l_imgg.imggplant
         LET l_imgg_i.imgglegal = l_imgg.imgglegal

         SELECT img09 INTO l_img09 
           FROM img_file
         WHERE img01 = l_imgg.imgg01 AND img02 = l_imgg.imgg02
           AND img03 = l_imgg.imgg03  AND img04 = l_imgg.imgg04
         IF SQLCA.sqlcode OR cl_null(l_img09) THEN
            #CALL cl_err3("sel","img_file",l_imgg.imgg01,l_imgg.imgg02,SQLCA.sqlcode,"","",0) 
            LET l_success = 'N'
            EXIT FOREACH
         END IF
         CALL s_umfchk(l_imgg.imgg01,l_imgg.imgg09,l_img09)
              RETURNING l_sw,l_imgg211
         IF l_sw = 1 AND NOT(l_ima906='3' AND l_imgg.imgg09 = l_ima907) THEN
            #CALL cl_err('imgg09/img09','mfg3075',0)
            LET l_success = 'N'
            EXIT FOREACH
         END IF
         LET l_imgg_i.imgg211 = l_imgg211
             
         INSERT INTO imgg_file VALUES (l_imgg_i.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
            CALL s_errmsg('imgg01',l_imgg.imgg01,'inset imgg_file:',SQLCA.sqlcode,1)
            LET l_success = 'N' 
         END IF
       END FOREACH  
          
   CALL s_showmsg()
   IF l_success <> 'Y' THEN
      RETURN FALSE 
   ELSE
      RETURN TRUE 
   END IF 
END FUNCTION

FUNCTION s_padd_imgg_drop(p_table)
   DEFINE p_table      STRING
   
   LET g_sql = "DROP TABLE ",p_table CLIPPED
   PREPARE drop_table FROM g_sql
   IF STATUS THEN
      CALL cl_err('drop table:',status,1)
      RETURN
   END IF
   EXECUTE drop_table
   IF SQLCA.sqlcode THEN
	  CALL cl_err('drop imgg_tmp fail:',SQLCA.sqlcode,1)
	  RETURN
   END IF 
END FUNCTION 

FUNCTION s_padd_imgg_del(p_table)
   DEFINE p_table      STRING
   
   LET g_sql = "DELETE FROM ",p_table CLIPPED
   PREPARE del_table FROM g_sql
   IF STATUS THEN
      CALL cl_err('del table:',status,1)
      RETURN
   END IF
   EXECUTE del_table
   IF SQLCA.sqlcode THEN
	  CALL cl_err('del imgg_tmp fail:',SQLCA.sqlcode,1)
	  RETURN
   END IF 
END FUNCTION 
#FUN-C70087
