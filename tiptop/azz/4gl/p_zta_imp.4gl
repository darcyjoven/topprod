# Prog. Version..: '5.30.06-13.03.12(00000)'     #

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION p_zta_imp(p_std_server)
   DEFINE l_zta  RECORD
              zta01   LIKE  zta_file.zta01,
              zta02   LIKE  zta_file.zta02,
              zta03   LIKE  zta_file.zta03,
              zta04   LIKE  zta_file.zta04,
              zta05   LIKE  zta_file.zta05,
              zta06   LIKE  zta_file.zta06,
              zta07   LIKE  zta_file.zta07,
              zta17   LIKE  zta_file.zta17
          END RECORD,

          l_ztb  RECORD
              ztb01   LIKE  ztb_file.ztb01,
              ztb03   LIKE  ztb_file.ztb03,
              ztb04   LIKE  ztb_file.ztb04,
              ztb08   LIKE  ztb_file.ztb08,
              ztb06   LIKE  ztb_file.ztb06,
              ztb07   LIKE  ztb_file.ztb07,
              ztb05   LIKE  ztb_file.ztb05
          END RECORD,

          l_ztc  RECORD
              ztc01   LIKE  ztc_file.ztc01,
              ztc06   LIKE  ztc_file.ztc06,
              ztc03   LIKE  ztc_file.ztc03,
              ztc04   LIKE  ztc_file.ztc04,
              ztc05   LIKE  ztc_file.ztc05
          END RECORD,
          l_ztc04_t VARCHAR(15),

          l_imp  RECORD
              tabname    VARCHAR(30),
              colname    VARCHAR(30),
              coltype    VARCHAR(15),
              collength  SMALLINT,
              colscale   SMALLINT,
              colno      DECIMAL
          END RECORD
#          l_part RECORD
#                 part1  SMALLINT,
#                 part2  SMALLINT,
#                 part3  SMALLINT,
#                 part4  SMALLINT,
#                 part5  SMALLINT,
#                 part6  SMALLINT,
#                 part7  SMALLINT,
#                 part8  SMALLINT,
#                 part9  SMALLINT,
#                 part10 SMALLINT,
#                 part11 SMALLINT,
#                 part12 SMALLINT,
#                 part13 SMALLINT,
#                 part14 SMALLINT,
#                 part15 SMALLINT,
#                 part16 SMALLINT
#                 END RECORD


   DEFINE l_dbname     VARCHAR(10),
          l_length1    VARCHAR(10),
          l_sql        VARCHAR(500),
	  l_zta01      LIKE zta_file.zta01,
          l_zs03       LIKE zs_file.zs03,
          l_date       DATE,
          i            SMALLINT,
          j            SMALLINT,
          l_a          SMALLINT,
          l_a_f        SMALLINT,
          l_b          SMALLINT,
          l_b_f        SMALLINT,
          p_std_server VARCHAR(10),
          l_c          SMALLINT,
          l_c_f        SMALLINT,
          ch           base.channel,
          l_error_list base.channel,
          l_success    VARCHAR(1),
          l_jump       VARCHAR(1)

   WHENEVER ERROR CONTINUE

   CALL p_zta_imp_sel_db(l_dbname) RETURNING l_dbname
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
#   DATABASE l_dbname

{   DECLARE p_zta_imp CURSOR FOR
      SELECT TABNAME,COLNAME,COLTYPE,COLLENGTH,COLNO
        FROM SYSCOLUMNS, SYSTABLES
       WHERE SYSCOLUMNS.TABID = SYSTABLES.TABID
         AND (TABNAME MATCHES "??_file" OR
              TABNAME MATCHES "???_file" OR
              TABNAME MATCHES "????_file")
#         AND TABNAME != 'zta_file'
#         AND TABNAME != 'ztb_file'
#         AND TABNAME != 'ztc_file'
       ORDER BY TABNAME, COLNO
}
#   LET l_sql="SELECT lower(table_name),lower(column_name),data_type,",
#             "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
#             "       data_scale,column_id",
#             "  FROM user_tab_columns ",
#             " WHERE (lower(table_name) LIKE '__/_file' ESCAPE '/' OR ",
#             "        lower(table_name) LIKE '___/_file' ESCAPE '/' OR ",
#             "        lower(table_name) LIKE '____/_file' ESCAPE '/' ) ",
#             " ORDER BY 1"
   LET l_sql="SELECT lower(table_name),lower(column_name),lower(data_type),",
             "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
             "       data_scale,column_id",
             "  FROM all_tab_columns ",
             " WHERE (lower(table_name) LIKE '__/_file' ESCAPE '/' OR ",
             "        lower(table_name) LIKE '___/_file' ESCAPE '/' OR ",
             "        lower(table_name) LIKE '____/_file' ESCAPE '/' OR ",
             "        lower(table_name) LIKE 'aps%' ) ",
             "   AND lower(owner) = '",l_dbname CLIPPED,"'",
             " ORDER BY 1"
   PREPARE p_zta_imp_pre FROM l_sql
   DECLARE p_zta_imp CURSOR FOR p_zta_imp_pre


   LET l_a=0
   LET l_b=0
   LET l_c=0
   LET l_zta01 = NULL
   LET l_zta.zta02=l_dbname
   #暫時先不設zta03和zta17
   LET l_zta.zta04="amam"
   LET l_zta.zta05=g_today
   LET l_zta.zta06=g_user
   LET l_zta.zta07='T'
   LET l_date=TODAY USING "yymmdd"
   LET l_success='y'
   LET l_jump='n'

#################zta import error list channel start##################
   CALL fgl_getenv("TEMPDIR") RETURNING l_sql
   LET l_sql = l_sql CLIPPED,"/","zta_err_lst"
   LET l_error_list=base.channel.create()
   CALL l_error_list.setdelimiter("")
   CALL l_error_list.openfile(l_sql CLIPPED, "w" )
   CALL l_error_list.write("table_name  db_name  command")

   LET l_sql="$TOP/ora/bin/up_priv.sh ",l_dbname CLIPPED
   RUN l_sql
 
   FOREACH p_zta_imp INTO l_imp.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err("foreach error:",SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     IF l_zta01 != l_imp.tabname OR l_zta01 IS NULL THEN
display l_zta01

        LET ch = base.Channel.create()
        FOR i=1 TO 6
            IF l_zta.zta01[i,i] = '_' THEN
               LET l_sql=l_zta.zta01[1,i-1] 
            END IF 
        END FOR
        LET l_sql="cd $TOP;find -name c_",l_sql CLIPPED,".sql|cut -d'/' -f 2"
        CALL ch.openPipe(l_sql,"r")
        IF NOT ch.read([l_zta.zta03]) THEN
           LET l_zta.zta03=''
        END IF
        CALL ch.close()

        LET l_jump='n'
        LET l_a=l_a+1
        LET l_zta.zta01=l_imp.tabname
        LET l_zta01=l_zta.zta01
        INSERT INTO zta_file(zta01,zta02,zta03,zta04,zta05,zta06,zta07,zta17,zta10)
               VALUES(l_zta.zta01,l_zta.zta02,l_zta.zta03,
                      l_zta.zta04,l_zta.zta05,l_zta.zta06,
                      l_zta.zta07,l_zta.zta17,'Y')
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert zta_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
            LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                      column 22,"insert into zta_file"
            CALL l_error_list.write(l_sql)
            LET l_success='n'
            LET l_jump='y'
            CONTINUE FOREACH
        END IF
        SELECT MAX(zs03)+1 INTO l_zs03
          FROM zs_file
         WHERE zs01=l_zta.zta01
           AND zs02=l_zta.zta02
        IF l_zs03 IS NULL THEN
           LET l_zs03=1
        END IF
        INSERT INTO zs_file 
               VALUES(l_zta.zta01,l_zta.zta02,l_zs03,l_date,'p',
                      'load from systables',g_user,'','Y','N','N','')
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert zs_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
            LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                      column 22,"insert into zs_file"
            CALL l_error_list.write(l_sql)
            LET l_success='n'
            DELETE FROM zta_file 
             WHERE zta01=l_zta.zta01
               AND zta02=l_zta.zta02
            LET l_jump='y'
            CONTINUE FOREACH
        END IF
        LET l_sql="INSERT INTO zs_file@to_std ",
                  "VALUES('",l_zta.zta01 CLIPPED,"','",
                             l_zta.zta02 CLIPPED,"',",
                             l_zs03 CLIPPED,",'",
                             l_date CLIPPED,"','p','load from systables','",
                             g_user CLIPPED,"','','Y','N','N','')"
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert std_server zs_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
            LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                      column 22,"insert into std_server.zs_file"
            CALL l_error_list.write(l_sql)
            LET l_success='n'
            DELETE FROM zta_file 
             WHERE zta01=l_zta.zta01
               AND zta02=l_zta.zta02
            DELETE FROM zs_file
             WHERE zs01=l_zta.zta01
               AND zs02=l_zta.zta02
               AND zs03=l_zs03
            LET l_jump='y'
            CONTINUE FOREACH
        END IF
#############抓ztc基本資料################
        LET l_sql="select distinct lower(a.index_name),uniqueness",
                  "  from all_indexes a,all_ind_columns b",
                  " where lower(a.table_name)='",l_zta.zta01 CLIPPED,"'",
                  "   and lower(a.table_owner)='",l_zta.zta02 CLIPPED,"'",
                  "   and a.index_name=b.index_name",
                  "   and a.table_owner=b.table_owner"
        PREPARE p_zta_imp_pidx FROM l_sql
        IF SQLCA.sqlcode THEN
           CALL cl_err("prepare:",SQLCA.sqlcode,1)
           RETURN
        END IF
        DECLARE p_zta_imp_didx CURSOR FOR p_zta_imp_pidx
        
##########################只有一筆資料,懶得用open故用foreach##########
        FOREACH p_zta_imp_didx INTO l_ztc.ztc03,l_ztc.ztc06
           IF SQLCA.SQLCODE THEN
              CALL cl_err('insert ztc_file:',SQLCA.SQLCODE,1)
              RETURN
           END IF
           LET l_sql="select lower(column_name)",
                     "  from all_indexes a,all_ind_columns b",
                     " where lower(a.table_name)='",l_zta.zta01 CLIPPED,"'",
                     "   and lower(a.table_owner)='",l_zta.zta02 CLIPPED,"'",
                     "   and lower(a.index_name)='",l_ztc.ztc03 CLIPPED,"'",
                     "   and a.index_name=b.index_name",
                     "   and a.table_owner=b.table_owner"
           PREPARE p_zta_imp_ppidx FROM l_sql
           IF SQLCA.sqlcode THEN
              CALL cl_err("prepare:",SQLCA.sqlcode,1)
              RETURN
           END IF
           DECLARE p_zta_imp_ddidx CURSOR FOR p_zta_imp_ppidx
           LET l_ztc.ztc04=''
           FOREACH p_zta_imp_ddidx INTO l_ztc04_t
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('insert ztc_file:',SQLCA.SQLCODE,1)
                 RETURN
              END IF
              IF l_ztc.ztc04 IS NULL THEN
                 LET l_ztc.ztc04=l_ztc04_t CLIPPED
              ELSE
                 LET l_ztc.ztc04=l_ztc.ztc04 CLIPPED,",",l_ztc04_t CLIPPED
              END IF
           END FOREACH
           LET l_ztc.ztc01=l_zta.zta01
           LET l_ztc.ztc05='p'
           IF l_ztc.ztc06="U" THEN
              LET l_ztc.ztc06="Y"
           ELSE
              LET l_ztc.ztc06="N"
           END IF
        
           INSERT INTO ztc_file VALUES(l_zta.zta01,l_zta.zta02,
                  l_ztc.ztc03,l_ztc.ztc04,l_ztc.ztc05,
                  l_ztc.ztc06)
           IF SQLCA.SQLCODE THEN
#              CALL cl_err("insert ztc_file:",SQLCA.SQLCODE,1)
              LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                        column 22,"insert into ztc_file"
              CALL l_error_list.write(l_sql)
              LET l_success='n'
              LET l_jump='y'
              DELETE FROM zta_file 
               WHERE zta01=l_zta.zta01
                 AND zta02=l_zta.zta02
              DELETE FROM zs_file
               WHERE zs01=l_zta.zta01
                 AND zs02=l_zta.zta02
                 AND zs03=l_zs03
                CONTINUE FOREACH
              LET l_sql="DELETE FROM zs_file@to_std ",
                        " WHERE zs01='",l_zta.zta01 CLIPPED,"'",
                        "   AND zs02='",l_zta.zta02 CLIPPED,"'",
                        "   AND zs03=",l_zs03 CLIPPED
              EXECUTE IMMEDIATE l_sql
              DISPLAY SQLCA.SQLCODE
              DELETE FROM ztc_file
               WHERE ztc01=l_zta.zta01
                 AND ztc02=l_zta.zta02
           END IF
        END FOREACH
     END IF

     IF l_jump = 'n' THEN

        INITIALIZE l_ztb.* TO NULL
        LET l_ztb.ztb03=l_imp.colname
        LET l_ztb.ztb04=l_imp.coltype
        LET l_ztb.ztb05='p'
       
        CASE WHEN l_ztb.ztb04 = "varchar2"
                  LET l_length1=l_imp.collength CLIPPED
                  LET l_ztb.ztb08 = l_length1 CLIPPED
             WHEN l_ztb.ztb04 = "number"
                  LET l_length1=l_imp.collength
#                  FOR i=1 TO 10
#                      IF l_length1[i,i]="." THEN
#                         LET l_ztb.ztb08=l_length1[1,i-1]
#                         EXIT FOR
#                      END IF
#                  END FOR
                  LET l_ztb.ztb08=l_length1 CLIPPED
                  LET l_length1=l_imp.colscale CLIPPED
                  IF l_length1<>'0' THEN
                     LET l_ztb.ztb08=l_ztb.ztb08 CLIPPED,",",l_length1 CLIPPED
                  END IF
        END CASE
        INSERT INTO ztb_file VALUES(l_zta.zta01,l_zta.zta02,l_ztb.ztb03,
                                    l_ztb.ztb04,l_ztb.ztb05,l_ztb.ztb06,
                                    l_ztb.ztb07,l_ztb.ztb08)
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert ztb_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
           LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                     column 22,"insert into ztb_file"
           CALL l_error_list.write(l_sql)
           LET l_success='n'
           DELETE FROM zta_file 
            WHERE zta01=l_zta.zta01
              AND zta02=l_zta.zta02
           DELETE FROM zs_file
            WHERE zs01=l_zta.zta01
              AND zs02=l_zta.zta02
              AND zs03=l_zs03
             CONTINUE FOREACH
           LET l_sql="DELETE FROM zs_file@to_std ",
                     " WHERE zs01='",l_zta.zta01 CLIPPED,"'",
                     "   AND zs02='",l_zta.zta02 CLIPPED,"'",
                     "   AND zs03=",l_zs03 CLIPPED
           EXECUTE IMMEDIATE l_sql
           DELETE FROM ztc_file
            WHERE ztc01=l_zta.zta01
              AND ztc02=l_zta.zta02
           DELETE FROM ztb_file
            WHERE ztb01=l_zta.zta01
              AND ztb02=l_zta.zta02
           LET l_jump='y'
           CONTINUE FOREACH
        END IF
     END IF 
   END FOREACH

#################非ds資料庫之synonym table專用 BEGIN##################
   IF l_dbname != 'ds' THEN      
      LET l_sql="select lower(synonym_name),lower(table_owner) ",
                "  from all_synonyms",
                " where lower(owner)='",l_dbname CLIPPED,"'"
      PREPARE p_zta_imp_ps FROM l_sql
      DECLARE p_zta_imp_s CURSOR FOR p_zta_imp_ps
      
      LET l_zta01 = NULL
      LET l_zta.zta02=l_dbname
      #暫時先不設zta03和zta17
      LET l_zta.zta04="amam"
      LET l_zta.zta05=g_today
      LET l_zta.zta06=g_user
      LET l_zta.zta07='S'
      FOREACH p_zta_imp_s INTO l_zta.zta01,l_zta.zta17
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach p_zta_imp_s",SQLCA.SQLCODE,1)
           EXIT FOREACH
        END IF
        INSERT INTO zta_file(zta01,zta02,zta03,zta04,zta05,zta06,zta07,zta17,zta10)
            VALUES(l_zta.zta01,l_zta.zta02,l_zta.zta03,l_zta.zta04,l_zta.zta05,
                   l_zta.zta06,l_zta.zta07,l_zta.zta17,'Y')
        IF SQLCA.SQLCODE THEN
#           CALL cl_err( 'insert zta_file:',SQLCA.SQLCODE,1)
           LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                     column 22,"insert into zta_file(synonym)"
           CALL l_error_list.write(l_sql)
           LET l_success='n'
           CONTINUE FOREACH
        END IF
        SELECT MAX(zs03)+1 INTO l_zs03
          FROM zs_file
         WHERE zs01=l_zta.zta01
           AND zs02=l_zta.zta02
        IF l_zs03 IS NULL THEN
           LET l_zs03=1
        END IF
        LET l_sql="INSERT INTO zs_file ",
                  "VALUES('",l_zta.zta01 CLIPPED,"','",
                             l_zta.zta02 CLIPPED,"',",
                             l_zs03,",'",
                             l_date,"','p','load from systables','",
                             g_user,"','','Y','N','N','')"
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert zs_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
            LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                      column 22,"insert into zs_file"
            CALL l_error_list.write(l_sql)
            LET l_success='n'
            DELETE FROM zta_file 
             WHERE zta01=l_zta.zta01
               AND zta02=l_zta.zta02
            CONTINUE FOREACH
        END IF
        LET l_sql="INSERT INTO zs_file@to_std ",
                  "VALUES('",l_zta.zta01 CLIPPED,"','",
                             l_zta.zta02 CLIPPED,"',",
                             l_zs03 CLIPPED,",'",
                             l_date CLIPPED,"','p','load from systables','",
                             g_user CLIPPED,"','','Y','N','N','')"
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
#           CALL cl_err("insert std_server zs_file:",SQLCA.SQLCODE,1)
#           EXIT FOREACH
            LET l_sql=l_zta.zta01 CLIPPED,column 13,l_zta.zta02 CLIPPED,
                      column 22,"insert into std_server.zs_file"
            CALL l_error_list.write(l_sql)
            LET l_success='n'
            DELETE FROM zta_file 
             WHERE zta01=l_zta.zta01
               AND zta02=l_zta.zta02
            DELETE FROM zs_file
             WHERE zs01=l_zta.zta01
               AND zs02=l_zta.zta02
               AND zs03=l_zs03
            CONTINUE FOREACH
        END IF
      END FOREACH
   END IF
#################非ds資料庫之synonym table專用 END ##################

#   DATABASE ds

   CALL l_error_list.close()
   IF l_success='n' THEN
      LET l_sql = "$TEMPDIR/zta_err_lst"
      CALL cl_prt_v(l_sql)
   END IF

END FUNCTION


FUNCTION p_zta_imp_sel_db(p_dbname)
   DEFINE p_row,p_col   SMALLINT
   DEFINE l_welcome     VARCHAR(1000)
   DEFINE p_dbname_t    VARCHAR(10)
   DEFINE p_dbname      VARCHAR(10)
   DEFINE l_cnt         SMALLINT


    LET p_dbname_t=p_dbname

       LET p_row = 12 LET p_col = 40

       OPEN WINDOW p_zta_imp_w AT p_row,p_col WITH FORM "azz/42f/p_zta_imp"
       ATTRIBUTE(STYLE = g_win_style)
    
       CALL cl_ui_init()

       LET l_welcome ="Please select a DataBase to generate data in p_zta."

       INPUT p_dbname,l_welcome WITHOUT DEFAULTS
         FROM FORMONLY.dbname,FORMONLY.welcome

            BEFORE FIELD dbname
                    IF p_dbname IS NULL THEN
                       # Hiko 2003/05/09 產生查詢畫面的參數初始化.
                       LET p_dbname = 'ds'
                       DISPLAY p_dbname TO dbname
                    END IF

            AFTER FIELD dbname
                    IF p_dbname IS NULL THEN NEXT FIELD dbname END IF
                    SELECT DISTINCT azp03 FROM azp_file WHERE azp03=p_dbname
                    IF STATUS THEN
                       CALL cl_err('sel azp:',STATUS,0) NEXT FIELD dbname
                    END IF

            ON ACTION controlp
                    CASE WHEN INFIELD(dbname)
                       # 產生查詢畫面的參數初始化.
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp4zta"
                       LET g_qryparam.construct = 'N'
                       LET g_qryparam.default1 = p_dbname
                       CALL cl_create_qry() RETURNING p_dbname 
                            DISPLAY p_dbname TO dbname
                            NEXT FIELD dbname
                    END CASE

       ON ACTION locale
           CALL cl_dynamic_locale()

       END INPUT
       IF INT_FLAG THEN 
          {LET INT_FLAG = 0} 
          CLOSE WINDOW p_zta_imp_w
          RETURN p_dbname 
       END IF
       CLOSE WINDOW p_zta_imp_w
       RETURN p_dbname
END FUNCTION
