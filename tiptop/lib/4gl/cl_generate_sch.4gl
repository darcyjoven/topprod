# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_generate_sch
# Descriptions...: 產生sch檔
# ARG............: p_colname即column name
# RETURN code....: 無 
# Usage .........: CALL cl_generate_sch(p_colname) 
# Date & Author..: 05/08/19 By qazzaq
# Modify ........: 06/01/03 By qazzaq TQC-5C0113
#                : 06/04/03 By qazzaq FUN-640001 cl_get_column_info預設資料庫為ds
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_generate_sch(p_tabname,p_colname)
DEFINE l_datatype  LIKE azp_file.azp06   #No.FUN-690005 VARCHAR(15)
DEFINE l_length1   LIKE type_file.num5   #No.FUN-690005 SMALLINT
DEFINE l_length2   LIKE type_file.num5   #No.FUN-690005 SMALLINT
DEFINE l_length    STRING
DEFINE l_tmp       STRING
 
DEFINE p_tabname   LIKE type_file.chr20  #No.FUN-690005 VARCHAR(20)
DEFINE p_colname   LIKE type_file.chr20  #No.FUN-690005 VARCHAR(20)
DEFINE l_top       LIKE gah_file.gah01   #No.FUN-690005 VARCHAR(35)
DEFINE l_tabname   LIKE type_file.chr20  #No.FUN-690005 VARCHAR(20)
DEFINE l_db_type   LIKE type_file.chr3   #No.FUN-690005 VARCHAR(3)
DEFINE l_sql       STRING
DEFINE l_str       STRING
DEFINE l_cmd       LIKE type_file.chr1000#No.FUN-690005 VARCHAR(100)
DEFINE l_idx DYNAMIC ARRAY OF RECORD
           name   LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(20),
           uniq   LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
           feld   LIKE ztc_file.ztc04
           END RECORD
DEFINE l_col DYNAMIC ARRAY OF RECORD
           name   LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(20),
           type   LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(20),
           def    LIKE azp_file.azp06,   #No.FUN-690005 VARCHAR(15),
           gat03  LIKE gat_file.gat03,
           gat04  LIKE gat_file.gat04,
           gat06  LIKE gat_file.gat06,
           zta11  LIKE zta_file.zta11,
           zta12  LIKE zta_file.zta12,
           gaq03  LIKE gaq_file.gaq03,
           gaq05  LIKE gaq_file.gaq05,
           null   LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
           length LIKE cre_file.cre08    #No.FUN-690005 VARCHAR(10)
           END RECORD
DEFINE l_idxfeld_t LIKE type_file.chr20    #No.FUN-690005 VARCHAR(20)
DEFINE l_i         LIKE type_file.num5     #No.FUN-690005 SMALLINT
DEFINE l_n         LIKE type_file.num5     #No.FUN-690005 SMALLINT
DEFINE l_cnt       LIKE type_file.num5     #No.FUN-690005 SMALLINT
DEFINE l_cnt_i     LIKE type_file.num5     #No.FUN-690005 SMALLINT
DEFINE l_cnt_c     LIKE type_file.num5     #No.FUN-690005 SMALLINT
DEFINE l_part RECORD
           part1   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part2   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part3   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part4   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part5   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part6   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part7   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part8   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part9   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part10  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part11  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part12  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part13  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part14  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part15  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
           part16  LIKE type_file.num5     #No.FUN-690005 SMALLINT
           END RECORD
DEFINE l_part_arr ARRAY[16] OF LIKE type_file.num5   #No.FUN-690005 SMALLINT
DEFINE g_err      LIKE type_file.chr1000   #No.FUN-690005 VARCHAR(1000)
DEFINE l_gensql_channel base.channel,
       l_tok            base.StringTokenizer
 
   WHENEVER ERROR CALL cl_err_msg_log   #TQC-5C0113
 
   IF p_tabname is null AND p_colname is null THEN
      RETURN
   END IF
   LET l_db_type=cl_db_get_database_type()
   IF p_tabname is null THEN
      IF l_db_type="IFX" THEN
         LET l_sql="SELECT DISTINCT tabname",
                   "  FROM systables a,syscolumns b ",
                   " WHERE colname='",p_colname CLIPPED,"'",
                   "   AND a.tabid=b.tabid"
         PREPARE cl_generate_sch_getifxtabname FROM l_sql
         EXECUTE cl_generate_sch_getifxtabname INTO l_tabname
         LET l_sql="SELECT DISTINCT tabname,idxname,idxtype,part1,part2,part3,",
                   "       part4,part5,part6,part7,part8,part9,part10,",
                   "       part11,part12,part13,part14,part15,part16 ",
                   "  FROM systables a,syscolumns b, sysindexes c ",
                   " WHERE colname='",p_colname CLIPPED,"'",
                   "   AND a.tabid=c.tabid",
                   "   AND a.tabid=b.tabid"
      ELSE
         LET l_sql="SELECT DISTINCT lower(table_name)",
                   "  FROM user_tab_columns ",
                   " WHERE lower(column_name)='",p_colname CLIPPED,"'",
                   "   AND (table_name LIKE '__/_FILE' ESCAPE '/' OR ",  #TQC-5C0113
                   "        table_name LIKE '___/_FILE' ESCAPE '/' OR ",
                   "        table_name LIKE '____/_FILE' ESCAPE '/' OR  ",
                   "        table_name LIKE 'TC/___/_FILE' ESCAPE '/' OR ",
                   "        table_name LIKE 'TC/____/_FILE' ESCAPE '/' OR ",
                   "        table_name LIKE 'TC/_____/_FILE' ESCAPE '/' OR  ",
                   "        table_name LIKE 'APS%' ) "
         PREPARE cl_generate_sch_getoratabname FROM l_sql
         EXECUTE cl_generate_sch_getoratabname INTO l_tabname
         LET l_sql="SELECT DISTINCT lower(a.table_name),lower(index_name),uniqueness",
                   "  FROM user_indexes a,user_tab_columns b",
                   " WHERE lower(b.column_name)='",p_colname CLIPPED,"'",
                   "   AND a.table_name=b.table_name"
      END IF
   ELSE
      LET l_tabname=p_tabname
      IF l_db_type="IFX" THEN
         LET l_sql="SELECT DISTINCT tabname,idxname,idxtype,part1,part2,part3,",
                   "       part4,part5,part6,part7,part8,part9,part10,",
                   "       part11,part12,part13,part14,part15,part16 ",
                   "  FROM systables a,sysindexes c ",
                   " WHERE tabname='",p_tabname CLIPPED,"'",
                   "   AND a.tabid=c.tabid"
      ELSE
         LET l_sql="SELECT DISTINCT lower(a.table_name),lower(index_name),uniqueness",
                   "  FROM user_indexes a",
                   " WHERE lower(a.table_name)='",p_tabname CLIPPED,"'"
      END IF
   END IF
   DECLARE cl_generate_sch_c1 CURSOR FROM l_sql
 
   LET l_cnt_i=1
   FOREACH cl_generate_sch_c1 INTO l_tabname,l_idx[l_cnt_i].name,
                                   l_idx[l_cnt_i].uniq,l_part.*
 
   LET l_part_arr[1]=l_part.part1
   LET l_part_arr[2]=l_part.part2
   LET l_part_arr[3]=l_part.part3
   LET l_part_arr[4]=l_part.part4
   LET l_part_arr[5]=l_part.part5
   LET l_part_arr[6]=l_part.part6
   LET l_part_arr[7]=l_part.part7
   LET l_part_arr[8]=l_part.part8
   LET l_part_arr[9]=l_part.part9
   LET l_part_arr[10]=l_part.part10
   LET l_part_arr[11]=l_part.part11
   LET l_part_arr[12]=l_part.part12
   LET l_part_arr[13]=l_part.part13
   LET l_part_arr[14]=l_part.part14
   LET l_part_arr[15]=l_part.part15
   LET l_part_arr[16]=l_part.part16
 
   IF l_db_type="IFX" THEN
      LET l_sql="SELECT colname FROM systables,syscolumns ",
                " WHERE tabname='",l_tabname CLIPPED,"'",
                "   AND systables.tabid=syscolumns.tabid ",
                " AND colno = ?"
   ELSE
      LET l_sql="select lower(column_name)",
                "  from user_indexes a,user_ind_columns b",
                " where lower(a.table_name)='",l_tabname CLIPPED,"'",
                "   and lower(a.index_name)='",l_idx[l_cnt_i].name CLIPPED,"'",
                "   and a.index_name=b.index_name",
                " order by column_position"
   END IF
   DECLARE cl_generate_sch_c CURSOR FROM l_sql
 
   IF l_db_type="IFX" THEN
      FOR l_i=1 TO 16
          IF l_part_arr[l_i] IS NULL THEN EXIT FOR END IF
          FOREACH cl_generate_sch_c USING l_part_arr[l_i] INTO l_idxfeld_t
             IF sqlca.sqlcode THEN
                LET g_err="foreach sysindexes error"
                CALL cl_err(g_err CLIPPED,sqlca.sqlcode,1)
                EXIT FOREACH
             END IF
             IF l_idx[l_cnt_i].feld IS NULL THEN
                LET l_idx[l_cnt_i].feld=l_idxfeld_t CLIPPED
             ELSE
                LET l_idx[l_cnt_i].feld=l_idx[l_cnt_i].feld CLIPPED,",",l_idxfeld_t CLIPPED
             END IF
          END FOREACH
      END FOR
   ELSE
      FOREACH cl_generate_sch_c INTO l_idxfeld_t
         IF sqlca.sqlcode THEN
            LET g_err="foreach sysindexes error"
            CALL cl_err(g_err CLIPPED,sqlca.sqlcode,1)
            EXIT FOREACH
         END IF
         IF l_idx[l_cnt_i].feld IS NULL THEN
            LET l_idx[l_cnt_i].feld=l_idxfeld_t CLIPPED
         ELSE
            LET l_idx[l_cnt_i].feld=l_idx[l_cnt_i].feld CLIPPED,",",l_idxfeld_t CLIPPED
         END IF
      END FOREACH
   END IF
   IF l_idx[l_cnt_i].uniq="U" THEN
      LET l_idx[l_cnt_i].uniq="Y"
   ELSE
      LET l_idx[l_cnt_i].uniq="N"
   END IF
   LET l_cnt_i=l_cnt_i+1
   END FOREACH
   CALL l_idx.deleteElement(l_cnt_i)
   LET l_cnt_i=l_cnt_i-1
 
   IF l_db_type="IFX" THEN
      LET l_sql="SELECT colname,coltype,default,gat03,gat04,gat06,zta11,zta12,gaq03,gaq05,b.colno ",
                "  FROM systables a,syscolumns b,OUTER sysdefaults c,",
                      " OUTER gaq_file,OUTER gat_file,OUTER zta_file",
                " WHERE tabname='",l_tabname CLIPPED,"'",
                "   AND a.tabid=b.tabid",
                "   AND b.tabid=c.tabid",
                "   AND b.colno=c.colno",
                "   AND colname=gaq01 ",
                "   AND gaq02='",g_lang CLIPPED,"' ",
                "   AND tabname=gat01 ",
                "   AND gat02='",g_lang CLIPPED,"' ",
                "   AND tabname=zta01 ",
                "   AND zta02='",g_dbs CLIPPED,"' ",
                " ORDER BY b.colno"
   ELSE
      #20091104 by Hiko
      #LET l_sql="SELECT lower(column_name),'',",
      #          "       data_default,gat03,gat04,gat06,zta11,zta12,gaq03,gaq05,nullable ",
      #          "  FROM user_tab_columns,gaq_file,gat_file,zta_file",
      #          " WHERE lower(table_name)='",l_tabname CLIPPED,"'",
      #          "   AND lower(column_name)=gaq01 (+) ",
      #          "   AND gaq02(+)='",g_lang CLIPPED,"' ",
      #          "   AND lower(table_name)=gat01(+)",
      #          "   AND gat02(+)='",g_lang CLIPPED,"' ",
      #          "   AND lower(table_name)=zta01(+)",
      #          "   AND zta02(+)='",g_dbs CLIPPED,"' ",
      #          " ORDER BY column_id"
      LET l_sql="SELECT lower(column_name),'',",
                "       data_default,gat03,gat04,gat06,zta11,zta12,gaq03,gaq05,nullable ",
                "  FROM user_tab_columns ",
                "       LEFT OUTER JOIN gaq_file ON lower(column_name)=gaq01 AND gaq02='",g_lang CLIPPED,"' ",
                "       LEFT OUTER JOIN gat_file ON lower(table_name)=gat01 AND gat02='",g_lang CLIPPED,"' ",
                "       LEFT OUTER JOIN zta_file ON lower(table_name)=zta01 AND zta02='",g_dbs CLIPPED,"' ",
                " WHERE lower(table_name)='",l_tabname CLIPPED,"'",
                " ORDER BY column_id"
   END IF
   DECLARE cl_generate_sch_c2 CURSOR FROM l_sql
 
   LET l_cnt_c=1
   FOREACH cl_generate_sch_c2 INTO l_col[l_cnt_c].*
      IF l_db_type="IFX" THEN
         IF l_col[l_cnt_c].type>=256 THEN
            LET l_col[l_cnt_c].null='Y'
         END IF
         CALL cl_get_column_info('ds',l_tabname,l_col[l_cnt_c].name)
         RETURNING l_col[l_cnt_c].type,l_col[l_cnt_c].length
      ELSE
         IF l_col[l_cnt_c].null='Y' THEN  
            LET l_col[l_cnt_c].null='N'
         ELSE
            LET l_col[l_cnt_c].null='Y'
         END IF
         CALL cl_get_column_info('ds',l_tabname,l_col[l_cnt_c].name)
         RETURNING l_col[l_cnt_c].type,l_col[l_cnt_c].length
      END IF
      LET l_cnt_c=l_cnt_c+1
   END FOREACH
   CALL l_col.deleteElement(l_cnt_c)
   LET l_cnt_c=l_cnt_c-1
   
   LET l_top = UPSHIFT(l_col[1].gat06)
   LET l_top = fgl_getenv(l_top)
   IF l_top IS NULL THEN
      RETURN
   END IF
   LET l_str = l_top CLIPPED,"/sch/",
               l_tabname CLIPPED,".sch"
   LET l_gensql_channel=base.channel.create()
   CALL l_gensql_channel.setdelimiter("")
   CALL l_gensql_channel.openfile(l_str CLIPPED, "w" )
   IF STATUS THEN
      CALL cl_err(l_str,"zta-026",1)
#      LET INT_FLAG=1               #TQC-5C0113
      CALL l_gensql_channel.close()
      RETURN
   ELSE
      IF l_db_type="IFX" THEN
         CALL l_gensql_channel.write("{")
      ELSE
         CALL l_gensql_channel.write("/*")
      END IF
      CALL l_gensql_channel.write("================================================================================")
      LET l_str = "檔案代號:",l_tabname CLIPPED
      CALL l_gensql_channel.write(l_str)
      LET l_str = "檔案名稱:",l_col[1].gat03 CLIPPED
      CALL l_gensql_channel.write(l_str)
      LET l_str = "檔案目的:",l_col[1].gat04 CLIPPED
      CALL l_gensql_channel.write(l_str)
      LET l_str = "上游檔案:",l_col[1].zta11 CLIPPED
      CALL l_gensql_channel.write(l_str)
      LET l_str = "下游檔案:",l_col[1].zta12 CLIPPED
      CALL l_gensql_channel.write(l_str)
      CALL l_gensql_channel.write("============.========================.==========================================")
      IF l_db_type="IFX" THEN
         CALL l_gensql_channel.write("}")
      ELSE
         CALL l_gensql_channel.write("*/")
      END IF
      LET l_str = "create table ",l_tabname CLIPPED
      CALL l_gensql_channel.write(l_str)
      CALL l_gensql_channel.write("(")
      LET l_i=0
      FOR l_cnt=1 TO l_cnt_c
         LET l_i=l_i+1
         IF l_i != l_n THEN
            IF l_cnt=l_cnt_c THEN
               IF l_db_type="IFX" THEN
                  IF l_col[l_cnt].type='datetime' THEN
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED,
                                     " TO ",l_col[l_cnt].type CLIPPED," NOT NULL"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED,
                                     " TO ",l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED,
                                     " TO ",l_col[l_cnt].type CLIPPED
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED,
                                     " TO ",l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"'"
                        END IF
                     END IF
                  ELSE
                     IF l_col[l_cnt].type='char' OR l_col[l_cnt].type='decimal' THEN
                        IF l_col[l_cnt].null='Y' THEN
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") NOT NULL"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL"
                           END IF
                        ELSE
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,")"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"'"
                           END IF
                        END IF
                     ELSE
                        IF l_col[l_cnt].null='Y' THEN
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED," NOT NULL"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL"
                           END IF
                        ELSE
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"'"
                           END IF
                        END IF
                     END IF
                  END IF
               ELSE
                  IF l_col[l_cnt].type='varchar2' OR 
                     l_col[l_cnt].type='char' OR
                     l_col[l_cnt].type='number' THEN
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") NOT NULL"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,")"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"'"
                        END IF
                     END IF
                  ELSE
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," NOT NULL"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"'"
                        END IF
                     END IF
                  END IF
               END IF
            ELSE
               IF l_db_type="IFX" THEN
                  IF l_col[l_cnt].type='datetime' THEN
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED," TO ",
                                       l_col[l_cnt].type CLIPPED," NOT NULL,"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED," TO ",
                                       l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL,"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED," TO ",
                                       l_col[l_cnt].type CLIPPED," ,"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," ",l_col[l_cnt].type CLIPPED," TO ",
                                       l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"',"
                        END IF
                     END IF
                  ELSE
                     IF l_col[l_cnt].type='char' OR l_col[l_cnt].type='decimal' THEN
                        IF l_col[l_cnt].null='Y' THEN
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") NOT NULL,"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL,"
                           END IF
                        ELSE
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,"),"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"',"
                           END IF
                        END IF
                     ELSE
                        IF l_col[l_cnt].null='Y' THEN
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED," NOT NULL,"
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL,"
                           END IF
                        ELSE
                           IF l_col[l_cnt].def IS NULL THEN
                              LET l_cmd=l_col[l_cnt].type CLIPPED,","
                           ELSE
                              LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"',"
                           END IF
                        END IF
                     END IF
                  END IF
               ELSE
                  IF l_col[l_cnt].type='varchar2' OR 
                     l_col[l_cnt].type='char' OR
                     l_col[l_cnt].type='number' THEN
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") NOT NULL,"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL,"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,"),"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED,"(",l_col[l_cnt].length CLIPPED,") DEFAULT '",l_col[l_cnt].def CLIPPED,"',"
                        END IF
                     END IF
                  ELSE
                     IF l_col[l_cnt].null='Y' THEN
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED," NOT NULL,"
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"' NOT NULL,"
                        END IF
                     ELSE
                        IF l_col[l_cnt].def IS NULL THEN
                           LET l_cmd=l_col[l_cnt].type CLIPPED,","
                        ELSE
                           LET l_cmd=l_col[l_cnt].type CLIPPED," DEFAULT '",l_col[l_cnt].def CLIPPED,"',"
                        END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF
         IF l_db_type="IFX" THEN
            IF cl_null(l_col[l_cnt].gaq03) THEN
               LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED
            ELSE
               IF LENGTH(l_cmd) > 25 THEN
                  LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED," {",
                             l_col[l_cnt].gaq03[1,40],"}"
               ELSE
                  LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED,COLUMN 38,"{",
                             l_col[l_cnt].gaq03[1,40],COLUMN 79,"}"
               END IF
            END IF
         ELSE
            IF cl_null(l_col[l_cnt].gaq03) THEN
               LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED
            ELSE
               IF LENGTH(l_cmd) > 25 THEN
                  LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED," /*",
                             l_col[l_cnt].gaq03[1,40],"*/"
               ELSE
                  LET l_str =l_col[l_cnt].name CLIPPED,' ',COLUMN 13,l_cmd CLIPPED,COLUMN 38,"/*",
                             l_col[l_cnt].gaq03[1,40],COLUMN 79,"*/"
               END IF
            END IF
         END IF
         CALL l_gensql_channel.write(l_str)
#         LET l_sql="SELECT gaq05 FROM gaq_file",
#                   " WHERE gaq01='",l_col[l_cnt].name CLIPPED,"'",
#                   "   AND gaq02='",g_lang CLIPPED,"'"
#         PREPARE p_zta_gsql_file_pre1 FROM l_sql
#         EXECUTE p_zta_gsql_file_pre1 INTO l_col[l_cnt].gaq05
#         FREE p_zta_gsql_file_pre1
         IF l_col[l_cnt].gaq05 != l_col[l_cnt].gaq03 THEN
            LET l_tok = base.StringTokenizer.createExt(l_col[l_cnt].gaq05 CLIPPED,"\n","",TRUE)
#            LET l_ln=LENGTH(l_col[l_cnt].gaq05)
            WHILE l_tok.hasMoreTokens()
                  LET l_str = l_tok.nextToken()
                  IF l_str!=l_col[l_cnt].gaq03 THEN
                     IF l_db_type="IFX" THEN
                        LET l_str=COLUMN 38,"{",l_str,COLUMN 79,"}"
                     ELSE
                        LET l_str=COLUMN 38,"/*",l_str,COLUMN 79,"*/"
                     END IF
                     CALL l_gensql_channel.write(l_str)
                  END IF
            END WHILE
         END IF
      END FOR
      CALL l_gensql_channel.write(");")
      CALL l_gensql_channel.write("")
      LET l_i=0
      FOR l_cnt=1 TO l_cnt_i
         LET l_i=l_i+1
         IF l_idx[l_cnt].uniq="Y" THEN
            LET l_str ="create unique index ",l_idx[l_cnt].name CLIPPED," on ",
                       l_tabname CLIPPED," (",l_idx[l_cnt].feld CLIPPED,");"
         ELSE 
            LET l_str ="create        index ",l_idx[l_cnt].name CLIPPED," on ",
                       l_tabname CLIPPED," (",l_idx[l_cnt].feld CLIPPED,");"
         END IF  
         CALL l_gensql_channel.write(l_str)
      END FOR
      IF l_db_type="IFX" THEN
         LET l_str="alter table ",l_tabname CLIPPED," modify lock mode(row);"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant select on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant index on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant update on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant delete on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant insert on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
      ELSE
         LET l_str="grant select on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant index on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant update on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant delete on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
         LET l_str="grant insert on ",l_tabname CLIPPED," to public;"
         CALL l_gensql_channel.write(l_str)
      END IF
      CALL l_gensql_channel.close()
   END IF
END FUNCTION
