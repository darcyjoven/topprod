# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_transfer.4gl
# Descriptions...: 調撥單審核操作
# Date & Author..: No.FUN-AA0086 10/11/12 by lixia 
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0083 11/12/22 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2

DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE     g_sql          STRING 
DEFINE     g_flag         LIKE type_file.chr1  
DEFINE     g_ruo          RECORD LIKE ruo_file.* 
DEFINE     g_img02_1      LIKE img_file.img02
DEFINE     g_img03_1      LIKE img_file.img03
DEFINE     g_img04_1      LIKE img_file.img04
DEFINE     g_img02_2      LIKE img_file.img02
DEFINE     g_img03_2      LIKE img_file.img03
DEFINE     g_img04_2      LIKE img_file.img04
DEFINE     g_pmm          RECORD LIKE pmm_file.*
DEFINE     g_oga          RECORD LIKE oga_file.*
DEFINE     g_oea          RECORD LIKE oea_file.*
DEFINE     g_cnt          LIKE type_file.num10
DEFINE     g_sma142_chk   LIKE sma_file.sma142 #是否在途管理
DEFINE     g_sma143_chk   LIKE sma_file.sma143 #在途歸屬
 
#根據闖入的參數l_flag判處 1：撥出審核  2：撥入審核                   
FUNCTION s_transfer(p_ruo,p_flag) 
   DEFINE     p_flag         LIKE type_file.chr1  
   DEFINE     p_ruo          RECORD LIKE ruo_file.* 
   DEFINE     l_cnt          LIKE type_file.num5  
   DEFINE     l_sql          STRING   
   DEFINE     l_imd20        LIKE imd_file.imd20

   SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
   SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp 
   LET g_flag = p_flag
   LET g_ruo.* = p_ruo.*
   
   IF g_ruo.ruoacti = 'N' THEN #資料無效
      CALL cl_err('','art-145',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   IF g_ruo.ruoconf = '3' THEN #已結案
      CALL cl_err('','art-974',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   #撥出審核時
   IF g_flag = '1'  AND  g_ruo.ruoconf = '1' THEN  #已撥出審核
      CALL cl_err('','art-289',0)
      LET g_success = 'N'
      RETURN 
   END IF
   IF g_flag = '1'  AND  g_ruo.ruoconf = '2' THEN #已撥入審核
      CALL cl_err('','art-290',0) 
      LET g_success = 'N'
      RETURN 
   END IF 
   #撥入審核時
   IF g_flag = '2'  AND  g_ruo.ruoconf = '0' THEN #開立狀態不能撥入審核
      CALL cl_err('','art-286',0)
      LET g_success = 'N'
      RETURN 
   END IF
   IF g_flag = '2'  AND  g_ruo.ruoconf = '2' THEN  #已撥入審核
      CALL cl_err('','aim-100',0)
      LET g_success = 'N' 
      RETURN 
   END IF   

   IF cl_null(g_ruo.ruo14) THEN
      LET g_sma142_chk = 'N'
      LET g_sma143_chk = ''
   ELSE
      LET g_sma142_chk = 'Y'
      LET l_sql = "SELECT imd20 FROM ",cl_get_target_table(g_ruo.ruo04, 'imd_file'),
                  " WHERE imd01 = '",g_ruo.ruo14,"'",
                  "   AND imd10 = 'W' AND imd22 = 'Y' "
      PREPARE pre_imd FROM l_sql
      EXECUTE pre_imd INTO l_imd20  
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','SELECT imd_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF   
      IF l_imd20 = g_ruo.ruo04 THEN
         LET g_sma143_chk = '1'
      ELSE
         LET g_sma143_chk = '2'
      END IF
   END IF
   
   IF g_flag = '1' THEN #撥出審核
      IF g_plant <> g_ruo.ruo04 THEN  #撥出審核時當前營運中心必須為撥出營運中心
         CALL cl_err(g_ruo.ruo04,'art-972',0)
         LET g_success = 'N'
         RETURN
      END IF
      CALL s_transfer_out()
   ELSE
      IF g_flag = '2' THEN #撥入審核
         IF g_plant <> g_ruo.ruo05 THEN  #撥入審核時當前營運中心必須為撥入營運中心
            CALL cl_err(g_ruo.ruo05,'art-973',0)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_transfer_in()
      END IF
   END IF   
END FUNCTION 

#撥出審核
FUNCTION s_transfer_out() 
   
   IF g_sma142_chk = "N" THEN   
      #非在途非多角 
      IF g_ruo.ruo901 = 'N' THEN 
         CALL s_transfer_s(g_ruo.ruo04,g_ruo.ruo01,'1')       #倉庫間調撥（撥出到撥入）
         CALL s_transfer_a()       #產生調撥單 （撥入而且結案）
      ELSE
      #非在途多角
         CALL s_transfer_v()       #多角貿易（撥入與撥出之間）
         CALL s_transfer_a()  #產生調撥單 （撥入而且結案）
      END IF
   ELSE     
      #在途非多角   
      IF g_ruo.ruo901 = 'N' THEN
         CALL s_transfer_s(g_ruo.ruo04,g_ruo.ruo01,'1') #倉庫間調撥（撥出到在途）
         CALL s_transfer_a()       #產生調撥單 （撥入而且撥出審核）
      ELSE
      #在途多角  
         IF g_sma143_chk ='1' THEN #在途歸屬撥出
            CALL s_transfer_s(g_ruo.ruo04,g_ruo.ruo01,'1')    #倉庫間調撥（撥出到在途）
            CALL s_transfer_a()    #產生調撥單 （撥入而且撥出審核）
         ELSE
            CALL s_transfer_v()    #多角貿易（撥出與在途）
            CALL s_transfer_a()    #產生調撥單 （撥入而且撥出審核）
         END IF         
      END IF
   END IF
END FUNCTION 

#撥入審核
FUNCTION s_transfer_in() 
      #在途非多角   
      IF g_ruo.ruo901 = 'N' THEN
         CALL s_transfer_s(g_ruo.ruo05,g_ruo.ruo01,'2')       #倉庫間調撥（在途到撥入）
         CALL s_transfer_st()         
      ELSE
      #在途多角  
         IF g_sma143_chk ='1' THEN #在途歸屬撥出
            CALL s_transfer_v()    #多角貿易（在途到撥入）
            CALL s_transfer_st()
         ELSE
            CALL s_transfer_s(g_ruo.ruo05,g_ruo.ruo01,'2')    #倉庫間調撥（在途到撥入）
            CALL s_transfer_st()
         END IF         
      END IF    
END FUNCTION 

#多角貿易單據拋轉
FUNCTION s_transfer_v() 
   DEFINE l_ruoconf         LIKE ruo_file.ruoconf
   DEFINE l_pmm01           LIKE pmm_file.pmm01  #採購單號
   DEFINE l_poz17           LIKE poz_file.poz17  #流程是否要一次完成
   DEFINE l_pmm99           LIKE pmm_file.pmm99  #多角貿易流程序號 
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE p_plant_new       LIKE azp_file.azp01
   DEFINE p_plant_new_a     LIKE azp_file.azp01 
   

   CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,   #採購單號
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,   #單價
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22);  #幣種

   DELETE FROM p801_file;

   CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01, #訂單單號
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6);
   DELETE FROM p900_file;

      IF g_success = 'N' THEN
         RETURN
      END IF
      #1.撥入營運中心--產生采購單
      LET g_success = 'Y'
      CALL t256_pmm_ins()
      IF g_success = 'N' THEN         
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF

      #2.代采買--正拋
      LET g_from_plant = g_ruo.ruo05     #拋轉資料的來源
               
      CALL p801(g_pmm.pmm01,'N',TRUE)           
      IF g_success = 'N' THEN        
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF
      LET l_ruoconf = '1'

      LET l_pmm01 = g_pmm.pmm01
      
      LET g_sql = " SELECT pmm99 FROM ",cl_get_target_table(g_ruo.ruo05,'pmm_file'), 
                  "  WHERE pmm01 = '",g_pmm.pmm01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
      PREPARE pmm99_2_pre FROM g_sql
      EXECUTE pmm99_2_pre INTO l_pmm99
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmm01',g_pmm.pmm01,'select pmm99',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

      SELECT poz17 INTO l_poz17 FROM poz_file WHERE poz01 = g_ruo.ruo904
      IF cl_null(l_poz17) THEN LET l_poz17 = 'N' END IF
      #多角貿易流程需一次完成
      IF l_poz17 = 'Y' THEN
         #3.出貨工廠--生成出貨單
         CALL t256_oga_ins(l_pmm01)
         IF g_success = 'N' THEN           
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         CALL s_mtrade_last_plant(g_ruo.ruo904)     #最后一站的站別 & 營運中心
              RETURNING l_last_poy02,l_last_poy04
         
         #4.出貨工廠--出貨單過帳
         CALL t254_1('6',g_oga.oga01,l_last_poy04,g_ruo.ruo07,l_pmm99)   #出貨單過帳
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         #5.銷售逆拋
         CALL p900_p2(g_oga.oga01,g_oga.oga09,l_last_poy04)    #多角拋轉
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF
         LET l_ruoconf = '2'
      END IF

      LET g_ruo.ruo99 = l_pmm99
      UPDATE ruo_file SET ruoconf   = l_ruoconf,
                          ruo99   = g_ruo.ruo99,
                          ruomodu = g_user,
                          ruodate = g_today
                    WHERE ruo01   = g_ruo.ruo01
                      AND ruoplant = g_ruo.ruoplant
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('ruo01',g_ruo.ruo01,"UPDATE ruo_file",SQLCA.sqlcode,1)
         LET g_ruo.ruo06 = NULL
         LET g_success = 'N'
      ELSE
         LET g_ruo.ruoconf = l_ruoconf
      END IF
  
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()
   DROP TABLE p801_file;
   DROP TABLE p900_file;

   DISPLAY BY NAME g_ruo.ruoconf
   DISPLAY BY NAME g_ruo.ruo99
   
END FUNCTION 

#撥入營運中心--產生采購單
FUNCTION t256_pmm_ins()
   DEFINE l_poy         RECORD LIKE poy_file.*#多角貿易單身檔 
   DEFINE l_pmc         RECORD LIKE pmc_file.*#供應商基本資料檔
   DEFINE p_plant_new   LIKE azp_file.azp01
   DEFINE l_poy03       LIKE poy_file.poy03   #下游廠商編號
   DEFINE li_result     LIKE type_file.num5

   INITIALIZE g_pmm.* TO NULL  #採購單單頭

   LET g_pmm.pmm40 = 0   #未稅淨額
   LET g_pmm.pmm40t = 0  #含稅金額

   #撥入營運中心
   SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
    WHERE poy01 = poz01
      AND poy01 = g_ruo.ruo904
      AND poy02 = (SELECT MIN(poy02) FROM poy_file
    WHERE poy01 = g_ruo.ruo904)
  
   #撥入營運中心和apmi000中0站的營運中心不同
   IF g_ruo.ruo05 <> l_poy.poy04 THEN
      LET g_showmsg = g_ruo.ruo05,'/',l_poy.poy04
      CALL s_errmsg('ruo05,poy04',g_showmsg,'PLANT DIFF','atm-152',1)
      LET g_success = 'N'
      RETURN
   END IF

   #出貨站
   #流通配销时,调拨可能是很多站,而并不是原来的2站式   
   SELECT poy03 INTO l_poy03 FROM poy_file,poz_file #下游產商編號
    WHERE poz01 = g_ruo.ruo904
      AND poz01 = poy01
      AND poy02 = (SELECT MIN(poy02) + 1 FROM poy_file
    WHERE poy01 = g_ruo.ruo904)
    
   IF g_azw.azw04 = '2' THEN
      CALL t256_art(l_poy.*,l_poy03,g_ruo.ruo05) RETURNING l_poy.* #取供應商資料
   END IF   

   #撥入營運中心設定的供應商資料   
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo05,'pmc_file'),  
               " WHERE pmc01 = '",l_poy03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql #FUN-A50102
   PREPARE t256_pmc_p1 FROM g_sql
   EXECUTE t256_pmc_p1 INTO l_pmc.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',l_poy03,'SELECT pmc',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   LET g_pmm.pmm01 = l_poy.poy35    #採購單號
   LET g_pmm.pmm02 = 'TAP'          #採購單性質
   LET g_pmm.pmm03 = 0              #更動序號
   IF g_azw.azw04 = '2' THEN
      LET g_pmm.pmm04 = g_today     #採購日期
      LET g_pmm.pmm12 = g_user      #採購員
      LET g_pmm.pmm13 = g_grup      #採購部門
   ELSE
      LET g_pmm.pmm04 = g_ruo.ruo07 #採購日期
      LET g_pmm.pmm12 = g_ruo.ruo08 #採購員
      LET g_pmm.pmm13 = g_ruo.ruogrup#採購部門
   END IF
   LET g_pmm.pmm05 = NULL           #專案號碼
   LET g_pmm.pmm06 = NULL           #預算號碼
   LET g_pmm.pmm07 = NULL           #單據分類
   LET g_pmm.pmm08 = NULL           #PBI
   LET g_pmm.pmm09 = l_poy03        #供應廠商
   LET g_pmm.pmm10 = l_pmc.pmc15    #送貨地址
   LET g_pmm.pmm11 = l_pmc.pmc16    #帳單地址
   LET g_pmm.pmm14 = g_pmm.pmm13    #收貨部門
   LET g_pmm.pmm15 = g_user         #確認人
   LET g_pmm.pmm16 = NULL           #運送方式
   LET g_pmm.pmm17 = NULL           #代理商
   LET g_pmm.pmm18 = 'Y'            #確認碼
   LET g_pmm.pmm20 = l_poy.poy06    #付款方式
   LET g_pmm.pmm21 = l_poy.poy09    #稅別
   LET g_pmm.pmm22 = l_poy.poy05    #幣別
   IF cl_null(g_pmm.pmm20) THEN LET g_pmm.pmm20 = l_pmc.pmc17 END IF
   IF cl_null(g_pmm.pmm21) THEN LET g_pmm.pmm21 = l_pmc.pmc47 END IF
   IF cl_null(g_pmm.pmm22) THEN LET g_pmm.pmm22 = l_pmc.pmc22 END IF
   LET g_pmm.pmm25 = '2'            #狀況碼
   LET g_pmm.pmm26 = l_poy.poy32    #理由碼
   LET g_pmm.pmm27 = g_today        #狀況異動日期
   LET g_pmm.pmm28 = NULL           #會計分類
   LET g_pmm.pmm29 = NULL           #會計科目
   LET g_pmm.pmm30 = 'N'            #收貨單列印否
   LET g_pmm.pmm31 = YEAR(g_today)  #會計年度
   LET g_pmm.pmm32 = MONTH(g_today) #會計期間
   LET g_pmm.pmm40 = 0              #總金額
   LET g_pmm.pmm401= 0              #代買總金額
   LET g_pmm.pmm41 = l_pmc.pmc49    #價格條件
   CALL s_currm(g_pmm.pmm22,g_pmm.pmm04,'B',g_ruo.ruo05)      #匯率
        RETURNING g_pmm.pmm42
   IF cl_null(g_pmm.pmm42) THEN LET g_pmm.pmm42 = 1 END IF
   
   LET g_sql = "SELECT gec04 FROM ",cl_get_target_table(g_ruo.ruo05,'gec_file'),  #稅率
               " WHERE gec01 = '",g_pmm.pmm21,"'",
               "   AND gec011= '1' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql 
   PREPARE t256_gec_p1 FROM g_sql
   EXECUTE t256_gec_p1 INTO g_pmm.pmm43
   IF cl_null(g_pmm.pmm43) THEN LET g_pmm.pmm43 = 0 END IF
   LET g_pmm.pmm44 = '1'            #扣抵區分
   LET g_pmm.pmm45 = 'Y'            #可用/不可用
   LET g_pmm.pmm46 = 0              #預付比率
   LET g_pmm.pmm47 = 0              #預付金額
   LET g_pmm.pmm48 = 0              #已結帳金額
   LET g_pmm.pmm49 = 'N'            #預付發票否
   LET g_pmm.pmm50 = ''             #代買流程最終供應商代號
   LET g_pmm.pmm99 = ''             #多角貿易流程序號
   LET g_pmm.pmm901 = 'Y'            #多角貿易否
   LET g_pmm.pmm902 = 'N'            #最終採購單否
   LET g_pmm.pmm903 = '3'            #營業額申報方式
   LET g_pmm.pmm904 = g_ruo.ruo904   #多角貿易流程代碼
   LET g_pmm.pmm905 = 'N'            #多角貿易拋轉否
   LET g_pmm.pmm906 = 'Y'            #多角貿易來源採購單否
   LET g_pmm.pmm907 = NULL           #No Use
   LET g_pmm.pmm908 = NULL           #No Use
   LET g_pmm.pmm909 = '4'            #資料來源
   LET g_pmm.pmm911 = l_poy.poy31    #下游廠商對應客戶編號
   LET g_pmm.pmm912 = l_poy.poy32    #下游廠商對應客戶編號
   LET g_pmm.pmm913 = l_poy.poy33    #下游廠商對應客戶編號
   LET g_pmm.pmm914 = l_poy.poy34    #下游廠商對應客戶編號
   LET g_pmm.pmm915 = l_poy.poy35    #下游廠商對應客戶編號
   LET g_pmm.pmm916 = l_poy.poy36    #下游廠商對應客戶編號
   LET g_pmm.pmmprsw = 'N'           #列印控制
   LET g_pmm.pmmprno = 0             #已列印次數
   LET g_pmm.pmmprdt = NULL          #最後列印日期
   LET g_pmm.pmmmksg = 'N'           #是否簽核
   LET g_pmm.pmmsign = NULL          #簽核等級
   LET g_pmm.pmmdays = 0             #簽核完成天數
   LET g_pmm.pmmprit = NULL          #簽核優先等級
   LET g_pmm.pmmsseq = NULL          #已簽核順序
   LET g_pmm.pmmsmax = NULL          #應簽核順序
   LET g_pmm.pmmacti = 'Y'           #資料有效碼
   LET g_pmm.pmmuser = g_user        #資料所有者
   LET g_pmm.pmmgrup = g_grup        #資料所有部門
   LET g_pmm.pmmmodu = NULL          #資料修改者
   LET g_pmm.pmmdate = g_today       #最近修改日
   LET g_pmm.pmm40t  = 0             #含稅總金額
   LET g_pmm.pmmud01 = NULL          #使用者定義
   LET g_pmm.pmmud02 = NULL          #使用者定義
   LET g_pmm.pmmud03 = NULL          #使用者定義
   LET g_pmm.pmmud04 = NULL          #使用者定義
   LET g_pmm.pmmud05 = NULL          #使用者定義
   LET g_pmm.pmmud06 = NULL          #使用者定義
   LET g_pmm.pmmud07 = NULL          #使用者定義
   LET g_pmm.pmmud08 = NULL          #使用者定義
   LET g_pmm.pmmud09 = NULL          #使用者定義
   LET g_pmm.pmmud10 = NULL          #使用者定義
   LET g_pmm.pmmud11 = NULL          #使用者定義
   LET g_pmm.pmmud12 = NULL          #使用者定義
   LET g_pmm.pmmud13 = NULL          #使用者定義
   LET g_pmm.pmmud14 = NULL          #使用者定義
   LET g_pmm.pmmud15 = NULL          #使用者定義
   LET g_pmm.pmmplant= g_ruo.ruo05   #所屬工廠   #要算需求的工厂 
   CALL s_getlegal(g_pmm.pmmplant) RETURNING g_pmm.pmmlegal   #所屬法人 
   LET g_pmm.pmm51   = '1'           #經營方式 1-經銷,2-成本代銷,3- 
   LET g_pmm.pmm52   = g_pmm.pmmplant#採購機構
   LET g_pmm.pmm53   = NULL          #配送中心
   LET g_pmm.pmmcond = g_today       #審核日期
   LET g_pmm.pmmcont = g_time        #審核時間
   LET g_pmm.pmmconu = g_user        #審核人員
   LET g_pmm.pmmcrat = g_today       #資料創建日
   LET g_pmm.pmmpos  = 'N'           #已傳POS否
   LET g_pmm.pmmoriu = g_user        #資料建立者
   LET g_pmm.pmmorig = g_grup        #資料建立部門

   CALL s_auto_assign_no("apm",g_pmm.pmm01,g_today,"","pmm_file","pmm01",g_ruo.ruo05,"","")
      RETURNING li_result,g_pmm.pmm01
   IF (NOT li_result) THEN
      LET g_success="N"
      CALL s_errmsg('','','','asf-377',1)
      RETURN
   END IF
   
   CALL t256_pmn_ins(g_ruo.ruo05)  
   IF g_success = "N" THEN RETURN END IF
   
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_ruo.ruo05,'pmm_file'),"(", 
               "pmm01, pmm02, pmm03, pmm04, pmm05,",
               "pmm06, pmm07, pmm08, pmm09, pmm10,",
               "pmm11, pmm12, pmm13, pmm14, pmm15,",
               "pmm16, pmm17, pmm18, pmm20, pmm21,",
               "pmm22, pmm25, pmm26, pmm27, pmm28,",
               "pmm29, pmm30, pmm31, pmm32, pmm40,",
               "pmm401,pmm41, pmm42, pmm43, pmm44,",
               "pmm45, pmm46, pmm47, pmm48, pmm49,",
               "pmm50, pmm99, pmm901,pmm902,pmm903,",
               "pmm904,pmm905,pmm906,pmm907,pmm908,",
               "pmm909,pmm911,pmm912,pmm913,pmm914,",
               "pmm915,  pmm916,  pmmprsw, pmmprno, pmmprdt,",
               "pmmmksg, pmmsign, pmmdays, pmmprit, pmmsseq,",
               "pmmsmax, pmmacti, pmmuser, pmmgrup, pmmmodu,",
               "pmmdate, pmm40t,  pmmud01, pmmud02, pmmud03,",
               "pmmud04, pmmud05, pmmud06, pmmud07, pmmud08,",
               "pmmud09, pmmud10, pmmud11, pmmud12, pmmud13,",
               "pmmud14, pmmud15, pmmplant,pmmlegal,pmm51, ",
               "pmm52,   pmm53,   pmmcond, pmmcont, pmmconu,",
               "pmmcrat, pmmpos,  pmmoriu, pmmorig)",
               "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?)  "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql 
   PREPARE pmm_ins FROM g_sql
   EXECUTE pmm_ins USING
      g_pmm.pmm01, g_pmm.pmm02, g_pmm.pmm03, g_pmm.pmm04, g_pmm.pmm05,
      g_pmm.pmm06, g_pmm.pmm07, g_pmm.pmm08, g_pmm.pmm09, g_pmm.pmm10,
      g_pmm.pmm11, g_pmm.pmm12, g_pmm.pmm13, g_pmm.pmm14, g_pmm.pmm15,
      g_pmm.pmm16, g_pmm.pmm17, g_pmm.pmm18, g_pmm.pmm20, g_pmm.pmm21,
      g_pmm.pmm22, g_pmm.pmm25, g_pmm.pmm26, g_pmm.pmm27, g_pmm.pmm28,
      g_pmm.pmm29, g_pmm.pmm30, g_pmm.pmm31, g_pmm.pmm32, g_pmm.pmm40,
      g_pmm.pmm401,g_pmm.pmm41, g_pmm.pmm42, g_pmm.pmm43, g_pmm.pmm44,
      g_pmm.pmm45, g_pmm.pmm46, g_pmm.pmm47, g_pmm.pmm48, g_pmm.pmm49,
      g_pmm.pmm50, g_pmm.pmm99, g_pmm.pmm901,g_pmm.pmm902,g_pmm.pmm903,
      g_pmm.pmm904,g_pmm.pmm905,g_pmm.pmm906,g_pmm.pmm907,g_pmm.pmm908,
      g_pmm.pmm909,g_pmm.pmm911,g_pmm.pmm912,g_pmm.pmm913,g_pmm.pmm914,
      g_pmm.pmm915,  g_pmm.pmm916, g_pmm.pmmprsw, g_pmm.pmmprno, g_pmm.pmmprdt,
      g_pmm.pmmmksg, g_pmm.pmmsign,g_pmm.pmmdays, g_pmm.pmmprit, g_pmm.pmmsseq,
      g_pmm.pmmsmax, g_pmm.pmmacti,g_pmm.pmmuser, g_pmm.pmmgrup, g_pmm.pmmmodu,
      g_pmm.pmmdate, g_pmm.pmm40t, g_pmm.pmmud01, g_pmm.pmmud02, g_pmm.pmmud03,
      g_pmm.pmmud04, g_pmm.pmmud05,g_pmm.pmmud06, g_pmm.pmmud07, g_pmm.pmmud08,
      g_pmm.pmmud09, g_pmm.pmmud10,g_pmm.pmmud11, g_pmm.pmmud12, g_pmm.pmmud13,
      g_pmm.pmmud14, g_pmm.pmmud15,g_pmm.pmmplant,g_pmm.pmmlegal,g_pmm.pmm51,
      g_pmm.pmm52,   g_pmm.pmm53,  g_pmm.pmmcond, g_pmm.pmmcont, g_pmm.pmmconu,
      g_pmm.pmmcrat, g_pmm.pmmpos, g_pmm.pmmoriu, g_pmm.pmmorig
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',g_ruo.ruo01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF

END FUNCTION

FUNCTION t256_art(p_poy,p_pmc01,p_plant)
   DEFINE p_poy         RECORD LIKE poy_file.*
   DEFINE p_pmc01       LIKE pmc_file.pmc01  
   DEFINE p_plant       LIKE azp_file.azp01
   DEFINE l_pmc         RECORD LIKE pmc_file.* #供應商主檔

   IF cl_null(p_poy.poy35) THEN   #采购单别
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO p_poy.poy35 FROM rye_file
      # WHERE rye01 = 'apm'
      #   AND rye02 = '2'
      #IF SQLCA.sqlcode THEN
      #   LET g_showmsg = 'apm','/2'
      #   CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
      #   LET g_success = 'N'
      #   RETURN
      #END IF
      #FUN-C90050 mark end-----
      #FUN-C90050 add begin---
      CALL s_get_defslip('apm','2',p_plant,'N') RETURNING p_poy.poy35  
      IF cl_null(p_poy.poy35) THEN
         LET g_showmsg = 'apm','/2'
         CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #FUN-C90050 add end-----
   END IF
   
   LET g_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'pmc_file'),  #供應商基本資料
               "  WHERE pmc01 = '",p_pmc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql 
   PREPARE t256_pmc_px1 FROM g_sql
   EXECUTE t256_pmc_px1 INTO l_pmc.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',l_pmc.pmc01,'SELECT pmc',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(p_poy.poy06) THEN  #付款方式
      LET p_poy.poy06 = l_pmc.pmc17
   END IF
   IF cl_null(p_poy.poy09) THEN  #PO税别
      LET p_poy.poy09 = l_pmc.pmc47
   END IF
   IF cl_null(p_poy.poy05) THEN  #币别
      LET p_poy.poy05 = l_pmc.pmc22
   END IF
  
   RETURN p_poy.*
END FUNCTION

FUNCTION t256_pmn_ins(p_plant_new) 
   DEFINE p_plant_new     LIKE azp_file.azp01
   DEFINE l_unit          LIKE ima_file.ima25
   DEFINE l_no            LIKE tqm_file.tqm01
   DEFINE l_price         LIKE tqn_file.tqn05
   DEFINE l_success       LIKE type_file.chr1
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_ima908        LIKE ima_file.ima908
   DEFINE l_ima15         LIKE ima_file.ima15
   DEFINE l_ima49         LIKE ima_file.ima49
   DEFINE l_ima491        LIKE ima_file.ima491
   DEFINE l_fac           LIKE pmn_file.pmn09
   DEFINE l_pmni          RECORD LIKE pmni_file.*           #No.FUN-7B0018
   DEFINE l_rup           RECORD LIKE rup_file.*
   DEFINE l_pmn           RECORD LIKE pmn_file.*
   DEFINE l_pmn52         LIKE pmn_file.pmn52
   DEFINE l_pmn54         LIKE pmn_file.pmn54
   DEFINE l_pmn56         LIKE pmn_file.pmn56

   DECLARE t256_b3_b CURSOR FOR
    SELECT * FROM rup_file
     WHERE rup01 = g_ruo.ruo01
       AND rupplant = g_ruo.ruoplant
     ORDER BY rup02
   IF STATUS THEN
      CALL s_errmsg('rup01',g_ruo.ruo01,'t256_b3_b',SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF

   FOREACH t256_b3_b INTO l_rup.*
      IF STATUS THEN
         CALL s_errmsg('rup01',g_ruo.ruo01,'foreach t256_b3_b',STATUS,1)
         LET g_success="N"
         EXIT FOREACH
      END IF
      LET g_sql = " SELECT ima02,ima25,ima908,ima15 ",
                  "   FROM ",cl_get_target_table(p_plant_new,'ima_file'), 
                  "  WHERE ima01 = '",l_rup.rup03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE t256_ima_p1 FROM g_sql
      EXECUTE t256_ima_p1 INTO l_ima02,l_ima25,l_ima908,l_ima15
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ima01',l_rup.rup03,'SELECT ima',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_pmn.* TO NULL
      LET l_pmn.pmn01 = g_pmm.pmm01   #採購單號
      LET l_pmn.pmn011= 'TAP'         #單據性質
      LET l_pmn.pmn02 = l_rup.rup02   #項次
      LET l_pmn.pmn03 = NULL          #詢價單號
      LET l_pmn.pmn04 = l_rup.rup03   #料件編號
      LET l_pmn.pmn041= l_ima02       #品名規格
      LET l_pmn.pmn05 = NULL          #APS單據編號
      
      LET g_sql = " SELECT pmh04,pmh07 FROM ",cl_get_target_table(p_plant_new,'pmh_file'),  
                  "  WHERE pmh01 = '",l_pmn.pmn04,"'",
                  "    AND pmh02 = '",g_pmm.pmm09,"'",
                  "    AND pmh13 = '",g_pmm.pmm22,"'",
                  "    AND pmh21 = ' ' ",
                  "    AND pmh22 = '1' ",
                  "    AND pmh23 = ' ' ",
                  "    AND pmhacti = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE t256_pmh_p1 FROM g_sql
      EXECUTE t256_pmh_p1 INTO l_pmn.pmn06,l_pmn.pmn123 #廠商料件編號 #廠牌

      LET l_pmn.pmn07 = l_rup.rup07   #採購單位
      LET l_pmn.pmn08 = l_ima25       #庫存單位
      CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN LET l_fac = 1 END IF
      LET l_pmn.pmn09 = l_fac         #轉換因子
      LET l_pmn.pmn10 = NULL          #No Use
      LET l_pmn.pmn11 = 'N'           #凍結碼
      LET l_pmn.pmn121= 1             #轉換因子
      LET l_pmn.pmn122= NULL          #專案代號
      LET l_pmn.pmn13 = 0             #超/短交限率
      LET l_pmn.pmn14 = 'N'           #部份交貨
      LET l_pmn.pmn15 = 'N'           #提前交貨
      LET l_pmn.pmn16 = '2'           #狀況碼
      LET l_pmn.pmn18 = NULL          #RunCard單號(委外)
      LET l_pmn.pmn20 = l_rup.rup12   #採購量
      IF cl_null(l_ima908) THEN LET l_ima908 = l_pmn.pmn07 END IF
      LET l_pmn.pmn86 = l_ima908      #計價單位
      CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_pmn.pmn87 = l_pmn.pmn20*l_fac  #計價數量
      LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)   #FUN-BB0084 

      LET l_pmn.pmn23 = g_pmm.pmm10        #送貨地址
      LET l_pmn.pmn24 = NULL               #請購單號
      LET l_pmn.pmn25 = NULL               #請購單號項次
      LET l_pmn.pmn30 = NULL               #標準價格
      IF g_sma.sma116 <> '0' THEN
         LET l_unit = l_pmn.pmn86
      ELSE
         LET l_unit = l_pmn.pmn07
      END IF
      IF g_azw.azw04='2' THEN         #check user
         CALL s_fetch_price3(g_ruo.ruo904,l_pmn.pmnplant,l_pmn.pmn04,l_pmn.pmn86,'0',0)
         RETURNING l_success,l_price
      ELSE
         CALL s_fetch_price2(g_pmm.pmm09,l_pmn.pmn04,l_unit,g_ruo.ruo07,'4',p_plant_new,g_pmm.pmm22)
              RETURNING l_no,l_price,l_success
      END IF
      IF l_success = 'N' THEN
         LET g_showmsg = g_pmm.pmm09,'/',l_pmn.pmn04,'/',l_unit,'/',g_pmm.pmm22,'/',g_ruo.ruo07
         CALL s_errmsg('tqo01,tqn03,tqn04,tqm05,tqn06',g_showmsg,'fetch price','axm-333',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      LET g_sql = " SELECT azi03 FROM ",cl_get_target_table(p_plant_new,'azi_file'),   #幣別檔
                  "  WHERE azi01 ='",g_pmm.pmm22,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE t256_azi_p1 FROM g_sql
      EXECUTE t256_azi_p1 INTO t_azi03

      IF g_sma142_chk = 'Y' AND g_sma143_chk = '2' THEN
         LET l_pmn52 = g_ruo.ruo14
         LET l_pmn54 = ' '
         LET l_pmn56 = ' '
      ELSE
         LET l_pmn52 = l_rup.rup13
         LET l_pmn54 = l_rup.rup14
         LET l_pmn56 = l_rup.rup15
      END IF
      
      IF cl_null(l_price) THEN LET l_price = 0 END IF
      LET l_pmn.pmn31 = l_price                         #單價
      LET l_pmn.pmn31 = cl_digcut(l_pmn.pmn31,t_azi03)
      LET l_pmn.pmn31t= l_pmn.pmn31 * (1+ g_pmm.pmm43/100)  #含稅單價
      LET l_pmn.pmn31t= cl_digcut(l_pmn.pmn31t,t_azi03)
      LET l_pmn.pmn32 = NULL                            #RunCard委外製程序
      LET l_pmn.pmn33 = g_ruo.ruo07                     #原始交貨日期
      LET l_pmn.pmn34 = l_pmn.pmn33 + l_ima49           #原始到廠日期
      LET l_pmn.pmn35 = l_pmn.pmn34 + l_ima491          #原始到庫日期
      LET l_pmn.pmn36 = g_ruo.ruo07                     #最近確認交貨日期
      LET l_pmn.pmn37 = NULL                            #最後一次到廠日期
      LET l_pmn.pmn38 = 'Y'                             #可用/不可用
      LET l_pmn.pmn40 = NULL                            #會計科目
      LET l_pmn.pmn41 = NULL                            #工單號碼
      LET l_pmn.pmn42 = '0'                             #替代碼
      LET l_pmn.pmn43 = NULL                            #本製程序號
      LET l_pmn.pmn431= NULL                            #下製程序號
      LET l_pmn.pmn44 = l_pmn.pmn31 * g_pmm.pmm42       #本幣單價
      LET l_pmn.pmn45 = NULL                            #無交期性採購單項次
      LET l_pmn.pmn46 = NULL                            #製程序號
      LET l_pmn.pmn50 = 0                               #交貨量
      LET l_pmn.pmn51 = 0                               #在驗量
      LET l_pmn.pmn52 = l_pmn52                         #倉庫
      LET l_pmn.pmn53 = 0                               #入庫量
      LET l_pmn.pmn54 = l_pmn54                         #儲位
      LET l_pmn.pmn55 = 0                               #驗退量
      LET l_pmn.pmn56 = l_pmn56                         #批號
      LET l_pmn.pmn57 = 0                               #超短交量
      LET l_pmn.pmn58 = 0                               #倉退量
      LET l_pmn.pmn59 = NULL                            #退貨單號
      LET l_pmn.pmn60 = NULL                            #項次
      LET l_pmn.pmn61 = l_pmn.pmn04                     #被替代料號
      LET l_pmn.pmn62 = 1                               #替代率
      LET l_pmn.pmn63 = 'N'                             #急料否
      LET l_pmn.pmn64 = 'N'                             #保稅否
      LET l_pmn.pmn65 = '1'                             #代買性質
      LET l_pmn.pmn66 = NULL                            #預算編號
      LET l_pmn.pmn67 = g_ruo.ruogrup                   #部門編號
      LET l_pmn.pmn68 = NULL                            #Blanket PO 單號
      LET l_pmn.pmn69 = NULL                            #Blanket PO 項次
      LET l_pmn.pmn70 = NULL                            #轉換因子
      LET l_pmn.pmn71 = NULL                            #海關手冊編號

      LET l_pmn.pmn88 = l_pmn.pmn31 * l_pmn.pmn87       #未稅金額
      LET l_pmn.pmn88t= l_pmn.pmn31t* l_pmn.pmn87       #含稅金額
      LET l_pmn.pmn930= g_plant                         #採購成本中心
      LET l_pmn.pmn401= NULL                            #會計科目二
      LET l_pmn.pmn90 = l_pmn.pmn31                     #取出單價
      LET l_pmn.pmn94 = NULL                            #no use
      LET l_pmn.pmn95 = NULL                            #no use
      LET l_pmn.pmn96 = NULL                            #WBS編號
      LET l_pmn.pmn97 = NULL                            #活動代號
      LET l_pmn.pmn98 = NULL                            #費用原因
      LET l_pmn.pmn91 = NULL                            #單元編號
      LET l_pmn.pmnud01 = NULL                          #自訂欄位-Textedit
      LET l_pmn.pmnud02 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud03 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud04 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud05 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud06 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud07 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud08 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud09 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud10 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud11 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud12 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud13 = NULL                          #自訂欄位-日期
      LET l_pmn.pmnud14 = NULL                          #自訂欄位-日期
      LET l_pmn.pmnud15 = NULL                          #自訂欄位-日期
      LET l_pmn.pmn89   = 'N'                           #VMI采購 
      LET l_pmn.pmnplant= g_pmm.pmmplant                #所屬工廠
      LET l_pmn.pmnlegal= g_pmm.pmmlegal                #所屬法人
      LET l_pmn.pmn72   = NULL                          #商品條碼
      LET l_pmn.pmn73   = '4'                           #取價類型 1-搭贈,2-促銷協議,3- 
      LET l_pmn.pmn74   = NULL                          #價格來源
      LET l_pmn.pmn75   = l_rup.rup01                   #來源單號
      LET l_pmn.pmn76   = l_rup.rup02                   #來源項次
      LET l_pmn.pmn77   = g_plant                       #來源機構

      
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_new,'pmn_file'),"( ", 
                  "pmn01, pmn011,pmn02, pmn03, pmn04,",
                  "pmn041,pmn05, pmn06, pmn07, pmn08,",
                  "pmn09, pmn10, pmn11, pmn121,pmn122,",
                  "pmn123,pmn13, pmn14, pmn15, pmn16,",
                  "pmn18, pmn20, pmn23, pmn24, pmn25,",
                  "pmn30, pmn31, pmn31t,pmn32, pmn33,",
                  "pmn34, pmn35, pmn36, pmn37, pmn38,",
                  "pmn40, pmn41, pmn42, pmn43, pmn431,",
                  "pmn44, pmn45, pmn46, pmn50, pmn51,",
                  "pmn52, pmn53, pmn54, pmn55, pmn56,",
                  "pmn57, pmn58, pmn59, pmn60, pmn61,",
                  "pmn62, pmn63, pmn64, pmn65, pmn66,",
                  "pmn67, pmn68, pmn69, pmn70, pmn71,",
                  "pmn80, pmn81, pmn82, pmn83, pmn84,",
                  "pmn85, pmn86, pmn87, pmn88, pmn88t,",
                  "pmn930,pmn401,pmn90, pmn94, pmn95,",
                  "pmn96, pmn97, pmn98, pmn91, pmnud01,",
                  "pmnud02, pmnud03, pmnud04, pmnud05, pmnud06,",
                  "pmnud07, pmnud08, pmnud09, pmnud10, pmnud11,",
                  "pmnud12, pmnud13, pmnud14, pmnud15, pmn89, ",
                  "pmnplant,pmnlegal,pmn72,   pmn73,   pmn74, ",
                  "pmn75,   pmn76,   pmn77)                   ",
                  "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?    )"

      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE ins_pmn FROM g_sql
      EXECUTE ins_pmn USING
         l_pmn.pmn01, l_pmn.pmn011,l_pmn.pmn02, l_pmn.pmn03, l_pmn.pmn04,
         l_pmn.pmn041,l_pmn.pmn05, l_pmn.pmn06, l_pmn.pmn07, l_pmn.pmn08,
         l_pmn.pmn09, l_pmn.pmn10, l_pmn.pmn11, l_pmn.pmn121,l_pmn.pmn122,
         l_pmn.pmn123,l_pmn.pmn13, l_pmn.pmn14, l_pmn.pmn15, l_pmn.pmn16,
         l_pmn.pmn18, l_pmn.pmn20, l_pmn.pmn23, l_pmn.pmn24, l_pmn.pmn25,
         l_pmn.pmn30, l_pmn.pmn31, l_pmn.pmn31t,l_pmn.pmn32, l_pmn.pmn33,
         l_pmn.pmn34, l_pmn.pmn35, l_pmn.pmn36, l_pmn.pmn37, l_pmn.pmn38,
         l_pmn.pmn40, l_pmn.pmn41, l_pmn.pmn42, l_pmn.pmn43, l_pmn.pmn431,
         l_pmn.pmn44, l_pmn.pmn45, l_pmn.pmn46, l_pmn.pmn50, l_pmn.pmn51,
         l_pmn.pmn52, l_pmn.pmn53, l_pmn.pmn54, l_pmn.pmn55, l_pmn.pmn56,
         l_pmn.pmn57, l_pmn.pmn58, l_pmn.pmn59, l_pmn.pmn60, l_pmn.pmn61,
         l_pmn.pmn62, l_pmn.pmn63, l_pmn.pmn64, l_pmn.pmn65, l_pmn.pmn66,
         l_pmn.pmn67, l_pmn.pmn68, l_pmn.pmn69, l_pmn.pmn70, l_pmn.pmn71,
         l_pmn.pmn80, l_pmn.pmn81, l_pmn.pmn82, l_pmn.pmn83, l_pmn.pmn84,
         l_pmn.pmn85, l_pmn.pmn86, l_pmn.pmn87, l_pmn.pmn88, l_pmn.pmn88t,
         l_pmn.pmn930,l_pmn.pmn401,l_pmn.pmn90, l_pmn.pmn94, l_pmn.pmn95,
         l_pmn.pmn96, l_pmn.pmn97, l_pmn.pmn98, l_pmn.pmn91, l_pmn.pmnud01,
         l_pmn.pmnud02, l_pmn.pmnud03, l_pmn.pmnud04, l_pmn.pmnud05, l_pmn.pmnud06,
         l_pmn.pmnud07, l_pmn.pmnud08, l_pmn.pmnud09, l_pmn.pmnud10, l_pmn.pmnud11,
         l_pmn.pmnud12, l_pmn.pmnud13, l_pmn.pmnud14, l_pmn.pmnud15, l_pmn.pmn89,
         l_pmn.pmnplant,l_pmn.pmnlegal,l_pmn.pmn72,   l_pmn.pmn73,   l_pmn.pmn74,
         l_pmn.pmn75,   l_pmn.pmn76,   l_pmn.pmn77
       
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','',g_ruo.ruo01,SQLCA.sqlcode,1)
         LET g_success="N"
         CONTINUE FOREACH
      END IF
     
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmni.* TO NULL
         LET l_pmni.pmni01 = l_pmn.pmn01
         LET l_pmni.pmni02 = l_pmn.pmn02
         IF NOT s_ins_pmni(l_pmni.*,p_plant_new) THEN
            LET g_success='N'                                                                     
            CONTINUE FOREACH                                                                     
         END IF
      END IF
      
      LET g_pmm.pmm40  = g_pmm.pmm40  + l_pmn.pmn88
      LET g_pmm.pmm40t = g_pmm.pmm40t + l_pmn.pmn88t
   END FOREACH
END FUNCTION

#生成出貨單
FUNCTION t256_oga_ins(p_pmm01)
   DEFINE p_pmm01           LIKE pmm_file.pmm01
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE p_plant_new       LIKE azp_file.azp01 
   DEFINE p_plant_new_a     LIKE azp_file.azp01 
   DEFINE li_result         LIKE type_file.num5
   DEFINE l_rvbs            RECORD LIKE rvbs_file.*
   DEFINE l_o_prog          LIKE zz_file.zz01
   DEFINE l_pmm99           LIKE pmm_file.pmm99        #多角貿易流程序號
   DEFINE l_poy             RECORD LIKE poy_file.*

    #1.找需求工廠--采購單
    
    LET g_sql =" SELECT pmm99 FROM ",cl_get_target_table(g_ruo.ruo05,'pmm_file'),
               "  WHERE pmm01 = '",p_pmm01,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
    CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql 
    PREPARE pmm99_pre FROM g_sql
    EXECUTE pmm99_pre INTO l_pmm99
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('pmm01',p_pmm01,'SELECT pmm99','mfg3188',1)
       LET g_success="N"
       RETURN
    END IF

    CALL s_mtrade_last_plant(g_ruo.ruo904)     #最后一站的站別 & 營運中心
         RETURNING l_last_poy02,l_last_poy04
    
    SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
     WHERE poy01 = poz01
       AND poy01 = g_ruo.ruo904
       AND poy02 = (SELECT MAX(poy02) FROM poy_file
     WHERE poy01 = g_ruo.ruo904)
    
    #配销时,若apmi000没有设置,则可以找ART默认设置
    IF g_azw.azw04 = '2' THEN
       IF cl_null(l_poy.poy36) THEN       
          #FUN-C90050 mark begin---   
          #SELECT rye03 INTO l_poy.poy36 FROM rye_file
          # WHERE rye01 = 'axm'
          #   AND rye02 = '50'
          #IF SQLCA.sqlcode THEN
          #   LET g_showmsg = 'axm','/50'
          #   CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
          #   LET g_success = 'N'
          #   RETURN
          #END IF
          #FUN-C90050 mark end------
 
          #FUN-C90050 add begin---
          CALL s_get_defslip('axm','50',g_oea.oeaplant,'N') RETURNING l_poy.poy36  
          IF cl_null(l_poy.poy36) THEN
             LET g_showmsg = 'axm','/50'
             CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF
          #FUN-C90050 add end----- 
       END IF
       IF cl_null(l_poy.poy11) THEN #出货仓库
          #FUN-C90049 mark begin---
          #SELECT rtz07 INTO l_poy.poy11 FROM rtz_file
          # WHERE rtz01 = l_last_poy04
          #FUN-C90049 mark end-----
          CALL s_get_coststore(l_last_poy04,'') RETURNING l_poy.poy11    #FUN-C90049 add
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('rtz01',l_last_poy04,'SELECT rtz07',SQLCA.sqlcode,1)
          END IF
       END IF
    END IF
    #carrier 流通配销出货仓库若没维护,要到哪里找?
    #No.TQC-A20063  --End  
    #2.找代采買拋轉時產生的訂單
    LET g_sql= " SELECT * ",
               "   FROM ",cl_get_target_table(l_last_poy04,'oea_file'),  
               "  WHERE oea99 = '",l_pmm99,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql 
    PREPARE oea_pre FROM g_sql
    EXECUTE oea_pre INTO g_oea.*
    IF SQLCA.sqlcode THEN
       LET g_showmsg = l_last_poy04,'/',l_pmm99
       CALL s_errmsg('azp03,oea99',g_showmsg,'SELECT oea','asf-959',1)
       LET g_success="N"
       RETURN
    END IF

    #3.出貨工廠--產生出貨單頭
    LET g_oga.oga00   = g_oea.oea00      #出貨別
    LET g_oga.oga01   = l_poy.poy36      #出貨單號
    LET g_oga.oga011  = NULL             #出貨通知單號
    LET g_oga.oga02   = g_ruo.ruo07      #出貨日期
    LET g_oga.oga021  = g_ruo.ruo07      #結關日期
    LET g_oga.oga022  = NULL             #裝船日期
    LET g_oga.oga03   = g_oea.oea03      #帳款客戶編號
    LET g_oga.oga032  = g_oea.oea032     #帳款客戶簡稱
    LET g_oga.oga033  = g_oea.oea033     #帳款客戶稅號
    LET g_oga.oga04   = g_oea.oea04      #送貨客戶編號
    LET g_oga.oga044  = g_oea.oea044     #送貨地址碼
    LET g_oga.oga05   = g_oea.oea05      #發票別
    LET g_oga.oga06   = g_oea.oea06      #更改版本
    LET g_oga.oga07   = g_oea.oea07      #出貨是否計入未開發票的銷貨待驗收入
    LET g_oga.oga08   = g_oea.oea08      #1.內銷 2.外銷  3.視同外銷
    LET g_oga.oga09   = '6'              #單據別
    LET g_oga.oga10   = NULL             #帳單編號
    LET g_oga.oga11   = NULL             #應收款日
    LET g_oga.oga12   = NULL             #容許票據到期日
    LET g_oga.oga13   = NULL             #科目分類碼
    LET g_oga.oga14   = g_oea.oea14      #人員編號
    LET g_oga.oga15   = g_oea.oea15      #部門編號
    LET g_oga.oga16   = g_oea.oea01      #訂單單號
    LET g_oga.oga161  = 0                #訂金應收比率
    LET g_oga.oga162  = 100              #出貨應收比率
    LET g_oga.oga163  = 0                #尾款應收比率
    LET g_oga.oga17   = NULL             #排貨模擬順序
    LET g_oga.oga18   = g_oea.oea1001    #收款客戶編號
    LET g_oga.oga19   = NULL             #待抵帳款-預收單號
    LET g_oga.oga20   = 'Y'              #分錄底稿是否可重新生成
    LET g_oga.oga21   = g_oea.oea21      #稅種
    LET g_oga.oga211  = g_oea.oea211     #稅率
    LET g_oga.oga212  = g_oea.oea212     #聯數
    LET g_oga.oga213  = g_oea.oea213     #含稅否
    LET g_oga.oga23   = g_oea.oea23      #幣種
    LET g_oga.oga24   = g_oea.oea24      #匯率
    LET g_oga.oga25   = g_oea.oea25      #銷售分類一
    LET g_oga.oga26   = g_oea.oea26      #銷售分類二
    LET g_oga.oga27   = NULL             #Invoice No.
    LET g_oga.oga28   = g_oea.oea18      #立帳時採用訂單匯率
    LET g_oga.oga29   = NULL             #信用額度餘額
    LET g_oga.oga30   = 'N'              #包裝單審核碼
    LET g_oga.oga31   = g_oea.oea31      #價格條件編號
    LET g_oga.oga32   = g_oea.oea32      #收款條件編號
    LET g_oga.oga33   = g_oea.oea33      #其它條件
    LET g_oga.oga34   = g_oea.oea34      #佣金率
    LET g_oga.oga35   = NULL             #外銷方式
    LET g_oga.oga36   = NULL             #非經海關証明文件名稱
    LET g_oga.oga37   = NULL             #非經海關証明文件號碼
    LET g_oga.oga38   = NULL             #出口報單類型
    LET g_oga.oga39   = NULL             #出口報單號碼
    LET g_oga.oga40   = NULL             #NOTIFY
    LET g_oga.oga41   = g_oea.oea41      #起運地
    LET g_oga.oga42   = g_oea.oea42      #到達地
    LET g_oga.oga43   = g_oea.oea43      #交運方式
    LET g_oga.oga44   = g_oea.oea44      #嘜頭編號
    LET g_oga.oga45   = g_oea.oea45      #聯絡人
    LET g_oga.oga46   = g_oea.oea46      #項目編號
    LET g_oga.oga47   = NULL             #船名/車號
    LET g_oga.oga48   = NULL             #航次
    LET g_oga.oga49   = g_oea.oea35      #卸貨港
    LET g_oga.oga50   = 0                #原幣出貨金額
    LET g_oga.oga501  = 0                #本幣出貨金額
    LET g_oga.oga51   = 0                #原幣出貨金額
    LET g_oga.oga511  =0                 #本幣出貨金額
    LET g_oga.oga52   = 0                #原幣預收訂金轉銷貨收入金額
    LET g_oga.oga53   = 0                #原幣應開發票稅前金額
    LET g_oga.oga54   = 0                #原幣已開發票稅前金額
    LET g_oga.oga99   = g_oea.oea99      #多角貿易流程序號
    LET g_oga.oga901  = 'N'              #post to abx system flag
    LET g_oga.oga902  = NULL             #信用超限留置代碼
    LET g_oga.oga903  = 'Y'              #信用檢查放行否
    LET g_oga.oga904  = NULL             #No Use
    LET g_oga.oga905  = 'N'              #已轉三角貿易出貨單否
    LET g_oga.oga906  = 'Y'              #起始出貨單否
    LET g_oga.oga907  = NULL             #憑証號碼
    LET g_oga.oga908  = NULL             #L/C NO
    LET g_oga.oga909  = 'Y'              #三角貿易否
    LET g_oga.oga910  = NULL             #境外倉庫
    LET g_oga.oga911  = NULL             #境外庫位
    LET g_oga.ogaconf = 'Y'              #審核否/作廢碼
    LET g_oga.ogapost = 'N'              #出貨扣帳否
    LET g_oga.ogaprsw = 0                #打印次數
    LET g_oga.ogauser = g_user           #資料所有者
    LET g_oga.ogagrup = g_plant          #資料所有部門
    LET g_oga.ogamodu = NULL             #資料更改者
    LET g_oga.ogadate = g_today          #最近更改日
    LET g_oga.oga55   = '1'              #狀況碼
    LET g_oga.oga57   = '1'              #FUN-AC0055 add
    LET g_oga.ogamksg = g_oea.oeamksg    #簽核
    LET g_oga.oga65   = g_oea.oea65      #客戶出貨簽收否
    LET g_oga.oga66   = NULL             #出貨簽收在途/驗退倉庫
    LET g_oga.oga67   = NULL             #出貨簽收在途/驗退庫位
    LET g_oga.oga1001 = g_oea.oea1001    #收款客戶編號
    LET g_oga.oga1002 = g_oea.oea1002    #債權代碼
    LET g_oga.oga1003 = g_oea.oea1003    #業績歸屬方
    LET g_oga.oga1004 = g_oea.oea1004    #調貨客戶
    LET g_oga.oga1005 = g_oea.oea1005    #是否計算業績
    LET g_oga.oga1006 = g_oea.oea1006    #折扣金額(稅前)
    LET g_oga.oga1007 = g_oea.oea1007    #折扣金額(含稅)
    LET g_oga.oga1008 = 0                #出貨總含稅金額
    LET g_oga.oga1009 = g_oea.oea1009    #客戶所屬渠道
    LET g_oga.oga1010 = g_oea.oea1010    #客戶所屬方
    LET g_oga.oga1011 = g_oea.oea1011    #開票客戶
    LET g_oga.oga1012 = NULL             #銷退單單號
    LET g_oga.oga1013 = 'N'              #已打印提單否
    LET g_oga.oga1014 = 'N'              #調貨銷退單所自動生成否
    LET g_oga.oga1015 = NULL             #導物流狀況碼
    LET g_oga.oga1016 = g_oea.oea1015    #代送商
    LET g_oga.oga68   = NULL             #No Use
    LET g_oga.ogaspc  = NULL             #SPC拋轉碼 0/1/2
    LET g_oga.oga69   = g_today          #錄入日期
    LET g_oga.oga912  = NULL             #保稅異動原因代碼
    LET g_oga.oga913  = NULL             #保稅報單日期
    LET g_oga.oga914  = NULL             #入庫單號
    LET g_oga.oga70   = NULL             #調撥單號
    LET g_oga.ogaud01 = NULL             #自訂欄位-Textedit
    LET g_oga.ogaud02 = NULL             #自訂欄位-文字
    LET g_oga.ogaud03 = NULL             #自訂欄位-文字
    LET g_oga.ogaud04 = NULL             #自訂欄位-文字
    LET g_oga.ogaud05 = NULL             #自訂欄位-文字
    LET g_oga.ogaud06 = NULL             #自訂欄位-文字
    LET g_oga.ogaud07 = NULL             #自訂欄位-數值
    LET g_oga.ogaud08 = NULL             #自訂欄位-數值
    LET g_oga.ogaud09 = NULL             #自訂欄位-數值
    LET g_oga.ogaud10 = NULL             #自訂欄位-整數
    LET g_oga.ogaud11 = NULL             #自訂欄位-整數
    LET g_oga.ogaud12 = NULL             #自訂欄位-整數
    LET g_oga.ogaud13 = NULL             #自訂欄位-日期
    LET g_oga.ogaud14 = NULL             #自訂欄位-日期
    LET g_oga.ogaud15 = NULL             #自訂欄位-日期
    LET g_oga.ogaplant=g_oea.oeaplant    #所屬工廠  #出货端的工厂  #carrier
    LET g_oga.ogalegal=g_oea.oealegal    #所屬法人  #出货端的工厂  #carrier
    LET g_oga.oga83   =g_oea.oea83       #銷貨機構
    LET g_oga.oga84   =g_oea.oea84       #取貨機構
    LET g_oga.oga85   =g_oea.oea85       #結算方式
    LET g_oga.oga86   =g_oea.oea86       #客層代碼
    LET g_oga.oga87   =g_oea.oea87       #會員卡號
    LET g_oga.oga88   =g_oea.oea88       #顧客姓名
    LET g_oga.oga89   =g_oea.oea89       #聯系電話
    LET g_oga.oga90   =g_oea.oea90       #證件類型
    LET g_oga.oga91   =g_oea.oea91       #證件號碼
    LET g_oga.oga92   =g_oea.oea92       #贈品發放單號
    LET g_oga.oga93   =g_oea.oea93       #返券發放單號
    LET g_oga.oga94   ='N'               #POS銷售否 Y-是,N-否
    LET g_oga.oga95   =0                 #本次積分  #carrier
    LET g_oga.oga96   =NULL              #收銀機號
    LET g_oga.oga97   =NULL              #交易序號
    LET g_oga.ogacond =g_today           #審核日期
    LET g_oga.ogaconu =g_user            #審核人員
    LET g_oga.ogaoriu =g_user            #資料建立者
    LET g_oga.ogaorig =g_grup            #資料建立部門
    LET g_oga.oga71   = NULL             #申報統編

    CALL s_auto_assign_no("axm",g_oga.oga01,g_oga.oga02,"","oga_file","oga01",l_last_poy04,"","")
         RETURNING li_result,g_oga.oga01
    IF (NOT li_result) THEN
       LET g_success="N"
       CALL s_errmsg('oga01',g_oga.oga01,'oga_file','asf-377',1)  #No.FUN-710033
       RETURN
    END IF

    #4.出貨工廠--產生出貨單身    
    CALL t256_ogb_ins(l_last_poy04)   
    IF g_success = 'N' THEN
       RETURN
    END IF

    LET g_oga.oga501 = g_oga.oga50*g_oga.oga24
    LET g_oga.oga511 = g_oga.oga51*g_oga.oga24
    
    LET g_sql = " INSERT INTO ",cl_get_target_table(l_last_poy04,'oga_file'),"(",  
                "oga00, oga01, oga011,oga02, oga021,",
                "oga022,oga03, oga032,oga033,oga04,",
                "oga044,oga05, oga06, oga07, oga08,",
                "oga09, oga10, oga11, oga12, oga13,",
                "oga14, oga15, oga16, oga161,oga162,",
                "oga163,oga17, oga18, oga19, oga20,",
                "oga21, oga211,oga212,oga213,oga23,",
                "oga24, oga25, oga26, oga27, oga28,",
                "oga29, oga30, oga31, oga32, oga33,",
                "oga34, oga35, oga36, oga37, oga38,",
                "oga39, oga40, oga41, oga42, oga43,",
                "oga44, oga45, oga46, oga47, oga48,",
                "oga49, oga50, oga501,oga51, oga511,",
                "oga52, oga53, oga54, oga99, oga901,",
                "oga902,oga903,oga904,oga905,oga906,",
                "oga907,oga908,oga909,oga910,oga911,",
                "ogaconf, ogapost, ogaprsw, ogauser, ogagrup,",
                "ogamodu, ogadate, oga55,   ogamksg, oga65,",
                "oga66,   oga67,   oga1001, oga1002, oga1003,",
                "oga1004, oga1005, oga1006, oga1007, oga1008,",
                "oga1009, oga1010, oga1011, oga1012, oga1013,",
                "oga1014, oga1015, oga1016, oga68,   ogaspc,",
                "oga69,   oga912,  oga913,  oga914,  oga70,",
                "ogaud01, ogaud02, ogaud03, ogaud04, ogaud05,",
                "ogaud06, ogaud07, ogaud08, ogaud09, ogaud10,",
                "ogaud11, ogaud12, ogaud13, ogaud14, ogaud15,",
                "ogaplant,ogalegal,oga83,   oga84,   oga85,",
                "oga86,   oga87,   oga88,   oga89,   oga90,",
                "oga91,   oga92,   oga93,   oga94,   oga95,",
                "oga96,   oga97,   ogacond, ogaconu, ogaoriu,",
                "ogaorig, oga71,oga57)", #FUN-AC0055 add oga57
                "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?)      "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql 
    PREPARE oga_ins FROM g_sql
    EXECUTE oga_ins USING
       g_oga.oga00,   g_oga.oga01,   g_oga.oga011, g_oga.oga02,  g_oga.oga021,
       g_oga.oga022,  g_oga.oga03,   g_oga.oga032, g_oga.oga033, g_oga.oga04,
       g_oga.oga044,  g_oga.oga05,   g_oga.oga06,  g_oga.oga07,  g_oga.oga08,
       g_oga.oga09,   g_oga.oga10,   g_oga.oga11,  g_oga.oga12,  g_oga.oga13,
       g_oga.oga14,   g_oga.oga15,   g_oga.oga16,  g_oga.oga161, g_oga.oga162,
       g_oga.oga163,  g_oga.oga17,   g_oga.oga18,  g_oga.oga19,  g_oga.oga20,
       g_oga.oga21,   g_oga.oga211,  g_oga.oga212, g_oga.oga213, g_oga.oga23,
       g_oga.oga24,   g_oga.oga25,   g_oga.oga26,  g_oga.oga27,  g_oga.oga28,
       g_oga.oga29,   g_oga.oga30,   g_oga.oga31,  g_oga.oga32,  g_oga.oga33,
       g_oga.oga34,   g_oga.oga35,   g_oga.oga36,  g_oga.oga37,  g_oga.oga38,
       g_oga.oga39,   g_oga.oga40,   g_oga.oga41,  g_oga.oga42,  g_oga.oga43,
       g_oga.oga44,   g_oga.oga45,   g_oga.oga46,  g_oga.oga47,  g_oga.oga48,
       g_oga.oga49,   g_oga.oga50,   g_oga.oga501, g_oga.oga51,  g_oga.oga511,
       g_oga.oga52,   g_oga.oga53,   g_oga.oga54,  g_oga.oga99,  g_oga.oga901,
       g_oga.oga902,  g_oga.oga903,  g_oga.oga904, g_oga.oga905, g_oga.oga906,
       g_oga.oga907,  g_oga.oga908,  g_oga.oga909, g_oga.oga910, g_oga.oga911,
       g_oga.ogaconf, g_oga.ogapost, g_oga.ogaprsw,g_oga.ogauser,g_oga.ogagrup,
       g_oga.ogamodu, g_oga.ogadate, g_oga.oga55,  g_oga.ogamksg,g_oga.oga65,
       g_oga.oga66,   g_oga.oga67,   g_oga.oga1001,g_oga.oga1002,g_oga.oga1003,
       g_oga.oga1004, g_oga.oga1005, g_oga.oga1006,g_oga.oga1007,g_oga.oga1008,
       g_oga.oga1009, g_oga.oga1010, g_oga.oga1011,g_oga.oga1012,g_oga.oga1013,
       g_oga.oga1014, g_oga.oga1015, g_oga.oga1016,g_oga.oga68,  g_oga.ogaspc,
       g_oga.oga69,   g_oga.oga912,  g_oga.oga913, g_oga.oga914, g_oga.oga70,
       g_oga.ogaud01, g_oga.ogaud02, g_oga.ogaud03,g_oga.ogaud04,g_oga.ogaud05,
       g_oga.ogaud06, g_oga.ogaud07, g_oga.ogaud08,g_oga.ogaud09,g_oga.ogaud10,
       g_oga.ogaud11, g_oga.ogaud12, g_oga.ogaud13,g_oga.ogaud14,g_oga.ogaud15,
       g_oga.ogaplant,g_oga.ogalegal,g_oga.oga83,  g_oga.oga84,  g_oga.oga85,
       g_oga.oga86,   g_oga.oga87,   g_oga.oga88,  g_oga.oga89,  g_oga.oga90,
       g_oga.oga91,   g_oga.oga92,   g_oga.oga93,  g_oga.oga94,  g_oga.oga95,
       g_oga.oga96,   g_oga.oga97,   g_oga.ogacond,g_oga.ogaconu,g_oga.ogaoriu,
       g_oga.ogaorig, g_oga.oga71,   g_oga.oga57   #FUN-AC0055 add g_oga.oga57
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','',g_ruo.ruo01,SQLCA.sqlcode,1)  #No.FUN-710033
       LET g_success="N"
       RETURN
    END IF

    #5.產生--出貨單的rvbs_file/imgs_file/tlfs_file
    
    LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'), 
                "  WHERE rvbs00 = '",g_prog,"'",
                "    AND rvbs01 = '",g_ruo.ruo01,"'",
                "    AND rvbs13 = 0 ",
                "    AND rvbs09 = - 1 "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql 
    PREPARE rvbs_p1 FROM g_sql
    EXECUTE rvbs_p1 INTO g_cnt
    IF g_cnt > 0 THEN
       
       LET g_sql = " SELECT * FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'),
                   "  WHERE rvbs00 = '",g_prog,"'",
                   "    AND rvbs01 = '",g_ruo.ruo01,"'",
                   "    AND rvbs13 = 0 ",
                   "    AND rvbs09 = - 1 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
       CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql 
       DECLARE rvbs_cs1 CURSOR FROM g_sql

       LET g_sql = " INSERT INTO ",cl_get_target_table(l_last_poy04,'rvbs_file'),"(", 
                   "                       rvbs00,rvbs01,rvbs02,rvbs021,",
                   "                       rvbs022,rvbs03,rvbs04,rvbs05,",
                   "                       rvbs06,rvbs07,rvbs08,rvbs09, ",
                   "                       rvbs10,rvbs11,rvbs12,rvbs13,  ",
                   "                       rvbsplant,rvbslegal)          ",
                   "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
       CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql 

       PREPARE ins_p1 FROM g_sql

       FOREACH rvbs_cs1 INTO l_rvbs.*
          LET l_rvbs.rvbs00 = 'axmt820'
          LET l_rvbs.rvbs01 = g_oga.oga01

          EXECUTE ins_p1 USING l_rvbs.rvbs00, l_rvbs.rvbs01, l_rvbs.rvbs02,
                               l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                               l_rvbs.rvbs04, l_rvbs.rvbs05, l_rvbs.rvbs06,
                               l_rvbs.rvbs07, l_rvbs.rvbs08, l_rvbs.rvbs09,
                               l_rvbs.rvbs10, l_rvbs.rvbs11, l_rvbs.rvbs12,
                               l_rvbs.rvbs13, l_rvbs.rvbsplant,l_rvbs.rvbslegal
          IF SQLCA.sqlcode THEN
             LET g_showmsg = l_rvbs.rvbs00,'/',l_rvbs.rvbs01,'/',l_rvbs.rvbs02
             CALL s_errmsg('rvbs00,rvbs01,rvbs02',g_showmsg,'ins rvbs',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          LET l_o_prog = g_prog
          LET g_prog = 'axmt820'
          CALL p900_imgs(l_last_poy04,l_poy.poy11,' ',' ',g_ruo.ruo07,l_rvbs.*)
          LET g_prog = l_o_prog
       END FOREACH
    END IF

END FUNCTION

#產生出貨單身
FUNCTION t256_ogb_ins(p_plant_new)   
   DEFINE p_plant_new LIKE type_file.chr21
   DEFINE l_fac       LIKE pmn_file.pmn09
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_poy11     LIKE poy_file.poy11
   DEFINE l_ogbi      RECORD LIKE ogbi_file.*      
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_oeb       RECORD LIKE oeb_file.*
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_sql       STRING
   DEFINE l_ogb09     LIKE ogb_file.ogb09
   DEFINE l_ogb091    LIKE ogb_file.ogb091
   DEFINE l_ogb092    LIKE ogb_file.ogb092

   SELECT poy11 INTO l_poy11   #倉庫別
     FROM poy_file,poz_file
    WHERE poz01 = g_ruo.ruo904
      AND poz01 = poy01
      AND poy02 IN (SELECT MAX(poy02) FROM poy_file
    WHERE poy01 = g_ruo.ruo904)

   LET g_sql = " SELECT * FROM ",cl_get_target_table(p_plant_new,'oeb_file'),  
               "  WHERE oeb01 = '",g_oea.oea01,"' ",
               "  ORDER BY oeb03 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
   CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
   PREPARE oeb_pre FROM g_sql
   DECLARE oeb_cs CURSOR FOR oeb_pre
   FOREACH oeb_cs INTO l_oeb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oea01',l_oeb.oeb01,'oeb_cs',SQLCA.sqlcode,1)  
         LET g_success="N"
         RETURN
      END IF
      IF g_sma142_chk = "Y"  AND g_sma143_chk = "1" THEN
         LET l_ogb09 = g_ruo.ruo14
         LET l_ogb091 = ' '
         LET l_ogb092 = ' '         
      ELSE
         LET l_sql = "SELECT rup09,rup10,rup11 FROM ",cl_get_target_table(p_plant_new,'rup_file'),  
                     " WHERE rup01 = '",g_ruo.ruo01,"'",
                     "   AND rupplant = '",g_ruo.ruoplant,"'",
                     "   AND rup03 = '",l_oeb.oeb04,"'"
         PREPARE ruo_pre1 FROM l_sql
         EXECUTE ruo_pre1 INTO l_ogb09,l_ogb091,l_ogb092
      END IF
      LET l_ogb.ogb01   = g_oga.oga01          #出貨單號
      LET l_ogb.ogb03   = l_oeb.oeb03          #項次
      LET l_ogb.ogb04   = l_oeb.oeb04          #產品編號
      LET l_ogb.ogb05   = l_oeb.oeb05          #銷售單位
      LET l_ogb.ogb05_fac = l_oeb.oeb05_fac    #銷售/庫存彙總單位換算率
      LET l_ogb.ogb06   = l_oeb.oeb06          #品名規格
      LET l_ogb.ogb07   = l_oeb.oeb07          #額外品名編號
      LET l_ogb.ogb08   = l_oeb.oeb08          #出貨營運中心編號
      LET l_ogb.ogb09   = l_ogb09              #出貨倉庫編號
      LET l_ogb.ogb091  = l_ogb091             #出貨儲位編號
      LET l_ogb.ogb092  = l_ogb092             #出貨批號
      LET l_ogb.ogb11   = l_oeb.oeb11          #客戶產品編號
      LET l_ogb.ogb12   = l_oeb.oeb12          #實際出貨數量
      #兩站式就直接取訂單的價格-也就是采購單的訂價;
      #若是多站式,則要做出貨工廠的取價
      #目前程序暫定是兩站式,故不做取價了
      LET l_ogb.ogb13   = l_oeb.oeb13          #原幣單價
      LET l_ogb.ogb14   = l_oeb.oeb14          #原幣未稅金額
      LET l_ogb.ogb14t  = l_oeb.oeb14t         #原幣含稅金額
      IF cl_null(l_ogb.ogb13)  THEN LET l_ogb.ogb13 = 0 END IF
      IF cl_null(l_ogb.ogb14)  THEN LET l_ogb.ogb14 = 0 END IF
      IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t= 0 END IF

      LET g_sql = " SELECT img09 FROM ",cl_get_target_table(p_plant_new,'img_file'),  
                  "  WHERE img01 = '",l_ogb.ogb04,"' ",
                  "    AND img02 = '",l_ogb.ogb09,"' ",
                  "    AND img03 = '",l_ogb.ogb091,"' ",
                  "    AND img04 = '",l_ogb.ogb092,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE img_pre FROM g_sql
      EXECUTE img_pre INTO l_img09
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_ogb.ogb04,'/',l_ogb.ogb09,'/',
                         l_ogb.ogb091,'/',l_ogb.ogb092
         CALL s_errmsg('ogb04,ogb09,ogb091,ogb092',g_showmsg,'img_pre','axm-244',1)
         LET g_success="N"
         RETURN
      END IF
      LET l_ogb.ogb15  = l_img09               #庫存明細單位由廠/倉/儲/批自動得出
      CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_ogb.ogb15_fac = l_fac              #銷售/庫存明細單位換算率
      LET l_ogb.ogb16  = l_ogb.ogb12*l_ogb.ogb15_fac        #數量
      LET l_ogb.ogb16  = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
      LET l_ogb.ogb17   = 'N'                  #多倉儲批出貨否
      LET l_ogb.ogb18   = l_ogb.ogb12          #預計出貨數量
      LET l_ogb.ogb19   = l_oeb.oeb906         #檢驗否
      LET l_ogb.ogb20   = NULL                 #No Use
      LET l_ogb.ogb21   = NULL                 #No Use
      LET l_ogb.ogb22   = NULL                 #No Use
      LET l_ogb.ogb31   = l_oeb.oeb01          #訂單單號
      LET l_ogb.ogb32   = l_oeb.oeb03          #訂單項次
      LET l_ogb.ogb60   = 0                    #已開發票數量
      LET l_ogb.ogb63   = 0                    #銷退數量
      LET l_ogb.ogb64   = 0                    #銷退數量
      LET l_ogb.ogb901  = NULL                 #No Use
      LET l_ogb.ogb902  = NULL                 #No Use
      LET l_ogb.ogb903  = NULL                 #No Use
      LET l_ogb.ogb904  = NULL                 #No Use
      LET l_ogb.ogb905  = NULL                 #No Use
      LET l_ogb.ogb906  = NULL                 #No Use
      LET l_ogb.ogb907  = NULL                 #No Use
      LET l_ogb.ogb908  = l_oeb.oeb908         #手冊編號
      LET l_ogb.ogb909  = NULL                 #No Use
      LET l_ogb.ogb910  = l_oeb.oeb910         #單位一
      LET l_ogb.ogb911  = l_oeb.oeb911         #單位一換算率(與銷售單位)
      LET l_ogb.ogb912  = l_oeb.oeb912         #單位一數量
      LET l_ogb.ogb913  = l_oeb.oeb913         #單位二
      LET l_ogb.ogb914  = l_oeb.oeb914         #單位二換算率(與銷售單位)
      LET l_ogb.ogb915  = l_oeb.oeb915         #單位二數量
      LET l_ogb.ogb916  = l_oeb.oeb916         #計價單位
      LET l_ogb.ogb917  = l_oeb.oeb917         #計價數量*/
      LET l_ogb.ogb65   = NULL                 #驗退理由碼
      LET l_ogb.ogb1001 = l_oeb.oeb1001        #原因碼
      LET l_ogb.ogb1002 = l_oeb.oeb1002        #訂價代號
      LET l_ogb.ogb1005 = l_oeb.oeb1003        #作業方式
      LET l_ogb.ogb1007 = l_oeb.oeb1007        #現金折扣單號
      LET l_ogb.ogb1008 = l_oeb.oeb1008        #稅別
      LET l_ogb.ogb1009 = l_oeb.oeb1009        #稅率
      LET l_ogb.ogb1010 = l_oeb.oeb1010        #含稅否
      LET l_ogb.ogb1011 = l_oeb.oeb1011        #非直營KAB
      LET l_ogb.ogb1003 = g_oga.oga02          #預計出貨日期
      LET l_ogb.ogb1004 = l_oeb.oeb1004        #提案代號
      LET l_ogb.ogb1006 = l_oeb.oeb1006        #折扣率
      LET l_ogb.ogb1012 = l_oeb.oeb1012        #搭贈
      LET l_ogb.ogb930  = l_oeb.oeb930         #成本中心
      LET l_ogb.ogb1013 = 0                    #已開發票未稅金額
      LET l_ogb.ogb1014 = NULL                 #保稅已放行否
      LET l_ogb.ogb41   = l_oeb.oeb41          #專案代號
      LET l_ogb.ogb42   = l_oeb.oeb42          #WBS編號
      LET l_ogb.ogb43   = l_oeb.oeb43          #活動代號
      LET l_ogb.ogb931  = l_oeb.oeb931         #包裝編號
      LET l_ogb.ogb932  = l_oeb.oeb932         #包裝數量
      LET l_ogb.ogbud01 = NULL                 #自訂欄位-Textedit
      LET l_ogb.ogbud02 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud03 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud04 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud05 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud06 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud07 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud08 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud09 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud10 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud11 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud12 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud13 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud14 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud15 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbplant=l_oeb.oebplant        #所屬工廠
      LET l_ogb.ogblegal=l_oeb.oeblegal        #所屬法人
      LET l_ogb.ogb44   =l_oeb.oeb44           #經營方式
      LET l_ogb.ogb45   =l_oeb.oeb45           #原扣率
      LET l_ogb.ogb46   =l_oeb.oeb46           #新扣率
      LET l_ogb.ogb47   =l_oeb.oeb47           #分攤折價=全部折價字段值的和
     #FUN-AC0055 mark ---------------------begin-----------------------
     ##FUN-AB0096 -----------add start-------------
     # IF cl_null(l_ogb.ogb50) THEN
     #    LET l_ogb.ogb50 = '1'                  
     # END IF
     ##FUN-AB0096 -------------add end-------------------
     #FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(l_ogb.ogb50) THEN 
       LET l_ogb.ogb50 = 0
     END IF 
     IF cl_null(l_ogb.ogb51) THEN 
       LET l_ogb.ogb51 = 0
     END IF 
     IF cl_null(l_ogb.ogb52) THEN 
       LET l_ogb.ogb52 = 0
     END IF      
     IF cl_null(l_ogb.ogb53) THEN 
       LET l_ogb.ogb53 = 0
     END IF 
     IF cl_null(l_ogb.ogb54) THEN 
       LET l_ogb.ogb54 = 0
     END IF 
     IF cl_null(l_ogb.ogb55) THEN 
       LET l_ogb.ogb55 = 0
     END IF                                     
     #FUN-C50097 ADD END-------       

      LET g_sql = " INSERT INTO ",cl_get_target_table(p_plant_new,'ogb_file'),"(", 
                  "ogb01,  ogb03,  ogb04,    ogb05,  ogb05_fac,",
                  "ogb06,  ogb07,  ogb08,    ogb09,  ogb091,",
                  "ogb092, ogb11,  ogb12,    ogb13,  ogb14,",
                  "ogb14t, ogb15,  ogb15_fac,ogb16,  ogb17,",
                  "ogb18,  ogb19,  ogb20,    ogb21,  ogb22,",
                  "ogb31,  ogb32,  ogb60,    ogb63,  ogb64,",
                  "ogb901, ogb902, ogb903,   ogb904, ogb905,",
                  "ogb906, ogb907, ogb908,   ogb909, ogb910,",
                  "ogb911, ogb912, ogb913,   ogb914, ogb915,",
                  "ogb916, ogb917, ogb65,    ogb1001,ogb1002,",
                  "ogb1005,ogb1007,ogb1008,  ogb1009,ogb1010,",
                  "ogb1011,ogb1003,ogb1004,  ogb1006,ogb1012,",
                  "ogb930, ogb1013,ogb1014,  ogb41,  ogb42,",
                  "ogb43,  ogb931, ogb932,   ogbud01,ogbud02,",
                  "ogbud03,ogbud04,ogbud05,  ogbud06,ogbud07,",
                  "ogbud08,ogbud09,ogbud10,  ogbud11,ogbud12,",
                  "ogbud13,ogbud14,ogbud15,  ogbplant,ogblegal,",
                  "ogb44,  ogb45,  ogb46,    ogb47,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",          #FUN-C50097 ADD 50,51,52  
                  "   VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,? ,?,?,?,?, ?,?)    "        #FUN-C50097 ADD 50,51,52
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql 
      PREPARE ogb_ins FROM g_sql
      EXECUTE ogb_ins USING
         l_ogb.ogb01,  l_ogb.ogb03,  l_ogb.ogb04,    l_ogb.ogb05,   l_ogb.ogb05_fac,
         l_ogb.ogb06,  l_ogb.ogb07,  l_ogb.ogb08,    l_ogb.ogb09,   l_ogb.ogb091,
         l_ogb.ogb092, l_ogb.ogb11,  l_ogb.ogb12,    l_ogb.ogb13,   l_ogb.ogb14,
         l_ogb.ogb14t, l_ogb.ogb15,  l_ogb.ogb15_fac,l_ogb.ogb16,   l_ogb.ogb17,
         l_ogb.ogb18,  l_ogb.ogb19,  l_ogb.ogb20,    l_ogb.ogb21,   l_ogb.ogb22,
         l_ogb.ogb31,  l_ogb.ogb32,  l_ogb.ogb60,    l_ogb.ogb63,   l_ogb.ogb64,
         l_ogb.ogb901, l_ogb.ogb902, l_ogb.ogb903,   l_ogb.ogb904,  l_ogb.ogb905,
         l_ogb.ogb906, l_ogb.ogb907, l_ogb.ogb908,   l_ogb.ogb909,  l_ogb.ogb910,
         l_ogb.ogb911, l_ogb.ogb912, l_ogb.ogb913,   l_ogb.ogb914,  l_ogb.ogb915,
         l_ogb.ogb916, l_ogb.ogb917, l_ogb.ogb65,    l_ogb.ogb1001, l_ogb.ogb1002,
         l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008,  l_ogb.ogb1009, l_ogb.ogb1010,
         l_ogb.ogb1011,l_ogb.ogb1003,l_ogb.ogb1004,  l_ogb.ogb1006, l_ogb.ogb1012,
         l_ogb.ogb930, l_ogb.ogb1013,l_ogb.ogb1014,  l_ogb.ogb41,   l_ogb.ogb42,
         l_ogb.ogb43,  l_ogb.ogb931, l_ogb.ogb932,   l_ogb.ogbud01, l_ogb.ogbud02,
         l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,  l_ogb.ogbud06, l_ogb.ogbud07,
         l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,  l_ogb.ogbud11, l_ogb.ogbud12,
         l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,  l_ogb.ogbplant,l_ogb.ogblegal,
         l_ogb.ogb44,  l_ogb.ogb45,  l_ogb.ogb46,    l_ogb.ogb47, 
         l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52, l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55 #FUN-C50097 ADD 50,51,52
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruo01',g_ruo.ruo01,'ogb_ins',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_ogbi.* TO NULL    
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      
      END IF

      LET g_oga.oga50 = g_oga.oga50 + l_ogb.ogb14
      LET g_oga.oga51 = g_oga.oga51 + l_ogb.ogb14t
   END FOREACH

END FUNCTION

#倉庫間調撥（異動庫存）
FUNCTION s_transfer_s(l_plant,l_ruo01,l_flag)     
   DEFINE   l_plant_1   LIKE azp_file.azp01 
   DEFINE   l_plant_2   LIKE azp_file.azp01 
   DEFINE   l_plant     LIKE azp_file.azp01 
   DEFINE   l_ruo01     LIKE ruo_file.ruo01 #調撥單單號
   DEFINE   l_flag      LIKE type_file.chr1 #標誌位1為撥出2位撥入
   DEFINE   l_qty_1     LIKE rup_file.rup12 
   DEFINE   l_qty_2     LIKE rup_file.rup12 
   DEFINE   l_rup       RECORD  LIKE rup_file.*   

   IF g_success = 'N' THEN
      RETURN
   END IF 
   DECLARE s_transfer_c CURSOR FOR SELECT * FROM rup_file 
                                    WHERE rup01 = l_ruo01
                                      AND rupplant = l_plant 
   FOREACH  s_transfer_c INTO l_rup.*
      IF STATUS THEN
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF g_sma142_chk = "Y"  THEN                #在途管理為Y
         IF l_flag = '1' THEN                    #撥出方到在途
            LET g_img02_1 = l_rup.rup09          #撥出倉庫編號 							
            LET g_img02_2 = g_ruo.ruo14          #在途仓仓库编号							
            LET g_img03_1 = l_rup.rup10          #拨出储位							
            LET g_img03_2 = ' '							
            LET g_img04_1 = l_rup.rup11          #拨出批							
            LET g_img04_2 = ' '							
            LET l_qty_1 = l_rup.rup12*l_rup.rup08#撥出數量
            LET l_qty_2 = l_qty_1      
            LET l_plant_1 = g_ruo.ruo04          #营运中心
            LET l_plant_2 = g_ruo.ruo04          #营运中心
         ELSE
            LET g_img02_1 = g_ruo.ruo14          #在途仓仓库编号 							
            LET g_img02_2 = l_rup.rup13          #撥入倉庫編號							
            LET g_img03_1 = ' '                 						
            LET g_img03_2 = l_rup.rup14		     #拨入储位					
            LET g_img04_1 = ' '						
            LET g_img04_2 = l_rup.rup15          #拨入批                    
            LET l_qty_2 = l_rup.rup16*l_rup.rup08#撥入數量
            LET l_qty_1 = l_qty_2      
            LET l_plant_1 = g_ruo.ruo05          #营运中心
            LET l_plant_2 = g_ruo.ruo05          #营运中心
         END IF
      ELSE
         LET g_img02_1 = l_rup.rup09             #撥出倉庫編號 							
         LET g_img02_2 = l_rup.rup13             #撥入倉庫編號								
         LET g_img03_1 = l_rup.rup10             #拨出储位							
         LET g_img03_2 = l_rup.rup14		     #拨入储位								
         LET g_img04_1 = l_rup.rup11             #拨出批							
         LET g_img04_2 = l_rup.rup15             #拨入批							
         LET l_qty_1 = l_rup.rup12*l_rup.rup08   #撥出數量	
         LET l_qty_2 = l_rup.rup16*l_rup.rup08	 #撥入數量		     
         LET l_plant_1 = g_ruo.ruo04             #营运中心
         LET l_plant_2 = g_ruo.ruo05             #营运中心
      END IF
       
      #出庫
      CALL s_upimg1(l_rup.rup03,g_img02_1,g_img03_1,g_img04_1,-1,l_qty_1,g_today,l_rup.rup03,
                    l_rup.rup09,' ',' ',l_rup.rup01,l_rup.rup02,
                    l_rup.rup07,'',l_rup.rup04,'','','','','',0,0,'','',l_plant_1)
      CALL s_log(l_rup.*,l_plant_1,'1')  #產生出庫異動記錄 
      #入庫              
      CALL s_upimg1(l_rup.rup03,g_img02_2,g_img03_2,g_img04_2,+1,l_qty_2,g_today,l_rup.rup03,
                    l_rup.rup09,' ',' ',l_rup.rup01,l_rup.rup02,
                    l_rup.rup07,'',l_rup.rup04,'','','','','',0,1,'','',l_plant_2)
    
      CALL s_log(l_rup.*,l_plant_2,'2')  #產生入庫異動記錄 
   END FOREACH   
END FUNCTION

#產生異動記錄 
FUNCTION s_log(l_rup,l_plant,l_flag)
   DEFINE l_img02     LIKE img_file.img02,                                                                        
          l_img03     LIKE img_file.img03,                                                                        
          l_img04     LIKE img_file.img04,
          l_img09     LIKE img_file.img09,     #庫存單位                                                                     
          l_img10     LIKE img_file.img10,     #庫存數量                                                                     
          l_img26     LIKE img_file.img26,
          l_tlf02     LIKE tlf_file.tlf02,
          l_tlf03     LIKE tlf_file.tlf03,
          l_tlf907    LIKE tlf_file.tlf907,
          l_tlf10     LIKE tlf_file.tlf10
   DEFINE l_rup       RECORD  LIKE rup_file.* 
   DEFINE l_flag      LIKE type_file.chr1   
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_sql       STRING 
             
    IF l_flag = '1' THEN           #出庫異動記錄
       LET l_img02 = g_img02_1     #倉
       LET l_img03 = g_img03_1     #儲
       LET l_img04 = g_img04_1     #批
       LET l_tlf02 = 50            #來源狀況：倉庫
       LET l_tlf03 = 66            #目的狀況：多營運中心工單
       LET l_tlf10 = l_rup.rup12   #異動數量
       LET l_tlf907 = -1           #出庫
    ELSE
       LET l_img02 = g_img02_2    #倉
       LET l_img03 = g_img03_2    #儲
       LET l_img04 = g_img04_2    #批
       LET l_tlf02 = 57           #來源狀況：營運中心間調撥
       LET l_tlf03 = 50           #目的狀況：倉庫間調撥
       LET l_tlf10 = l_rup.rup16  #異動數量
       LET l_tlf907 = 1           #入庫
    END IF   
 
    LET l_sql = " SELECT img09,img10,img26 ",
                "   FROM ",cl_get_target_table(l_plant,'img_file'),
                "  WHERE img01 = '",l_rup.rup03,"'",
                "    AND img02 = '",l_img02,"'", 
                "    AND img03 = '",l_img03,"'",    
                "    AND img04 = '",l_img04,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE img_sel FROM l_sql
    EXECUTE img_sel INTO l_img09,l_img10,l_img26
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","img_file",l_rup.rup03,"",SQLCA.sqlcode,"","ckp#log",1)
       LET g_success = 'N'
       RETURN
    END IF
    INITIALIZE g_tlf.* TO NULL
    LET g_tlf.tlf01 = l_rup.rup03      #異動料件編號
    LET g_tlf.tlf020 = g_plant         #機構別
    LET g_tlf.tlf02 = l_tlf02          #來源狀況
    LET g_tlf.tlf021 = g_img02_1       #倉庫(來源）
    LET g_tlf.tlf022 = g_img03_1       #儲位(來源）
    LET g_tlf.tlf023 = g_img04_1       #批號(來源）
    LET g_tlf.tlf024 = l_img10         #異動後庫存數量
    LET g_tlf.tlf025 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf026 = l_rup.rup01     #單據號碼
    LET g_tlf.tlf027 = l_rup.rup02     #單據項次
    LET g_tlf.tlf03 = l_tlf03          #資料目的
    LET g_tlf.tlf031 = g_img02_2       #倉庫(目的)
    LET g_tlf.tlf032 = g_img03_2       #儲位(目的)
    LET g_tlf.tlf033 = g_img04_2       #批號(目的)
    LET g_tlf.tlf035 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf036 = l_rup.rup01     #參考號碼
    LET g_tlf.tlf037 = l_rup.rup02     #單據項次
    LET g_tlf.tlf04 = ' '              #工作站                                                                                    
    LET g_tlf.tlf05 = ' '              #作業序號
    LET g_tlf.tlf06 = g_today          #日期
    LET g_tlf.tlf07 = g_today          #異動資料產生日期
    LET g_tlf.tlf08 = TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09 = g_user           #產生人
    LET g_tlf.tlf10 = l_tlf10          #收料數量
    LET g_tlf.tlf11 = l_rup.rup04      #收料單位 
    LET g_tlf.tlf12 = l_rup.rup08      #收料/庫存轉換率
    LET g_tlf.tlf13 = 'artt256'        #異動命令代號
    LET g_tlf.tlf15 = l_img26          #倉儲會計科目
    LET g_tlf.tlf60 = l_rup.rup08      #異動單據單位對庫存單位之換算率
    LET g_tlf.tlf930 = l_rup.rupplant
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_rup.rup01
    LET g_tlf.tlf906 = l_rup.rup02
    LET g_tlf.tlf907 = l_tlf907
    CALL s_tlf1(1,0,l_plant)
END FUNCTION

#生成調撥單
#若非在途，單據為結案狀態，否則為撥出審核狀態
FUNCTION s_transfer_a() 
   DEFINE   l_sql      STRING
   DEFINE   l_legal    LIKE azw_file.azw02
   DEFINE   l_ruocont  LIKE ruo_file.ruo10t

   IF g_success = 'N' THEN
      RETURN
   END IF
   
   LET l_ruocont = TIME  
   IF g_sma142_chk = "N" THEN    #非在途  
      UPDATE ruo_file SET ruoconf = '3',
                          ruo10 = g_today, 
                          ruo11 = g_user,
                          ruo10t = l_ruocont,
                          ruo12 = g_today, 
                          ruo13 = g_user,
                          ruo12t = l_ruocont,
                          ruo15 = 'Y'    
     WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
   ELSE
      UPDATE ruo_file SET ruoconf = '1',
                          ruo10 = g_today, 
                          ruo11 = g_user,
                          ruo10t = l_ruocont,
                          ruo15 = 'Y'  
     WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
   END IF  
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF    
   
   #撥出審核時要復制一筆相同的資料到撥入營運中心(ruoplant-->ruo05)
   #復制單頭資料到撥入營運中心
   DELETE FROM ruo_temp
   DELETE FROM rup_temp
   SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_ruo.ruo05
   INSERT INTO ruo_temp   SELECT * FROM ruo_file
                           WHERE ruo01 = g_ruo.ruo01 
                             AND ruoplant = g_ruo.ruoplant 
    
   IF g_sma142_chk = "N" THEN    #非在途
      UPDATE ruo_temp SET ruoplant = g_ruo.ruo05,
                          ruolegal = l_legal
   ELSE
      UPDATE ruo_temp SET ruoplant = g_ruo.ruo05,
                          ruolegal = l_legal,
                          ruo15 = 'N'
   END IF
   LET l_sql = " INSERT INTO ",cl_get_target_table(g_ruo.ruo05, 'ruo_file'),
               " SELECT * FROM ruo_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
   CALL cl_parse_qry_sql(l_sql, g_ruo.ruo05) RETURNING l_sql
   PREPARE trans_ins_ruo FROM l_sql
   EXECUTE trans_ins_ruo
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ruo_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF     
   
   #復制單身資料到撥入營運中心
   INSERT INTO rup_temp   SELECT * FROM rup_file
                           WHERE rup01 = g_ruo.ruo01 
                             AND rupplant = g_ruo.ruoplant
   
   IF g_sma142_chk = "N" THEN    #非在途
      UPDATE rup_temp SET rupplant = g_ruo.ruo05,
                          ruplegal = l_legal,
                          rup18 = 'Y'
   ELSE
      UPDATE rup_temp SET rupplant = g_ruo.ruo05,
                          ruplegal = l_legal
   END IF

   LET l_sql = " INSERT INTO ",cl_get_target_table(g_ruo.ruo05, 'rup_file'),
               " SELECT * FROM rup_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
   CALL cl_parse_qry_sql(l_sql, g_ruo.ruo05) RETURNING l_sql
   PREPARE trans_ins_rup FROM l_sql
   EXECUTE trans_ins_rup
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO rup_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DROP TABLE ruo_temp
   DROP TABLE rup_temp
END FUNCTION 

#撥入審核時更改調撥單的狀態為撥入審核
FUNCTION s_transfer_st()
   DEFINE   l_sql      STRING
   DEFINE   l_ruocont  LIKE ruo_file.ruo10t #審核時間

   IF g_success = 'N' THEN
      RETURN
   END IF
   LET l_ruocont = TIME 
   LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'ruo_file'),
               "   SET ruoconf = '2' , ",               
               "       ruo12 = '",g_today,"',", 
               "       ruo13 = '",g_user,"',",
               "       ruo12t = '",l_ruocont,"',",
               "       ruo15 = 'Y'",    
               " WHERE ruo01 = '",g_ruo.ruo01,"'",
               "   AND ruoplant = '",g_ruo.ruoplant,"'"
   PREPARE trans_upd_ruo1 FROM l_sql
   EXECUTE trans_upd_ruo1 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
     CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
     LET g_success='N'
     RETURN
   END IF
   LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo05, 'ruo_file'),
               "   SET ruoconf = '2' , ",               
               "       ruo12 = '",g_today,"',", 
               "       ruo13 = '",g_user,"',",
               "       ruo12t = '",l_ruocont,"',",
               "       ruo15 = 'Y'",    
               " WHERE ruo01 = '",g_ruo.ruo01,"'",
               "   AND ruoplant = '",g_ruo.ruoplant,"'"
   PREPARE trans_upd_ruo2 FROM l_sql
   EXECUTE trans_upd_ruo2 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
     CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
     LET g_success='N'
     RETURN
   END IF   
END FUNCTION

#FUN-AA0086--end---
 

