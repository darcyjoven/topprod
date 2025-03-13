# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmt253_1.4gl
# Descriptions...: 跨工廠 --庫存過帳--過帳還原--單位檢查--
# Date & Author..: 06/02/17 By ice
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: TQC-6A0079    06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun Lock imgg_file 失敗,不能直接rollback
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_tlf2/s_mupimg傳值營運中心改成機構別
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/16 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980093 09/09/23 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ina               RECORD LIKE ina_file.*,
    g_yy,g_mm		LIKE type_file.num5,            #No.FUN-680120 SMALLINT            #
    b_inb               RECORD LIKE inb_file.*,
    g_ima86             LIKE ima_file.ima86,
    g_imd10             LIKE imd_file.imd10
DEFINE l_dbs            LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
DEFINE l_plant          LIKE type_file.chr20            #No.FUN-870007
DEFINE l_t_dbs          LIKE type_file.chr21             #No.FUN-680120 VARCHAR(20)
DEFINE g_forupd_sql     STRING    #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt            LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE l_sql            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
#FUNCTION t253_ina_sel(p_ina01,p_dbs) #FUN-980093 mark
FUNCTION t253_ina_sel(p_ina01,p_plant)  #FUN-980093 add
   DEFINE p_ina01   LIKE ina_file.ina01,
          p_dbs     LIKE type_file.chr21             #No.FUN-680120 VARCHAR(21)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()           
     #LET p_dbs = g_dbs_new     
     #CALL s_gettrandbs()       
     #LET p_dbs_tra = g_dbs_tra 
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
 
   #LET l_sql = " SELECT * FROM ",p_dbs CLIPPED,"ina_file ", #FUN-980093 mark
   #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"ina_file ", #FUN-980093 add
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'ina_file'),  #FUN-A50102
               "  WHERE ina01 = '",p_ina01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   #No.CHI-950007  --Begin
   PREPARE t253_ina_sel FROM l_sql                                                                                                       
#  DECLARE t253_ina_cs CURSOR FOR t253_ina_sel
   EXECUTE t253_ina_sel INTO g_ina.*
   #No.CHI-950007  --End  
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_success="N" 
      RETURN
   END IF
END FUNCTION
 
#FUNCTION t253_sma(p_dbs) #FUN-980093 mark
FUNCTION t253_sma(p_plant)  #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()            
     #LET p_dbs = g_dbs_new      
     #CALL s_gettrandbs()        
     #LET p_dbs_tra = g_dbs_tra  
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
 
   
   #LET l_sql = " SELECT * FROM ",p_dbs CLIPPED,"sma_file "
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'sma_file')  #FUN-A50102
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   #No.CHI-950007  --Begin
   PREPARE t253_sma FROM l_sql
#  DECLARE t253_sma_cs CURSOR FOR t253_sma
   EXECUTE t253_sma INTO g_sma.*
   #No.CHI-950007  --End  
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_success="N" 
      RETURN
   END IF   
END FUNCTION
 
#FUNCTION t253_u_ina(p_dbs,p_flag) #FUN-980093 mark
FUNCTION t253_u_ina(p_plant,p_flag) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          p_flag  LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()
     #LET p_dbs = g_dbs_new
     #CALL s_gettrandbs()
     #LET p_dbs_tra = g_dbs_tra
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
 
   IF p_flag = 'Y' THEN
      #LET l_sql = " UPDATE ",p_dbs CLIPPED,"ina_file ", #FUN-980093 mark
      #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"ina_file ", #FUN-980093 add
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ina_file'), #FUN-A50102
                  "    SET inapost = 'Y' ",
                  "  WHERE ina01 = '",g_ina.ina01,"' "
   ELSE
      #LET l_sql = " UPDATE ",p_dbs CLIPPED,"ina_file ", #FUN-980093 mark
      #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"ina_file ", #FUN-980093 add
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ina_file'), #FUN-A50102
                  "    SET inapost = 'N', ",
                  "        ina08 = '0' ",
                  "  WHERE ina01 = '",g_ina.ina01,"' "
   END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE upd_ina FROM l_sql
   EXECUTE upd_ina
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd inapost: ',SQLCA.SQLCODE,1)
      LET g_success='N' 
      RETURN
   END IF
END FUNCTION
 
FUNCTION t253_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       #p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_dbs) #FUN-980093 mark
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_plant) #FUN-980093 add
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         p_dbs      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
         p_type     LIKE type_file.num10             #No.FUN-680120 INTEGER
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
    IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF
    IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF
    LET g_forupd_sql =
        #"SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM ",p_dbs CLIPPED,"imgg_file ", #FUN-980093 mark
        #"SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980093 add
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
        "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)            #FUN-B80061     ADD
    CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_forupd_sql,p_plant) RETURNING g_forupd_sql #FUN-980093
   # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #FUN-B80061     MARK  
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
#       ROLLBACK WORK   #No.TQC-930155
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
#       ROLLBACK WORK  #No.TQC-930155
       RETURN
    END IF
 
    LET l_sql = "SELECT ima25,ima906 ",
                #"  FROM ",p_dbs CLIPPED,"ima_file ",                
                "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01 = '",p_imgg01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima25_pre FROM l_sql
    EXECUTE ima25_pre INTO l_ima25,l_ima906
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF
 
    #CALL s_umfchkm(p_imgg01,p_imgg09,l_ima25,p_dbs) #FUN-980093 mark
    CALL s_umfchkm(p_imgg01,p_imgg09,l_ima25,p_plant)  #FUN-980093 add
         RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' 
       RETURN
    END IF
 
    #CALL s_mupimgg(p_type,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg10,g_ina.ina02,p_dbs) #FUN-980093 mark
    CALL s_mupimgg(p_type,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg10,g_ina.ina02,p_plant) #FUN-980093 add
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
#FUNCTION t253_g_s(p_ina01,p_dbs)   #No.FUN-870007-mark
FUNCTION t253_g_s(p_ina01,p_plant)  #No.FUN-870007
   DEFINE p_ina01   LIKE ina_file.ina01,
          p_dbs     LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_cnt     LIKE type_file.num10             #No.FUN-680120 INTEGER
   DEFINE p_plant  LIKE type_file.chr20
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
       
   IF s_shut(0) THEN RETURN END IF
   WHENEVER ERROR CALL cl_err_msg_log
   LET g_imd10 = 'S' 
 
#No.FUN-870007-start-
#   LET l_dbs = p_dbs
   LET l_plant = p_plant
   LET g_plant_new = l_plant CLIPPED
   CALL s_getdbs()  #FUN-980093 add
   CALL s_gettrandbs()
   LET p_dbs_tra = g_dbs_tra   #FUN-980093 add
   LET l_dbs = s_dbstring(g_dbs_new)
#No.FUN-870007--end--
 
   #CALL t253_ina_sel(p_ina01,l_dbs)  #FUN-980093 mark
   CALL t253_ina_sel(p_ina01,p_plant) #FUN-980093 add
   IF g_success='N' THEN RETURN END IF
   
   IF g_ina.inapost = 'Y' THEN 
      CALL cl_err('',9023,0)
      LET g_success = 'N' 
      RETURN 
   END IF
   IF g_ina.inapost = 'X' THEN 
      CALL cl_err('',9024,0)
      LET g_success = 'N'
      RETURN END IF
   IF g_ina.inaconf!= 'Y' THEN 
      CALL cl_err('','aap-717',0)
      LET g_success = 'N' 
      RETURN 
   END IF
 
   IF g_ina.inamksg = 'Y' THEN
      IF g_ina.ina08 != '1' THEN
         CALL cl_err('','aim-317',0)
         LET g_success = 'N' 
         RETURN
      END IF
   END IF
 
   #CALL t253_sma(l_dbs) #FUN-980093 mark
   CALL t253_sma(p_plant) #FUN-980093 add
   IF g_success='N' THEN RETURN END IF
   IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success="N"
      RETURN
   END IF
   CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51 THEN 
      CALL cl_err(g_yy,'mfg6090',0)
      LET g_success="N" 
      RETURN
   ELSE 
      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN 
         CALL cl_err(g_mm,'mfg6091',0) 
         LET g_success="N"
         RETURN
      END IF
   END IF
 
   IF g_aza.aza23 MATCHES '[Yy]' AND g_ina.inamksg MATCHES '[Yy]' THEN  
      IF g_ina.ina08 <> '1' THEN
          #必須簽核狀況為已核准，才能執行過帳
          CALL cl_err(g_ina.ina01,'aim-317',1)
          LET g_success="N"
          RETURN
      END IF
   END IF
 
   #IF NOT cl_confirm('mfg0176') THEN RETURN END IF
   LET g_success = 'Y'
   
   #LET g_forupd_sql = "SELECT * FROM ",l_dbs CLIPPED,"ina_file WHERE ina01 = ? FOR UPDATE "  #FUN-980093 mark
   #LET g_forupd_sql = "SELECT * FROM ",p_dbs_tra CLIPPED,"ina_file WHERE ina01 = ? FOR UPDATE " #FUN-980093 add
   LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ina_file ')," WHERE ina01 = ? FOR UPDATE " #FUN-A50102
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)       #FUN-B80061    ADD	 
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_forupd_sql,p_plant) RETURNING g_forupd_sql #FUN-980093
  # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)      #FUN-B80061    MARK 
   DECLARE t253_cl2 CURSOR FROM g_forupd_sql 
   OPEN t253_cl2 USING g_ina.ina01
   IF STATUS THEN
      CALL cl_err("OPEN t253_ina:", STATUS, 1)
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t253_cl2 INTO g_ina.*
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl2:", STATUS, 1)
      CLOSE t253_cl2
      LET g_success = 'N'
      RETURN
   END IF
   
   #CALL t253_g_s1(l_dbs)  #FUN-980093 mark
   CALL t253_g_s1(p_plant) #FUN-980093 add
   IF SQLCA.SQLCODE THEN 
      LET g_success='N' 
      CLOSE t253_cl2
      RETURN 
   END IF
 
   IF g_success = 'Y' THEN
      #CALL t253_u_ina(l_dbs,'Y') #FUN-980093 mark
      CALL t253_u_ina(p_plant,'Y') #FUN-980093 add
      IF g_success = 'N' THEN
         CLOSE t253_cl2
         RETURN
      END IF
   END IF
   CLOSE t253_cl2
END FUNCTION
 
#FUNCTION t253_g_s1(p_dbs)  #FUN-980093 mark
FUNCTION t253_g_s1(p_plant)  #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()
     #LET p_dbs = g_dbs_new
     #CALL s_gettrandbs()
     #LET p_dbs_tra = g_dbs_tra
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
   
   LET l_dbs = p_dbs
   #LET l_sql = " SELECT * FROM ",l_dbs CLIPPED,"inb_file  ", #FUN-980093 mark
   #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"inb_file  ", #FUN-980093 add
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'inb_file'), #FUN-A50102
               "  WHERE inb01 = '",g_ina.ina01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE t253_inb_1 FROM l_sql                                                                                                       
   DECLARE t253_inb_cs CURSOR FOR t253_inb_1
   FOREACH t253_inb_cs INTO b_inb.*
      IF STATUS THEN
         EXIT FOREACH
         LET g_success = 'N'
      END IF
 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
          MESSAGE '_s1() read no:',b_inb.inb03 USING '#####&',' parts: ', b_inb.inb04
      ELSE
          DISPLAY '_s1() read no:',b_inb.inb03 USING '#####&',' parts: ', b_inb.inb04 AT 2,1
      END IF
      IF cl_null(b_inb.inb04) THEN
         CONTINUE FOREACH
      END IF
 
      IF g_sma.sma115 = 'Y' THEN
         #CALL t253_update_du(l_dbs) #FUN-980093 mark
         CALL t253_update_du(p_plant) #FUN-980093 add
      END IF
      IF g_success = 'N' THEN
         RETURN
      END IF
      
      CALL t253_update(b_inb.inb05,b_inb.inb06,b_inb.inb07,
                       #b_inb.inb09,b_inb.inb08,b_inb.inb08_fac,l_dbs) #FUN-980093 mark
                       b_inb.inb09,b_inb.inb08,b_inb.inb08_fac,p_plant)  #FUN-980093 add
   END FOREACH
END FUNCTION
 
#FUNCTION t253_update_du(p_dbs) #FUN-980093 mark
FUNCTION t253_update_du(p_plant) #FUN-980093 add
   DEFINE p_dbs     LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(400)
          l_ima25   LIKE ima_file.ima25,
          g_ima906  LIKE ima_file.ima906,
          g_ima907  LIKE ima_file.ima907,
          u_type    LIKE type_file.num5           #No.FUN-680120 SMALLINT
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()
     #LET p_dbs = g_dbs_new
     #CALL s_gettrandbs()
     #LET p_dbs_tra = g_dbs_tra
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
 
   LET l_sql = "SELECT ima906,ima907,ima25 ",
               #"  FROM ",p_dbs CLIPPED,"ima_file ",
               "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
               " WHERE ima01 = '",b_inb.inb04,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE sel_ima FROM l_sql
   EXECUTE sel_ima INTO g_ima906,g_ima907,l_ima25 
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      RETURN
   END IF
    
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   CASE WHEN g_ina.ina00 MATCHES "[12]" LET u_type=-1
	      WHEN g_ina.ina00 MATCHES "[34]" LET u_type=+1
	      WHEN g_ina.ina00 MATCHES "[56]" LET u_type=0
   END CASE
 
   IF g_ima906 = '2' THEN                        #子母單位
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t253_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                         #b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2',l_dbs) #FUN-980093 mark
                         b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2',p_plant) #FUN-980093 add
         IF g_success='N' THEN
            RETURN
         END IF
#        IF NOT cl_null(b_inb.inb907) AND b_inb.inb907 <> 0 THEN                 #CHI-860005 Mark
         IF NOT cl_null(b_inb.inb907) THEN                                       #CHI-860005
            CALL t253_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           #b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2') #FUN-980093 mark
                           b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2',p_plant) #FUN-980093 add
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
      IF NOT cl_null(b_inb.inb902) THEN
         CALL t253_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            #b_inb.inb07,b_inb.inb902,b_inb.inb903,b_inb.inb904,u_type,'1',l_dbs) #FUN-980093 mark
                            b_inb.inb07,b_inb.inb902,b_inb.inb903,b_inb.inb904,u_type,'1',p_plant)  #FUN-980093 add
         IF g_success='N' THEN
            RETURN
         END IF
#        IF NOT cl_null(b_inb.inb904) AND b_inb.inb904 <> 0 THEN                 #CHI-860005 Mark
         IF NOT cl_null(b_inb.inb904) THEN                                       #CHI-860005 
            CALL t253_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           #b_inb.inb904,0,b_inb.inb902,b_inb.inb903,u_type,'1') #FUN-980093 mark
                           b_inb.inb904,0,b_inb.inb902,b_inb.inb903,u_type,'1',p_plant) #FUN-980093 add
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN                        #參考單位
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t253_upd_imgg('2',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            #b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2',l_dbs) #FUN-980093 mark
                            b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2',p_plant) #FUN-980093 add
         IF g_success = 'N' THEN
            RETURN
         END IF
#        IF NOT cl_null(b_inb.inb907) AND b_inb.inb907 <> 0 THEN                 #CHI-860005 Mark
         IF NOT cl_null(b_inb.inb907) THEN                                       #CHI-860005
            CALL t253_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           #b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2') #FUN-980093 mark
                           b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2',p_plant) #FUN-980093 add
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
      #No.CHI-770019  --Begin
      #IF NOT cl_null(b_inb.inb902) THEN
      #   IF NOT cl_null(b_inb.inb904) AND b_inb.inb904 <> 0 THEN
      #      CALL t253_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
      #                     b_inb.inb904,0,b_inb.inb902,b_inb.inb903,u_type,'1')
      #      IF g_success='N' THEN
      #         RETURN
      #      END IF
      #   END IF
      #END IF
      #No.CHI-770019  --End  
   END IF
 
END FUNCTION
 
FUNCTION t253_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   #u_type,p_flag)
                   u_type,p_flag,p_plant)
   DEFINE p_ware     LIKE imgg_file.imgg02,	         #倉庫
          p_loca     LIKE imgg_file.imgg03,	         #儲位
          p_lot      LIKE imgg_file.imgg04,              #批號
          p_unit     LIKE imgg_file.imgg09,
          p_qty      LIKE imgg_file.imgg10,              #數量  
          p_img10    LIKE imgg_file.imgg10,              #異動后數量
          p_uom      LIKE imgg_file.imgg09,              #img 單位
          p_factor   LIKE imgg_file.imgg21,  	         #轉換率
          l_imgg10   LIKE imgg_file.imgg10,
          u_type     LIKE type_file.num5,          #No.FUN-680120 SMALLINT             #+1:雜收 -1:雜發  0:報廢
          p_flag     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          g_cnt      LIKE type_file.num5           #No.FUN-680120 SMALLINT
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_dbs           LIKE azp_file.azp03        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
   IF cl_null(p_qty)  THEN LET p_qty=0    END IF
   IF p_uom IS NULL THEN
      CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
 
   LET l_sql = " SELECT imgg10 ",
               #"   FROM ",l_dbs CLIPPED,"imgg_file ", #FUN-980093 mark
               #"   FROM ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980093 add
               "   FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-50102
               "  WHERE imgg01 = '",b_inb.inb04,"' ",
               "    AND imgg02 = '",p_ware,"' ",
               "    AND imgg03 = '",p_loca,"' ",
               "    AND imgg04 = '",p_lot,"' ",
               "    AND imgg09 = '",p_uom,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE imgg_pre FROM l_sql
   DECLARE imgg_cur CURSOR FOR imgg_pre
   EXECUTE imgg_pre INTO l_imgg10
   IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
   INITIALIZE g_tlff.* TO NULL
   LET g_tlff.tlff01=b_inb.inb04                #異動料件編號
   IF g_ina.ina00 MATCHES "[1256]" THEN
      #----來源----
      LET g_tlff.tlff02=50                      #'Stock'
      LET g_tlff.tlff020=g_plant
      LET g_tlff.tlff021=p_ware                 #倉庫
      LET g_tlff.tlff022=p_loca                 #儲位
      LET g_tlff.tlff023=p_lot                  #批號
      LET g_tlff.tlff024=l_imgg10               #異動后數量
      LET g_tlff.tlff025=p_unit                 #庫存單位(ima_file or img_file)
      LET g_tlff.tlff026=b_inb.inb01            #雜發/報廢單號
      LET g_tlff.tlff027=b_inb.inb03            #雜發/報廢項次
      #---目的----
      IF g_ina.ina00 MATCHES "[12]" THEN
         LET g_tlff.tlff03=90
      ELSE 
         LET g_tlff.tlff03=40
      END IF
      LET g_tlff.tlff036=b_inb.inb11            #目的單號
   END IF
   LET g_tlff.tlff04= ' '                       #工作站
   LET g_tlff.tlff05= ' '                       #作業序號
   LET g_tlff.tlff06=g_ina.ina02                #發料日期
   LET g_tlff.tlff07=g_today                    #異動資料產生日期
   LET g_tlff.tlff08=TIME                       #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user                     #產生人
   LET g_tlff.tlff10=p_qty                      #異動數量
   LET g_tlff.tlff11=p_uom	                 #發料單位
   LET g_tlff.tlff12=p_factor                   #發料/庫存 換算率
   CASE WHEN g_ina.ina00 = '1' LET g_tlff.tlff13='aimt301'
        WHEN g_ina.ina00 = '2' LET g_tlff.tlff13='aimt311'
        WHEN g_ina.ina00 = '3' LET g_tlff.tlff13='aimt302'
        WHEN g_ina.ina00 = '4' LET g_tlff.tlff13='aimt312'
        WHEN g_ina.ina00 = '5' LET g_tlff.tlff13='aimt303'
        WHEN g_ina.ina00 = '6' LET g_tlff.tlff13='aimt313'
   END CASE
   LET g_tlff.tlff14=b_inb.inb15                #異動原因
   LET g_tlff.tlff17=g_ina.ina07              
   LET g_tlff.tlff19=g_ina.ina04
   LET g_tlff.tlff20=g_ina.ina06                #Project code
   LET g_tlff.tlff62=b_inb.inb12                #參考單號
   LET g_tlff.tlff64=b_inb.inb901               #手冊編號  
   LET l_dbs = l_dbs CLIPPED
   LET l_t_dbs = l_dbs[1,(LENGTH(l_dbs)-1)]
   IF cl_null(p_qty) OR p_qty=0 THEN
    # CALL s_tlff2(p_flag,NULL,l_t_dbs)   #No.FUN-980059
      #CALL s_tlff2(p_flag,NULL,l_plant)   #No.FUN-980059 #FUN-980093 mark
      CALL s_tlff2(p_flag,NULL,p_plant)   #No.FUN-980059 #FUN-980093 add
   ELSE
   #  CALL s_tlff2(p_flag,p_uom,l_t_dbs)  #No.FUN-980059
      #CALL s_tlff2(p_flag,p_uom,l_plant)  #No.FUN-980059 #FUN-980093 mark
      CALL s_tlff2(p_flag,p_uom,p_plant)  #No.FUN-980059 #FUN-980093 add
   END IF
END FUNCTION
 
#FUNCTION t253_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_dbs) #FUN-980093 mark
FUNCTION t253_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_plant) #FUN-980093 add
   DEFINE p_ware    LIKE tlf_file.tlf021,      #No.FUN-680120 VARCHAR(10)                    #倉庫 # TQC-6A0079
          p_loca    LIKE tlf_file.tlf022,      #No.FUN-680120 VARCHAR(10)                    #儲位 # TQC-6A0079
          p_lot     LIKE img_file.img04,      #LIKE cqo_file.cqo16,       #No.FUN-680120 VARCHAR(24)                    #批號     #TQC-B90211
          p_qty     LIKE tlf_file.tlf10,          #數量   
          p_uom     LIKE img_file.img09,       # Prog. Version..: '5.30.06-13.03.12(04)                    #img 單位  #TQC-840066
          p_factor  LIKE tlff_file.tlff12,     #No.FUN-680120 DECIMAL(16,8)               #轉換率
          p_dbs     LIKE type_file.chr21,      #No.FUN-680120 VARCHAR(21)
          l_factor  LIKE oeb_file.oeb12,       #No.FUN-680120 DECIMAL(16,8)               #轉換率
          u_type    LIKE type_file.num5,       #No.FUN-680120 SMALLINT                    # +1:雜收 -1:雜發  0:報廢
          l_qty     LIKE img_file.img10,   
          l_ima01   LIKE ima_file.ima01,
          l_ima25   LIKE ima_file.ima25,
#         l_imaqty  LIKE ima_file.ima262,
          l_imaqty  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_imafac  LIKE img_file.img21,
          l_img     RECORD
            img10   LIKE img_file.img10,
            img16   LIKE img_file.img16,
            img23   LIKE img_file.img23,
            img24   LIKE img_file.img24,
            img09   LIKE img_file.img09,
            img21   LIKE img_file.img21
                END RECORD,
         l_cnt      LIKE type_file.num5                       #No.FUN-680120 SMALLINT
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #FUN-A50102--mark--str--
     #CALL s_getdbs()
     #LET p_dbs = g_dbs_new
     #CALL s_gettrandbs()
     #LET p_dbs_tra = g_dbs_tra
     #FUN-A50102--mark--end--
    #--End   FUN-980093 add-------------------------------------
 
   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
 
   IF p_uom IS NULL THEN
      LET g_success = 'N'
      RETURN
   END IF
   #------------------------------------------- update img_file
   MESSAGE "update img_file ..."
 
   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                      #"  FROM ",p_dbs CLIPPED,"img_file ", #FUN-980093 mark
                      #"  FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980093 add
                      "  FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
                      " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)              #FUN-B80061     ADD
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_forupd_sql,p_plant) RETURNING g_forupd_sql #FUN-980093
  # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)             #FUN-B80061     MARK
   DECLARE img_lock CURSOR FROM g_forupd_sql
 
   OPEN img_lock USING b_inb.inb04,p_ware,p_loca,p_lot
   IF STATUS THEN
      LET g_success = 'N'
      RETURN
   END IF
   FETCH img_lock INTO l_img.*
   IF STATUS THEN
      LET g_success='N'
      RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   #CALL s_umfchkm(b_inb.inb04,p_uom,l_img.img09,p_dbs) #FUN-980093 mark
   CALL s_umfchkm(b_inb.inb04,p_uom,l_img.img09,p_plant) #FUN-980093 add
      RETURNING g_cnt,l_factor
   IF g_cnt = 1 THEN
      LET g_success ='N'
      RETURN
   END IF
   #carrier --Begin
   #LET p_qty = p_qty * l_factor
   LET l_qty = l_img.img10 - p_qty * l_factor
   # 統一由 s_upimg來做庫存不足(sma894)的判斷
 
#  CALL s_mupimg(-1,b_inb.inb04,p_ware,p_loca,p_lot,p_qty*l_factor,g_ina.ina02,p_dbs,0,'','')  #No.FUN-850100 #No.FUN-870007-mark
   #CALL s_mupimg(-1,b_inb.inb04,p_ware,p_loca,p_lot,p_qty*l_factor,g_ina.ina02,l_plant,0,'','') #No.FUN-870007 #FUN-980093 mark
   CALL s_mupimg(-1,b_inb.inb04,p_ware,p_loca,p_lot,p_qty*l_factor,g_ina.ina02,p_plant,0,'','') #No.FUN-870007 #FUN-980093 add
   #carrier --End  
   IF g_success='N' THEN
      RETURN
   END IF
   #------------------------------------------- update ima_file
   MESSAGE "update ima_file ..."
   #LET g_forupd_sql = "SELECT ima25 FROM ",p_dbs CLIPPED,"ima_file WHERE ima01= ? FOR UPDATE " #FUN-560183 del ima86
   LET g_forupd_sql = "SELECT ima25 FROM ",cl_get_target_table(p_plant,'ima_file')," WHERE ima01= ? FOR UPDATE " #FUN-50102
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)          #FUN-B80061     ADD 
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)         #FUN-B80061     MARK
   DECLARE ima_lock CURSOR FROM g_forupd_sql
 
   OPEN ima_lock USING b_inb.inb04
   IF STATUS THEN
      LET g_success = 'N'
      CLOSE ima_lock
      RETURN
   END IF
   FETCH ima_lock INTO l_ima25     #,g_ima86 #FUN-560183
   IF STATUS THEN
      LET g_success = 'N'
      CLOSE ima_lock
      RETURN
   END IF
 
   IF b_inb.inb08=l_ima25 THEN
      LET l_imafac = 1
   ELSE
      CALL s_umfchk(b_inb.inb04,l_img.img09,l_ima25)
         RETURNING g_cnt,l_imafac
      #-單位換算率抓不到
      IF g_cnt = 1 THEN
         LET g_success ='N'
         RETURN
      END IF
   END IF
 
   IF cl_null(l_imafac) THEN
      LET l_imafac = 1
   END IF
   LET l_imaqty = p_qty * l_imafac
   #CALL t253_u_ima(l_dbs) #FUN-980093 mark
   CALL t253_u_ima(p_plant) #FUN-980093 add
   IF g_success='N' THEN
      RETURN
   END IF
 
   #------------------------------------------- insert tlf_file
   MESSAGE "insert tlf_file ..."
   IF g_success='Y' THEN
      #CALL t253_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,u_type) #FUN-980093 mark
      CALL t253_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,u_type,p_plant) #FUN-980093 add
   END IF
END FUNCTION
 
#FUNCTION t253_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,u_type)  #FUN-980093 mark
FUNCTION t253_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,u_type,p_plant) #FUN-980093 add
   DEFINE p_ware   LIKE img_file.img02,          #No.FUN-680120 VARCHAR(10)	         #倉庫
          p_loca   LIKE img_file.img03,          #No.FUN-680120 VARCHAR(10)     		 #儲位
          p_lot    LIKE img_file.img04,          #No.FUN-680120 VARCHAR(24)    		 #批號
          p_qty    LIKE tlf_file.tlf10,      
          p_uom    LIKE tlf_file.tlf11,          # Prog. Version..: '5.30.06-13.03.12(04)                 #img 單位
          p_factor LIKE tlff_file.tlff12,        #No.FUN-680120 DECIMAL(16,8) 		 #轉換率
          p_unit   LIKE ima_file.ima25,          #單位
          p_img10  LIKE img_file.img10,          #異動后數量
          u_type   LIKE type_file.num5,          #No.FUN-680120 SMALLINT	         # +1:雜收 -1:雜發  0:報廢
          l_sfb02  LIKE sfb_file.sfb02,
          l_sfb03  LIKE sfb_file.sfb03,
          l_sfb04  LIKE sfb_file.sfb04,
          l_sfb22  LIKE sfb_file.sfb22,
          l_sfb27  LIKE sfb_file.sfb27,
          l_sta    LIKE type_file.num5,           #No.FUN-680120 SMALLINT
          g_cnt    LIKE type_file.num5            #No.FUN-680120 SMALLINT
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_dbs           LIKE azp_file.azp03        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=b_inb.inb04                   #異動料件編號
   IF g_ina.ina00 MATCHES "[1256]" THEN
      #----來源----
      LET g_tlf.tlf02=50                         #'Stock'
      LET g_tlf.tlf020=g_plant
      LET g_tlf.tlf021=p_ware                    #倉庫
      LET g_tlf.tlf022=p_loca                    #儲位
      LET g_tlf.tlf023=p_lot                     #批號
      LET g_tlf.tlf024=p_img10                   #異動后數量
      LET g_tlf.tlf025=p_unit                    #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=b_inb.inb01               #雜發/報廢單號
      LET g_tlf.tlf027=b_inb.inb03               #雜發/報廢項次
      #---目的----
      IF g_ina.ina00 MATCHES "[12]"
         THEN LET g_tlf.tlf03=90
         ELSE LET g_tlf.tlf03=40
      END IF
      LET g_tlf.tlf036=b_inb.inb11               #目的單號
   END IF
   LET g_tlf.tlf04= ' '                          #工作站
   LET g_tlf.tlf05= ' '                          #作業序號
   LET g_tlf.tlf06=g_ina.ina02                   #發料日期
   LET g_tlf.tlf07=g_today                       #異動資料產生日期
   LET g_tlf.tlf08=TIME                          #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user                        #產生人
   LET g_tlf.tlf10=p_qty                         #異動數量
   LET g_tlf.tlf11=p_uom	                 #發料單位
   LET g_tlf.tlf12 =p_factor                     #發料/庫存 換算率
   CASE 
      WHEN g_ina.ina00 = '1' LET g_tlf.tlf13='aimt301'
      WHEN g_ina.ina00 = '2' LET g_tlf.tlf13='aimt311'
      WHEN g_ina.ina00 = '3' LET g_tlf.tlf13='aimt302'
      WHEN g_ina.ina00 = '4' LET g_tlf.tlf13='aimt312'
      WHEN g_ina.ina00 = '5' LET g_tlf.tlf13='aimt303'
      WHEN g_ina.ina00 = '6' LET g_tlf.tlf13='aimt313'
   END CASE
   LET g_tlf.tlf14=b_inb.inb15                   #異動原因
   LET g_tlf.tlf17=g_ina.ina07
   LET g_tlf.tlf19=g_ina.ina04
   LET g_tlf.tlf20=g_ina.ina06                   #Project code
   LET g_tlf.tlf62=b_inb.inb12                   #參考單號
   LET g_tlf.tlf64=b_inb.inb901                  #手冊編號  
#   CALL s_tlf2(1,0,l_dbs)  #No.FUN-870007-mark
   #CALL s_tlf2(1,0,l_plant) #No.FUN-870007 #FUN-980093 mark
   CALL s_tlf2(1,0,p_plant) #No.FUN-870007 #FUN-980093 add
END FUNCTION
 
#FUNCTION t253_p2_s(p_ina01,p_dbs)  #FUN-980093 mark
FUNCTION t253_p2_s(p_ina01,p_plant) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          p_ina01 LIKE ina_file.ina01,
          l_dbs   LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_ogc   RECORD LIKE ogc_file.*,   
          l_dt    LIKE type_file.dat               #No.FUN-680120 DATE
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
  
   LET l_dbs = p_dbs
   LET g_ina.ina01 = p_ina01
   #CALL t253_u_ina(l_dbs,'N') #FUN-980093 mark
   CALL t253_u_ina(p_plant,'N') #FUN-980093 add
   IF g_success = 'N' THEN
      RETURN 
   END IF
   #CALL t253_ina_sel(p_ina01,l_dbs) #FUN-980093 mark
   CALL t253_ina_sel(p_ina01,p_plant) #FUN-980093 add
   IF g_success = 'N' THEN
      RETURN 
   END IF
   
   #LET l_sql = " SELECT * FROM ",l_dbs CLIPPED,"inb_file  ", #FUN-980093 mark
   #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"inb_file  ", #FUN-980093 add
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'inb_file'), #FUN-50102
               "  WHERE inb01 = '",g_ina.ina01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE t253_inb_2 FROM l_sql                                                                                                       
   DECLARE t253_inb_2_cs CURSOR FOR t253_inb_2
   FOREACH t253_inb_2_cs INTO b_inb.*
      IF STATUS THEN 
         LET g_success='N' 
         RETURN 
      END IF
      IF cl_null(b_inb.inb04) THEN CONTINUE FOREACH END IF
      IF cl_null(b_inb.inb05) THEN LET b_inb.inb05=' ' END IF
      IF cl_null(b_inb.inb06) THEN LET b_inb.inb06=' ' END IF
      IF cl_null(b_inb.inb07) THEN LET b_inb.inb07=' ' END IF
      #CALL t253_u_imgg(l_dbs) #FUN-980093 mark
      CALL t253_u_imgg(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         RETURN 
      END IF
      #CALL t253_u_img(l_dbs)  #FUN-980093 mark
      CALL t253_u_img(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         RETURN 
      END IF
      #CALL t253_u_ima(l_dbs) #FUN-980093 mark
      CALL t253_u_ima(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         RETURN 
      END IF
      #CALL t253_u_tlf(l_dbs) #FUN-980093 mark
      CALL t253_u_tlf(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         RETURN 
      END IF
   END FOREACH
 
END FUNCTION
 
#FUNCTION t253_u_imgg(p_dbs) #FUN-980093 mark
FUNCTION t253_u_imgg(p_plant) #FUN-980093 add
   DEFINE p_dbs     LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_ima906  LIKE ima_file.ima906,
          l_ima25   LIKE ima_file.ima25
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
  
   #CALL t253_sma(p_dbs) #FUN-980093 mark
   CALL t253_sma(p_plant) #FUN-980093 add
   IF g_success='N' THEN RETURN END IF
   IF g_sma.sma115 = 'N' THEN RETURN END IF
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_inb.inb04
   IF l_ima906 = '1' THEN RETURN END IF
   IF cl_null(l_ima906) THEN LET g_success = 'N' RETURN END IF
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=b_inb.inb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' 
      RETURN
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      #CALL s_undo_dismantle(g_ina.ina01,b_inb.inb03)
      IF g_success='N' THEN RETURN END IF
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t253_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            b_inb.inb07,b_inb.inb905,b_inb.inb906,
                            #b_inb.inb907,1,'2',p_dbs) #FUN-980093 mark
                            b_inb.inb907,1,'2',p_plant) #FUN-980093 add
         IF g_success='N' THEN RETURN END IF
      END IF
      IF NOT cl_null(b_inb.inb902) THEN
         CALL t253_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            b_inb.inb07,b_inb.inb902,b_inb.inb903,
                            #b_inb.inb904,1,'1',p_dbs) #FUN-980093 mark
                            b_inb.inb904,1,'1',p_plant) #FUN-980093 add
         IF g_success='N' THEN RETURN END IF
      END IF
      #CALL t253_tlff_2(p_dbs) #FUN-980093 mark
      CALL t253_tlff_2(p_plant) #FUN-980093 add
      IF g_success='N' THEN RETURN END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t253_upd_imgg('2',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            b_inb.inb07,b_inb.inb905,b_inb.inb906,
                            #b_inb.inb907,1,'2',p_dbs) #FUN-980093 mark
                            b_inb.inb907,1,'2',p_plant) #FUN-980093 add
         IF g_success = 'N' THEN RETURN END IF
      END IF
      #CALL t253_tlff_2(p_dbs) #FUN-980093 mark
      CALL t253_tlff_2(p_plant) #FUN-980093 add
      IF g_success='N' THEN RETURN END IF
   END IF
 
END FUNCTION
 
#FUNCTION t253_u_img(p_dbs)  # Update img_file #FUN-980093 mark
FUNCTION t253_u_img(p_plant)  # Update img_file #FUN-980093 add
   DEFINE l_qty        LIKE img_file.img10,
          p_dbs        LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_flag       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_img09      LIKE img_file.img09,
          l_img10      LIKE img_file.img10,
          l_factor     LIKE tlff_file.tlff12         #No.FUN-680120 DECIMAL(16,8)               #轉換率
   DEFINE u_flag       LIKE type_file.num5           #No.FUN-680120 SMALLINT
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
   LET l_qty=b_inb.inb09*b_inb.inb08_fac
   
   #CALL t253_mchk_img(b_inb.inb04,b_inb.inb05,'','',p_dbs) #FUN-980093 mark
   CALL t253_mchk_img(b_inb.inb04,b_inb.inb05,'','',p_plant) #FUN-980093 add
      RETURNING l_flag,l_img09,l_img10
   IF l_flag = 1 THEN
      LET g_success ='N'
      RETURN
   END IF
   #CALL s_umfchkm(b_inb.inb04,b_inb.inb08,l_img09,p_dbs) #FUN-980093 mark
   CALL s_umfchkm(b_inb.inb04,b_inb.inb08,l_img09,p_plant) #FUN-980093 add
      RETURNING g_cnt,l_factor
   IF g_cnt = 1 THEN
      LET g_success ='N'
      RETURN
   END IF
   #carrier  --Begin
   LET l_qty = l_qty #* l_factor
   #carrier  --End  
#  CALL s_mupimg(1,b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,l_qty,g_today,p_dbs,0,'','')  #No.FUN-850100 #No.FUN-870007-mark
   #CALL s_mupimg(1,b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,l_qty,g_today,l_plant,0,'','')  #No.FUN-870007 #FUN-980093 mark
   CALL s_mupimg(1,b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,l_qty,g_today,p_plant,0,'','')  #No.FUN-870007  #FUN-980093 add
   IF g_success = 'N' THEN
      CALL cl_err('u_upimg(-1)','9050',0) 
      RETURN
   END IF
END FUNCTION
 
#FUNCTION t253_u_ima(p_dbs)  #------------------------------------ Update ima_file #FUN-980093 mark
FUNCTION t253_u_ima(p_plant)  #------------------------------------ Update ima_file #FUN-980093 add
   DEFINE  p_dbs   LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
#          l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26                  #NO.FUN-A20044
           l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
#  LET l_ima26=0 LET l_ima261=0 LET l_ima262=0 #NO.FUN-A20044
   LET l_avl_stk_mpsmrp = 0                    #NO.FUN-A20044 
   LET l_unavl_stk = 0                         #NO.FUN-A20044
   LET l_avl_stk = 0                           #NO.FUN-A20044  
   LET l_sql = " SELECT SUM(img10*img21) ",
               #"   FROM ",p_dbs CLIPPED,"img_file ", #FUN-980093 mark
               #"   FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980093 add
               "   FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
               "  WHERE img01 = '",b_inb.inb04,"' ",
               "    AND img23 = 'Y' AND img24 = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
#  PREPARE sel_ima26 FROM l_sql          #NO.FUN-A20044
#  EXECUTE sel_ima26 INTO l_ima26        #NO.FUN-A20044
   PREPARE sel_avl FROM l_sql            #NO.FUN-A20044
   EXECUTE sel_avl INTO l_avl_stk_mpsmrp #NO.FUN-A20044
   IF STATUS THEN CALL cl_err('sel sum1:',STATUS,1) LET g_success='N' END IF
#  IF l_ima26 IS NULL THEN LET l_ima26=0 END IF                       #NO.FUN-A20044
   IF l_avl_stk_mpsmrp IS NULL THEN LET l_avl_stk_mpsmrp = 0  END IF  #NO.FUN-A20044
   LET l_sql = "  SELECT SUM(img10*img21) ",
               #"    FROM ",p_dbs CLIPPED,"img_file ", #FUN-980093 mark
               #"    FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980093 add
               "    FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
               "  WHERE img01 = '",b_inb.inb04,"' ",
               "    AND img23 = 'N' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
#  PREPARE sel_ima261 FROM l_sql          #NO.FUN-A20044   
#  EXECUTE sel_ima261 INTO l_ima261       #NO.FUN-A20044
   PREPARE sel_avl1 FROM l_sql            #NO.FUN-A20044
   EXECUTE sel_avl1 INTO l_unavl_stk      #NO.FUN-A20044
   IF STATUS THEN CALL cl_err('sel sum2:',STATUS,1) LET g_success='N' END IF
#  IF l_ima261 IS NULL THEN LET l_ima261=0 END IF          #NO.FUN-A20044
   IF l_unavl_stk  IS NULL THEN LET l_unavl_stk=0 END IF   #NO.FUN-A20044
   LET l_sql = "  SELECT SUM(img10*img21) ",
               #"    FROM ",p_dbs CLIPPED,"img_file ", #FUN-980093 mark
               #"    FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980093 add
               "    FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
               "  WHERE img01 = '",b_inb.inb04,"' ",
               "    AND img23 = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
#  PREPARE sel_ima262 FROM l_sql          #NO.FUN-A20044 
#  EXECUTE sel_ima262 INTO l_ima262       #NO.FUN-A20044
   PREPARE sel_avl2 FROM l_sql            #NO.FUN-A20044
   EXECUTE sel_avl2 INTO l_avl_stk        #NO.FUN-A20044
   IF STATUS THEN CALL cl_err('sel sum3:',STATUS,1) LET g_success='N' END IF
#  IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
   IF l_avl_stk  IS NULL THEN LET l_avl_stk=0 END IF     #NO.FUN-A20044
#  LET l_sql = " UPDATE ",p_dbs CLIPPED,"ima_file SET ima26 = ",l_ima26,", ", 
#              "                                      ima261= ",l_ima261,", ",
#              "                                      ima262= ",l_ima262,",  ",
#              "                                      ima74 = '",g_ina.ina02,"' ",
   #LET l_sql = " UPDATE ",p_dbs CLIPPED,"ima_file SET ima74 = '",g_ina.ina02,"' ",
   LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ima_file')," SET ima74 = '",g_ina.ina02,"' ",  #FUN-50102
               "                                WHERE ima01 = '",b_inb.inb04,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-50102
#  PREPARE upd_ima26 FROM l_sql #NO.FUN-A20044
#  EXECUTE upd_ima26            #NO.FUN-A20044
   PREPARE upd_avl FROM l_sql   #NO.FUN-A20044
   EXECUTE upd_avl              #NO.FUN-A20044
   IF STATUS THEN
#     CALL cl_err('upd ima26*:',STATUS,1) LET g_success='N' RETURN     #NO.FUN-A20044
      CALL cl_err('upd avl_stk:',STATUS,1) LET g_success='N' RETURN    #NO.FUN-A20044
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd ima26*:','mfg0177',1) LET g_success='N' RETURN  #NO.FUN-A20044
      CALL cl_err('upd avl_stk:','mfg0177',1) LET g_success='N' RETURN #NO.FUN-A20044
   END IF
END FUNCTION
 
#FUNCTION t253_u_tlf(p_dbs) #------------------------------------ Update tlf_file #FUN-980093 mark
FUNCTION t253_u_tlf(p_plant) #------------------------------------ Update tlf_file #FUN-980093 add
    DEFINE p_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
    DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
    DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
    DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
    DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
    DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
    
     #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
      LET g_plant_new = p_plant
      CALL s_getdbs()
      LET p_dbs = g_dbs_new
      CALL s_gettrandbs()
      LET p_dbs_tra = g_dbs_tra
     #--End   FUN-980093 add-------------------------------------

  ##NO.FUN-8C0131   add--begin  
    #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"tlf_file ",
    LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'tlf_file'), #FUN-A50102
                "  WHERE tlf01 = '",b_inb.inb04,"' ",
                "    AND ((tlf026= '",g_ina.ina01,"' ",
                "    AND tlf027 = ",b_inb.inb03,") OR ",
                "        (tlf036= '",g_ina.ina01,"' ",
                "    AND tlf037 = ",b_inb.inb03,")) ",  
                "    AND tlf06  = '",g_ina.ina02,"' " 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-A50102
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102            
    DECLARE t253_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t253_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH 
  ##NO.FUN-8C0131   add--end        
    #LET l_sql = " DELETE FROM ",p_dbs CLIPPED,"tlf_file ", #FUN-980093 mark
    #LET l_sql = " DELETE FROM ",p_dbs_tra CLIPPED,"tlf_file ", #FUN-980093 add
    LET l_sql = " DELETE FROM ",cl_get_target_table(p_plant,'tlf_file'), #FUN-50102
                "  WHERE tlf01 = '",b_inb.inb04,"' ",
                "    AND ((tlf026= '",g_ina.ina01,"' ",
                "    AND tlf027 = ",b_inb.inb03,") OR ",
                "        (tlf036= '",g_ina.ina01,"' ",
                "    AND tlf037 = ",b_inb.inb03,")) ",  #異動單號/項次 
                "    AND tlf06  = '",g_ina.ina02,"' "   #異動日期
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
    PREPARE upd_tlf FROM l_sql
    EXECUTE upd_tlf
    IF STATUS THEN
       CALL cl_err('del tlf:',STATUS,1) LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlf:','mfg0177',1) LET g_success='N' RETURN
    END IF
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       #IF NOT s_untlf1(p_dbs_tra) THEN 
       IF NOT s_untlf1(p_plant) THEN   #FUN-A50102
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end    
END FUNCTION
 
#FUNCTION t253_tlff_2(p_dbs) #FUN-980093 mark
FUNCTION t253_tlff_2(p_plant) #FUN-980093 add
    DEFINE p_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
    DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
    DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
    
     #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
      LET g_plant_new = p_plant
      CALL s_getdbs()
      LET p_dbs = g_dbs_new
      CALL s_gettrandbs()
      LET p_dbs_tra = g_dbs_tra
     #--End   FUN-980093 add-------------------------------------
    
    #LET l_sql = " DELETE FROM ",p_dbs CLIPPED,"tlff_file ", #FUN-980093 mark
    #LET l_sql = " DELETE FROM ",p_dbs_tra CLIPPED,"tlff_file ",#FUN-980093 add
    LET l_sql = " DELETE FROM ",cl_get_target_table(p_plant,'tlff_file'),#FUN-50102
                "  WHERE tlff01 = '",b_inb.inb04,"' ",
                "    AND ((tlff026 = '",g_ina.ina01,"' ",
                "    AND tlff027 = ",b_inb.inb03,") OR ",
                "       (tlff036 = '",g_ina.ina01,"' ",
                "    AND tlff037 = ",b_inb.inb03,")) ", #異動單號/項次 
                "    AND tlff06  = '",g_ina.ina02,"' "  #異動日期
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
    PREPARE upd_tlff FROM l_sql
    EXECUTE upd_tlff
    IF SQLCA.SQLCODE THEN
       CALL cl_err('del tlff:',SQLCA.SQLCODE,1)
       LET g_success='N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlff:','mfg0177',1) 
       LET g_success='N' 
       RETURN
    END IF
END FUNCTION
 
#FUNCTION t253_mchk_img18(p_item,p_ware,p_loc,p_lot,p_date,p_dbs)  #FUN-980093 mark
FUNCTION t253_mchk_img18(p_item,p_ware,p_loc,p_lot,p_date,p_plant) #FUN-980093 add
   DEFINE p_item     LIKE img_file.img01,
          p_ware     LIKE img_file.img02,
          p_loc      LIKE img_file.img03,
          p_lot      LIKE img_file.img04,
          p_date     LIKE img_file.img18,
          p_dbs      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_cnt      LIKE type_file.num10,            #No.FUN-680120 INTEGER
          l_sql      LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(600)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
          
   IF cl_null(p_loc) THEN LET p_loc = ' ' END IF
   IF cl_null(p_lot) THEN LET p_lot = ' ' END IF
   #LET l_sql=" SELECT COUNT(*) FROM ",p_dbs CLIPPED,"img_file", #FUN-980093 mark
   #LET l_sql=" SELECT COUNT(*) FROM ",p_dbs_tra CLIPPED,"img_file", #FUN-980093 add
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
             "  WHERE img01 = '",p_item,"' ",
             "    AND img02 = '",p_ware,"' ",
             "    AND img03 = '",p_loc,"' ",
             "    AND img04 = '",p_lot,"' ",
             "    AND img18 < '",p_date,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   #No.CHI-950007  --Begin
   PREPARE img18_pre FROM l_sql
#  DECLARE img18_cur  CURSOR FOR img18_pre
   EXECUTE img18_pre INTO l_cnt
   #No.CHI-950007  --End  
   RETURN l_cnt
END FUNCTION
 
#FUNCTION t253_mchk_img(p_item,p_ware,p_loc,p_lot,p_dbs) #FUN-980093 mark
FUNCTION t253_mchk_img(p_item,p_ware,p_loc,p_lot,p_plant) #FUN-980093 add
   DEFINE p_item     LIKE img_file.img01,
          p_ware     LIKE img_file.img02,
          p_loc      LIKE img_file.img03,
          p_lot      LIKE img_file.img04,
          p_dbs      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_img      RECORD LIKE img_file.*,
          l_sql      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(600)
          l_flag     LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
 
   LET l_flag = 0
   IF cl_null(p_loc) THEN LET p_loc = ' ' END IF
   IF cl_null(p_lot) THEN LET p_lot = ' ' END IF
   #LET l_sql=" SELECT * FROM ",p_dbs CLIPPED,"img_file", #FUN-980093 mark
   #LET l_sql=" SELECT * FROM ",p_dbs_tra CLIPPED,"img_file", #FUN-980093 add
   LET l_sql=" SELECT * FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-50102
             "  WHERE img01 = '",p_item ,"' ",
             "    AND img02 = '",p_ware ,"' ",
             "    AND img03 = '",p_loc  ,"' ",
             "    AND img04 = '",p_lot  ,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE s_pre FROM l_sql
   DECLARE s_cur  CURSOR FOR s_pre
   OPEN s_cur 
   FETCH s_cur INTO l_img.*
   IF SQLCA.sqlcode THEN
      LET l_flag = 1
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10 = 0 END IF
   RETURN l_flag,l_img.img09,l_img.img10
 
END FUNCTION
 
#FUNCTION t253_mchk_imgg10(p_item,p_ware,p_loc,p_lot,p_unit,p_dbs) #FUN-980093 mark
FUNCTION t253_mchk_imgg10(p_item,p_ware,p_loc,p_lot,p_unit,p_plant) #FUN-980093 add
   DEFINE p_item     LIKE imgg_file.imgg01,
          p_ware     LIKE imgg_file.imgg02,
          p_loc      LIKE imgg_file.imgg03,
          p_lot      LIKE imgg_file.imgg04,
          p_unit     LIKE imgg_file.imgg09,
          p_dbs      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_imgg10   LIKE imgg_file.imgg10, 
          l_sql      LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(600)
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------
          
   IF cl_null(p_loc) THEN LET p_loc = ' ' END IF
   IF cl_null(p_lot) THEN LET p_lot = ' ' END IF
   #LET l_sql=" SELECT imgg10 FROM ",p_dbs CLIPPED,"imgg_file", #FUN-980093 mark
   #LET l_sql=" SELECT imgg10 FROM ",p_dbs_tra CLIPPED,"imgg_file", #FUN-980093 add
   LET l_sql=" SELECT imgg10 FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-50102
             "  WHERE imgg01 = '",p_item,"' ",
             "    AND imgg02 = '",p_ware,"' ",
             "    AND imgg03 = '",p_loc,"' ",
             "    AND imgg04 = '",p_lot,"' ",
             "    AND imgg09 = '",p_unit,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   #No.CHI-950007  --Begin
   PREPARE imgg10_pre FROM l_sql
#  DECLARE imgg10_cur  CURSOR FOR imgg10_pre
   EXECUTE imgg10_pre INTO l_imgg10
   #No.CHI-950007  --End  
   IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
   RETURN l_imgg10
END FUNCTION

#FUN-B80061
