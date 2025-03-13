# Prog. Version..: '5.30.06-13.03.14(00003)'     #
#
# Pattern name...: s_padd_img.4gl
# Descriptions...: 
# Date & Author..: No:FUN-C70087 12/08/01 By Bart
# Modify.........: No.FUN-CC0095 12/12/18 By Bart 使用array
# Modify.........: No.MOD-D30005 13/03/04 By bart insert img前判斷是否已存在
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
 
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
FUNCTION s_padd_img_init()
   CALL g_padd_img.clear()
END FUNCTION 

FUNCTION s_padd_img_data1(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,p_date)
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE p_date       LIKE type_file.dat  
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE l_newno      LIKE type_file.num5

   IF p_img01[1,4] = 'MISC' THEN
      RETURN 
   END IF 
   
   IF cl_null(p_img01) THEN
      RETURN 
   END IF
   IF s_joint_venture( p_img01,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
      RETURN
   END IF
   IF cl_null(p_img02) THEN LET p_img02 = ' ' END IF 
   IF cl_null(p_img03) THEN LET p_img03 = ' ' END IF 
   IF cl_null(p_img04) THEN LET p_img04 = ' ' END IF
   
   LET l_newno = g_padd_img.getLength() + 1
   LET g_padd_img[l_newno].img01=p_img01             
   LET g_padd_img[l_newno].img02=p_img02             
   LET g_padd_img[l_newno].img03=p_img03             
   LET g_padd_img[l_newno].img04=p_img04              
   LET g_padd_img[l_newno].img05=p_img05            
   LET g_padd_img[l_newno].img06=p_img06 
   LET g_padd_img[l_newno].img14=p_date 
   LET g_padd_img[l_newno].img17=p_date 
   LET g_padd_img[l_newno].img37=p_date 
      
   SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
          WHERE ima01=p_img01
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
   LET g_padd_img[l_newno].img09 = l_img09  
   LET g_padd_img[l_newno].img13 = NULL  
   LET g_padd_img[l_newno].img21 = 1
   IF l_ima71 =0 THEN
      LET g_padd_img[l_newno].img18=g_lastdat
   ELSE 
      LET g_padd_img[l_newno].img13=p_date          
      LET g_padd_img[l_newno].img18=p_date +l_ima71
   END IF
   SELECT ime09,ime10,ime11                  
     INTO g_padd_img[l_newno].img26,g_padd_img[l_newno].img27,g_padd_img[l_newno].img28     
     FROM ime_file
    WHERE ime01 = p_img02 AND ime02 = p_img03
       AND imeacti = 'Y'   #FUN-D40103
   IF SQLCA.sqlcode THEN 
      SELECT imd08,imd14,imd15              
        INTO g_padd_img[l_newno].img26,g_padd_img[l_newno].img27,g_padd_img[l_newno].img28   
        FROM imd_file WHERE imd01=p_img02
   END IF
END FUNCTION 

FUNCTION s_padd_img_show1()
   DEFINE l_s_img      DYNAMIC ARRAY OF RECORD
                       img01 LIKE img_file.img01,
                       img02 LIKE img_file.img02,
                       img03 LIKE img_file.img03,
                       img04 LIKE img_file.img04,
                       img09 LIKE img_file.img09,
                       img26 LIKE img_file.img26,
                       img13 LIKE img_file.img13,
                       img18 LIKE img_file.img18,
                       img21 LIKE img_file.img21,
                       img19 LIKE img_file.img19,
                       img36 LIKE img_file.img36,
                       img27 LIKE img_file.img27,
                       img28 LIKE img_file.img28,
                       img35 LIKE img_file.img35
                       END RECORD
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_success    LIKE type_file.chr1 
   DEFINE g_cnt        LIKE type_file.num5 
   DEFINE l_gfe02      LIKE gfe_file.gfe02
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ac         LIKE type_file.num5
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE l_rowno      LIKE type_file.num5
   DEFINE l_cnt        LIKE type_file.num5  #MOD-D30005
   
   LET l_success = 'Y'
   IF g_sma.sma892[2,2]='Y' THEN
      OPEN WINDOW s_padd_img_w AT 04,02 WITH FORM "sub/42f/s_padd_img"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("s_padd_img") 
      
      CALL l_s_img.clear()
      LET g_rec_b = 0
      LET l_i = 1
      LET l_rowno = g_padd_img.getLength()
      IF l_rowno = 0 THEN RETURN END IF 

      FOR l_i = 1 TO l_rowno
         LET l_s_img[l_i].img01 = g_padd_img[l_i].img01
         LET l_s_img[l_i].img02 = g_padd_img[l_i].img02
         LET l_s_img[l_i].img03 = g_padd_img[l_i].img03
         LET l_s_img[l_i].img04 = g_padd_img[l_i].img04
         LET l_s_img[l_i].img09 = g_padd_img[l_i].img09
         LET l_s_img[l_i].img26 = g_padd_img[l_i].img26
         LET l_s_img[l_i].img13 = g_padd_img[l_i].img13
         LET l_s_img[l_i].img18 = g_padd_img[l_i].img18
         LET l_s_img[l_i].img21 = g_padd_img[l_i].img21
         LET l_s_img[l_i].img19 = g_padd_img[l_i].img19
         LET l_s_img[l_i].img36 = g_padd_img[l_i].img36
         LET l_s_img[l_i].img27 = g_padd_img[l_i].img27
         LET l_s_img[l_i].img28 = g_padd_img[l_i].img28
         LET l_s_img[l_i].img35 = g_padd_img[l_i].img35
      END FOR 

      DISPLAY ARRAY l_s_img TO s_img.* ATTRIBUTE( COUNT = g_rec_b)
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
      
      INPUT ARRAY l_s_img FROM s_img.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,UNBUFFERED,
                     INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       BEFORE ROW 
          LET l_ac = ARR_CURR()
          SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
           WHERE ima01=l_s_img[l_ac].img01
          IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
       
       AFTER FIELD img09
          IF cl_null(l_s_img[l_ac].img09) THEN NEXT FIELD img09 END IF
          SELECT gfe02 INTO l_gfe02 FROM gfe_file 
           WHERE gfe01=l_s_img[l_ac].img09 AND gfeacti = 'Y'
          IF SQLCA.sqlcode THEN 
             CALL cl_err3("sel","gfe_file",l_s_img[l_ac].img09,"",SQLCA.sqlcode,"","",0) NEXT FIELD img09 
          END IF
          IF l_s_img[l_ac].img09=l_img09 THEN
             LET l_s_img[l_ac].img21 = 1
          ELSE
             CALL s_umfchk(l_s_img[l_ac].img01,l_s_img[l_ac].img09,l_img09)
                  RETURNING g_cnt,l_s_img[l_ac].img21
             IF g_cnt = 1 THEN 
                CALL cl_err('','mfg3075',0)
                NEXT FIELD img09
             END IF
          END IF
          DISPLAY BY NAME l_s_img[l_ac].img21  
       AFTER FIELD img13             
          IF l_ima71 > 0 THEN
             LET l_s_img[l_ac].img18=l_s_img[l_ac].img13+l_ima71
             DISPLAY BY NAME l_s_img[l_ac].img18
          END IF     

       AFTER FIELD img18          
          IF cl_null(l_s_img[l_ac].img18) THEN NEXT FIELD img18 END IF
          IF l_ima71 = 0 THEN LET l_s_img[l_ac].img18=g_lastdat END IF
          DISPLAY BY NAME l_s_img[l_ac].img18

       AFTER FIELD img35           
          IF NOT cl_null(l_s_img[l_ac].img35) THEN
             SELECT * FROM pja_file WHERE pja01=l_s_img[l_ac].img35 AND pjaacti = 'Y'
                       AND pjaclose = 'N'   
             IF STATUS THEN
                CALL cl_err3("sel","pja_file",l_s_img[l_ac].img35,"",STATUS,"","",0) 
                NEXT FIELD img35
             END IF
          END IF

       ON CHANGE img35 
          LET l_ac = ARR_CURR()
  
       ON ACTION EXIT
          LET l_success = 'N'
          EXIT INPUT 
          
       ON ACTION controlg
          CALL cl_cmdask()
          CONTINUE INPUT

       ON ACTION CANCEL
          LET l_success = 'N' 
          EXIT INPUT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION ACCEPT
          CALL s_showmsg_init()
          FOR l_i = 1 TO l_s_img.getLength()
             INITIALIZE l_img.* TO NULL
             LET l_img.img01 = l_s_img[l_i].img01
             LET l_img.img02 = l_s_img[l_i].img02
             LET l_img.img03 = l_s_img[l_i].img03
             LET l_img.img04 = l_s_img[l_i].img04
             LET l_img.img09 = l_s_img[l_i].img09
             LET l_img.img26 = l_s_img[l_i].img26
             LET l_img.img13 = l_s_img[l_i].img13
             LET l_img.img18 = l_s_img[l_i].img18
             LET l_img.img21 = l_s_img[l_i].img21
             LET l_img.img19 = l_s_img[l_i].img19
             LET l_img.img36 = l_s_img[l_i].img36
             LET l_img.img27 = l_s_img[l_i].img27
             LET l_img.img28 = l_s_img[l_i].img28
             LET l_img.img35 = l_s_img[l_i].img35

             LET l_img.img05 = g_padd_img[l_i].img05
             LET l_img.img06 = g_padd_img[l_i].img06
             LET l_img.img14 = g_padd_img[l_i].img14
             LET l_img.img17 = g_padd_img[l_i].img17
             LET l_img.img37 = g_padd_img[l_i].img37 
             
             SELECT ime04,ime05,ime06,ime07               
               INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25     
               FROM ime_file
              WHERE ime01 = l_img.img02 AND ime02 = l_img.img03
                  AND imeacti = 'Y'       #FUN-D40103
             IF SQLCA.sqlcode THEN 
                SELECT imd10,imd11,imd12,imd13                
                  INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25
                  FROM imd_file WHERE imd01=l_img.img02
                IF SQLCA.SQLCODE THEN 
                   LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
                   LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
                END IF
             END IF
             LET l_img.img20=1         
             LET l_img.img30=0         
             LET l_img.img31=0
             LET l_img.img32=0         
             LET l_img.img33=0
             LET l_img.img34=1     
             LET l_img.img10=0 
             IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
             IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
             IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
             LET l_img.imgplant = g_plant 
             LET l_img.imglegal = g_legal 
             #MOD-D30005---begin
             SELECT COUNT(*) INTO l_cnt
               FROM img_file
              WHERE img01 = l_img.img01
                AND img02 = l_img.img02
                AND img03 = l_img.img03
                AND img04 = l_img.img04
             IF l_cnt = 0 THEN 
             #MOD-D30005---end
                INSERT INTO img_file VALUES (l_img.*)
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   #CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
                   CALL s_errmsg('img01',l_img.img01,'inset img_file:',SQLCA.sqlcode,1)
                   LET l_success = 'N' 
                END IF
             END IF  #MOD-D30005
          END FOR 
          
          EXIT INPUT 
          
    END INPUT 
    IF INT_FLAG THEN 
       LET INT_FLAG=0 
       CLOSE WINDOW s_padd_img_w 
       RETURN FALSE
    END IF
    
    CLOSE WINDOW s_padd_img_w
   END IF 
   CALL s_showmsg()
   IF l_success <> 'Y' THEN
      RETURN FALSE 
   ELSE
      RETURN TRUE 
   END IF 
END FUNCTION
#FUN-CC0095---end

FUNCTION s_padd_img_create()
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
           
   LET g_sql = "img01.img_file.img01,",
	           "img02.img_file.img02,",
	           "img03.img_file.img03,",
	           "img04.img_file.img04,",
               "img05.img_file.img05,",
               "img06.img_file.img06,",
               "img09.img_file.img09,",
               "img13.img_file.img13,",
               "img18.img_file.img18,",
               "img19.img_file.img19,",
               "img21.img_file.img21,",
               "img26.img_file.img26,",
               "img27.img_file.img27,",
               "img28.img_file.img28,",
               "img35.img_file.img35,",
               "img36.img_file.img36,",
               "img14.img_file.img14,",
               "img17.img_file.img17,",
               "img37.img_file.img37 "

   LET l_time = CURRENT HOUR TO FRACTION(5)
   CALL cl_replace_str(l_time, ":", "") RETURNING l_time
   CALL cl_replace_str(l_time, ".", "_") RETURNING l_time
   #LET l_table = 's_padd_img',l_time
   LET l_table = 's_img',g_prog,l_time

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
      CALL cl_err('Create_img_tmp_fail','',0)     
      RETURN '' 
   END IF

   RETURN l_table
END FUNCTION

FUNCTION s_padd_img_data(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,p_date,p_table)
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE p_date       LIKE type_file.dat  
   DEFINE p_table      STRING 
   DEFINE l_check      LIKE type_file.chr1
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71

   IF p_img01[1,4] = 'MISC' THEN
      RETURN 
   END IF 
   
   LET g_sql="SELECT 'Y' ",
	     "  FROM ",p_table CLIPPED,  #g_cr_db_str,
	     " WHERE img01 = '",p_img01,"'",
	     "   AND img02 = '",p_img02,"'",
	     "   AND img03 = '",p_img03,"'",
         "   AND img04 = '",p_img04,"'"
   PREPARE check_img FROM g_sql
   IF STATUS THEN
      CALL cl_err('check_img:',status,1)
      RETURN
   END IF

   LET g_sql = "INSERT INTO ",p_table CLIPPED,  #g_cr_db_str,
	       " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      RETURN
   END IF

   IF cl_null(p_img01) THEN
      RETURN 
   END IF
   IF s_joint_venture( p_img01,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
      RETURN
   END IF
   IF cl_null(p_img02) THEN LET p_img02 = ' ' END IF 
   IF cl_null(p_img03) THEN LET p_img03 = ' ' END IF 
   IF cl_null(p_img04) THEN LET p_img04 = ' ' END IF
   
   LET l_check = 'N'
   EXECUTE check_img INTO l_check
   
   INITIALIZE l_img.* TO NULL
   IF l_check <> 'Y' THEN 
      LET l_img.img01=p_img01             
      LET l_img.img02=p_img02             
      LET l_img.img03=p_img03             
      LET l_img.img04=p_img04              
      LET l_img.img05=p_img05            
      LET l_img.img06=p_img06 
      LET l_img.img14 = p_date 
      LET l_img.img17 = p_date 
      LET l_img.img37 = p_date 
      
      SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
             WHERE ima01=l_img.img01
      IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
      LET l_img.img09 = l_img09  
      LET l_img.img13 = NULL  
      LET l_img.img21 = 1
      IF l_ima71 =0 THEN
         LET l_img.img18=g_lastdat
      ELSE LET l_img.img13=p_date          
         LET l_img.img18=p_date +l_ima71
      END IF
      SELECT ime04,ime05,ime06,ime07,ime09
            ,ime10,ime11                  
        INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26
            ,l_img.img27,l_img.img28     
        FROM ime_file
       WHERE ime01 = p_img02 AND ime02 = p_img03
             AND imeacti = 'Y'   #FUN-D40103
      IF SQLCA.sqlcode THEN 
         SELECT imd10,imd11,imd12,imd13,imd08
               ,imd14,imd15              
           INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25,l_img.img26
               ,l_img.img27,l_img.img28   
           FROM imd_file WHERE imd01=l_img.img02
         IF SQLCA.SQLCODE THEN 
            LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
            LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
         END IF
      END IF
      EXECUTE insert_prep USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,l_img.img05,l_img.img06,
                                l_img.img09,l_img.img13,l_img.img18,l_img.img19,l_img.img21,
                                l_img.img26,l_img.img27,l_img.img28,l_img.img35,l_img.img36,
                                l_img.img14,l_img.img17,l_img.img37
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
	     CALL cl_err('insert cho2_tmp fail:',SQLCA.sqlcode,1)
	     RETURN
      END IF
   END IF 
END FUNCTION 

FUNCTION s_padd_img_show(p_table)
   DEFINE p_table      STRING
   DEFINE l_s_img      DYNAMIC ARRAY OF RECORD
                       img01 LIKE img_file.img01,
                       img02 LIKE img_file.img02,
                       img03 LIKE img_file.img03,
                       img04 LIKE img_file.img04,
                       img09 LIKE img_file.img09,
                       img26 LIKE img_file.img26,
                       img13 LIKE img_file.img13,
                       img18 LIKE img_file.img18,
                       img21 LIKE img_file.img21,
                       img19 LIKE img_file.img19,
                       img36 LIKE img_file.img36,
                       img27 LIKE img_file.img27,
                       img28 LIKE img_file.img28,
                       img35 LIKE img_file.img35
                       END RECORD,
          l_s_img1     RECORD
                       img05 LIKE img_file.img05,
                       img06 LIKE img_file.img06,
                       img14 LIKE img_file.img14,
                       img17 LIKE img_file.img17,
                       img37 LIKE img_file.img37
                       END RECORD 
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_success    LIKE type_file.chr1 
   DEFINE g_cnt        LIKE type_file.num5 
   DEFINE l_gfe02      LIKE gfe_file.gfe02
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ac         LIKE type_file.num5
   DEFINE l_ima71      LIKE ima_file.ima71

   LET l_success = 'Y'
   IF g_sma.sma892[2,2]='Y' THEN
      OPEN WINDOW s_padd_img_w AT 04,02 WITH FORM "sub/42f/s_padd_img"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("s_padd_img") 
      
      LET g_sql="SELECT img01,img02,img03,img04, ",
                "  img09,img26,img13,img18,img21,img19,img36,img27,img28,img35",
	            "  FROM ",p_table CLIPPED, #g_cr_db_str CLIPPED,
                "  ORDER BY img01,img02 DESC "
               
      PREPARE img_tmp_p FROM g_sql
      DECLARE img_tmp_cur CURSOR FOR img_tmp_p

      LET g_sql="SELECT img05,img06,img14,img17,img37 ",
	            "  FROM ",p_table CLIPPED, #g_cr_db_str CLIPPED,
                "  WHERE img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? "
               
      PREPARE img_tmp_p1 FROM g_sql
      DECLARE img_tmp_cur1 CURSOR FOR img_tmp_p1
      
      CALL l_s_img.clear()
      LET g_rec_b = 0
      LET l_i = 1

      FOREACH img_tmp_cur INTO l_s_img[l_i].*
         IF SQLCA.sqlcode THEN
            #CALL cl_err('foreach_tmp:',SQLCA.sqlcode,1)
            CALL s_errmsg('','','foreach tmp:',SQLCA.sqlcode,1)
            LET l_success = 'N'
            EXIT FOREACH
         END IF
         LET l_i = l_i + 1
      END FOREACH
      CALL l_s_img.deleteElement(l_i)

      DISPLAY ARRAY l_s_img TO s_img.* ATTRIBUTE( COUNT = g_rec_b)
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
      
      INPUT ARRAY l_s_img FROM s_img.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,UNBUFFERED,
                     INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       BEFORE ROW 
          LET l_ac = ARR_CURR()
          SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
           WHERE ima01=l_s_img[l_ac].img01
          IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
       
       AFTER FIELD img09
          IF cl_null(l_s_img[l_ac].img09) THEN NEXT FIELD img09 END IF
          SELECT gfe02 INTO l_gfe02 FROM gfe_file 
           WHERE gfe01=l_s_img[l_ac].img09 AND gfeacti = 'Y'
          IF SQLCA.sqlcode THEN 
             CALL cl_err3("sel","gfe_file",l_s_img[l_ac].img09,"",SQLCA.sqlcode,"","",0) NEXT FIELD img09 
          END IF
          IF l_s_img[l_ac].img09=l_img09 THEN
             LET l_s_img[l_ac].img21 = 1
          ELSE
             CALL s_umfchk(l_s_img[l_ac].img01,l_s_img[l_ac].img09,l_img09)
                  RETURNING g_cnt,l_s_img[l_ac].img21
             IF g_cnt = 1 THEN 
                CALL cl_err('','mfg3075',0)
                NEXT FIELD img09
             END IF
          END IF
          DISPLAY BY NAME l_s_img[l_ac].img21  
       AFTER FIELD img13             
          IF l_ima71 > 0 THEN
             LET l_s_img[l_ac].img18=l_s_img[l_ac].img13+l_ima71
             DISPLAY BY NAME l_s_img[l_ac].img18
          END IF     

       AFTER FIELD img18          
          IF cl_null(l_s_img[l_ac].img18) THEN NEXT FIELD img18 END IF
          IF l_ima71 = 0 THEN LET l_s_img[l_ac].img18=g_lastdat END IF
          DISPLAY BY NAME l_s_img[l_ac].img18

       AFTER FIELD img35           
          IF NOT cl_null(l_s_img[l_ac].img35) THEN
             SELECT * FROM pja_file WHERE pja01=l_s_img[l_ac].img35 AND pjaacti = 'Y'
                       AND pjaclose = 'N'   
             IF STATUS THEN
                CALL cl_err3("sel","pja_file",l_s_img[l_ac].img35,"",STATUS,"","",0) 
                NEXT FIELD img35
             END IF
          END IF

       ON CHANGE img35 
          LET l_ac = ARR_CURR()
  
       ON ACTION EXIT
          LET l_success = 'N' 
          EXIT INPUT 
          
       ON ACTION controlg
          CALL cl_cmdask()
          CONTINUE INPUT

       ON ACTION CANCEL
          LET l_success = 'N' 
          EXIT INPUT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION ACCEPT
          CALL s_showmsg_init()
          FOR l_i = 1 TO l_s_img.getLength()
             INITIALIZE l_img.* TO NULL
             LET l_img.img01 = l_s_img[l_i].img01
             LET l_img.img02 = l_s_img[l_i].img02
             LET l_img.img03 = l_s_img[l_i].img03
             LET l_img.img04 = l_s_img[l_i].img04
             LET l_img.img09 = l_s_img[l_i].img09
             LET l_img.img26 = l_s_img[l_i].img26
             LET l_img.img13 = l_s_img[l_i].img13
             LET l_img.img18 = l_s_img[l_i].img18
             LET l_img.img21 = l_s_img[l_i].img21
             LET l_img.img19 = l_s_img[l_i].img19
             LET l_img.img36 = l_s_img[l_i].img36
             LET l_img.img27 = l_s_img[l_i].img27
             LET l_img.img28 = l_s_img[l_i].img28
             LET l_img.img35 = l_s_img[l_i].img35

             FOREACH img_tmp_cur1 
               USING l_img.img01,l_img.img02,l_img.img03,l_img.img04
                INTO l_s_img1.*
                
                LET l_img.img05 = l_s_img1.img05
                LET l_img.img06 = l_s_img1.img06
                LET l_img.img14 = l_s_img1.img14
                LET l_img.img17 = l_s_img1.img17
                LET l_img.img37 = l_s_img1.img37
             END FOREACH   
             
             SELECT ime04,ime05,ime06,ime07               
               INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25     
               FROM ime_file
              WHERE ime01 = l_img.img02 AND ime02 = l_img.img03
               AND imeacti = 'Y'     #FUN-D40103
             IF SQLCA.sqlcode THEN 
                SELECT imd10,imd11,imd12,imd13                
                  INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25
                  FROM imd_file WHERE imd01=l_img.img02
                IF SQLCA.SQLCODE THEN 
                   LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
                   LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
                END IF
             END IF
             LET l_img.img20=1         
             LET l_img.img30=0         
             LET l_img.img31=0
             LET l_img.img32=0         
             LET l_img.img33=0
             LET l_img.img34=1     
             LET l_img.img10=0 
             IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
             IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
             IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
             LET l_img.imgplant = g_plant 
             LET l_img.imglegal = g_legal 
             
             INSERT INTO img_file VALUES (l_img.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                #CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
                CALL s_errmsg('img01',l_img.img01,'inset img_file:',SQLCA.sqlcode,1)
                LET l_success = 'N' 
             END IF
          END FOR 
          
          EXIT INPUT 
          
    END INPUT 
    IF INT_FLAG THEN 
       LET INT_FLAG=0 
       CLOSE WINDOW s_padd_img_w 
       RETURN FALSE
    END IF
    
    CLOSE WINDOW s_padd_img_w
   END IF 
   CALL s_showmsg()
   IF l_success <> 'Y' THEN
      RETURN FALSE 
   ELSE
      RETURN TRUE 
   END IF 
END FUNCTION

FUNCTION s_padd_img_drop(p_table)
   DEFINE p_table      STRING
   
   LET g_sql = "DROP TABLE ",p_table CLIPPED
   PREPARE drop_table FROM g_sql
   IF STATUS THEN
      CALL cl_err('drop table:',status,1)
      RETURN
   END IF
   EXECUTE drop_table
   IF SQLCA.sqlcode THEN
	  CALL cl_err('drop img_tmp fail:',SQLCA.sqlcode,1)
	  RETURN
   END IF 
END FUNCTION 

FUNCTION s_padd_img_del(p_table)
   DEFINE p_table      STRING
   
   LET g_sql = "DELETE FROM ",p_table CLIPPED
   PREPARE del_table FROM g_sql
   IF STATUS THEN
      CALL cl_err('delete table:',status,1)
      RETURN
   END IF
   EXECUTE del_table
   IF SQLCA.sqlcode THEN
	  CALL cl_err('delete img_tmp fail:',SQLCA.sqlcode,1)
	  RETURN
   END IF 
END FUNCTION 
#FUN-C70087
