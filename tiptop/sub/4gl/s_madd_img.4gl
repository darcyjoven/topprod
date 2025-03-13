# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_madd_img.4gl
# Descriptions...: 新增倉庫庫存明細檔(img_file)
# Date & Author..: 03/06/07 By Apple
# Usage..........: CALL s_madd_img(p_img01,p_img02,p_img03,p_img04,p_img05,
#                                  p_img06,p_date,p_plant) 
# Input Parameter: p_img01   料號 
#                  p_img02   倉庫 
#                  p_img03   儲位 
#                  p_img04   批號 
#                  p_img05   參考號碼 
#                  p_img06   序號
#                  p_date    單據日期
#                  p_plant   機構別
# Return code....: 
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun 增加字段img38/INSERT寫法調整
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.FUN-870007 09/08/18 By Zhangyajun GP5.2img_file增加字段/傳值修改
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980059 09/09/11 By arman  GP5.2架構,修改SUB傳入參數
# Modify.........: No.FUN-980017 09/09/23 By destiny 修改qry的參數
# Modify.........: No.TQC-9A0109 09/10/23 By sunyanchun  post to area 32
# Modify.........: No.FUN-9B0157 09/12/07 By bnlent img_file需要给tra db
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.TQC-A70126 10/08/03 By lilingyu INSERT img_file時出現資料重複的現象
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:FUN-AB0100 10/11/24 By rainy 修正FUN-980059錯誤
# Modify.........: No:TQC-B80057 11/08/04 By pauline 修正TQC-A70126錯誤 
# Modify.........: No:CHI-C50010 12/06/01 By ck2yuan 調撥時,有效日期應拿原本調撥前的有效日期
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680147 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose      #No.FUN-680147 SMALLINT
DEFINE   g_redate        LIKE type_file.dat         #CHI-C50010 add
DEFINE   g_redate_f      LIKE type_file.chr1        #CHI-C50010 add

FUNCTION s_madd_img(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,
#                   p_date,p_azp03)   #No.FUN-870007-mark
                    p_date,p_plant)   #No.FUN-870007
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE p_date       LIKE type_file.dat              #No.FUN-680147 DATE
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE p_azp03      LIKE azp_file.azp03
   DEFINE p_azp01      LIKE azp_file.azp01     #No.FUN-980059
   DEFINE l_azp03      LIKE azp_file.azp03
   DEFINE l_dbs        LIKE azp_file.azp03     #No.FUN-9B0157
   DEFINE l_azp01      LIKE azp_file.azp01     #No.FUN-980059
   DEFINE l_gfe02      LIKE gfe_file.gfe02
   DEFINE l_pja02      LIKE pja_file.pja02
   DEFINE l_row,l_col  LIKE type_file.num5             #No.FUN-680147 SMALLINT
   DEFINE l_sql        LIKE type_file.chr1000          #No.FUN-680147 VARCHAR(300)
   DEFINE p_plant      LIKE type_file.chr20            #No.FUN-870007
   DEFINE l_cnt        LIKE type_file.num5             #TQC-A70126 
   #FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_img01,p_plant) OR NOT s_internal_item( p_img01,p_plant ) THEN
        RETURN
    END IF
   #FUN-A90049 --------------end-------------------------------------

   INITIALIZE l_img.* TO NULL                  #NO.TQC-9A0109
   LET l_img.img01=p_img01                     #料號
   LET l_img.img02=p_img02                     #倉庫
   LET l_img.img03=p_img03                     #儲位
   LET l_img.img04=p_img04                     #批號
   LET l_img.img05=p_img05                     #參號單號
   LET l_img.img06=p_img06                     
 
#No.FUN-870007-start-
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET p_azp03 = g_dbs_new
   LET l_dbs = g_dbs_tra
   LET p_azp01 = p_plant  #No.FUN-980059
#No.FUN-870007--end--
 
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
#  CALL s_locchk1(p_img01,p_img02,p_img03,p_azp03)    #No.FUN-980059
   CALL s_locchk1(p_img01,p_img02,p_img03,p_plant)    #No.FUN-980059 
        RETURNING g_i,l_img.img26
   IF g_i = 0 THEN LET g_errno='N' RETURN END IF
 
 # LET l_sql="SELECT ima25,ima71 FROM ",p_azp03 CLIPPED,".dbo.ima_file",     #TQC-950050 MARK                                           
   #LET l_sql="SELECT ima25,ima71 FROM ",s_dbstring(p_azp03),"ima_file",  #TQC-950050 ADD
   LET l_sql="SELECT ima25,ima71 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
             " WHERE ima01='",l_img.img01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102          
   PREPARE s_ima_pre  FROM l_sql
   DECLARE s_ima_cur  CURSOR FOR s_ima_pre
   OPEN s_ima_cur
   FETCH s_ima_cur INTO l_img09,l_ima71 
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
   LET l_img.img09 =l_img09                     #庫存單位
   LET l_img.img10 =0                           #庫存數量
   LET l_img.img17 =p_date
   LET l_img.img13 =null                        #No.7304
   IF l_ima71 =0
   THEN LET l_img.img18=g_lastdat               #有效日期
   ELSE LET l_img.img13=p_date                  #No.7304 
        LET l_img.img18=p_date  + l_ima71
   END IF
  #CHI-C50010 str add-----
   IF g_redate_f = 'Y'  THEN
      LET l_img.img18 = g_redate
   END IF
  #CHI-C50010 end add-----
   LET l_sql="SELECT ime04,ime05,ime06,ime07,ime09",
            #" FROM ",p_azp03 CLIPPED,".dbo.ime_file",    #TQC-950050 MARK                                                              
             #" FROM ",s_dbstring(p_azp03),"ime_file", #TQC-950050 ADD
             " FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102   
             " WHERE ime01='",p_img02,"'",
             "   AND ime02='",p_img03,"'",
             "   AND imeacti = 'Y' "      #FUN-D40103
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102 
   PREPARE s_ime_pre FROM l_sql
   DECLARE s_ime_cur  CURSOR FOR s_ime_pre 
   OPEN s_ime_cur 
   FETCH s_ime_cur  INTO l_img.img22, l_img.img23, l_img.img24, 
                         l_img.img25, l_img.img26
   
   IF SQLCA.sqlcode  THEN
      LET l_sql = "SELECT imd10,imd11,imd12,imd13,imd08 ",
                 #" FROM ",p_azp03 CLIPPED,".dbo.imd_file",     #TQC-950050 MARK                                                        
                  #" FROM ",s_dbstring(p_azp03),"imd_file",  #TQC-950050 ADD
                  " FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102    
                  " WHERE imd01='",p_img02,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102 
      PREPARE s_imd_pre FROM l_sql
      DECLARE s_imd_cur  CURSOR FOR s_imd_pre 
      OPEN s_imd_cur 
      FETCH s_imd_cur  INTO l_img.img22, l_img.img23, l_img.img24, 
                            l_img.img25, l_img.img26
          IF SQLCA.SQLCODE THEN
             LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
             LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
          END IF
   END IF
   LET l_img.img20=1          LET l_img.img21=1  
   LET l_img.img30=0          LET l_img.img31=0
   LET l_img.img32=0          LET l_img.img33=0
   LET l_img.img34=1          LET l_img.img37=p_date 
   LET g_errno=' '
   IF g_sma.sma892[2,2]='Y' THEN
 
     LET l_row = 8  LET l_col = 29
     OPEN WINDOW s_madd_img_w AT l_row,l_col WITH FORM "sub/42f/s_add_img"
     ATTRIBUTE( STYLE = g_win_style )
 
     CALL cl_ui_locale("s_add_img")
 
     DISPLAY l_img09 TO ima25
     DISPLAY l_ima71 TO ima71  #No.7304
     DISPLAY BY NAME l_img.img09, l_img.img21,
                     l_img.img26, l_img.img13, l_img.img18,   #No.7304
                     l_img.img19, l_img.img36,
                     l_img.img27, l_img.img28, l_img.img35
     INPUT BY NAME l_img.img09, l_img.img21,
                   l_img.img26, l_img.img13, l_img.img18,  #No.7304
                   l_img.img19, l_img.img36,
                   l_img.img27, l_img.img28, l_img.img35
         WITHOUT DEFAULTS
      AFTER FIELD img09
        IF cl_null(l_img.img09) THEN NEXT FIELD img09 END IF
       #LET l_sql="SELECT gfe02 FROM ",p_azp03 CLIPPED,".dbo.gfe_file",    #TQC-950050 MARK                                             
        #LET l_sql="SELECT gfe02 FROM ",s_dbstring(p_azp03),"gfe_file", #TQC-950050 ADD 
        LET l_sql="SELECT gfe02 FROM ",cl_get_target_table(p_plant,'gfe_file'), #FUN-A50102  
				  " WHERE gfe01='",l_img.img09,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102           
   	    PREPARE s_gfe_pre  FROM l_sql
        DECLARE s_gfe_cur  CURSOR FOR s_gfe_pre 
        OPEN s_gfe_cur
        FETCH s_gfe_cur  INTO l_gfe02
           IF STATUS THEN
              CALL cl_err(l_img.img09,'aoo-012',0) NEXT FIELD img09
           END IF
          #LET l_azp03 = s_madd_img_catstr(p_azp03) # 傳回的值為資料庫名稱+":"或資料庫名稱+"." #No.FUN-870007-mark
           LET l_azp03 = s_dbstring(p_azp03)   #No.FUN-870007-
          #LET l_azp01 = s_dbstring(p_azp01)   #No.FUN-980059    #FUN-AB0100 mark
          LET l_azp01 = p_azp01    #FUN-AB0100 
          #CALL s_umfchk1(l_img.img01,l_img.img09,l_img09,l_azp03)  #No.FUN-980059
           CALL s_umfchk1(l_img.img01,l_img.img09,l_img09,l_azp01)  #No.FUN-980059
                RETURNING g_cnt,l_img.img21
                IF g_cnt = 1 THEN 
                     CALL cl_err('','mfg3075',0)
                     NEXT FIELD img09
                 END IF
            DISPLAY BY NAME l_img.img21
      AFTER FIELD img21
        IF cl_null(l_img.img21) THEN NEXT FIELD img21 END IF
        IF l_img.img21=0 THEN NEXT FIELD img21 END IF
 
      AFTER FIELD img13               #No.7304
        IF l_ima71 > 0 THEN
           LET l_img.img18=l_img.img13+l_ima71
           DISPLAY BY NAME l_img.img18
        END IF
 
      AFTER FIELD img18              #No.7304
        IF cl_null(l_img.img18) THEN NEXT FIELD img18 END IF
        IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF
        DISPLAY BY NAME l_img.img18
     
      AFTER FIELD img35            #bugno:7255
        IF NOT cl_null(l_img.img35) THEN
           SELECT * FROM pja_file WHERE pja01=l_img.img35 AND pjaacti = 'Y'
                                    AND pjaclose = 'N'                     #FUN-960038
           #LET l_sql="SELECT pja02 FROM ",p_azp03 CLIPPED,".dbo.pja_file",    #TQC-950050 MARK                                         
            #LET l_sql="SELECT pja02 FROM ",s_dbstring(p_azp03),"pja_file", #TQC-950050 ADD
            LET l_sql="SELECT pja02 FROM ",cl_get_target_table(p_plant,'pja_file'), #FUN-A50102        
                      " WHERE pja01='",l_img.img35,"'",
                      "   AND pjaacti = 'Y'  "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102              
      	   PREPARE s_pja_pre  FROM l_sql
           DECLARE s_pja_cur  CURSOR FOR s_pja_pre 
           OPEN s_pja_cur
           FETCH s_pja_cur  INTO l_pja02
                IF STATUS THEN
                   CALL cl_err(l_img.img35,'apj-005',0)
                   NEXT FIELD img35
                END IF
        END IF
 
        ON KEY(CONTROL-P)
           IF INFIELD(img35) THEN       #bugno:7255
             # Prog. Version..: '5.30.06-13.03.12(0,0,l_img.img35,p_azp03) RETURNING l_img.img35         #No.FUN-980017
              CALL q_mpja(0,0,l_img.img35,p_plant) RETURNING l_img.img35        #No.FUN-980017
#              CALL FGL_DIALOG_SETBUFFER( l_img.img35 )
              DISPLAY BY NAME l_img.img35
              NEXT FIELD img35
           END IF
 
      AFTER INPUT
         IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF    #No.7304
         DISPLAY BY NAME l_img.img18                             #No.7304
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
     END INPUT
     CLOSE WINDOW s_madd_img_w
     IF INT_FLAG THEN LET INT_FLAG=0 LET g_errno='N' RETURN END IF
   END IF
   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF    #No.7304
   LET l_img.imgplant = p_plant  #No.FUN-870007
   SELECT azw02 INTO l_img.imglegal FROM azw_file WHERE azw01=g_plant_new  #No.FUN-870007 

#TQC-A70126 --begin--
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'),
               " WHERE img01 = '",l_img.img01,"'",
               "   AND img02 = '",l_img.img02,"'",
               "   AND img03 = '",l_img.img03,"'",
               "   AND img04 = '",l_img.img04,"'"
#    RUN l_sql                                                      #TQC-B80057  mark
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    #TQC-B80057  add
    CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql       #TQC-B80057  add
    PREPARE img_pre_1 FROM l_sql
    EXECUTE img_pre_1 INTO l_cnt                                    #TQC-B80057  add
    FREE img_pre_1                                                  #TQC-B80057  add
#    DECLARE img_pre_cur CURSOR FOR img_pre_1                       #TQC-B80057  mark
#    FOREACH img_pre_cur INTO l_cnt                                 #TQC-B80057  mark
#       EXIT FOREACH                                                #TQC-B80057  mark
#    END FOREACH                                                    #TQC-B80057  mark
    IF l_cnt = 0 THEN  
#TQC-A70126 --end--
#No.TQC-930155-start-
#   LET l_sql="INSERT INTO ",p_azp03 CLIPPED,".dbo.img_file VALUES",
  #LET l_sql="INSERT INTO ",p_azp03 CLIPPED,".dbo.img_file(",       #TQC-950050 MARK                                                    
   #LET l_sql="INSERT INTO ",s_dbstring(p_azp03),"img_file(",    #TQC-950050 ADD #No.FUN-9B0157 mark  
   #LET l_sql="INSERT INTO ",s_dbstring(l_dbs),"img_file(",     #No.FUN-9B0157 p_azp03-->l_dbs
   LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'img_file'),"(",  #FUN-A50102
             "img01,img02,img03,img04,img05,img06,img07,img08,img09,img10,",
             "img11,img12,img13,img14,img15,img16,img17,img18,img19,img20,",
             "img21,img22,img23,img24,img25,img26,img27,img28,img30,img31,",
             "img32,img33,img34,img35,img36,img37,img38,imgplant,imglegal) VALUES", #No.FUN-870007-add imgplant,imglegal
#No.TQC-930155--end--
   " (?,?,?,?,?,?,?,?,?,?,
      ?,?,?,?,?,?,?,?,?,?,
      ?,?,?,?,?,?,?,?,?,?,
      ?,?,?,?,?,?,?,?,?)"    #No.TQC-930155 #No.FUN-870007-add ?,?
#     ?,?,?,?,?,?)"  #No.TQC-930155
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE s_ins_img_pre   FROM l_sql
   EXECUTE s_ins_img_pre   USING l_img.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins img: ',SQLCA.SQLCODE,1)
      LET g_errno='N' 
   END IF
 END IF     #TQC-A70126
END FUNCTION

FUNCTION s_madd_img_catstr(p_dbs)
DEFINE p_dbs  LIKE azp_file.azp03
 
  FOR g_i=20 TO 1 STEP -1
      IF p_dbs[g_i,g_i]='.'
         THEN RETURN p_dbs
      END IF
  END FOR
  LET p_dbs=p_dbs CLIPPED,'.'
  RETURN p_dbs
END FUNCTION
#CHI-C50010 str add-----
FUNCTION s_mdate_record(p_date,p_flag)
   DEFINE p_date       LIKE type_file.dat
   DEFINE p_flag       LIKE type_file.chr1

   IF p_flag = 'Y' THEN
     LET g_redate_f = 'Y'
     LET g_redate = p_date
   END IF

END FUNCTION
#CHI-C50010 end add-----
