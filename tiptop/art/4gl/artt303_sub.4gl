# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: artt303_sub.4gl
# Descriptions...: 判斷同一機構+商品+單位只能有一筆促銷資料
# Date & Author..: No.FUN-A60044 2010/06/28 By Cockroach
# Input Parameter: p_type        促銷類型 1：一般促銷 2：組合促銷  3:滿額促銷
#                  p_org         機構別
#                  p_makeorg     制定機構
#                  p_saleno      促銷編號
#                  p_teamno      組別
#                # p_style       資料類型1.產品,2.產品分類,3.類別,4.品牌,5.系列,6.型別,7.規格,8.屬性,9.價格
#                # p_item        代碼   
#                # p_unit        單位       
#                  p_bdate       開始日期
#                  p_edate       結束日期
#                  p_btime       開始時間
#                  p_etime       結束時間
# Modify.........: No.FUN-A80104 10/09/20 By lixia資料類型改為varchar2(2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_org      LIKE rab_file.rabplant
DEFINE g_makeorg  LIKE rab_file.rab01
DEFINE g_saleno   LIKE rab_file.rab02
DEFINE g_teamno   LIKE rag_file.rag04
#DEFINE g_style    LIKE rag_file.rag04
#DEFINE g_item     LIKE rag_file.rag05
#DEFINE g_unit     LIKE rag_file.rag06
DEFINE g_bdate    LIKE rae_file.rae04
DEFINE g_edate    LIKE rae_file.rae05
DEFINE g_btime    LIKE rae_file.rae06
DEFINE g_etime    LIKE rae_file.rae07
DEFINE g_snum     LIKE type_file.num5
DEFINE g_enum     LIKE type_file.num5
DEFINE g_success  LIKE type_file.chr1
DEFINE g_sql      STRING
DEFINE g_dbs      LIKE azp_file.azp03
 
#FUNCTION t303sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_style,p_item,p_unit,p_bdate,p_edate,p_btime,p_etime)
FUNCTION t303sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_bdate,p_edate,p_btime,p_etime)
DEFINE p_type     LIKE type_file.chr1
DEFINE p_org      LIKE rab_file.rabplant
DEFINE p_makeorg  LIKE rab_file.rab01
DEFINE p_saleno   LIKE rab_file.rab02
DEFINE p_teamno   LIKE rag_file.rag04
#DEFINE p_style    LIKE rag_file.rag04
#DEFINE p_item     LIKE rag_file.rag05
#DEFINE p_unit     LIKE rag_file.rag06
DEFINE p_bdate    LIKE rae_file.rae04
DEFINE p_edate    LIKE rae_file.rae05
DEFINE p_btime    LIKE rae_file.rae06
DEFINE p_etime    LIKE rae_file.rae07
 
       WHENEVER ERROR CONTINUE
     # CALL s_showmsg_init()
       LET g_success = 'Y'
     # LET g_errno = ''
       IF cl_null(p_type) OR cl_null(p_org) OR
          cl_null(p_bdate) OR cl_null(p_edate) OR
          cl_null(p_btime) OR cl_null(p_etime) THEN
          RETURN 
       END IF
       LET g_org = p_org
       LET g_makeorg = p_makeorg
       LET g_saleno=p_saleno
       LET g_teamno=p_teamno
      #LET g_style = p_style
      #LET g_item = p_item
      #LET g_unit = p_unit
       LET g_bdate = p_bdate
       LET g_edate = p_edate
       LET g_btime = p_btime
       LET g_etime = p_etime
       LET g_snum = p_btime[1,2]*60 + p_btime[4,5]
       LET g_enum = p_etime[1,2]*60 + p_etime[4,5]
      #SELECT rae01,rae02,rae03,rae04,rae05,rae06,rae07,raeplant FROM rae_file WHERE 1=0 INTO TEMP cx001_temp
      #SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp
      #SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp1
       CASE p_type
        WHEN '2'
          CALL t303sub_chk_n1()
       END CASE
      #DROP TABLE cx001_temp
      #DROP TABLE cx002_temp
      #DROP TABLE cx002_temp1
       IF g_success = 'N' THEN
        # CALL s_showmsg()
          RETURN
       END IF
END FUNCTION
 
FUNCTION t303sub_chk_n1()
DEFINE l_n LIKE type_file.num5
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_rag06 LIKE rag_file.rag06
DEFINE l_rag   RECORD LIKE rag_file.*
DEFINE l_msg   LIKE ze_file.ze03

     DELETE FROM cx001_temp
     LET g_sql = " INSERT INTO cx001_temp ",
                 " SELECT rae01,rae02,raf03,rae04,rae05,rae06,rae07,raeplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rae_file'),",",cl_get_target_table(g_org, 'raf_file')," ",
                 "  WHERE raeplant = '",g_org,"' AND raeacti = 'Y' ",
                 "    AND (rae04 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR rae05 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR '",g_bdate,"' BETWEEN rae04 AND rae05 ", 
                 "     OR '",g_edate,"' BETWEEN rae04 AND rae05 )",
                 "    AND rae01=raf01 AND rae02=raf02 AND raeplant=rafplant ", #####
                 "    AND rae01||rae02||raf03||raeplant NOT IN ",
                 "        (SELECT DISTINCT rae01||rae02||raf03||raeplant ",
                 "           FROM ",cl_get_target_table(g_org, 'rae_file'),",",cl_get_target_table(g_org, 'raf_file')," ",
                 "          WHERE rae01 = '",g_makeorg,"' AND rae02 = '",g_saleno,"' AND raeplant = '",g_org,"' ",
                 "            AND raf03 = '",g_teamno,"'  ",  #add
                 "            AND rae01=raf01 AND rae02=raf02 AND raeplant=rafplant ) "  #####
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs1 FROM g_sql
     EXECUTE ins_temp_cs1 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx001_temp',SQLCA.sqlcode,1)
        RETURN
     END IF
 
     SELECT COUNT(*) INTO l_n FROM cx001_temp 
     IF l_n > 0 THEN
        UPDATE cx001_temp SET rae06=rae06[1,2]*60+rae06[4,5],  
                              rae07=rae07[1,2]*60+rae07[4,5]  
        DELETE FROM cx001_temp  
          WHERE (rae05 = g_bdate AND rae07 < g_snum) OR (rae04 = g_edate AND rae06 > g_enum)
     END IF
     SELECT COUNT(*) INTO l_n FROM cx001_temp 
     IF l_n = 0 THEN
        LET g_success = 'Y'
        RETURN
     END IF

     DELETE FROM cx002_temp
     LET g_sql = " INSERT INTO cx002_temp ",
                 " SELECT DISTINCT rag01,rag02,rag03,rag04,ima01,' ',ragplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rag_file'),",",cl_get_target_table(g_org, 'ima_file'),",cx001_temp ",
                 "  WHERE rae01 = rag01 AND rae02 = rag02 AND raeplant = ragplant AND ragacti = 'Y' ",
                 "    AND rae03 = rag03                        ",  #add
                #"    AND ((rag04 = '1' AND rag05 = ima01   )  ",
                #"     OR  (rag04 = '2' AND rag05 = ima131  )  ",
                #"     OR  (rag04 = '3' AND rag05 = ima1004 )  ",
                #"     OR  (rag04 = '4' AND rag05 = ima1005 )  ",
                #"     OR  (rag04 = '5' AND rag05 = ima1006 )  ",
                #"     OR  (rag04 = '6' AND rag05 = ima1007 )  ",
                #"     OR  (rag04 = '7' AND rag05 = ima1008 )  ",
                #"     OR  (rag04 = '8' AND rag05 = ima1009 )) "
                 "    AND ((rag04 = '01' AND rag05 = ima01   )  ",#FUN-A80104
                 "     OR  (rag04 = '02' AND rag05 = ima131  )  ",#FUN-A80104
                 "     OR  (rag04 = '03' AND rag05 = ima1004 )  ",#FUN-A80104
                 "     OR  (rag04 = '04' AND rag05 = ima1005 )  ",#FUN-A80104
                 "     OR  (rag04 = '05' AND rag05 = ima1006 )  ",#FUN-A80104
                 "     OR  (rag04 = '06' AND rag05 = ima1007 )  ",#FUN-A80104
                 "     OR  (rag04 = '07' AND rag05 = ima1008 )  ",#FUN-A80104
                 "     OR  (rag04 = '08' AND rag05 = ima1009 )) " #FUN-A80104
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs2 FROM g_sql
     EXECUTE ins_temp_cs2 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp',SQLCA.sqlcode,1)
        RETURN
     END IF

#####DELETE FROM cx002_temp1
#####LET g_sql = " INSERT INTO cx002_temp1 ",
#####            " SELECT DISTINCT a.rag01,a.rag02,a.rag03,' ',a.rag05,'',a.ragplant FROM cx002_temp a,cx002_temp b ",
#####            "  WHERE 1=1  ", # a.rag01=b.rag01 AND a.rag02=b.rag02 AND a.rag03=b.rag03 AND a.ragplant=b.ragplant ",
#####            "  GROUP BY a.rag01,a.rag02,a.rag03,a.rag05,a.ragplant  ",
#####           #" HAVING COUNT(a.*)=                                  ",
#####            " HAVING COUNT(a.rag04)=                                  ",
#####            "        (SELECT COUNT(DISTINCT b.rag04) FROM cx002_temp b,cx002_temp a    ",
#####           #"          WHERE 1=1                                    ",
#####            "          WHERE a.rag01=b.rag01 AND a.rag02=b.rag02 AND a.rag03=b.rag03 AND a.ragplant=b.ragplant)" 
#####           #"            AND a.rag05=b.rag05  ",
#####           #"          GROUP BY b.rag01,b.rag02,b.rag03,b.ragplant) "
#####           #"         HAVING COUNT(DISTINCT b.rag04)>0 "
#####        
#####CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
#####CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
#####PREPARE ins_temp_cs3 FROM g_sql
#####EXECUTE ins_temp_cs3 
#####IF SQLCA.sqlcode THEN
#####   LET g_success='N'
#####   CALL s_errmsg('ins','','cx002_temp',SQLCA.sqlcode,1)
#####   RETURN
#####END IF


#####DELETE FROM cx001_temp
#####LET g_sql = " INSERT INTO cx001_temp(rae01,rae02,rae03,rae04,rae05,rae06,rae07,raeplant) ",
#####            " VALUES(g_makeorg,g_saleno,g_teamno,g_bdate,g_edate,g_btime,g_etime,g_org) "
#####CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
#####CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
#####PREPARE ins_temp_cs4 FROM g_sql
#####EXECUTE ins_temp_cs4 
#####IF SQLCA.sqlcode THEN
#####   LET g_success='N'
#####   CALL s_errmsg('ins','','cx001_temp',SQLCA.sqlcode,1)
#####   RETURN
#####END IF

#####SELECT COUNT(*) INTO l_n FROM cx001_temp 
#####IF l_n > 0 THEN
#####   UPDATE cx001_temp SET rae06=rae06[1,2]*60+rae06[4,5],  
#####                         rae07=rae07[1,2]*60+rae07[4,5]  
#####END IF

#####DELETE FROM cx002_temp

     DELETE FROM cx002_temp1
     LET g_sql = " INSERT INTO cx002_temp1 ",
                 " SELECT DISTINCT rag01,rag02,rag03,rag04,ima01,' ',ragplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rag_file'),",",cl_get_target_table(g_org, 'ima_file')," ",
                 "  WHERE rag01='",g_makeorg,"' AND rag02 = '",g_saleno,"' AND ragplant = '",g_org,"' AND ragacti = 'Y' ",
                 "    AND rag03 = '",g_teamno,"'               ",  #add
                #"    AND ((rag04 = '1' AND rag05 = ima01   )  ",
                #"     OR  (rag04 = '2' AND rag05 = ima131  )  ",
                #"     OR  (rag04 = '3' AND rag05 = ima1004 )  ",
                #"     OR  (rag04 = '4' AND rag05 = ima1005 )  ",
                #"     OR  (rag04 = '5' AND rag05 = ima1006 )  ",
                #"     OR  (rag04 = '6' AND rag05 = ima1007 )  ",
                #"     OR  (rag04 = '7' AND rag05 = ima1008 )  ",
                #"     OR  (rag04 = '8' AND rag05 = ima1009 )) " 
                 "    AND ((rag04 = '01' AND rag05 = ima01   )  ",#FUN-A80104
                 "     OR  (rag04 = '02' AND rag05 = ima131  )  ",#FUN-A80104
                 "     OR  (rag04 = '03' AND rag05 = ima1004 )  ",#FUN-A80104
                 "     OR  (rag04 = '04' AND rag05 = ima1005 )  ",#FUN-A80104
                 "     OR  (rag04 = '05' AND rag05 = ima1006 )  ",#FUN-A80104
                 "     OR  (rag04 = '06' AND rag05 = ima1007 )  ",#FUN-A80104
                 "     OR  (rag04 = '07' AND rag05 = ima1008 )  ",#FUN-A80104
                 "     OR  (rag04 = '08' AND rag05 = ima1009 )) " #FUN-A80104

     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs5 FROM g_sql
     EXECUTE ins_temp_cs5 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp',SQLCA.sqlcode,1)
        RETURN
     END IF

     LET g_sql = " SELECT DISTINCT cx002_temp1.* FROM cx002_temp,cx002_temp1 ",
                 "  WHERE cx002_temp1.rag05=cx002_temp.rag05   "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     DECLARE rag_cs CURSOR FROM g_sql
     FOREACH rag_cs INTO l_rag.rag01,l_rag.rag02,l_rag.rag03,l_rag.rag04,l_rag.rag05,l_rag.rag06,l_rag.ragplant
       IF SQLCA.sqlcode THEN
          LET g_success='N'
          CALL s_errmsg('sel','','rag_file',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_showmsg = l_rag.rag01,"/",l_rag.rag02,"/",l_rag.rag03,"/",l_rag.rag05,"/",l_rag.rag06,"/",l_rag.ragplant
       LET g_errno = 'art-218' 
       CALL s_errmsg('rag01,rag02,rag03,ima01,rag06,ragplant',g_showmsg,'',g_errno,1)
       LET g_success = 'N'
     END FOREACH


END FUNCTION
#FUN-A60044 

