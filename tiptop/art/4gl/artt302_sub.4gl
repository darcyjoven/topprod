# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: artt302_sub.4gl
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
# Modify.........: No.MOD-B90039 11/09/05 By suncx g_teamno類型定義錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_org      LIKE rab_file.rabplant
DEFINE g_makeorg  LIKE rab_file.rab01
DEFINE g_saleno   LIKE rab_file.rab02
#DEFINE g_teamno   LIKE rad_file.rad04
DEFINE g_teamno   LIKE rad_file.rad03 #MOD-B90039
#DEFINE g_style    LIKE rad_file.rad04
#DEFINE g_item     LIKE rad_file.rad05
#DEFINE g_unit     LIKE rad_file.rad06
DEFINE g_bdate    LIKE rac_file.rac12
DEFINE g_edate    LIKE rac_file.rac13
DEFINE g_btime    LIKE rac_file.rac14
DEFINE g_etime    LIKE rac_file.rac15
DEFINE g_snum     LIKE type_file.num5
DEFINE g_enum     LIKE type_file.num5
DEFINE g_success  LIKE type_file.chr1
DEFINE g_sql      STRING
DEFINE g_dbs      LIKE azp_file.azp03
 
#FUNCTION t302sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_style,p_item,p_unit,p_bdate,p_edate,p_btime,p_etime)
FUNCTION t302sub_chk(p_type,p_org,p_makeorg,p_saleno,p_teamno,p_bdate,p_edate,p_btime,p_etime)
DEFINE p_type     LIKE type_file.chr1
DEFINE p_org      LIKE rab_file.rabplant
DEFINE p_makeorg  LIKE rab_file.rab01
DEFINE p_saleno   LIKE rab_file.rab02
DEFINE p_teamno   LIKE rad_file.rad04
#DEFINE p_style    LIKE rad_file.rad04
#DEFINE p_item     LIKE rad_file.rad05
#DEFINE p_unit     LIKE rad_file.rad06
DEFINE p_bdate    LIKE rac_file.rac12
DEFINE p_edate    LIKE rac_file.rac13
DEFINE p_btime    LIKE rac_file.rac14
DEFINE p_etime    LIKE rac_file.rac15
 
       WHENEVER ERROR CONTINUE
       CALL s_showmsg_init()
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
       SELECT rac01,rac02,rac03,rac12,rac13,rac14,rac15,racplant FROM rac_file WHERE 1=0 INTO TEMP cx001_temp
       SELECT rad01,rad02,rad03,rad04,rad05,rad06,radplant FROM rad_file WHERE 1=0 INTO TEMP cx002_temp
       SELECT rad01,rad02,rad03,rad04,rad05,rad06,radplant FROM rad_file WHERE 1=0 INTO TEMP cx002_temp1
       SELECT rad01,rad02,rad03,rad04,rad05,rad06,radplant FROM rad_file WHERE 1=0 INTO TEMP cx002_temp2
       CASE p_type
        WHEN '1'
          CALL t302sub_chk_n1()
       END CASE
       DROP TABLE cx001_temp
       DROP TABLE cx002_temp
       DROP TABLE cx002_temp1
       DROP TABLE cx002_temp2
       IF g_success = 'N' THEN
          CALL s_showmsg()
          RETURN
       END IF
END FUNCTION
 
FUNCTION t302sub_chk_n1()
DEFINE l_n LIKE type_file.num5
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_rad06 LIKE rad_file.rad06
DEFINE l_rad   RECORD LIKE rad_file.*
DEFINE l_msg   LIKE ze_file.ze03

     DELETE FROM cx001_temp
     LET g_sql = " INSERT INTO cx001_temp ",
                 " SELECT rac01,rac02,rac03,rac12,rac13,rac14,rac15,racplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rac_file')," ",
                 "  WHERE racplant = '",g_org,"' AND racacti = 'Y' ",
                 "    AND (rac12 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR rac13 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                 "     OR '",g_bdate,"' BETWEEN rac12 AND rac13 ", 
                 "     OR '",g_edate,"' BETWEEN rac12 AND rac13 )",
                 "    AND rac01||rac02||rac03||racplant NOT IN ",
                 "        (SELECT DISTINCT rac01||rac02||rac03||racplant ",
                 "           FROM ",cl_get_target_table(g_org, 'rac_file')," ",
                 "          WHERE rac01 = '",g_makeorg,"' AND rac02 = '",g_saleno,"' AND racplant = '",g_org,"' ",
                 "            AND rac03 = '",g_teamno,"' )"   #add
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
        UPDATE cx001_temp SET rac14=rac14[1,2]*60+rac14[4,5],  
                              rac15=rac15[1,2]*60+rac15[4,5]  
        DELETE FROM cx001_temp  
          WHERE (rac13 = g_bdate AND rac15 < g_snum) OR (rac12 = g_edate AND rac14 > g_enum)
     END IF
     SELECT COUNT(*) INTO l_n FROM cx001_temp 
     IF l_n = 0 THEN
        LET g_success = 'Y'
        RETURN
     END IF

     DELETE FROM cx002_temp
     LET g_sql = " INSERT INTO cx002_temp ",
                #" SELECT DISTINCT rad01,rad02,rad03,rad04,ima01,rad06,radplant ",
                #" SELECT rad01,rad02,rad03,' ',ima01,'',radplant FROM ",
                 " SELECT DISTINCT rad01,rad02,rad03,rad04,ima01,'',radplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rad_file'),",",cl_get_target_table(g_org, 'ima_file'),",cx001_temp ",
                 "  WHERE rac01 = rad01 AND rac02 = rad02 AND racplant = radplant AND radacti = 'Y' ",
                 "    AND rac03 = rad03                        ",  #add
                # "    AND ((rad04 = '1' AND rad05 = ima01   )  ",
                # "     OR  (rad04 = '2' AND rad05 = ima131  )  ",
                # "     OR  (rad04 = '3' AND rad05 = ima1004 )  ",
                # "     OR  (rad04 = '4' AND rad05 = ima1005 )  ",
                #"     OR  (rad04 = '5' AND rad05 = ima1006 )  ",
                #"     OR  (rad04 = '6' AND rad05 = ima1007 )  ",
                #"     OR  (rad04 = '7' AND rad05 = ima1008 )  ",
                #"     OR  (rad04 = '8' AND rad05 = ima1009 )) "
                 "    AND ((rad04 = '01' AND rad05 = ima01   )  ",#FUN-A80104
                 "     OR  (rad04 = '02' AND rad05 = ima131  )  ",#FUN-A80104
                 "     OR  (rad04 = '03' AND rad05 = ima1004 )  ",#FUN-A80104
                 "     OR  (rad04 = '04' AND rad05 = ima1005 )  ",#FUN-A80104
                 "     OR  (rad04 = '05' AND rad05 = ima1006 )  ",#FUN-A80104
                 "     OR  (rad04 = '06' AND rad05 = ima1007 )  ",#FUN-A80104
                 "     OR  (rad04 = '07' AND rad05 = ima1008 )  ",#FUN-A80104
                 "     OR  (rad04 = '08' AND rad05 = ima1009 )) " #FUN-A80104
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs2 FROM g_sql
     EXECUTE ins_temp_cs2 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp',SQLCA.sqlcode,1)
        RETURN
     END IF

     DELETE FROM cx002_temp2
     LET g_sql = " INSERT INTO cx002_temp2 ",
                 " SELECT DISTINCT rad01,rad02,rad03,COUNT(DISTINCT rad04),'','',radplant FROM cx002_temp ",
                 "  WHERE 1=1  ",
                 "  GROUP BY rad01,rad02,rad03,radplant  ",
                 " HAVING COUNT(DISTINCT rad04)>0        " 
             
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs6 FROM g_sql
     EXECUTE ins_temp_cs6 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp2',SQLCA.sqlcode,1)
        RETURN
     END IF


     DELETE FROM cx002_temp1
     LET g_sql = " INSERT INTO cx002_temp1 ",
                 " SELECT DISTINCT a.rad01,a.rad02,a.rad03,' ',a.rad05,'',a.radplant FROM cx002_temp a ",
                 "  WHERE 1=1  ",
                 "  GROUP BY a.rad01,a.rad02,a.rad03,a.rad05,a.radplant  ",
                 " HAVING COUNT(a.rad04)=                                ",
                 "        (SELECT  b.rad04 FROM cx002_temp2 b            ",
                 "          WHERE a.rad01=b.rad01 AND a.rad02=b.rad02 AND a.rad03=b.rad03 AND a.radplant=b.radplant)" 
             
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     PREPARE ins_temp_cs3 FROM g_sql
     EXECUTE ins_temp_cs3 
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL s_errmsg('ins','','cx002_temp1',SQLCA.sqlcode,1)
        RETURN
     END IF



     DELETE FROM cx002_temp
     LET g_sql = " INSERT INTO cx002_temp ",
                 " SELECT DISTINCT rad01,rad02,rad03,' ',ima01,'',radplant ",
                 "   FROM ",cl_get_target_table(g_org, 'rad_file'),",",cl_get_target_table(g_org, 'ima_file')," ",
                 "  WHERE rad01='",g_makeorg,"' AND rad02 = '",g_saleno,"' AND radplant = '",g_org,"' AND radacti = 'Y' ",
                 "    AND rad03 = '",g_teamno,"'               ",  #add
               # "    AND ((rad04 = '1' AND rad05 = ima01   )  ",
               # "     OR  (rad04 = '2' AND rad05 = ima131  )  ",
               # "     OR  (rad04 = '3' AND rad05 = ima1004 )  ",
               # "     OR  (rad04 = '4' AND rad05 = ima1005 )  ",
               # "     OR  (rad04 = '5' AND rad05 = ima1006 )  ",
               # "     OR  (rad04 = '6' AND rad05 = ima1007 )  ",
               # "     OR  (rad04 = '7' AND rad05 = ima1008 )  ",
               # "     OR  (rad04 = '8' AND rad05 = ima1009 )) ",
                 "    AND ((rad04 = '01' AND rad05 = ima01   )  ",#FUN-A80104
                 "     OR  (rad04 = '02' AND rad05 = ima131  )  ",#FUN-A80104
                 "     OR  (rad04 = '03' AND rad05 = ima1004 )  ",#FUN-A80104
                 "     OR  (rad04 = '04' AND rad05 = ima1005 )  ",#FUN-A80104
                 "     OR  (rad04 = '05' AND rad05 = ima1006 )  ",#FUN-A80104
                 "     OR  (rad04 = '06' AND rad05 = ima1007 )  ",#FUN-A80104
                 "     OR  (rad04 = '07' AND rad05 = ima1008 )  ",#FUN-A80104
                 "     OR  (rad04 = '08' AND rad05 = ima1009 )) ",#FUN-A80104
                 "  GROUP BY rad01,rad02,rad03,ima01,radplant  ",
                 "  HAVING COUNT(rad04) =  ",
                 "                      (SELECT COUNT(DISTINCT rad04) FROM ",cl_get_target_table(g_org, 'rad_file')," ",
                 "                        WHERE rad01='",g_makeorg,"' AND rad02 = '",g_saleno,"' AND radplant = '",g_org,"' AND radacti = 'Y' ",
                 "                          AND rad03 = '",g_teamno,"')" 

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
                 "  WHERE cx002_temp1.rad05=cx002_temp.rad05   "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
     CALL cl_parse_qry_sql(g_sql, g_org) RETURNING g_sql   
     DECLARE rad_cs CURSOR FROM g_sql
     FOREACH rad_cs INTO l_rad.rad01,l_rad.rad02,l_rad.rad03,l_rad.rad04,l_rad.rad05,l_rad.rad06,l_rad.radplant
       IF SQLCA.sqlcode THEN
          LET g_success='N'
          CALL s_errmsg('sel','','rad_file',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_showmsg = l_rad.rad01,"/",l_rad.rad02,"/",l_rad.rad03,"/",l_rad.rad05,"/",l_rad.rad06,"/",l_rad.radplant
       CALL s_errmsg('rad01,rad02,rad03,ima01,rad06,radplant',g_showmsg,'','art-218',1)
       LET g_success = 'N'
     END FOREACH


END FUNCTION
#FUN-A60044 

