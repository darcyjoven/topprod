# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Descriptions...: 应收帐款-产生代收/代收应返
# Date & Author..: NO.FUN-AB0034 10/12/07 By wujie
# Modify.........: No.FUN-B10058 11/01/25 By lutingting 流通财务改善
# Modify.........: No.FUN-D40089 13/04/23 By zhangweib 批次審核的報錯,加show單據編號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(72)
DEFINE   g_rec_b         LIKE type_file.num5          #No.FUN-680123 SMALLINT              #單身筆數
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE   g_wc            LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(300)         #查詢條件
         g_sql           LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(300)
         g_t1            LIKE ooy_file.ooyslip,       #No.FUN-680123 VARCHAR(5) #TQC-5A0089
         p_row,p_col     LIKE type_file.num5,         #No.FUN-680123 SMALLINT,
         b_oob           RECORD LIKE oob_file.*,
         g_ooa_t         RECORD LIKE ooa_file.* ,
         g_ooa_o         RECORD LIKE ooa_file.* ,
         l_oob09_sum     LIKE oob_file.oob09,
         l_oob10_sum     LIKE oob_file.oob10

DEFINE   m_oma           RECORD LIKE oma_file.*
DEFINE   g_oow           RECORD LIKE oow_file.*
 
FUNCTION s_t300_w1(p_sw,p_no)
   DEFINE p_no           LIKE oma_file.oma01        
   DEFINE p_sw           LIKE type_file.chr1
   DEFINE l_oma          RECORD LIKE oma_file.*
   DEFINE l_omc          RECORD LIKE omc_file.*
   DEFINE l_omb45        LIKE omb_file.omb45
   DEFINE l_omb14        LIKE omb_file.omb14
   DEFINE l_omb16        LIKE omb_file.omb16
   
   WHENEVER ERROR CONTINUE
   IF g_success ='N' THEN RETURN END IF 
    
   # 合法驗証,是否存在該單據號，應收帳款系統是否使用
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01=p_no
   IF STATUS THEN 
     #CALL cl_err3("sel","oma_file",p_no,"",STATUS,"","sel oma:",1)    #No.FUN-660116   #No.FUN-D40089   Mark
     #No.FUN-D40089 ---start--- Add
      IF g_bgerr THEN
         CALL s_errmsg('oma01',p_no,'',STATUS,1)
      ELSE
         CALL cl_err3("sel","oma_file",p_no,"",STATUS,"","sel oma:",1)
      END IF
      #No.FUN-D40089 ---end  --- Add
      LET g_success ='N' 
      RETURN 
   END IF
   IF l_oma.oma74 <> '2' THEN RETURN END IF 
   IF g_ooz.ooz01='N' THEN
     #CALL cl_err('','9037',0)   #No.FUN-D40089   Mark
     #No.FUN-D40089 ---start--- Add
      IF g_bgerr THEN
         CALL s_errmsg('oma01',p_no,'','9037',1)
      ELSE
         CALL cl_err('','9037',0)
      END IF
      #No.FUN-D40089 ---end  --- Add
      RETURN
   END IF
   IF l_oma.oma01 IS NULL THEN RETURN END IF
 
   # 若該單據未確認且未作廢，則可維護直接收款
   IF l_oma.omavoid = 'Y' THEN
      RETURN 
   END IF
   IF p_sw ='-' THEN 
      DELETE FROM omc_file WHERE omc01 IN (SELECT oma01 FROM oma_file WHERE oma16 = l_oma.oma01)   
      IF STATUS THEN
        #CALL cl_err3("del","omc_file",l_oma.oma01,"",STATUS,"","del omc",1)   #No.FUN-D40089   Mark
        #No.FUN-D40089 ---start--- Add
         IF g_bgerr THEN
            CALL s_errmsg('oma01',l_oma.oma01,'',STATUS,1)
         ELSE
            CALL cl_err3("del","omc_file",l_oma.oma01,"",STATUS,"","del omc",1)
         END IF
        #No.FUN-D40089 ---end  --- Add
         LET g_success = 'N' 
         RETURN
      END IF
      
      DELETE FROM oma_file WHERE oma16 = l_oma.oma01
      IF STATUS THEN
        #CALL cl_err3("del","oma_file",l_oma.oma19,"",STATUS,"","del oma",1)   #No.FUN-D40089   Mark
        #No.FUN-D40089 ---start--- Add
         IF g_bgerr THEN
            CALL s_errmsg('oma01',l_oma.oma01,'',STATUS,1)
         ELSE
            CALL cl_err3("del","oma_file",l_oma.oma19,"",STATUS,"","del oma",1)
         END IF
        #No.FUN-D40089 ---end  --- Add
         LET g_success = 'N' 
         RETURN
      END IF
      UPDATE omb_file SET omb47 = '' WHERE omb01 =l_oma.oma01
      IF STATUS THEN
        #CALL cl_err3("upd","omb_file",l_oma.oma19,"",STATUS,"","upd omb",1)   #No.FUN-D40089   Mark
        #No.FUN-D40089 ---start--- Add
         IF g_bgerr THEN
            CALL s_errmsg('oma01',l_oma.oma01,'',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","omb_file",l_oma.oma19,"",STATUS,"","upd omb",1)
         END IF
        #No.FUN-D40089 ---end  --- Add
         LET g_success = 'N' 
         RETURN
      END IF
   END IF 
   IF p_sw ='+' THEN 
     #DECLARE t300_w1_c CURSOR FOR SELECT omb45,SUM(omb14),SUM(omb16) FROM omb_file WHERE omb01 = l_oma.oma01  GROUP BY omb45 #FUN-B10058 by elva
      DECLARE t300_w1_c CURSOR FOR SELECT omb45,SUM(omb14t),SUM(omb16t) FROM omb_file WHERE omb01 = l_oma.oma01  GROUP BY omb45 #FUN-B10058 by elva
      FOREACH t300_w1_c INTO l_omb45,l_omb14,l_omb16
         CALL t300_w1_ins_oma(l_oma.oma00,l_oma.oma01,l_omb45,l_omb14,l_omb16)
         IF g_success ='N' THEN 
            RETURN 
         END IF 
      END FOREACH 
   END IF 
END FUNCTION 

FUNCTION t300_w1_ins_oma(p_oma00,p_oma01,p_omb45,p_omb14,p_omb16)
   DEFINE p_oma00   LIKE oma_file.oma00
   DEFINE p_oma01   LIKE oma_file.oma01
   DEFINE p_omb45   LIKE omb_file.omb45
   DEFINE p_omb14   LIKE omb_file.omb14
   DEFINE p_omb16   LIKE omb_file.omb16
   DEFINE li_result LIKE type_file.num5
   DEFINE l_ool     RECORD LIKE ool_file.*
   DEFINE l_omc     RECORD LIKE omc_file.*


   
   INITIALIZE m_oma.* TO NULL
   SELECT oma23 INTO m_oma.oma23 FROM oma_file WHERE oma01 = p_oma01
   SELECT * INTO g_oow.* FROM oow_file WHERE oow00 = '0'
   IF STATUS THEN
      LET g_success = 'N'
      RETURN 
   END IF
   CALL t300_w1_oma_default()
   #IF p_omb14 > 0 AND p_oma00 ='12' THEN     #FUN-B10058
   IF p_omb14 > 0 AND p_oma00 ='19' THEN      #FUN-B10058 
      LET m_oma.oma00 ='27'       
      CALL s_auto_assign_no("AXR",g_oow.oow20,m_oma.oma02,"27","oma_file","oma01","","","")  
           RETURNING li_result,m_oma.oma01
   END IF 
   #IF p_omb14 < 0 AND p_oma00 ='12' THEN     #FUN-B10058
   IF p_omb14 < 0 AND p_oma00 ='19' THEN      #FUN-B10058 
      LET m_oma.oma00 ='16'       
      CALL s_auto_assign_no("AXR",g_oow.oow18,m_oma.oma02,"16","oma_file","oma01","","","")  
           RETURNING li_result,m_oma.oma01
   END IF 
   #IF p_omb14 < 0 AND p_oma00 ='21' THEN     #FUN-B10058 
   IF p_omb14 < 0 AND p_oma00 ='28' THEN      #FUN-B10058 
      LET m_oma.oma00 ='27'       
      CALL s_auto_assign_no("AXR",g_oow.oow20,m_oma.oma02,"27","oma_file","oma01","","","")  
           RETURNING li_result,m_oma.oma01
   END IF    
   #IF p_omb14 > 0 AND p_oma00 ='21' THEN     #FUN-B10058 
   IF p_omb14 > 0 AND p_oma00 ='28' THEN      #FUN-B10058
      LET m_oma.oma00 ='16'       
      CALL s_auto_assign_no("AXR",g_oow.oow18,m_oma.oma02,"16","oma_file","oma01","","","")  
           RETURNING li_result,m_oma.oma01
   END IF   
   IF (NOT li_result) THEN  
      LET g_success ='N'
      RETURN 
   END IF  
   LET m_oma.oma03 = p_omb45        
                                                                                                                       
   LET g_sql = "SELECT occ02,occ07,occ08,occ11,occ18,occ231,occ37,occ41,occ43,occ43,occ45",
               "  FROM ",cl_get_target_table(g_plant,'occ_file'), 
               " WHERE occ01 = '",m_oma.oma03,"' AND occacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             						
	 CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql               
   PREPARE sel_occ_pre39 FROM g_sql
   EXECUTE sel_occ_pre39 INTO m_oma.oma032,m_oma.oma68,m_oma.oma05,m_oma.oma042,m_oma.oma043,m_oma.oma044,m_oma.oma40,m_oma.oma21,m_oma.oma25,m_oma.oma26,m_oma.oma32


   IF NOT cl_null(m_oma.oma68) THEN                                                                                                 
      SELECT occ02 INTO m_oma.oma69
        FROM occ_file
       WHERE occ01=m_oma.oma68                   #再抓取收款客戶簡稱
   END IF 
   LET m_oma.oma04 = m_oma.oma03
   LET m_oma.oma14 = g_user 
   LET m_oma.oma15 = g_grup
   LET m_oma.oma16 = p_oma01

   LET g_sql = "SELECT gec04,gec05,gec06,gec07,gec08 FROM ",cl_get_target_table(g_plant,'gec_file'), 
               " WHERE gec01 = '",m_oma.oma21,"' AND gec011 = '2'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             						
	 CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql            
   PREPARE sel_gec_pre41 FROM g_sql    
   EXECUTE sel_gec_pre41 INTO m_oma.oma211,m_oma.oma212,m_oma.oma172,m_oma.oma213,m_oma.oma171

   IF m_oma.oma23=g_aza.aza17 THEN
      LET m_oma.oma24 = 1 
      LET m_oma.oma58 = 1
   ELSE
      CALL s_curr3(m_oma.oma23,m_oma.oma02,g_ooz.ooz17) RETURNING m_oma.oma24
      CALL s_curr3(m_oma.oma23,m_oma.oma09,g_ooz.ooz17) RETURNING m_oma.oma58
      IF cl_null(m_oma.oma24) THEN LET m_oma.oma24=1 END IF
      IF cl_null(m_oma.oma58) THEN LET m_oma.oma58=1 END IF
   END IF
  
   SELECT ooz08 INTO m_oma.oma13 FROM ooz_file WHERE ooz00='0' 
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=m_oma.oma13
   #by elva --begin
   #LET m_oma.oma18=l_ool.ool26 #by elva
   #IF g_aza.aza63 = 'Y' THEN
   #   LET m_oma.oma181=l_ool.ool261
   #END IF
   IF m_oma.oma00='27' THEN
      LET m_oma.oma18=l_ool.ool36
   ELSE
      LET m_oma.oma18=l_ool.ool11
   END IF
   IF g_aza.aza63 = 'Y' THEN
      IF m_oma.oma00='27' THEN
         LET m_oma.oma181=l_ool.ool361
      ELSE
         LET m_oma.oma181=l_ool.ool111
      END IF
   END IF
   #by elva --end
 
   LET m_oma.oma66 = g_plant
   LET m_oma.omalegal = g_azw.azw02
 
 
   CALL s_rdatem(m_oma.oma03,m_oma.oma32,m_oma.oma02,m_oma.oma09,m_oma.oma02,g_plant) 
          RETURNING m_oma.oma11,m_oma.oma12
   LET m_oma.oma65 = '1' 
   LET m_oma.oma60 = m_oma.oma24    
   IF g_aaz.aaz90='Y' THEN
      LET m_oma.oma930=s_costcenter(m_oma.oma15)
   END IF
   IF cl_null(m_oma.oma51) THEN
      LET m_oma.oma51 = 0
   END IF
   IF cl_null(m_oma.oma51f) THEN
      LET m_oma.oma51f = 0
   END IF
   
   LET m_oma.oma50 = p_omb14
   LET m_oma.oma50t= p_omb14
   LET m_oma.oma54 = p_omb14
   LET m_oma.oma54t= p_omb14
   LET m_oma.oma56 = p_omb16
   LET m_oma.oma56t= p_omb16
   LET m_oma.oma59 = p_omb16
   LET m_oma.oma59t= p_omb16
   LET m_oma.oma61 = p_omb16         
   LET m_oma.oma161 = 0                                                                                                 
   LET m_oma.oma162 = 100                                                                                               
   LET m_oma.oma163 = 0   
   LET m_oma.omalegal = g_legal 
   LET m_oma.omaoriu = g_user      
   LET m_oma.omaorig = g_grup  
#No.FUN-AB0034 --begin
   IF cl_null(m_oma.oma73) THEN LET m_oma.oma73 =0 END IF
   IF cl_null(m_oma.oma73f) THEN LET m_oma.oma73f =0 END IF
   IF cl_null(m_oma.oma74) THEN LET m_oma.oma74 =0 END IF
#No.FUN-AB0034 --end    
   INSERT INTO oma_file VALUES(m_oma.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #CALL cl_err3("ins","oma_file",m_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)   #No.FUN-D40089   Mark
     #No.FUN-D40089 ---start--- Add
      IF g_bgerr THEN
         CALL s_errmsg('oma01',m_oma.oma01,'',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","oma_file",m_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
      END IF
      #No.FUN-D40089 ---end  --- Add
      LET g_success='N'
      RETURN
   END IF
   INITIALIZE l_omc.* TO NULL
   LET l_omc.omc01 = m_oma.oma01
   LET l_omc.omc02 = 1
   LET l_omc.omc03 = m_oma.oma32
   LET l_omc.omc04 = m_oma.oma11
   LET l_omc.omc05 = m_oma.oma12
   LET l_omc.omc06 = m_oma.oma24
   LET l_omc.omc07 = m_oma.oma60
   LET l_omc.omc08 = m_oma.oma54t
   LET l_omc.omc09 = m_oma.oma56t
   LET l_omc.omc10 = 0
   LET l_omc.omc11 = 0
   LET l_omc.omc12 = m_oma.oma10
   LET l_omc.omc13 = l_omc.omc09-l_omc.omc11
   LET l_omc.omc14 = 0
   LET l_omc.omc15 = 0
   LET l_omc.omclegal = m_oma.omalegal

   INSERT INTO omc_file VALUES(l_omc.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
     #CALL cl_err3("ins","omc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-D40089   Mark
     #No.FUN-D40089 ---start--- Add
      IF g_bgerr THEN
         CALL s_errmsg('oma01',m_oma.oma01,'',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","omc_file","","",SQLCA.sqlcode,"","",1)
      END IF
      #No.FUN-D40089 ---end  --- Add
     LET g_success = 'N'
   END IF
  #UPDATE omb_file SET omb47 = m_oma.oma01 WHERE omb01 =p_oma01 #by elva
   UPDATE omb_file SET omb47 = m_oma.oma01 WHERE omb01 =p_oma01 AND omb45=p_omb45 #by elva
   IF STATUS THEN
     #CALL cl_err3("upd","omb_file","","",STATUS,"","upd omb",1)   #No.FUN-D40089   Mark
     #No.FUN-D40089 ---start--- Add
      IF g_bgerr THEN
         CALL s_errmsg('oma01',m_oma.oma01,'',STATUS,1)
      ELSE
         CALL cl_err3("upd","omb_file","","",STATUS,"","upd omb",1)
      END IF
      #No.FUN-D40089 ---end  --- Add
      LET g_success = 'N' 
      RETURN
   END IF
END FUNCTION 

FUNCTION t300_w1_oma_default()
 
   LET m_oma.oma01 = NULL
   LET m_oma.oma02 = TODAY 
   LET m_oma.oma07 = 'N'
   LET m_oma.oma08 = '1'
   LET m_oma.oma09 = TODAY
   LET m_oma.oma17 = '1'
   LET m_oma.oma171 = '31'
   LET m_oma.oma172 = '1'
   LET m_oma.oma173 = YEAR(m_oma.oma02)
   LET m_oma.oma174 = MONTH(m_oma.oma02)
   LET m_oma.oma20 = 'Y'
   LET m_oma.oma50 = 0
   LET m_oma.oma50t = 0
   LET m_oma.oma52 = 0
   LET m_oma.oma53 = 0
   LET m_oma.oma54 = 0
   LET m_oma.oma54x = 0
   LET m_oma.oma54t = 0 
   LET m_oma.oma55 = 0
   LET m_oma.oma56 = 0
   LET m_oma.oma56x = 0
   LET m_oma.oma56t = 0
   LET m_oma.oma57 = 0
   LET m_oma.oma59 = 0
   LET m_oma.oma59x = 0
   LET m_oma.oma61 = 0         
   LET m_oma.oma59t = 0
   LET m_oma.oma64 = 1
   LET m_oma.oma70 = 1  
   LET m_oma.oma73 = 0 
   LET m_oma.oma73f= 0  
   LET m_oma.oma74 ='1'  
   LET m_oma.omaconf = 'Y'
   LET m_oma.omavoid = 'N'
   LET m_oma.omaprsw = 0
   LET m_oma.omauser = g_user
   LET m_oma.omaoriu = g_user 
   LET m_oma.omaorig = g_grup 
   LET m_oma.omagrup = g_grup
   LET m_oma.omadate = TODAY
END FUNCTION
