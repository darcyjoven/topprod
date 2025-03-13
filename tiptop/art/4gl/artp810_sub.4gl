# Prog. Version..: '5.30.06-13.03.22(00002)'     #
#
# Program name...: artp810_sub.4gl
# Descriptions...: 營運中心調撥批量處理 
# Date & Author..: No.FUN-C80072 12/08/27 by nanbing 
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2

DATABASE ds
 
GLOBALS "../../config/top.global" 
DEFINE l_cnt      LIKE type_file.num5
DEFINE i          LIKE type_file.num5                     
DEFINE l_sql      STRING  
DEFINE g_forupd_sql       STRING

FUNCTION p810_out_yes(l_ruo01,l_ruoplant,p_transaction)
DEFINE p_transaction   LIKE type_file.chr1
DEFINE l_gen02    LIKE gen_file.gen02            
DEFINE l_rup      RECORD LIKE rup_file.*                         
DEFINE l_ruo      RECORD LIKE ruo_file.*
DEFINE l_ruo01    LIKE ruo_file.ruo01
DEFINE l_ruoplant    LIKE ruo_file.ruoplant
DEFINE l_flag1    LIKE type_file.num5    
   WHENEVER ERROR CONTINUE

   LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(l_ruoplant,'ruo_file'),
                      " WHERE ruo01 = ? AND ruoplant = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p810_cl CURSOR FROM g_forupd_sql

   LET g_success = 'Y'   
   CALL p810_out_yes_chk(l_ruo01,l_ruoplant)
   IF g_success = 'N' THEN 
      RETURN 
   END IF    
   IF p_transaction = 'Y' THEN 
      CALL p810_temp('1') 
      BEGIN WORK
   END IF  

   open p810_cl USING l_ruo01,l_ruoplant
   
   IF STATUS THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'open p810_cl',SQLCA.sqlcode,1)
      CLOSE p810_cl 
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      ELSE
         LET g_success = 'N'
         RETURN    
      END IF    
   END IF
 
   FETCH p810_cl  INTO l_ruo.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'',SQLCA.sqlcode,1)
      CLOSE p810_cl
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      ELSE    
         LET g_success = 'N'
         RETURN   
      END IF  
   END IF
   #調撥單來源為調撥申請單時,更新申請單的審核碼
   IF l_ruo.ruo02 = '5' THEN
      CALL p810_upd_rvq('3',l_ruo.ruo03,l_ruo.ruoplant) RETURNING l_flag1
      IF (NOT l_flag1) THEN
         CALL s_errmsg('ruo01',l_ruo.ruo01,'','art-855',1)
         CLOSE p810_cl
         IF p_transaction = 'Y' THEN 
            ROLLBACK WORK
         ELSE    
            LET g_success = 'N'
            RETURN   
         END IF  
      END IF
   END IF
   CALL t256_sub(l_ruo.*,'1','N')

   IF g_success = 'Y' THEN      
      IF p_transaction = 'Y' THEN 
         COMMIT WORK
      END IF  
      CLOSE p810_cl 
   ELSE
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      ELSE    
         LET g_success = 'N'
         RETURN      
      END IF  
      CLOSE p810_cl 
   END IF
   IF p_transaction = 'Y' THEN 
      CALL p810_temp('2')
   END IF 
END FUNCTION

FUNCTION p810_in_yes(l_ruo01,l_ruoplant,p_transaction)
DEFINE p_transaction   LIKE type_file.chr1
DEFINE l_gen02         LIKE gen_file.gen02 
DEFINE l_rup           RECORD LIKE rup_file.* 
DEFINE l_ruo           RECORD LIKE ruo_file.*   
DEFINE l_ruo01         LIKE ruo_file.ruo01
DEFINE l_ruoplant      LIKE ruo_file.ruoplant
DEFINE l_rup13         LIKE rup_file.rup13
DEFINE l_rup16         LIKE rup_file.rup16
DEFINE l_rup02         LIKE rup_file.rup02
DEFINE l_rup14         LIKE rup_file.rup14
DEFINE l_rup15         LIKE rup_file.rup15  

   WHENEVER ERROR CONTINUE
   LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(l_ruoplant,'ruo_file'),
                      " WHERE ruo01 = ? AND ruoplant = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p810_cl1 CURSOR FROM g_forupd_sql  

   LET g_success = 'Y'   
   CALL p810_in_yes_chk(l_ruo01,l_ruoplant)
   IF g_success = 'N' THEN 
      RETURN 
   END IF 
   IF p_transaction = 'Y' THEN 
      CALL p810_temp('1')
      BEGIN WORK
   END IF 
   LET g_success = 'Y'


   open p810_cl1  USING l_ruo01,l_ruoplant
   
   IF STATUS THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'open p810_cl1',STATUS,1)
      CLOSE p810_cl1
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      ELSE
         LET g_success = 'N'
         RETURN   
      END IF 
   END IF
 
   FETCH p810_cl1  INTO l_ruo.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'',SQLCA.sqlcode,1)
      CLOSE p810_cl1
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      ELSE    
         LET g_success = 'N'
         RETURN   
      END IF 
   END IF
   LET g_success = 'Y'
   LET l_sql = "SELECT rup02,rup13,rup14,rup15,rup16 FROM ",cl_get_target_table(l_ruo.ruoplant,'rup_file'),
               " WHERE rup01 = '",l_ruo.ruo01,"' AND rupplant = '",l_ruo.ruoplant,"'" 
   PREPARE p810_rupx1 FROM l_sql
   DECLARE rup_csx1 CURSOR FOR p810_rupx1
   FOREACH rup_csx1 INTO l_rup02,l_rup13,l_rup14,l_rup15,l_rup16
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruo01',l_ruo.ruo01,'foreach',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_sql = "UPDATE ",cl_get_target_table(l_ruo.ruo04,'rup_file'),
                  "   SET rup13 = '",l_rup13,"',",
                  "       rup14 = '",l_rup14,"',",
                  "       rup15 = '",l_rup15,"',",
                  "       rup16 = '",l_rup16,"'",
                  " WHERE rup01 = '",l_ruo.ruo011,"'", 
                  "   AND rup02 = '",l_rup02,"'",
                  "   AND rupplant = '",l_ruo.ruo04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
      CALL cl_parse_qry_sql(l_sql,l_ruo.ruo04) RETURNING l_sql 
      PREPARE rup_uprup FROM l_sql
      EXECUTE rup_uprup  
      IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
         CALL s_errmsg('ruo01',l_ruo.ruo01,'update rup_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH

   CALL t256_sub(l_ruo.*,'2','N')
   IF g_success = 'Y' THEN
      IF p_transaction = 'Y' THEN 
         COMMIT WORK
      END IF  
      CLOSE p810_cl1 
   ELSE
      IF p_transaction = 'Y' THEN 
         ROLLBACK WORK
      END IF 
      CLOSE p810_cl1 
   END IF
   IF p_transaction = 'Y' THEN 
      CALL p810_temp('2')
   END IF 
   
END FUNCTION


FUNCTION p810_temp(l_flag)
   DEFINE l_flag  LIKE type_file.num5
   IF l_flag = '1' THEN
      SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
      SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp
      CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,   #採購單號
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,   #單價
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22)   #幣種

      CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01, #訂單單號
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6)
   ELSE
      DROP TABLE p801_file
      DROP TABLE p900_file
      DROP TABLE ruo_temp
      DROP TABLE rup_temp
   END IF
END FUNCTION

FUNCTION p810_out_yes_chk(l_ruo01,l_ruoplant)
DEFINE l_rup      RECORD LIKE rup_file.*                         
DEFINE l_ruo      RECORD LIKE ruo_file.*
DEFINE l_ruo01    LIKE ruo_file.ruo01
DEFINE l_ruoplant    LIKE ruo_file.ruoplant
DEFINE l_img10    LIKE img_file.img10
DEFINE l_imd20   LIKE imd_file.imd20
DEFINE l_imd01   LIKE imd_file.imd01
DEFINE l_flag01  LIKE type_file.chr1    #FUN-D30024
   IF l_ruo01 IS NULL OR l_ruoplant IS NULL THEN 
      CALL s_errmsg('','','','-400',1)
      LET g_success = 'N'
      RETURN 
   END IF

   LET l_sql = "SELECT *  FROM ",cl_get_target_table(l_ruoplant,'ruo_file'),
               " WHERE ruo01 = '", l_ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruoplant) RETURNING l_sql             
   PREPARE p810_ruo FROM l_sql
   EXECUTE p810_ruo INTO l_ruo.*
   
   IF l_ruo.ruoplant <> l_ruo.ruo04 THEN 
     LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruo04
      CALL s_errmsg('ruo01,ruo04',g_showmsg,'','art1078',1)
      LET g_success = 'N'       
      RETURN
   END IF     
   IF l_ruo.ruoconf = '1' THEN
      #CALL cl_err('','art-289',0) 
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-289',1)
      LET g_success = 'N'  
      RETURN
   END IF #已撥出審核
   IF l_ruo.ruoconf = '2' THEN
      #CALL cl_err('','art-290',0)
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-290',1)
      LET g_success = 'N'  
      RETURN
   END IF #已撥入審核
   IF l_ruo.ruoconf = '3' THEN
      #CALL cl_err('','art-974',0)
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-974',1)
      LET g_success = 'N'  
      RETURN
   END IF #已結案 
   IF l_ruo.ruoconf = 'X' THEN
      #CALL cl_err('','art-380',0)
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-380',1)
      LET g_success = 'N'
      RETURN
   END IF #已作廢 


   LET l_sql = "SELECT * FROM ",cl_get_target_table(l_ruo.ruo04,'rup_file'),
               " WHERE rup01= '",l_ruo.ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruo.ruo04) RETURNING l_sql                   
   PREPARE p810_rup1 FROM l_sql
   DECLARE rup_cs1 CURSOR FOR p810_rup1
   FOREACH rup_cs1 INTO l_rup.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruo01',l_ruo.ruo01,'foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF      
      #撥出倉庫是否屬於撥出營運中心
      IF NOT s_chk_ware1(l_rup.rup09,l_ruo.ruo04) THEN
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup09,'/',l_ruo.ruo04
         CALL s_errmsg('ruo01,rup09,ruo04',g_showmsg,'','art1005',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_sma.sma142 = 'N' THEN   #不啟用在途倉
        #撥入倉庫是否屬於撥入營運中心
         IF NOT s_chk_ware1(l_rup.rup13,l_ruo.ruo05) THEN   
            LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup13,'/',l_ruo.ruo05         
            CALL s_errmsg('ruo01,rup13,ruo04',g_showmsg,'','art1006',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      ####check_img10檢查庫存數量
      IF cl_null(l_rup.rup10) THEN
         LET l_rup.rup10 = ' ' 
      END IF 
      IF cl_null(l_rup.rup11) THEN
         LET l_rup.rup11 = ' ' 
      END IF
      LET l_sql = "SELECT img10 FROM ",cl_get_target_table(l_ruo.ruo04,'img_file'),
              " WHERE img01 = '", l_rup.rup03,"' ",
              "   AND img02 = '",l_rup.rup09,"' ",
              "   AND img03 = '",l_rup.rup10,"' ",
              "   AND img04 = '",l_rup.rup11,"' "  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
      CALL cl_parse_qry_sql(l_sql,l_ruo.ruo04) RETURNING l_sql                   
      PREPARE p810_img FROM l_sql
      EXECUTE p810_img INTO l_img10      
      IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
      LET g_errno = ''
      IF l_img10 < l_rup.rup12 THEN
      #FUN-D30024 --------Begin---------
         CALL s_inv_shrt_by_warehouse(l_rup.rup09,l_ruo.ruo04) RETURNING l_flag01   #TQC-D40078 l_ruo.ruo04
         IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
      #  IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
      #FUN-D30024 --------End-----------
            #LET g_check_img = 'N'   
             # CALL cl_err(l_img10,'mfg3471',0)
            LET g_errno = 'mfg3471'
         ELSE
            IF NOT cl_confirm('mfg3469') THEN
               LET g_errno = 'art-475'  
            END IF
         END IF   
      END IF
      IF NOT cl_null(g_errno) THEN 
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup03,'/',l_rup.rup09,'/',l_rup.rup12
         CALL s_errmsg('ruo01,rup03,rup09,rup12',g_showmsg,'',g_errno,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH   
   IF  g_sma.sma142 = 'Y' THEN   #啟用在途倉
   
      IF g_sma.sma143 = '1' THEN #調撥在途歸屬撥出方
         LET l_imd20 = l_ruo.ruo04
      ELSE
         IF g_sma.sma143 = '2' THEN #調撥在途歸屬撥入方
            LET l_imd20 = l_ruo.ruo05
         END IF
      END IF

      SELECT COUNT(*) INTO l_cnt FROM imd_file
        WHERE imd10 = 'W' AND imd20 = l_imd20 AND imd01 = l_ruo.ruo14
      IF l_cnt <= 0  THEN        #在途倉是否屬於歸屬營運中心
        IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
           LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup13,'/',l_ruo.ruo04
           CALL s_errmsg('ruo01,rup13,ruo04',g_showmsg,'','art1007',1)
           LET g_success = 'N'
           RETURN
        END IF
        IF g_sma.sma143 = '2' THEN   #調撥在途歸屬撥入方
           LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruo14
           CALL s_errmsg('ruo01,ruo14',g_showmsg,'','art1008',1)
           LET g_success = 'N'
           RETURN
        END IF
      END IF
   END IF

   IF l_ruo.ruo901 = 'Y' AND cl_null(l_ruo.ruo904) THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'','art-995',1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ruo.ruo04,'rup_file'),
               " WHERE rup01= '",l_ruo.ruo01,"' "," AND rupplant = '",l_ruo.ruoplant,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruo.ruoplant) RETURNING l_sql                   
   PREPARE p810_rup_1 FROM l_sql
   EXECUTE p810_rup_1 INTO l_cnt          
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'sel rup',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 
END FUNCTION    


FUNCTION p810_in_yes_chk(l_ruo01,l_ruoplant)
DEFINE l_rup03         LIKE rup_file.rup03
DEFINE l_rup12         LIKE rup_file.rup12
DEFINE l_rup13         LIKE rup_file.rup13
DEFINE l_rup16         LIKE rup_file.rup16
DEFINE l_rup02         LIKE rup_file.rup02
DEFINE l_rup14         LIKE rup_file.rup14
DEFINE l_rup15         LIKE rup_file.rup15                   
DEFINE l_ruo           RECORD LIKE ruo_file.*
DEFINE l_rup           RECORD LIKE rup_file.*    
DEFINE l_ruo01         LIKE ruo_file.ruo01
DEFINE l_ruoplant      LIKE ruo_file.ruoplant
   IF l_ruo01 IS NULL OR l_ruoplant IS NULL THEN 
      CALL s_errmsg('','','','-400',1)
      LET g_success = 'N'
      RETURN 
   END IF

   LET l_sql = "SELECT *  FROM ",cl_get_target_table(l_ruoplant,'ruo_file'),
               " WHERE ruo01 = '", l_ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruoplant) RETURNING l_sql                   
   PREPARE p810_ruo1 FROM l_sql
   EXECUTE p810_ruo1 INTO l_ruo.*

   IF l_ruo.ruoplant <> l_ruo.ruo05 THEN 
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruo05
      CALL s_errmsg('ruo01,ruo05',g_showmsg,'','art1079',1)
      LET g_success = 'N'
      RETURN
   END IF   
   IF l_ruo.ruoconf = '0' THEN
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-286',1)
      LET g_success = 'N'
      RETURN
   END IF #
   IF l_ruo.ruoconf = '2' THEN
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','aim-100',1)
      LET g_success = 'N'
      RETURN
   END IF 
   IF l_ruo.ruoconf = '3' THEN
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-974',1)
      LET g_success = 'N'
      RETURN
   END IF #已結案 
   IF l_ruo.ruoconf = 'X' THEN
      LET g_showmsg = l_ruo.ruo01,'/',l_ruo.ruoconf
      CALL s_errmsg('ruo01,ruoconf',g_showmsg,'','art-380',1)
      LET g_success = 'N'
      RETURN
   END IF #已作廢  

   LET l_cnt=0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ruo.ruo05,'rup_file'),
               " WHERE rup01= '",l_ruo.ruo01,"' "," AND rupplant = '",l_ruo.ruo05,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruo.ruo05) RETURNING l_sql                   
   PREPARE p810_rup_2 FROM l_sql
   EXECUTE p810_rup_2 INTO l_cnt          
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL s_errmsg('ruo01',l_ruo.ruo01,'sel rup',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   #檢查商品是否有撥入數量和撥入倉庫
   LET l_sql = "SELECT rup03,rup12,rup13,rup16 FROM ",cl_get_target_table(l_ruo.ruo05,'rup_file'),
               " WHERE rup01 = '", l_ruo.ruo01 ,"' AND rupplant = '",l_ruo.ruo05 ,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruo.ruo05) RETURNING l_sql                   
   PREPARE p810_rupx FROM l_sql
   DECLARE rup_csx CURSOR FOR p810_rupx
   FOREACH rup_csx INTO l_rup.rup03,l_rup.rup12,l_rup.rup13,l_rup.rup16
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruo01',l_ruo.ruo01,'foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #判斷是否有撥出數量
      IF l_rup.rup12 IS NULL OR l_rup.rup12 <= 0 THEN 
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup12
         CALL s_errmsg('ruo01,rup12',g_showmsg,'sel rup12','art-317',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷是否有撥入倉庫     
      IF l_rup.rup13 IS NULL THEN
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup13
         CALL s_errmsg('ruo01,rup13',g_showmsg,'sel rup13','art-318',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF NOT s_chk_ware1(l_rup.rup13,l_ruo.ruo05) THEN
         LET g_showmsg =  l_ruo.ruo01,'/',l_rup.rup13,'/',l_ruo.ruo05
         CALL s_errmsg('ruo01,rup13,ruo05',g_showmsg,'','art1006',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷是否有撥入數量
      IF l_rup.rup16 IS NULL OR l_rup.rup16 <= 0 THEN
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup16
         CALL s_errmsg('ruo01,rup16',g_showmsg,'sel rup16','art-319',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷撥入數量是否大于撥出數量
      IF l_rup.rup16 > l_rup.rup12 THEN
         LET g_showmsg = l_ruo.ruo01,'/',l_rup.rup12,'/',l_rup.rup16
         CALL s_errmsg('ruo01,rup12,rup16',g_showmsg,'sel rup12,rup16','art-320',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

END FUNCTION    

FUNCTION p810_upd_rvq(p_rvqconf,l_ruo03,l_ruoplant)
   DEFINE l_sql       STRING
   DEFINE p_rvqconf   LIKE rvq_file.rvqconf
   DEFINE l_rvq01     LIKE rvq_file.rvq01
   DEFINE l_rvq05     LIKE rvq_file.rvq05  #申請營運中心
   DEFINE l_rvq06     LIKE rvq_file.rvq06  #申請單號
   DEFINE l_rvq07     LIKE rvq_file.rvq07  #撥出營運中心
   DEFINE l_rvq08     LIKE rvq_file.rvq08  #撥入營運中心
   DEFINE l_rvqconf   LIKE rvq_file.rvqconf
   DEFINE l_azw07     LIKE azw_file.azw07
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_ruo03     LIKE ruo_file.ruo03
   DEFINE l_ruoplant  LIKE ruo_file.ruoplant
   LET l_rvqconf = p_rvqconf
   LET l_azw07 = ''
   LET l_cnt = ''
   
   LET l_sql = "SELECT rvq01,rvq05,rvq06,rvq07,rvq08 FROM ",cl_get_target_table(l_ruoplant,'rvq_file'),
               " WHERE rvq01 = '",l_ruo03,"' AND rvqplant = '",l_ruoplant, "'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,l_ruoplant) RETURNING l_sql                   
   PREPARE p810_rvq FROM l_sql
   EXECUTE p810_rvq INTO l_rvq01,l_rvq05,l_rvq06,l_rvq07,l_rvq08  
   IF cl_null(l_rvq06) THEN
      LET l_rvq06 = l_rvq01
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = l_rvq08 AND azw01 = l_rvq07 AND azwacti='Y'
 　IF l_cnt > 0 THEN        #撥出營運中心的上級是撥入營運中心
      LET l_azw07 = l_rvq08
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = l_rvq07 AND azw01 = l_rvq08  AND azwacti='Y'
　　　　IF l_cnt>0 THEN      #判讀撥入營運中心的上級是否是撥出營運中心
          LET l_azw07 = l_rvq07
       END IF
   END IF
   IF cl_null(l_azw07) THEN #撥入撥出沒有上下級關係，抓取撥出的上級營運中心
      SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = l_rvq07  AND azwacti='Y'
   END IF
　　IF cl_null(l_azw07) THEN
       LET l_azw07 = l_rvq07 #撥出營運中心為最上級營運中心
   END IF
   #更新撥出營運中心
   LET l_sql = " UPDATE ",cl_get_target_table(l_rvq07,'rvq_file'),
               "    SET rvqconf = '",l_rvqconf,"' ",
               "  WHERE rvq01 = '",l_rvq01,"'",
               "    AND rvqplant = '",l_rvq07,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_rvq07) RETURNING l_sql
   PREPARE pre_upd_rvq1 FROM l_sql
   EXECUTE pre_upd_rvq1
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      RETURN FALSE
   END IF
   #不是撥出營運中心申請，更新申請營運中心
   IF l_rvq07 <> l_rvq05 THEN
      LET l_sql = " UPDATE ",cl_get_target_table(l_rvq05,'rvq_file'),
                  "    SET rvqconf = '",l_rvqconf,"' ",
                  "  WHERE rvq01 = '",l_rvq06,"'",
                  "    AND rvqplant = '",l_rvq05,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rvq05) RETURNING l_sql
      PREPARE pre_upd_rvq2 FROM l_sql
      EXECUTE pre_upd_rvq2
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         RETURN FALSE
      END IF
   END IF
   #上級營運中心不是撥出營運中心也不是申請營運中心，更新上級營運中心
   IF l_azw07 <> l_rvq07 AND l_azw07 <> l_rvq05 THEN
      LET l_sql = " UPDATE ",cl_get_target_table(l_azw07,'rvq_file'),
                  "    SET rvqconf = '",l_rvqconf,"' ",
                  "  WHERE rvq05 = '",l_rvq05,"'",
                  "    AND rvq06 = '",l_rvq06,"'",
                  "    AND rvqplant = '",l_azw07,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql
      PREPARE pre_upd_rvq3 FROM l_sql
      EXECUTE pre_upd_rvq3
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         RETURN FALSE
      END IF      
   END IF
   RETURN TRUE
END FUNCTION
#FUN-C80072 
