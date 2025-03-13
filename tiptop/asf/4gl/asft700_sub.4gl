# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: asft700_sub.4gl
# Descriptions...: 存放asft700相關函數
# Date & Author..: 10/09/01 by kim (#FUN-A80102)
# Modify.........: No:FUN-A80060 10/09/28 By jan GP5.25工單間合拼  
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.MOD-AC0336 10/12/28 By jan 重抓製程料號
# Modify.........: No.FUN-B10054 11/01/21 By jan 報工單工時重算
# Modify.........: No.TQC-B20161 11/02/23 By jan rva33給預設值
# Modify.........: No.CHI-B40021 11/02/23 By jan 使用"關鍵點報工"時，計算在製量有誤
# Modify.........: No.CHI-B40065 11/04/28 By shenyang 修改p700sub_pmn(
# Modify.........: No.FUN-B50046 11/05/10 By Abby GP5.25 APS追版 str----------
# Modify.........: No:FUN-960106 09/07/03 By Duke 鎖定設備相關設定
# Modify.........: No:FUN-990094 09/10/05 By Mandy (1)回報鎖定設備未完成量調整
#                                                  (2)刪除生產日報後,良品轉出量(vne311)應減少才對
# Modify.........: No.FUN-B50046 11/05/10 By Abby GP5.25 APS追版 end----------
# Modify.........: No:FUN-B30177 11/05/24 By lixiang INSERT INTO pmn_file時，如果pmn58為null則給'0'
# Modify.........: No:TQC-B50143 11/05/25 By jan 修正刪除BUG
# Modify.........: No:FUN-A70095 11/06/02 By lixh1 新增確認,取消確認段邏輯
# Modify.........: No.TQC-B60153 11/06/17 By lixh1 修改asf-802報錯時機
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:TQC-B80180 11/08/25 By jan 上下製程段抓取應從ecm_file抓
# Modify.........: No:FUN-BB0083 11/11/28 By xujing 增加數量欄位小數取位
# Modify.........: NO.FUN-BC0104 12/01/12 By xianghui 增加一個WHERE條件
# Modify.........: No:FUN-BB0086 12/01/19 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C20007 12/02/02 By zhangll 报工单取消审核时应考虑入库量
# Modify.........: No:MOD-BB0314 12/02/17 By bart asms270參數啟用關鍵製成報工功能時，在打報工單的wip量會異常
# Modify.........: No:TQC-C20298 12/02/20 By destiny where条件错误     
# Modify.........: No:TQC-C20361 12/02/23 By lixh1 更改WIP 計算方式
# Modify.........: No:MOD-C30620 12/02/23 By jan 委外入庫在產生報工單時，WIP量會為0造成無法報工
# Modify.........: No:CHI-BA0039 12/03/13 By ck2yuan 確認時不應控卡當站下線數量與asft701一致
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t110sub_y_chk參數
# Modify.........: No:MOD-C60147 12/07/19 By ck2yuan 修正TQC-C10122修改方向
# Modify.........: No:MOD-C70242 12/07/24 By suncx 產生委外採購單時，應該判斷l_ecm.ecm52<>'Y'
# Modify.........: No:MOD-C80032 12/08/06 By Elise 已確認不可再確認，應出現"此單據已確認"
# Modify.........: No:CHI-C60008 12/08/15 By ck2yuan 將 t701_update img,ima,tlf部分移至確認與取消確認段
# Modify.........: No:MOD-CB0209 12/12/17 By Elise 最後一站轉出時，轉出數量若大於最小發料套數show錯誤訊息
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-C30163 12/12/18 By pauline CALL q_ecm(時增加參數
# Modify.........: No:MOD-D20173 13/03/07 By bart 標準工時/標準機時除以生產數量sfb08
# Modify.........: No:MOD-C90058 13/03/08 By ck2yuan 委外完工數 應是 所有的轉出數量,不應只有良品轉出數量
# Modify.........: No:MOD-D30233 13/03/27 By bart 將t700_chk_input移到asft700.4gl
# Modify.........: No:FUN-D40092 13/04/25 By lixiang 當然入庫對庫存的異動放在審核和取消審核段
# Modify.........: No:MOD-D60212 13/06/26 By suncx 管控報廢量不可大於總PQC送檢數量-PQC合格數量-已報廢數量
# Modify.........: No:MOD-D60236 13/06/28 By suncx 还原CHI-BA0039修改內容
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

DATABASE ds        
 
GLOBALS "../../config/top.global"

#FUN-D40092--add---begin---
DEFINE g_img09   LIKE img_file.img09,
       g_img21   LIKE img_file.img21
DEFINE g_shd     RECORD LIKE shd_file.*,
       g_ima86   LIKE ima_file.ima86,
       g_ima918  LIKE ima_file.ima918,
       g_ima921  LIKE ima_file.ima921
#FUN-D40092--add---end----

#
#作用:lock cursor
#回傳值:無
#
#FUN-A70095 -------------------Begin---------------------
FUNCTION t700sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM shb_file WHERE shb01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t700sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
#FUN-A70095 -------------------End----------------------
# Update 製程追蹤檔  #FUN-A80102
FUNCTION t700sub_upd_ecm(p_cmd,l_shb)
DEFINE l_vne03  LIKE vne_file.vne03     #FUN-870092 add
DEFINE l_vne06  LIKE vne_file.vne06     #FUN-870092 add
DEFINE p_cmd    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
       l_shi    RECORD LIKE shi_file.*,
       l_ecm03  LIKE ecm_file.ecm03,
       l_ecm03n LIKE ecm_file.ecm03,
       l_ecm322 LIKE ecm_file.ecm322,
       l_final  LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)   #終站否
DEFINE l_sum    LIKE qcm_file.qcm091,   #No.FUN-680121 DEC(12,3),
       l_factor LIKE ecm_file.ecm59,    #No.FUN-680121 DEC(16,8),
       l_cnt    LIKE type_file.num5,    #No.FUN-680121 SMALLINT
       l_ecm57a LIKE ecm_file.ecm57,    #當站在制單位  #No.FUN-760108
       l_ecm57  LIKE ecm_file.ecm57,
       l_ecm58  LIKE ecm_file.ecm58,
       l_ecm51  LIKE ecm_file.ecm51
DEFINE l_qty    LIKE shb_file.shb111    #FUN-A50066
DEFINE l_ecm012,l_ecm012n             LIKE ecm_file.ecm012  #FUN-A50066
DEFINE l_ecm62_a,l_ecm62_b,l_ecm62_c  LIKE ecm_file.ecm62   #FUN-A50066
DEFINE l_ecm63_a,l_ecm63_b,l_ecm63_c  LIKE ecm_file.ecm63   #FUN-A50066
DEFINE l_sfb05  LIKE sfb_file.sfb05     #FUN-A50066
DEFINE l_sfb06  LIKE sfb_file.sfb06     #FUN-A50066
DEFINE l_shb    RECORD LIKE shb_file.*  #FUN-A80102
DEFINE l_ecm    RECORD LIKE ecm_file.*  #FUN-A80102
DEFINE g_cnt2          LIKE type_file.num10   #FUN-960106 ADD
DEFINE g_re_dis_vne06 LIKE type_file.num20    #FUN-990094 add
DEFINE l_ecm58_1       LIKE ecm_file.ecm58    #No.FUN-BB0086

   # 抓下製程
   #FUN-A50066--begin--modify--------------------
   # LET l_ecm03=''
   # LET l_final='N'
   # SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
   #  WHERE ecm01=l_shb.shb05   #工單單號
   #    AND ecm03>l_shb.shb06
   # IF cl_null(l_ecm03)
   #    THEN
   #    LET l_final='Y'
   # END IF 
   IF cl_null(l_shb.shb012) THEN LET l_shb.shb012=' ' END IF #FUN-A60095
   #FUN-A80102(S)
   SELECT * INTO l_ecm.* FROM ecm_file WHERE ecm01 =l_shb.shb05 
                                         AND ecm012=l_shb.shb012
                                         AND ecm03 =l_shb.shb06
   #FUN-A80102(E)
   CALL t700sub_next_ecm03(l_shb.*) RETURNING l_sfb05,l_sfb06,l_ecm012,l_ecm03,l_final  #FUN-A50066
   #抓取本站的組成用量,底數
   SELECT ecm62,ecm63 INTO l_ecm62_a,l_ecm63_a FROM ecm_file WHERE ecm01=l_shb.shb05
      AND ecm03=l_shb.shb06 AND ecm012=l_shb.shb012
   #抓取下站的組成用量,底數
   SELECT ecm62,ecm63 INTO l_ecm62_b,l_ecm63_b FROM ecm_file WHERE ecm01=l_shb.shb05
      AND ecm03=l_ecm03 AND ecm012=l_ecm012
   IF cl_null(l_ecm62_a) THEN LET l_ecm62_a=1 END IF #FUN-A70143
   IF cl_null(l_ecm63_a) THEN LET l_ecm63_a=1 END IF #FUN-A70143
   IF cl_null(l_ecm62_b) THEN LET l_ecm62_b=1 END IF #FUN-A70143
   IF cl_null(l_ecm63_b) THEN LET l_ecm63_b=1 END IF #FUN-A70143
   #FUN-A50066--end--modify-----------------------
 
#...委外時->委外完工數量須異動
    IF NOT cl_null(l_shb.shb14) THEN   #委外入庫單 !=space
      #LET l_ecm322 = l_shb.shb111                                                      #MOD-C90058 mark
       LET l_ecm322 = l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb17   #MOD-C90058 add
    ELSE
       LET l_ecm322 = 0
    END IF
 
    CALL cl_msg("asft700: update ecm_file .............")
 
    CASE p_cmd
         WHEN 'a'
#.......................檢查轉出量....................................
              SELECT (ecm311+ecm312+ecm313+ecm314+ecm316),ecm51
                INTO l_sum,l_ecm51
               FROM ecm_file
              WHERE ecm01 = l_shb.shb05
                AND ecm03 = l_shb.shb06
                AND ecm012= l_shb.shb012  #FUN-A50066
                
              #No.FUN-BB0086--add--begin---
              SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
              WHERE ecm01=l_shb.shb05   
              AND ecm03=l_shb.shb06       
              AND ecm012=l_shb.shb012
              LET l_shb.shb111 = s_digqty(l_shb.shb111,l_ecm58_1)
              LET l_shb.shb113 = s_digqty(l_shb.shb113,l_ecm58_1)
              LET l_shb.shb112 = s_digqty(l_shb.shb112,l_ecm58_1)
              LET l_shb.shb114 = s_digqty(l_shb.shb114,l_ecm58_1)
              LET l_shb.shb115 = s_digqty(l_shb.shb115,l_ecm58_1)
              LET l_shb.shb17 = s_digqty(l_shb.shb17,l_ecm58_1)
              LET l_ecm322 = s_digqty(l_ecm322,l_ecm58_1)
              #No.FUN-BB0086--add--end---
              IF l_sum = 0 OR cl_null(l_sum) THEN   #表第一站
                 UPDATE ecm_file SET ecm311=ecm311+l_shb.shb111, #良品轉出
                                     ecm312=ecm312+l_shb.shb113, #重工轉出
                                     ecm313=ecm313+l_shb.shb112, #當站報廢
                                     ecm314=ecm314+l_shb.shb114, #當站下線
                                     ecm315=ecm315+l_shb.shb115, #Bonus
                                     ecm316=ecm316+l_shb.shb17,
                                     ecm322=ecm322+l_ecm322,     #委外完工量
                                          #.委外時->委外完工數量(ecm322)增加
                                     ecm50 = l_shb.shb02,  #開工日期
                                     ecm51 = l_shb.shb03,  #完工日
                                     ecm25 = l_shb.shb021, #開工時間
                                     ecm26 = l_shb.shb031  #完工時間
                  WHERE ecm01=l_shb.shb05   #工單單號
                    AND ecm03=l_shb.shb06   #本製程序
                    AND ecm012=l_shb.shb012 #本製程段 #FUN-A50066
                 IF STATUS OR SQLCA.SQLERRD[3]=0
                    THEN
                    CALL cl_err('Update ecm_file:#1',STATUS,1)
                    LET g_success='N'
                 END IF
                 IF g_sma.sma901 = 'Y' THEN    #有串APS
                     IF l_ecm.ecm61 = 'Y' THEN #有平行加工
                        #FUN-960106 MARK --STR----------------------------
                        # UPDATE vlj_file SET vlj311=vlj311+g_shb.shb111, #良品轉出
                        #                     vlj312=vlj312+g_shb.shb113, #重工轉出
                        #                     vlj313=vlj313+g_shb.shb112, #當站報廢
                        #                     vlj314=vlj314+g_shb.shb114, #當站下線
                        #                     vlj315=vlj315+g_shb.shb115, #Bonus
                        #                     vlj316=vlj316+g_shb.shb17,
                        #                    #vlj322=vlj322+l_ecm322,     #委外完工量
                        #                    #     #.委外時->委外完工數量(vlj322)增加
                        #                     vlj50 = g_shb.shb02,  #開工日期
                        #                     vlj51 = g_shb.shb03,  #完工日
                        #                     #no.4621 add vlj25,vlj26
                        #                     vlj25 = g_shb.shb021, #開工時間
                        #                     vlj26 = g_shb.shb031  #完工時間
                        #                     #no.4621 add (end)
                        #  WHERE vlj01=g_shb.shb05   #工單單號
                        #    AND vlj02=g_sma.sma917  #資源型態
                        #    AND vlj03=g_shb.shb06   #本製程序
                        #    AND vlj06=g_shb.shb09   #資源編號
                        #FUN-960106 MARK --END----------------------------
                        #FUN-960106 ADD --STR-----------------------------
                         UPDATE vne_file SET vne311=vne311+l_shb.shb111, #良品轉出
                                             vne312=vne312+l_shb.shb113, #重工轉出
                                             vne313=vne313+l_shb.shb112, #當站報廢
                                             vne314=vne314+l_shb.shb114, #當站下線
                                             vne315=vne315+l_shb.shb115, #Bonus
                                             vne316=vne316+l_shb.shb17,  #工單轉出
                                             vne50 = l_shb.shb02,  #開工日期
                                             vne51 = l_shb.shb03,  #完工日期
                                             vne25 = l_shb.shb021, #開工時間
                                             vne26 = l_shb.shb031  #完工時間
                           WHERE vne01=l_shb.shb05
                             AND vne02=l_shb.shb05
                             AND vne03=l_shb.shb06
                             AND vne05=l_shb.shb09
                             AND vne012=l_shb.shb012 #本製程段  
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                             CALL cl_err('Update vlj_file:#1',STATUS,1)
                             LET g_success='N'
                         END IF
                     END IF
 
                     #==>更新vne_file的未完成量
                     LET l_vne03 = l_shb.shb06
                     SELECT vne06 INTO l_vne06
                       FROM vne_file
                      WHERE vne01 = l_shb.shb05 #製令編號
                        AND vne02 = l_shb.shb05 #途程編號
                        AND vne03 = l_vne03     #加工序號
                        AND vne04 = l_ecm.ecm04 #作業編號
                        AND vne05 = l_shb.shb09 #資源編號
                        AND vne012=l_shb.shb012 #本製程段
                     IF NOT cl_null(l_vne06) THEN
                         LET l_vne06 = l_vne06 - (l_shb.shb111+l_shb.shb113+l_shb.shb112+l_shb.shb114+l_shb.shb115+l_shb.shb17)
                         IF l_vne06 < 0 THEN
                             LET g_re_dis_vne06 = l_vne06 *(-1) #FUN-990094 add
                             LET l_vne06 = 0 
                         END IF
                         UPDATE vne_file
                            SET vne06 = l_vne06
                          WHERE vne01 = l_shb.shb05 #製令編號
                            AND vne02 = l_shb.shb05 #途程編號
                            AND vne03 = l_vne03     #加工序號
                            AND vne04 = l_ecm.ecm04 #作業編號
                            AND vne05 = l_shb.shb09 #資源編號
                            AND vne012=l_shb.shb012 #本製程段 
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                             CALL cl_err('Update vne_file:#1',STATUS,1)
                             LET g_success='N'
                         END IF
                     END IF
                 END IF
              ELSE
                 UPDATE ecm_file SET ecm311=ecm311+l_shb.shb111, #良品轉出
                                     ecm312=ecm312+l_shb.shb113, #重工轉出
                                     ecm313=ecm313+l_shb.shb112, #當站報廢
                                     ecm314=ecm314+l_shb.shb114, #當站下線
                                     ecm315=ecm315+l_shb.shb115, #Bonus
                                     ecm316=ecm316+l_shb.shb17,
                                     ecm322=ecm322+l_ecm322,      #委外完工量
                                            #.委外時->委外完工數量(ecm322)增加
                                     ecm50 = l_shb.shb02,  #開工日期
                                     ecm51 = l_shb.shb03,  #完工日
                                     ecm25 = l_shb.shb021, #開工時間
                                     ecm26 = l_shb.shb031  #完工時間
                  WHERE ecm01=l_shb.shb05   #工單單號
                    AND ecm03=l_shb.shb06   #本製程序
                    AND ecm012=l_shb.shb012 #本製程段  #FUN-A50066
                 IF STATUS OR SQLCA.SQLERRD[3]=0
                    THEN
                    CALL cl_err('Update ecm_file:#1',STATUS,1)
                    LET g_success='N'
                 END IF
 
                 IF g_sma.sma901 = 'Y' THEN    #有串APS
                     IF l_ecm.ecm61 = 'Y' THEN #有平行加工
                        #FUN-960106 MARK --STR----------------------------
                        # UPDATE vlj_file SET vlj311=vlj311+g_shb.shb111, #良品轉出
                        #                     vlj312=vlj312+g_shb.shb113, #重工轉出
                        #                     vlj313=vlj313+g_shb.shb112, #當站報廢
                        #                     vlj314=vlj314+g_shb.shb114, #當站下線
                        #                     vlj315=vlj315+g_shb.shb115, #Bonus
                        #                     vlj316=vlj316+g_shb.shb17,
                        #                    #vlj322=vlj322+l_ecm322,      #委外完工量
                        #                    #       #.委外時->委外完工數量(vlj322)增加
                        #                     vlj50 = g_shb.shb02,  #開工日期
                        #                     vlj51 = g_shb.shb03,  #完工日
                        #                     #no.4621 add vlj25,vlj26
                        #                     vlj25 = g_shb.shb021, #開工時間
                        #                     vlj26 = g_shb.shb031  #完工時間
                        #                     #no.4621 add (end)
                        #  WHERE vlj01=g_shb.shb05   #工單單號
                        #    AND vlj02=g_sma.sma917  #資源型態
                        #    AND vlj03=g_shb.shb06   #本製程序
                        #    AND vlj06=g_shb.shb09   #資源編號
                        #FUN-960106 MARK --END-----------------------------
                        #FUN-960106 ADD --STR------------------------------
                         UPDATE vne_file SET vne311=vne311+l_shb.shb111, #良品轉出
                                             vne312=vne312+l_shb.shb113, #重工轉出
                                             vne313=vne313+l_shb.shb112, #當站報廢
                                             vne314=vne314+l_shb.shb114, #當站下線
                                             vne315=vne315+l_shb.shb115, #Bonus
                                             vne316=vne316+l_shb.shb17,  #工單轉出
                                             vne50 = l_shb.shb02,  #開工日期
                                             vne51 = l_shb.shb03,  #完工日期
                                             vne25 = l_shb.shb021, #開工時間
                                             vne26 = l_shb.shb031  #完工時間
                          WHERE vne01=l_shb.shb05
                            AND vne02=l_shb.shb05
                            AND vne03=l_shb.shb06
                            AND vne05=l_shb.shb09
                            AND vne012=l_shb.shb012 #本製程段
                        #FUN-960106 ADD --END------------------------------

                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                             CALL cl_err('Update vlj_file:#2',STATUS,1)
                             LET g_success='N'
                         END IF
                     END IF
 
                     #==>更新vne_file的未完成量
                     LET l_vne03 = l_shb.shb06
                     SELECT vne06 INTO l_vne06
                       FROM vne_file
                      WHERE vne01 = l_shb.shb05 #製令編號
                        AND vne02 = l_shb.shb05 #途程編號
                        AND vne03 = l_vne03     #加工序號
                        AND vne04 = l_ecm.ecm04 #作業編號
                        AND vne05 = l_shb.shb09 #資源編號
                        AND vne012=l_shb.shb012 #本製程段 #FUN-960106 
                     IF NOT cl_null(l_vne06) THEN
                         LET l_vne06 = l_vne06 - (l_shb.shb111+l_shb.shb113+l_shb.shb112+l_shb.shb114+l_shb.shb115+l_shb.shb17)
                         IF l_vne06 < 0 THEN
                             LET g_re_dis_vne06 = l_vne06 *(-1) #FUN-990094 add
                             LET l_vne06 = 0 
                         END IF
                         UPDATE vne_file
                            SET vne06 = l_vne06
                          WHERE vne01 = l_shb.shb05 #製令編號
                            AND vne02 = l_shb.shb05 #途程編號
                            AND vne03 = l_vne03     #加工序號
                            AND vne04 = l_ecm.ecm04 #作業編號
                            AND vne05 = l_shb.shb09 #資源編號
                            AND vne012=l_shb.shb012 #本製程段   
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                             CALL cl_err('Update vne_file:#2',STATUS,1)
                             LET g_success='N'
                         END IF
                     END IF
                 END IF
              END IF
 
              IF l_final='N'  #非終站
                 THEN   #良品轉入
                 #FUN-A50066--begin--modify------------------------------------
                 #SELECT ecm58 INTO l_ecm57a FROM ecm_file
                 # WHERE ecm01=l_shb.shb05
                 #   AND ecm03=l_shb.shb06
 
                 #SELECT ecm57 INTO l_ecm57 FROM ecm_file
                 # WHERE ecm01=l_shb.shb05
                 #   AND ecm03=l_ecm03
                 #CALL s_umfchk(l_shb.shb10,l_ecm57a,l_ecm57)                                                   
                 #         RETURNING g_sw,l_factor
                 #    IF g_sw = '1' THEN                                                                                             
                 #       CALL cl_err('upd_ecm301','mfg1206',0)                                                                  
                 #       LET g_success='N'
                 #    ELSE
                        IF l_ecm012 = l_shb.shb012 THEN #for 平行工藝無跨製程段
                           LET l_qty=(l_shb.shb111+l_shb.shb115)/l_ecm62_a*l_ecm63_a
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                           LET l_qty=l_qty*l_ecm62_b/l_ecm63_b
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                          #UPDATE ecm_file SET ecm301=ecm301+(l_shb.shb111+l_shb.shb115)*l_factor
                          #No.FUN-BB0086--add--begin---
                          SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                           WHERE ecm01=l_shb.shb05   
                             AND ecm03=l_ecm03       
                             AND ecm012=l_ecm012     
                          LET l_qty = s_digqty(l_qty,l_ecm58_1)
                          #No.FUN-BB0086--add--end---
                           UPDATE ecm_file SET ecm301=ecm301+l_qty
                            WHERE ecm01=l_shb.shb05   #工單單號
                              AND ecm03=l_ecm03       #下製程序
                              AND ecm012=l_ecm012     #FUN-A50066
                        ELSE
                           #for 平行工藝跨製程段,則需以"多個前製程段中的最小轉出套數"回寫到本製程段首製程序
                           LET l_qty=t700sub_ecm301_minp(l_shb.shb05,l_sfb05,l_sfb06,l_ecm012)
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                           LET l_qty=l_qty*l_ecm62_b/l_ecm63_b
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                          #No.FUN-BB0086--add--begin---
                          SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                           WHERE ecm01=l_shb.shb05   
                             AND ecm03=l_ecm03       
                             AND ecm012=l_ecm012     
                          LET l_qty = s_digqty(l_qty,l_ecm58_1)
                          #No.FUN-BB0086--add--end---
                           UPDATE ecm_file SET ecm301=l_qty
                            WHERE ecm01=l_shb.shb05   #工單單號
                              AND ecm03=l_ecm03       #下製程序
                              AND ecm012=l_ecm012
                        END IF 
                 #FUN-A50066--end--modify-------------------------------------
                        IF STATUS OR SQLCA.SQLERRD[3]=0
                           THEN
                           CALL cl_err('Update ecm_file:#2',STATUS,1)
                           LET g_success='N'
                        END IF
                    #END IF    #FUN-A50066       
              END IF
              IF l_shb.shb113>0    #重工轉出
              THEN
#bugno:6123 add check 重工數量須依單位轉換...........................
                #FUN-A50066--begin--modify--------
                # SELECT ecm58 INTO l_ecm58 FROM ecm_file   #轉出單位
                #  WHERE ecm01=l_shb.shb05   #工單單號
                #    AND ecm03=l_shb.shb06   #當站製程序
                # SELECT ecm57 INTO l_ecm57 FROM ecm_file
                #  WHERE ecm01=l_shb.shb05   #工單單號
                #    AND ecm03=l_shb.shb12   #重工下製程序
                # #計算重工單位轉換率
                # CALL s_umfchk(l_shb.shb10,l_ecm58,l_ecm57) RETURNING g_sw,l_factor
                # IF g_sw = '1' THEN
                #    CALL cl_err('upd_ecm_shb113','mfg1206',1)
                #    LET g_success='N'
                # END IF
                #取得重工轉出的組成用量,底數
                 SELECT ecm62,ecm63 INTO l_ecm62_c,l_ecm63_c FROM ecm_file WHERE ecm01=l_shb.shb05
                    AND ecm03=l_shb.shb12 AND ecm012=l_shb.shb121 
                 IF cl_null(l_ecm62_c) THEN LET l_ecm62_c = 1 END IF
                 IF cl_null(l_ecm63_c) THEN LET l_ecm63_c = 1 END IF
                 LET l_qty=l_shb.shb113/l_ecm62_a*l_ecm63_a
                 IF cl_null(l_qty) THEN LET l_qty=0 END IF
                 LET l_qty=l_qty*l_ecm62_c/l_ecm63_c
                 IF cl_null(l_qty) THEN LET l_qty=0 END IF
                #UPDATE ecm_file SET ecm302=ecm302+l_shb.shb113*l_factor
                 #No.FUN-BB0086--add--begin---
                 SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                 WHERE ecm01=l_shb.shb05   
                 AND ecm03=l_shb.shb12       
                 AND ecm012=l_shb.shb121
                 LET l_qty = s_digqty(l_qty,l_ecm58_1)
                 #No.FUN-BB0086--add--end---
                 UPDATE ecm_file SET ecm302=ecm302+l_qty
                #FUN-A50066--end--modify------------------------------
                  WHERE ecm01=l_shb.shb05   #工單單號
                    AND ecm03=l_shb.shb12   #重工下製程序
                    AND ecm012=l_shb.shb121 #重工轉出下製程段號 #FUN-A50066
                 IF STATUS OR SQLCA.SQLERRD[3]=0
                    THEN
                    CALL cl_err('Update ecm_file:#3',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
              IF l_shb.shb17>0 THEN  #工單轉出
                 DECLARE t700sub_shi_cur CURSOR FOR
                    SELECT * FROM shi_file WHERE shi01=l_shb.shb01
                 FOREACH t700sub_shi_cur INTO l_shi.*
                    UPDATE ecm_file SET ecm303=ecm303+l_shi.shi05
                     WHERE ecm01=l_shi.shi02   #工單單號
                       AND ecm03=l_shi.shi04   #製程序
                       AND ecm012=l_shi.shi012 #FUN-A50066 
                    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                       CALL cl_err('Update ecm_file:#31',STATUS,1)
                       LET g_success='N' EXIT FOREACH
                    END IF
                 END FOREACH
              END IF

              #FUN-A80102(S)
              #自動產生下站採購單
              IF g_sma.sma1432='Y' THEN
                 CALL t700sub_gen_next_po(l_shb.*)
              END IF
              #FUN-A80102(E)
         WHEN 'r'
           IF l_shb.shb12 > 0 THEN   #MOD-920089 add
              #FUN-A50066--begin--modify---------------
              #SELECT MAX(ecm03) INTO l_ecm03n FROM ecm_file
              # WHERE ecm01=l_shb.shb05   #工單單號
              #   AND ecm03<l_shb.shb06
              #IF NOT cl_null(l_ecm03n) THEN
              #   SELECT COUNT(*) INTO l_cnt FROM shb_file
              #    WHERE shb05=l_shb.shb05   #工單單號
              #      AND shb06=l_ecm03n
              #      AND shb12 > 0           #上站有重工
              #      AND shb012=l_ecm012n    #FUN-A50066
              #   IF l_cnt > 0 THEN
              #      CALL cl_err(l_shb.shb01,'asf-806',1)
              #      LET g_success = 'N'
              #      RETURN
              #   END IF
              #END IF
              CALL t700sub_previous_ecm03(l_shb.*) 
              IF g_success ='N' THEN RETURN l_shb.* END IF  #FUN-A80102
              #FUN-A50066--end--modify------------------
           END IF    #No.MOD-930068 add
 
#.............委外時-委外完工數量(ecm322)減少
              #No.FUN-BB0086--add--begin---
              SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
              WHERE ecm01=l_shb.shb05   
              AND ecm03=l_shb.shb06       
              AND ecm012=l_shb.shb012
              LET l_shb.shb111 = s_digqty(l_shb.shb111,l_ecm58_1)
              LET l_shb.shb113 = s_digqty(l_shb.shb113,l_ecm58_1)
              LET l_shb.shb112 = s_digqty(l_shb.shb112,l_ecm58_1)
              LET l_shb.shb114 = s_digqty(l_shb.shb114,l_ecm58_1)
              LET l_shb.shb115 = s_digqty(l_shb.shb115,l_ecm58_1)
              LET l_shb.shb17 = s_digqty(l_shb.shb17,l_ecm58_1)
              LET l_ecm322 = s_digqty(l_ecm322,l_ecm58_1)
              #No.FUN-BB0086--add--end---
              UPDATE ecm_file SET ecm311=ecm311-l_shb.shb111,  #良品轉出
                                  ecm312=ecm312-l_shb.shb113,  #重工轉出
                                  ecm313=ecm313-l_shb.shb112,  #當站報廢
                                  ecm314=ecm314-l_shb.shb114,  #當站下線
                                  ecm315=ecm315-l_shb.shb115,  #Bonus(紅利)
                                  ecm316=ecm316-l_shb.shb17,
                                  ecm322=ecm322-l_ecm322       #委外完工量
               WHERE ecm01=l_shb.shb05   #工單單號
                 AND ecm03=l_shb.shb06   #本製程序
                 AND ecm012=l_shb.shb012 #FUN-A50066
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err('Update ecm_file:#4',STATUS,1)
                 LET g_success='N'
              END IF
              IF g_sma.sma901 = 'Y' THEN    #有串APS
                  IF l_ecm.ecm61 = 'Y' THEN #有平行加工
                     #FUN-960106 MARK --STR----------------------------
                     # UPDATE vlj_file SET vlj311=vlj311-g_shb.shb111,  #良品轉出
                     #                     vlj312=vlj312-g_shb.shb113,  #重工轉出
                     #                     vlj313=vlj313-g_shb.shb112,  #當站報廢
                     #                     vlj314=vlj314-g_shb.shb114,  #當站下線
                     #                     vlj315=vlj315-g_shb.shb115,  #Bonus(紅利)
                     #                     vlj316=vlj316-g_shb.shb17
                     #  WHERE vlj01=g_shb.shb05   #工單單號
                     #    AND vlj02=g_sma.sma917  #資源型態
                     #    AND vlj03=g_shb.shb06   #本製程序
                     #    AND vlj06=g_shb.shb09   #資源編號
                     #FUN-960106 MARK --END----------------------------
                    #FUN-990094---mod---str----
                    ##FUN-960106 ADD --STR-----------------------------
                    # UPDATE vne_file SET vne311=vne311+g_shb.shb111, #良品轉出
                    #                     vne312=vne312+g_shb.shb113, #重工轉出
                    #                     vne313=vne313+g_shb.shb112, #當站報廢
                    #                     vne314=vne314+g_shb.shb114, #當站下線
                    #                     vne315=vne315+g_shb.shb115, #Bonus
                    #                     vne316=vne316+g_shb.shb17  #工單轉出
                    #  WHERE vne01=g_shb.shb05
                    #    AND vne02=g_shb.shb05
                    #    AND vne03=g_shb.shb06
                    #    AND vne05=g_shb.shb09
                    ##FUN-960106 ADD --END-----------------------------
                      UPDATE vne_file SET vne311=vne311-l_shb.shb111, #良品轉出
                                          vne312=vne312-l_shb.shb113, #重工轉出
                                          vne313=vne313-l_shb.shb112, #當站報廢
                                          vne314=vne314-l_shb.shb114, #當站下線
                                          vne315=vne315-l_shb.shb115, #Bonus
                                          vne316=vne316-l_shb.shb17  #工單轉出
                       WHERE vne01=l_shb.shb05
                         AND vne02=l_shb.shb05
                         AND vne03=l_shb.shb06
                         AND vne05=l_shb.shb09
                         AND vne012=l_shb.shb012
                    #FUN-990094---mod---end----
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err('Update vlj_file:#3',STATUS,1)
                          LET g_success='N'
                      END IF
                  END IF
 
                  #==>更新vne_file的未完成量
                  LET l_vne03 = l_shb.shb06
                  SELECT COUNT(*) INTO l_cnt
                    FROM vne_file
                   WHERE vne01 = l_shb.shb05 #製令編號
                     AND vne02 = l_shb.shb05 #途程編號
                     AND vne03 = l_vne03     #加工序號
                     AND vne04 = l_ecm.ecm04 #作業編號
                     AND vne05 = l_shb.shb09 #資源編號
                     AND vne012=l_shb.shb012 #本製程段 #FUN-960106
                  IF l_cnt > 0 THEN
                      UPDATE vne_file
                         SET vne06 = vne06 + (l_shb.shb111+l_shb.shb113+l_shb.shb112+l_shb.shb114+l_shb.shb115+l_shb.shb17)
                       WHERE vne01 = l_shb.shb05 #製令編號
                         AND vne02 = l_shb.shb05 #途程編號
                         AND vne03 = l_vne03     #加工序號
                         AND vne04 = l_ecm.ecm04 #作業編號
                         AND vne05 = l_shb.shb09 #資源編號
                         AND vne012=l_shb.shb012 #本製程段 #FUN-960106 
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err('Update vne_file:#3',STATUS,1)
                          LET g_success='N'
                      END IF
                  END IF
              END IF
              IF l_final='N'    #非終站
                 THEN                #良品轉入
                #FUN-A50066--begin--modify----------------
                # SELECT ecm58 INTO l_ecm57a FROM ecm_file
                #  WHERE ecm01=l_shb.shb05
                #    AND ecm03=l_shb.shb06
 
                # SELECT ecm57 INTO l_ecm57 FROM ecm_file
                #  WHERE ecm01=l_shb.shb05
                #    AND ecm03=l_ecm03
                # CALL s_umfchk(l_shb.shb10,l_ecm57a,l_ecm57)                                                   
                #          RETURNING g_sw,l_factor
                #     IF g_sw = '1' THEN                                                                                             
                #        CALL cl_err('upd_ecm301','mfg1206',0)                                                                  
                #        LET g_success='N'
                #    ELSE
                        IF l_ecm012 = l_shb.shb012 THEN  #for 平行工藝無跨製程段 
                           LET l_qty=(l_shb.shb111+l_shb.shb115)/l_ecm62_a*l_ecm63_a
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                           LET l_qty=l_qty*l_ecm62_b/l_ecm63_b
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                          #UPDATE ecm_file SET ecm301=ecm301-(l_shb.shb111+l_shb.shb115)*l_factor
                          #No.FUN-BB0086--add--begin---
                          SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                           WHERE ecm01=l_shb.shb05   
                             AND ecm03=l_ecm03       
                             AND ecm012=l_ecm012     
                          LET l_qty = s_digqty(l_qty,l_ecm58_1)
                          #No.FUN-BB0086--add--end---
                           UPDATE ecm_file SET ecm301=ecm301-l_qty
                            WHERE ecm01=l_shb.shb05   #工單單號
                              AND ecm03=l_ecm03       #下製程序
                              AND ecm012=l_ecm012     #FUN-A50066
                           IF STATUS OR SQLCA.SQLERRD[3]=0
                              THEN
                              CALL cl_err('Update ecm_file:#5',STATUS,1)
                              LET g_success='N'
                           END IF
                        ELSE 
                           #for 平行工藝跨製程段,則需以"多個前製程段中的最小轉出套數"回寫到本製程段首製程序
                           LET l_qty=t700sub_ecm301_minp(l_shb.shb05,l_sfb05,l_sfb06,l_ecm012)
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                           LET l_qty=l_qty*l_ecm62_b/l_ecm63_b
                           IF cl_null(l_qty) THEN LET l_qty=0 END IF
                          #No.FUN-BB0086--add--begin---
                          SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                           WHERE ecm01=l_shb.shb05   
                             AND ecm03=l_ecm03       
                             AND ecm012=l_ecm012     
                          LET l_qty = s_digqty(l_qty,l_ecm58_1)
                          #No.FUN-BB0086--add--end---
                           UPDATE ecm_file SET ecm301=l_qty
                            WHERE ecm01=l_shb.shb05   #工單單號
                              AND ecm03=l_ecm03       #下製程序
                              AND ecm012=l_ecm012     #FUN-A50066
                           IF STATUS OR SQLCA.SQLERRD[3]=0
                              THEN
                              CALL cl_err('Update ecm_file:#5',STATUS,1)
                              LET g_success='N'
                           END IF
                        END IF
                #FUN-A50066--end--modify--------------------
                    #END IF      #FUN-A50066     
## --------------若下製程已有轉出應檢查本次報工刪除是否合理 ----
                 IF t700sub_r_chk(l_ecm03,l_ecm012,l_shb.shb05) THEN  #FUN-A50066 #TQC-B50143
                    LET g_success='N'
                    RETURN l_shb.*  #FUN-A80102
                 END IF
              END IF
              IF l_shb.shb113>0    #重工轉出
                 THEN
#bugno:6123 add check 重工數量須依單位轉換...........................
                #FUN-A50066--begin--modify--------------------------
                # SELECT ecm58 INTO l_ecm58 FROM ecm_file   #轉出單位
                #  WHERE ecm01=l_shb.shb05   #工單單號
                #    AND ecm03=l_shb.shb06   #當站製程序
                # SELECT ecm57 INTO l_ecm57 FROM ecm_file
                #  WHERE ecm01=l_shb.shb05   #工單單號
                #    AND ecm03=l_shb.shb12   #重工下製程序
                # #計算重工單位轉換率
                # CALL s_umfchk(l_shb.shb10,l_ecm58,l_ecm57) RETURNING g_sw,l_factor
                # IF g_sw = '1' THEN
                #    CALL cl_err('r_upd_ecm_shb113','mfg1206',1)
                #    LET g_success='N'
                # END IF
                 #取得重工轉出的組成用量,底數
                 SELECT ecm62,ecm63 INTO l_ecm62_c,l_ecm63_c FROM ecm_file WHERE ecm01=l_shb.shb05
                    AND ecm03=l_shb.shb12 AND ecm012=l_shb.shb121 
                 LET l_qty=l_shb.shb113/l_ecm62_a*l_ecm63_a
                 IF cl_null(l_qty) THEN LET l_qty=0 END IF
                 LET l_qty=l_qty*l_ecm62_c/l_ecm63_c
                 IF cl_null(l_qty) THEN LET l_qty=0 END IF
                #FUN-A50066--end--modify----------------------------
#bugno:6123重工轉入 add * l_factor
                #UPDATE ecm_file SET ecm302=ecm302-l_shb.shb113*l_factor #FUN-A50066
                 #No.FUN-BB0086--add--begin---
                 SELECT ecm58 INTO l_ecm58_1 FROM ecm_file 
                 WHERE ecm01=l_shb.shb05   
                 AND ecm03=l_shb.shb12       
                 AND ecm012=l_shb.shb121
                 LET l_qty = s_digqty(l_qty,l_ecm58_1)
                 #No.FUN-BB0086--add--end---
                 UPDATE ecm_file SET ecm302=ecm302-l_qty  #FUN-A50066
                  WHERE ecm01=l_shb.shb05   #工單單號
                    AND ecm03=l_shb.shb12   #重工下製程序
                    AND ecm012=l_shb.shb121 #重工下製程段 #FUN-A50066 
                 IF STATUS OR SQLCA.SQLERRD[3]=0
                    THEN
                    CALL cl_err('Update ecm_file:#6',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
              IF l_shb.shb17>0 THEN  #工單轉出
                 DECLARE t700sub_shi1_cur CURSOR FOR
                    SELECT * FROM shi_file WHERE shi01=l_shb.shb01
                 FOREACH t700sub_shi1_cur INTO l_shi.*
                    UPDATE ecm_file SET ecm303=ecm303-l_shi.shi05
                     WHERE ecm01=l_shi.shi02   #工單單號
                       AND ecm03=l_shi.shi04   #製程序
                       AND ecm012=l_shi.shi012 #FUN-A50066 
                    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                       CALL cl_err('Update ecm_file:#31',STATUS,1)
                       LET g_success='N' EXIT FOREACH
                    END IF
                 END FOREACH
              END IF
    END CASE
    
    RETURN l_shb.*   #FUN-A80102
END FUNCTION

FUNCTION t700sub_ecm301_minp(p_shb05,p_sfb05,p_sfb06,p_ecm012)
DEFINE p_shb05     LIKE shb_file.shb05
DEFINE p_sfb05     LIKE sfb_file.sfb05
DEFINE p_sfb06     LIKE sfb_file.sfb06
DEFINE p_ecm012    LIKE ecm_file.ecm012
DEFINE l_ecm012    LIKE ecm_file.ecm012
DEFINE l_tmpqty    LIKE shb_file.shb111
DEFINE l_minqty    LIKE shb_file.shb111

   LET l_tmpqty = 0
   LET l_minqty = NULL
   DECLARE t700sub_ecm301_minp_c1 CURSOR FOR 
    #TQC-B80180--begin--mod-----
    #SELECT ecu012 FROM ecu_file
    #             WHERE ecu01 = p_sfb05 
    #               AND ecu02 = p_sfb06
    #               AND ecu015= p_ecm012
     SELECT DISTINCT ecm012 FROM ecm_file
      WHERE ecm01 = p_shb05
        AND ecm015= p_ecm012
    #TQC-B80180--end--mod----
   FOREACH t700sub_ecm301_minp_c1 INTO l_ecm012
      LET l_tmpqty = 0
      SELECT ((ecm311+ecm315)/ecm62*ecm63) 
        INTO l_tmpqty
        FROM ecm_file
       WHERE ecm01  = p_shb05   #工單單號
         AND ecm012 = l_ecm012
         AND ecm03  = (SELECT MAX(ecm03) FROM ecm_file 
                       WHERE ecm01 =p_shb05 
                         AND ecm012=l_ecm012)
      IF l_tmpqty IS NULL THEN LET l_tmpqty = 0 END IF
      IF cl_null(l_minqty) THEN LET l_minqty = l_tmpqty  END IF
      IF l_tmpqty < l_minqty THEN
         LET l_minqty = l_tmpqty 
      END IF
   END FOREACH
   IF l_minqty is null THEN LET l_minqty =0  END IF
   RETURN l_minqty  
END FUNCTION

FUNCTION t700sub_previous_ecm03(l_shb)
DEFINE l_ecm03    LIKE ecm_file.ecm03
DEFINE l_ecm012   LIKE ecm_file.ecm012
DEFINE l_sfb93   LIKE sfb_file.sfb93
DEFINE l_sfb06   LIKE sfb_file.sfb06
DEFINE l_sfb05   LIKE sfb_file.sfb05
DEFINE l_shb     RECORD LIKE shb_file.*
DEFINE l_flag    LIKE type_file.num5  #MOD-AC0336

 LET l_ecm03=''
 LET g_success='Y'
 SELECT sfb93,sfb06 INTO l_sfb93,l_sfb06 FROM sfb_file WHERE sfb01=l_shb.shb05  #MOD-AC0336
 CALL s_schdat_sel_ima571(l_shb.shb05) RETURNING l_flag,l_sfb05  #MOD-AC0336 
 
 IF l_sfb93='Y' AND g_sma.sma541='Y' THEN  
    SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
     WHERE ecm01=l_shb.shb05
       AND ecm03<l_shb.shb06
       AND ecm012=l_shb.shb012
    IF cl_null(l_ecm03) THEN   #為本製程段的首製程序
       #抓取上一製程段
       DECLARE t700sub_ecu012_cus CURSOR FOR
       #TQC-B80180--begin--mod-----
       #SELECT DISTINCT ecu012 FROM ecu_file
       # WHERE ecu01 =l_sfb05
       #   AND ecu02 =l_sfb06
       #   AND ecu015=l_shb.shb012
        SELECT DISTINCT ecm012 FROM ecm_file
         WHERE ecm01 =l_shb.shb05
           AND ecm015=l_shb.shb012
       #TQC-B80180--end--mod----
       FOREACH t700sub_ecu012_cus INTO l_ecm012
         #抓取上製程段的最末製程
         SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
          WHERE ecm01=l_shb.shb05
            AND ecm012=l_ecm012
       # IF NOT t700sub_r_chk_shb12(l_ecm012,l_ecm03,l_shb.shb01) THEN LET g_success='N' RETURN END IF              #FUN-A70095 
         IF NOT t700sub_r_chk_shb12(l_ecm012,l_ecm03,l_shb.shb01,l_shb.shb05) THEN LET g_success='N' RETURN END IF  #FUN-A70095 
      END FOREACH
    ELSE
    # IF NOT t700sub_r_chk_shb12(l_shb.shb012,l_ecm03,l_shb.shb01) THEN LET g_success='N' RETURN END IF              #FUN-A70095
      IF NOT t700sub_r_chk_shb12(l_shb.shb012,l_ecm03,l_shb.shb01,l_shb.shb05) THEN LET g_success='N' RETURN END IF  #FUN-A70095
    END IF
 ELSE
    IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF 
    SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
     WHERE ecm01=l_shb.shb05
       AND ecm03<l_shb.shb06
       AND ecm012=l_shb.shb012
    # IF NOT t700sub_r_chk_shb12(l_shb.shb012,l_ecm03,l_shb.shb01) THEN LET g_success='N' RETURN END IF              #FUN-A70095
      IF NOT t700sub_r_chk_shb12(l_shb.shb012,l_ecm03,l_shb.shb01,l_shb.shb05) THEN LET g_success='N' RETURN END IF  #FUN-A70095
 END IF
END FUNCTION

#FALSE:上站有重工   TRUE:上站沒有重工
#FUNCTION t700sub_r_chk_shb12(p_ecm012n,p_ecm03n,p_shb01)         #FUN-A70095
FUNCTION t700sub_r_chk_shb12(p_ecm012n,p_ecm03n,p_shb01,p_shb05)  #FUN-A70095 
DEFINE p_ecm012n    LIKE ecm_file.ecm012
DEFINE p_ecm03n     LIKE ecm_file.ecm03
DEFINE l_cnt        LIKE type_file.num5
DEFINE p_shb01      LIKE shb_file.shb01
DEFINE p_shb05      LIKE shb_file.shb05   #FUN-A70095   

  IF NOT cl_null(p_ecm03n) THEN
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM shb_file
     #WHERE shb05=g_shb.shb05   #工單單號   #FUN-A70095
      WHERE shb05=p_shb05                   #FUN-A70095
        AND shb06=p_ecm03n
        AND shb12 > 0           #上站有重工
        AND shb012=p_ecm012n 
        IF l_cnt > 0 THEN
           CALL cl_err(p_shb01,'asf-806',1)
           RETURN FALSE
       END IF
  END IF
  RETURN TRUE
END FUNCTION

# 抓下製程
FUNCTION t700sub_next_ecm03(l_shb)
DEFINE l_ecm03    LIKE ecm_file.ecm03
DEFINE l_ecu015   LIKE ecu_file.ecu015
DEFINE l_final    LIKE type_file.chr1
DEFINE l_sfb93    LIKE sfb_file.sfb93
DEFINE l_sfb06    LIKE sfb_file.sfb06
DEFINE l_sfb05    LIKE sfb_file.sfb05
DEFINE l_shb      RECORD LIKE shb_file.*
DEFINE l_flag    LIKE type_file.num5  #MOD-AC0336

   LET l_ecm03=''
   LET l_final='N'
   SELECT sfb93,sfb06 INTO l_sfb93,l_sfb06 FROM sfb_file WHERE sfb01=l_shb.shb05  #MOD-AC0336
   CALL s_schdat_sel_ima571(l_shb.shb05) RETURNING l_flag,l_sfb05  #MOD-AC0336
   
   IF l_sfb93='Y' AND g_sma.sma541='Y' THEN  
      SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
       WHERE ecm01=l_shb.shb05
         AND ecm03>l_shb.shb06
         AND ecm012=l_shb.shb012
      IF cl_null(l_ecm03) THEN   #為本製程段的最後一個製程
         #抓取下一製程段
        #TQC-B80180--begin--mod--
        #SELECT ecu015 INTO l_ecu015 FROM ecu_file
        # WHERE ecu01 =l_sfb05
        #   AND ecu02 =l_sfb06
        #   AND ecu012=l_shb.shb012
         DECLARE t700sub_ecm015_cs CURSOR FOR
          SELECT DISTINCT ecm015 FROM ecm_file
           WHERE ecm01 =l_shb.shb05
             AND ecm012=l_shb.shb012
         FOREACH t700sub_ecm015_cs INTO l_ecu015
            EXIT FOREACH
         END FOREACH
        #TQC-B80180--end--mod---
         IF cl_null(l_ecu015) THEN 
            LET l_final='Y'  #最終製程段的最終站
            RETURN l_sfb05,l_sfb06,l_shb.shb012,' ',l_final
         ELSE       
            #抓取下製程段的首製程
            SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
             WHERE ecm01=l_shb.shb05
               AND ecm012=l_ecu015
            RETURN l_sfb05,l_sfb06,l_ecu015,l_ecm03,l_final
         END IF
      ELSE
         RETURN l_sfb05,l_sfb06,l_shb.shb012,l_ecm03,l_final  #返回本製造段的下一製程序
      END IF
   ELSE
      IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF 
      LET l_ecm03 = NULL
      SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
       WHERE ecm01=l_shb.shb05   #工單單號
         AND ecm03>l_shb.shb06
         AND ecm012=l_shb.shb012
      IF cl_null(l_ecm03) THEN
         LET l_final='Y'
      END IF
   END IF
   RETURN l_sfb05,l_sfb06,l_shb.shb012,l_ecm03,l_final
END FUNCTION

#p_ecm012/p_ecm03 下一製程的製程段/製程序
FUNCTION t700sub_r_chk(p_ecm03,p_ecm012,p_shb05)  #FUN-A50066 #TQC-B50143
DEFINE  p_ecm03   LIKE ecm_file.ecm03
DEFINE  p_ecm012  LIKE ecm_file.ecm012 #FUN-A50066
DEFINE  l_in_qty  LIKE ecm_file.ecm311
DEFINE  l_out_qty LIKE ecm_file.ecm311
DEFINE  l_ecm     RECORD LIKE ecm_file.*
DEFINE  p_shb05   LIKE shb_file.shb05     #TQC-B50143
DEFINE  l_out_unqty LIKE ecm_file.ecm311  #FUN-A70095
 
    #FUN-A80102(S)
    #TQC-B50143--拿掉以下程式的mark符(S)
    SELECT * INTO l_ecm.*
      FROM ecm_file
     WHERE ecm01=p_shb05  #TQC-B50143
       AND ecm03=p_ecm03
       AND ecm012=p_ecm012  #FUN-A50066
    IF STATUS THEN CALL cl_err('sel ecm_file',STATUS,0) RETURN -1 END IF
    #TQC-B50143--(E)
    #FUN-A80102(E)
 
     IF l_ecm.ecm54='Y' THEN   #check in 否
        IF l_ecm.ecm301<l_ecm.ecm291
           THEN
           CALL cl_err('','asf-809',0)
           RETURN -1
        END IF
        LET l_in_qty =  l_ecm.ecm291                #check in
                      + l_ecm.ecm302                #重工轉入
     ELSE
        LET l_in_qty =  l_ecm.ecm301                #良品轉入量
                      + l_ecm.ecm302                #重工轉入量
                      + l_ecm.ecm303                #工單轉入量
     END IF
     LET l_out_qty =  l_ecm.ecm311  #*l_ecm.ecm59    #良品轉出  #FUN-A50066
                    + l_ecm.ecm312  #*l_ecm.ecm59    #重工轉出  #FUN-A50066
                    + l_ecm.ecm313  #*l_ecm.ecm59    #當站報廢  #FUN-A50066
                    + l_ecm.ecm314  #*l_ecm.ecm59    #當站下線  #FUN-A50066
                    + l_ecm.ecm316  #*l_ecm.ecm59    #工單轉出  #FUN-A50066
#FUN-A70095 ----------------Begin-------------------
     LET l_out_unqty = 0 
     SELECT SUM(shb111+shb112+shb113+shb114+shb17) INTO l_out_unqty FROM shb_file
      WHERE shb05 = p_shb05
        AND shb012 = p_ecm012
        AND shb06 = p_ecm03
        AND shbconf = 'N'         
     IF cl_null(l_out_unqty) THEN LET l_out_unqty=0 END IF
#FUN-A70095 ----------------End---------------------
     IF cl_null(l_in_qty) THEN LET l_in_qty=0 END IF
     IF cl_null(l_out_qty) THEN LET l_out_qty=0 END IF
     LET l_out_qty = l_out_qty + l_out_unqty    #FUN-A70095
     IF l_out_qty>l_in_qty    #轉出>轉入
        THEN
     #  CALL cl_err('','asf-808',0)  #FUN-A70095
        CALL cl_err('','asf-227',0)  #FUN-A70095
        RETURN -1
     ELSE
        RETURN 0
     END IF
 
END FUNCTION

#FUN-A80102(S)
FUNCTION t700sub_shb26_31(p_shb05,p_shb012,p_shb06)  
   DEFINE p_shb05       LIKE shb_file.shb05 
   DEFINE p_shb012      LIKE shb_file.shb012
   DEFINE p_shb06       LIKE shb_file.shb06 
   DEFINE l_shb31       LIKE shb_file.shb31 
   DEFINE l_shb26       LIKE shb_file.shb26 
   DEFINE l_next_shb012 LIKE shb_file.shb012
   DEFINE l_next_shb06  LIKE shb_file.shb06 
   
   IF g_sma.sma1431='N' OR g_sma.sma1431 IS NULL THEN
      RETURN 'N','N'
   END IF

   SELECT ecm52 INTO l_shb31 FROM ecm_file
    WHERE ecm01=p_shb05
      AND ecm03=p_shb06
      AND ecm012=p_shb012
   CALL s_schdat_next_ecm03(p_shb05,p_shb012,p_shb06)
     RETURNING l_next_shb012,l_next_shb06
   IF l_next_shb012 IS NULL THEN LET l_next_shb012 = ' ' END IF
   SELECT ecm52 INTO l_shb26 FROM ecm_file
    WHERE ecm01  = p_shb05
      AND ecm03  = l_next_shb06
      AND ecm012 = l_next_shb012
   IF SQLCA.sqlcode THEN
      LET l_shb26 = 'N'
   END IF
   RETURN l_shb26,l_shb31
END FUNCTION
#FUN-A80102(E)

#(A).函數目的:檢查本站可以報工的量(總允許轉出量)
#(B).需手動報工的站:
#1.當報工點(ecm66/sgm66)為'Y'時必須手動報工
#2.當工序為"數量完全委外"時，委外工序和前道工序 Default 報工點='Y',可以改成'N',但要自動報工的委外站,sfb05的檢驗否必須為'N',否則無法自動產生入庫單,且"免檢料自動入庫(sma886_7)"要打勾
#3.當工序中含有"數量部分委外"時,必須手動報工  (報工點='Y',不可改'N') (否則自動報工時無法區分良品轉入的量是來自廠外或廠內)
#(C).當站可報工量:
#Rule.1:若當前工序之前的工序中存在報工點ecm66='Y'的工序，則當前工序的轉出量(shb111+shb112+shb113+shb114)不得大於上道報工點ecm66='Y'的工序的良品轉出量(ecm311+ecm315)-本道工序良品已轉出量(ecm311+ecm312+ecm313+ecm314+ecm316)
#Rule.2:若當前工序之前的工序中不存在報工點ecm66='Y'的工序，則當前工序的良品轉出量(shb111+shb112+shb113+shb114)不得大於當前製程段的第一道工序的良品轉入量(ecm301)-本道工序良品已轉出量(ecm311+ecm312+ecm313+ecm314+ecm316)
#(D).傳入參數:
#工單、Runcard、製程段、製程序
#特別說明:
#WHEN p_sgm01為 NULL 時，抓ecm,有值時抓sgm
#WHEN p_ecm03 = 0 OR NULL 時，回傳值改為:求得本製程段中所有製程序的最小轉出量
#(E).回傳值: 
#1.瓶頸製程段 
#2.瓶頸製程序 (前製程的手動報工站或首製程序)
#3.本站可報工量 (瓶頸站的轉出量)
FUNCTION t700sub_check_auto_report(p_sfb01,p_sgm01,p_ecm012,p_ecm03)
   DEFINE p_sfb01  LIKE sfb_file.sfb01 
   DEFINE p_sgm01  LIKE sgm_file.sgm01 
   DEFINE p_ecm012 LIKE ecm_file.ecm012
   DEFINE p_ecm03  LIKE ecm_file.ecm03 
   DEFINE l_sql    STRING
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_min_tran_out LIKE ecm_file.ecm311   #最小轉出量
   DEFINE l_min_ecm012   LIKE ecm_file.ecm012
   DEFINE l_min_ecm03    LIKE ecm_file.ecm03
   DEFINE l_ecm  RECORD 
                   ecm012   LIKE ecm_file.ecm012 ,
                   ecm03    LIKE ecm_file.ecm03  ,
                   ecm301   LIKE ecm_file.ecm301 ,
                   ecm302   LIKE ecm_file.ecm302 ,
                   ecm303   LIKE ecm_file.ecm303 ,
                   ecm311   LIKE ecm_file.ecm311 ,
                   ecm312   LIKE ecm_file.ecm312 ,
                   ecm313   LIKE ecm_file.ecm313 ,
                   ecm314   LIKE ecm_file.ecm314 ,
                   ecm315   LIKE ecm_file.ecm315 ,
                   ecm316   LIKE ecm_file.ecm316 ,
                   ecm321   LIKE ecm_file.ecm321 ,
                   ecm322   LIKE ecm_file.ecm322 ,
                   ecm52    LIKE ecm_file.ecm52  ,
                   ecm62    LIKE ecm_file.ecm62  ,
                   ecm63    LIKE ecm_file.ecm63  ,
                   ecm66    LIKE ecm_file.ecm66      #FUN-A70095
                END RECORD
   DEFINE l_pre_ecm012   LIKE ecm_file.ecm012
   DEFINE l_pre_ecm03    LIKE ecm_file.ecm03
   DEFINE l_aecm         RECORD LIKE ecm_file.*       #CHI-B40021
   DEFINE l_ecm62        LIKE ecm_file.ecm62          #FUN-A70095
   DEFINE l_ecm63        LIKE ecm_file.ecm63          #FUN-A70095
   DEFINE l_min_tran_out_sum  LIKE ecm_file.ecm311    #FUN-A70095
#TQC-C20361 ------------Begin---------------
   DEFINE l_ecm311       LIKE ecm_file.ecm311
   DEFINE l_ecm312       LIKE ecm_file.ecm312
   DEFINE l_ecm313       LIKE ecm_file.ecm313
   DEFINE l_ecm314       LIKE ecm_file.ecm314
   DEFINE l_ecm316       LIKE ecm_file.ecm316
   DEFINE l_ecm321       LIKE ecm_file.ecm321
   DEFINE l_ecm322       LIKE ecm_file.ecm322
#TQC-C20361 ------------End-----------------
   
   IF p_ecm012 IS NULL THEN LET p_ecm012=' ' END IF
 #FUN-A70095 ------------------Begin---------------------  
 #抓取當站的組成用量和底數 
 # SELECT ecm62,ecm63 INTO l_ecm62,l_ecm63 FROM ecm_file  #TQC-C20361
 #TQC-C20361 -----------------Begin-----------------
   SELECT ecm62,ecm63,ecm311,ecm312,ecm313,ecm314,ecm316,ecm321,ecm322 
     INTO l_ecm62,l_ecm63,l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm316,l_ecm321,l_ecm322
     FROM ecm_file
 #TQC-C20361 -----------------End-------------------
    WHERE ecm01 = p_sfb01
      AND ecm012 = p_ecm012
      AND ecm03 = p_ecm03 
   IF cl_null(l_ecm62) THEN LET l_ecm62 = 1 END IF
   IF cl_null(l_ecm63) THEN LET l_ecm63 = 1 END IF
 #TQC-C20361 -----Begin------
   IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF
   IF cl_null(l_ecm312) THEN LET l_ecm312 = 0 END IF
   IF cl_null(l_ecm313) THEN LET l_ecm313 = 0 END IF
   IF cl_null(l_ecm314) THEN LET l_ecm314 = 0 END IF
   IF cl_null(l_ecm316) THEN LET l_ecm316 = 0 END IF
   IF cl_null(l_ecm321) THEN LET l_ecm321 = 0 END IF
   IF cl_null(l_ecm322) THEN LET l_ecm322 = 0 END IF
 #TQC-C20361 -----End--------
 #FUN-A70095 ------------------End-----------------------
   #1.Check 前一報工點
   LET l_sql = "SELECT ecm012,ecm03,ecm301,ecm302,ecm303,",    
               "ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,", 
            #  "ecm321,ecm322,ecm52,ecm62,ecm63,ecm321,ecm322,ecm66 FROM ecm_file ",  #FUN-A70095
               "ecm321,ecm322,ecm52,ecm62,ecm63,ecm66 FROM ecm_file ",                #FUN-A70095 
               " WHERE ecm01='",p_sfb01,"'",
               "   AND ecm012='",p_ecm012,"'",
               "   AND ecm66='Y' "
   IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
      LET l_sql = l_sql ,"   AND ecm03 < ",p_ecm03
   END IF
   LET l_sql = l_sql ,"  ORDER BY ecm03 DESC"
   
   LET l_min_ecm012 = ' '
   LET l_min_ecm03  = 0
   PREPARE t700sub_auto_report_p1 FROM l_sql
   DECLARE t700sub_auto_report_c1 CURSOR FOR t700sub_auto_report_p1
   FOREACH t700sub_auto_report_c1 INTO l_ecm.*
       LET l_min_tran_out = l_ecm.ecm311 + l_ecm.ecm315
   #FUN-A70095 -------------Begin------------------
       IF cl_null(l_ecm.ecm62) THEN LET l_ecm.ecm62 = 1 END IF
       IF cl_null(l_ecm.ecm63) THEN LET l_ecm.ecm63 = 1 END IF
       LET l_min_tran_out = l_min_tran_out/l_ecm.ecm62 * l_ecm.ecm63 
       LET l_min_tran_out = l_min_tran_out * l_ecm62/l_ecm63
       IF cl_null(l_min_tran_out) THEN LET l_min_tran_out = 0 END IF
   #FUN-A70095 -------------End--------------------
       LET l_min_ecm012 = l_ecm.ecm012
       LET l_min_ecm03  = l_ecm.ecm03
       EXIT FOREACH
   END FOREACH
   
#FUN-A70095 ------------------Begin-------------------------
   LET l_sql = "SELECT * FROM ecm_file ",
               " WHERE ecm01='",p_sfb01,"'",
               "   AND ecm012='",p_ecm012,"'"
   IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
      LET l_sql = l_sql ,"   AND ecm03 < = ",p_ecm03
   END IF
  #--------------No:MOD-BB0314 modify
  #抓取最小站的良品轉入量
  #LET l_sql = l_sql ,"  ORDER BY ecm03 DESC"
   LET l_sql = l_sql ,"  ORDER BY ecm03 "
  #--------------No:MOD-BB0314 end
   PREPARE t700sub_auto_report_p5 FROM l_sql
   DECLARE t700sub_auto_report_c5 CURSOR FOR t700sub_auto_report_p5
#FUN-A70095 ------------------End----------------------------    

   #2.若前面無報工點='Y'的資料,則check首製程序
   IF l_min_ecm03 = 0 THEN
       #FUN-A70095 ------Begin--------
       # SELECT MIN(ecm03) INTO l_min_ecm03 
       #   FROM ecm_file
       #  WHERE ecm01 =p_sfb01
       #    AND ecm012=p_ecm012
       #FUN-A70095 ------End----------
        #CHI-B40021 (S)
        #SELECT ecm301 INTO l_min_tran_out
        #  FROM ecm_file
        # WHERE ecm01 =p_sfb01
        #   AND ecm012=p_ecm012
        #   AND ecm03 =l_min_ecm03
        #FUN-A70095 -----Begin------
        #SELECT * INTO l_aecm.*
        #  FROM ecm_file
        # WHERE ecm01 =p_sfb01
        #   AND ecm012=p_ecm012
        #   AND ecm03 =l_min_ecm03
        #FUN-A70095 -----End--------
         LET l_min_tran_out_sum = 0   #FUN-A70095     
         FOREACH t700sub_auto_report_c5 INTO l_aecm.*        #FUN-A70095
            IF cl_null(l_aecm.ecm62) THEN LET l_aecm.ecm62 = 1 END IF  #FUN-A70095
            IF cl_null(l_aecm.ecm63) THEN LET l_aecm.ecm63 = 1 END IF  #FUN-A70095
            IF l_aecm.ecm54='Y' THEN   #check in ??
              #---------------No:MOD-BB0314  modify
              #只先算第一站的轉入量即可，在t700_sub_check_auto_report()外面再去扣除該站的轉出量
              #LET l_min_tran_out
              #     =  l_aecm.ecm291
              #      - l_aecm.ecm311
              #      - l_aecm.ecm312
              #      - l_aecm.ecm313
              #      - l_aecm.ecm314
              #      - l_aecm.ecm316
               LET l_min_tran_out = l_aecm.ecm291
              #---------------No:MOD-BB0314  end
            ELSE
              #---------------No:MOD-BB0314  modify
              #只先算第一站的轉入量即可，在t700_sub_check_auto_report()外面再去扣除該站的轉出量
              #LET l_min_tran_out
              #    =  l_aecm.ecm301
              #     + l_aecm.ecm302
              #     + l_aecm.ecm303
              #     - l_aecm.ecm311
              #     - l_aecm.ecm312
              #     - l_aecm.ecm313
              #     - l_aecm.ecm314
              #     - l_aecm.ecm316
               LET l_min_tran_out = l_aecm.ecm301
                                  + l_aecm.ecm302
                                  + l_aecm.ecm303
              #---------------No:MOD-BB0314  end
            END IF
            IF cl_null(l_min_tran_out) THEN LET l_min_tran_out=0 END IF
            LET l_min_tran_out = l_min_tran_out/l_aecm.ecm62 * l_aecm.ecm63   #FUN-A70095
           #---------------No:MOD-BB0314  modify
            LET l_min_tran_out_sum = l_min_tran_out_sum + l_min_tran_out      #FUN-A70095
            EXIT FOREACH
           #---------------No:MOD-BB0314  end
            #CHI-B40021 (E)
         END FOREACH    #FUN-A70095
         IF cl_null(l_min_tran_out_sum) THEN LET l_min_tran_out_sum=0 END IF  #FUN-A70095
         LET l_min_tran_out = l_min_tran_out_sum * l_ecm62/l_ecm63            #FUN-A70095  
         IF cl_null(l_min_tran_out) THEN LET l_min_tran_out=0 END IF          #FUN-A70095 
   END IF
   #TQC-C20361 ---------------Begin--------------
   LET l_min_tran_out = l_min_tran_out 
                        - l_ecm311                #良品轉出
                        - l_ecm312                #重工轉出
                        - l_ecm313                #當站報廢
                        - l_ecm314                #當站下線
                        - l_ecm316                #工單轉出
                      # - l_ecm321                #委外加工量  #MOD-C30620
                      # + l_ecm322                #委外完工量  #MOD-C30620
   #TQC-C20361 ---------------End----------------
   
   RETURN l_min_ecm012,l_min_ecm03,l_min_tran_out
END FUNCTION

#目的:自動產生前幾站的報工單
#傳入參數:當站報工單、當站ecm
#PS:
#1.本函數要包在Transaction裡面再呼叫之,本函數內沒包Transaction
#2.本函數處理過程如果發生錯誤,會LET g_success='N' 並脫離函數
#3.呼叫本函數前,應該先做"前幾站是否可自動報工"的檢查 (CALL t700sub_check_auto_report)
#
#自動報工處理邏輯：
#1.若當前報工站的前面幾站(不跨製程段)的良品轉出量(ecm311)低於當前報工站的
#"本次報工總數量(shb111～114)"+"ecm轉出量(ecm311～316)",
#則將差異的量做自動報工(即自動產生報工單)並異動到ecm。也就是 報工點='N'的站也可以手動報工部分的量。
#2.for 當前報工站及前幾道自動報工站：若該站數量完全委外(數量部分委外的製程序不允許自動報工),
#則依照本次自動報工數量產生收貨單(已確認)、入庫單(已確認)，檢查下站(不跨製程段)若為委外站，
#則將本次報工的"良品轉出總數"自動產生下站的委外採購單，並發出。
FUNCTION t700sub_auto_report(p_shb,p_ecm)
   DEFINE p_sfb01    LIKE sfb_file.sfb01 
   DEFINE p_sgm01    LIKE sgm_file.sgm01 
   DEFINE p_ecm012   LIKE ecm_file.ecm012
   DEFINE p_ecm03    LIKE ecm_file.ecm03 
   DEFINE p_shb      RECORD LIKE shb_file.*
   DEFINE p_ecm      RECORD LIKE ecm_file.*
   DEFINE l_sql      STRING
   DEFINE l_shb      RECORD LIKE shb_file.*
   DEFINE l_ecm      RECORD LIKE ecm_file.*
   DEFINE l_repqty   LIKE ecm_file.ecm301
   DEFINE l_outqty   LIKE ecm_file.ecm311
   DEFINE l_totqty   LIKE ecm_file.ecm311
   DEFINE l_sgm01    LIKE sgm_file.sgm01 
   DEFINE l_ecm01    LIKE ecm_file.ecm01 
   DEFINE l_sgm012   LIKE sgm_file.sgm012
   DEFINE l_sgm03    LIKE sgm_file.sgm03
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rvb01    LIKE rvb_file.rvb01
   DEFINE l_prog     STRING
   DEFINE l_rvv17    LIKE rvv_file.rvv17
   DEFINE l_pmm09    LIKE pmm_file.pmm09
   DEFINE l_rvv      RECORD LIKE rvv_file.*
   DEFINE l_t1       LIKE type_file.chr5
   DEFINE la_ecm     DYNAMIC ARRAY OF RECORD
                        sgm01   LIKE sgm_file.sgm01 ,
                        ecm01   LIKE ecm_file.ecm01 ,
                        sgm012  LIKE sgm_file.sgm012,
                        sgm03   LIKE sgm_file.sgm03 
                     END RECORD
#FUN-A70095 ------------Begin---------------
   DEFINE l_rvb02    LIKE rvb_file.rvb02
   DEFINE l_rvb05    LIKE rvb_file.rvb05
   DEFINE l_rvb36    LIKE rvb_file.rvb36
   DEFINE l_rvb37    LIKE rvb_file.rvb37
   DEFINE l_rvb38    LIKE rvb_file.rvb38
   DEFINE l_cnt1     LIKE type_file.num5
#FUN-A70095 ------------End-----------------
   DEFINE l_shb34    LIKE shb_file.shb34   #No.FUN-BB0086

   WHENEVER ERROR CALL cl_err_msg_log

   IF p_shb.shb012 IS NULL THEN LET p_shb.shb012=' ' END IF
   
   LET l_sql = "SELECT '',ecm01,ecm012,ecm03 FROM ecm_file ",
               " WHERE ecm01='",p_shb.shb05,"'",
               "   AND ecm012='",p_shb.shb012,"'",
               "   AND (ecm66='N' OR trim(ecm66) IS NULL) "
   IF p_shb.shb06 > 0 AND p_shb.shb06 IS NOT NULL THEN
      LET l_sql = l_sql ,"   AND ecm03 < ",p_shb.shb06
   END IF
   LET l_sql = l_sql ,"  ORDER BY ecm03 "

   IF p_ecm.ecm62 IS NULL THEN LET p_ecm.ecm62 = 1 END IF
   IF p_ecm.ecm63 IS NULL THEN LET p_ecm.ecm63 = 1 END IF
   
   #本報工站總轉出數量
#FUN-A70095 ---------------------Begin----------------------- 
#  LET l_repqty = ((p_shb.shb111 +p_shb.shb112 + p_shb.shb113 + 
#                   p_shb.shb114 ) + (p_ecm.ecm311 + p_ecm.ecm312 + 
#                   p_ecm.ecm313 + p_ecm.ecm314 + p_ecm.ecm315 + 
#                   p_ecm.ecm316)) / p_ecm.ecm62*p_ecm.ecm63
   LET l_repqty = (p_ecm.ecm311 + p_ecm.ecm312 +p_ecm.ecm313 +p_ecm.ecm314+ 
                   p_ecm.ecm315+p_ecm.ecm316)/ p_ecm.ecm62*p_ecm.ecm63
#FUN-A70095 ---------------------End-------------------------
                   

   LET l_t1  = s_get_doc_no(p_shb.shb01)
   LET l_cnt = 1
   CALL la_ecm.clear()
   PREPARE t700sub_auto_report_p2 FROM l_sql
   DECLARE t700sub_auto_report_c2 CURSOR FOR t700sub_auto_report_p2
   FOREACH t700sub_auto_report_c2 INTO l_sgm01,l_ecm01,l_sgm012,l_sgm03
      LET la_ecm[l_cnt].sgm01  = l_sgm01 
      LET la_ecm[l_cnt].ecm01  = l_ecm01 
      LET la_ecm[l_cnt].sgm012 = l_sgm012
      LET la_ecm[l_cnt].sgm03  = l_sgm03 
      LET l_cnt = l_cnt + 1
   END FOREACH
   
   FOR l_cnt = 1 TO la_ecm.getlength()
      IF la_ecm[l_cnt].sgm03 IS NULL THEN CONTINUE FOR END IF
      SELECT * INTO l_ecm.* FROM ecm_file
       WHERE ecm01  = la_ecm[l_cnt].ecm01
         AND ecm012 = la_ecm[l_cnt].sgm012
         AND ecm03  = la_ecm[l_cnt].sgm03

      INITIALIZE l_shb.* TO NULL
      LET l_shb.* = p_shb.*

      LET l_shb.shb01  = l_t1
      LET l_shb.shb03  = p_shb.shb03
      LET l_shb.shb05  = p_shb.shb05
      LET l_shb.shb06  = la_ecm[l_cnt].sgm03
      LET l_shb.shb012 = la_ecm[l_cnt].sgm012

      LET l_shb.shb111 = 0
      LET l_shb.shb113 = 0
      LET l_shb.shb112 = 0
      LET l_shb.shb114 = 0
      LET l_shb.shb115 = 0
      LET l_shb.shb17  = 0
      LET l_shb.shb27  = l_ecm.ecm67
      IF l_ecm.ecm62 IS NULL THEN LET l_ecm.ecm62 = 1 END IF
      IF l_ecm.ecm63 IS NULL THEN LET l_ecm.ecm63 = 1 END IF
      LET l_shb.shb032 = 0  #FUN-B10054
      LET l_shb.shb033 = 0  #FUN-B10054

      LET l_outqty = l_repqty - (l_ecm.ecm311 / l_ecm.ecm62 * l_ecm.ecm63)

      IF l_outqty <= 0 THEN  #本站的報工量超過報工站的量,不需補報工
         CONTINUE FOR
      END IF

      LET l_shb.shb111 = l_outqty * l_ecm.ecm62 / l_ecm.ecm63
      #No.FUN-BB0086--add--begin--
      SELECT ecm58 INTO l_shb34 FROM ecm_file 
       WHERE ecm01=g_shb.shb05 
         AND emc03=g_shb.shb06 
         AND ecm012=g_shb.shb012
      LET l_shb.shb111 = s_digqty(l_shb.shb111,l_shb34)
      #No.FUN-BB0086--add--end--

      #委外站自動開立收貨及入庫單
      IF l_ecm.ecm52='Y' THEN
         IF g_sma.sma1432='Y' THEN
            #檢查委外入庫量是否足夠報工,若足夠則不需產生收貨、入庫單
            #(暫不考慮單位換算的問題,日後要換算時,應該入庫單位都要為換算為ecm58去處理報工單)
            LET l_rvv17=0
            SELECT SUM(rvv17)-SUM(COALESCE(shb111+shb112+shb113+shb114,0)) INTO l_rvv17 
              FROM rvu_file,pmn_file,rvv_file 
              LEFT OUTER JOIN shb_file ON (shb14 = rvv01 AND shb15 = rvv02)
             WHERE rvv36 = pmn01 AND rvv37 = pmn02
               AND rvv01 = rvu01 AND rvuconf = 'Y'
               AND pmn41 = l_shb.shb05 AND pmn43 = la_ecm[l_cnt].sgm03
               AND pmn012= la_ecm[l_cnt].sgm012

            IF l_rvv17 IS NULL OR l_rvv17 < 0 THEN LET l_rvv17 = 0 END IF

            IF l_rvv17 < l_outqty THEN
               CALL t700sub_gen_ro(l_shb.*,l_outqty - l_rvv17) RETURNING l_rvb01
               IF g_success='N' THEN
                  EXIT FOR
               END IF
          #FUN-A70095 ---------------Begin---------------
               DECLARE t700sub_rvb01 CURSOR FOR 
                  SELECT rvb02,rvb05,rvb36,rvb37,rvb38 FROM rvb_file
                   WHERE rvb01 = l_rvb01
               FOREACH t700sub_rvb01 INTO l_rvb02,l_rvb05,l_rvb36,l_rvb37,l_rvb38 
                  LET l_cnt1 = 0 
                  SELECT COUNT(*) INTO l_cnt1 FROM img_file
                   WHERE img01 = l_rvb05
                     AND img02 = l_rvb36
                     AND img03 = l_rvb37
                     AND img04 = l_rvb38
                  IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF     
                  IF l_cnt1 < 1 THEN
                     CALL t700sub_add_img(l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_rvb01,l_rvb02,l_shb.shb03)
                  END IF
                  IF g_success = 'N' THEN
                     EXIT FOREACH
                  END IF
               END FOREACH   
          #FUN-A70095 ---------------End-----------------
               LET l_prog=g_prog
               LET g_prog='apmt200'
              #CALL t110sub_y_chk(l_rvb01,' ','SUB','1') #CHI-C30118 mark
               CALL t110sub_y_chk(l_rvb01,TRUE,'N',' ','SUB','1','1') #CHI-C30118 add
               IF g_success = "Y" THEN
                  CALL t110sub_y_upd(l_rvb01,TRUE,'N',' ','SUB','1','1')
                 #CALL t110sub_y_upd(l_rvb01,FALSE,'N',' ','SUB','1','1')
               END IF
               LET g_prog=l_prog
               IF g_success='N' THEN
                  EXIT FOR
               END IF
            END IF

            #一張入庫單身,開立一張報工單
            LET l_totqty = 0
            LET l_sql = "SELECT rvv_file.*,pmm09 ",
                        "  FROM rvu_file,rvv_file,pmn_file,pmm_file",
                        " WHERE rvv36 = pmn01 AND rvv37 = pmn02 ",
                        "   AND pmm01 = pmn01 ",
                        "   AND rvv01 = rvu01 AND rvuconf = 'Y' ",
                        "   AND pmn41 = '",l_shb.shb05,"' AND pmn43 = ",la_ecm[l_cnt].sgm03,
                        "   AND pmn012= '",la_ecm[l_cnt].sgm012,"'",
                        "   AND rvv17 > COALESCE((SELECT SUM(shb111+shb112+shb113+shb114) ",
                        "  FROM shb_file WHERE shb14 = rvv01 AND shb15 = rvv02),0)"
            PREPARE t700sub_auto_report_p3 FROM l_sql
            DECLARE t700sub_auto_report_c3 CURSOR FOR t700sub_auto_report_p3
            FOREACH t700sub_auto_report_c3 INTO l_rvv.*,l_pmm09
               SELECT rvv17-SUM(COALESCE(shb111,0)+COALESCE(shb112,0)+
                                COALESCE(shb113,0)+COALESCE(shb114,0))
                 INTO l_repqty
                 FROM rvv_file LEFT OUTER JOIN shb_file 
                   ON (shb14 = rvv01 AND shb15 = rvv02)
                WHERE rvv01 = l_rvv.rvv01
                  AND rvv02 = l_rvv.rvv02
               IF l_repqty > l_outqty THEN
                  LET l_repqty = l_outqty
               END IF
               LET l_shb.shb111 = l_repqty
               LET l_shb.shb14  = l_rvv.rvv01   #入庫單號  
               LET l_shb.shb15  = l_rvv.rvv02   #項次    
               LET l_shb.shb28  = l_rvv.rvv36   #委外採購單號      
               LET l_shb.shb29  = l_rvv.rvv04   #委外收貨單號      
               LET l_shb.shb27  = l_pmm09       #委外廠商        
             # IF NOT t700sub_gen_shb(l_shb.*,l_ecm.*) THEN       #FUN-A70095 
               IF NOT t700sub_gen_shb('1',l_shb.*,l_ecm.*,p_shb.shb32) THEN   #FUN-A70095  #FOR號機管理
                  LET g_success='N'
                  EXIT FOR
               END IF
               LET l_totqty = l_totqty + l_repqty
               IF l_totqty > = l_outqty THEN
                 #EXIT FOR      #TQC-B20161
                  EXIT FOREACH  #TQC-B20161
               END IF
            END FOREACH
         ELSE  #委外站,又勾選自動產生報工,但系統參數未設定自動收貨/入庫
            LET g_success='N'
            EXIT FOR
         END IF
      ELSE
         LET l_shb.shb14 = NULL   #入庫單號  
         LET l_shb.shb15 = NULL   #項次    
         LET l_shb.shb28 = NULL   #委外採購單號      
         LET l_shb.shb29 = NULL   #委外收貨單號      
         LET l_shb.shb27 = NULL   #委外廠商        
      #  IF NOT t700sub_gen_shb(l_shb.*,l_ecm.*) THEN      #FUN-A70095
         IF NOT t700sub_gen_shb('1',l_shb.*,l_ecm.*,p_shb.shb32) THEN  #FUN-A70095 #FOR號機管理
            LET g_success='N'
            EXIT FOR
         END IF
      END IF

   END FOR
END FUNCTION

#FUNCTION t700sub_gen_shb(l_shb,l_ecm)                #FUN-A70095
# 根據傳入的p_type參數判斷工單合拼or號機管理 1、號機管理 2、工單合拼	
FUNCTION t700sub_gen_shb(p_type,l_shb,l_ecm,p_shb32)  #FUN-A70095
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_shb       RECORD LIKE shb_file.*
   DEFINE l_ecm       RECORD LIKE ecm_file.*
   DEFINE l_factor    LIKE ecm_file.ecm59
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_i         LIKE type_file.num5
   DEFINE p_type      LIKE type_file.chr1   #FUN-A70095
   DEFINE p_shb32     LIKE shb_file.shb32   #FUN-A70095
   DEFINE l_sfb08    LIKE sfb_file.sfb08  #MOD-D20173

   CALL s_auto_assign_no("asf",l_shb.shb01,l_shb.shb03,"9","shb_file","shb01","","","")
      RETURNING li_result,l_shb.shb01
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF

   LET l_shb.shb012 = l_ecm.ecm012
   LET l_shb.shb06  = l_ecm.ecm03
   LET l_shb.shb081 = l_ecm.ecm04

   IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF

   #將ecm相關欄位帶入shb
  #CALL t700sub_shb081(l_shb.*,l_ecm.*,l_shb.*)        #MOD-C60147 mark
   CALL t700sub_shb081(l_shb.*,l_ecm.*,l_shb.*,'N')    #MOD-C60147 add 
      RETURNING l_i,l_shb.*,l_ecm.*

   IF l_i = 1 THEN  #有錯誤
      RETURN FALSE
   END IF
   SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = l_shb.shb05  #MOD-D20173 
   IF g_sma.sma1435='N' OR l_shb.shb032 = 0 THEN  #FUN-B10054
      #LET l_shb.shb032 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm14 / 60  #MOD-D20173
      LET l_shb.shb032 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm14 / l_sfb08 / 60  #MOD-D20173
   END IF  #FUN-B10054
   IF g_sma.sma1435='N' OR l_shb.shb033 = 0 THEN  #FUN-B10054
      #LET l_shb.shb033 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm16 / 60  #MOD-D20173
      LET l_shb.shb033 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm16 / l_sfb08 / 60  #MOD-D20173
   END IF

   LET l_shb.shb30 = 'Y'
   CALL t700sub_shb26_31(l_shb.shb05,l_shb.shb012,l_shb.shb06) 
      RETURNING l_shb.shb26,l_shb.shb31
   IF cl_null(l_shb.shbconf) THEN  LET l_shb.shbconf = 'N' END IF    #FUN-A70095
   INSERT INTO shb_file VALUES (l_shb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb05,SQLCA.sqlcode,1)
      RETURN FALSE
   END IF

   CALL cl_flow_notify(l_shb.shb01,'I')
#FUN-A70095 --------------------Begin----------------------
   IF p_type = '1' THEN
      CALL t700sub_confirm(l_shb.shb01,p_shb32)
      IF g_success = 'Y' THEN
         RETURN TRUE
      ELSE
         RETURN FALSE
      END IF
   END IF  
#  CALL t700sub_upd_ecm('a',l_shb.*)    # Update 製程追蹤檔
#     RETURNING l_shb.*

#  IF g_success='N' THEN
#     RETURN FALSE
#  END IF

#  IF l_shb.shb112 > 0 THEN    #表示有報廢數量
#     SELECT ima55 INTO l_ima55 FROM ima_file 
#      WHERE ima01= l_shb.shb10

#     CALL s_umfchk(l_shb.shb10,l_ecm.ecm58,l_ima55)                                                   
#              RETURNING l_i,l_factor

#     IF l_i = '1' THEN                                                                                             
#        LET l_factor = 1
#     END IF
#     UPDATE sfb_file SET sfb12 = sfb12 + (l_shb.shb112 * l_factor)
#      WHERE sfb01 = l_shb.shb05 
#     IF SQLCA.sqlerrd[3] = 0  THEN 
#        CALL cl_err(l_shb.shb05,'asf-861',1)
#        RETURN FALSE
#     END IF
#  END IF
#FUN-A70095 --------------------End-------------------------
   RETURN TRUE
END FUNCTION

#FUNCTION t700sub_shb081(l_shb,l_ecm,l_shb_t)         #MOD-C60147 mark
FUNCTION t700sub_shb081(l_shb,l_ecm,l_shb_t,l_flag)   #MOD-C60147 add
   DEFINE l_shb    RECORD LIKE shb_file.*
   DEFINE l_shb_t  RECORD LIKE shb_file.*
   DEFINE l_ecm    RECORD LIKE ecm_file.*
   DEFINE l_sha041 LIKE sha_file.sha041  #MOD-A50114 add 
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_flag   LIKE type_file.chr1   #MOD-C60147 add

   IF cl_null(l_shb.shb012) THEN LET l_shb.shb012=' ' END IF #FUN-A60095
   #LET l_shb.shb06 = NULL  #TQC-960363 add  #FUN-A80102 mark

   SELECT shb32,shbconf INTO l_shb.shb32,l_shb.shbconf FROM shb_file   #FUN-A70095
    WHERE shb01 = l_shb.shb01                                          #FUN-A70095    

  #MOD-C60147 str mark-----
  #IF NOT cl_null(l_shb.shb06) THEN
  #   SELECT COUNT(*) INTO l_cnt FROM ecm_file
  #    WHERE ecm01=l_shb.shb05 AND ecm04=l_shb.shb081
  #      AND ecm03=l_shb.shb06
  #      AND ecm012=l_shb.shb012  #FUN-A50066
  #ELSE
  #MOD-C60147 end mark-----
      SELECT COUNT(*) INTO l_cnt FROM ecm_file
       WHERE ecm01=l_shb.shb05 AND ecm04=l_shb.shb081
         AND ecm012=l_shb.shb012  #FUN-A50066
  #END IF    #MOD-C60147 mark

   CASE
     WHEN l_cnt=0
          CALL cl_err(l_shb.shb081,'aec-015',1)
          LET l_shb.shb081 = l_shb_t.shb081
          LET l_shb.shb06 = l_shb_t.shb06
          RETURN 1,l_shb.*,l_ecm.*    #MOD-640104  -1 -> 1
     WHEN l_cnt=1
         #MOD-C60147 str mark-----
         #IF NOT cl_null(l_shb.shb06) THEN
         #    SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.*
         #      INTO l_shb.shb06,l_shb.shb09,l_shb.shb082,l_shb.shb07,
         #           l_ecm.*
         #      FROM ecm_file
         #     WHERE ecm01=l_shb.shb05 AND ecm04=l_shb.shb081
         #       AND ecm03=l_shb.shb06
         #       AND ecm012=l_shb.shb012  #FUN-A50066
         #ELSE
         #MOD-C60147 end mark-----
              SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.*
                INTO l_shb.shb06,l_shb.shb09,l_shb.shb082,l_shb.shb07,
                     l_ecm.*
                FROM ecm_file
               WHERE ecm01=l_shb.shb05 AND ecm04=l_shb.shb081
                 AND ecm012=l_shb.shb012  #FUN-A50066
         #END IF                          #MOD-C60147 mark
          IF STATUS THEN  #資料資料不存在
             CALL cl_err(l_shb.shb081,STATUS,0)
             LET l_shb.shb081 = l_shb_t.shb081
             LET l_shb.shb06 = l_shb_t.shb06
             RETURN 1,l_shb.*,l_ecm.*    #MOD-640104  -1 -> 1
          END IF
     WHEN l_cnt>1 AND l_flag = 'Y'     #MOD-C60147 add AND l_flag = 'Y'
         #FUN-A80102(S)  
         #如果手動輸入作業編號存在兩個製程序,則需讓使用者開窗挑選製程序
         #IF g_chr = 'Y' THEN
         #   LET l_shb.shb06 = l_shb06
         #ELSE
            #CALL q_ecm(FALSE,FALSE,l_shb.shb05,l_shb.shb081)   #FUN-C30163 mark
             CALL q_ecm(FALSE,FALSE,l_shb.shb05,l_shb.shb081,'','','','')  #FUN-C30163 add
                RETURNING l_shb.shb081,l_shb.shb06
         #END IF    #MOD-9B0151
         #FUN-A80102(E)
          SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.*
            INTO l_shb.shb06,l_shb.shb09,l_shb.shb082,l_shb.shb07,
                 l_ecm.*
            FROM ecm_file
           WHERE ecm01=l_shb.shb05 AND ecm04=l_shb.shb081
             AND ecm03=l_shb.shb06
             AND ecm012=l_shb.shb012  #FUN-A50066
          IF STATUS THEN  #資料資料不存在
             CALL cl_err(l_shb.shb081,STATUS,0)
             LET l_shb.shb081 = l_shb_t.shb081
             LET l_shb.shb06 = l_shb_t.shb06
             RETURN 1,l_shb.*,l_ecm.*    #MOD-640104  -1 -> 1
          END IF
   END CASE
   
   IF NOT cl_null(l_ecm.ecm56) OR
      NOT cl_null(l_ecm.ecm55) THEN   #FUN-560053
      LET l_shb.shb081 = l_shb_t.shb081
      LET l_shb.shb06 = l_shb_t.shb06
      IF NOT cl_null(l_ecm.ecm56) THEN
          CALL cl_err('','asf-083',0)
      ELSE
          CALL cl_err('','asf-084',0)
      END IF
      RETURN 1,l_shb.*,l_ecm.*    #MOD-640104  -1 -> 1
   END IF
   IF g_sma.sma901 = 'Y' THEN 
      IF g_sma.sma917 = 0 THEN 
          #工作站
          LET l_shb.shb09 = l_shb.shb07
      END IF
   END IF
   
   #str MOD-A50114 add
   #若該製程有check-in的程序,應該以check-in的日期、時間預設開工日期、時間
   IF l_ecm.ecm54='Y' THEN
      LET l_sha041=''
      SELECT sha04,sha041 INTO l_shb.shb02,l_sha041
        FROM sha_file
       WHERE sha01=l_shb.shb05
         AND sha02=l_shb.shb06
         AND (sha08 IS NULL OR sha08=' ')
      LET l_shb.shb021=l_sha041[1,5]
   END IF
   #end MOD-A50114 add
 
   CALL t700sub_shb26_31(l_shb.shb05,l_shb.shb012,l_shb.shb06) 
      RETURNING l_shb.shb26,l_shb.shb31 #FUN-A80102
   RETURN 0,l_shb.*,l_ecm.*
END FUNCTION

FUNCTION t700sub_gen_next_po(p_shb)
   DEFINE p_shb     RECORD LIKE shb_file.* 
   DEFINE l_flag    LIKE type_file.num5
   DEFINE l_wip     LIKE ecm_file.ecm321
   DEFINE l_ecm     RECORD LIKE ecm_file.*
   DEFINE l_smy76   LIKE smy_file.smy76
   DEFINE l_ecm012  LIKE ecm_file.ecm012
   DEFINE l_ecm03   LIKE ecm_file.ecm03
   DEFINE l_tot     LIKE pmm_file.pmm40
   DEFINE l_tott    LIKE pmm_file.pmm40t
   DEFINE lr_pmm    RECORD LIKE pmm_file.*
   DEFINE lr_pmn    RECORD LIKE pmn_file.*
   DEFINE li_result LIKE type_file.num5
   DEFINE l_pmm01   LIKE pmm_file.pmm01
   DEFINE l_pmm04   LIKE pmm_file.pmm04
   DEFINE l_pmm09   LIKE pmm_file.pmm09      
   DEFINE l_pmm12   LIKE pmm_file.pmm12      
   DEFINE l_pmm22   LIKE pmm_file.pmm22
   DEFINE l_pmm21   LIKE pmm_file.pmm21
   DEFINE l_t1      LIKE type_file.chr5

   IF g_sma.sma1432='N' OR cl_null(g_sma.sma1432) THEN
      RETURN
   END IF
   
   CALL s_schdat_next_ecm03(p_shb.shb05,p_shb.shb012,p_shb.shb06) 
      RETURNING l_ecm012,l_ecm03

   #檢查是否有下製程站(不跨製程段)
   IF (l_ecm012 <> p_shb.shb012) OR (cl_null(l_ecm03)) THEN
      RETURN
   END IF

   SELECT * INTO l_ecm.* FROM ecm_file
    WHERE ecm01  = p_shb.shb05
      AND ecm012 = l_ecm012
      AND ecm03  = l_ecm03
   
  #IF l_ecm.ecm52='N' THEN RETURN END IF    #MOD-C70242 mark
   IF l_ecm.ecm52<>'Y' THEN RETURN END IF   #MOD-C70242 add

   #本站可委外量
   CALL s_sub_available_qty(l_ecm.ecm01,l_ecm.ecm012,l_ecm.ecm03)
        RETURNING l_flag,l_wip

   IF l_wip < = 0 THEN  #採購單已自行開立
      RETURN
   END IF
   
   LET l_t1 = s_get_doc_no(p_shb.shb01)
   SELECT smy76 INTO l_smy76 FROM smy_file
                            WHERE smyslip = l_t1
   IF cl_null(l_smy76) THEN
      CALL cl_err(l_ecm.ecm03,'asf-162',1)
      LET g_success='N'
      RETURN
   END IF

   CALL s_auto_assign_no("apm",l_smy76,p_shb.shb03,"2","pmm_file","pmm01","","","")
        RETURNING li_result,l_pmm01
   IF (NOT li_result) THEN
      CALL cl_err(l_ecm.ecm03,'apm-920',1)
      LET g_success='N'
      RETURN
   END IF

   IF cl_null(l_ecm.ecm67) THEN
      CALL cl_err(l_ecm.ecm03,'axm-117',1)
      LET g_success='N'
      RETURN
   END IF
   LET l_pmm04 = p_shb.shb03
   LET l_pmm09 = l_ecm.ecm67
   LET l_pmm12 = p_shb.shb04
   SELECT pmc47,pmc22 INTO l_pmm21,l_pmm22 
     FROM pmc_file
    WHERE pmc01=l_pmm09
   IF cl_null(l_pmm22) THEN LET l_pmm22 = g_aza.aza17 END IF

   CALL p700sub_pmm(l_pmm01,l_pmm04,l_pmm09,l_pmm12,l_pmm22) RETURNING lr_pmm.*
   LET lr_pmm.pmm21 = l_pmm21

   INSERT INTO pmm_file VALUES (lr_pmm.*)
   IF STATUS THEN
      CALL cl_err('ins pmm',STATUS,1)
      LET g_success='N'
      RETURN
   END IF

   SELECT sfb05 INTO lr_pmn.pmn04 FROM sfb_file
               WHERE sfb01 = p_shb.shb05
   CALL s_defprice_new(lr_pmn.pmn04,lr_pmm.pmm09,lr_pmm.pmm22,lr_pmm.pmm04,
                       l_ecm.ecm58,l_ecm.ecm04,lr_pmm.pmm21,lr_pmm.pmm43,'2',
                       l_ecm.ecm58,'',lr_pmm.pmm41,lr_pmm.pmm20,lr_pmm.pmmplant)
          RETURNING lr_pmn.pmn31,lr_pmn.pmn31t,
                    lr_pmn.pmn73,lr_pmn.pmn74    #TQC-AC0257 add
   IF cl_null(lr_pmn.pmn73) THEN LET lr_pmn.pmn73='4' END IF #TQC-AC0257
   IF lr_pmn.pmn31=0 OR lr_pmn.pmn31t=0 THEN
      CALL cl_err('ins pmm','axr-033',1)
      LET g_success='N'
      RETURN
   END IF
   LET lr_pmn.pmn13 =0
   CALL s_overate(lr_pmn.pmn04) RETURNING lr_pmn.pmn13

   CALL p700sub_pmn(lr_pmm.pmm01,1,lr_pmn.pmn04,l_ecm.ecm01,l_ecm.ecm012,l_ecm.ecm03,
   #                l_wip,lr_pmn.pmn31,'',lr_pmn.pmn31,p_shb.shb03,lr_pmn.pmn13,   #CHI-B40065
                    l_wip,lr_pmn.pmn31,'',lr_pmn.pmn31t,p_shb.shb03,lr_pmn.pmn13,   #CHI-B40065
                    lr_pmm.pmm22) RETURNING lr_pmn.*
   SELECT ima35,ima36 INTO lr_pmn.pmn52,lr_pmn.pmn54 FROM ima_file WHERE ima01 = lr_pmn.pmn04
   IF cl_null(lr_pmn.pmn58) THEN LET lr_pmn.pmn58 = 0 END IF    #No.FUN-B30177

   IF cl_null(lr_pmn.pmn56) THEN LET lr_pmn.pmn56 = ' ' END IF   #FUN-A70095
   CALL s_schdat_pmn78(lr_pmn.pmn41,lr_pmn.pmn012,lr_pmn.pmn43,lr_pmn.pmn18,   #FUN-C10002
                                   lr_pmn.pmn32) RETURNING lr_pmn.pmn78      #FUN-C10002
   INSERT INTO pmn_file VALUES (lr_pmn.*)
   IF STATUS THEN
      CALL cl_err('ins pmn',STATUS,1)
      LET g_success='N'
      RETURN
   END IF

#  SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)   #CHI-B70039 mark
   SELECT SUM(pmn87*pmn31),SUM(pmn87*pmn31t)   #CHI-B70039
     INTO l_tot,l_tott
     FROM pmn_file
    WHERE pmn01 = lr_pmm.pmm01
   LET l_tot = cl_digcut(l_tot,t_azi04)
   LET l_tott= cl_digcut(l_tott,t_azi04)
   UPDATE pmm_file SET pmm40 = l_tot,pmm40t= l_tott
    WHERE pmm01 = lr_pmm.pmm01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
      CALL cl_err('upd pmm',SQLCA.sqlcode,1)
      RETURN
   END IF
   
   CALL t540sub_y_chk(lr_pmm.*)
   IF g_success = "Y" THEN
      CALL t540sub_y_upd(lr_pmm.pmm01," ")
   END IF
   IF g_success = "Y" THEN
      CALL p610sub_update(lr_pmm.pmm01,FALSE)
      IF g_success = 'Y' THEN
         CALL p610sub_sfb(lr_pmm.pmm01)
      END IF
   END IF
END FUNCTION

FUNCTION t700sub_gen_ro(l_shb,p_roqty)
   DEFINE l_shb    RECORD LIKE shb_file.*
   DEFINE l_rva    RECORD LIKE rva_file.*
   DEFINE l_rvb    RECORD LIKE rvb_file.*
   DEFINE l_flag   LIKE type_file.num5
   DEFINE l_pmm    RECORD LIKE pmm_file.*
   DEFINE l_pmn    RECORD LIKE pmn_file.*
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_totqty LIKE rvb_file.rvb07
   DEFINE l_qty    LIKE rvb_file.rvb07
   DEFINE p_roqty  LIKE rvb_file.rvb07
   DEFINE l_roqty  LIKE rvb_file.rvb07
   DEFINE l_sql    STRING
   DEFINE l_t1     LIKE type_file.chr5
   
   LET l_rva.rva06 = l_shb.shb03
   LET l_rva.rva05 = l_shb.shb27
   LET l_rva.rva33 = l_shb.shb04   #TQC-B20161
   IF NOT cl_null(g_sma.sma53) AND l_rva.rva06 <= g_sma.sma53 THEN
      CALL cl_err(l_shb.shb06,'mfg9999',1)
      LET g_success='N'
      RETURN
   END IF

   LET l_t1 = s_get_doc_no(l_shb.shb01)
   SELECT smy77 INTO l_rva.rva01 
                FROM smy_file
               WHERE smyslip = l_t1
   IF cl_null(l_rva.rva01) THEN
      CALL cl_err(l_shb.shb06,'asf-163',1)
      LET g_success='N'
      RETURN
   END IF

   CALL s_auto_assign_no("APM",l_rva.rva01,l_rva.rva06,"3","rva_file","rva01","","","")
        RETURNING l_flag, l_rva.rva01
   IF NOT l_flag THEN
      CALL cl_err(l_shb.shb06,'apm-920',1)
      LET g_success='N'
      RETURN
   END IF

   CALL t700sub_set_rva_def(l_rva.*) RETURNING l_rva.*

   INSERT INTO rva_file VALUES (l_rva.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins rva',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF

   CALL cl_flow_notify(l_rva.rva01,'I')  #新增資料到 p_flow

   LET l_totqty = 0
   LET l_cnt = 1
   LET l_sql = "SELECT pmm_file.*,pmn_file.* FROM pmm_file,pmn_file ",
               " WHERE pmm18 <> 'X' ",
               "   AND (pmn20-pmn50+pmn55+pmn58>0) ",
               "   AND pmm01 = pmn01 AND pmn16='2' ",
               "   AND pmn41 = '",l_shb.shb05,"' ",
               "   AND pmn012= '",l_shb.shb012,"' ",
               "   AND pmn43 = ",l_shb.shb06,
               " ORDER BY pmm04 "
   PREPARE t700sub_gen_ro_p FROM l_sql
   DECLARE t700sub_gen_ro_c CURSOR FOR t700sub_gen_ro_p
   FOREACH t700sub_gen_ro_c INTO l_pmm.*,l_pmn.*
      LET l_qty = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55+l_pmn.pmn58
      IF (p_roqty - l_totqty)> l_qty THEN
         LET l_roqty = l_qty
      ELSE
         LET l_roqty = p_roqty - l_totqty
      END IF
      LET l_rvb.rvb01 = l_rva.rva01
      LET l_rvb.rvb02 = l_cnt
      LET l_rvb.rvb03 = l_pmn.pmn02
      LET l_rvb.rvb04 = l_pmn.pmn01
      LET l_rvb.rvb05 = l_pmn.pmn04
      LET l_rvb.rvb07 = l_roqty
      LET l_rvb.rvb36 = l_pmn.pmn52
      LET l_rvb.rvb37 = l_pmn.pmn54
      LET l_rvb.rvb34 = l_pmn.pmn41
      LET l_rvb.rvb90 = l_pmn.pmn07
      LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90)  #FUN-BB0083 add
 #FUN-A70095 ---------Begin---------
      LET l_rvb.rvb38 = l_pmn.pmn56
      IF cl_null(l_rvb.rvb38) THEN
         LET l_rvb.rvb38 = ' '
      END IF
 #FUN-A70095 ---------End-----------   
      IF cl_null(l_rvb.rvb36) THEN
         SELECT ima35,ima36 INTO l_rvb.rvb36,l_rvb.rvb37 
           FROM ima_file WHERE ima01 = l_pmn.pmn04
      END IF
      CALL t700sub_set_rvb_def(l_rva.*,l_rvb.*) 
         RETURNING l_rvb.*
      INSERT INTO rvb_file VALUES (l_rvb.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins rvb',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
      LET l_totqty = l_totqty + l_rvb.rvb07
     #IF p_roqty >= l_totqty THEN    #FUN-A70095
      IF l_totqty >= p_roqty  THEN   #FUN-A70095
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   RETURN l_rva.rva01
END FUNCTION

FUNCTION t700sub_set_rva_def(l_rva)
    DEFINE l_rva RECORD LIKE rva_file.*
 
    IF cl_null(l_rva.rva06) OR l_rva.rva06=0 THEN
       LET l_rva.rva06 = g_today
    END IF
    LET l_rva.rvaprsw = 'Y'
    LET l_rva.rvaprno = 0
    LET l_rva.rva00 = '1'
    LET l_rva.rva10 ='SUB'
    LET l_rva.rva04 = 'N'
    LET l_rva.rva29 = '1'
    LET l_rva.rvaconf = 'N'
    LET l_rva.rvaspc = '0'
    LET l_rva.rvaoriu = g_user
    LET l_rva.rvaorig = g_grup    
    LET l_rva.rvauser=g_user
    LET l_rva.rvagrup=g_grup
    LET l_rva.rvadate=g_today
    LET l_rva.rvaacti='Y'
    LET l_rva.rvaplant = g_plant
    LET l_rva.rvalegal = g_legal
    RETURN l_rva.*
END FUNCTION

FUNCTION t700sub_set_rvb_def(l_rva,l_rvb)
   DEFINE l_rva    RECORD LIKE rva_file.*
   DEFINE l_rvb    RECORD LIKE rvb_file.*
   DEFINE l_ima491 LIKE ima_file.ima491

   LET l_rvb.rvb35 = 'N'
   LET l_rvb.rvb06 = 0
   IF cl_null(l_rvb.rvb07) THEN
      LET l_rvb.rvb07 = 0
   END IF
   LET l_rvb.rvb08 = 0
   LET l_rvb.rvb09 = 0
   LET l_rvb.rvb10 = 0
   LET l_rvb.rvb82 = 0
   LET l_rvb.rvb85 = 0
   LET l_rvb.rvb87 = 0
   LET l_rvb.rvb06  = 0     #已請數量
   LET l_rvb.rvb09  = 0     #允請數量
   LET l_rvb.rvb10  = 0     
   LET l_rvb.rvb10t = 0     
   LET l_rvb.rvb15  = 0     #容器數量
   LET l_rvb.rvb16  = 0     #容器數目
   LET l_rvb.rvb18  = '10'  #收貨狀況
   LET l_rvb.rvb27  = 0     #NO USE
   LET l_rvb.rvb28  = 0     #NO USE
   LET l_rvb.rvb29  = 0     #退補量
   LET l_rvb.rvb32  = 0     #NO USE
   LET l_rvb.rvb31  = 0     #
   LET l_rvb.rvb30  = 0     #入庫量
   LET l_rvb.rvb33  = 0     #入庫量
   LET l_rvb.rvb331 = 0    #允收量
   LET l_rvb.rvb332 = 0    #允收量
   LET l_rvb.rvb35  = 'N'   #樣品否
   LET l_rvb.rvb40  = ''    #檢驗日期
   LET l_rvb.rvb87 = l_rvb.rvb07
   LET l_rvb.rvb86 = l_rvb.rvb90
   LET l_rvb.rvb10 = 0
   IF cl_null(l_rvb.rvb08) OR l_rvb.rvb08 = 0 THEN
      LET l_rvb.rvb08 = l_rvb.rvb07
   END IF
   LET l_rvb.rvb11 = 0
   LET l_rvb.rvb42 = '4'
   LET l_rvb.rvbplant = g_plant
   LET l_rvb.rvblegal = g_legal

   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = l_rvb.rvb05
   IF cl_null(l_ima491) THEN
      LET l_ima491 = 0
   END IF
   IF l_ima491 > 0 THEN
      CALL s_getdate(l_rva.rva06,l_ima491) RETURNING l_rvb.rvb12
   ELSE
      IF cl_null(l_rvb.rvb12) THEN
         LET l_rvb.rvb12 = l_rva.rva06
      END IF
   END IF
   CALL t700sub_get_rvb39(l_rvb.rvb04,l_rvb.rvb05,l_rvb.rvb19,l_rva.rva05) RETURNING l_rvb.rvb39 #CHI-8A0025
 
   RETURN l_rvb.*
END FUNCTION

FUNCTION t700sub_get_rvb39(p_rvb04,p_rvb05,p_rvb19,p_rva05)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915
   DEFINE p_rva05   LIKE rva_file.rva05
 
  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
  #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制       
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
 
   IF l_ima915='2' OR l_ima915='3' THEN
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04
 
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=p_rva05
         AND pmh13=l_pmm22
         AND pmhacti = 'Y'                                           #CHI-910021
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
 
END FUNCTION

#FUN-A80060--begin--add-------------------------
FUNCTION t700sub_auto_Combined_Wo(p_shb,p_sfd05,p_shb24)
   DEFINE p_shb      RECORD LIKE shb_file.*
   DEFINE l_sql      STRING
   DEFINE l_shb      RECORD LIKE shb_file.*
   DEFINE l_ecm      RECORD LIKE ecm_file.*
   DEFINE p_shb24    LIKE shb_file.shb24
   DEFINE p_sfd05    LIKE sfd_file.sfd05
   DEFINE l_sfd05    LIKE sfd_file.sfd05
   DEFINE l_sfd07    LIKE sfd_file.sfd07
   DEFINE l_sfb01    LIKE sfb_file.sfb01
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_sfb85    LIKE sfb_file.sfb85
   DEFINE l_t1       LIKE type_file.chr5
   DEFINE l_wip      LIKE shb_file.shb111
   DEFINE l_pqc      LIKE qcm_file.qcm091  
   DEFINE l_tot_pqc  LIKE shb_file.shb111
   DEFINE l_ecm53    LIKE ecm_file.ecm53
   DEFINE l_ecm54    LIKE ecm_file.ecm54
   DEFINE l_flag     LIKE type_file.num5
   DEFINE l_shb34    LIKE shb_file.shb34   #No.FUN-BB0086
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   SELECT sfb85 INTO l_sfb85 FROM sfb_file WHERE sfb01=p_shb.shb05
   LET l_sql="SELECT sfb01,sfd05,sfd07  FROM sfd_file,sfb_file ",
              " WHERE sfd01='",l_sfb85,"'", 
              "   AND sfd03=sfb01 ",
              "   AND sfd03<>'",p_shb.shb05,"'",
              " ORDER BY sfb01"
   PREPARE t700sub_sfb_p1 FROM l_sql
   DECLARE t700sub_sfb_c1 CURSOR FOR t700sub_sfb_p1
   FOREACH t700sub_sfb_c1 INTO l_sfb01,l_sfd05,l_sfd07
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM ecm_file
       WHERE ecm01=l_sfb01 AND ecm012=l_sfd07
         AND ecm04=p_shb.shb081
      IF l_cnt > 0 THEN
         INITIALIZE l_shb.* TO NULL
         LET l_shb.* = p_shb.*
         LET l_shb.shb111=p_shb.shb111*l_sfd05/p_sfd05
         LET l_shb.shb112=p_shb.shb112*l_sfd05/p_sfd05
         LET l_shb.shb113=p_shb.shb113*l_sfd05/p_sfd05
         LET l_shb.shb114=p_shb.shb114*l_sfd05/p_sfd05
         LET l_shb.shb115=p_shb.shb115*l_sfd05/p_sfd05
         LET l_shb.shb17 =p_shb.shb17 *l_sfd05/p_sfd05
         #No.FUN-BB0086--add--begin--
         SELECT ecm58 INTO l_shb34 FROM ecm_file
          WHERE ecm01=g_shb.shb05
            AND emc03=g_shb.shb06
            AND ecm012=g_shb.shb012
         LET l_shb.shb111 = s_digqty(l_shb.shb111,l_shb34)
         LET l_shb.shb112 = s_digqty(l_shb.shb112,l_shb34)
         LET l_shb.shb113 = s_digqty(l_shb.shb113,l_shb34)
         LET l_shb.shb114 = s_digqty(l_shb.shb114,l_shb34)
         LET l_shb.shb115 = s_digqty(l_shb.shb115,l_shb34)
         LET l_shb.shb17 = s_digqty(l_shb.shb17,l_shb34)
         #No.FUN-BB0086--add--end--
         LET l_shb.shb032=p_shb.shb032*l_sfd05/p_sfd05   #FUN-B10054
         LET l_shb.shb033=p_shb.shb033*l_sfd05/p_sfd05   #FUN-B10054
         DECLARE ecm_curs CURSOR FOR
          SELECT *  FROM ecm_file
           WHERE ecm01=l_sfb01 AND ecm04=p_shb.shb081
             AND ecm012=l_sfd07
         FOREACH ecm_curs INTO l_ecm.*
           EXIT FOREACH
         END FOREACH
         LET l_t1  = s_get_doc_no(p_shb.shb01)
         LET l_shb.shb01  = l_t1
         LET l_shb.shb05  = l_sfb01
         LET l_shb.shb012 = l_sfd07
         LET l_shb.shb081=l_ecm.ecm04
         LET l_shb.shb082=l_ecm.ecm45
         LET l_shb.shb06=l_ecm.ecm03
         LET l_shb.shb23=l_sfb85
         LET l_shb.shb24=p_shb24
         LET l_shb.shbconf = 'N' #FUN-A70095
         LET l_shb.shb32 = ' '   #FUN-A70095    
         SELECT sfb05 INTO l_shb.shb10 FROM sfb_file WHERE sfb01=l_sfb01
         CALL t700sub_accept_qty('a',l_shb.*) RETURNING l_flag,l_wip,l_pqc,l_ecm53,l_ecm54,l_tot_pqc
         IF l_flag = -1 THEN LET g_success='N' CALL cl_err('','asf-167',1) EXIT FOREACH END IF
       # IF NOT t700sub_gen_shb(l_shb.*,l_ecm.*) THEN       #FUN-A70095
         IF NOT t700sub_gen_shb('2',l_shb.*,l_ecm.*,p_shb.shb32) THEN   #FUN-A70095 for 工單合拼
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF        
   END FOREACH
   
END FUNCTION

FUNCTION t700sub_accept_qty(p_cmd,p_shb)
DEFINE p_cmd      LIKE type_file.chr1,   
       l_wip_qty  LIKE shb_file.shb111,
       l_pqc_qty  LIKE qcm_file.qcm091,   #良品數
       l_sum_qty  LIKE qcm_file.qcm091
DEFINE l_bn_ecm012 LIKE ecm_file.ecm012  #FUN-A80102
DEFINE l_bn_ecm03  LIKE ecm_file.ecm03   #FUN-A80102
DEFINE l_tot_pqc   LIKE shb_file.shb111
DEFINE p_shb       RECORD LIKE shb_file.*
DEFINE l_ecm       RECORD LIKE ecm_file.*
DEFINE l_msg       STRING
DEFINE l_shb112    LIKE shb_file.shb112  #MOD-D60212
DEFINE l_qcm22     LIKE qcm_file.qcm22   #MOD-D60212
 
#      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#           -委外加工量(h)+委外完工量(i)
#      WIP量指目前在該站的在製量，
#      若系統參數定義要做Check-In時，WIP量尚可區
#      分為等待上線數量與上線處理數量。
#      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#                 -委外加工量(h)+委外完工量(i)
#      等待上線數量=線投入量(a+b)-Check-In量(c)
 
#      若該站允許做製程委外，則
#      可委外加工量=WIP量-委外加工量(h)
#      委外在外量=委外加工量(h)-委外完工量(i)
 
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
      
       IF cl_null(p_shb.shb012) THEN LET p_shb.shb012=' ' END IF 
       SELECT * INTO l_ecm.* FROM ecm_file
        WHERE ecm01=p_shb.shb05 AND ecm03=p_shb.shb06
          AND ecm012=p_shb.shb012
       IF STATUS THEN  #資料資料不存在
          CALL cl_err('sel ecm_file',STATUS,1)
          RETURN -1,l_wip_qty,l_pqc_qty,l_ecm.ecm53,l_ecm.ecm54,l_tot_pqc
       END IF
       
       IF g_sma.sma1431='N' OR cl_null(g_sma.sma1431) THEN   #FUN-A80102
          IF cl_null(p_shb.shb14) AND cl_null(p_shb.shb15) THEN
             IF l_ecm.ecm54='Y' THEN   #check in 否
                LET l_wip_qty =  l_ecm.ecm291                #check in
                               - l_ecm.ecm311                #良品轉出
                               - l_ecm.ecm312                #重工轉出
                               - l_ecm.ecm313                #當站報廢
                               - l_ecm.ecm314                #當站下線
                               - l_ecm.ecm316                #工單轉出
                               - l_ecm.ecm321                #委外加工量
                               + l_ecm.ecm322                #委外完工量
             ELSE
                LET l_wip_qty =  l_ecm.ecm301                #良品轉入量
                               + l_ecm.ecm302                #重工轉入量
                               + l_ecm.ecm303                #工單轉入
                               - l_ecm.ecm311                #良品轉出
                               - l_ecm.ecm312                #重工轉出
                               - l_ecm.ecm313                #當站報廢
                               - l_ecm.ecm314                #當站下線
                               - l_ecm.ecm316                #工單轉出
                               - l_ecm.ecm321                #委外加工量
                               + l_ecm.ecm322                #委外完工量
             END IF
          ELSE
             LET l_wip_qty = l_ecm.ecm321 - l_ecm.ecm322  
          END IF
       #FUN-A60102(S)
       ELSE
          CALL t700sub_check_auto_report(p_shb.shb05,'',p_shb.shb012,p_shb.shb06) 
             RETURNING l_bn_ecm012,l_bn_ecm03,l_wip_qty 
       #TQC-C20361 --------------Begin---------------
       #此邏輯段移到t700sub_check_auto_report()
       #    #--------------No:MOD-BB0314 add
       #    #t700sub_check_auto_report篹出來的l_wip_qty世位扣掉本站已轉出數量，所以須再扣除
       #     LET l_wip_qty = l_wip_qty 
       #                   - l_ecm.ecm311                #良品轉出
       #                   - l_ecm.ecm312                #重工轉出
       #                   - l_ecm.ecm313                #當站報廢
       #                   - l_ecm.ecm314                #當站下線
       #                   - l_ecm.ecm316                #工單轉出
       #                   - l_ecm.ecm321                #委外加工量
       #                   + l_ecm.ecm322                #委外完工量
       #    #--------------No:MOD-BB0314 end
       #TQC-C20361 --------------End-----------------
       #FUN-A60102(E)
       END IF
       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
 
       LET l_sum_qty=p_shb.shb111+p_shb.shb113+p_shb.shb112+p_shb.shb114+p_shb.shb17
 
       IF l_sum_qty>l_wip_qty AND p_cmd<>'d' AND p_cmd<>'s' THEN 
          LET l_msg=p_shb.shb05," WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
          CALL cl_err(l_msg,'asf-801',1)
          RETURN -1,l_wip_qty,l_pqc_qty,l_ecm.ecm53,l_ecm.ecm54,l_tot_pqc
       END IF
 
#      若該站製程追蹤檔中定義本站需要做PQC檢查，
#      則可報工數量尚需滿足以下條件:
#          可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
#      DISPLAY '' TO FORMONLY.tot_pqc
       IF l_ecm.ecm53='Y' THEN   #PQC
         #SELECT SUM(qcm091) INTO l_pqc_qty FROM qcm_file                     #MOD-D60212 mark
          SELECT SUM(qcm091),SUM(qcm22) INTO l_pqc_qty,l_qcm22 FROM qcm_file  #MOD-D60212 add qcm22
           WHERE qcm02=p_shb.shb05   #工單編號
             AND qcm05=p_shb.shb06   #製程序號
             AND qcm14='Y'  #確認
            #AND qcm012=g_shb.shb012  #FUN-BC0104  #TQC-C20298
             AND qcm012=p_shb.shb012  #FUN-BC0104  #TQC-C20298
             AND (qcm09='1' OR qcm09='3')  #判定結果(1.Accept  3.特採) 
          IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
          LET l_tot_pqc = l_pqc_qty 

          #MOD-D60212 add begin--------------------
          SELECT SUM(shb112) INTO l_shb112 FROM shb_file
           WHERE shb05 = p_shb.shb05 
             AND shb06 = p_shb.shb06
             AND shb012 = p_shb.shb012
             AND shbconf = 'Y'
          IF cl_null(l_shb112) THEN LET l_shb112 = 0 END IF 
          #MOD-D60212 add end----------------------
 
          IF cl_null(l_ecm.ecm311) THEN LET l_ecm.ecm311=0 END IF
          IF cl_null(l_ecm.ecm312) THEN LET l_ecm.ecm312=0 END IF
          IF cl_null(l_ecm.ecm313) THEN LET l_ecm.ecm313=0 END IF
          IF cl_null(l_ecm.ecm314) THEN LET l_ecm.ecm314=0 END IF
          IF cl_null(l_ecm.ecm302) THEN LET l_ecm.ecm302=0 END IF
          IF cl_null(l_ecm.ecm303) THEN LET l_ecm.ecm303=0 END IF
          IF cl_null(l_ecm.ecm316) THEN LET l_ecm.ecm316=0 END IF
 
          LET l_pqc_qty=l_pqc_qty - l_ecm.ecm311    #良品轉出
                                  - l_ecm.ecm312    #重工轉出
                                  - l_ecm.ecm314    #當站下線
                                  - l_ecm.ecm316    #工單轉出
                                  + l_ecm.ecm302
 
         #IF l_sum_qty-p_shb.shb112>l_pqc_qty AND p_cmd<>'d'
          IF l_sum_qty-p_shb.shb112>l_pqc_qty AND p_cmd<>'d' AND p_cmd<>'s'   #TQC-B60153
             THEN
             LET l_msg=p_shb.shb05," WIP:",l_wip_qty USING "<<<<.<<" CLIPPED,
                       "  PQC:",l_pqc_qty USING "<<<<.<<" CLIPPED
             CALL cl_err(l_msg,'asf-802',1)
             RETURN -1,l_wip_qty,l_pqc_qty,l_ecm.ecm53,l_ecm.ecm54,l_tot_pqc
          END IF
#MOD-D60212 add begin--------------------
          IF p_shb.shb112 > l_qcm22 - l_tot_pqc - l_shb112 AND p_cmd<>'d' AND p_cmd<>'s' THEN 
             CALL cl_err(l_msg,'asf1051',1)
             RETURN -1,l_wip_qty,l_pqc_qty,l_ecm.ecm53,l_ecm.ecm54,l_tot_pqc
          END IF 
#MOD-D60212 add end----------------------
       END IF
       RETURN 0,l_wip_qty,l_pqc_qty,l_ecm.ecm53,l_ecm.ecm54,l_tot_pqc
END FUNCTION
#FUN-A80060--end--add------------------------
#MOD-D30233---begin mark
##MOD-CB0209---add----------------------------S
##最後一站良品轉出+全部當站轉出(不考慮重工轉出)-Bonus(除最後一站)
#FUNCTION t700_chk_input(p_shb01_1,p_shb05_1,p_shb111,p_shb112,p_shb114,p_shb17)
#   DEFINE l_bonus_2   LIKE shb_file.shb115,
#          l_ecm311_2  LIKE ecm_file.ecm311,
#          l_sum_qty_2 LIKE qcm_file.qcm091, 
#          l_sum_qty_3 LIKE qcm_file.qcm091,
#          l_ima153    LIKE ima_file.ima153,
#          l_min_set   LIKE sfb_file.sfb08,
#          l_wip_qty_2 LIKE shb_file.shb111,
#          p_shb01_1   LIKE shb_file.shb01,
#          p_shb05_1   LIKE shb_file.shb05,
#          p_shb111    LIKE shb_file.shb111,
#          p_shb112    LIKE shb_file.shb112,
#          p_shb114    LIKE shb_file.shb114,
#          p_shb17     LIKE shb_file.shb17,  
#          l_cnt       LIKE type_file.num5,
#          l_shb       RECORD LIKE shb_file.*
#
#   SELECT * INTO l_shb.* FROM shb_file WHERE shb05 = p_shb05_1 
#   
#   #MOD-D30233---begin                                      
#   IF STATUS THEN  #資料資料不存在
#      CALL cl_err('sel shb_file',STATUS,1)
#      RETURN -1
#   END IF                                      
#   #MOD-D30233---end
#       LET l_cnt=0  LET l_min_set=0
#       CALL s_get_ima153(l_shb.shb10) RETURNING l_ima153
#       CALL s_minp_routing(l_shb.shb05,g_sma.sma73,0,l_shb.shb081,l_shb.shb012,l_shb.shb06)
#            RETURNING l_cnt,l_min_set
#
#      #最後站(已確認)良品轉出
#       SELECT SUM(ecm311) INTO l_ecm311_2 FROM ecm_file
#        WHERE ecm01 = l_shb.shb05
#          AND ecm03 IN (SELECT MAX(ecm03) FROM ecm_file
#                         WHERE ecm01 = l_shb.shb05)
#
#      #全部(已確認)當站轉出(不考慮重工轉出shb113)
#       SELECT SUM(ecm313+ecm314+ecm316) INTO l_sum_qty_2 FROM ecm_file
#        WHERE ecm01 = l_shb.shb05
#
#      #Bonus (不包含最後一站)
#       SELECT SUM(ecm315) INTO l_bonus_2 FROM ecm_file
#        WHERE ecm01  = l_shb.shb05
#          AND ecm03 !=(SELECT MAX(ecm03) FROM ecm_file
#                        WHERE ecm01 =l_shb.shb05)
#                         #AND ecm012=l_shb.shb012)
#      #本次轉出數量
#       LET l_wip_qty_2 = p_shb111 +p_shb112 +p_shb114 +p_shb17
#
#       LET l_sum_qty_3 = l_min_set -(l_ecm311_2 +l_sum_qty_2 -l_bonus_2)
#       IF l_wip_qty_2 > l_sum_qty_3 THEN
#          CALL cl_err('','aws-721',1)
#          LET g_success='N'
#          RETURN -1
#       END IF
#       RETURN 0
#END FUNCTION
##MOD-CB0209---add----------------------------E
#MOD-D30233---end
#FUN-A70095 -------------------------Begin----------------------------
#根據傳入值p_flag判斷是走確認段的邏輯還是取消確認段的邏輯
#p_flag = true 走確認段邏輯，false 走取消確認段邏輯
FUNCTION t700sub_y_chk(p_shb01,p_flag)
   DEFINE p_shb01    LIKE shb_file.shb01
   DEFINE p_flag     LIKE type_file.num5 
   DEFINE l_sfb04    LIKE sfb_file.sfb04
   DEFINE l_shb      RECORD LIKE shb_file.*
   DEFINE l_yy,l_mm  LIKE type_file.num5
   DEFINE l_shb012   LIKE shb_file.shb012
   DEFINE l_shb06    LIKE shb_file.shb06
   DEFINE l_shb111   LIKE shb_file.shb111
   DEFINE l_qcm091   LIKE qcm_file.qcm091
   DEFINE l_outqty   LIKE shb_file.shb111
   DEFINE l_qcf091   LIKE qcf_file.qcf091   
   DEFINE l_diff     LIKE qcf_file.qcf091
   DEFINE l_sum1     LIKE ecm_file.ecm311
   DEFINE l_sum2     LIKE sfb_file.sfb09
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_shd07    LIKE shd_file.shd07
   DEFINE l_shj12    LIKE shj_file.shj12
   DEFINE l_sfv09    LIKE sfv_file.sfv09  #TQC-C20007 add
   DEFINE l_n        LIKE type_file.num5

   IF cl_null(p_shb01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_shb.* FROM shb_file  WHERE shb01 = p_shb01
   SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = l_shb.shb05
   IF p_flag THEN
      IF l_shb.shbconf = 'Y' THEN
         CALL cl_err('','asf-148',1)  #MOD-C80032 mod 0->1
         LET g_success = 'N'
         RETURN
      END IF
   END IF 
   IF NOT p_flag THEN
      IF l_shb.shbconf = 'N' THEN
         CALL cl_err('','asf-216',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   IF l_shb.shbconf = 'X' THEN
      CALL cl_err('','asf-149',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_sfb04 = '8' THEN
      CALL cl_err('','asf-211',0)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_yp(l_shb.shb03) RETURNING l_yy,l_mm
   IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較 
      CALL cl_err(l_yy,'asf-212',0)
      LET g_success = 'N'
      RETURN
   ELSE 
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN 
         CALL cl_err(l_mm,'asf-213',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--str--
   IF g_aza.aza115='Y' THEN
      SELECT COUNT(shd02) INTO l_n FROM shd_file WHERE trim(shd18) IS NULL AND shd01=p_shb01 
      IF l_n>=1 THEN
         CALL cl_err('','aim-888',1)
         LET g_success = 'N'
         RETURN
      END IF 
   END IF 
   #FUN-CB0087--add--end--
   IF p_flag THEN
     #CHI-BA0039 str mark------
     #IF l_shb.shb114 > 0 THEN
     #   SELECT SUM(shd07) INTO l_shd07 FROM shd_file  WHERE shd01 = p_shb01
     #   IF SQLCA.sqlcode OR (cl_null(l_shd07)) THEN
     #      LET l_shd07=0
     #   END IF
     #   IF l_shd07<>l_shb.shb114 THEN #轉入總和不等於轉出,show提示
     #      CALL cl_err('','asf-223',1)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
     #END IF
     #CHI-BA0039 end mark------
     #MOD-D60236 add begin------
      IF l_shb.shb114 > 0 THEN
         SELECT SUM(shd07) INTO l_shd07 FROM shd_file  WHERE shd01 = p_shb01
         IF SQLCA.sqlcode OR (cl_null(l_shd07)) THEN
            LET l_shd07=0
         END IF
         IF l_shd07<>l_shb.shb114 THEN #轉入總和不等於轉出,show提示
            CALL cl_err('','asf-223',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #MOD-D60236 add end-------
      IF l_shb.shb17 > 0 THEN
         SELECT SUM(shj12) INTO l_shj12 FROM shj_file
                                       WHERE shj01=p_shb01
         IF SQLCA.sqlcode OR (cl_null(l_shj12)) THEN
            LET l_shj12=0
         END IF
         IF l_shj12<>l_shb.shb17 THEN #轉入總和不等於轉出,show提示
            CALL cl_err('','asf-098',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF  
   END IF 
   IF NOT p_flag THEN
      IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF
      CALL s_schdat_next_ecm03(l_shb.shb05,l_shb.shb012,l_shb.shb06) #取得下一站的製程段製程序
      RETURNING l_shb012,l_shb06
      SELECT SUM(qcm091) INTO l_qcm091 FROM qcm_file
       WHERE qcm02 = l_shb.shb05
         AND qcm05 = l_shb06
         AND qcm012 = l_shb012
         AND qcm14 <> 'X'
      IF cl_null(l_qcm091) THEN LET l_qcm091 = 0 END IF
      SELECT (ecm311+ecm312+ecm313+ecm314+ecm316) INTO l_outqty FROM ecm_file
       WHERE ecm01 = l_shb.shb05
         AND ecm03 = l_shb.shb06
         AND ecm012= l_shb.shb012
      SELECT (shb111+shb112+shb113+shb114+shb17) INTO l_shb111 FROM shb_file
       WHERE shb01=l_shb.shb01
      IF (l_outqty-l_shb111) < l_qcm091 THEN
         CALL cl_err('','asf-219',0)
         LET g_success = 'N'  
         RETURN
      END IF
      IF NOT s_schdat_chk_ecm03(l_shb.shb05,l_shb.shb012,l_shb.shb06) THEN    #最終站
       #若是最終站時則判斷是否有對應的FQC單
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM qcf_file
                          WHERE qcf02 = l_shb.shb05
                            AND (qcf09 = '1' OR qcf09 = '3')
                            AND qcfacti = 'Y'
                            AND qcf14 !='X'
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        SELECT SUM(qcf091) INTO l_qcf091 FROM qcf_file
         WHERE qcf02 = l_shb.shb05
           AND (qcf09 = '1' OR qcf09 = '3')
           AND qcfacti = 'Y'
           AND qcf14 !='X'
        SELECT SUM(shb111) INTO l_shb111 FROM shb_file
         WHERE shb05 = l_shb.shb05
           AND shb06 = l_shb.shb06
           AND shb012= l_shb.shb012
           AND shbconf = 'Y'
        LET l_diff = l_shb111 - l_qcf091
        IF l_cnt > 0 AND l_shb.shb111 > l_diff THEN
           CALL cl_err('','asf-220',1)
           LET g_success='N'
           RETURN
        END IF
        #讀取最終站良品轉出量+Bonus Qty & 完工入庫量
        SELECT (ecm311+ecm315),sfb09 INTO l_sum1,l_sum2
          FROM ecm_file,sfb_file
         WHERE ecm01 = l_shb.shb05
           AND ecm03 = l_shb.shb06
           AND ecm01 = sfb01
           AND ecm012= l_shb.shb012  #FUN-A50066
         IF cl_null(l_sum1) THEN LET l_sum1 = 0  END IF
         IF cl_null(l_sum2) THEN LET l_sum2 = 0  END IF

         #TQC-C20007 -- add l_sum2只为过账后的入库数量，应加上有效的未过账的
         SELECT SUM(sfv09) INTO l_sfv09
           FROM sfv_file,sfu_file
          WHERE sfv01=sfu01
            AND sfv11=l_shb.shb05
            AND sfupost='N'
            AND sfuconf!='X'
         IF cl_null(l_sfv09) THEN LET l_sfv09 = 0 END IF
         LET l_sum2 = l_sum2 + l_sfv09
         #TQC-C20007 -- add end

         #當站報工量+bonus Qty須<=終站總良品轉出量+Bonus Qty-已入庫量
         IF (l_shb.shb111+l_shb.shb115) > (l_sum1 - l_sum2) THEN
            CALL cl_err('','asf-681',0)
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION t700sub_confirm(p_shb01,p_date)
   DEFINE  p_shb01    LIKE shb_file.shb01
   DEFINE  p_shb      RECORD LIKE shb_file.*
   DEFINE  l_shb      RECORD LIKE shb_file.*
   DEFINE  l_ima55    LIKE ima_file.ima55
   DEFINE  l_ecm58    LIKE ecm_file.ecm58
   DEFINE  l_i        LIKE type_file.num5
   DEFINE  l_factor   LIKE ecm_file.ecm59
   DEFINE  p_date     LIKE shb_file.shb32
   DEFINE  l_yy,l_mm  LIKE type_file.num5
  
   SELECT * INTO p_shb.*  FROM shb_file WHERE shb01 = p_shb01 
   CALL t700sub_lock_cl()
   OPEN t700sub_cl USING p_shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700sub_cl:", STATUS, 1)
      CLOSE t700sub_cl
      LET g_success = 'N'
      RETURN
   END IF     
   FETCH t700sub_cl INTO l_shb.*       # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t700sub_cl
      LET g_success='N'
      RETURN
   END IF
   IF cl_null(p_date) THEN
      LET l_shb.shb32 = g_today 
      DISPLAY l_shb.shb32 TO shb32
      IF (g_action_choice CLIPPED = "confirm") OR
         (g_action_choice CLIPPED = "insert") THEN
          INPUT l_shb.shb32 WITHOUT DEFAULTS FROM shb32 
   
         AFTER FIELD shb32
            IF NOT cl_null(l_shb.shb32) THEN
               IF g_sma.sma53 IS NOT NULL AND l_shb.shb32 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD shb32
               END IF
               CALL s_yp(l_shb.shb32) RETURNING l_yy,l_mm
   
               IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                  CALL cl_err('','mfg6090',0)
                  NEXT FIELD shb32 
               END IF
            END IF 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_success = 'N'
               CLOSE t700sub_cl
               RETURN
            END IF
            IF NOT cl_null(l_shb.shb32) THEN
               IF g_sma.sma53 IS NOT NULL AND l_shb.shb32 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD shb32
               END IF
               CALL s_yp(l_shb.shb32) RETURNING l_yy,l_mm
               IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err(l_yy,'mfg6090',0)
                  NEXT FIELD shb32
               END IF
            ELSE
               CONTINUE INPUT
            END IF
            ON ACTION CONTROLG
                CALL cl_cmdask()
   
            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE INPUT
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_success = 'N'
            CLOSE t700sub_cl
            RETURN
         END IF
      END IF
   ELSE
      LET l_shb.shb32 = p_date
   END IF

   IF g_sma.sma53 IS NOT NULL AND l_shb.shb32 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'
      CLOSE t700sub_cl
      RETURN
   END IF
  
   CALL s_yp(l_shb.shb32) RETURNING l_yy,l_mm
  
   IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0)
      LET g_success = 'N'
      CLOSE t700sub_cl
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL cl_err(l_mm,'mfg6091',0)
         LET g_success = 'N'
         CLOSE t700sub_cl
         RETURN
      END IF
   END IF
   CALL t700sub_upd_ecm('a',p_shb.*)    # Update 製程追蹤檔
        RETURNING p_shb.*
   IF g_success = 'N' THEN
      CLOSE t700sub_cl
      RETURN
   END IF

  #FUN-D40092--add----begin---
   #當站入庫的庫存異動移到審核段
   CALL t700sub_add(p_shb01)
   IF g_success = 'N' THEN
      CLOSE t700sub_cl
      RETURN
   END IF
  #FUN-D40092--add----end----

   IF p_shb.shb112 > 0 THEN    #表示有報廢數量
      SELECT ima55 INTO l_ima55 FROM ima_file
       WHERE ima01= p_shb.shb10
   
      SELECT ecm58 INTO l_ecm58 FROM ecm_file
       WHERE ecm01=p_shb.shb05
         AND ecm03=p_shb.shb06
         AND ecm012=p_shb.shb012 
      CALL s_umfchk(p_shb.shb10,l_ecm58,l_ima55)   
        RETURNING l_i,l_factor
      IF l_i = '1' THEN
         LET l_factor = 1
      END IF
      UPDATE sfb_file SET sfb12 = sfb12 + (p_shb.shb112 * l_factor)
       WHERE sfb01 = p_shb.shb05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         CALL cl_err(p_shb.shb05,'asf-861',1)
         LET g_success = 'N'
         CLOSE t700sub_cl
         RETURN
      END IF 
   END IF
   
   UPDATE shb_file SET shb32 = l_shb.shb32,
                       shbconf = 'Y'
                 WHERE shb01 = p_shb01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('Update shb_file:#7',STATUS,1)
      LET g_success='N'
      CLOSE t700sub_cl
      RETURN
   END IF
   CLOSE t700sub_cl
END FUNCTION

FUNCTION t700sub_unconfirm(p_shb01)
   DEFINE  p_shb01    LIKE shb_file.shb01
   DEFINE  l_shb      RECORD LIKE shb_file.*
   DEFINE  l_ima55    LIKE ima_file.ima55
   DEFINE  l_ecm58    LIKE ecm_file.ecm58
   DEFINE  l_i        LIKE type_file.num5
   DEFINE  l_factor   LIKE ecm_file.ecm59

   SELECT * INTO l_shb.*  FROM shb_file WHERE shb01 = p_shb01
   CALL t700sub_lock_cl()
   OPEN t700sub_cl USING p_shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700sub_cl:", STATUS, 1)
      CLOSE t700sub_cl
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t700sub_cl INTO l_shb.*       # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t700sub_cl
      LET g_success='N'
      RETURN
   END IF
   IF g_success='N' THEN
      RETURN
   ELSE
      #FUN-D40092--add----begin---
      #當站入庫的庫存異動移到取消審核段
      CALL t700sub_del(p_shb01)
      IF g_success = 'N' THEN
         CLOSE t700sub_cl
         RETURN
      END IF
      #FUN-D40092--add----end----

      CALL t700sub_upd_ecm('r',l_shb.*)    # Update 製程追蹤檔
           RETURNING l_shb.*
      MESSAGE "update sfb_file"
      SELECT ima55 INTO l_ima55 FROM ima_file 
       WHERE ima01= l_shb.shb10
  
      SELECT ecm58 INTO l_ecm58 FROM ecm_file
       WHERE ecm01=l_shb.shb05
         AND ecm03=l_shb.shb06
  
      CALL s_umfchk(l_shb.shb10,l_ecm58,l_ima55)     
               RETURNING l_i,l_factor
  
      IF l_i = '1' THEN     
         LET l_factor = 1
      END IF
      UPDATE sfb_file SET sfb12 = sfb12 - (l_shb.shb112 * l_factor) 
       WHERE sfb01 = l_shb.shb05 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err(l_shb.shb05,'asf-861',1)
         LET g_success='N'
         CLOSE t700sub_cl
         RETURN
      END IF
      UPDATE shb_file SET shbconf = 'N',
                          shb32 = '' 
       WHERE shb01 = p_shb01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('Update shb_file:#9',STATUS,1)
         LET g_success='N'
         CLOSE t700sub_cl
         RETURN 
      END IF
   END IF
   CLOSE t700sub_cl
END FUNCTION

FUNCTION t700sub_add_img(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,p_date)
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE p_date       LIKE shb_file.shb03
   DEFINE l_i          LIKE type_file.num5 

   INITIALIZE l_img.* TO NULL
   LET l_img.img01=p_img01              #料號
   LET l_img.img02=p_img02              #倉庫
   LET l_img.img03=p_img03              #儲位
   LET l_img.img04=p_img04              #批號
   LET l_img.img05=p_img05              #參考號碼
   LET l_img.img06=p_img06              #序號

   IF s_joint_venture( p_img01,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
      LET g_success = 'N'
      RETURN
   END IF

   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk(l_img.img01,l_img.img02,l_img.img03) RETURNING l_i,l_img.img26
   IF l_i = 0 THEN
      LET g_success = 'N'
      RETURN
   END IF
   SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
          WHERE ima01=l_img.img01
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
      LET l_ima71=0
   END IF
   LET l_img.img09=l_img09
   LET l_img.img10=0
   LET l_img.img17=p_date
   LET l_img.img13=null            
   IF l_ima71 =0 THEN 
      LET l_img.img18=g_lastdat
   ELSE
      LET l_img.img13=p_date      
      LET l_img.img18=p_date +l_ima71
   END IF
   SELECT ime04,ime05,ime06,ime07,ime09,ime10,ime11
     INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26,l_img.img27,l_img.img28
     FROM ime_file
    WHERE ime01 = p_img02 AND ime02 = p_img03
      AND imeacti = 'Y'   #FUN-D40103  
   IF SQLCA.sqlcode THEN
      SELECT imd10,imd11,imd12,imd13,imd08,imd14,imd15  
        INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25,l_img.img26,l_img.img27,l_img.img28
        FROM imd_file WHERE imd01=l_img.img02
      IF SQLCA.SQLCODE THEN
         LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
         LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
      END IF
   END IF
   LET l_img.img20=1         LET l_img.img21=1
   LET l_img.img30=0         LET l_img.img31=0
   LET l_img.img32=0         LET l_img.img33=0
   LET l_img.img34=1         LET l_img.img37=p_date
   LET l_img.img14=p_date
   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   LET l_img.imgplant = g_plant
   LET l_img.imglegal = g_legal

   INSERT INTO img_file VALUES (l_img.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-A70095 -------------------------End------------------------------
#FUN-D40092--mark--begin---
##CHI-C60008 str add------
#FUNCTION t700sub_t701update(l_shb,p_cmd)
#DEFINE p_cmd    LIKE type_file.chr1,
#       l_shb    RECORD LIKE shb_file.*,
#       l_shd    RECORD LIKE shd_file.*,
#       l_img09  LIKE img_file.img09,
#       l_ima25  LIKE ima_file.ima25,
#       l_ima86  LIKE ima_file.ima86,
#       l_ima918 LIKE ima_file.ima918,
#       l_ima921 LIKE ima_file.ima921,
#       l_imafac LIKE img_file.img21,
#       l_imaqty LIKE type_file.num15_3,
#       l_img RECORD
#                img10   LIKE img_file.img10,
#                img16   LIKE img_file.img16,
#                img23   LIKE img_file.img23,
#                img24   LIKE img_file.img24,
#                img09   LIKE img_file.img09,
#                img21   LIKE img_file.img21
#             END RECORD,
#       u_type   LIKE type_file.num5,
#       l_sql    STRING,
#       l_qty    LIKE img_file.img10,
#       la_tlf   DYNAMIC ARRAY OF RECORD LIKE tlf_file.*,
#       l_tlf    RECORD LIKE tlf_file.*,
#       l_i      LIKE type_file.num5,
#       l_cnt    LIKE type_file.num5
#
#    DECLARE t700_upt701 CURSOR FOR
#     SELECT * FROM shd_file WHERE shd01=l_shb.shb01
#
#   FOREACH t700_upt701 INTO l_shd.*
#    #--------------------------- update img_file
#     MESSAGE "update img_file ..."
#
#     LET l_sql =
#         "SELECT img10,img16,img23,img24,img09,img21 FROM img_file",
#         " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? FOR UPDATE"
#     LET l_sql = cl_forupd_sql(l_sql)
#     DECLARE img_lock CURSOR FROM l_sql
#
#     OPEN img_lock USING l_shd.shd06,l_shd.shd03,l_shd.shd04,l_shd.shd05
#     IF STATUS THEN
#        CALL cl_err("OPEN img_lock:", STATUS, 1)
#        CLOSE img_lock
#        LET g_success='N'
#        RETURN
#     END IF
#     FETCH img_lock INTO l_img.*
#     IF STATUS THEN
#        CALL cl_err('lock img fail',STATUS,1)
#        CLOSE img_lock
#        LET g_success='N'
#        RETURN
#     END IF
#     IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
#     IF p_cmd = 'a'  THEN
#        LET l_qty= l_img.img10 + l_shd.shd07    #下線庫存數量add
#     ELSE
#        LET l_qty= l_img.img10 - l_shd.shd07
#     END IF
#
#     IF p_cmd = 'a'  THEN
#        LET u_type=+1    #入庫
#     ELSE
#        LET u_type=-1
#     END IF
#
#
#     CALL s_upimg(l_shd.shd06,l_shd.shd03,l_shd.shd04,l_shd.shd05,u_type,l_shd.shd07,g_today,
#           '','','','',l_shd.shd01,l_shd.shd02,'','','','','','','','','','','','')
#     IF g_success='N' THEN RETURN END IF
#
#    #------------------------------------------- update ima_file
#     MESSAGE "update ima_file ..."
#
#     LET l_sql=
#         "SELECT ima25,ima86,ima918,ima921 FROM ima_file WHERE ima01= ? FOR UPDATE"
#
#     LET l_sql = cl_forupd_sql(l_sql)
#     DECLARE ima_lock CURSOR FROM l_sql
#
#     OPEN ima_lock USING l_shd.shd06
#     IF STATUS THEN
#        CALL cl_err('lock ima fail',STATUS,1)
#        CLOSE ima_lock
#        LET g_success='N'
#        RETURN
#     END IF
#
#     FETCH ima_lock INTO l_ima25,l_ima86,l_ima918,l_ima921
#     IF STATUS THEN
#        CALL cl_err('lock ima fail',STATUS,1)
#        CLOSE ima_lock
#        LET g_success='N'
#        RETURN
#     END IF
#     IF l_img.img09=l_ima25 THEN
#        LET l_imafac = 1
#     ELSE
#        CALL s_umfchk(l_shd.shd06,l_img.img09,l_ima25)
#                 RETURNING l_cnt,l_imafac
#     #----單位換算率抓不到--------###
#        IF l_cnt = 1 THEN
#           CALL cl_err('','abm-731',1)
#           LET g_success ='N'
#        END IF
#     END IF
#     IF cl_null(l_imafac)  THEN LET l_imafac = 1 END IF
#     LET l_imaqty = l_shd.shd07 * l_imafac
#     CALL s_udima(l_shd.shd06,l_img.img23,l_img.img24,l_imaqty,
#                  g_today,u_type)  RETURNING l_cnt
#
#     IF g_success='N' THEN RETURN END IF
#
#
#    #-------------------- insert/delete tlf_file ---------------------
#     MESSAGE "insert tlf_file ..."
#
#     IF g_success='Y'  THEN
#        IF p_cmd = 'a'  THEN
#           MESSAGE "insert tlf_file ..."
#           INITIALIZE g_tlf.* TO NULL
#           LET g_tlf.tlf01=l_shd.shd06         #異動料件編號
#          #CHI-C30128(1) -- add start --
#           LET g_tlf.tlf012=l_shb.shb012    #製程段
#           LET g_tlf.tlf013=l_shb.shb06     #製程序
#          #CHI-C30128(1) -- add end --
#          #-----------------入庫-----------------------------------------
#           #----來源----
#           LET g_tlf.tlf02=60                  #來源狀況:工單製程當站下線
#           LET g_tlf.tlf026=l_shd.shd01        #來源單號
#           #---目的----
#           LET g_tlf.tlf03=50                  #stock:工單製程入庫
#           LET g_tlf.tlf030=g_plant            #工廠別
#           LET g_tlf.tlf031=l_shd.shd03        #倉庫
#           LET g_tlf.tlf032=l_shd.shd04        #儲位
#           LET g_tlf.tlf033=l_shd.shd05        #批號
#           LET g_tlf.tlf034=l_qty              #異動後數量
#           LET g_tlf.tlf035=l_ima25            #庫存單位(ima_file or img_file)
#           LET g_tlf.tlf036=l_shd.shd01        #雜收單號
#           LET g_tlf.tlf037=l_shd.shd02        #雜收項次
#
#           LET g_tlf.tlf04= ' '             #工作站
#          #LET g_tlf.tlf05= ' '             #作業序號   #CHI-C30128 mark
#           LET g_tlf.tlf05= l_shb.shb081    #作業序號   #CHI-C30128
#           LET g_tlf.tlf06=l_shb.shb03      #報工日期
#           LET g_tlf.tlf07=g_today          #異動資料產生日期
#           LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
#           LET g_tlf.tlf09=g_user           #產生人
#           LET g_tlf.tlf10=l_shd.shd07      #異動數量
#           LET g_tlf.tlf11=l_img.img09      #發料單位
#           LET g_tlf.tlf12=1                #發料/庫存 換算率
#           LET g_tlf.tlf13='asft700'
#           LET g_tlf.tlf14=' '              #異動原因
#           LET g_tlf.tlf17=' '              #Remark
#           LET g_tlf.tlf19=l_shb.shb07      #工作中心
#           LET g_tlf.tlf20=' '              #Project code
#           LET g_tlf.tlf61= l_ima86
#           LET g_tlf.tlf62=l_shb.shb05      #參考單號
#           LET g_tlf.tlf902 = l_shd.shd03
#           LET g_tlf.tlf903 = l_shd.shd04
#           LET g_tlf.tlf904 = l_shd.shd05
#           LET g_tlf.tlf905 = l_shd.shd01
#           LET g_tlf.tlf906 = l_shd.shd02
#           LET g_tlf.tlf907 = '1'
#           IF g_aaz.aaz90='Y' THEN
#              SELECT sfb98 INTO g_tlf.tlf930 FROM sfb_file
#                                            WHERE sfb01=l_shb.shb05
#              IF SQLCA.sqlcode THEN
#                 LET g_tlf.tlf930=NULL
#              END IF           END IF
#           CALL s_tlf(1,0)                  #insert tlf_file
#
#        ELSE
#           MESSAGE "delete tlf_file ..."
#             LET l_sql =  " SELECT  * FROM tlf_file ",
#                          " WHERE tlf01 = '",l_shd.shd06,"'",
#                          "   AND tlf902 = '",l_shd.shd03,"'",
#                          "   AND tlf903 = '",l_shd.shd04,"'",
#                          "   AND tlf904 = '",l_shd.shd05,"'",
#                          "   AND tlf905 = '",l_shd.shd01,"'",
#                          "   AND tlf906 = '",l_shd.shd02,"'",
#                          "   AND AND tlf907 = '1' "
#             DECLARE t701_u_tlf_c CURSOR FROM l_sql
#             LET l_i = 0
#             CALL la_tlf.clear()
#             FOREACH t701_u_tlf_c INTO l_tlf.*
#                LET l_i = l_i + 1
#                LET la_tlf[l_i].* = l_tlf.*
#             END FOREACH
#           DELETE FROM tlf_file
#            WHERE tlf01  = l_shd.shd06
#              AND tlf902 = l_shd.shd03
#              AND tlf903 = l_shd.shd04
#              AND tlf904 = l_shd.shd05
#              AND tlf905 = l_shd.shd01
#              AND tlf906 = l_shd.shd02
#              AND tlf907 = '1'
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('','aws-703',1)
#              LET g_success = 'N'  RETURN
#           ELSE
#              IF l_ima918 = 'Y' OR l_ima921 = 'Y' THEN
#                 DELETE FROM tlfs_file
#                  WHERE tlfs01 = l_shd.shd06
#                    AND tlfs10 = l_shd.shd01
#                    AND tlfs11 = l_shd.shd02
#                    AND tlfs111 = l_shb.shb03
#                  IF SQLCA.sqlcode THEN
#                     LET g_success = 'N'  RETURN
#                  END IF
#              END IF
#           END IF
#                  FOR l_i = 1 TO la_tlf.getlength()
#                     LET g_tlf.* = la_tlf[l_i].*
#                     IF NOT s_untlf1('') THEN
#                        LET g_success='N' RETURN
#                     END IF
#                  END FOR
#        END IF
#     END IF
#   END FOREACH
#END FUNCTION
##CHI-C60008 end add------ 
#FUN-D40092--mark--end-----
#FUN-B50046

#FUN-D40092--add---begin---
#原當站入庫的對庫存tlf,img,imgg的異動移到審核和取消審核段
#邏輯由asft701搬移過來
FUNCTION t700sub_add(p_shb01)   #審核庫存入庫
DEFINE p_shb01   LIKE shb_file.shb01
DEFINE l_cnt     LIKE type_file.num10

  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM shd_file WHERE shd01= p_shb01
  IF l_cnt = 0 THEN 
  	 RETURN  
  END IF
  	
  DECLARE t700sub_add CURSOR FOR
     SELECT * FROM shd_file WHERE shd01= p_shb01
  FOREACH t700sub_add INTO g_shd.*
     IF cl_null(g_shd.shd06) THEN 
     	  LET g_success='N' 
     	  EXIT FOREACH  
     END IF
     
     SELECT img09,img21 INTO g_img09,g_img21 FROM img_file
      WHERE img01=g_shd.shd06 AND img02=g_shd.shd03
        AND img03=g_shd.shd04 AND img04=g_shd.shd05
        
     SELECT ima918,ima921 INTO g_ima918,g_ima921 FROM ima_file 
        WHERE ima01 = g_shd.shd06 AND imaacti = 'Y'
        
     IF g_sma.sma115 = 'Y' THEN
        IF g_shd.shd12 != 0 OR g_shd.shd15 != 0 THEN 
           CALL t700sub_update_du('1')   #審核庫存入庫
           IF g_success='N' THEN 
           	  EXIT FOREACH 
           END IF
        END IF 
     END IF 
     CALL t700sub_update('1',g_shd.shd03,g_shd.shd04,g_shd.shd05,   #'1' 審核庫存入庫
                         g_shd.shd07,g_img09,1)      
     
     IF g_success='N' THEN 
     	  EXIT FOREACH  
     END IF
  END FOREACH
  IF g_success='N' THEN 
     RETURN
   END IF
END FUNCTION

FUNCTION t700sub_del(p_shb01)     #取消審核刪除庫存
DEFINE p_shb01   LIKE shb_file.shb01
DEFINE l_cnt     LIKE type_file.num10

  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM shd_file WHERE shd01= p_shb01
  IF l_cnt = 0 THEN 
  	 RETURN  
  END IF
  	
  DECLARE t700sub_del CURSOR FOR
     SELECT * FROM shd_file WHERE shd01= p_shb01
  FOREACH t700sub_del INTO g_shd.*
     IF cl_null(g_shd.shd06) THEN 
     	  LET g_success='N' 
     	  EXIT FOREACH  
     END IF
     
     SELECT img09,img21 INTO g_img09,g_img21 FROM img_file
      WHERE img01=g_shd.shd06 AND img02=g_shd.shd03
        AND img03=g_shd.shd04 AND img04=g_shd.shd05
     
     SELECT ima918,ima921 INTO g_ima918,g_ima921 FROM ima_file 
        WHERE ima01 = g_shd.shd06 AND imaacti = 'Y'
     IF g_sma.sma115 = 'Y' THEN
        IF g_shd.shd12 != 0 OR g_shd.shd15 != 0 THEN 
           CALL t700sub_update_du('2')   #取消審核刪除庫存
           IF g_success='N' THEN 
           	  EXIT FOREACH 
           END IF
        END IF 
     END IF 
     CALL t700sub_update('2',g_shd.shd03,g_shd.shd04,g_shd.shd05,  #'2' 取消審核刪除庫存
                         g_shd.shd07,g_img09,1)      
     IF g_success='N' THEN 
     	  EXIT FOREACH  
     END IF
  END FOREACH
  IF g_success='N' THEN 
  	 RETURN 
  END IF
END FUNCTION

FUNCTION t700sub_update(p_flag,p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
  DEFINE p_flag   LIKE type_file.chr1          
  DEFINE p_ware   LIKE imd_file.imd01,         #倉庫
         p_loca   LIKE imd_file.imd01,         #儲位 
         p_lot    LIKE type_file.chr20,        #批號   
         p_qty    LIKE img_file.img10,         #數量
         p_factor LIKE ima_file.ima31_fac,     #轉換率
         u_type   LIKE type_file.num5,         # +1:雜收 -1:雜發  0:報廢
         l_qty    LIKE img_file.img10,         #異動後數量
         l_a      LIKE type_file.chr1,         
         l_ima25  LIKE ima_file.ima25,
         l_imaqty LIKE type_file.num15_3,      
         l_imafac LIKE img_file.img21, 
         l_img RECORD
               img10   LIKE img_file.img10,
               img16   LIKE img_file.img16,
               img23   LIKE img_file.img23,
               img24   LIKE img_file.img24,
               img09   LIKE img_file.img09,
               img21   LIKE img_file.img21
               END RECORD,
         l_cnt  LIKE type_file.num5          
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   
  DEFINE l_sql   STRING                                   
  DEFINE l_i     LIKE type_file.num5                    
  DEFINE p_uom   LIKE ima_file.ima25   
  DEFINE l_shb   RECORD LIKE shb_file.*   
  
    SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = g_shd.shd01
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) 
       LET g_success = 'N' 
       RETURN
    END IF
#----------------------------------- update img_file
   MESSAGE "update img_file ..."

   LET l_sql = 
       "SELECT img10,img16,img23,img24,img09,img21 FROM img_file",
       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? FOR UPDATE"
   LET l_sql = cl_forupd_sql(l_sql)
   DECLARE img_lock CURSOR FROM l_sql

   OPEN img_lock USING g_shd.shd06,p_ware,p_loca,p_lot
   IF STATUS THEN
      CALL cl_err("OPEN img_lock:", STATUS, 1)
      CLOSE img_lock
      LET g_success='N' 
      RETURN
   END IF
   FETCH img_lock INTO l_img.*
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) 
      CLOSE img_lock
      LET g_success='N' 
      RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   IF p_flag = '1'  THEN 
      LET l_qty= l_img.img10 + p_qty    #下線庫存數量add 
   ELSE  
      LET l_qty= l_img.img10 - p_qty   
   END IF 

   IF p_flag = '1'  THEN 
      LET u_type=+1    #審核 入庫
   ELSE 
      LET u_type=-1    #取消審核
   END IF

   CALL s_upimg(g_shd.shd06,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today, 
         '','','','',g_shd.shd01,g_shd.shd02,'','','','','','','','','','','','')  
   IF g_success='N' THEN 
   	  RETURN 
   END IF

------------------------------------------- update ima_file
   MESSAGE "update ima_file ..."
  
   LET l_sql=
       "SELECT ima25,ima86 FROM ima_file WHERE ima01= ? FOR UPDATE"

   LET l_sql = cl_forupd_sql(l_sql)
   DECLARE ima_lock CURSOR FROM l_sql

   OPEN ima_lock USING g_shd.shd06
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) 
      CLOSE ima_lock
      LET g_success='N' 
      RETURN
   END IF 

   FETCH ima_lock INTO l_ima25,g_ima86
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) 
      CLOSE ima_lock
      LET g_success='N' 
      RETURN
   END IF

   IF p_uom=l_ima25 THEN
      LET l_imafac = 1
   ELSE
      CALL s_umfchk(g_shd.shd06,p_uom,l_ima25)
               RETURNING l_cnt,l_imafac 
   #----單位換算率抓不到--------###  
      IF l_cnt = 1 THEN 
         CALL cl_err('','abm-731',1)
         LET g_success ='N' 
      END IF 
   END IF
   IF cl_null(l_imafac)  THEN 
   	  LET l_imafac = 1 
   END IF
   LET l_imaqty = p_qty * l_imafac
   CALL s_udima(g_shd.shd06,l_img.img23,l_img.img24,l_imaqty,
                g_today,u_type)  RETURNING l_cnt

   IF g_success='N' THEN 
   	  RETURN 
   END IF

   #shd 
-------------------- insert/delete tlf_file ---------------------
   MESSAGE "insert tlf_file ..."

   IF g_success='Y'  THEN 
      IF p_flag = '1'  THEN    #審核 入庫
         MESSAGE "insert tlf_file ..."
         CALL t700sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                        u_type)
      ELSE 
         MESSAGE "delete tlf_file ..."    #取消審核
           LET l_sql =  " SELECT  * FROM tlf_file ", 
                        " WHERE tlf01 = '",g_shd.shd06,"'", 
                        "   AND tlf902 = '",g_shd.shd03,"'",  
                        "   AND tlf903 = '",g_shd.shd04,"'", 
                        "   AND tlf904 = '",g_shd.shd05,"'",
                        "   AND tlf905 = '",g_shd.shd01,"'",
                        "   AND tlf906 = '",g_shd.shd02,"'",
                        "   AND AND tlf907 = '1' "     
           DECLARE t701_u_tlf_c CURSOR FROM l_sql
           LET l_i = 0 
           CALL la_tlf.clear()
           FOREACH t701_u_tlf_c INTO g_tlf.* 
              LET l_i = l_i + 1
              LET la_tlf[l_i].* = g_tlf.*
           END FOREACH     

         DELETE FROM tlf_file
          WHERE tlf01  = g_shd.shd06
            AND tlf902 = g_shd.shd03
            AND tlf903 = g_shd.shd04
            AND tlf904 = g_shd.shd05
            AND tlf905 = g_shd.shd01
            AND tlf906 = g_shd.shd02
            AND tlf907 = '1'
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'  
            RETURN 
         ELSE
            IF g_ima918 = 'Y' OR g_ima921 = 'Y' THEN
               DELETE FROM tlfs_file
                WHERE tlfs01 = g_shd.shd06
                  AND tlfs10 = g_shd.shd01
                  AND tlfs11 = g_shd.shd02
                  AND tlfs111 = l_shb.shb03 

                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'  
                   RETURN 
                END IF  
            END IF 
         END IF
                FOR l_i = 1 TO la_tlf.getlength()
                   LET g_tlf.* = la_tlf[l_i].*
                   IF NOT s_untlf1('') THEN 
                      LET g_success='N' 
                      RETURN
                   END IF 
                END FOR       
      END IF
   END IF
   MESSAGE "seq#",g_shd.shd03 USING'<<<',' post ok!'

END FUNCTION
 
FUNCTION t700sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                  u_type)
   DEFINE
      p_ware  LIKE imd_file.imd01,       #倉庫
      p_loca  LIKE imd_file.imd01,       #儲位 
      p_lot   LIKE type_file.chr20,      #批號   
      p_qty   LIKE img_file.img10,       #數量
      p_factor LIKE ima_file.ima31_fac,  #轉換率
      p_unit  LIKE ima_file.ima25,       #單位
      p_img10    LIKE img_file.img10,    #異動後數量
      u_type     LIKE type_file.num5,    # +1:雜收 -1:雜發  0:報廢
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    
      g_cnt      LIKE type_file.num5     
  DEFINE p_uom   LIKE ima_file.ima25 
  DEFINE l_shb   RECORD LIKE shb_file.*   
  
      SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = g_shd.shd01
      
      INITIALIZE g_tlf.* TO NULL
      LET g_tlf.tlf01=g_shd.shd06         #異動料件編號
      LET g_tlf.tlf012=l_shb.shb012    #製程段
      LET g_tlf.tlf013=l_shb.shb06     #製程序
#-----------------入庫-----------------------------------------
      #----來源----
      LET g_tlf.tlf02=60                  #來源狀況:工單製程當站下線
      LET g_tlf.tlf026=g_shd.shd01        #來源單號
      #---目的----
      LET g_tlf.tlf03=50                  #stock:工單製程入庫
      LET g_tlf.tlf030=g_plant            #工廠別
      LET g_tlf.tlf031=p_ware             #倉庫
      LET g_tlf.tlf032=p_loca             #儲位
      LET g_tlf.tlf033=p_lot              #批號
      LET g_tlf.tlf034=p_img10            #異動後數量
      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_shd.shd01        #雜收單號
      LET g_tlf.tlf037=g_shd.shd02        #雜收項次 
 
      LET g_tlf.tlf04= ' '             #工作站
     #LET g_tlf.tlf05= ' '             #作業序號
      LET g_tlf.tlf05= l_shb.shb081    #作業序號
      LET g_tlf.tlf06=l_shb.shb03      #報工日期
      LET g_tlf.tlf07=g_today          #異動資料產生日期  
      LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
      LET g_tlf.tlf09=g_user           #產生人
      LET g_tlf.tlf10=p_qty            #異動數量
      LET g_tlf.tlf11=p_uom            #發料單位
      LET g_tlf.tlf12=p_factor         #發料/庫存 換算率
      LET g_tlf.tlf13='asft700'
      LET g_tlf.tlf14=' '              #異動原因
      LET g_tlf.tlf17=' '              #Remark
      LET g_tlf.tlf19=l_shb.shb07      #工作中心 
      LET g_tlf.tlf20=' '              #Project code
      LET g_tlf.tlf61= g_ima86
      LET g_tlf.tlf62=l_shb.shb05      #參考單號
      LET g_tlf.tlf902 = g_shd.shd03 
      LET g_tlf.tlf903 = g_shd.shd04 
      LET g_tlf.tlf904 = g_shd.shd05 
      LET g_tlf.tlf905 = g_shd.shd01 
      LET g_tlf.tlf906 = g_shd.shd02 
      LET g_tlf.tlf907 = '1'
      IF g_aaz.aaz90='Y' THEN
         SELECT sfb98 INTO g_tlf.tlf930 FROM sfb_file
                                       WHERE sfb01=l_shb.shb05
         IF SQLCA.sqlcode THEN
            LET g_tlf.tlf930=NULL
         END IF
      END IF
      CALL s_tlf(1,0)                  #insert tlf_file 
END FUNCTION
	
FUNCTION t700sub_update_du(p_flag)
DEFINE u_type    LIKE type_file.num5,    
       p_flag    LIKE type_file.chr1,         
       l_ima906  LIKE ima_file.ima906,
       l_ima907  LIKE ima_file.ima907
       
   IF g_sma.sma115 = 'N' THEN 
   	  RETURN 
   END IF
   
    IF p_flag = '1'  THEN 
       LET u_type=+1    #入庫
    ELSE 
       LET u_type=-1    
    END IF
 
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01 = g_shd.shd06
   IF SQLCA.sqlcode THEN
      LET g_success='N' 
      RETURN
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(g_shd.shd13) THEN 
         CALL t700sub_upd_imgg('1',g_shd.shd06,g_shd.shd03,g_shd.shd04,
                         g_shd.shd05,g_shd.shd13,g_shd.shd14,g_shd.shd15,u_type,'2')
         IF g_success='N' THEN 
         	  RETURN 
         END IF
         IF p_flag = '1' THEN
            IF NOT cl_null(g_shd.shd15) AND g_shd.shd15 <> 0 THEN  
               CALL t700sub_tlff(g_shd.shd03,g_shd.shd04,g_shd.shd05,g_img09,
                              g_shd.shd15,0,g_shd.shd13,g_shd.shd14,u_type,'2')
               IF g_success='N' THEN 
               	  RETURN 
               END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(g_shd.shd10) THEN 
         CALL t700sub_upd_imgg('1',g_shd.shd06,g_shd.shd03,g_shd.shd04,
                            g_shd.shd05,g_shd.shd10,g_shd.shd11,g_shd.shd12,u_type,'1')
         IF g_success='N' THEN 
         	  RETURN 
         END IF
         IF p_flag = '1' THEN
            IF NOT cl_null(g_shd.shd12) AND g_shd.shd12 <> 0 THEN  
               CALL t700sub_tlff(g_shd.shd03,g_shd.shd04,g_shd.shd05,g_img09,
                           g_shd.shd12,0,g_shd.shd10,g_shd.shd11,u_type,'1')
               IF g_success='N' THEN 
               	  RETURN 
               END IF
            END IF
         END IF
      END IF
      IF p_flag = '2' THEN
         CALL t700sub_tlff_w()
         IF g_success='N' THEN 
         	  RETURN 
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(g_shd.shd13) THEN 
         CALL t700sub_upd_imgg('2',g_shd.shd06,g_shd.shd03,g_shd.shd04,
                            g_shd.shd05,g_shd.shd13,g_shd.shd14,g_shd.shd15,u_type,'2')
         IF g_success = 'N' THEN 
         	  RETURN 
         END IF
         IF p_flag = '1' THEN
            IF NOT cl_null(g_shd.shd15) AND g_shd.shd15 <> 0 THEN  
               CALL t700sub_tlff(g_shd.shd03,g_shd.shd04,g_shd.shd05,g_img09,
                              g_shd.shd15,0,g_shd.shd13,g_shd.shd14,u_type,'2')
               IF g_success='N' THEN 
               	  RETURN 
               END IF
            END IF
         END IF
      END IF
      IF p_flag = '2' THEN
         CALL t700sub_tlff_w()
         IF g_success='N' THEN 
         	  RETURN 
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t700sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,                                        
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,         
         p_type     LIKE type_file.num10,
         l_cnt      LIKE type_file.num10,
         l_sql      STRING         
 
    LET l_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET l_sql = cl_forupd_sql(l_sql)
    DECLARE imgg_lock CURSOR FROM l_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N' 
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1) 
       LET g_success='N' 
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906 
      FROM ima_file WHERE ima01=p_imgg01                
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN                                    
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)                                
       LET g_success = 'N' RETURN                                               
    END IF                                                                      
                                                                                
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)                                    
          RETURNING l_cnt,l_imgg21                                              
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN                                                           
       CALL cl_err('','mfg3075',0)                                              
       LET g_success = 'N' RETURN                                               
    END IF  
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_today,  
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN 
    	 RETURN 
    END IF
    
END FUNCTION
 
FUNCTION t700sub_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag)
DEFINE
   l_avl_stk  LIKE type_file.num15_3,
   l_ima25    LIKE ima_file.ima25,
   l_ima55    LIKE ima_file.ima55,
   l_ima86    LIKE ima_file.ima86,
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位 
   p_lot      LIKE img_file.img04,     	 ##批號   
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   l_imgg10   LIKE imgg_file.imgg10,     
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   u_type     LIKE type_file.num5,          #No.FUN-680121 INTEGER##+1:雜收 -1:雜發  0:報廢
   p_flag     LIKE type_file.chr1,         
   g_cnt      LIKE type_file.num5,
   l_shb      RECORD LIKE shb_file.*
 
   CALL s_getima(g_shd.shd06) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86
   
   IF cl_null(p_ware) THEN 
   	  LET p_ware=' ' 
   END IF
   IF cl_null(p_loca) THEN 
   	  LET p_loca=' ' 
   END IF
   IF cl_null(p_lot)  
   	  THEN LET p_lot=' '  
   END IF
   IF cl_null(p_qty)  THEN 
   	  LET p_qty=0    
   END IF
   
   IF p_uom IS NULL THEN
      CALL cl_err('p_uom null:','asf-031',1) 
      LET g_success = 'N' 
      RETURN
   END IF
   SELECT imgg10 INTO l_imgg10 FROM imgg_file                                  
     WHERE imgg01=g_shd.shd06 AND imgg02=p_ware                                 
       AND imgg03=p_loca      AND imgg04=p_lot                                  
       AND imgg09=p_uom                                                         
   IF cl_null(l_imgg10) THEN 
   	 LET l_imgg10 = 0 
   END IF  
   SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = g_shd.shd01
   INITIALIZE g_tlff.* TO NULL
    
   LET g_tlff.tlff01=g_shd.shd06         #異動料件編號
#-----------------入庫-----------------------------------------
   #----來源----
   LET g_tlff.tlff02=60                  #來源狀況:工單製程當站下線
   LET g_tlff.tlff026=g_shd.shd01        #來源單號
   #---目的----
   LET g_tlff.tlff03=50                  #stock:工單製程入庫
   LET g_tlff.tlff030=g_plant            #工廠別
   LET g_tlff.tlff031=p_ware             #倉庫
   LET g_tlff.tlff032=p_loca             #儲位
   LET g_tlff.tlff033=p_lot              #批號
   LET g_tlff.tlff034=l_imgg10           #異動後數量
   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=g_shd.shd01        #雜收單號
   LET g_tlff.tlff037=g_shd.shd02        #雜收項次 
 
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_shb.shb03      #報工日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期  
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_uom            #發料單位
   LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
   LET g_tlff.tlff13='asft700'
   LET g_tlff.tlff14=' '              #異動原因
   LET g_tlff.tlff17=' '              #Remark
   LET g_tlff.tlff19=l_shb.shb07      #工作中心 
   LET g_tlff.tlff20=' '              #Project code
   LET g_tlff.tlff61= l_ima86
   LET g_tlff.tlff62=l_shb.shb05      #參考單號
   LET g_tlff.tlff902 = g_shd.shd03 
   LET g_tlff.tlff903 = g_shd.shd04 
   LET g_tlff.tlff904 = g_shd.shd05 
   LET g_tlff.tlff905 = g_shd.shd01 
   LET g_tlff.tlff906 = g_shd.shd02 
   LET g_tlff.tlff907 = '1'
   IF g_aaz.aaz90='Y' THEN
      SELECT sfb98 INTO g_tlff.tlff930 FROM sfb_file
                                      WHERE sfb01=l_shb.shb05
      IF SQLCA.sqlcode THEN
         LET g_tlff.tlff930=NULL
      END IF
   END IF
   IF cl_null(g_shd.shd15) OR g_shd.shd15=0 THEN 
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,g_shd.shd13)
   END IF
END FUNCTION
 
FUNCTION t700sub_tlff_w()                                                            
                                                                                
    MESSAGE "d_tlff!"                                                           
                                                                                
    DELETE FROM tlff_file                                                       
     WHERE tlff01 =g_shd.shd06                                                  
       AND tlff902 = g_shd.shd03
       AND tlff903 = g_shd.shd04
       AND tlff904 = g_shd.shd05
       AND tlff905 = g_shd.shd01
       AND tlff906 = g_shd.shd02
       AND tlff907 = '1'
                                                                                
    IF STATUS THEN                                                              
       CALL cl_err('del tlff:',STATUS,1) 
       LET g_success='N' 
       RETURN               
    END IF                                                                      
END FUNCTION     	
#FUN-D40092--add---end-----

