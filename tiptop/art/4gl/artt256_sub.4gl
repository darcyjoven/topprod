# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Program name...: artt256_sub.4gl
# Descriptions...: 調撥單審核操作
# Date & Author..: No.FUN-AA0086 10/11/12 by lixia 
# Modify.........: No.FUN-AC0040 10/12/20 By lixia s_transfe更改位置和名稱
# Modify.........: No.TQC-AC0389 10/12/29 By lixia 採購單的預設單別應該為撥入營運中心的預設單別
# Modify.........: No.TQC-AC0382 10/12/29 By lixia 調撥調整修改
# Modify.........: No.TQC-AC0407 11/01/04 By lixia CALL s_fetch_price3中pmnplant取撥入方plant code
# Modify.........: No.TQC-B20004 11/02/25 By lixia 
# Modify.........: No.TQC-B30102 11/03/10 By lixia tlf修改
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:TQC-B60126 11/06/20 By baogc 修改下游廠商對應客戶編號的賦值
# Modify.........: No:TQC-B70026 11/07/05 By pauline 當在途倉撥入確認時,撥出數量與撥入數量相同時會一同更改撥出確認的日期與人員
# Modify.........: No.FUN-B80085 11/08/09 By fanbj FOR UPDATE 下一行調用cl_forupd_sql 函式
# Modify.........: No:TQC-BA0063 11/10/28 By pauline 撥出確認控卡取消預設倉設定
# Modify.........: No:FUN-BA0096 11/10/31 By pauline 調整tlf026,tlf036寫入資料
# Modify.........: No:FUN-BA0104 11/10/28 By pauline 搬移程式碼
# Modify.........: No.FUN-BB0084 11/11/29 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/12/21 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BC0048 12/01/13 By nanbing MARK t256_sub_v()中的 事務處理
# Modify.........: No.FUN-BB0001 12/01/18 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No:TQC-BC0039 12/01/18 By pauline 調整tlf026,tlf036寫入資料
# Modify.........: No.FUN-B90101 12/01/29 By lixiang 服飾二維開發，寫入子單身，需同步更新母單身的資料
# Modify.........: No:MOD-BC0245 12/02/15 By suncx 營運中心調撥單作業 在撥入審核時，撥出審核人和時間都被更改為撥入審核人和撥入審核的時間
# Modify.........: No:TQC-C20352 12/02/22 By lixiang BUG修改
# Modify.........: No:MOD-C30850 12/03/26 By SunLM 調撥單如果是不同法人間調撥，單身有兩個或以上項次對應的商品編號一樣，程序審核就會蕩掉
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No:TQC-C90058 12/09/11 By yangxf 根據來源項次關係抓取調撥單單位和數量
# Modify.........: No:TQC-C90064 12/09/14 By dongsz 不使用在途倉時，撥出審核時要更新撥出審核日期和撥出審核人員
# Modify.........: No:FUN-CA0086 12/10/10 By shiwuying 增加调拨单退货
# Modify.........: No:FUN-C90049 12/10/20 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CC0057 12/12/19 By xumeimei 拨入审核时，拨入营运中心跟取货营运中心不一致时，在拨入和取货营运中心各写一笔代管库存明细异动资料
# Modify.........: No:FUN-CC0082 12/12/27 By baogc 邏輯調整
# Modify.........: No:FUN-CC0158 12/12/31 By xumeimei INSERT INTO rup_file是rup22给值:拨入营运中心
# Modify.........: No:FUN-D10106 13/01/23 By dongsz 1.審核時添加成本關帳日期的檢查  2.調整日期的賦值
# Modify.........: No:MOD-CB0117 13/03/04 By Elise tlf10是單據數量,請修正傳入s_log中的值審核人員
# Modify.........: No:MOD-D30179 13/03/20 By Sakura 有CALL s_upimg1()時,顯示錯誤訊息s_errmsg後一併顯示料號以及欄位
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08

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
DEFINE     g_msg          LIKE ze_file.ze03
DEFINE     g_sma142_chk   LIKE sma_file.sma142 #是否在途管理
DEFINE     g_sma143_chk   LIKE sma_file.sma143 #在途歸屬 1：歸屬撥出方 2：歸屬撥入方
DEFINE     g_flow99       LIKE ruo_file.ruo99  #FUN-CA0086
 
#根據闖入的參數l_flag判處 1：撥出審核  2：撥入審核                   
FUNCTION t256_sub(p_ruo,p_flag,p_flag1) 
   DEFINE     p_flag         LIKE type_file.chr1  
   DEFINE     p_flag1        LIKE type_file.chr1   #是否走倉退
   DEFINE     p_ruo          RECORD LIKE ruo_file.* 
   DEFINE     l_cnt          LIKE type_file.num5  
   DEFINE     l_sql          STRING   
   DEFINE     l_imd20        LIKE imd_file.imd20
   DEFINE     l_flag1        LIKE type_file.chr1
   DEFINE     l_sma53        LIKE sma_file.sma53    #FUN-D10106 add
   WHENEVER ERROR CONTINUE   #TQC-C90058 add

   IF g_success = 'N' THEN
      RETURN
   END IF
   #SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
   #SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp 
   LET g_flag = p_flag
   LET g_ruo.* = p_ruo.*  
   
  #FUN-D10106--add--str---
   IF g_flag = '1' THEN
      IF g_ruo.ruo07 <= g_sma.sma53 THEN
         CALL s_errmsg('',g_ruo.ruo04,'','mfg9999',1)
         LET g_success='N'
         RETURN
      ELSE
         IF g_ruo.ruo901 = 'Y' THEN
            LET l_sql = " SELECT sma53 FROM ",cl_get_target_table(g_ruo.ruo05,'sma_file'),
                        "  WHERE sma00 = '0'"
            PREPARE sel_sma_pre FROM l_sql
            EXECUTE sel_sma_pre INTO l_sma53
            IF g_ruo.ruo07 <= l_sma53 THEN
               CALL s_errmsg('',g_ruo.ruo05,'','mfg9999',1)
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   ELSE
      IF g_ruo.ruo07 <= g_sma.sma53 THEN
         CALL s_errmsg('',g_ruo.ruo05,'','mfg9999',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
  #FUN-D10106--add--end---
   IF cl_null(g_ruo.ruo14) THEN #由在途倉有無判斷是否在途管理
      LET g_sma142_chk = 'N'
      LET g_sma143_chk = ''
   ELSE
      LET g_sma142_chk = 'Y' #在途管理時，在撥出營運中心查找在途歸屬
      LET l_sql = "SELECT imd20 FROM ",cl_get_target_table(g_ruo.ruo04, 'imd_file'),
                  " WHERE imd01 = '",g_ruo.ruo14,"'",
            #      "   AND imd10 = 'W' AND imd22 = 'Y' "     #TQC-BA0063 mark
                  "   AND imd10 = 'W' "                #TQC-BA0063 add     
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql 
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

   IF g_sma142_chk = "N" THEN      #非在途（調撥單位結案，無撥入審核）
      IF g_ruo.ruo901 = 'N' THEN   #非多角
         CALL t256_sub_a()       #產生調撥單 （撥入而且結案）   #FUN-BA0096 add
         CALL t256_sub_s(g_ruo.ruo04,g_ruo.ruo01,'1') #倉庫間調撥（撥出到撥入）
    #     CALL t256_sub_a()       #產生調撥單 （撥入而且結案）   #FUN-BA0096 mark      
      ELSE                         #多角
        #FUN-CA0086 Begin---
        #差異調整單 或者 调拨单退货都走多角仓退
        #IF g_ruo.ruo02 = '4' AND p_flag1 = 'Y' THEN #差異調整單  
         IF (g_ruo.ruo02 = '4' AND p_flag1 = 'Y') OR (g_ruo.ruo02 = '7') THEN
        #FUN-CA0086 End-----
            CALL t256_sub_wback()#倉退
         ELSE
            CALL t256_sub_v()    #多角貿易（撥入與撥出之間）
         END IF
         CALL t256_sub_a()       #產生調撥單 （撥入而且結案）
      END IF
      CALL t256_sub_ruo_upd('3',g_ruo.ruo04,'','1')
      CALL t256_sub_ins_rxg(g_ruo.*)              #FUN-CC0057 add
#TQC-AC0382--mark--str--
#      IF g_ruo.ruopos = 'N' AND g_ruo.ruo02 = '4' THEN  #pos拋磚的單據為撥出審核狀態
#         CALL t256_sub_ruo_upd('1',g_ruo.ruo04,'','1')
#      ELSE
#         IF g_success = 'Y' THEN
#            CALL t256_sub_rup_upd() RETURNING  l_flag1
#            CALL t256_sub_ruo_upd('3',g_ruo.ruo04,'','1')
#         END IF
#      END IF
#TQC-AC0382--mark--end--
   ELSE                            #在途         
      IF g_ruo.ruo901 = 'N' THEN   #非多角         
         IF g_flag = '1' THEN      #撥出審核時產生狀態為撥出審核的調撥單,撥出到在途異動
            CALL t256_sub_a()                 #FUN-BA0096 add
            CALL t256_sub_ruo_upd('1',g_ruo.ruo04,'','1')                   #FUN-BA0096 add
            CALL t256_sub_s(g_ruo.ruo04,g_ruo.ruo01,'1') #倉庫間調撥
 #           CALL t256_sub_a()                                 #FUN-BA0096 mark
 #           CALL t256_sub_ruo_upd('1',g_ruo.ruo04,'','1')     #FUN-BA0096 mark
         ELSE                      #撥入審核時更改調撥單狀態，在途到撥入異動
            #CALL t256_sub_s(g_ruo.ruo04,g_ruo.ruo01,'2') #倉庫間調撥
            CALL t256_sub_s(g_ruo.ruo04,g_ruo.ruo011,'2') #倉庫間調撥 #TQC-AC0407
            IF g_success = 'Y' THEN
               CALL t256_sub_rup_upd() RETURNING  l_flag1
               CALL t256_sub_ruo_upd(l_flag1,g_ruo.ruo04,'','1')
            END IF
            CALL t256_sub_ins_rxg(g_ruo.*)              #FUN-CC0057 add
         END IF              
      ELSE                               #多角  
         IF g_flag = '1' THEN            #撥出審核   
            IF g_sma143_chk ='1' THEN #在途歸屬撥出
              CALL t256_sub_a()       #產生調撥單 （撥入而且撥出審核）                #FUN-BA0096 add 
              CALL t256_sub_s(g_ruo.ruo04,g_ruo.ruo01,'1')    #倉庫間調撥（撥出到在途）
             #CALL t256_sub_a()       #產生調撥單 （撥入而且撥出審核）              #FUN-BA0096 mark
            ELSE
               CALL t256_sub_a()      #產生調撥單 （撥入而且撥出審核）                #FUN-BA0096 add
              #FUN-CA0086 Begin---
              #CALL t256_sub_v()      #多角貿易（撥出與在途）
               IF g_ruo.ruo02 = '7' THEN
                  CALL t256_sub_wback()     #倉退
               ELSE
                  CALL t256_sub_v()   #多角貿易（撥出與在途）
               END IF
              #FUN-CA0086 End-----
              #CALL t256_sub_a()      #產生調撥單 （撥入而且撥出審核）                 #FUN-BA0096 mark
            END IF
            CALL t256_sub_ruo_upd('1',g_ruo.ruo04,'','1')
         ELSE
            IF g_sma143_chk ='1' THEN #在途歸屬撥出
              #FUN-CA0086 Begin---
               IF g_ruo.ruo02 = '7' THEN
                  CALL t256_sub_wback()     #倉退
               ELSE
              #FUN-CA0086 End-----
                  CALL t256_sub_v()    #多角貿易（在途到撥入）
               END IF #FUN-CA0086
            ELSE
               CALL t256_sub_s(g_ruo.ruo05,g_ruo.ruo01,'2')    #倉庫間調撥（在途到撥入）
            END IF   
            IF g_success = 'Y' THEN
               CALL t256_sub_rup_upd() RETURNING  l_flag1
               CALL t256_sub_ruo_upd(l_flag1,g_ruo.ruo04,'','1')
            END IF
            CALL t256_sub_ins_rxg(g_ruo.*)              #FUN-CC0057 add
         END IF         
      END IF
     #FUN-CA0086 Begin---
      IF g_flag = '2' THEN
         LET g_cnt = 0
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo.ruo05, 'rup_file'),
                     " WHERE rup01 = '",g_ruo.ruo01,"'",
                     "   AND rup16 > rup12 "
         PREPARE t256_sub_sel_rup12_16 FROM g_sql
         EXECUTE t256_sub_sel_rup12_16 INTO g_cnt
         IF g_cnt > 0 THEN
            CALL t256_sub_ins_rvq()
         END IF
      END IF
     #FUN-CA0086 End-----
   END IF  
   #FUN-B90101--add--begin--
   #服飾行業下，根據子單身的資料匯總到母單身中
   IF s_industry("slk") THEN
      CALL t256_ins_rupslk(g_ruo.ruo011)
      CALL t256_sub_rupslk_upd()      #TQC-C20352 add
   END IF
   #FUN-B90101--add--end-- 
END FUNCTION 

#多角貿易單據拋轉
FUNCTION t256_sub_v() 
   DEFINE l_ruoconf         LIKE ruo_file.ruoconf
   DEFINE l_pmm01           LIKE pmm_file.pmm01  #採購單號
   #DEFINE l_poz17           LIKE poz_file.poz17  #流程是否要一次完成
   DEFINE l_pmm99           LIKE pmm_file.pmm99  #多角貿易流程序號 
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE p_plant_new       LIKE azp_file.azp01
   DEFINE p_plant_new_a     LIKE azp_file.azp01 
   DEFINE l_sql             STRING
   

   #CREATE TEMP TABLE p801_file(
   #     p_no     LIKE type_file.num5,
   #     so_no    LIKE pmm_file.pmm01,   #採購單號
   #     so_item  LIKE type_file.num5,
   #     so_price LIKE oeb_file.oeb13,   #單價
   #     so_curr  LIKE pmm_file.pmm22);  #幣種

   DELETE FROM p801_file;

   #CREATE TEMP TABLE p900_file(
   #    p_no        LIKE type_file.num5,
   #    pab_no      LIKE oea_file.oea01, #訂單單號
   #    pab_item    LIKE type_file.num5,
   #    pab_price   LIKE type_file.num20_6);
   DELETE FROM p900_file;

      IF g_success = 'N' THEN
         RETURN
      END IF
      #1.撥入營運中心--產生采購單
      LET g_success = 'Y'
      CALL t256_pmm_ins()
      IF g_success = 'N' THEN         
        # ROLLBACK WORK     #FUN-BC0048 Mark
         #CALL s_showmsg()
         RETURN
      END IF

      #2.代采買--正拋
      LET g_from_plant = g_ruo.ruo05     #拋轉資料的來源
               
      CALL p801(g_pmm.pmm01,'N',TRUE)           
      IF g_success = 'N' THEN        
        # ROLLBACK WORK     #FUN-BC0048 Mark
         #CALL s_showmsg()
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

      #SELECT poz17 INTO l_poz17 FROM poz_file WHERE poz01 = g_ruo.ruo904
      #IF cl_null(l_poz17) THEN LET l_poz17 = 'N' END IF
      #多角貿易流程需一次完成
      #IF l_poz17 = 'Y' THEN
         #3.出貨工廠--生成出貨單
         CALL t256_oga_ins(l_pmm01)
         IF g_success = 'N' THEN           
           # ROLLBACK WORK   #FUN-BC0048 Mark
            #CALL s_showmsg()
            RETURN
         END IF

         CALL s_mtrade_last_plant(g_ruo.ruo904)     #最后一站的站別 & 營運中心
              RETURNING l_last_poy02,l_last_poy04
         
         #4.出貨工廠--出貨單過帳
         CALL t254_1('6',g_oga.oga01,l_last_poy04,g_ruo.ruo07,l_pmm99)   #出貨單過帳
         IF g_success = 'N' THEN
           # ROLLBACK WORK   #FUN-BC0048 Mark
            #CALL s_showmsg()
            RETURN
         END IF

         #5.銷售逆拋
         CALL p900_p2(g_oga.oga01,g_oga.oga09,l_last_poy04)    #多角拋轉
         IF g_success = 'N' THEN
           # ROLLBACK WORK   #FUN-BC0048 Mark
            #CALL s_showmsg()
            RETURN
         END IF
         LET l_ruoconf = '2'
      #END IF

      LET g_ruo.ruo99 = l_pmm99
      LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruoplant,'ruo_file'),
                  "   SET ruoconf   = '",l_ruoconf,"',",
                  "       ruo99   = '",g_ruo.ruo99,"',",
                  "       ruomodu = '",g_user,"',",
                  "       ruodate = '",g_today,"'",
                  " WHERE ruo01   = '",g_ruo.ruo01,"'",
                  "   AND ruoplant = '",g_ruo.ruoplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_ruo.ruoplant) RETURNING l_sql
      PREPARE pre_updruo FROM l_sql
      EXECUTE pre_updruo
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('ruo01',g_ruo.ruo01,"UPDATE ruo_file",SQLCA.sqlcode,1)
         LET g_ruo.ruo06 = NULL
         LET g_success = 'N'
      ELSE
         LET g_ruo.ruoconf = l_ruoconf
      END IF
  #FUN-BC0048 Mark start ---
  # IF g_success = 'Y' THEN
  #    COMMIT WORK
  # ELSE
  #    ROLLBACK WORK
  # END IF
  # CALL s_showmsg()
  #FUN-BC0048 Mark end---
   #DROP TABLE p801_file;
   #DROP TABLE p900_file;

   #DISPLAY BY NAME g_ruo.ruoconf
   #DISPLAY BY NAME g_ruo.ruo99
   
END FUNCTION 

#撥入營運中心--產生采購單
FUNCTION t256_pmm_ins()
   DEFINE l_poy         RECORD LIKE poy_file.*#多角貿易單身檔 
   DEFINE l_pmc         RECORD LIKE pmc_file.*#供應商基本資料檔
   DEFINE p_plant_new   LIKE azp_file.azp01
   DEFINE l_poy03       LIKE poy_file.poy03   #下游廠商編號
   DEFINE li_result     LIKE type_file.num5
   DEFINE l_sql         STRING
##-TQC-B60126 - ADD - BEGIN ---------------------
   DEFINE l_poy31       LIKE poy_file.poy03,
          l_poy32       LIKE poy_file.poy03,
          l_poy33       LIKE poy_file.poy03,
          l_poy34       LIKE poy_file.poy03,
          l_poy35       LIKE poy_file.poy03,
          l_poy36       LIKE poy_file.poy03
   DEFINE i             LIKE type_file.num5
##-TQC-B60126 - ADD -  END  ---------------------

   INITIALIZE g_pmm.* TO NULL  #採購單單頭

   LET g_pmm.pmm40 = 0   #未稅淨額
   LET g_pmm.pmm40t = 0  #含稅金額

   #撥入營運中心
   #SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
   # WHERE poy01 = poz01
   #   AND poy01 = g_ruo.ruo904
   #   AND poy02 = (SELECT MIN(poy02) FROM poy_file
   # WHERE poy01 = g_ruo.ruo904)
   LET l_sql = "SELECT poy_file.* FROM ",cl_get_target_table(g_ruo.ruo04, 'poy_file'),",",
                                         cl_get_target_table(g_ruo.ruo04, 'poz_file'),
               " WHERE poy01 = poz01 ",
               "   AND poy01 = '",g_ruo.ruo904,"'",
               "   AND poy02 = (SELECT MIN(poy02) FROM ",cl_get_target_table(g_ruo.ruo04, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
   PREPARE sel_poy1 FROM l_sql
   EXECUTE sel_poy1 INTO l_poy.*
  
   #撥入營運中心和apmi000中0站的營運中心不同
   IF g_ruo.ruo05 <> l_poy.poy04 THEN
      LET g_showmsg = g_ruo.ruo05,'/',l_poy.poy04
      CALL s_errmsg('ruo05,poy04',g_showmsg,'PLANT DIFF','atm-152',1)
      LET g_success = 'N'
      RETURN
   END IF

   #出貨站
   #流通配销时,调拨可能是很多站,而并不是原来的2站式   
   #SELECT poy03 INTO l_poy03 FROM poy_file,poz_file #下游產商編號
   # WHERE poz01 = g_ruo.ruo904
   #   AND poz01 = poy01
   #   AND poy02 = (SELECT MIN(poy02) + 1 FROM poy_file
   # WHERE poy01 = g_ruo.ruo904)
   LET l_sql = "SELECT poy03 FROM ",cl_get_target_table(g_ruo.ruo04, 'poy_file'),",",
                                    cl_get_target_table(g_ruo.ruo04, 'poz_file'),
               " WHERE poz01 = '",g_ruo.ruo904,"'",
               "   AND poz01 = poy01",
               "   AND poy02 = (SELECT MIN(poy02) + 1 FROM ",cl_get_target_table(g_ruo.ruo04, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
   PREPARE sel_poy2 FROM l_sql
   EXECUTE sel_poy2 INTO l_poy03
    
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
     #LET g_pmm.pmm04 = g_today     #採購日期     #FUN-D10106 mark
      LET g_pmm.pmm04 = g_ruo.ruo07 #採購日期     #FUN-D10106 add
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
#--TQC-B60126 - MARK - BEGIN -------------------------------
#  LET g_pmm.pmm911 = l_poy.poy31    #下游廠商對應客戶編號
#  LET g_pmm.pmm912 = l_poy.poy32    #下游廠商對應客戶編號
#  LET g_pmm.pmm913 = l_poy.poy33    #下游廠商對應客戶編號
#  LET g_pmm.pmm914 = l_poy.poy34    #下游廠商對應客戶編號
#  LET g_pmm.pmm915 = l_poy.poy35    #下游廠商對應客戶編號
#  LET g_pmm.pmm916 = l_poy.poy36    #下游廠商對應客戶編號
#--TQC-B60126 - MARK -  END  -------------------------------
#--TQC-B60126 - ADD  - BEGIN -------------------------------
   FOR i = 1 TO 6
       SELECT poy03 INTO l_poy03 FROM poy_file
        WHERE poy01 = g_pmm.pmm904 AND poy02 = i
       IF STATUS THEN LET l_poy03 = '' END IF
       CASE i
         WHEN 1 LET l_poy31 = l_poy03
         WHEN 2 LET l_poy32 = l_poy03
         WHEN 3 LET l_poy33 = l_poy03
         WHEN 4 LET l_poy34 = l_poy03
         WHEN 5 LET l_poy35 = l_poy03
         WHEN 6 LET l_poy36 = l_poy03
      END CASE
   END FOR
   LET g_pmm.pmm911 = l_poy31
   LET g_pmm.pmm912 = l_poy32
   LET g_pmm.pmm913 = l_poy33
   LET g_pmm.pmm914 = l_poy34
   LET g_pmm.pmm915 = l_poy35
   LET g_pmm.pmm916 = l_poy36
#--TQC-B60126 - ADD  -  END  -------------------------------
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
   DEFINE l_sql         STRING

   IF cl_null(p_poy.poy35) THEN   #采购单别
      #SELECT rye03 INTO p_poy.poy35 FROM rye_file
      # WHERE rye01 = 'apm'
      #   AND rye02 = '2'
      #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo.ruo04,'rye_file'),
      #FUN-C90050 mark begin---
      #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo.ruo05,'rye_file'), #TQC-AC0389
      #            " WHERE rye01 = 'apm'",
      #            "   AND rye02 = '2'" 
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      ##CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
      #CALL cl_parse_qry_sql(l_sql,g_ruo.ruo05) RETURNING l_sql  #TQC-AC0389
      #PREPARE pre_selrye03 FROM l_sql
      #EXECUTE pre_selrye03 INTO p_poy.poy35 
      #IF SQLCA.sqlcode THEN
      #   LET g_showmsg = 'apm','/2'
      #   CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
      #   LET g_success = 'N'
      #   #RETURN   #TQC-B20004
      #END IF     
      #FUN-C90050 mark end----

      #FUN-C90050 add begin---
      CALL s_get_defslip('apm','2',g_ruo.ruo05,'N') RETURNING  p_poy.poy35   
      IF cl_null(p_poy.poy35) THEN
         LET g_showmsg = 'apm','/2'
         CALL s_errmsg('','','sel rye03','art-330',1)
         LET g_success = 'N'
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
      #RETURN  #TQC-B20004
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
   DEFINE l_sql           STRING

   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruoplant,'rup_file'),
               " WHERE rup01 = '",g_ruo.ruo01,"'",
               "   AND rupplant = '",g_ruo.ruoplant,"'",
               " ORDER BY rup02 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruoplant) RETURNING l_sql
   PREPARE t256_pre_rup11 FROM l_sql
   DECLARE t256_b3_b CURSOR FOR t256_pre_rup11
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
      IF g_flag = '1' THEN
         LET l_pmn.pmn20 = l_rup.rup12   #採購量
      ELSE
         LET l_pmn.pmn20 = l_rup.rup16   #採購量
      END IF
      IF cl_null(l_ima908) THEN LET l_ima908 = l_pmn.pmn07 END IF
      LET l_pmn.pmn86 = l_ima908      #計價單位
      CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_pmn.pmn87 = l_pmn.pmn20*l_fac  #計價數量
      LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)  #FUN-BB0084  

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
         #CALL s_fetch_price3(g_ruo.ruo904,l_pmn.pmnplant,l_pmn.pmn04,l_pmn.pmn86,'0',0)
         CALL s_fetch_price3(g_ruo.ruo904,g_ruo.ruo05,l_pmn.pmn04,l_pmn.pmn86,'0',0)#TQC-AC0407
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
      LET l_pmn.pmn77   = l_rup.rupplant                #來源機構

      
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
   DEFINE l_sql             STRING

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
    
    #SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
    # WHERE poy01 = poz01
    #   AND poy01 = g_ruo.ruo904
    #   AND poy02 = (SELECT MAX(poy02) FROM poy_file
    # WHERE poy01 = g_ruo.ruo904)
    LET l_sql = "SELECT poy_file.*  FROM ",cl_get_target_table(g_ruo.ruo04,'poy_file'),",",
                                           cl_get_target_table(g_ruo.ruo04,'poz_file'),
                " WHERE poy01 = poz01",
                "   AND poy01 = '",g_ruo.ruo904,"'",
                "   AND poy02 = (SELECT MAX(poy02) FROM ",cl_get_target_table(g_ruo.ruo04,'poy_file'),
                " WHERE poy01 = '",g_ruo.ruo904,"')"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
    PREPARE pre_selpoy2 FROM l_sql
    EXECUTE pre_selpoy2 INTO l_poy.*
    
    #配销时,若apmi000没有设置,则可以找ART默认设置
    IF g_azw.azw04 = '2' THEN
       IF cl_null(l_poy.poy36) THEN          
          #SELECT rye03 INTO l_poy.poy36 FROM rye_file
          # WHERE rye01 = 'axm'
          #   AND rye02 = '50'
          #FUN-C90050 mark begin---
          #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo.ruo04,'rye_file'),
          #            " WHERE rye01 = 'axm'",
          #            "   AND rye02 = '50'" 
          #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          #CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
          #PREPARE pre_selrye2 FROM l_sql
          #EXECUTE pre_selrye2 INTO l_poy.poy36
          #IF SQLCA.sqlcode THEN
          #   LET g_showmsg = 'axm','/50'
          #   CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
          #   LET g_success = 'N'
          #   RETURN
          #END I
          #FUN-C90050 mark end-----

          #FUN-C90050 add begin---
          CALL s_get_defslip('axm','50',g_ruo.ruo04,'N') RETURNING l_poy.poy36
          IF cl_null(l_poy.poy36) THEN
             LET g_showmsg = 'axm','/50'
             CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF   
          #FUN-C90050 add end-----
       END IF
       IF cl_null(l_poy.poy11) THEN #出货仓库
          #SELECT rtz07 INTO l_poy.poy11 FROM rtz_file
          # WHERE rtz01 = l_last_poy04
          #FUN-C90049 mark begin----
          #LET l_sql = "SELECT rtz07 FROM ",cl_get_target_table(g_ruo.ruo04,'rtz_file'),
          #            " WHERE rtz01 = '",l_last_poy04,"'"
          #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          #CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
          #PREPARE pre_selrtz2 FROM l_sql
          #EXECUTE pre_selrtz2 INTO l_poy.poy11
          #IF SQLCA.sqlcode THEN
          #   CALL s_errmsg('rtz01',l_last_poy04,'SELECT rtz07',SQLCA.sqlcode,1)
          #END IF
          #FUN-C90049 mark end-----
          CALL s_get_coststore(l_last_poy04,'') RETURNING l_poy.poy11    #FUN-C90049 add 
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
                "ogaorig, oga71)",
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
                "         ?,?)      "
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
       g_oga.ogaorig, g_oga.oga71
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

   #SELECT poy11 INTO l_poy11   #倉庫別
   #  FROM poy_file,poz_file
   # WHERE poz01 = g_ruo.ruo904
   #   AND poz01 = poy01
   #   AND poy02 IN (SELECT MAX(poy02) FROM poy_file
   # WHERE poy01 = g_ruo.ruo904)
   LET l_sql = "SELECT poy11 FROM ",cl_get_target_table(g_ruo.ruo04,'poy_file'),",",
                                    cl_get_target_table(g_ruo.ruo04,'poz_file'),
               " WHERE poz01 = '",g_ruo.ruo904,"'",
               "   AND poz01 = poy01",
               "   AND poy02 IN (SELECT MAX(poy02) FROM ",cl_get_target_table(g_ruo.ruo04,'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
   PREPARE sel_poy11 FROM l_sql
   EXECUTE sel_poy11 INTO l_poy11   #倉庫別

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
                     "   AND rup03 = '",l_oeb.oeb04,"'",
                     "   AND rup02 = '",l_oeb.oeb03,"'"  #MOD-C30850 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql
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
      LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15)   #FUN-910088--add--
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
     # -----------add start-------------
     # IF cl_null(l_ogb.ogb50) THEN
     #    LET l_ogb.ogb50 = '1'                  
     # END IF
     # -------------add end-------------------
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
                  #"ogb44,  ogb45,  ogb46,    ogb47,ogb50)",            # add ogb50
                  "ogb44,  ogb45,  ogb46,    ogb47,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)", #FUN-C50097 ADD ogb50,51,52
                  "   VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  #"          ?,?,?,?,?, ?,?,?,?,?)    "                 #add?
                  "          ?,?,?,?,?, ?,?,?,? ,?,?,?,?,?,?)    "                        #FUN-C50097 ADD ogb50,51,52
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
         #l_ogb.ogb44,  l_ogb.ogb45,  l_ogb.ogb46,    l_ogb.ogb47,   l_ogb.ogb50     # add ogb50 
         l_ogb.ogb44,  l_ogb.ogb45,  l_ogb.ogb46,    l_ogb.ogb47,l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,   #FUN-C50097 ADD ogb50,51,52
         l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55
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
FUNCTION t256_sub_s(p_plant,p_ruo01,l_flag)  
   DEFINE   p_plant     LIKE azp_file.azp01  #調撥單所屬營運中心
   DEFINE   p_ruo01     LIKE ruo_file.ruo01  #調撥單單號   
   DEFINE   l_plant_1   LIKE azp_file.azp01  #出庫營運中心
   DEFINE   l_plant_2   LIKE azp_file.azp01  #入庫營運中心  
   DEFINE   l_flag      LIKE type_file.chr1  #標誌位1為撥出到在途2為在途到撥入
   DEFINE   l_qty_1     LIKE rup_file.rup12  #異動數量
   DEFINE   l_qty_2     LIKE rup_file.rup12  #異動數量
   DEFINE   l_rup       RECORD  LIKE rup_file.*  
   DEFINE   l_sql       STRING 
   DEFINE   l_cnt       LIKE type_file.num5
   DEFINE   l_qtyin     LIKE rup_file.rup16  #撥入單據異動數量 #MOD-CB0117 add
   DEFINE   l_qtyout    LIKE rup_file.rup12  #撥出單據異動數量 #MOD-CB0117 add

   IF g_success = 'N' THEN
      RETURN
   END IF 
   #查出調撥單的單身資料
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant, 'rup_file'),
               "  WHERE  rup01 = '",p_ruo01,"'",
               "    AND  rupplant = '",p_plant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sel_rup FROM l_sql            
   DECLARE cur_selrup CURSOR FOR sel_rup
   FOREACH cur_selrup INTO l_rup.*
      IF STATUS THEN
         #CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL s_errmsg('foreach','','rup_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF g_sma142_chk = "Y"  THEN                #在途管理為Y         
         IF l_flag = '1' THEN                    #撥出到在途
            LET g_img02_1 = l_rup.rup09          #撥出倉庫編號 							
            LET g_img02_2 = g_ruo.ruo14          #在途仓仓库编号							
            LET g_img03_1 = l_rup.rup10          #拨出储位							
            LET g_img03_2 = ' '							
            LET g_img04_1 = l_rup.rup11          #拨出批							
            LET g_img04_2 = ' '							
            LET l_qtyout  = l_rup.rup12          #單據數量 #MOD-CB0117 add
            LET l_qtyin   = l_qtyout             #單據數量 #MOD-CB0117 add
            LET l_qty_1 = l_rup.rup12*l_rup.rup08#數量
            LET l_qty_2 = l_qty_1    
            IF g_sma143_chk = "1"  THEN          #在途歸屬撥出
               LET l_plant_1 = g_ruo.ruo04
               LET l_plant_2 = g_ruo.ruo04
            ELSE
               LET l_plant_1 = g_ruo.ruo04
               LET l_plant_2 = g_ruo.ruo05
            END IF         
         ELSE                                    #在途到撥入 
            LET g_img02_1 = g_ruo.ruo14          #在途仓仓库编号 							
            LET g_img02_2 = l_rup.rup13          #撥入倉庫編號							
            LET g_img03_1 = ' '                 						
            LET g_img03_2 = l_rup.rup14		     #拨入储位					
            LET g_img04_1 = ' '						
            LET g_img04_2 = l_rup.rup15          #拨入批                    
            LET l_qtyin   = l_rup.rup16          #單據數量 #MOD-CB0117 add
            LET l_qtyout  = l_qtyin              #單據數量 #MOD-CB0117 add
            LET l_qty_2 = l_rup.rup16*l_rup.rup08 #撥入數量
            LET l_qty_1 = l_qty_2 
            IF g_sma143_chk = "1"  THEN          #在途歸屬撥出
               LET l_plant_1 = g_ruo.ruo04
               LET l_plant_2 = g_ruo.ruo05
            ELSE
               LET l_plant_1 = g_ruo.ruo05
               LET l_plant_2 = g_ruo.ruo05
            END IF 
         END IF
      ELSE                                       #撥出到撥入
         LET g_img02_1 = l_rup.rup09             #撥出倉庫編號 							
         LET g_img02_2 = l_rup.rup13             #撥入倉庫編號								
         LET g_img03_1 = l_rup.rup10             #拨出储位							
         LET g_img03_2 = l_rup.rup14		     #拨入储位								
         LET g_img04_1 = l_rup.rup11             #拨出批							
         LET g_img04_2 = l_rup.rup15             #拨入批							
         LET l_qtyout  = l_rup.rup12             #單據數量 #MOD-CB0117 add
         LET l_qtyin   = l_rup.rup16             #單據數量 #MOD-CB0117 add
         LET l_qty_1 = l_rup.rup12*l_rup.rup08   #撥出數量	
         LET l_qty_2 = l_rup.rup16*l_rup.rup08	 #撥入數量
         LET l_plant_1 = g_ruo.ruo04
         LET l_plant_2 = g_ruo.ruo05
      END IF
       
      #檢查撥出料倉儲批是否存在，不存在就增加
      LET l_cnt = 0
      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_1,'img_file'),
                  " WHERE img01 = '",l_rup.rup03,"'",
                  "   AND img02 = '",g_img02_1,"'",
                  "   AND img03 = '",g_img03_1,"'",         
                  "   AND img04 = '",g_img04_1,"'"         
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
      CALL cl_parse_qry_sql(l_sql,l_plant_1) RETURNING l_sql 
      PREPARE sel_img_cs1 FROM l_sql
      EXECUTE sel_img_cs1 INTO l_cnt
      
      IF l_cnt = 0 OR l_cnt IS NULL THEN      
         CALL s_madd_img(l_rup.rup03,g_img02_1,g_img03_1,g_img04_1,g_ruo.ruo01,'',g_today,l_plant_1)
      END IF 

      #出庫庫存異動
      CALL s_upimg1(l_rup.rup03,g_img02_1,g_img03_1,g_img04_1,-1,l_qty_1,g_today,l_rup.rup03,
                    l_rup.rup09,' ',' ',l_rup.rup01,l_rup.rup02,
                    l_rup.rup07,'',l_rup.rup04,'','','','','',0,0,'','',l_plant_1)
      IF g_success = 'N' THEN
         #CALL cl_err('s_upimg(-1)','9050',1) 
         #CALL s_errmsg('','','s_upimg(-1)','9050',1)              #MOD-D30179 mark
         CALL s_errmsg('rup03',l_rup.rup03,'s_upimg(-1)','9050',1) #MOD-D30179 add
         RETURN
      END IF
      #產生出庫異動記錄
     #CALL s_log(l_rup.*,l_plant_1,l_qty_1,'1')   #MOD-CB0117 mark
      CALL s_log(l_rup.*,l_plant_1,l_qtyout,'1')  #MOD-CB0117 add
      
      #檢查撥入料倉儲批是否存在，不存在就增加
      LET l_cnt = 0
      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_2,'img_file'),
                  " WHERE img01 = '",l_rup.rup03,"'",
                  "   AND img02 = '",g_img02_2,"'",
                  "   AND img03 = '",g_img03_2,"'",
                  "   AND img04 = '",g_img04_2,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_2) RETURNING l_sql
      PREPARE sel_img_cs2 FROM l_sql
      EXECUTE sel_img_cs2 INTO l_cnt
      
      IF l_cnt = 0 OR l_cnt IS NULL THEN      
         CALL s_madd_img(l_rup.rup03,g_img02_2,g_img03_2,g_img04_2,g_ruo.ruo01,'',g_today,l_plant_2)
      END IF 

      #入庫庫存異動              
      CALL s_upimg1(l_rup.rup03,g_img02_2,g_img03_2,g_img04_2,+1,l_qty_2,g_today,l_rup.rup03,
                    l_rup.rup09,' ',' ',l_rup.rup01,l_rup.rup02,
                    l_rup.rup07,'',l_rup.rup04,'','','','','',0,1,'','',l_plant_2) 
      IF g_success = 'N' THEN
         #CALL cl_err('s_upimg(-1)','9050',1) 
         #CALL s_errmsg('','','s_upimg(-1)','9050',1)              #MOD-D30179 mark
         CALL s_errmsg('rup03',l_rup.rup03,'s_upimg(-1)','9050',1) #MOD-D30179 add
         RETURN
      END IF
      #產生入庫異動記錄
     #CALL s_log(l_rup.*,l_plant_2,l_qty_2,'2')   #MOD-CB0117 mark 
      CALL s_log(l_rup.*,l_plant_2,l_qtyin,'2')   #MOD-CB0117 add
   END FOREACH   
END FUNCTION

#產生異動記錄 
FUNCTION s_log(l_rup,l_plant,l_qty,l_flag)
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
   DEFINE l_qty       LIKE rup_file.rup12
   DEFINE l_sql       STRING 
             
    IF l_flag = '1' THEN           #出庫異動記錄
       LET l_img02 = g_img02_1     #倉
       LET l_img03 = g_img03_1     #儲
       LET l_img04 = g_img04_1     #批
       LET l_tlf02 = 50            #來源狀況：倉庫
       LET l_tlf03 = 66            #目的狀況：多營運中心工單
       LET l_tlf10 = l_qty         #異動數量
       LET l_tlf907 = -1           #出庫
    ELSE
       LET l_img02 = g_img02_2    #倉
       LET l_img03 = g_img03_2    #儲
       LET l_img04 = g_img04_2    #批
       LET l_tlf02 = 57           #來源狀況：營運中心間調撥
       LET l_tlf03 = 50           #目的狀況：倉庫間調撥
       LET l_tlf10 = l_qty        #異動數量
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
       #CALL cl_err3("sel","img_file",l_rup.rup03,"",SQLCA.sqlcode,"","ckp#log",1)
       CALL s_errmsg('','','SELECT img_temp:',SQLCA.sqlcode,1)
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
    #LET g_tlf.tlf026 = l_rup.rup01     #單據號碼
#    LET g_tlf.tlf026 = g_ruo.ruo01     #單據號碼#TQC-AC0407        #FUN-BA0096 mark
#FUN-BA0096 add START
    IF g_sma142_chk = "N" THEN            #不走在途
       IF l_flag = 1 THEN                 #撥出確認
          LET g_tlf.tlf026 = g_ruo.ruo01
       ELSE
          LET g_tlf.tlf026 = g_ruo.ruo011       #撥入確認
       END IF
    END IF
    IF g_sma142_chk = "Y" THEN
       IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
          IF g_flag = '1' AND l_flag = '1' THEN    #撥出確認且出庫
             LET g_tlf.tlf026 = g_ruo.ruo01
          END IF
          IF g_flag = '1' AND l_flag = '2' THEN    #撥出確認且入庫
             LET g_tlf.tlf026 = g_ruo.ruo01
          END IF
       END IF
       IF g_sma.sma143 = '2' THEN   #調撥在途歸屬撥入方
          IF g_flag = '1' AND l_flag = '1' THEN    #撥出確認且出庫
             LET g_tlf.tlf026 = g_ruo.ruo01
          END IF
          IF g_flag = '1' AND l_flag = '2' THEN    #撥出確認且入庫
            #LET g_tlf.tlf026 = g_ruo.ruo011  #TQC-BC0039 mark
             LET g_tlf.tlf026 = g_ruo.ruo01        #TQC-BC0039 add
          END IF
       END IF
    END IF
    IF g_flag = '2' AND g_sma142_chk = "Y" THEN          #走在途且撥入確認
       LET g_tlf.tlf026 = g_ruo.ruo01
    END IF
#FUN-BA0096 add END
    LET g_tlf.tlf027 = l_rup.rup02     #單據項次
    LET g_tlf.tlf03 = l_tlf03          #資料目的
    LET g_tlf.tlf031 = g_img02_2       #倉庫(目的)
    LET g_tlf.tlf032 = g_img03_2       #儲位(目的)
    LET g_tlf.tlf033 = g_img04_2       #批號(目的)
    LET g_tlf.tlf035 = l_rup.rup04     #庫存單位
    #LET g_tlf.tlf036 = l_rup.rup01     #參考號碼
#    LET g_tlf.tlf036 = g_ruo.ruo01     #參考號碼#TQC-AC0407 #FUN-BA0096 mark
#FUN-BA0096 add START
    IF g_sma142_chk = "N" THEN         #不走在途
       IF l_flag = 1 THEN              #撥出確認
         #LET g_tlf.tlf036 = g_ruo.ruo011  #TQC-BC0039 mark
          LET g_tlf.tlf036 = g_ruo.ruo01   #TQC-BC0039 add
       ELSE                            #撥入確認
         #LET g_tlf.tlf036 = g_ruo.ruo01  #TQC-BC0039 mark
          LET g_tlf.tlf036 = g_ruo.ruo011   #TQC-BC0039 add
       END IF
    END IF
    IF g_sma142_chk = "Y" THEN
       IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
          IF g_flag = '1' AND l_flag = '1' THEN    #撥出確認且出庫
            #LET g_tlf.tlf036 = g_ruo.ruo011  #TQC-BC0039 mark
             LET g_tlf.tlf036 = g_ruo.ruo01     #TQC-BC0039 add
          END IF
          IF g_flag = '1' AND l_flag = '2' THEN    #撥出確認且入庫
            #LET g_tlf.tlf036 = g_ruo.ruo011  #TQC-BC0039 mark
             LET g_tlf.tlf036 = g_ruo.ruo01     #TQC-BC0039 add
          END IF
       END IF
       IF g_sma.sma143 = '2' THEN   #調撥在途歸屬撥入方
          IF g_flag = '1' AND l_flag = '1' THEN    #撥出確認且出庫
            #LET g_tlf.tlf036 = g_ruo.ruo011  #TQC-BC0039 mark
             LET g_tlf.tlf036 = g_ruo.ruo01       #TQC-BC0039 add
          END IF
          IF g_flag = '1' AND l_flag = '2' THEN    #撥出確認且入庫
             LET g_tlf.tlf036 = g_ruo.ruo01
          END IF
       END IF
    END IF
    IF g_flag = '2' AND g_sma142_chk = "Y" THEN          #走在途且撥入確認
      #LET g_tlf.tlf036 = g_ruo.ruo011  #TQC-BC0039 mark
       LET g_tlf.tlf036 = g_ruo.ruo01        #TQC-BC0039 add
    END IF
#FUN-BA0096 add END
    LET g_tlf.tlf037 = l_rup.rup02     #單據項次
    LET g_tlf.tlf04 = ' '              #工作站                                                                                    
    LET g_tlf.tlf05 = ' '              #作業序號
   #LET g_tlf.tlf06 = g_today          #日期     #FUN-D10106 mark
    LET g_tlf.tlf06 = g_ruo.ruo07      #日期     #FUN-D10106 add
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

#生成拨入营运中心的調撥單,并更新撥出營運中心的對應單號
FUNCTION t256_sub_a() 
   DEFINE   l_sql      STRING
   DEFINE   l_legal    LIKE azw_file.azw02
   DEFINE   l_ruocont  LIKE ruo_file.ruo10t
   DEFINE   l_ruo01    LIKE ruo_file.ruo01    #TQC-AC0382
   DEFINE   li_result  LIKE type_file.num5    #TQC-AC0382
   DEFINE   l_no       LIKE oay_file.oayslip  #TQC-AC0382

   IF g_success = 'N' THEN
      RETURN
   END IF
   #當撥出營運中心和撥入營運中心相同時，不需要再次生成調撥單,只要更新ruo011即可
   IF g_ruo.ruo04 = g_ruo.ruo05 THEN
      #RETURN
      #TQC-AC0382 add--str--更新撥出的對應單號
      LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'ruo_file'),
                  "   SET ruo011 = '",g_ruo.ruo01,"'",
                  " WHERE ruo01 = '",g_ruo.ruo01,"'",
                  "   AND ruoplant = '",g_ruo.ruo04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql
      PREPARE trans_upd1_ruo011 FROM l_sql
      EXECUTE trans_upd1_ruo011
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #TQC-AC0382 add--end--
   ELSE
      #撥出審核時要復制一筆相同的資料到撥入營運中心(ruoplant-->ruo05)
      #復制單頭資料到撥入營運中心
      DELETE FROM ruo_temp
      DELETE FROM rup_temp
      CALL s_getlegal(g_ruo.ruo05) RETURNING l_legal
      LET l_sql = " INSERT INTO ruo_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_ruo.ruo04, 'ruo_file'),
                  "  WHERE ruo01 = '",g_ruo.ruo01,"'", 
                  "    AND ruoplant = '",g_ruo.ruo04,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql 
      PREPARE trans_ins_ruotemp FROM l_sql
      EXECUTE trans_ins_ruotemp
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','INSERT INTO ruo_temp:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF 
      
   #TQC-AC0382--add--str--
   #撥入營運中心單號重新生成
      #FUN-C90050 mark begin---
      #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo.ruo05,'rye_file'),
      #            " WHERE rye01 = 'art' AND rye02 = 'J1'" 
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #CALL cl_parse_qry_sql(l_sql,g_ruo.ruo05) RETURNING l_sql
      #PREPARE pre_sel_rye1 FROM l_sql
      #EXECUTE pre_sel_rye1 INTO l_no
      #FUN-C90050 mark end------

      CALL s_get_defslip('art','J1',g_ruo.ruo05,'N') RETURNING l_no      #FUN-C90050 add

      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01,ruoplant",g_ruo.ruo05,"","")
      RETURNING li_result,l_ruo01
      IF (NOT li_result) THEN
         LET g_success="N"
         CALL s_errmsg('','','','asf-377',1)
         RETURN
      END IF
   #TQC-AC0382--add--end--
   
      IF g_sma142_chk = "N" THEN    #非在途
         UPDATE ruo_temp SET ruo01 = l_ruo01,        #TQC-AC0382
                             ruo011 = g_ruo.ruo01,    #TQC-AC0382
                             ruoplant = g_ruo.ruo05,
                             ruolegal = l_legal
      ELSE
         UPDATE ruo_temp SET ruo01 = l_ruo01,        #TQC-AC0382
                             ruo011 = g_ruo.ruo01,    #TQC-AC0382
                             ruoplant = g_ruo.ruo05,
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
      LET l_sql = " INSERT INTO rup_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_ruo.ruo04, 'rup_file'),
                  "  WHERE rup01 = '",g_ruo.ruo01,"'", 
                  "    AND rupplant = '",g_ruo.ruo04,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql 
      PREPARE trans_ins_ruptemp FROM l_sql
      EXECUTE trans_ins_ruptemp
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','INSERT INTO rup_temp:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF 
      
      IF g_sma142_chk = "N" THEN    #非在途
         UPDATE rup_temp SET rup01 = l_ruo01,     #TQC-AC0382
                             rupplant = g_ruo.ruo05,
                             ruplegal = l_legal,
                             rup18 = 'Y'
      ELSE
         UPDATE rup_temp SET rup01 = l_ruo01,     #TQC-AC0382
                             rupplant = g_ruo.ruo05,
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
   #TQC-AC0382 add--str--更新撥出的對應單號
      LET g_ruo.ruo011 = l_ruo01
      LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'ruo_file'),
                  "   SET ruo011 = '",l_ruo01,"'",
                  " WHERE ruo01 = '",g_ruo.ruo01,"'",
                  "   AND ruoplant = '",g_ruo.ruo04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql
      PREPARE trans_upd_ruo011 FROM l_sql
      EXECUTE trans_upd_ruo011
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_sma142_chk = "N" THEN    #非在途時單身撥出撥入相同結案
         LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'rup_file'),
                     "   SET rup18 = 'Y'",
                     " WHERE rup01 = '",g_ruo.ruo01,"'",
                     "   AND rupplant = '",g_ruo.ruo04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql
         PREPARE trans_upd_rup18 FROM l_sql
         EXECUTE trans_upd_rup18
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('','','UPDATE rup_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
        #TQC-C20352--add--begin--  
         IF s_industry("slk") THEN
            LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'rupslk_file'),
                        "   SET rupslk18 = 'Y'",
                        " WHERE rupslk01 = '",g_ruo.ruo01,"'",
                        "   AND rupslkplant = '",g_ruo.ruo04,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql
            PREPARE trans_upd_rupslk18 FROM l_sql
            EXECUTE trans_upd_rupslk18
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('','','UPDATE rupslk_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF 
        #TQC-C20352--add--end--   
      END IF
   #TQC-AC0382 add--end--
   END IF	

   #DROP TABLE ruo_temp
   #DROP TABLE rup_temp
END FUNCTION 

#撥入審核時更改調撥單的狀態為撥入審核
FUNCTION t256_sub_ruo_upd(p_conf,p_plant,p_ruocont,p_flag)
   DEFINE   p_conf     LIKE ruo_file.ruoconf 
   DEFINE   l_sql1     STRING
   DEFINE   l_sql      STRING               #TQC-AC0382
   DEFINE   p_ruocont  LIKE ruo_file.ruo10t
   DEFINE   l_ruocont  LIKE ruo_file.ruo10t #審核時間
   DEFINE   p_plant    LIKE azp_file.azp01
   DEFINE   p_flag     LIKE type_file.chr1
   DEFINE   l_ruo15    LIKE ruo_file.ruo15  #TQC-AC0382
   DEFINE   l_ruo01    LIKE ruo_file.ruo01  #TQC-AC0382
   DEFINE   l_conf     LIKE ruo_file.ruoconf #TQC-B70026

   IF g_success = 'N' THEN
      RETURN
   END IF
   
#TQC-AC0382 --add--str--
   IF (p_plant = g_ruo.ruo04 AND g_flag = '1') OR (p_plant = g_ruo.ruo05 AND g_flag = '2')THEN
      LET l_ruo01 = g_ruo.ruo01
   ELSE
      LET l_ruo01 = g_ruo.ruo011
   END IF
#TQC-AC0382 --add--end--

   IF cl_null(p_ruocont) THEN
      LET l_ruocont = TIME 
   ELSE
      LET l_ruocont = p_ruocont
   END IF
   IF p_conf = '1' THEN
      #TQC-AC0382 --add--str--
      IF p_plant = g_ruo.ruo04 THEN
         LET l_ruo15 = 'Y'
      ELSE
         LET l_ruo15 = 'N'
      END IF
      #TQC-AC0382 --add--end--
      LET l_sql1 = "UPDATE ",cl_get_target_table(p_plant, 'ruo_file'),
                  "   SET ruoconf = '1' , ",               
                  "       ruo10 = '",g_today,"',", 
                  "       ruo11 = '",g_user,"',",
                  "       ruo10t = '",l_ruocont,"',",
                  "       ruo15 = '",l_ruo15,"',",
                  "       ruo99 = '",g_ruo.ruo99,"'",      
                 # " WHERE ruo01 = '",g_ruo.ruo01,"'",
                  " WHERE ruo01 = '",l_ruo01,"'",     #TQC-AC0382
                  "   AND ruoplant = '",p_plant,"'"
   ELSE
      IF p_conf = '3' THEN
         LET l_sql1 = "UPDATE ",cl_get_target_table(p_plant, 'ruo_file'),
                     "   SET ruoconf = '3' , ",
                     "       ruo10 = '",g_today,"',",     #MOD-BC0245 mark   #TQC-C90064 remark
                     "       ruo11 = '",g_user,"',",      #MOD-BC0245 mark   #TQC-C90064 remark 
                     "       ruo10t = '",l_ruocont,"',",  #MOD-BC0245 mark   #TQC-C90064 remark
                     "       ruo12 = '",g_today,"',",
                     "       ruo13 = '",g_user,"',",
                     "       ruo12t = '",l_ruocont,"',",
                     "       ruo15 = 'Y',",
                     "       ruo99 = '",g_ruo.ruo99,"'",  
                    # " WHERE ruo01 = '",g_ruo.ruo01,"'",
                     " WHERE ruo01 = '",l_ruo01,"'",      #TQC-AC0382
                     "   AND ruoplant = '",p_plant,"'"
      ELSE
      # TQC-B70026 BEGIN
        IF p_conf = '4' THEN
           LET l_conf = '3'
        ELSE
           LET l_conf = p_conf
        END IF
      # TQC-B70026 END
         LET l_sql1 = "UPDATE ",cl_get_target_table(p_plant, 'ruo_file'),
                   # "   SET ruoconf = '",p_conf,"',",   # TQC-B70026 
                     "   SET ruoconf = '",l_conf,"',",   # TQC-B70026
                     "       ruo12 = '",g_today,"',",
                     "       ruo13 = '",g_user,"',",
                     "       ruo12t = '",l_ruocont,"',",
                     "       ruo15 = 'Y',",
                     "       ruo99 = '",g_ruo.ruo99,"'",  
                     #" WHERE ruo01 = '",g_ruo.ruo01,"'",
                     " WHERE ruo01 = '",l_ruo01,"'",      #TQC-AC0382
                     "   AND ruoplant = '",p_plant,"'"
      END IF
   END IF
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
   PREPARE trans_upd_ruo1 FROM l_sql1
   EXECUTE trans_upd_ruo1 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('','','UPDATE ruo_file:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF   
   #撥出與撥入營運中心不同時，更新撥入營運中心狀態
   IF p_plant <> g_ruo.ruo05 AND g_ruo.ruo04 <> g_ruo.ruo05 AND p_flag <> '2' THEN
      CALL t256_sub_ruo_upd(p_conf,g_ruo.ruo05,l_ruocont,'2')
   END IF
   IF p_plant <> g_ruo.ruo04 AND g_ruo.ruo04 <> g_ruo.ruo05 AND p_flag <> '2'THEN
      CALL t256_sub_ruo_upd(p_conf,g_ruo.ruo04,l_ruocont,'2')
   END IF
END FUNCTION

#由當撥出數量與撥入數量的關係判斷結案狀態
FUNCTION t256_sub_rup_upd()
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_rup02    LIKE rup_file.rup02
   DEFINE l_rup12    LIKE rup_file.rup12
   DEFINE l_rup16    LIKE rup_file.rup16
   DEFINE l_sql      STRING
   DEFINE l_sql1     STRING
   DEFINE l_sql2     STRING

   #LET l_flag = '3'           #TQC-B70026
    LET l_flag = '4'           #TQC-B70026
   #檢查撥入數量是否等於撥出數量
   LET l_sql = "SELECT rup02,rup12,rup16 FROM ",cl_get_target_table(g_ruo.ruo05, 'rup_file'),
               " WHERE rup01 = '",g_ruo.ruo01,"'",
               "   AND rupplant = '",g_ruo.ruo05,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruo05) RETURNING l_sql
   PREPARE tra_rupx FROM l_sql
   DECLARE tra_csx CURSOR FOR tra_rupx
   FOREACH tra_csx INTO l_rup02,l_rup12,l_rup16
     #IF l_rup12 = l_rup16 THEN  #FUN-CA0086
      IF l_rup12 <= l_rup16 THEN #FUN-CA0086
         LET l_sql1 = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'rup_file'),
                      "   SET rup18 = 'Y' ",                     
                      " WHERE rup01 = '",g_ruo.ruo011,"'",
                      "   AND rup02 = '",l_rup02,"'",
                      "   AND rupplant = '",g_ruo.ruo04,"'"
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         CALL cl_parse_qry_sql(l_sql1,g_ruo.ruo04) RETURNING l_sql1
         PREPARE trans_upd_rup1 FROM l_sql1
         EXECUTE trans_upd_rup1 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('','','UPDATE rup_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF   
         LET l_sql2 = "UPDATE ",cl_get_target_table(g_ruo.ruo05, 'rup_file'),
                      "   SET rup18 = 'Y' ",                     
                      " WHERE rup01 = '",g_ruo.ruo01,"'",
                      "   AND rup02 = '",l_rup02,"'",
                      "   AND rupplant = '",g_ruo.ruo05,"'"         
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         CALL cl_parse_qry_sql(l_sql2,g_ruo.ruo05) RETURNING l_sql2
         PREPARE trans_upd_rup2 FROM l_sql2
         EXECUTE trans_upd_rup2 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('','','UPDATE rup_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF                

      ELSE
         LET l_flag = '2'
      END IF 
   END FOREACH
   RETURN l_flag
END FUNCTION

#TQC-C20352--add--begin--
#由當撥出數量與撥入數量的關係判斷結案狀態
FUNCTION t256_sub_rupslk_upd()
   DEFINE l_rupslk02    LIKE rup_file.rup02
   DEFINE l_rupslk12    LIKE rup_file.rup12
   DEFINE l_rupslk16    LIKE rup_file.rup16
   DEFINE l_sql         STRING
   DEFINE l_sql1        STRING
   DEFINE l_sql2        STRING

   #檢查撥入數量是否等於撥出數量
   LET l_sql = "SELECT rupslk02,rupslk12,rupslk16 FROM ",cl_get_target_table(g_ruo.ruo05, 'rupslk_file'),
               " WHERE rupslk01 = '",g_ruo.ruo01,"'",
               "   AND rupslkplant = '",g_ruo.ruo05,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql,g_ruo.ruo05) RETURNING l_sql
   PREPARE tra_rupslkx FROM l_sql
   DECLARE tra_csslkx CURSOR FOR tra_rupslkx
   FOREACH tra_csslkx INTO l_rupslk02,l_rupslk12,l_rupslk16
      IF l_rupslk12 = l_rupslk16 THEN
         LET l_sql1 = "UPDATE ",cl_get_target_table(g_ruo.ruo04, 'rupslk_file'),
                      "   SET rupslk18 = 'Y' ",
                      " WHERE rupslk01 = '",g_ruo.ruo011,"'",
                      "   AND rupslk02 = '",l_rupslk02,"'",
                      "   AND rupslkplant = '",g_ruo.ruo04,"'"
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         CALL cl_parse_qry_sql(l_sql1,g_ruo.ruo04) RETURNING l_sql1
         PREPARE trans_upd_rupslk1 FROM l_sql1
         EXECUTE trans_upd_rupslk1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('','','UPDATE rupslk_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         LET l_sql2 = "UPDATE ",cl_get_target_table(g_ruo.ruo05, 'rupslk_file'),
                      "   SET rupslk18 = 'Y' ",
                      " WHERE rupslk01 = '",g_ruo.ruo01,"'",
                      "   AND rupslk02 = '",l_rupslk02,"'",
                      "   AND rupslkplant = '",g_ruo.ruo05,"'"
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         CALL cl_parse_qry_sql(l_sql2,g_ruo.ruo05) RETURNING l_sql2
         PREPARE trans_upd_rupslk2 FROM l_sql2
         EXECUTE trans_upd_rupslk2
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('','','UPDATE rupslk_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION
#TQC-C20352--add--end---

FUNCTION t256_sub_wback() #倉退多角貿易
    DEFINE l_sql      STRING 
    DEFINE i,l_i      LIKE type_file.num5    
    DEFINE li_result  LIKE type_file.num5 
    DEFINE l_plant    LIKE azp_file.azp01  
    DEFINE l_legal    LIKE azw_file.azw02 
    DEFINE l_no       LIKE oay_file.oayslip  
    DEFINE l_cnt      LIKE type_file.num5
    DEFINE l_rvu      RECORD LIKE rvu_file.*
    DEFINE l_rvv      RECORD LIKE rvv_file.*
    DEFINE l_rvb      RECORD LIKE rvb_file.*
    DEFINE l_rup12    LIKE rup_file.rup12
    DEFINE l_rup04    LIKE rup_file.rup04    
    DEFINE l_plant_1  LIKE azw_file.azw01      #TQC-C90058   
    DEFINE l_ruo01    LIKE ruo_file.ruo01      #FUN-CA0086

    IF g_success = 'N' THEN
       RETURN
    END IF
 
    LET l_plant = g_ruo.ruo04  
#TQC-C90058 add begin ---
    SELECT azw07 INTO l_plant_1 FROM azw_file 
     WHERE azw01 = g_ruo.ruo05
       AND azw07 = g_ruo.ruo04
    IF cl_null(l_plant_1)THEN
       SELECT azw07 INTO l_plant_1 FROM azw_file
        WHERE azw01 = g_ruo.ruo04
       IF cl_null(l_plant_1)THEN
          LET l_plant_1 = g_ruo.ruo04
       END IF
    END IF 
#TQC-C90058 add end -----
    CALL s_getlegal(l_plant) RETURNING l_legal  
 
    #新增單頭檔(rvu_file)
    LET l_rvu.rvu00 = '3'                #異動別(倉退)
    #FUN-C90050 mark begin---
    #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant,'rye_file'),
    #            " WHERE rye01 = 'apm' AND rye02 = '4'" 
    #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
    #PREPARE pre_sel_rye03 FROM l_sql
    #EXECUTE pre_sel_rye03 INTO l_no
    #FUN-C90050 mark end----

    CALL s_get_defslip('apm','4',l_plant,'N') RETURNING l_no     #FUN-C90050 add

    CALL s_auto_assign_no('apm',l_no,g_today,"4","rvu_file","rvu01",l_plant,"","")
    RETURNING li_result,l_rvu.rvu01
    IF (NOT li_result) THEN 
       LET g_msg = l_plant CLIPPED,l_rvu.rvu01
       CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
       LET g_success ='N'
       RETURN
    END IF  

   #FUN-CA0086 Begin---
    IF g_ruo.ruo02 = '7' THEN
       IF cl_null(g_ruo.ruo03) THEN
          CALL t256_sub_wback1()   #无来源调拨单的仓退
          RETURN
       END IF

       LET l_sql = "SELECT ruo99 FROM ",cl_get_target_table(g_ruo.ruo04,'ruo_file'),
                   " WHERE ruo01 = '",g_ruo.ruo03,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE ruo99_p FROM l_sql
       EXECUTE ruo99_p INTO g_ruo.ruo99
    END IF
   #FUN-CA0086 End-----

    #根據多角貿易流程序號找收貨單號，廠商編號
    LET l_sql = "SELECT rva01,rva05 ",
                " FROM ",cl_get_target_table(l_plant,'rva_file'), 
                " WHERE rva99 = '",g_ruo.ruo99,"' " 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE rva_p1 FROM l_sql
    EXECUTE rva_p1 INTO l_rvu.rvu02,l_rvu.rvu04
    IF SQLCA.SQLCODE THEN
       LET g_success='N'
       RETURN
    END IF       
              
    LET l_rvu.rvu03 = g_today         #異動日期  
    SELECT pmc03 INTO l_rvu.rvu05     #廠商簡稱
      FROM pmc_file
     WHERE pmc01 = l_rvu.rvu04 
    LET l_rvu.rvu06 = g_grup          #採購部門		
    LET l_rvu.rvu07 = g_user          #人員
    LET l_rvu.rvu08 = 'TAP'           #採購性質
    LET l_rvu.rvu09 = g_today 
    LET l_rvu.rvu10 = 'Y'													
    LET l_rvu.rvu20 = 'N'             #已拋轉
    #LET l_rvu.rvu99 = g_ruo.ruo99        
    LET l_rvu.rvuconf= 'Y'
    LET l_rvu.rvuacti= 'Y'
    LET l_rvu.rvuuser= g_user
    LET l_rvu.rvugrup= g_grup
    LET l_rvu.rvuoriu= g_user       
    LET l_rvu.rvuorig= g_grup       
    LET l_rvu.rvumodu= null
    LET l_rvu.rvudate= null
    LET l_rvu.rvu27  = '1'    #TQC-B60065
    
    #新增倉退單頭    
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rvu_file'), 
      "(rvu00 ,rvu01 ,rvu02 ,rvu03 ,rvu04 ,rvu05 ,rvu06 ,rvu07 ,",
      " rvu08 ,rvu09 ,rvu10 ,rvu20 ,rvuconf,rvuacti,rvuuser,",
      " rvugrup,rvumodu,rvudate,rvuplant,rvulegal,rvuoriu,rvuorig,rvu27)", #TQC-B60065
     #" rvugrup,rvumodu,rvudate,rvuplant,rvulegal,rvuoriu,rvuorig)",       #TQC-B60065
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?,?,  ?,?,?)"                                        #TQC-B60065 Add ?
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
     PREPARE ins_rvu FROM l_sql
     EXECUTE ins_rvu USING 
         l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
         l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
         l_rvu.rvu10,l_rvu.rvu20,l_rvu.rvuconf,l_rvu.rvuacti,
         l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,
         l_plant,l_legal,l_rvu.rvuoriu,l_rvu.rvuorig,l_rvu.rvu27           #TQC-B60065
    IF SQLCA.sqlcode<>0 THEN
       CALL s_errmsg("","","ins rvu:",SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF

   #新增單身檔(rvv_file) 
    LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'rvb_file'),
                " WHERE rvb01 = '",l_rvu.rvu02,"' " 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE rvb_p1 FROM l_sql
    DECLARE cur_rvb CURSOR FOR rvb_p1
    LET l_cnt = 1
    FOREACH cur_rvb INTO l_rvb.*  
       LET l_sql = "SELECT rvr02 FROM ",cl_get_target_table(l_plant,'rvr_file'),
                   " WHERE rvr01 = '",g_ruo.ruo03,"'",
                   "   AND rvr03 = '",l_rvb.rvb02,"'"
       PREPARE sel_rvr_pre FROM l_sql
       EXECUTE sel_rvr_pre INTO l_i

                   
       #收貨單中的料件存在于調撥單中，做倉退
       LET l_sql = "SELECT rup04,rup12 FROM ",cl_get_target_table(l_plant,'rup_file'), 
                   " WHERE rup01 = '",g_ruo.ruo01,"'",
                   "   AND rupplant = '",l_plant,"'",
                   "   AND rup03 = '",l_rvb.rvb05,"'"
      #FUN-CA0086 Begin---
      #           #TQC-C90058 add begin ---
      #           ,"   AND rup17 = (SELECT rvr02 FROM ",cl_get_target_table(l_plant_1,'rvr_file'),
      #            "                 WHERE rvr01 = '",g_ruo.ruo03,"'",
      #            "                   AND rvr03 = '",l_rvb.rvb02,"')"
      #           #TQC-C90058 add end ---
       IF g_ruo.ruo02 = '7' THEN
          IF g_ruo.ruo04 = g_plant THEN
             LET l_ruo01 = g_ruo.ruo01
          ELSE
             LET l_ruo01 = g_ruo.ruo011
          END IF
          LET l_sql =
                   "SELECT rup04,rup12 FROM ",cl_get_target_table(l_plant,'rup_file'),
                   " WHERE rup01 = '",l_ruo01,"'",
                   "   AND rupplant = '",l_plant,"'",
                   "   AND rup03 = '",l_rvb.rvb05,"'",
                   "   AND rup17 = (SELECT rup02 FROM ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                   "                 WHERE rup01 = '",g_ruo.ruo03,"'",
                   "                   AND rup02 = '",l_rvb.rvb02,"')"
       ELSE
          LET l_sql = l_sql CLIPPED,
                   "   AND rup17 = (SELECT rvr02 FROM ",cl_get_target_table(l_plant_1,'rvr_file'),
                   "                 WHERE rvr01 = '",g_ruo.ruo03,"'",
                   "                   AND rvr03 = '",l_rvb.rvb02,"')"
       END IF
      #FUN-CA0086 End-----
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #TQC-C90058 mark
      #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql     #TQC-C90058 mark
       PREPARE sel_rup12 FROM l_sql
       EXECUTE sel_rup12 INTO l_rup04,l_rup12
       IF SQLCA.SQLCODE = '100' THEN
          CONTINUE FOREACH
       END IF
       LET l_rvv.rvv01 = l_rvu.rvu01
       LET l_rvv.rvv02 = l_cnt
       LET l_rvv.rvv03 = '3'
       LET l_rvv.rvv04 = l_rvu.rvu02
      #LET l_rvv.rvv05 = l_rvu.rvu04 #TQC-C90058 Mark
       LET l_rvv.rvv05 = l_rvb.rvb02 #TQC-C90058 Add
       LET l_rvv.rvv09 = g_today
       LET l_rvv.rvv17 = l_rup12
       LET l_rvv.rvv24 = l_rvb.rvb21
       LET l_rvv.rvv25 = l_rvb.rvb35
       LET l_rvv.rvv31 = l_rvb.rvb05
       LET l_rvv.rvv32 = l_rvb.rvb36
       LET l_rvv.rvv33 = l_rvb.rvb37
       LET l_rvv.rvv34 = l_rvb.rvb38
       LET l_rvv.rvv35 = l_rup04
       LET l_rvv.rvv35_fac = 1
       LET l_rvv.rvv36 = l_rvb.rvb04
       LET l_rvv.rvv37 = l_rvb.rvb03 
       LET l_rvv.rvv38 = l_rvb.rvb10 
       LET l_rvv.rvv80 = l_rvb.rvb80 
       LET l_rvv.rvv81 = l_rvb.rvb81 
       LET l_rvv.rvv82 = l_rvb.rvb82 
       LET l_rvv.rvv83 = l_rvb.rvb83 
       LET l_rvv.rvv84 = l_rvb.rvb84 
       LET l_rvv.rvv85 = l_rvb.rvb85 
       LET l_rvv.rvv80 = l_rvb.rvb80 
       LET l_rvv.rvv86 = l_rvb.rvb86
       LET l_rvv.rvv87 = l_rvb.rvb87
       LET l_rvv.rvv39t = l_rvb.rvb88t
       LET l_rvv.rvv38t = l_rvb.rvb10t 
       LET l_rvv.rvv930 = l_rvb.rvb930       
       #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
       LET l_rvv.rvv22 = l_rvb.rvb22          #FUN-BB0001 add       
       LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rvv_file'),  
       "(rvv01,rvv02,rvv03,rvv04,rvv05,rvv06,rvv09,rvv17,rvv18,rvv23, ",
       " rvv24,rvv25,rvv26,rvv31,rvv031,rvv32,rvv33,rvv34,rvv35,rvv35_fac, ",
       " rvv36,rvv37,rvv38,rvv39,rvv40,rvv41,rvv42,rvv43,rvv80,rvv81,rvv82, ",
       " rvv83,rvv84,rvv85,rvv86,rvv87,rvv38t,rvv39t,rvv88,rvv930,rvv89,rvvplant,rvvlegal,",
       " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
       " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,rvv22)",    #FUN-BB0001 add rvv22
       " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
       "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",             
       "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  #FUN-BB0001 add ?\ 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE ins_rvv FROM l_sql
       EXECUTE ins_rvv USING 
       l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv06,l_rvv.rvv09,
       l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,
       l_rvv.rvv031,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
       l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,l_rvv.rvv41,l_rvv.rvv42,
       l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,   
       l_rvv.rvv86,l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv88,l_rvv.rvv930,l_rvv.rvv89,   
       l_plant,l_legal,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,                                                    
       l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
       l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,l_rvv.rvv22   #FUN-BB0001 add l_rvv.rvv22
       IF SQLCA.sqlcode THEN         
          LET g_success="N"
          CALL s_errmsg('','','',SQLCA.sqlcode,1)
          RETURN
       END IF
       LET l_cnt = l_cnt + 1     
    END FOREACH 
    #審核過帳倉退單
    CALL t256_sub_y(l_rvu.rvu01,l_plant)
    #倉退多角
LET g_prog = 'artt256' #FUN-CA0086
    IF g_success = 'Y' THEN
       LET g_from_plant = g_ruo.ruo04     #拋轉資料的來源
       CALL p840(l_rvu.rvu01,l_plant,TRUE)
    END IF
   #FUN-CA0086 Begin---
LET g_prog = 'artt257'
    IF g_success = 'Y' THEN
       LET l_sql = "SELECT rvu99 FROM ",cl_get_target_table(l_plant,'rvu_file'),
                   " WHERE rvu01 = '",l_rvu.rvu01,"'"
       PREPARE sel_rvu99_p FROM l_sql
       EXECUTE sel_rvu99_p INTO g_ruo.ruo99
       UPDATE ruo_file SET ruo99 = g_ruo.ruo99 WHERE ruo01 = g_ruo.ruo01
       IF SQLCA.sqlcode THEN
          LET g_success="N"
          CALL s_errmsg('','','upd ruo99',SQLCA.sqlcode,1)
          RETURN
       END IF
    END IF
   #FUN-CA0086 End-----
END FUNCTION

#FUN-CA0086 Begin---
#目前只支持两角，不支持两角以上，直接产生多角仓退单和销退单
FUNCTION t256_sub_wback1()
 DEFINE li_result  LIKE type_file.num5
 DEFINE l_plant    LIKE azp_file.azp01
 DEFINE l_legal    LIKE azw_file.azw02
 DEFINE l_no       LIKE oay_file.oayslip
 DEFINE l_cnt      LIKE type_file.num5      #项次
 DEFINE l_sw       LIKE type_file.num5
 DEFINE l_rup      RECORD LIKE rup_file.*
 DEFINE l_rvu      RECORD LIKE rvu_file.*
 DEFINE l_rvv      RECORD LIKE rvv_file.*
 DEFINE l_pmc      RECORD LIKE pmc_file.*
 DEFINE l_poy      RECORD LIKE poy_file.*
 DEFINE l_poy03    LIKE poy_file.poy03
 DEFINE l_ima02    LIKE ima_file.ima02
 DEFINE l_ima15    LIKE ima_file.ima15
 DEFINE l_ima25    LIKE ima_file.ima25
 DEFINE l_ima908   LIKE ima_file.ima908
 DEFINE l_imd20    LIKE imd_file.imd20
 DEFINE l_price    LIKE rvv_file.rvv38
 DEFINE l_success  LIKE type_file.chr1
 DEFINE l_fac      LIKE rvv_file.rvv35_fac
 DEFINE l_unit     LIKE rvv_file.rvv35
 
   LET l_plant = g_ruo.ruo04
   CALL s_getlegal(l_plant) RETURNING l_legal
   
   #新增單頭檔(rvu_file)
   LET l_rvu.rvu00 = '3'                #異動別(倉退)
   #FUN-C90050 mark begin-----
   #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant,'rye_file'),
   #            " WHERE rye01 = 'apm' AND rye02 = '4'" 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   #PREPARE t256_sub_wback1_sel_rye03 FROM g_sql
   #EXECUTE t256_sub_wback1_sel_rye03 INTO l_no
   #FUN-C90050 mark end-----

   CALL s_get_defslip('apm','4',l_plant,'N') RETURNING l_no   #FUN-C90050 add

   CALL s_auto_assign_no('apm',l_no,g_today,"4","rvu_file","rvu01",l_plant,"","")
   RETURNING li_result,l_rvu.rvu01
   IF (NOT li_result) THEN 
      LET g_msg = l_plant CLIPPED,l_rvu.rvu01
      CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
      LET g_success ='N'
      RETURN
   END IF

   LET g_sql = "SELECT poy_file.* FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),",",
                                         cl_get_target_table(g_ruo.ruo05, 'poz_file'),
               " WHERE poy01 = poz01 ",
               "   AND poy01 = '",g_ruo.ruo904,"'",
               "   AND poy02 = (SELECT MIN(poy02) FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_sub_wback1_sel_poy1 FROM g_sql
   EXECUTE t256_sub_wback1_sel_poy1 INTO l_poy.*
   
   LET g_sql = "SELECT poy03 FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),",",
                                    cl_get_target_table(g_ruo.ruo05, 'poz_file'),
               " WHERE poz01 = '",g_ruo.ruo904,"'",
               "   AND poz01 = poy01",
               "   AND poy02 = (SELECT MIN(poy02) + 1 FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_sub_wback1_sel_poy2 FROM g_sql
   EXECUTE t256_sub_wback1_sel_poy2 INTO l_poy03
    
   IF g_azw.azw04 = '2' THEN
     #CALL t256_art(l_poy.*,l_poy03,g_ruo.ruo05) RETURNING l_poy.*
      CALL t256_art(l_poy.*,l_poy03,g_ruo.ruo05) RETURNING l_poy.* #取供應商資料
   END IF   

   #撥入營運中心設定的供應商資料   
  #LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo05,'pmc_file'),  
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo05,'pmc_file'),  
               " WHERE pmc01 = '",l_poy03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
   PREPARE t256_sub_wback1_pmc_p1 FROM g_sql
   EXECUTE t256_sub_wback1_pmc_p1 INTO l_pmc.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',l_poy03,'SELECT pmc',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   LET l_rvu.rvu02 = ''              #收货单号
   LET l_rvu.rvu03 = g_today         #異動日期  
   LET l_rvu.rvu04 = l_poy03         #供应商
  #SELECT pmc03 INTO l_rvu.rvu05     #廠商簡稱
  #  FROM pmc_file
  # WHERE pmc01 = l_rvu.rvu04
   LET l_rvu.rvu05 = l_pmc.pmc03     #廠商簡稱
   LET l_rvu.rvu06 = g_grup          #採購部門		
   LET l_rvu.rvu07 = g_user          #人員
   LET l_rvu.rvu08 = 'TAP'           #採購性質
   LET l_rvu.rvu09 = g_today         #取回日期
   LET l_rvu.rvu10 = 'Y'             #开立折让单否					
   LET l_rvu.rvu20 = 'N'             #已拋轉
   LET l_rvu.rvu24 = g_ruo.ruo904    #多角流程编号
   #LET l_rvu.rvu99 = g_ruo.ruo99    #   
   LET l_rvu.rvuconf= 'Y'            #确认码
   LET l_rvu.rvuacti= 'Y'            #资料有效码
   LET l_rvu.rvuuser= g_user         #资料所有者
   LET l_rvu.rvugrup= g_grup         #资料所有部门
   LET l_rvu.rvuoriu= g_user         #资料建立者
   LET l_rvu.rvuorig= g_grup         #资料建立部门
   LET l_rvu.rvumodu= null           #资料修改者
   LET l_rvu.rvudate= null           #最近修改日
   LET l_rvu.rvucrat= g_today        #最近修改日
   LET l_rvu.rvu27  = '1'            #虚拟类型
   LET l_rvu.rvu111 = l_poy.poy06    #付款方式
   LET l_rvu.rvu115 = l_poy.poy09    #稅別
   LET l_rvu.rvu113 = l_poy.poy05    #幣別
   LET l_rvu.rvu112 = l_pmc.pmc49    #價格條件
   CALL s_currm(l_rvu.rvu113,l_rvu.rvu03,'B',l_plant)      #匯率
        RETURNING l_rvu.rvu114
   IF cl_null(l_rvu.rvu114) THEN LET l_rvu.rvu114 = 1 END IF
   LET g_sql = "SELECT gec04 FROM ",cl_get_target_table(l_plant,'gec_file'),  #稅率
               " WHERE gec01 = '",l_rvu.rvu113,"'",
               "   AND gec011= '1' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE t256_sub_wback1_gec_p1 FROM g_sql
   EXECUTE t256_sub_wback1_gec_p1 INTO l_rvu.rvu12
   IF cl_null(l_rvu.rvu12) THEN LET l_rvu.rvu12 = 0 END IF
   LET l_rvu.rvumksg = 'N'
   
   #新增倉退單頭    
   LET g_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rvu_file'), 
     "(rvu00 ,rvu01 ,rvu02 ,rvu03 ,rvu04 ,rvu05 ,rvu06 ,rvu07 ,",
     " rvu08 ,rvu09 ,rvu10 ,rvu20 ,rvu24 ,rvuconf,rvuacti,rvuuser,",
     " rvugrup,rvumodu,rvudate,rvuplant,rvulegal,rvuoriu,rvuorig,rvucrat,rvumksg,",
     " rvu111,rvu112,rvu113,rvu114,rvu115,rvu12,rvu27)",
     " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
     "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?)"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql 
    PREPARE t256_sub_wback1_ins_rvu FROM g_sql
    EXECUTE t256_sub_wback1_ins_rvu USING 
        l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
        l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
        l_rvu.rvu10,l_rvu.rvu20,l_rvu.rvu24,l_rvu.rvuconf,l_rvu.rvuacti,
        l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,
        l_plant,l_legal,l_rvu.rvuoriu,l_rvu.rvuorig,l_rvu.rvucrat,l_rvu.rvumksg,
        l_rvu.rvu111,l_rvu.rvu112,l_rvu.rvu113,l_rvu.rvu114,l_rvu.rvu115,l_rvu.rvu12,l_rvu.rvu27
   IF SQLCA.sqlcode<>0 THEN
      CALL s_errmsg("","","ins rvu:",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   #新增單身檔(rvv_file) 
   IF NOT cl_null(g_ruo.ruo14) THEN
      LET g_sql = "SELECT imd20 FROM ",cl_get_target_table(g_ruo.ruo04, 'imd_file'),
                  " WHERE imd01 = '",g_ruo.ruo14,"'",
                  "   AND imd10 = 'W' "                #TQC-BA0063 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
      PREPARE t256_sub_wback1_pre_imd FROM g_sql
      EXECUTE t256_sub_wback1_pre_imd INTO l_imd20
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','SELECT imd_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
   ELSE
      LET l_imd20 = ''
   END IF

   IF l_imd20 = g_ruo.ruo04 THEN
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                  " WHERE rup01 = '",g_ruo.ruo011,"' "
   ELSE
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                  " WHERE rup01 = '",g_ruo.ruo01,"' " 
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql 
   PREPARE t256_sub_wback1_rup_p1 FROM g_sql
   DECLARE t256_sub_wback1_cur_rup CURSOR FOR t256_sub_wback1_rup_p1
   LET l_cnt = 1
   FOREACH t256_sub_wback1_cur_rup INTO l_rup.*  
      
      
      LET g_sql = " SELECT ima02,ima25,ima908,ima15 ",
                  "   FROM ",cl_get_target_table(l_plant,'ima_file'),
                  "  WHERE ima01 = '",l_rup.rup03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_sub_wback1_ima_p1 FROM g_sql
      EXECUTE t256_sub_wback1_ima_p1 INTO l_ima02,l_ima25,l_ima908,l_ima15
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ima01',l_rup.rup03,'SELECT ima',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_rvv.rvv01 = l_rvu.rvu01       #入库单号/退货单号  
      LET l_rvv.rvv02 = l_cnt             #项次
      LET l_rvv.rvv03 = '3'               #异动类别 (1.入库  2.验退 3.仓退)
      LET l_rvv.rvv04 = ''                #收货单号
      LET l_rvv.rvv05 = ''	              #项次
      LET l_rvv.rvv09 = g_today           #异动日期
      LET l_rvv.rvv17 = l_rup.rup12       #数量
      LET l_rvv.rvv24 = ''                #保税过帐否
      LET l_rvv.rvv25 = 'N'               #样品否
      LET l_rvv.rvv31 = l_rup.rup03       #料件编号
      LET l_rvv.rvv031 = l_ima02          #料件编号
      IF NOT cl_null(l_imd20) AND g_ruo.ruo04 = l_imd20 THEN
         LET l_rvv.rvv32 = g_ruo.ruo14    #仓库
         LET l_rvv.rvv33 = ' '            #存放位置
         LET l_rvv.rvv34 = ' '            #批号/专案代号
      ELSE
         LET l_rvv.rvv32 = l_rup.rup09    #仓库
         LET l_rvv.rvv33 = l_rup.rup10    #存放位置
         LET l_rvv.rvv34 = l_rup.rup11    #批号/专案代号
     	END IF
      LET l_rvv.rvv35 = l_rup.rup07       #单位
      LET l_rvv.rvv35_fac = l_rup.rup08   #转换率
      LET l_rvv.rvv36 = ''                #采购单号
      LET l_rvv.rvv37 = ''                #采购序号
      LET l_rvv.rvv80 = ''                #单位一
      LET l_rvv.rvv81 = ''                #单位一换算率(与采购单位)
      LET l_rvv.rvv82 = ''                #单位一数量
      LET l_rvv.rvv83 = ''                #单位二
      LET l_rvv.rvv84 = ''                #单位二换算率(与采购单位)
      LET l_rvv.rvv85 = ''                #单位二数量
      IF cl_null(l_ima908) THEN LET l_ima908 = l_rvv.rvv35 END IF
      LET l_rvv.rvv86 = l_ima908          #计价单位
       CALL s_umfchkm(l_rvv.rvv31,l_rvv.rvv35,l_rvv.rvv86,l_plant)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_rvv.rvv87 = l_rvv.rvv17*l_fac #计价数量
      LET l_rvv.rvv87 = s_digqty(l_rvv.rvv87,l_rvv.rvv86)
      
      IF g_sma.sma116 <> '0' THEN
         LET l_unit = l_rvv.rvv86
      ELSE
         LET l_unit = l_rvv.rvv35
      END IF
      IF g_azw.azw04='2' THEN
         CALL s_fetch_price3(g_ruo.ruo904,g_ruo.ruo04,l_rvv.rvv31,l_rvv.rvv86,'0',0)
         RETURNING l_success,l_price
      ELSE
         CALL s_fetch_price2(l_rvu.rvu04,l_rvv.rvv31,l_unit,g_ruo.ruo07,'4',l_plant,l_rvu.rvu113)
              RETURNING l_no,l_price,l_success
      END IF
      IF l_success = 'N' THEN
         LET g_showmsg = l_rvu.rvu04,'/',l_rvv.rvv09,'/',l_unit,'/',l_rvu.rvu113,'/',g_ruo.ruo07
         CALL s_errmsg('tqo01,tqn03,tqn04,tqm05,tqn06',g_showmsg,'fetch price','axm-333',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      LET g_sql = " SELECT azi03 FROM ",cl_get_target_table(l_plant,'azi_file'),   #幣別檔
                  "  WHERE azi01 ='",l_rvu.rvu113,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_sub_wback1_azi_p1 FROM g_sql
      EXECUTE t256_sub_wback1_azi_p1 INTO t_azi03
      LET l_rvv.rvv38 = l_price                            #单价
      LET l_rvv.rvv38 = cl_digcut(l_rvv.rvv38,t_azi03)
      LET l_rvv.rvv38t = l_rvv.rvv38*(1+l_rvu.rvu12/100)   #含税单价
      LET l_rvv.rvv39 = l_rvv.rvv38*l_rvv.rvv87            #金额
      LET l_rvv.rvv39t = l_rvv.rvv38t*l_rvv.rvv87          #含税金额
      LET l_rvv.rvv930 = s_costcenter(l_rvu.rvu06)         #成本中心
      #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
     #LET l_rvv.rvv22 = 
      LET l_rvv.rvv89 = 'N'

      LET g_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rvv_file'),  
      "(rvv01,rvv02,rvv03,rvv04,rvv05,rvv06,rvv09,rvv17,rvv18,rvv23, ",
      " rvv24,rvv25,rvv26,rvv31,rvv031,rvv32,rvv33,rvv34,rvv35,rvv35_fac, ",
      " rvv36,rvv37,rvv38,rvv39,rvv40,rvv41,rvv42,rvv43,rvv80,rvv81,rvv82, ",
      " rvv83,rvv84,rvv85,rvv86,rvv87,rvv38t,rvv39t,rvv88,rvv930,rvv89,rvvplant,rvvlegal,",
      " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
      " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,rvv22)",
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",             
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_sub_wback1_ins_rvv FROM g_sql
      EXECUTE t256_sub_wback1_ins_rvv USING 
      l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv06,l_rvv.rvv09,
      l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,
      l_rvv.rvv031,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
      l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,l_rvv.rvv41,l_rvv.rvv42,
      l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,   
      l_rvv.rvv86,l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv88,l_rvv.rvv930,l_rvv.rvv89,   
      l_plant,l_legal,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,                                                    
      l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
      l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,l_rvv.rvv22
      IF SQLCA.sqlcode THEN         
         LET g_success="N"
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET l_cnt = l_cnt + 1     
   END FOREACH 
   #審核過帳倉退單
   CALL t256_sub_y(l_rvu.rvu01,l_plant)
   IF g_success = 'N' THEN RETURN END IF
   
   #多角流程序号
   IF g_success = 'Y' THEN
      CALL s_flowauno('pmm',g_ruo.ruo904,l_rvu.rvu03)
             RETURNING l_sw,g_flow99
      IF l_sw THEN
         CALL s_errmsg("","","","tri-011",1)
         LET g_success = 'N' RETURN
      END IF
      LET g_sql = " UPDATE ",cl_get_target_table(l_plant,'rvu_file'),
                    "    SET rvu99 = '",g_flow99,"'",
                    "  WHERE rvu01 = '",l_rvu.rvu01,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
        PREPARE t256_sub_wback1_upd_rvu_p FROM g_sql
        EXECUTE t256_sub_wback1_upd_rvu_p
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg("rvu01",l_rvu.rvu01,"upd rvu99",SQLCA.sqlcode,1)
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0
        LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'pmm_file'),
                    "  WHERE pmm99 = '",g_flow99,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
        PREPARE t256_sub_wback1_check_pmm99 FROM g_sql
        EXECUTE t256_sub_wback1_check_pmm99 INTO g_cnt
        IF g_cnt > 1 THEN
           CALL s_errmsg("","","","tri-011",1)
           LET g_success = 'N' RETURN
        END IF
   END IF
   
   IF g_success = 'Y' THEN
      CALL t256_ins_oha(l_rvu.rvu01)   #产生拨入营运中心的销退单
   END IF
   
   IF g_success = 'Y' THEN
      LET g_sql = "SELECT rvu99 FROM ",cl_get_target_table(l_plant,'rvu_file'),
                  " WHERE rvu01 = '",l_rvu.rvu01,"'"
      PREPARE t256_sub_wback1_sel_rvu99_p FROM g_sql
      EXECUTE t256_sub_wback1_sel_rvu99_p INTO g_ruo.ruo99
      UPDATE ruo_file SET ruo99 = g_ruo.ruo99 WHERE ruo01 = g_ruo.ruo01
      IF SQLCA.sqlcode THEN
         LET g_success="N"
         CALL s_errmsg('','','upd ruo99',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
   
   
END FUNCTION

FUNCTION t256_ins_oha(p_rvu01)
 DEFINE p_rvu01    LIKE rvu_file.rvu01
 DEFINE li_result  LIKE type_file.num5
 DEFINE l_plant    LIKE azp_file.azp01
 DEFINE l_legal    LIKE azw_file.azw02
 DEFINE l_no       LIKE oay_file.oayslip
 DEFINE l_cnt      LIKE type_file.num5      #项次
 DEFINE l_rup      RECORD LIKE rup_file.*
 DEFINE l_oha      RECORD LIKE oha_file.*
 DEFINE l_ohb      RECORD LIKE ohb_file.*
 DEFINE l_rvu      RECORD LIKE rvu_file.*
 DEFINE l_rvv      RECORD LIKE rvv_file.*
 DEFINE l_pmc      RECORD LIKE pmc_file.*
 DEFINE l_poy      RECORD LIKE poy_file.*
 DEFINE l_occ      RECORD LIKE occ_file.*
 DEFINE l_poy03    LIKE poy_file.poy03
 DEFINE l_price    LIKE ogb_file.ogb13
 DEFINE l_ima02    LIKE ima_file.ima02
 DEFINE l_ima15    LIKE ima_file.ima15
 DEFINE l_ima25    LIKE ima_file.ima25
 DEFINE l_ima29    LIKE ima_file.ima29
 DEFINE l_ima908   LIKE ima_file.ima908
 DEFINE l_imd20    LIKE imd_file.imd20
 DEFINE l_ohbi     RECORD LIKE ohbi_file.*
#DEFINE l_oia07    LIKE oia_file.oia07
 DEFINE l_gec04    LIKE gec_file.gec04
 DEFINE l_gec05    LIKE gec_file.gec05
 DEFINE l_gec07    LIKE gec_file.gec07

   LET l_plant = g_ruo.ruo05
   CALL s_getlegal(l_plant) RETURNING l_legal

   LET g_sql = "SELECT poy_file.* FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),",",
                                         cl_get_target_table(g_ruo.ruo05, 'poz_file'),
               " WHERE poy01 = poz01 ",
               "   AND poy01 = '",g_ruo.ruo904,"'",
               "   AND poy02 = (SELECT MAX(poy02) FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_ins_oha_sel_poy1 FROM g_sql
   EXECUTE t256_ins_oha_sel_poy1 INTO l_poy.*
   
   LET g_sql = "SELECT poy03 FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),",",
                                    cl_get_target_table(g_ruo.ruo05, 'poz_file'),
               " WHERE poz01 = '",g_ruo.ruo904,"'",
               "   AND poz01 = poy01",
               "   AND poy02 = (SELECT MIN(poy02) FROM ",cl_get_target_table(g_ruo.ruo05, 'poy_file'),
               " WHERE poy01 = '",g_ruo.ruo904,"')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_ins_oha_sel_poy2 FROM g_sql
   EXECUTE t256_ins_oha_sel_poy2 INTO l_poy03
   
   
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant, 'occ_file'),
               " WHERE occ01 = '",l_poy03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE t256_ins_oha_sel_occ FROM g_sql
   EXECUTE t256_ins_oha_sel_occ INTO l_occ.*

   #新增銷退單單頭檔(oha_file)
   CALL s_auto_assign_no('axm',l_poy.poy41,g_today,"","","",l_plant,"","")
     RETURNING li_result,l_oha.oha01
   IF (NOT li_result) THEN 
      LET g_msg = l_plant CLIPPED,l_oha.oha01
      CALL s_errmsg("oha01",l_oha.oha01,g_msg CLIPPED,"mfg3046",1) 
      LET g_success ='N'
      RETURN
   END IF
   
   LET l_oha.oha16 = ''
 
  #LET l_oha.oha02 = g_today                  #销退日期      #FUN-D10106 mark
   LET l_oha.oha02 = g_ruo.ruo07              #销退日期      #FUN-D10106 add
   LET l_oha.oha03 = l_poy03                  #帐款客户编号
   LET l_oha.oha032= l_occ.occ02              #帐款客户简称
   LET l_oha.oha04 = l_poy03                  #退货客户编号
   LET l_oha.oha05 = '3'                      #單據別(代採銷退)
   LET l_oha.oha08 = '1'                      #1.内销 2.外销 3.视同外销
   LET l_oha.oha09 = '1'                      #销退处理方式
   LET l_oha.oha10 = null                     #帐单编号
   LET l_oha.oha14 = l_occ.occ04              #人员编号
  #LET l_oha.oha15 = g_grup                   #部门编号
   IF cl_null(l_oha.oha14) THEN LET l_oha.oha14 = g_user END IF
   IF NOT cl_null(l_oha.oha14) THEN
      LET g_sql = "SELECT gen03 ",
                  " FROM ",cl_get_target_table(l_plant,'gen_file'),
                  " WHERE gen01 ='",l_oha.oha14,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_ins_oha_gen_p FROM g_sql
      EXECUTE t256_ins_oha_gen_p INTO l_oha.oha15
      IF cl_null(l_oha.oha15) THEN LET l_oha.oha15='' END IF
   END IF
   LET l_oha.oha21 = l_poy.poy08              #税别
   LET g_sql = "SELECT gec04,gec05,gec07 FROM ",cl_get_target_table(l_plant,'gec_file'),  #稅率
               " WHERE gec01 = '",l_oha.oha21,"'",
               "   AND gec011= '2' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE t256_sub_wback1_gec_p FROM g_sql
   EXECUTE t256_sub_wback1_gec_p INTO l_gec04,l_gec05,l_gec07
   LET l_oha.oha211= l_gec04                  #税率
   LET l_oha.oha212= l_gec05                  #联数
   LET l_oha.oha213= l_gec07                  #含税否
   LET l_oha.oha23 = l_poy.poy05              #币别
   CALL p840_azi(l_oha.oha23)                 #讀取幣別資料
   #出貨時重新抓取匯率
   CALL s_currm(l_oha.oha23,l_oha.oha02,g_pod.pod01,l_plant)
       RETURNING l_oha.oha24
   #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
   IF l_oha.oha23 = g_aza.aza17 THEN
      LET l_oha.oha24=1                       #汇率
   END IF
   IF cl_null(l_oha.oha24) THEN LET l_oha.oha24=1 END IF
   LET l_oha.oha25 = l_poy.poy10              #销售分类一
   LET l_oha.oha26 = ''                         #销售分类二
   LET l_oha.oha31 = l_occ.occ44              #价格条件
   LET l_oha.oha41 = 'Y'                      #三角贸易销退单否
   LET l_oha.oha42 = 'Y'                      #是否入库存
   LET l_oha.oha43 = 'N'                      #起始三角贸易销退单否
   LET l_oha.oha44 = 'Y'                      #抛转否
   LET l_oha.oha45 = ''                       #No Use
   LET l_oha.oha46 = ''                       #No Use
   LET l_oha.oha47 = ''                       #运送车号
   LET l_oha.oha48 = ''                       #备注
   LET l_oha.oha50 = 0                        #原幣銷退總未稅金額
   LET l_oha.oha53 = 0                        #原幣銷退應開折讓未稅金額
   LET l_oha.oha54 = 0                        #原幣銷退已開折讓未稅金額
   LET l_oha.oha55 = '1'                      #状况码
   LET l_oha.oha99 = g_flow99                 #多角贸易流程序号
   LET l_oha.ohaconf='Y'                      #确认否
   LET l_oha.ohapost='Y'                      #库存入帐否
   LET l_oha.ohaprsw=0                        #列印次数
   LET l_oha.ohauser=g_user                   #
   LET l_oha.ohagrup=g_grup                   #
   LET l_oha.ohaoriu=g_user                   #
   LET l_oha.ohaorig=g_grup                   #
   LET l_oha.ohamodu=null                     #
   LET l_oha.ohadate=null                     #
  #IF l_aza.aza50 = 'Y'THEN                   #使用分銷功能
  #   ##銷退單新增欄位設置                                                 
  #   IF l_oea.oea00 = '6' THEN    
  #      LET l_oha.oha05 = '4'  #代送銷售  
  #   END IF
  #   LET l_oha.oha1001 = l_oea.oea17         #收款客戶編號
  #   LET l_oha.oha1002 = l_oea.oea1002       #債權代碼     
  #   LET l_oha.oha1003 = l_oea.oea1003       #業績歸屬方   
  #   LET l_oha.oha1004 = g_poy.poy31         #退貨原因碼 
  #   LET l_oha.oha1005 = l_oea.oea1005       #是否計算業績 
  #   LET l_oha.oha1006 = 0                   #折扣金額(未稅)
  #   LET l_oha.oha1007 = 0                   #折扣金額(含稅)
  #   LET l_oha.oha1008 = 0                   #銷退單總含稅金額
  #   LET l_oha.oha1009 = l_oea.oea1009       #客戶所屬渠道    
  #   LET l_oha.oha1010 = l_oea.oea1010       #客戶所屬方      
  #   LET l_oha.oha1011 = l_oea.oea1011       #開票客戶        
  #   LET l_oha.oha1012 = ''                  #原始退單號      
  #   LET l_oha.oha1013 = ''                  #收料驗收單號    
  #   LET l_oha.oha1014 = l_oea.oea1004       #代送商          
  #   LET l_oha.oha1015 = 'N'                 #是否對應代送出貨
  #   LET l_oha.oha1016 = l_oea.oea1001       #帳款客戶編號    
  #   LET l_oha.oha1017 = '0'                 #導物流狀況碼    
  #   LET l_oha.oha1018 = ''                  #代送出貨單號    
  #END IF
   LET l_oha.ohaud01 = ''                     #自订栏位-Textedit
   LET l_oha.ohaud02 = ''                     #
   LET l_oha.ohaud03 = ''                     #
   LET l_oha.ohaud04 = ''                     #
   LET l_oha.ohaud05 = ''                     #
   LET l_oha.ohaud06 = ''                     #
   LET l_oha.ohaud07 = ''                     #
   LET l_oha.ohaud08 = ''                     #
   LET l_oha.ohaud09 = ''                     #
   LET l_oha.ohaud10 = ''                     #
   LET l_oha.ohaud11 = ''                     #
   LET l_oha.ohaud12 = ''                     #
   LET l_oha.ohaud13 = ''                     #
   LET l_oha.ohaud14 = ''                     #
   LET l_oha.ohaud15 = ''                     #
   IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #发票性质
   LET l_oha.ohamksg = 'N'
   #新增銷退單頭檔(oha_file)
   LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'oha_file'),
             "( oha01,oha02,oha03,oha032, ",
             "  oha04,oha05,oha08,oha09,",
             "  oha10,oha14,oha15,oha16,",
             "  oha21,oha211,oha212,oha213,",
             "  oha23,oha24,oha25,oha26,",
             "  oha31,oha41,oha42,oha43,",
             "  oha44,oha45,oha46,oha47,",
             "  oha48,oha50,oha53,oha54,oha55,",
             "  ohaconf,ohapost,ohaprsw,ohauser, ",
	     "  ohagrup,ohamodu,ohadate,oha99,ohaoriu,ohaorig,ohamksg,   ",
	     "  oha1001,oha1002,oha1003,oha1004, ",
	     "  oha1005,oha1006,oha1007,oha1008, ",
	     "  oha1009,oha1010,oha1011,oha1012, ",
	     "  oha1013,oha1014,oha1015,oha1016, ",
	     "  oha1017,oha1018,ohaplant,ohalegal, ",
             "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",                    
             "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",                    
             "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,oha57)",              
             " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                      "?,?,?,?, ?,?,?,?,  ",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,  ?,? ,?,?,?,?) "
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE t256_ins_oha_ins_oha FROM g_sql
         EXECUTE t256_ins_oha_ins_oha USING 
               l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032, 
               l_oha.oha04,l_oha.oha05,l_oha.oha08,l_oha.oha09,
               l_oha.oha10,l_oha.oha14,l_oha.oha15,l_oha.oha16,
               l_oha.oha21,l_oha.oha211,l_oha.oha212,l_oha.oha213,
               l_oha.oha23,l_oha.oha24,l_oha.oha25,l_oha.oha26,
               l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,
               l_oha.oha44,l_oha.oha45,l_oha.oha46,l_oha.oha47,
               l_oha.oha48,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.oha55,
               l_oha.ohaconf,l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,
	       l_oha.ohagrup,l_oha.ohamodu,l_oha.ohadate,l_oha.oha99,
               l_oha.ohaoriu,l_oha.ohaorig,l_oha.ohamksg,
               l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,
               l_oha.oha1004,l_oha.oha1005,l_oha.oha1006,  
               l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,
               l_oha.oha1010,l_oha.oha1011,l_oha.oha1012,  
               l_oha.oha1013,l_oha.oha1014,l_oha.oha1015,  
               l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,l_plant,l_legal,
               l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,l_oha.ohaud04,l_oha.ohaud05,
               l_oha.ohaud06,l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,l_oha.ohaud10,
               l_oha.ohaud11,l_oha.ohaud12,l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,l_oha.oha57
            IF SQLCA.sqlcode<>0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","ins oha:",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","ins oha:",1)
               END IF
               LET g_success = 'N'
            END IF
 
  #IF l_aza.aza50 = 'Y' AND l_oha.oha05 = '4'  THEN   #使用分銷功能,且有代送則生成出貨單
  #   CALL p840_ogains()     
  #END IF
   
   IF g_success = 'N' THEN RETURN END IF
   
   #銷退單身檔
   IF NOT cl_null(g_ruo.ruo14) THEN
      LET g_sql = "SELECT imd20 FROM ",cl_get_target_table(g_ruo.ruo04, 'imd_file'),
                  " WHERE imd01 = '",g_ruo.ruo14,"'",
                  "   AND imd10 = 'W' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
      PREPARE t256_ins_oha_pre_imd1 FROM g_sql
      EXECUTE t256_ins_oha_pre_imd1 INTO l_imd20
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','SELECT imd_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
   ELSE
      LET l_imd20 = ''
   END IF

   IF l_imd20 = g_ruo.ruo04 THEN
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                  " WHERE rup01='",g_ruo.ruo011,"' "
   ELSE
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                  " WHERE rup01='",g_ruo.ruo01,"' "
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
   PREPARE t256_ins_oha_rup_p1 FROM g_sql
   DECLARE t256_ins_oha_rup_c1 CURSOR FOR t256_ins_oha_rup_p1
   FOREACH t256_ins_oha_rup_c1 INTO l_rup.*
      IF STATUS THEN
         LET g_success='N'
         RETURN
      END IF
      
      LET g_sql = " SELECT rvu_file.*,rvv_file.* ",
                  "   FROM ",cl_get_target_table(g_ruo.ruo04,'rvv_file'),",",
                             cl_get_target_table(g_ruo.ruo04,'rvu_file'),
                  "  WHERE rvu01 = rvv01 AND rvu01 = '",p_rvu01,"'",
                  "    AND rvv02 = '",l_rup.rup02,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
      PREPARE t256_ins_oha_rvv_p2 FROM g_sql
      EXECUTE t256_ins_oha_rvv_p2 INTO l_rvu.*,l_rvv.*

      #新增銷退單身檔[ohb_file]
      LET l_ohb.ohb01 = l_oha.oha01         #銷退單號
      LET l_ohb.ohb03 = l_rup.rup02         #項次
      LET l_ohb.ohb04 = l_rup.rup03         #產品編號
      LET l_ohb.ohb05 = l_rup.rup07         #銷售單位
      LET l_ohb.ohb05_fac= l_rup.rup08      #換算率
      LET g_sql = " SELECT ima02,ima25,ima908,ima15 ",
                  "   FROM ",cl_get_target_table(l_plant,'ima_file'),
                  "  WHERE ima01 = '",l_rup.rup03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_ins_oha_ima_p2 FROM g_sql
      EXECUTE t256_ins_oha_ima_p2 INTO l_ima02,l_ima25,l_ima908,l_ima15
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ima01',l_rup.rup03,'SELECT ima',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_ohb.ohb06 = l_ima02             #品名規格
      LET l_ohb.ohb07 = l_ima02             #額外品名編號
      LET l_ohb.ohb08 = l_plant             #出貨工廠
      LET l_ohb.ohb09 = g_ruo.ruo05         #出貨倉庫
      LET l_ohb.ohb091= ' '                 #出貨儲位
      LET l_ohb.ohb092= ' '                 #出貨批號
      LET l_ohb.ohbud01 = ''
      LET l_ohb.ohbud02 = ''
      LET l_ohb.ohbud03 = ''
      LET l_ohb.ohbud04 = ''
      LET l_ohb.ohbud05 = ''
      LET l_ohb.ohbud06 = ''
      LET l_ohb.ohbud07 = ''
      LET l_ohb.ohbud08 = ''
      LET l_ohb.ohbud09 = ''
      LET l_ohb.ohbud10 = ''
      LET l_ohb.ohbud11 = ''
      LET l_ohb.ohbud12 = ''
      LET l_ohb.ohbud13 = ''
      LET l_ohb.ohbud14 = ''
      LET l_ohb.ohbud15 = ''
      IF cl_null(l_imd20) OR l_imd20 = g_ruo.ruo04 THEN
         LET l_ohb.ohb09 = l_rup.rup13
         LET l_ohb.ohb091 = l_rup.rup14
         LET l_ohb.ohb092 = l_rup.rup15
      ELSE
         LET l_ohb.ohb09 = g_ruo.ruo14
         LET l_ohb.ohb091 = ' '
         LET l_ohb.ohb092 = ' '
      END IF
         
     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
         LET l_ohb.ohb092= ' '
      END IF
      IF cl_null(l_ohb.ohb09) THEN LET l_ohb.ohb09 = ' ' END IF
      IF cl_null(l_ohb.ohb091) THEN LET l_ohb.ohb091 = ' ' END IF
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092 = ' ' END IF
    
      LET l_ohb.ohb11 = l_rup.rup03      #客戶產品編號
      LET l_ohb.ohb12 = l_rup.rup12      #實際出貨數量
      LET l_ohb.ohb917 = l_rup.rup12
      LET l_ohb.ohb916 = l_rup.rup07
     
      LET l_ohb.ohb31 = ''
      LET l_ohb.ohb32 = ''
      LET l_ohb.ohb930 = s_costcenter(l_oha.oha15)
      
     #IF g_aza.aza50 = 'Y' THEN
     #CALL s_fetch_price2(l_oha.oha1001,l_ohb.ohb04,l_unit,l_oha.oha02,'4',l_plant,l_oha.oha23)
     #  RETURNING l_ohb.ohb1002,l_ohb.ohb13,l_success
     #IF l_success ='N' THEN
     #   LET g_success = 'N'
     #   LET g_showmsg = l_plant,"+",l_oha.oha1001,"+",l_ohb.ohb04,"+",l_oha.oha01,"+",l_oha.oha02,"+",l_oha.oha23
     #      CALL s_errmsg("l_plant,l_oha.oha1001,l_ohb.ohb04,l_oha.oha01,l_oha.oha02,l_oha.oha23",g_showmsg,"s_fetch_price2","axm-043",1)
     #   END IF
     #END IF  
     #IF cl_null(l_ohb.ohb916) THEN
     #   LET l_ohb.ohb917=l_ohb.ohb12
     #END IF 
     #IF l_oha.oha213 = 'N' THEN              #表示不含稅
     #   LET l_ohb.ohb14 = l_ohb.ohb917* l_ohb.ohb13
     #   LET l_ohb.ohb14t= l_ohb.ohb14*(1+l_oha.oha211/100)
     #ELSE
     #   LET l_ohb.ohb13 = l_ohb.ohb13*(1+l_oha.oha211/100)
     #   LET l_ohb.ohb14t= l_ohb.ohb917*l_ohb.ohb13
     #   LET l_ohb.ohb14 = l_ohb.ohb14t/(1+l_oha.oha211/100)
     #END IF
     #ELSE
      IF l_oha.oha213 = 'Y' THEN
         LET l_ohb.ohb13=l_rvv.rvv38t    #含稅單價. 同上游採購單價
      ELSE
         LET l_ohb.ohb13=l_rvv.rvv38     #未稅單價. 同上游採購單價
      END IF
      LET g_sql = " SELECT azi03,azi04 FROM ",cl_get_target_table(l_plant,'azi_file'),   #幣別檔
                  "  WHERE azi01 ='",l_oha.oha23,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_sub_ins_oha_azi_p1 FROM g_sql
      EXECUTE t256_sub_ins_oha_azi_p1 INTO t_azi03,t_azi04
      CALL cl_digcut(l_ohb.ohb13,t_azi03) RETURNING l_ohb.ohb13
      LET l_ohb.ohb64 = l_rvu.rvu21
      LET l_ohb.ohb67 = 0
      LET l_ohb.ohb68 = '1'
      IF cl_null(l_ohb.ohb64) THEN LET l_ohb.ohb64 = '1' END IF
      #未稅金額/含稅金額 . ohb14/ohb14t
      IF l_oha.oha213 = 'N' THEN
         LET l_ohb.ohb14=l_ohb.ohb917*l_ohb.ohb13
         LET l_ohb.ohb14t=l_ohb.ohb14*(1+l_oha.oha211/100)
      ELSE
         LET l_ohb.ohb14t=l_ohb.ohb917*l_ohb.ohb13
         LET l_ohb.ohb14=l_ohb.ohb14t/(1+l_oha.oha211/100)
      END IF
    	#END IF
    	
      CALL cl_digcut(l_ohb.ohb14,t_azi04) RETURNING l_ohb.ohb14
      CALL cl_digcut(l_ohb.ohb14t,t_azi04)RETURNING l_ohb.ohb14t
      LET l_ohb.ohb50 = l_poy.poy31       #原因碼
      LET l_ohb.ohb37 = l_ohb.ohb13
    
      LET l_ohb.ohb917 = l_rvv.rvv87
      LET l_ohb.ohb15 = l_ima25
      LET l_ohb.ohb15_fac = l_rup.rup08
      LET l_ohb.ohb16 = l_ohb.ohb12*l_ohb.ohb15_fac
      LET l_ohb.ohb30 = ''              #原出貨發票號 oma10
      IF cl_null(l_ohb.ohb31) THEN LET l_ohb.ohb31='' END IF
      IF cl_null(l_ohb.ohb32) THEN LET l_ohb.ohb32='' END IF
      LET l_ohb.ohb33 = ''
      LET l_ohb.ohb34 = ''
      LET l_ohb.ohb60 =0
      LET l_ohb.ohb61 = 'N'
      LET l_ohb.ohb910 = l_rvv.rvv80
      LET l_ohb.ohb911 = l_rvv.rvv81
      LET l_ohb.ohb912 = l_rvv.rvv82
      LET l_ohb.ohb913 = l_rvv.rvv83
      LET l_ohb.ohb914 = l_rvv.rvv84
      LET l_ohb.ohb915 = l_rvv.rvv85
      LET l_ohb.ohb916 = l_rvv.rvv86
     #IF l_aza.aza50 = 'Y'THEN     #使用分銷功能
     #   #銷退單單身新增欄位設置
     #   LET l_ohb.ohb50   = g_poy.poy31         #退貨原因碼 
     #   LET l_ohb.ohb1001 = l_oeb.oeb1002       #定價編碼
     #   LET l_ohb.ohb1002 = ''                  #提案編號
     #   LET l_ohb.ohb1003 = l_oeb.oeb1006       #折扣率
     #   LET l_ohb.ohb1004 = l_azf10a            #搭增否
     #END IF
     #LET l_ohb.ohb1005 = l_oeb.oeb1003
      #新增銷退單身檔
select count(*) INTO g_cnt FROM ds11.ohb_file
where ohb01=l_ohb.ohb01
DISPLAY "ohb:",g_cnt
      
      LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'ohb_file'),
       "(ohb01,ohb03,ohb04,ohb05, ",
       " ohb05_fac,ohb06,ohb07,ohb08, ",
       " ohb09,ohb091,ohb092,ohb11, ",
       " ohb12,ohb37,ohb13,ohb14,ohb14t,",
       " ohb15,ohb15_fac,ohb16,ohb30, ",
       " ohb31,ohb32,ohb33,ohb34,",
       " ohb50,ohb51,ohb60,ohb61,ohb910,",
       " ohb911,ohb912,ohb913,ohb914,ohb930,",
       " ohb915,ohb916,ohb917,ohb1001,ohb1002,ohb1003,ohb1004,ohb1005,ohbplant,ohblegal, ",
       " ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
       " ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
       " ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",
       " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",
       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",
       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?, ?,?) "
    	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_ins_oha_ins_ohb FROM g_sql
      EXECUTE t256_ins_oha_ins_ohb USING 
        l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05, 
        l_ohb.ohb05_fac,l_ohb.ohb06,l_ohb.ohb07,l_ohb.ohb08, 
        l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11, 
        l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,
        l_ohb.ohb15,l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30, 
        l_ohb.ohb31,l_ohb.ohb32,l_ohb.ohb33,l_ohb.ohb34,
        l_ohb.ohb50,l_ohb.ohb51,l_ohb.ohb60,l_ohb.ohb61,l_ohb.ohb910,
        l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb930,
        l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb1001,l_ohb.ohb1002,
        l_ohb.ohb1003,l_ohb.ohb1004,l_ohb.ohb1005,l_plant,l_legal
       ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,l_ohb.ohbud04,l_ohb.ohbud05,
        l_ohb.ohbud06,l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,l_ohb.ohbud10,
        l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15
        IF SQLCA.sqlcode<>0 THEN
          CALL s_errmsg("","","ins ohb:","apm-019",1)
           LET g_success = 'N'
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_ohbi.* TO NULL
              LET l_ohbi.ohbi01 = l_ohb.ohb01
              LET l_ohbi.ohbi03 = l_ohb.ohb03
              IF NOT s_ins_ohbi(l_ohbi.*,l_plant) THEN
                 LET g_success = 'N'  
              END IF
           END IF 
          #IF g_oaz.oaz96 ='Y' THEN
          #   CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
          #   IF l_oia07 = '0' THEN
          #      CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant)
          #   END IF
          #END IF
        END IF
      #更新img和tlf
      CALL s_img_tlf(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb01,l_ohb.ohb03,l_plant,'5')

      #單頭之銷退金額
      LET l_oha.oha50 =l_oha.oha50 + l_ohb.ohb14   #原幣銷退金額(未稅)
      LET g_sql="UPDATE ",cl_get_target_table(l_plant,'oha_file'),
                   "   SET oha50 = ? ",
                   " WHERE oha01 = ? "
    	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_ins_oha_upd_oha50 FROM g_sql
      EXECUTE t256_ins_oha_upd_oha50 USING l_oha.oha50,l_oha.oha01
      IF SQLCA.sqlcode<>0 THEN
         CALL s_errmsg("","","upd oha:",SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      IF g_aza.aza50 = 'Y'THEN     #使用分銷功能
         LET l_oha.oha1008 = l_oha.oha1008 + l_ohb.ohb14t   #原幣銷退金額(含稅)
         LET g_sql="UPDATE ",cl_get_target_table(l_plant,'oha_file'),
                    "   SET oha1008 = ? ",                                            
                    " WHERE oha01 = ? "                                             
    	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE t256_ins_oha_upd_oha1008 FROM g_sql                                             
         EXECUTE t256_ins_oha_upd_oha1008 USING l_oha.oha1008,l_oha.oha01                            
         IF SQLCA.sqlcode<>0 THEN
               CALL s_errmsg("","","upd oha:",SQLCA.sqlcode,1)
            LET g_success = 'N'                                                     
         END IF
      END IF
   
      #回寫最近入庫日 ima73
      LET g_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant,'ima_file'),
                   " WHERE ima01='",l_ohb.ohb04,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE t256_ins_oha_ima_p3 FROM g_sql
      IF SQLCA.SQLCODE THEN
           CALL s_errmsg("ima01",l_ohb.ohb04,"",SQLCA.sqlcode,1)
      END IF
      DECLARE t256_ins_oha_ima_c3 CURSOR FOR t256_ins_oha_ima_p3
      OPEN t256_ins_oha_ima_c3
      FETCH t256_ins_oha_ima_c3 INTO l_ima29
      #異動日期需大於原來的異動日期才可
      #必須判斷null,否則新料不會update
      IF (l_oha.oha02 > l_ima29 OR l_ima29 IS NULL) THEN
         LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'ima_file'),
                     " SET ima73 = ? , ima29 = ? WHERE ima01 = ?  "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE t256_ins_oha_upd_ima3 FROM g_sql
         EXECUTE t256_ins_oha_upd_ima3 USING l_oha.oha02,l_oha.oha02,l_ohb.ohb04
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL s_errmsg('ima01',l_ohb.ohb04,'upd ima',STATUS,1)
            LET g_success='N'
         END IF
      END IF
   END FOREACH

  #IF l_aza.aza50 = 'Y' AND l_oha.oha05 = '4'  THEN   #使用分銷功能,且有代送則生成出貨單
  #   CALL p840_ogbins()     
  #END IF
END FUNCTION

FUNCTION s_img_tlf(p_part,p_ware,p_loca,p_lot,p_no,p_item,p_plant,p_sta)
  DEFINE p_part      LIKE ima_file.ima01,       #料號
         p_ware      LIKE ogb_file.ogb09,       #倉
         p_loca      LIKE ogb_file.ogb091,      #儲
         p_lot       LIKE ogb_file.ogb092,      #批
         p_sta       LIKE type_file.chr1,       #4.倉退單 5.銷退單
         p_no        LIKE oha_file.oha01,       #单号
         p_item      LIKE ohb_file.ohb03,       #项次
         p_plant     LIKE azw_file.azw01,       #plant
         l_img       RECORD LIKE img_file.*,
         l_oha       RECORD LIKE oha_file.*,
         l_ohb       RECORD LIKE ohb_file.*,
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_imd10     LIKE imd_file.imd10,
         l_imd11     LIKE imd_file.imd11,
         l_imd12     LIKE imd_file.imd12,
         l_imd13     LIKE imd_file.imd13,
         l_imd14     LIKE imd_file.imd14,
         l_imd15     LIKE imd_file.imd15,
         l_ima02     LIKE ima_file.ima02,
         l_ima25     LIKE ima_file.ima25
  DEFINE l_legal    LIKE azw_file.azw02

   CALL s_getlegal(p_plant) RETURNING l_legal
   
   IF p_part[1,4]='MISC' THEN RETURN END IF
   IF p_loca IS NULL THEN LET p_loca=' ' END IF
   IF p_lot  IS NULL THEN LET p_lot =' ' END IF

   IF s_joint_venture(p_part,p_plant) OR NOT s_internal_item(p_part,p_plant ) THEN
      RETURN
   END IF
   
   LET g_sql = "SELECT oha_file.*,ohb_file.* ",
               "  FROM ",cl_get_target_table(p_plant,'oha_file'),",",
                         cl_get_target_table(p_plant,'ohb_file'),
               " WHERE ohb01 = oha01 ",
               "   AND ohb01 = '",p_no,"'",
               "   AND ohb03 = '",p_item,"'"
   PREPARE sel_no_p FROM g_sql
   EXECUTE sel_no_p INTO l_oha.*,l_ohb.*
   
   LET g_sql = "SELECT ima01,ima25 ",
               "  FROM ",cl_get_target_table(p_plant,'ima_file'),
               " WHERE ima01 = '",p_part,"'"
   PREPARE sel_ima25_p FROM g_sql
   EXECUTE sel_ima25_p INTO l_ima02,l_ima25
   
   LET g_sql = "SELECT COUNT(*) ",
                " FROM ",cl_get_target_table(p_plant,'img_file'),
                " WHERE img01='",p_part,"' ",
                "   AND img02='",p_ware,"'",
                "   AND img03='",p_loca,"'",
                "   AND img04='",p_lot,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE img_pre1 FROM g_sql
   IF STATUS THEN
      CALL s_errmsg("","","img_pre",STATUS,1)
   END IF
   DECLARE img_cs CURSOR FOR img_pre1
   OPEN img_cs
   LET g_cnt = 0
   FETCH img_cs INTO g_cnt
   IF g_cnt = 0 THEN
      LET l_img.img01 = p_part
      LET l_img.img02 = p_ware
      LET l_img.img03 = p_loca
      LET l_img.img04 = p_lot
	    IF cl_null(l_img.img04) THEN LET l_img.img04 = ' ' END IF
      LET l_img.img05 = l_ohb.ohb01
      LET l_img.img06 = l_ohb.ohb03
      LET l_img.img09 = l_ima25
      LET l_img.img10 = 0
      LET l_img.img13 = null      #No.7304
      LET l_img.img18 = g_lastdat
      LET l_img.img17 = g_today
      LET l_img.img20 = 1
      LET l_img.img21 = 1
      
      LET g_sql = "SELECT imd10,imd11,imd12,imd13,imd14,imd15 ",
                  "  FROM ",cl_get_target_table(p_plant,'imd_file'),
                  " WHERE imd01 = '",p_ware,"'"
      PREPARE sel_imd_p FROM g_sql
      EXECUTE sel_imd_p INTO l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15
      LET l_img.img22 = l_imd10
      LET l_img.img23 = l_imd11
      LET l_img.img24 = l_imd12
      LET l_img.img25 = l_imd13
      LET l_img.img27 = l_imd14
      LET l_img.img28 = l_imd15
      LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'img_file'),
        "(img01,img02,img03,img04,img05,img06,",
        " img09,img10,img13,img17,img18,", 
        " img20,img21,img22,img23,img24,", 
        " img25,img27,img28,imgplant,imglegal)",
        " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE ins_img FROM g_sql
      EXECUTE ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,
                            l_img.img05,l_img.img06,
                            l_img.img09,l_img.img10,l_img.img13,l_img.img17,
                            l_img.img18,
                            l_img.img20,l_img.img21,l_img.img22,l_img.img23,
                            l_img.img24,l_img.img25,l_img.img27,l_img.img28,p_plant,l_legal
      IF SQLCA.sqlcode<>0 THEN
         CALL s_errmsg("","","ins img:",SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   
   CALL s_mupimg(1,p_part,p_ware,p_loca,p_lot,l_ohb.ohb12*l_ohb.ohb15_fac,
                 l_oha.oha02, p_plant,1,l_oha.oha01,l_ohb.ohb03)

   #----來源----
   LET g_tlf.tlf01=l_ohb.ohb04             #異動料件編號
   LET g_tlf.tlf02=731
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '            #倉庫
   LET g_tlf.tlf022=' '            #儲位
   LET g_tlf.tlf023=' '            #批號
   LET g_tlf.tlf024=0              #異動後數量
   LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ohb.ohb01    #銷退單號
   LET g_tlf.tlf027=l_ohb.ohb03    #銷退項次
   #---目的----
   LET g_tlf.tlf03=50
   LET g_tlf.tlf030=l_ohb.ohb08
   LET g_tlf.tlf031=l_ohb.ohb09    #倉庫
   LET g_tlf.tlf032=l_ohb.ohb091   #儲位
   LET g_tlf.tlf033=l_ohb.ohb092   #批號
   LET g_tlf.tlf034=l_img10        #異動後庫存數量
   LET g_tlf.tlf035=l_ima25        #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ohb.ohb01    #銷退單號
   LET g_tlf.tlf037=l_ohb.ohb03    #銷退項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=l_ohb.ohb12      #異動數量
   LET g_tlf.tlf11=l_ohb.ohb05      #發料單位
   LET g_tlf.tlf12 =l_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=l_ohb.ohb50      #異動原因   #MOD-870120

   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(p_part)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oha.oha03
   LET g_tlf.tlf20=''
  #SELECT oga46 INTO g_tlf.tlf20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlf.tlf62=l_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64=l_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930=l_ohb.ohb930
   SELECT ogb41,ogb42,ogb43,ogb1001
     INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
     FROM ogb_file
    WHERE ogb01 = l_ohb.ohb31
      AND ogb03 = l_ohb.ohb32
   IF SQLCA.sqlcode THEN
     LET g_tlf.tlf20 = ' '
     LET g_tlf.tlf41 = ' '
     LET g_tlf.tlf42 = ' '
     LET g_tlf.tlf43 = ' '
   END IF
   CALL s_tlf1(1,0,p_plant)
END FUNCTION

FUNCTION t256_sub_ins_rvq()
 DEFINE l_rup            RECORD LIKE rup_file.*
 DEFINE l_rvq            RECORD LIKE rvq_file.*
 DEFINE l_rvr            RECORD LIKE rvr_file.*
 DEFINE l_flag           LIKE type_file.chr1

   #撥入撥出存在上下級關係
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM azw_file WHERE azw01 = g_ruo.ruo05 AND azw07 = g_ruo.ruo04  #撥出是撥入的上級
   IF g_cnt>0 THEN
      LET l_rvq.rvqplant = g_ruo.ruo04 
   ELSE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM azw_file WHERE azw01 = g_ruo.ruo04 AND azw07 = g_ruo.ruo05 #拨入是拨出的上级
      IF g_cnt>0 THEN 
         LET l_rvq.rvqplant = g_ruo.ruo05 
      END IF
   END IF
   #撥入撥出無上下級關係
   IF cl_null(l_rvq.rvqplant) THEN
      SELECT azw07 INTO l_rvq.rvqplant FROM azw_file WHERE azw01 = g_ruo.ruo04  #抓拨出营运中心的上级营运中心
   END IF 
   IF cl_null(l_rvq.rvqplant) THEN 
      LET l_rvq.rvqplant = g_ruo.ruo04　 #拨出营运中心为最上层
   END IF
   CALL s_getlegal(l_rvq.rvqplant) RETURNING l_rvq.rvqlegal   #法人
   LET l_rvq.rvq00 = '2'
   
   #自动编号
   #FUN-C90050 mark begin---
   #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(l_rvq.rvqplant,'rye_file'),
   #            " WHERE rye01 = 'art' AND rye02 = 'C5'" 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #CALL cl_parse_qry_sql(g_sql,l_rvq.rvqplant) RETURNING g_sql
   #PREPARE t256_sub_ins_rvq_sel_rye FROM g_sql
   #EXECUTE t256_sub_ins_rvq_sel_rye INTO l_rvq.rvq01
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','C5',l_rvq.rvqplant,'N') RETURNING l_rvq.rvq01    #FUN-C90050 add

   CALL s_auto_assign_no("art",l_rvq.rvq01,g_today,"C5","rvq_file","rvq01,rvqplant",l_rvq.rvqplant,"","")
   RETURNING l_flag,l_rvq.rvq01 #自動生成新的申請單號 
   IF (NOT l_flag) THEN  
      LET g_success = 'N'
      CALL s_errmsg('rvq01',l_rvq.rvq01,'','sub-145',1) 
      RETURN
   END IF
   
   IF g_ruo.ruo02 = 'P' THEN										
      LET l_rvq.rvq02 = 'P'										
   ELSE										
      LET l_rvq.rvq02 = '1'										
   END IF										
   LET l_rvq.rvq03 = g_today										
   LET l_rvq.rvq04 = g_user										
   LET l_rvq.rvq05 = l_rvq.rvqplant										
   LET l_rvq.rvq06 = g_ruo.ruo011
   LET l_rvq.rvq07 = g_ruo.ruo04
   LET l_rvq.rvq08 = g_ruo.ruo05
   LET l_rvq.rvq10 = g_today										
   LET l_rvq.rvq10t = TIME										
   LET l_rvq.rvq11 = g_user										
   LET l_rvq.rvq12 = NULL
   LET l_rvq.rvq14 = g_ruo.ruo011
   LET l_rvq.rvq15 = g_ruo.ruo14										
   LET l_rvq.rvq99 = g_ruo.ruo99										
   LET l_rvq.rvq904 = g_ruo.ruo904										
   LET l_rvq.rvqpos = 'Y'										
   LET l_rvq.rvqconf = '3'
   LET l_rvq.rvqplant = l_rvq.rvqplant 
   LET l_rvq.rvquser = g_user   
   LET l_rvq.rvqgrup = g_grup   
   LET l_rvq.rvqoriu = g_user   
   LET l_rvq.rvqorig = g_grup  
   LET l_rvq.rvqcrat = g_today  
   LET l_rvq.rvqacti = 'Y'       
   LET l_rvq.rvqdate = NULL
   LET g_sql = "INSERT INTO ", cl_get_target_table(l_rvq.rvqplant,'rvq_file'),
               "(rvq00,rvq01,rvq02,rvq03,rvq04,rvq05,rvq06,rvq07,rvq08,rvq09,rvq10,
                 rvq10t,rvq11,rvq12,rvq12t,rvq13,rvq14,rvq15,rvq904,rvq99,
                 rvqacti,rvqconf,rvqcrat,rvqdate,rvqgrup,rvqlegal,rvqmodu,
                 rvqorig,rvqoriu,rvqplant,rvqpos,rvquser) ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?)  "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  
   CALL cl_parse_qry_sql(g_sql,l_rvq.rvqplant) RETURNING g_sql          
   PREPARE t256_sub_ins_rvq_ins_rvq01 FROM g_sql
   EXECUTE t256_sub_ins_rvq_ins_rvq01 USING l_rvq.rvq00,l_rvq.rvq01,l_rvq.rvq02,l_rvq.rvq03,l_rvq.rvq04,
                 l_rvq.rvq05,l_rvq.rvq06,l_rvq.rvq07,l_rvq.rvq08,l_rvq.rvq09,
                 l_rvq.rvq10,l_rvq.rvq10t,l_rvq.rvq11,l_rvq.rvq12,l_rvq.rvq12t,
                 l_rvq.rvq13,l_rvq.rvq14,l_rvq.rvq15,l_rvq.rvq904,
                 l_rvq.rvq99,l_rvq.rvqacti,l_rvq.rvqconf,l_rvq.rvqcrat,l_rvq.rvqdate,
                 l_rvq.rvqgrup,l_rvq.rvqlegal,l_rvq.rvqmodu,
                 l_rvq.rvqorig,l_rvq.rvqoriu,l_rvq.rvqplant,l_rvq.rvqpos,l_rvq.rvquser
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL s_errmsg('rvqplant',l_rvq.rvqplant,'INSERT rvq_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   
   #插入單身
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ruo.ruo05,'rup_file'),
               " WHERE rup01 = '",g_ruo.ruo01,"'",
               "   AND rup16 > rup12 "
   PREPARE t256_sub_sel_rup_p FROM g_sql
   DECLARE t256_sub_sel_rup_c CURSOR FOR t256_sub_sel_rup_p
   FOREACH t256_sub_sel_rup_c INTO l_rup.*
      LET l_rvr.rvr00 = '2'
         LET l_rvr.rvr01 = l_rvq.rvq01
         IF cl_null(l_rvr.rvr02) THEN  #自動增1編號       
            LET l_rvr.rvr02 = '1'
         ELSE
            LET l_rvr.rvr02 = l_rvr.rvr02 + 1
         END IF
         LET l_rvr.rvr03 = l_rup.rup02										
         LET l_rvr.rvr04 = l_rup.rup03										
         LET l_rvr.rvr05 = l_rup.rup06										
         LET l_rvr.rvr06 = l_rup.rup07	
         LET l_rvr.rvr07 = l_rup.rup08         
         LET l_rvr.rvr08 = l_rup.rup16 - l_rup.rup12								
         LET l_rvr.rvr09 = 0
         LET l_rvr.rvrplant = l_rvq.rvqplant										
         LET l_rvr.rvrlegal = l_rvq.rvqlegal										
         LET g_sql = " INSERT INTO ", cl_get_target_table(l_rvq.rvqplant,'rvr_file'),
                     "(rvr00,rvr01,rvr02,rvr03,rvr04,rvr05,rvr06,rvr07,rvr08,rvr09,
                       rvr10,rvr11,rvrlegal,rvrplant) ",
                     " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  
         CALL cl_parse_qry_sql(g_sql,l_rvq.rvqplant) RETURNING g_sql          
         PREPARE t256_sub_ins_rvq_ins_rvr FROM g_sql
         EXECUTE t256_sub_ins_rvq_ins_rvr USING l_rvr.rvr00,l_rvr.rvr01,l_rvr.rvr02,l_rvr.rvr03,l_rvr.rvr04,
                                   l_rvr.rvr05,l_rvr.rvr06,l_rvr.rvr07,l_rvr.rvr08,l_rvr.rvr09,
                                   l_rvr.rvr10,l_rvr.rvr11,l_rvr.rvrlegal,l_rvr.rvrplant         
         IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
            LET g_success = 'N'
            CALL s_errmsg('rvrplant',l_rvq.rvqplant,'INSERT rvr_file',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
   END FOREACH
   
   IF g_success = 'Y' THEN
      CALL t256_sub_ins_ruo(l_rvq.rvq01,l_rvq.rvqplant)
   END IF
END FUNCTION

FUNCTION t256_sub_ins_ruo(p_rvq01,p_plant)  #产生调拨单
   DEFINE   p_plant    LIKE azw_file.azw01
   DEFINE   p_rvq01    LIKE rvq_file.rvq01
   DEFINE   l_ruo      RECORD LIKE ruo_file.*
   DEFINE   l_rup      RECORD LIKE rup_file.*
   DEFINE   l_rvq      RECORD LIKE rvq_file.*
   DEFINE   li_result  LIKE type_file.num5
   DEFINE   l_no       LIKE oay_file.oayslip
   DEFINE   l_cnt      LIKE type_file.num5  

   LET g_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rvq_file'),
               " WHERE rvq01 = '",p_rvq01,"'",
               "   AND rvqplant = '",p_plant,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE t256_sub_ins_ruo_sel_rvq FROM g_sql
   EXECUTE t256_sub_ins_ruo_sel_rvq INTO l_rvq.*

   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_rvq.rvq07,'ruo_file'),
               " WHERE ruo01 = '",l_rvq.rvq14,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_rvq.rvq07) RETURNING g_sql
   PREPARE t256_sub_ins_ruo_sel_ruo FROM g_sql
   EXECUTE t256_sub_ins_ruo_sel_ruo INTO l_ruo.*

   LET g_sql = "SELECT imd20 FROM ",cl_get_target_table(l_rvq.rvq07,'imd_file'),
               " WHERE imd01 = '",l_rvq.rvq15,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_rvq.rvq07) RETURNING g_sql
   PREPARE t256_sub_ins_ruo_sel_imd FROM g_sql
   EXECUTE t256_sub_ins_ruo_sel_imd INTO l_ruo.ruo05  #从原拨出营运中心到在途仓
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('imd20',l_rvq.rvq15,'','art-438',1)
      RETURN
   END IF
   
   LET l_ruo.ruo011 = ''
   LET l_ruo.ruo02 = '4'
   LET l_ruo.ruo03 = l_rvq.rvq01 #來源單號
   LET l_ruo.ruo07 = g_today
   LET l_ruo.ruo08 = g_user
   LET l_ruo.ruo09 = l_rvq.rvq09 #備註
   LET l_ruo.ruoacti = 'Y'   
   LET l_ruo.ruoconf = '0'
   LET l_ruo.ruocrat = g_today
   LET l_ruo.ruodate = NULL
   LET l_ruo.ruogrup = g_grup
   LET l_ruo.ruomodu = NULL
   LET l_ruo.ruouser = g_user
   LET l_ruo.ruooriu = g_user
   LET l_ruo.ruoorig = g_grup
   LET l_ruo.ruo14 = ''
   LET l_ruo.ruo15 = 'N'
   LET l_ruo.ruo904 = l_rvq.rvq904
   LET l_ruo.ruo99 = ''


   #FUN-C90050 mark begin---
   #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(l_ruo.ruo04,'rye_file'),
   #            " WHERE rye01 = 'art' AND rye02 = 'J1'" 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #CALL cl_parse_qry_sql(g_sql,l_rvq.rvq07) RETURNING g_sql
   #PREPARE t256_sub_ins_ruo_sel_rye FROM g_sql
   #EXECUTE t256_sub_ins_ruo_sel_rye INTO l_no
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','J1',l_ruo.ruo04,'N') RETURNING l_no       #FUN-C90050 add 

   #原調撥單的邏輯，从原拨出营运中心到在途仓的调拨单
   CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01,ruoplant",l_ruo.ruo04,"","")
   RETURNING li_result,l_ruo.ruo01
   IF (NOT li_result) THEN
      LET g_success="N"
      CALL s_errmsg('','','','asf-377',1)
      RETURN
   END IF
   #查看是否要走多角的流程
   SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = l_ruo.ruo04 AND azw02 NOT IN
   (SELECT azw02 FROM  azw_file WHERE azw01 = l_ruo.ruo05)    
   IF l_cnt > 0 THEN          #多角流程
      LET l_ruo.ruo901 = 'Y' 
   ELSE
      LET l_ruo.ruo901 = 'N' 
   END IF
   #插入單頭的資料
   LET g_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04,'ruo_file'),
               "(ruo01,ruo02,ruo03,ruo04,ruo05,ruo06,ruo07,",
               "ruo08,ruo09,ruo10,ruo10t,ruo11,ruo12,ruo12t,",
               "ruo13,ruo14,ruo15,ruo901,ruo904,ruo99,ruoacti,",
               "ruoconf,ruocrat,ruodate,ruogrup,ruolegal,ruomodu,",
               "ruoplant,ruouser,ruopos,ruooriu,ruoorig)",
               "  VALUES(?,?,?,?,?, ?,?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?)"               
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
   CALL cl_parse_qry_sql(g_sql,l_ruo.ruo04) RETURNING g_sql 
   PREPARE t256_sub_ins_ruo_ins_ruo FROM g_sql
   EXECUTE t256_sub_ins_ruo_ins_ruo USING
   l_ruo.ruo01, l_ruo.ruo02, l_ruo.ruo03, l_ruo.ruo04, l_ruo.ruo05,
   l_ruo.ruo06, l_ruo.ruo07, l_ruo.ruo08, l_ruo.ruo09, l_ruo.ruo10,
   l_ruo.ruo10t,l_ruo.ruo11, l_ruo.ruo12, l_ruo.ruo12t,l_ruo.ruo13,
   l_ruo.ruo14, l_ruo.ruo15, l_ruo.ruo901,l_ruo.ruo904,l_ruo.ruo99, l_ruo.ruoacti,
   l_ruo.ruoconf, l_ruo.ruocrat, l_ruo.ruodate, l_ruo.ruogrup, l_ruo.ruolegal,
   l_ruo.ruomodu, l_ruo.ruoplant,l_ruo.ruouser, l_ruo.ruopos,  l_ruo.ruooriu,l_ruo.ruoorig
    
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',l_ruo.ruo01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF
   
   #插入單身資料
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_rvq.rvq08,'rup_file'),
               " WHERE rup01 = '",g_ruo.ruo01,"'",
               "   AND rup16 - rup12 > 0 "
   LET l_cnt = 1
   PREPARE t256_sub_ins_ruo_sel_rvr_p FROM g_sql
   DECLARE t256_sub_ins_ruo_sel_rvr_c CURSOR FOR t256_sub_ins_ruo_sel_rvr_p 
   FOREACH t256_sub_ins_ruo_sel_rvr_c INTO l_rup.*
   
      LET l_rup.rup01 = l_ruo.ruo01
      LET l_rup.rup02 = l_cnt
      LET l_rup.rup17 = l_cnt
      LET l_rup.rup12 = l_rup.rup16 - l_rup.rup12
      LET l_rup.rup16 = l_rup.rup12
      LET l_rup.rup19 = l_rup.rup12
      LET l_rup.rup13 = l_rvq.rvq15
      LET l_rup.rup14 = ' '
      LET l_rup.rup15 = ' '
      LET l_rup.rup18 = 'N'
      LET l_rup.rupplant = l_ruo.ruoplant
      LET l_rup.ruplegal = l_ruo.ruolegal
      LET l_rup.rup22 = l_ruo.ruo05        #FUN-CC0158 add
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'rup_file'),"(",
                  "              rup01,rup02,rup03,rup04,rup05,rup06,rup07,rup08,rup09,rup10,rup11,",
                  "              rup12,rup13,rup14,rup15,rup16,rup17,rup18,rup19,rup22,rupplant,ruplegal)", #FUN-CC0158 add rup22
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "      #FUN-CC0158 add 1?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE t256_sub_ins_ruo_ins_rup FROM g_sql
      EXECUTE t256_sub_ins_ruo_ins_rup
                       USING l_rup.rup01,l_rup.rup02,l_rup.rup03,l_rup.rup04,l_rup.rup05,l_rup.rup06,l_rup.rup07,
                             l_rup.rup08,l_rup.rup09,l_rup.rup10,l_rup.rup11,l_rup.rup12,l_rup.rup13,l_rup.rup14,
                             l_rup.rup15,l_rup.rup16,l_rup.rup17,l_rup.rup18,l_rup.rup19,l_rup.rup22,l_rup.rupplant,l_rup.ruplegal    #FUN-CC0158 add l_rup.rup22
      IF SQLCA.sqlcode THEN         
         LET g_success="N"
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET l_cnt = l_cnt + 1     
   END FOREACH 
   IF g_success = 'N' THEN RETURN END IF
   CALL t256_sub(l_ruo.*,'1','N') #在途仓到原拨出营运中心，如果有多角，走仓退
END FUNCTION
#FUN-CA0086 End-----

FUNCTION t256_sub_y(p_rvu01,p_plant)
   DEFINE p_plant      LIKE azp_file.azp01   
   DEFINE l_rvu        RECORD LIKE rvu_file.*
   DEFINE l_rvv        RECORD LIKE rvv_file.*
   DEFINE p_rvu01      LIKE rvu_file.rvu01
   DEFINE l_yy,l_mm    LIKE type_file.num5
   DEFINE l_sql        STRING
   DEFINE l_forupd_sql STRING
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE l_rvucont    LIKE rvu_file.rvucont 
   DEFINE l_ima25      LIKE ima_file.ima25

   IF g_success = 'N' THEN 
      RETURN 
   END IF    
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant, 'rvu_file'), 
               " WHERE rvu01 = '",p_rvu01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql       
   PREPARE pre_sel_rvu FROM l_sql
   EXECUTE pre_sel_rvu INTO l_rvu.*
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('','','sel rvu_file',SQLCA.sqlcode,1)
      RETURN
   END IF 

   #無單身資料不可確認
   LET l_cnt=0
   LET l_sql = "SELECT COUNT(*) FROM ", cl_get_target_table(p_plant, 'rvv_file'), 
               " WHERE rvv01 = '",l_rvu.rvu01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
   PREPARE pre_sel_rvv FROM l_sql
   EXECUTE pre_sel_rvv INTO l_cnt  
   IF l_cnt=0 OR l_cnt IS NULL THEN
      #CALL cl_err('','mfg-009',1)
      CALL s_errmsg('','','SELECT rvv_file:','mfg-009',1)
      LET g_success = 'N' 
      RETURN
   END IF   
   #庫存異動日期不可小於關帳日期
   IF g_sma.sma53 IS NOT NULL AND l_rvu.rvu03 <= g_sma.sma53 THEN
      #CALL cl_err('','mfg9999',1)
      CALL s_errmsg('','','','mfg9999',1)
      LET g_success = 'N' 
      RETURN
   END IF

   CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      #CALL cl_err('','mfg6091',1)
      CALL s_errmsg('','','','mfg6091',1)
      LET g_success = 'N'
      RETURN
   END IF 
   
   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant, 'rvu_file'), 
                      " WHERE rvu01 = ? FOR UPDATE"
   #CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql         # FUN-B80085--mark--
   CALL cl_forupd_sql(l_forupd_sql) RETURNING l_forupd_sql             # FUN-B80085--add---       
   CALL cl_parse_qry_sql(l_forupd_sql, p_plant) RETURNING l_forupd_sql                    
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)                           
   DECLARE stw_sub_cl CURSOR FROM l_forupd_sql   
   
   OPEN stw_sub_cl USING l_rvu.rvu01
   IF STATUS THEN
      #CALL cl_err("OPEN stw_sub_cl:", STATUS, 1)
      CALL s_errmsg('','','OPEN stw_sub_cl:',STATUS,1)
      CLOSE stw_sub_cl
      LET g_success = 'N' 
      RETURN
   END IF

   FETCH stw_sub_cl INTO l_rvu.*               #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      #CALL cl_err(l_rvu.rvu01,SQLCA.sqlcode,0) #資料被他人LOCK
      CALL s_errmsg('',l_rvu.rvu01,'stw_sub_cl',SQLCA.sqlcode,1)
      CLOSE stw_sub_cl
      LET g_success = 'N' 
      RETURN
   END IF

   #更新單頭確認碼
   LET l_rvucont = TIME
   IF g_success = 'Y' THEN
      LET l_sql = "UPDATE ",cl_get_target_table(p_plant, 'rvu_file'),  
                  "   SET rvuconf = 'Y', ",
                  "       rvuconu = '",g_user,"',",
                  "       rvucond = '",g_today,"',",
                  "       rvucont = '",l_rvucont,"'",
                  " WHERE rvu01 = '",l_rvu.rvu01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
      CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
      PREPARE pre_upd_rvu FROM l_sql
      EXECUTE pre_upd_rvu
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('upd rvuconf',SQLCA.sqlcode,1)
         CALL s_errmsg('','','upd rvuconf',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF  
   END IF
   IF g_success='Y' THEN  #執行確認
      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant, 'rvv_file'), 
                  " WHERE rvv01 = '",l_rvu.rvu01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
      CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql       
      PREPARE pre_sel_rvv1 FROM l_sql
      DECLARE stw__s1_c CURSOR FOR pre_sel_rvv1
      FOREACH stw__s1_c INTO l_rvv.*
         IF STATUS THEN
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
      
         LET l_cnt=0
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_plant, 'img_file'),
                     "  WHERE img01 = '",l_rvv.rvv31,"'",   #料號
                     "    AND img02 = '",l_rvv.rvv32,"'",   #倉庫
                     "    AND img03 = '",l_rvv.rvv33,"'",   #儲位
                     "    AND img04 = '",l_rvv.rvv34,"'",   #批號
                     "    AND img18 < '",l_rvu.rvu03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
         CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
         PREPARE pre_sel_rvvcn FROM l_sql
         EXECUTE pre_sel_rvvcn INTO l_cnt  
         IF l_cnt > 0 THEN                         #異動日期大於有效日期
            #CALL cl_err(l_rvv.rvv32,'aim-400',0)   #須修改
            CALL s_errmsg('',l_rvv.rvv32,'','aim-400',1)
            LET g_success = 'N' 
            RETURN
         END IF      
 
         LET l_sql = "SELECT ima25 FROM ",cl_get_target_table(p_plant, 'ima_file'), #庫存單位
                     " WHERE ima01 = '",l_rvv.rvv31,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
         CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
         PREPARE pre_sel_ima25 FROM l_sql
         EXECUTE pre_sel_ima25 INTO l_ima25          
         #更新相關的檔案
         CALL t256_sub_bu(l_rvu.*,l_rvv.*,l_ima25,p_plant)
      END FOREACH
   END IF    
END FUNCTION

#更新相關的檔案
FUNCTION t256_sub_bu(l_rvu,l_rvv,p_ima25,p_plant)
   DEFINE l_img21        LIKE img_file.img21,
          l_img23        LIKE img_file.img23,
          l_img24        LIKE img_file.img24,
          l_pmn07        LIKE pmn_file.pmn07,
          l_sta          LIKE type_file.num5,          
          l_qty_ima      LIKE img_file.img10,
          l_qty_img      LIKE img_file.img10,
          l_qty1_ima     LIKE img_file.img10,
          l_qty1_img     LIKE img_file.img10,
          l_qty_rvv17    LIKE rvv_file.rvv17,
          l_rvv17        LIKE rvv_file.rvv17   
   DEFINE l_rvv          RECORD LIKE rvv_file.*
   DEFINE l_rvu          RECORD LIKE rvu_file.*
   DEFINE l_cnt          LIKE type_file.num10
   DEFINE p_ima25        LIKE ima_file.ima25
   DEFINE l_forupd_sql   STRING
   DEFINE l_fac          LIKE rvv_file.rvv35_fac
   DEFINE p_plant        LIKE azp_file.azp01
   DEFINE l_ima01        LIKE ima_file.ima01
   DEFINE l_sql          STRING
   #庫存資料
   LET l_forupd_sql = " SELECT img01,img02,img03,img04 FROM ",cl_get_target_table(p_plant, 'img_file'),
                      "  WHERE img01= ? ",
                      "    AND img02= ? ",
                      "    AND img03= ? ",
                      "    AND img04= ? ",
                      "    FOR UPDATE "
   #CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql         # FUN-B80085--mark--
   CALL cl_forupd_sql(l_forupd_sql) RETURNING l_forupd_sql             # FUN-B80085--add---        
   CALL cl_parse_qry_sql(l_forupd_sql, p_plant) RETURNING l_forupd_sql 
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)             
   DECLARE img_lock_bu CURSOR FROM l_forupd_sql

   OPEN img_lock_bu USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
   IF STATUS THEN
      #CALL cl_err("OPEN img_lock_bu:", STATUS, 1)
      CALL s_errmsg('','','OPEN img_lock_bu:',STATUS,1)
      CLOSE img_lock_bu
      LET g_success = 'N'
      RETURN
   END IF
   FETCH img_lock_bu INTO l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
   IF STATUS THEN
      CLOSE img_lock_bu 
      #CALL cl_err('img_lock_bu fail',STATUS,1) 
      CALL s_errmsg('','','img_lock_bu fail:',STATUS,1)
      LET g_success='N' 
      RETURN
   END IF

   LET l_sql = "SELECT img21,img23,img24 FROM ",cl_get_target_table(p_plant, 'img_file'),
               " WHERE img01 = '",l_rvv.rvv31,"'", 
               "   AND img02 = '",l_rvv.rvv32,"'",
               "   AND img03 = '",l_rvv.rvv33,"'", 
               "   AND img04 = '",l_rvv.rvv34,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
   PREPARE pre_sel_img1 FROM l_sql
   EXECUTE pre_sel_img1 INTO l_img21,l_img23,l_img24                      
   IF STATUS THEN
      #CALL cl_err3("sel","img_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","sel img",1)
      CALL s_errmsg('','','sel img_file:',SQLCA.sqlcode,1) 
      LET g_success='N'
      RETURN
   END IF  
   IF cl_null(l_img21) THEN LET l_img21=1 END IF   
   IF cl_null(l_rvv.rvv35_fac) THEN LET l_rvv.rvv35_fac=1 END IF 
   LET l_qty_img = l_rvv.rvv17                    #退貨總數(img_file)
   LET l_qty_ima = l_rvv.rvv17                    #退貨總數(ima_file)   
   LET l_qty1_img = l_rvv.rvv17 * l_rvv.rvv35_fac
   LET l_qty1_ima = l_qty1_img * l_img21
   #更新倉庫庫存明細資料
   CALL s_upimg1(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,0,l_qty1_img,l_rvv.rvv09,  
                 '','','','',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',0,0,'','',p_plant)  
   IF g_success = 'N' THEN
      #CALL cl_err('bu_upimg(-1)','9050',1) 
      #CALL s_errmsg('','','bu_upimg(-1):','9050',1)              #MOD-D30179 mark
      CALL s_errmsg('rvv31',l_rvv.rvv31,'bu_upimg(-1):','9050',1) #MOD-D30179 add
      RETURN
   END IF
   #鎖ima--str
   LET l_forupd_sql="SELECT ima01 FROM ",cl_get_target_table(p_plant, 'ima_file'), 
                    " WHERE ima01= ? FOR UPDATE "
   #CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql         # FUN-B80085--mark--  
   CALL cl_forupd_sql(l_forupd_sql) RETURNING l_forupd_sql             # FUN-B80085--add---
   CALL cl_parse_qry_sql(l_forupd_sql, p_plant) RETURNING l_forupd_sql                  
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)                           
   DECLARE ima_lock_1 CURSOR FROM l_forupd_sql 
   OPEN ima_lock_1 USING l_rvv.rvv31
   IF SQLCA.sqlcode THEN
      #CALL cl_err('lock ima fail',STATUS,1) 
      CALL s_errmsg('','','lock ima fail',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   FETCH ima_lock_1 INTO l_ima01
   IF SQLCA.sqlcode THEN
      #CALL cl_err('lock ima fail',STATUS,1) 
      CALL s_errmsg('','','lock ima fail',STATUS,1)
      LET g_success = 'N'
      RETURN 
   END IF
   #鎖ima--end

   #更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   IF s_udima1(l_rvv.rvv31,l_img23,l_img24,l_qty1_ima,l_rvu.rvu03,0,p_plant) THEN  
      RETURN
   END IF
   IF g_success = 'N' THEN
      RETURN
   END IF
   #產生異動記錄
   CALL t256_sub_log(l_rvv.*,p_ima25,p_plant)
   CALL t256_sub_update_tlff(l_rvv.*,p_plant)
   IF SQLCA.sqlcode THEN
      #CALL cl_err('tlf_file',SQLCA.sqlcode,1)
      CALL s_errmsg('','','tlf_file',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF   
   LET l_qty_rvv17 = l_rvv.rvv17 

   #更新採購單退貨量
   IF NOT cl_null(l_rvv.rvv36) AND l_rvv.rvv25='N' THEN
      LET l_sql = "SELECT SUM(rvv17) FROM ",cl_get_target_table(p_plant, 'rvv_file'),",",
                                            cl_get_target_table(p_plant, 'rvu_file'),     #計算倉退
                  " WHERE rvv36 = '",l_rvv.rvv36,"'",
                  "   AND rvv37 = '",l_rvv.rvv37,"'",
                  "   AND rvuconf ='Y' AND rvu00='3'", 
                  "   AND rvv01=rvu01 AND rvv25='N'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
      PREPARE pre_sel_rvv17 FROM l_sql
      EXECUTE pre_sel_rvv17 INTO l_rvv17
      IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF

      LET l_sql = "UPDATE ",cl_get_target_table(p_plant, 'pmn_file'),  
                  "   SET pmn58 = '",l_rvv17,"'",
                  " WHERE pmn01 = '",l_rvv.rvv36,"'",
                  "   AND pmn02 = '",l_rvv.rvv37,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
      PREPARE pre_upd_pmm58 FROM l_sql
      EXECUTE pre_upd_pmm58
      IF SQLCA.sqlcode THEN
         #CALL cl_err3("upd","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","upd pmn58:",1) 
         CALL s_errmsg('','','upd pmn_file',SQLCA.sqlcode,1) 
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION

#新增異動記錄
FUNCTION t256_sub_log(l_rvv,p_ima25,p_plant)
   DEFINE l_sta       LIKE type_file.num5,    
          l_flag      LIKE type_file.num5,   
          l_ima25_fac LIKE tlf_file.tlf60,
          l_img09     LIKE img_file.img09,       #庫存單位
          l_img10     LIKE img_file.img10,       #庫存數量
          l_img26     LIKE img_file.img26,
          l_pmn65     LIKE pmn_file.pmn65
   DEFINE l_rvv       RECORD LIKE rvv_file.*
   DEFINE p_plant     LIKE azp_file.azp01
   DEFINE p_ima25     LIKE ima_file.ima25
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_sql       STRING

   LET l_img09 = ''   
   LET l_img10 = ''   
   LET l_img26 = ''
  
   INITIALIZE g_tlf.* TO NULL

   LET g_tlf.tlf01  = l_rvv.rvv31             #異動料件編號
   LET g_tlf.tlf020 = g_plant                 #工廠別

   LET g_tlf.tlf02 = 50
   LET g_tlf.tlf021 = l_rvv.rvv32          #倉庫別
   LET g_tlf.tlf022 = l_rvv.rvv33          #儲位別
   LET g_tlf.tlf023 = l_rvv.rvv34          #批號
   LET g_tlf.tlf024 = l_img10              #異動後庫存數量
   LET g_tlf.tlf025 = p_ima25
   LET g_tlf.tlf026 = l_rvv.rvv01
   LET g_tlf.tlf027 = l_rvv.rvv02
   LET g_tlf.tlf03=31
   LET g_tlf.tlf031=' '                 #倉庫別
   LET g_tlf.tlf032=' '                 #儲位別
   LET g_tlf.tlf033=' '                 #批號
   LET g_tlf.tlf034=l_img10                #異動後存數量
   LET g_tlf.tlf035=' '                 #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_rvv.rvv04         #參考號碼(驗收單號)
   LET g_tlf.tlf037=l_rvv.rvv05
   
    #異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=l_rvv.rvv09          #日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=l_rvv.rvv17          #收料數量
    LET g_tlf.tlf11=l_rvv.rvv35          #收料單位
    LET g_tlf.tlf12=l_rvv.rvv35_fac      #收料/庫存轉換率
    #LET g_tlf.tlf13='artt255'           #異動命令代號
    LET g_tlf.tlf13='apmt1072'           #TQC-B30102
    LET g_tlf.tlf14= l_rvv.rvv26
    LET g_tlf.tlf16=' '                  #貸方
    LET g_tlf.tlf17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlf.tlf18           #異動後總庫存量
    LET g_tlf.tlf19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlf.tlf20= l_rvv.rvv34         #專案號碼

    LET l_sql = "SELECT ima25 FROM ",cl_get_target_table(p_plant, 'ima_file'), #庫存單位
                " WHERE ima01 = '",l_rvv.rvv31,"'",
                "   AND imaacti='Y'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
    CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
    PREPARE pre_sel1_ima25 FROM l_sql
    EXECUTE pre_sel1_ima25 INTO l_ima25    
    CALL s_umfchk1(l_rvv.rvv31,l_rvv.rvv35,l_ima25,p_plant)
         RETURNING l_flag,l_ima25_fac
    IF l_flag THEN
       #單位換算率抓不到#
       #CALL cl_err('rvv35/ima25: ','abm-731',1)
       CALL s_errmsg('','','rvv35/ima25:','abm-731',1) 
       LET g_success ='N'
       LET l_ima25_fac = 1.0
    END IF
    LET g_tlf.tlf60=l_ima25_fac
    LET g_tlf.tlf62= l_rvv.rvv36
    LET g_tlf.tlf63= l_rvv.rvv37
    LET g_tlf.tlf64 = l_rvv.rvv41 
    LET g_tlf.tlf930 = l_rvv.rvv930  
    LET g_tlf.tlf20 = ' '
    LET g_tlf.tlf41 = ' '
    LET g_tlf.tlf42 = ' '
    LET g_tlf.tlf43 = ' '
    CALL s_tlf1(1,0,p_plant)
END FUNCTION

FUNCTION t256_sub_update_tlff(l_rvv,p_plant)
   DEFINE l_ima25   LIKE ima_file.ima25,
          l_ima906  LIKE ima_file.ima906,
          l_ima907  LIKE ima_file.ima907
   DEFINE l_rvv     RECORD LIKE rvv_file.*
   DEFINE l_rvv83   LIKE rvv_file.rvv83
   DEFINE l_rvv84   LIKE rvv_file.rvv84
   DEFINE l_rvv85   LIKE rvv_file.rvv85
   DEFINE p_plant   LIKE azp_file.azp01
   DEFINE l_sql     STRING

   IF g_sma.sma115 = 'N' THEN RETURN END IF #是否使用雙單位

   LET l_sql = "SELECT ima906,ima907,ima25 FROM ",cl_get_target_table(p_plant, 'ima_file'), 
               " WHERE ima01 = '",l_rvv.rvv31,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
   PREPARE pre_sel_ima9  FROM l_sql
   EXECUTE pre_sel_ima9  INTO l_ima906,l_ima907,l_ima25 
   IF SQLCA.sqlcode THEN
      LET g_success='N' 
      RETURN     
   END IF
   IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         IF NOT cl_null(l_rvv.rvv85) THEN
            LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
            CALL t256_sub_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,l_ima25,l_ima906,p_plant)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         IF NOT cl_null(l_rvv.rvv82) THEN   
            LET l_rvv83=l_rvv.rvv80 LET l_rvv84=l_rvv.rvv81 LET l_rvv85=l_rvv.rvv82
            CALL t256_sub_tlff('1',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,l_ima25,l_ima906,p_plant)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         IF NOT cl_null(l_rvv.rvv85) THEN
            LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
            CALL t256_sub_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,l_ima25,l_ima906,p_plant)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
END FUNCTION

#新增異動記錄
FUNCTION t256_sub_tlff(p_flag,p_unit,p_fac,p_qty,l_rvv,p_ima25,p_ima906,p_plant)
   DEFINE p_unit       LIKE imgg_file.imgg09,
          p_flag       LIKE type_file.chr1,    
          p_fac        LIKE imgg_file.imgg21,
          p_qty        LIKE imgg_file.imgg10,
          l_sta        LIKE type_file.num5,    
          l_flag       LIKE type_file.num5,    
          l_ima25_fac  LIKE tlff_file.tlff60,
          l_imgg09     LIKE imgg_file.imgg09,       #庫存單位
          l_imgg10     LIKE imgg_file.imgg10,       #庫存數量
          l_imgg26     LIKE imgg_file.imgg26,
          l_pmn65      LIKE pmn_file.pmn65,
          l_return     LIKE rvb_file.rvb30
   DEFINE l_rvv        RECORD LIKE rvv_file.*
   DEFINE p_plant      LIKE azp_file.azp01
   DEFINE p_ima25      LIKE ima_file.ima25
   DEFINE p_ima906     LIKE ima_file.ima906
   DEFINE l_ima39      LIKE ima_file.ima39
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_ima907     LIKE ima_file.ima907
   DEFINE l_ima25      LIKE ima_file.ima25
   DEFINE l_sql        STRING

   LET l_sql = "SELECT imgg10,imgg26 FROM ",cl_get_target_table(p_plant, 'imgg_file'), 
               " WHERE imgg01 = '",l_rvv.rvv31,"'", 
               "   AND imgg02 = '",l_rvv.rvv32,"'", 
               "   AND imgg03 = '",l_rvv.rvv33,"'",  
               "    AND imgg04 = '",l_rvv.rvv34,"'", 
               "    AND imgg09 = '",p_unit,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
   PREPARE pre_sel_imgg  FROM l_sql
   EXECUTE pre_sel_imgg  INTO l_imgg10,l_imgg26
   IF SQLCA.sqlcode AND NOT (p_ima906='3' AND p_flag = '1') THEN
      #CALL cl_err('ckp#log',SQLCA.sqlcode,1) 
      CALL s_errmsg('','','ckp#log',SQLCA.sqlcode,1) 
      LET g_success = 'N' 
      RETURN
   END IF
   INITIALIZE g_tlff.* TO NULL

    LET g_tlff.tlff01  = l_rvv.rvv31             #異動料件編號
    LET g_tlff.tlff020 = g_plant                 #工廠別
    LET g_tlff.tlff02 = 50
    LET g_tlff.tlff021 = l_rvv.rvv32          #倉庫別
    LET g_tlff.tlff022 = l_rvv.rvv33          #儲位別
    LET g_tlff.tlff023 = l_rvv.rvv34          #批號
    LET g_tlff.tlff024 = l_imgg10             #異動後庫存數量
    LET g_tlff.tlff025 = p_ima25
    LET g_tlff.tlff026 = l_rvv.rvv01
    LET g_tlff.tlff027 = l_rvv.rvv02
    LET g_tlff.tlff03=31
    LET g_tlff.tlff031=' '                 #倉庫別
    LET g_tlff.tlff032=' '                 #儲位別
    LET g_tlff.tlff033=' '                 #批號
    LET g_tlff.tlff034=l_imgg10                #異動後存數量
    LET g_tlff.tlff035=' '                 #庫存單位(ima_file or imgg_file)
    LET g_tlff.tlff036=l_rvv.rvv04         #參考號碼(驗收單號)
    LET g_tlff.tlff037=l_rvv.rvv05
  
    # 異動數量
    LET g_tlff.tlff04=' '                  #工作站
    LET g_tlff.tlff05=' '                  #作業序號
    LET g_tlff.tlff06=l_rvv.rvv09          #日期
    LET g_tlff.tlff07=g_today              #異動資料產生日期
    LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user               #產生人
    LET g_tlff.tlff10=p_qty                #收料數量
    LET g_tlff.tlff11=p_unit               #收料單位
    LET g_tlff.tlff12=p_fac                #收料/庫存轉換率
    LET g_tlff.tlff13='apmt1072'           #異動命令代號
    LET g_tlff.tlff14= l_rvv.rvv26
    LET g_tlff.tlff16=' '                  #貸方
    LET g_tlff.tlff17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlff.tlff18           #異動後總庫存量
    LET g_tlff.tlff19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlff.tlff20= l_rvv.rvv34         #專案號碼

    LET l_ima906=NULL
    LET l_ima907=NULL
    LET l_sql = "SELECT ima25,ima906,ima907 FROM ",cl_get_target_table(p_plant, 'ima_file'), #庫存單位
                " WHERE ima01 = '",l_rvv.rvv31,"'",
                "   AND imaacti='Y'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
    CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql 
    PREPARE pre_sel1_ima FROM l_sql
    EXECUTE pre_sel1_ima INTO l_ima25,l_ima906,l_ima907 
    CALL s_umfchk1(l_rvv.rvv31,p_unit,l_ima25,p_plant)
         RETURNING l_flag,l_ima25_fac
    IF l_flag AND NOT (l_ima906='3' AND p_flag='2') THEN
       #單位換算率抓不到
       #CALL cl_err('rvv35/ima25: ','abm-731',1)
       CALL s_errmsg('','','rvv35/ima25:','abm-731',1) 
       LET g_success ='N'
       LET l_ima25_fac = 1.0
    END IF
    LET g_tlff.tlff60=l_ima25_fac
    LET g_tlff.tlff62= l_rvv.rvv36
    LET g_tlff.tlff63= l_rvv.rvv37
    LET g_tlff.tlff64 = l_rvv.rvv41 
    LET g_tlff.tlff930= l_rvv.rvv930   
    CALL s_tlff2(p_flag,NULL,p_plant)    
END FUNCTION
#FUN-BA0104 add START
#確認調撥單撥入倉庫/撥出倉庫/在途倉是否一致為非成本倉/成本倉
FUNCTION s_check(p_stock,p_plant)
DEFINE p_stock LIKE rup_file.rup09
DEFINE p_plant LIKE rup_file.rupplant
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_sql   STRING
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_plant, 'jce_file'),
               " WHERE jce02 = '",p_stock,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql
DISPLAY l_sql
   PREPARE pre_jce FROM l_sql
   EXECUTE pre_jce INTO l_cnt
   IF l_cnt >0 THEN
      LET g_flag = TRUE
   ELSE
      LET g_flag = FALSE
   END IF

    IF SQLCA.SQLCODE THEN
     #  CALL s_errmsg('',p_org,p_org,SQLCA.SQLCODE,1)
       LET g_flag = FALSE
    END IF

   RETURN g_flag
END FUNCTION
#FUN-BA0104 add END
#FUN-AA0086--end---
#FUN-AC0040 
#FUN-B90101--add--begin--
FUNCTION t256_ins_rupslk(l_ruo01)
DEFINE l_rup  RECORD LIKE rup_file.*
DEFINE l_rupslk RECORD LIKE rupslk_file.*
DEFINE l_imx000 LIKE imx_file.imx000
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_rup02  LIKE rup_file.rup02
DEFINE l_ima151 LIKE ima_file.ima151,
       l_imaag  LIKE ima_file.imaag,
       l_ruo01  LIKE ruo_file.ruo01

   SELECT COUNT(*) INTO l_cnt FROM rupslk_file
    WHERE rupslk01 = l_ruo01 AND rupslkplant = g_ruo.ruo05
   IF l_cnt>0 THEN
      RETURN
   END IF
   DECLARE t256_sel_rupslk CURSOR FOR 
      SELECT * FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01 AND rupslkplant = g_ruo.ruo04 ORDER BY rupslk02
   FOREACH t256_sel_rupslk INTO l_rupslk.*
      LET l_rupslk.rupslk01 =  l_ruo01
      LET l_rupslk.rupslkplant = g_ruo.ruo05
      CALL s_getlegal(g_ruo.ruo05) RETURNING l_rupslk.rupslklegal
      IF g_sma142_chk = "N" THEN    #非在途
         LET l_rupslk.rupslk18 = 'Y'
      ELSE
         LET l_rupslk.rupslk18 = 'N'
      END IF  
      INSERT INTO rupslk_file VALUES (l_rupslk.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("ins","rupslk_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","ins rupslk",1)
         LET g_success = 'N'
         RETURN
      END IF
      UPDATE rup_file SET rup20s = l_rupslk.rupslk03,
                          rup21s = l_rupslk.rupslk02
            WHERE rup01 = l_rupslk.rupslk01
              AND rupplant = l_rup.rupplant 
   END FOREACH
#  DECLARE t256_sel_rup CURSOR FOR
#   SELECT * FROM rup_file WHERE rup01 = l_ruo01 AND rupplant = g_ruo.ruo05
#  FOREACH t256_sel_rup INTO l_rup.*
#     SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=l_rup.rup03
#     IF l_ima151 = 'N' AND l_imaag = '@CHILD' THEN
#        SELECT imx00 INTO l_rupslk.rupslk03 FROM imx_file WHERE imx000 = l_rup.rup03
#     END IF
#     IF l_ima151 <> 'Y' AND (l_ima151<>'N' OR l_imaag<>'@CHILD') THEN
#        LET l_rupslk.rupslk03 = l_rup.rup03
#     END IF
#     SELECT COUNT(*) INTO l_cnt FROM rupslk_file
#      WHERE rupslk03 = l_rupslk.rupslk03 AND rupslk01 = l_rupslk.rupslk01
#     IF l_cnt<1 THEN
#        SELECT MAX(rupslk02)+1 INTO l_rupslk.rupslk02 FROM rupslk_file
#         WHERE rupslk01 = l_rupslk.rupslk01
#        IF cl_null(l_rupslk.rupslk02) THEN
#           LET l_rupslk.rupslk02 =1
#        END IF
#        LET l_rupslk.rupslk01= l_rup.rup01
#        LET l_rupslk.rupslk04= l_rup.rup04
#        LET l_rupslk.rupslk05= l_rup.rup05
#        LET l_rupslk.rupslk06= l_rup.rup06
#        LET l_rupslk.rupslk07= l_rup.rup07
#        LET l_rupslk.rupslk08= l_rup.rup08
#        LET l_rupslk.rupslk09= l_rup.rup09
#        LET l_rupslk.rupslk10= l_rup.rup10
#        LET l_rupslk.rupslk11= l_rup.rup11
#        LET l_rupslk.rupslk12= l_rup.rup12
#        LET l_rupslk.rupslk13= l_rup.rup13
#        LET l_rupslk.rupslk14= l_rup.rup14
#        LET l_rupslk.rupslk15= l_rup.rup15
#        LET l_rupslk.rupslk16= l_rup.rup16
#        LET l_rupslk.rupslk17= l_rup.rup17
#        LET l_rupslk.rupslk18= l_rup.rup18
#        LET l_rupslk.rupslk19= l_rup.rup19
#        LET l_rupslk.rupslk20= l_rup.rup20
#        LET l_rupslk.rupslk21= l_rup.rup21
#        LET l_rupslk.rupslk22= l_rup.rup22
#        LET l_rupslk.rupslklegal = l_rup.ruplegal
#        LET l_rupslk.rupslkplant = l_rup.rupplant  
#        IF l_ima151 = 'N' AND l_imaag = '@CHILD' THEN
#           SELECT SUM(rup12),SUM(rup16),SUM(rup19) INTO l_rupslk.rupslk12,l_rupslk.rupslk16,l_rupslk.rupslk19
#              FROM rup_file,imx_file WHERE rup01 = l_rupslk.rupslk01
#                                       AND imx000= rup03
#                                       AND rup03 = l_rup.rup03
#                                       GROUP BY imx00
#        END IF
#        INSERT INTO rupslk_file (rupslk01,rupslk02,rupslk03,rupslk04,rupslk05,rupslk06,rupslk07,
#                                 rupslk08,rupslk09,rupslk10,rupslk11,rupslk12,rupslk13,
#                                 rupslk14,rupslk15,rupslk16,rupslk17,rupslk18,rupslk19,
#                                 rupslk20,rupslk21,rupslk22,rupslkplant,rupslklegal)
#                 VALUES(l_rupslk.rupslk01,l_rupslk.rupslk02,l_rupslk.rupslk03,
#                        l_rupslk.rupslk04,l_rupslk.rupslk05,l_rupslk.rupslk06,
#                        l_rupslk.rupslk07,l_rupslk.rupslk08,l_rupslk.rupslk09,
#                        l_rupslk.rupslk10,l_rupslk.rupslk11,l_rupslk.rupslk12,
#                        l_rupslk.rupslk13,l_rupslk.rupslk14,l_rupslk.rupslk15,
#                        l_rupslk.rupslk16,l_rupslk.rupslk17,l_rupslk.rupslk18,
#                        l_rupslk.rupslk19,l_rupslk.rupslk20,l_rupslk.rupslk21,
#                        l_rupslk.rupslk22,l_rupslk.rupslkplant,l_rupslk.rupslklegal) 
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("ins","rupslk_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","ins rupslk",1)
#           LET g_success = 'N'
#           RETURN
#        END IF
#        UPDATE rup_file SET rup20s = l_rupslk.rupslk03,
#                            rup21s = l_rupslk.rupslk02
#           WHERE rupslk01 = l_rup.rup01
#             AND rupslkplant = l_rup.rupplant
#     ELSE
#        UPDATE rupslk_file
#           SET rupslk12 = rupslk12+l_rup.rup12,
#               rupslk16 = rupslk16+l_rup.rup16,
#               rupslk19 = rupslk16+l_rup.rup19
#         WHERE rupslk01 = l_rupslk.rupslk01
#           AND rupslk03 = l_rupslk.rupslk03
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("upd","rup_file",l_ruo01,"",SQLCA.sqlcode,"","upd rup",1)
#           LET g_success = 'N'   
#           RETURN
#        END IF
#     END IF
#  END FOREACH
END FUNCTION
#FUN-B90101--add--end--
#FUN-CC0057-----add-----str
FUNCTION t256_sub_ins_rxg(p_ruo)
DEFINE l_sql           STRING
DEFINE l_rup           RECORD LIKE rup_file.*
DEFINE l_rxg           RECORD LIKE rxg_file.*
DEFINE l_rvm03         LIKE rvm_file.rvm03
DEFINE l_rtz07         LIKE rtz_file.rtz07
DEFINE l_ruc08         LIKE ruc_file.ruc08
DEFINE l_ruc09         LIKE ruc_file.ruc09
DEFINE p_ruo           RECORD LIKE ruo_file.*
DEFINE l_sql1          STRING

   
   INITIALIZE l_rxg.* TO NULL

   IF p_ruo.ruo02 NOT MATCHES '[389]' THEN
      RETURN
   END IF
   IF g_flag = '1' THEN
      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_ruo.ruo05,'ruo_file'),
                  " WHERE ruo01 = '",p_ruo.ruo011,"'",
                  "   AND ruoplant = '",p_ruo.ruo05,"' "
      PREPARE sel_ruo FROM l_sql
      EXECUTE sel_ruo INTO p_ruo.*
   END IF
  #LET l_sql = "SELECT rup01,rup02,rup03,rup07,rup13,rup14,rup15,rup16,rup22,rup17 FROM rup_file",                                        #FUN-CC0082 Mark
   LET l_sql = "SELECT rup01,rup02,rup03,rup07,rup13,rup14,rup15,rup16,rup22,rup17 FROM ",cl_get_target_table(p_ruo.ruoplant,'rup_file'), #FUN-CC0082 Add
               " WHERE rup01 = '",p_ruo.ruo01,"'",
               "   AND rup22 <> '",p_ruo.ruo05,"'"
   DECLARE sel_rup_cs CURSOR FROM l_sql
   FOREACH sel_rup_cs INTO l_rup.rup01,l_rup.rup02,l_rup.rup03,l_rup.rup07,l_rup.rup13,
                           l_rup.rup14,l_rup.rup15,l_rup.rup16,l_rup.rup22,l_rup.rup17
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF cl_null(l_rup.rup14) THEN LET l_rup.rup14 = ' ' END IF
      IF cl_null(l_rup.rup15) THEN LET l_rup.rup15 = ' ' END IF
      LET l_rxg.rxg01 = l_rup.rup03
      LET l_rxg.rxg02 = g_today
      LET l_rxg.rxg03 = g_today
      LET l_rxg.rxg04 = '1'
      LET l_rxg.rxg05 = l_rup.rup01
      LET l_rxg.rxg06 = l_rup.rup02
      LET l_rxg.rxg07 = (-1)*l_rup.rup16
      LET l_rxg.rxg08 = l_rup.rup07
      LET l_rxg.rxg09 = l_rup.rup13
      LET l_rxg.rxg10 = l_rup.rup14
      LET l_rxg.rxg11 = l_rup.rup15
      IF p_ruo.ruo02 = '8' THEN
         SELECT ruc08,ruc09 INTO l_ruc08,l_ruc09
           FROM ruc_file
          WHERE ruc02 = p_ruo.ruo03
            AND ruc03 = l_rup.rup17
            AND ruc07 <> '1'
      END IF
      IF p_ruo.ruo02 = '3' THEN
         LET l_sql = "SELECT ruc08,ruc09,rvm03 ",
                     "  FROM ruc_file,",cl_get_target_table(p_ruo.ruo04,'rvn_file'),
                     "               ,",cl_get_target_table(p_ruo.ruo04,'rvm_file'),
                     " WHERE rvn03 = ruc02 ",
                     "   AND rvn04 = ruc03 ",
                     "   AND rvn01 = '",p_ruo.ruo03,"' ",
                     "   AND rvn02 = '",l_rup.rup17,"' ",
                     "   AND ruc07 <> '1' ",
                     "   AND rvm01 = rvn01 "
         PREPARE sel_ruc_rvm_pre FROM l_sql
         EXECUTE sel_ruc_rvm_pre INTO l_ruc08,l_ruc09,l_rvm03
      END IF
      IF p_ruo.ruo02 = '9' THEN
         LET l_sql = "SELECT ogb31,ogb32 FROM ",cl_get_target_table(p_ruo.ruo05,'ogb_file'),
                     " WHERE ogb01 = '",p_ruo.ruo03,"' ",
                     "   AND ogb03 = '",l_rup.rup17,"' "
         PREPARE sel_ogb31_ogb32_pre FROM l_sql
         EXECUTE sel_ogb31_ogb32_pre INTO l_ruc08,l_ruc09
         LET l_rxg.rxg15 = NULL
      END IF
      LET l_rxg.rxg12 = l_ruc08
      LET l_rxg.rxg13 = l_ruc09
      IF p_ruo.ruo02 = '3' THEN
         LET l_rxg.rxg14 = p_ruo.ruo03
         LET l_rxg.rxg15 = l_rup.rup17
         LET l_rxg.rxg16 = l_rvm03
      END IF
      LET l_rxg.rxg17 = p_ruo.ruo05
      LET l_rxg.rxg18 = l_rup.rup22
      LET l_rxg.rxgplant = p_ruo.ruo05
      SELECT azw02 INTO l_rxg.rxglegal FROM azw_file WHERE azw01 = l_rxg.rxgplant
      SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = l_rup.rup22
      LET l_sql1 = "INSERT INTO ",cl_get_target_table(l_rxg.rxgplant,'rxg_file'),"(",
                   "   rxg01,rxg02,rxg03,rxg04,rxg05,rxg06,rxg07,rxg08,rxg09,rxg10,rxg11,",
                   "   rxg12,rxg13,rxg14,rxg15,rxg16,rxg17,rxg18,rxgplant,rxglegal)",
                   "   VALUES(?,?,?,?,?, ?,?,?,?,?,",
                   "          ?,?,?,?,?, ?,?,?,?,?)"
      PREPARE ins_rxg_cs FROM  l_sql1
      EXECUTE ins_rxg_cs USING l_rxg.rxg01,l_rxg.rxg02,l_rxg.rxg03,l_rxg.rxg04,l_rxg.rxg05,
                               l_rxg.rxg06,l_rxg.rxg07,l_rxg.rxg08,l_rxg.rxg09,l_rxg.rxg10,
                               l_rxg.rxg11,l_rxg.rxg12,l_rxg.rxg13,l_rxg.rxg14,l_rxg.rxg15,
                               l_rxg.rxg16,l_rxg.rxg17,l_rxg.rxg18,l_rxg.rxgplant,l_rxg.rxglegal
      LET l_rxg.rxg07 = l_rup.rup16
      LET l_rxg.rxg09 = l_rtz07
      LET l_rxg.rxg10 = ' '
      LET l_rxg.rxg11 = ' '
      LET l_rxg.rxgplant = l_rup.rup22
      SELECT azw02 INTO l_rxg.rxglegal FROM azw_file WHERE azw01 =  l_rxg.rxgplant
      LET l_sql1 = "INSERT INTO ",cl_get_target_table(l_rxg.rxgplant,'rxg_file'),"(",
                   "   rxg01,rxg02,rxg03,rxg04,rxg05,rxg06,rxg07,rxg08,rxg09,rxg10,rxg11,",
                   "   rxg12,rxg13,rxg14,rxg15,rxg16,rxg17,rxg18,rxgplant,rxglegal)",
                   "   VALUES(?,?,?,?,?, ?,?,?,?,?,",
                   "          ?,?,?,?,?, ?,?,?,?,?)"
      PREPARE ins_rxg_cs2 FROM  l_sql1
      EXECUTE ins_rxg_cs2 USING l_rxg.rxg01,l_rxg.rxg02,l_rxg.rxg03,l_rxg.rxg04,l_rxg.rxg05,
                                l_rxg.rxg06,l_rxg.rxg07,l_rxg.rxg08,l_rxg.rxg09,l_rxg.rxg10,
                                l_rxg.rxg11,l_rxg.rxg12,l_rxg.rxg13,l_rxg.rxg14,l_rxg.rxg15,
                                l_rxg.rxg16,l_rxg.rxg17,l_rxg.rxg18,l_rxg.rxgplant,l_rxg.rxglegal
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins rxg:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-CC0057-----add-----end
