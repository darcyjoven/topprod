# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: artt304_sub.4gl
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
 
DEFINE g_org        LIKE rah_file.rahplant
DEFINE g_makeorg    LIKE rah_file.rah01
DEFINE g_saleno     LIKE rah_file.rah02
DEFINE g_teamno     LIKE rai_file.rai03
#DEFINE g_style     LIKE raj_file.raj04
#DEFINE g_item      LIKE raj_file.raj05
#DEFINE g_unit      LIKE raj_file.raj06
DEFINE g_bdate      LIKE rah_file.rah04
DEFINE g_edate      LIKE rah_file.rah05
DEFINE g_btime      LIKE rah_file.rah06
DEFINE g_etime      LIKE rah_file.rah07
DEFINE g_snum       LIKE type_file.num5
DEFINE g_enum       LIKE type_file.num5
DEFINE g_success    LIKE type_file.chr1
DEFINE g_sql        STRING
DEFINE g_dbs        LIKE azp_file.azp03
 
#FUNCTION t304sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_style,p_item,p_unit,p_bdate,p_edate,p_btime,p_etime)
FUNCTION t304sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_bdate,p_edate,p_btime,p_etime)
DEFINE p_type        LIKE type_file.chr1
DEFINE p_org         LIKE rah_file.rahplant
DEFINE p_makeorg     LIKE rah_file.rah01
DEFINE p_saleno      LIKE rah_file.rah02
DEFINE p_teamno      LIKE rai_file.rai03
#DEFINE p_style       LIKE raj_file.raj04
#DEFINE p_item        LIKE raj_file.raj05
#DEFINE p_unit        LIKE raj_file.raj06
DEFINE p_bdate       LIKE rah_file.rah04
DEFINE p_edate       LIKE rah_file.rah05
DEFINE p_btime       LIKE rah_file.rah06
DEFINE p_etime       LIKE rah_file.rah07
 
       WHENEVER ERROR CONTINUE
      #CALL s_showmsg_init()
       LET g_success = 'Y'
       LET g_errno = ''
       IF cl_null(p_type) OR cl_null(p_org) OR
         #cl_null(p_item) OR
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
       SELECT rah01,rah02,rah03,rah04,rah05,rah06,rah07,rahplant FROM rah_file WHERE 1=0 INTO TEMP cx001_temp
       SELECT raj01,raj02,raj03,raj04,raj05,raj06,rajplant FROM raj_file WHERE 1=0 INTO TEMP cx002_temp
       SELECT raj01,raj02,raj03,raj04,raj05,raj06,rajplant FROM raj_file WHERE 1=0 INTO TEMP cx002_temp1
       CASE p_type
        WHEN '3'
          CALL t304sub_chk_n1()
       END CASE
       DROP TABLE cx001_temp
       DROP TABLE cx002_temp
       DROP TABLE cx002_temp1
       IF g_success = 'N' THEN
        # CALL s_showmsg()
          RETURN
       END IF
END FUNCTION
 
FUNCTION t304sub_chk_n1()
DEFINE l_n LIKE type_file.num5
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_raj06 LIKE raj_file.raj06
DEFINE l_raj   RECORD LIKE raj_file.*
DEFINE l_msg   LIKE ze_file.ze03

     DELETE FROM cx001_temp
     LET g_sql = " INSERT INTO cx001_temp ",
                 " SELECT rah01,rah02,rai03,rah04,rah05,rah06,rah07,rahplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rah_file'),",",cl_get_target_table(g_org, 'rai_file')," ",
                 "  WHERE rahplant = '",g_org,"' AND rahacti = 'Y' AND rah11='2' ",
                 "    AND (rah04 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR rah05 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR '",g_bdate,"' BETWEEN rah04 AND rah05 ", 
                 "     OR '",g_edate,"' BETWEEN rah04 AND rah05 )",
                 "    AND rah01=rai01 AND rah02=rai02 AND rahplant=raiplant AND raiacti='Y'", #####
                 "    AND rah01||rah02||rai03||rahplant NOT IN ",
                 "        (SELECT DISTINCT rah01||rah02||rai03||rahplant ",
                 "           FROM ",cl_get_target_table(g_org, 'rah_file'),",",cl_get_target_table(g_org, 'rai_file')," ",
                 "          WHERE rah01 = '",g_makeorg,"' AND rah02 = '",g_saleno,"' AND rahplant = '",g_org,"' ",
                 "            AND rai03 = '",g_teamno,"'  ",  #add
                 "            AND rah01=rai01 AND rah02=rai02 AND rahplant=raiplant ) "  #####
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
        UPDATE cx001_temp SET rah06=rah06[1,2]*60+rah06[4,5],  
                              rah07=rah07[1,2]*60+rah07[4,5]  
        DELETE FROM cx001_temp  
          WHERE (rah05 = g_bdate AND rah07 < g_snum) OR (rah04 = g_edate AND rah06 > g_enum)
     END IF
     SELECT COUNT(*) INTO l_n FROM cx001_temp 
     IF l_n = 0 THEN
        LET g_success = 'Y'
        RETURN
     END IF

     DELETE FROM cx002_temp
     LET g_sql = " INSERT INTO cx002_temp ",
                 " SELECT DISTINCT raj01,raj02,raj03,raj04,ima01,' ',rajplant ",
                 "   FROM ",cl_get_target_table(g_org, 'raj_file'),",",cl_get_target_table(g_org, 'ima_file'),",cx001_temp ",
                 "  WHERE rah01 = raj01 AND rah02 = raj02 AND rahplant = rajplant AND rajacti = 'Y' ",
                 "    AND rah03 = raj03                        ",  #add
                #"    AND ((raj04 = '1' AND raj05 = ima01   )  ",
                #"     OR  (raj04 = '2' AND raj05 = ima131  )  ",
                #"     OR  (raj04 = '3' AND raj05 = ima1004 )  ",
                #"     OR  (raj04 = '4' AND raj05 = ima1005 )  ",
                #"     OR  (raj04 = '5' AND raj05 = ima1006 )  ",
                #"     OR  (raj04 = '6' AND raj05 = ima1007 )  ",
                #"     OR  (raj04 = '7' AND raj05 = ima1008 )  ",
                #"     OR  (raj04 = '8' AND raj05 = ima1009 )) "
                "    AND ((raj04 = '01' AND raj05 = ima01   )  ",#FUN-A80104
                 "     OR  (raj04 = '02' AND raj05 = ima131  )  ",#FUN-A80104
                 "     OR  (raj04 = '03' AND raj05 = ima1004 )  ",#FUN-A80104
                 "     OR  (raj04 = '04' AND raj05 = ima1005 )  ",#FUN-A80104
                 "     OR  (raj04 = '05' AND raj05 = ima1006 )  ",#FUN-A80104
                 "     OR  (raj04 = '06' AND raj05 = ima1007 )  ",#FUN-A80104
                 "     OR  (raj04 = '07' AND raj05 = ima1008 )  ",#FUN-A80104
                 "     OR  (raj04 = '08' AND raj05 = ima1009 )) " #FUN-A80104
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
#####            " SELECT DISTINCT a.raj01,a.raj02,a.raj03,' ',a.raj05,'',a.rajplant FROM cx002_temp a,cx002_temp b ",
#####            "  WHERE 1=1  ", # a.raj01=b.raj01 AND a.raj02=b.raj02 AND a.raj03=b.raj03 AND a.rajplant=b.rajplant ",
#####            "  GROUP BY a.raj01,a.raj02,a.raj03,a.raj05,a.rajplant  ",
#####           #" HAVING COUNT(a.*)=                                  ",
#####            " HAVING COUNT(a.raj04)=                                  ",
#####            "        (SELECT COUNT(DISTINCT b.raj04) FROM cx002_temp b,cx002_temp a    ",
#####           #"          WHERE 1=1                                    ",
#####            "          WHERE a.raj01=b.raj01 AND a.raj02=b.raj02 AND a.raj03=b.raj03 AND a.rajplant=b.rajplant)" 
#####           #"            AND a.raj05=b.raj05  ",
#####           #"          GROUP BY b.raj01,b.raj02,b.raj03,b.rajplant) "
#####           #"         HAVING COUNT(DISTINCT b.raj04)>0 "
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
#####LET g_sql = " INSERT INTO cx001_temp(rah01,rah02,rah03,rah04,rah05,rah06,rah07,rahplant) ",
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
#####   UPDATE cx001_temp SET rah06=rah06[1,2]*60+rah06[4,5],  
#####                         rah07=rah07[1,2]*60+rah07[4,5]  
#####END IF

     DELETE FROM cx002_temp1
     LET g_sql = " INSERT INTO cx002_temp1 ",
                 " SELECT DISTINCT raj01,raj02,raj03,raj04,ima01,' ',rajplant ",
                 "   FROM ",cl_get_target_table(g_org, 'raj_file'),",",cl_get_target_table(g_org, 'ima_file')," ",
                 "  WHERE raj01='",g_makeorg,"' AND raj02 = '",g_saleno,"' AND rajplant = '",g_org,"' AND rajacti = 'Y' ",
                 "    AND raj03 = '",g_teamno,"'               ",  #add
               # "    AND ((raj04 = '1' AND raj05 = ima01   )  ",
               # "     OR  (raj04 = '2' AND raj05 = ima131  )  ",
               # "     OR  (raj04 = '3' AND raj05 = ima1004 )  ",
               # "     OR  (raj04 = '4' AND raj05 = ima1005 )  ",
               # "     OR  (raj04 = '5' AND raj05 = ima1006 )  ",
               # "     OR  (raj04 = '6' AND raj05 = ima1007 )  ",
               # "     OR  (raj04 = '7' AND raj05 = ima1008 )  ",
               # "     OR  (raj04 = '8' AND raj05 = ima1009 )) " 
                 "    AND ((raj04 = '01' AND raj05 = ima01   )  ",#FUN-A80104
                 "     OR  (raj04 = '02' AND raj05 = ima131  )  ",#FUN-A80104
                 "     OR  (raj04 = '03' AND raj05 = ima1004 )  ",#FUN-A80104
                 "     OR  (raj04 = '04' AND raj05 = ima1005 )  ",#FUN-A80104
                 "     OR  (raj04 = '05' AND raj05 = ima1006 )  ",#FUN-A80104
                 "     OR  (raj04 = '06' AND raj05 = ima1007 )  ",#FUN-A80104
                 "     OR  (raj04 = '07' AND raj05 = ima1008 )  ",#FUN-A80104
                 "     OR  (raj04 = '08' AND raj05 = ima1009 )) " #FUN-A80104

     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs5 FROM g_sql
     EXECUTE ins_temp_cs5 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp',SQLCA.sqlcode,1)
        RETURN
     END IF

     LET g_sql = " SELECT DISTINCT cx002_temp.* FROM cx002_temp,cx002_temp1 ",
                 "  WHERE cx002_temp1.raj05=cx002_temp.raj05   "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     DECLARE raj_cs CURSOR FROM g_sql
     FOREACH raj_cs INTO l_raj.raj01,l_raj.raj02,l_raj.raj03,l_raj.raj04,l_raj.raj05,l_raj.raj06,l_raj.rajplant
       IF SQLCA.sqlcode THEN
          LET g_success='N'
          CALL s_errmsg('sel','','raj_file',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_showmsg = l_raj.raj01,"/",l_raj.raj02,"/",l_raj.raj03,"/",l_raj.raj05,"/",l_raj.raj06,"/",l_raj.rajplant
      #CALL s_errmsg('raj01,raj02,raj03,ima01,raj06,rajplant',g_showmsg,'','art-218',1)
       LET g_errno = 'art-218' 
       CALL s_errmsg('raj01,raj02,raj03,ima01,raj06,rajplant',g_showmsg,'',g_errno,1)
       LET g_success = 'N'
     END FOREACH


END FUNCTION
#FUN-A60044 

