# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: asfp302.4gl
# Descriptions...: 整批工單產生作業
# Date & Author..: 97/06/28 BY Roger
# Modify.........: No:8049 03/09/03 Carol 在 p302_firm1()中
#                                         檢核 g_sfb.sfb24 = 'N' 未產生製程追蹤則不可確認
#                                         時應要再加上一條件check sfb93 = 'Y'(需走製程)時,才要check
# Modify.........: No.9027 04/01/08 Kammy sr.ima55變數給值應抓取ima55之資料，
#                                         但目前抓取的欄位為ima25
# Modify.........: MOD-470043 04/07/16 Carol 單身加 show 生產料號的 品名&規格
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大                                       
# Modify.........: No.MOD-490471 04/10/13 by Carol sfb01,sfb92 INPUT 分別open window :q_ksf,q_ksg
# Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.MOD-4C0090 05/01/18 By Mandy AFTER ROW 段語法上不可再有陣列的判斷,及NEXT FIELD
# Modify.........: No.FUN-510029 05/02/23 By Mandy 報表轉XML
# Modify.........: No.MOD-530397 05/04/04 By Carol 1.輸入完通知單號與項次後，預計完工日應一併顯示
#                                                  2.輸入時單頭之「批數」應預設為 0 
#                                                  3.選取一條龍完工日期應參考生產前置時間進行計算作相對之調整
#                                                  4.若單頭沒有選取產生PBI，則產生工單單頭之母工單號欄應為空白
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-5A0223 05/12/12 By Pengu 1.單身"工單編號"若空白,按確認時show err mess
#                                                  2.開工日>完工日時,open window 顯示錯誤訊息     
# Modify.........: No.FUN-5C0063 05/12/27 By Sarah 單頭"部門廠商"(sfb82)增加開窗功能(q_gem),
#                                                  增加ACTION"查詢委外廠商"(q_pmc)
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時, 特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.MOD-610110 06/02/08 By Pengu 1.當一個料件是X件時，它下面的元件會重復產生
                                   #               2.這個虛擬件本身也會列出在單身，開工單
# Modify.........: No.MOD-640300 06/04/10 By kim 用製造通知單轉工單,產生的工單都己確認及狀態碼己為3.料表己料件,建議應為未確認狀況..
# Modify.........: No.FUN-650193 06/06/01 By kim 2.0功能改善-主特性代碼
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-660119 06/08/30 By Sarah 當選擇之"通知單號"有多筆單身時,在產生完第一筆之後,自動帶出後面的項次以增加操作速度
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-750225 07/05/29 By arman   運行程序，確定后提示審核，后打印報表，報表只有一筆資料，打印出接下頁字樣且位置有誤
# Modify.........: No.TQC-760024 07/06/06 By rainy   若單身有單號是空白，則不能執行 
# Modify.........: No.TQC-790077 07/09/19 By Carrier 生成FBI時,default最近更改日期
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-850144 08/05/15 By claire 輸入工單後,判斷項次不為空時即帶出相關資訊
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-880009 08/08/19 By sherry 若該工單 sfa11都是  'E' ,則更新 sfb39='2'
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990267 09/10/13 By Pengu 母工單欄位不應該放製通單編號
# Modify.........: No:TQC-9A0130 09/10/26 By liuxqa 修改ROWID.
# Modify.........: No:MOD-9B0070 09/11/11 By sabrina "S"件不會展子工單
# Modify.........: No:TQC-9B0136 09/11/18 By Carrier 产生sfb_file时,给sfbmksg赋值
# Modify.........: No:MOD-9C0041 09/12/25 By Pengu 1.兩user同時執行asfp302時會產生lock情況
#                                                  2.批量欄位default通知單數量
# Modify.........: No:MOD-9C0079 09/12/25 By Pengu 若M件沒有BOM時不應產生在單身
# Modify.........: No:TQC-9C0182 09/12/29 By lilingyu "批量"欄位未控管負數 
# Modify.........: No:FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:MOD-9C0449 09/01/13 By Pengu 控管計畫數量不可為0
# Modify.........: No:TQC-A30046 10/03/10 By Carrier 1.sfb44赋值 2.transaction标准化
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A50073 10/05/19 By destiny input 时要controlg
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No:TQC-A70044 10/07/09 By Carrier sfc_sw不勾选时,sfb85 = NULL
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:TQC-A90021 10/09/08 By destiny 上一次的报错信息晴空      
# Modify.........: No.FUN-A90035 10/09/20 By vealxu 新增sfd_file時,確認碼給 'N'
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0034 10/11/08 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 新增new_part的控管 
# Modify.........: No:CHI-9C0001 10/11/25 By Summer 預計開工日應該要用預計開工日推算
# Modify.........: No:TQC-AC0238 10/12/16 By zhangweib 工單單別排除smy73='Y'的單別
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50212 11/05/25 By vampire 將 mm_qty、mm_qty1 DEFINE sfb_file.sfb08
# Modify.........: No:CHI-B50051 11/06/16 By Vampire 將 asf-740 移除
# Modify.........: No:TQC-B60297 11/06/24 By jan 推算預計開工日時公式錯誤，變動前製時間未考慮"變動前製時間批量"
# Modify.........: No:TQC-B80103 11/08/16 By houlia 調整批量欄位跟asfi301的生產數量一致
# Modify.........: No:FUN-B60116 11/09/16 By Abby asfi500新增EF整合後，相關聯程式調整
# Modify.........: No:TQC-B90123 11/09/19 By houlia 拋轉時判斷發料最少數量 
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: No:TQC-BA0134 11/10/25 By houlia 審核時判斷是否存在備料檔
# Modify.........: No:TQC-BB0015 11/11/02 By zhangll 修正TQC-BA0134,FUN-B60116寫法
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.MOD-C30277 12/03/10 By fengrui 修改日期控管
# Modify.........: No.TQC-C40168 12/04/19 By fengrui 添加對BOM已確認、已發放的檢查
# Modify.........: No.FUN-C30114 12/08/07 By bart sfb89值
# Modify.........: No:CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No:TQC-C80130 12/09/03 By chenjing 修改開工日和完工日中bug問題
# Modify.........: No:MOD-CA0114 12/10/29 By Elise 修正TQC-C40168於bom_chk funtion的修改
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No:MOD-D20044 13/02/06 By suncx 計算單身生產數量時需要考慮生產單位的小數位數
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti
# Modify.........: No:MOD-D70022 13/07/19 By suncx 生成子訂單，需要給母工單欄位賦值
# Modify.........: No:MOD-D80129 13/08/15 By suncx sfb98成本中心帶smy60值
# Modify.........: No:MOD-D80153 13/08/26 By suncx 第一次錄入時，製造通知單單身未必存在項次為1的資料，不應默認賦值為1

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   k_sfb       RECORD LIKE sfb_file.*,
         v_sfb       RECORD LIKE sfb_file.*,
        #-----------No:CHI-9C0001 add
         g_sfb01_t   LIKE sfb_file.sfb01,
         g_sfb92_t   LIKE sfb_file.sfb01,
         g_sfb13_t   LIKE sfb_file.sfb01,
         g_sfb15_t   LIKE sfb_file.sfb01,
        #-----------No:CHI-9C0001 end
         sfc_sw      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         lot         LIKE type_file.num10,         #No.FUN-680121 INTEGER
#        lota        LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
         lota        LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044 
         l_mod       LIKE type_file.num10,         #No.FUN-680121 INTEGER
         g_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
         g_t1        LIKE oay_file.oayslip,        #No.FUN-550067         #No.FUN-680121 VARCHAR(05)
         g_sw        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         g_rec_b     LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
         g_first     LIKE type_file.chr1,   #No.FUN-680121 VARCHAR(1) #FUN-660119 add
         old_sfb01   LIKE sfb_file.sfb01,   #FUN-660119 add
         old_sfb92   LIKE sfb_file.sfb92,   #FUN-660119 add
         mm_sfb08    LIKE sfb_file.sfb08,
         g_ecu01     LIKE ecu_file.ecu01,
         l_smy57     LIKE smy_file.smy57,
         l_smyapr    LIKE smy_file.smyapr,                #No.TQC-9B0136
         l_slip      LIKE oay_file.oayslip,               #No.FUN-680121 VARCHAR(5)#No.FUN-550067 
         new DYNAMIC ARRAY OF RECORD
                new_part        LIKE sfb_file.sfb05,      #No.MOD-490217
                ima02           LIKE ima_file.ima02,      #MOD-470043
                ima021          LIKE ima_file.ima021,     #MOD-470043
                sfb95           LIKE sfb_file.sfb95,      #FUN-650193
#               new_qty         LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
                new_qty         LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
                b_date          LIKE type_file.dat,           #No.FUN-680121 DATE
                e_date          LIKE type_file.dat,           #No.FUN-680121 DATE
                new_no          LIKE oea_file.oea01,          #No.FUN-680121 #No.FUN-550067  
                wo_type         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                ven_no          LIKE sfb_file.sfb82,          #No.FUN-680121 VARCHAR(10)
                rid             INTEGER                       #MOD-D70022 add
         END RECORD
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_sql           STRING                     #No.TQC-AC0238
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   CALL p302_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p302_tm()
   DEFINE   p_row,p_col,i    LIKE type_file.num5            #No.FUN-680121 SMALLINT
#   DEFINE   mm_qty,mm_qty1   LIKE occ_file.occ15            #No.FUN-680121 DEC(15,0)     #MOD-B50212 mark
   DEFINE   mm_qty,mm_qty1   LIKE sfb_file.sfb08            #MOD-B50212 add
   DEFINE   l_cnt            LIKE type_file.num5            #No.FUN-680121 SMALLINT
   DEFINE   l_ima02          LIKE ima_file.ima02            #MOD-470043
   DEFINE   l_ima021         LIKE ima_file.ima021           #MOD-470043
   DEFINE   l_flag           LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)
   DEFINE   l_ima910         LIKE ima_file.ima910           #FUN-550112
   DEFINE   p_flag_sfb82     LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1) #FUN-5C0063
   DEFINE   l_qty1           LIKE sfb_file.sfb08            #No.TQC-B80103 add
   DEFINE   l_qty2           LIKE ima_file.ima56            #No.TQC-B80103 add
   DEFINE   l_ima56          LIKE ima_file.ima56            #No.TQC-B80103 add
   DEFINE   l_ima561         LIKE ima_file.ima561           #No.TQC-B80103 add
   DEFINE   li_result        LIKE type_file.num5            #TQC-C80130 add
   DEFINE   l_ima55          LIKE ima_file.ima55            #MOD-D20044 add
   
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 2 
   LET p_col = 10
 
   OPEN WINDOW p302_w AT p_row,p_col WITH FORM "asf/42f/asfp302" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("sfb95",g_sma.sma118='Y')
 
   CALL cl_opmsg('z')
 
   LET g_first = 'Y'   #FUN-660119 add
   WHILE TRUE
      CLEAR FORM
      INITIALIZE k_sfb.* TO NULL
      LET mm_qty=0   
      LET mm_qty1=0   
      LET sfc_sw='Y'
      LET lot=0       #MOD-530397-2 ->1改為0
      LET g_sw='N' 
      LET lota=0   
      LET k_sfb.sfb81=TODAY
      LET k_sfb.sfb42=99 
      IF g_first = 'Y' THEN    
        #LET k_sfb.sfb92=1   #MOD-D80153 mark  
      ELSE
         #第一次產生完之後,抓同一張製造通知單,是否有其他項次,有的話繼續帶出
         SELECT MIN(ksg02) INTO k_sfb.sfb92 FROM ksg_file
          WHERE ksg01=old_sfb01 
            AND ksg02>old_sfb92
            AND ksg09!='Y'         #尚未結案
         IF NOT cl_null(k_sfb.sfb92) THEN
            LET k_sfb.sfb01 = old_sfb01
         ELSE
            LET k_sfb.sfb92=1
         END IF
      END IF
 
     #------------No:CHI-9C0001 add
      LET g_sfb01_t = NULL
      LET g_sfb92_t = NULL
      LET g_sfb13_t = NULL
      LET g_sfb15_t = NULL
     #------------No:CHI-9C0001 end

      LET p_flag_sfb82 = 'N'   #FUN-5C0063
 
      DISPLAY BY NAME k_sfb.sfb01,k_sfb.sfb92,k_sfb.sfb81,
                      k_sfb.sfb42,sfc_sw,lot,lota,g_sw 
      CALL cl_set_head_visible("grid01,grid02,grid03","YES")  #NO.FUN-6B0031
      INPUT BY NAME k_sfb.sfb01,k_sfb.sfb92,k_sfb.sfb81,
                    k_sfb.sfb05,k_sfb.sfb071,k_sfb.sfb08,k_sfb.sfb13,
                    k_sfb.sfb15,k_sfb.sfb42,sfc_sw,lot,lota,g_sw,
                    k_sfb.sfb82
                 WITHOUT DEFAULTS 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         AFTER FIELD sfb01        #製造通知單
            IF not cl_null(k_sfb.sfb01) THEN 
               SELECT count(*) INTO l_cnt FROM ksf_file 
                WHERE ksf01 = k_sfb.sfb01 
                  AND ksfconf = 'Y'
               IF cl_null(l_cnt) THEN
                  LET l_cnt = 0
               END IF
               IF l_cnt <=0 THEN 
                  CALL cl_err(k_sfb.sfb01,'asf-737',0)
                  NEXT FIELD sfb01
               END IF
               IF NOT cl_null(k_sfb.sfb92) THEN
                 #---------------No:CHI-9C0001 add
                  IF (k_sfb.sfb92 != g_sfb92_t OR cl_null(g_sfb92_t)) OR
                     ( k_sfb.sfb01 != g_sfb01_t OR cl_null(g_sfb01_t)) THEN   
                 #---------------No:CHI-9C0001 end
                  SELECT ksg03,ksg05,ksg07,ksg04
                    INTO k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb071,k_sfb.sfb15
                    FROM ksg_file
                   WHERE ksg01=k_sfb.sfb01 AND ksg02=k_sfb.sfb92 AND ksg09='N'
 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","ksg_file",k_sfb.sfb01,k_sfb.sfb92,"asf-737","","",0)    #No.FUN-660128
                     NEXT FIELD sfb01
                  END IF
                  #-------------------- 99/07/30 以未開單量為預計生產量
                  SELECT SUM(sfb08) INTO mm_sfb08 FROM sfb_file
                   WHERE sfb91=k_sfb.sfb01 AND sfb92=k_sfb.sfb92
                     AND sfb05=k_sfb.sfb05 AND sfb87!='X'
                  IF STATUS OR mm_sfb08 IS NULL THEN
                     LET mm_sfb08=0
                  END IF
                  #CHI-B50051 --- modify --- start ---   
                  #IF k_sfb.sfb08<=mm_sfb08 THEN
                  #   CALL cl_err(k_sfb.sfb01,'asf-740',0) 
                  #   NEXT FIELD sfb01
                  #ELSE
                     LET k_sfb.sfb08=k_sfb.sfb08-mm_sfb08
                     LET lota = k_sfb.sfb08    #No:MOD-9C0041 add
                  #END IF
                  IF lota < 0 THEN
                     LET k_sfb.sfb08 = 0
                     LET lota = 0
                  END IF
                  #CHI-B50051 --- modify ---  end  ---
                  CALL p302_time(k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb15,'2') RETURNING k_sfb.sfb13   #No:CHI-9C0001 add
                  IF cl_null(k_sfb.sfb13) THEN
                     LET k_sfb.sfb13=g_today
                  END IF
                  IF k_sfb.sfb13 < g_today THEN LET k_sfb.sfb13 = g_today END IF #No:CHI-9C0001 add
                  SELECT ima02,ima021 INTO l_ima02,l_ima021 
                    FROM ima_file
                   WHERE ima01=k_sfb.sfb05
                  DISPLAY l_ima02 TO FORMONLY.ima02_t     #MOD-470043
                  DISPLAY l_ima021 TO FORMONLY.ima021_t   #MOD-470043

                  LET g_sfb92_t = k_sfb.sfb92     #No:CHI-9C0001 add
                  LET g_sfb13_t = k_sfb.sfb13     #No:CHI-9C0001 add
                  LET g_sfb15_t = k_sfb.sfb15     #No:CHI-9C0001 add
 
                  DISPLAY BY NAME k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb13,k_sfb.sfb071,  #MOD-530397-1
                                  k_sfb.sfb15,lota    #No:MOD-9C0041 modify                                        #MOD-530397-1
                  END IF     #No:CHI-9C0001 add
               #MOD-D80153 add begin----------------------
               ELSE
                  SELECT MIN(ksg02) INTO k_sfb.sfb92 FROM ksg_file
                   WHERE ksg01=k_sfb.sfb01
                     AND ksg09!='Y'         #尚未結案
               #MOD-D80153 add end------------------------
               END IF
               LET g_sfb01_t = k_sfb.sfb01     #No:CHI-9C0001 add
            END IF
     
         AFTER FIELD sfb92      #項次
            IF cl_null(k_sfb.sfb01) THEN
               NEXT FIELD sfb01
            END IF
           #---------------No:CHI-9C0001 add
            IF (k_sfb.sfb92 != g_sfb92_t OR cl_null(g_sfb92_t)) OR
               ( k_sfb.sfb01 != g_sfb01_t OR cl_null(g_sfb01_t)) THEN   
           #---------------No:CHI-9C0001 end
               SELECT ksg03,ksg05,ksg07,ksg04
                 INTO k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb071,k_sfb.sfb15
                 FROM ksg_file
                WHERE ksg01=k_sfb.sfb01 AND ksg02=k_sfb.sfb92 AND ksg09='N'
 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","ksg_file",k_sfb.sfb01,k_sfb.sfb92,"asf-737","","",0)    #No.FUN-660128
                  NEXT FIELD sfb01
               END IF
               #-------------------- 99/07/30 以未開單量為預計生產量
               SELECT SUM(sfb08) INTO mm_sfb08 FROM sfb_file
                WHERE sfb91=k_sfb.sfb01 AND sfb92=k_sfb.sfb92
                  AND sfb05=k_sfb.sfb05 AND sfb87!='X'
               IF STATUS OR mm_sfb08 IS NULL THEN
                  LET mm_sfb08=0
               END IF   
               #CHI-B50051 --- modify --- start ---
               #IF k_sfb.sfb08<=mm_sfb08 THEN
               #   CALL cl_err(k_sfb.sfb01,'asf-740',0) 
               #   NEXT FIELD sfb01
               #ELSE
                  LET k_sfb.sfb08=k_sfb.sfb08-mm_sfb08
               #END IF
                  IF k_sfb.sfb08 < 0 THEN
		        LET k_sfb.sfb08 = 0
                  END IF
               #CHI-B50051 --- modify ---  end  ---
               CALL p302_time(k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb15,'2') RETURNING k_sfb.sfb13   #No:CHI-9C0001 add
               IF cl_null(k_sfb.sfb13) THEN
                  LET k_sfb.sfb13=g_today
               END IF
               IF k_sfb.sfb13 < g_today THEN LET k_sfb.sfb13 = g_today END IF #No:CHI-9C0001 add
               SELECT ima02,ima021 INTO l_ima02,l_ima021 
                 FROM ima_file
                WHERE ima01=k_sfb.sfb05
               DISPLAY l_ima02 TO FORMONLY.ima02_t     #MOD-470043
               DISPLAY l_ima021 TO FORMONLY.ima021_t   #MOD-470043

               LET g_sfb13_t = k_sfb.sfb13     #No:CHI-9C0001 add
               LET g_sfb15_t = k_sfb.sfb15     #No:CHI-9C0001 add
 
               DISPLAY BY NAME k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb13,k_sfb.sfb071,  #MOD-530397-1
                               k_sfb.sfb15                                        #MOD-530397-1
               END IF     #No:CHI-9C0001 add
            LET g_sfb92_t = k_sfb.sfb92     #No:CHI-9C0001 add
     
         AFTER FIELD sfb81        #開單日期
            IF cl_null(k_sfb.sfb81) THEN
               NEXT FIELD sfb81 
            END IF
       
         AFTER FIELD sfb13
       #TQC-C80130--add--start--
            IF NOT cl_null(k_sfb.sfb13) THEN
               IF k_sfb.sfb13 < k_sfb.sfb81 THEN
                  CALL cl_err('','asf-867',1)
                  NEXT FIELD sfb13
               END IF
               LET li_result = 0
               CALL s_daywk(k_sfb.sfb13) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(k_sfb.sfb13,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(k_sfb.sfb13,'mfg3153',1)
               END IF
            END IF
       #TQC-C80130--add--end--
            IF NOT cl_null(k_sfb.sfb15) AND NOT cl_null(k_sfb.sfb13) THEN
               IF k_sfb.sfb13 > k_sfb.sfb15 THEN
                  CALL cl_err(' ','asf-310',1)
                  #NEXT FIELD sfb13   #MOD-C30277
               END IF
              #---------------No:CHI-9C0001 add
               IF k_sfb.sfb13 != g_sfb13_t OR cl_null(g_sfb13_t) THEN
                  IF cl_confirm("asf-983") THEN
                     CALL p302_time(k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb13,'1') 
                            RETURNING k_sfb.sfb15  
                     DISPLAY BY NAME k_sfb.sfb15
                  END IF 
                  LET g_sfb13_t = k_sfb.sfb13     #No:CHI-9C0001 add
                  LET g_sfb15_t = k_sfb.sfb15     #No:CHI-9C0001 add
               END IF   
              #---------------No:CHI-9C0001 end 
            END IF
 
         AFTER FIELD sfb15
       #TQC-C80130--add--start--
            IF NOT cl_null(k_sfb.sfb15) THEN 
               IF k_sfb.sfb15 < k_sfb.sfb81 THEN
                  CALL cl_err('','asf-868',1)
                   NEXT FIELD sfb15
               END IF
               LET li_result = 0
               CALL s_daywk(k_sfb.sfb15) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(k_sfb.sfb15,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(k_sfb.sfb15,'mfg3153',1)
               END IF
            END IF
       #TQC-C80130--add--end--
            IF NOT cl_null(k_sfb.sfb15) AND NOT cl_null(k_sfb.sfb13) THEN
               IF k_sfb.sfb13 > k_sfb.sfb15 THEN
                  CALL cl_err(' ','asf-310',1)
                  #NEXT FIELD sfb15  #MOD-C30277
               END IF
              #---------------No:CHI-9C0001 add
               IF k_sfb.sfb15 != g_sfb15_t OR cl_null(g_sfb15_t) THEN
                  IF cl_confirm("asf-988") THEN
                     CALL p302_time(k_sfb.sfb05,k_sfb.sfb08,k_sfb.sfb15,'2') 
                            RETURNING k_sfb.sfb13  
                     IF k_sfb.sfb13 < g_today THEN LET k_sfb.sfb13 = g_today END IF
                     DISPLAY BY NAME k_sfb.sfb13
                  END IF 
                  LET g_sfb13_t = k_sfb.sfb13     #No:CHI-9C0001 add
                  LET g_sfb15_t = k_sfb.sfb15     #No:CHI-9C0001 add
               END IF   
              #---------------No:CHI-9C0001 end 
            END IF
 
         AFTER FIELD sfb08        #預計產量
           #--------------No:MOD-9C0449 modify
           #IF cl_null(k_sfb.sfb08) OR k_sfb.sfb08 = 0 THEN
           #   NEXT FIELD sfb08 
           #END IF
            IF cl_null(k_sfb.sfb08) THEN
               NEXT FIELD sfb08 
            ELSE 
               IF k_sfb.sfb08 <= 0 THEN 
                  CALL cl_err('','axr-034',0)
                  NEXT FIELD sfb08 
               END IF
            END IF
           #--------------No:MOD-9C0449 end
     
         AFTER FIELD sfb42        #展開階數
            IF k_sfb.sfb42 IS NULL THEN
               NEXT FIELD sfb42
            END IF
     
         AFTER FIELD lot          #批數
            IF lot=' ' OR lot IS NULL THEN
               NEXT FIELD lot
            END IF
            IF lot IS NOT NULL THEN
               IF lot < 0 THEN 
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT 
               END IF 
            END IF  

         #MOD-D20044 add begin----------------------------------
         ON CHANGE lot
            IF NOT cl_null(lot) THEN 
               IF lot != 0 THEN 
                  LET lota=k_sfb.sfb08/lot
                  SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = k_sfb.sfb05
                  LET lota=s_digqty(lota,l_ima55)
               ELSE 
                  LET lota=k_sfb.sfb08
               END IF 
               DISPLAY BY NAME lota 
            END IF 
         #MOD-D20044 add end------------------------------------
         
         AFTER FIELD lota         #批量
            IF lota=' ' OR lota IS NULL THEN
               NEXT FIELD lota
            END IF
            IF lot=0 AND lota=0 THEN
               NEXT FIELD lot
            END IF
            #TQC-B80103  --begin
            SELECT ima56,ima561 INTO l_ima56,l_ima561 
             FROM ima_file 
             WHERE ima01= k_sfb.sfb05 
            IF NOT cl_null(lota) THEN
               IF l_ima561 > 0 THEN #生產單位批量&最少生產數量
                  IF lota <l_ima561 THEN
                     CALL cl_err(l_ima561,'asf-307',0)
                     NEXT FIELD lota
                  END IF
               END IF
               IF NOT cl_null(l_ima56) AND l_ima56>0  THEN #生產單位批量
                  LET l_qty1 = lota * 1000
                  LET l_qty2 = l_ima56 * 1000
                  IF (l_qty1 MOD l_qty2) > 0 THEN
                     CALL cl_err(l_ima56,'asf-308',0)
                     NEXT FIELD lota
                  END IF
               END IF
            END IF 
            #TQC-B80103  --end 
     
         AFTER FIELD g_sw   
            IF g_sw=' ' OR g_sw IS NULL THEN
               NEXT FIELD g_sw
            END IF
            IF g_sw NOT MATCHES '[YN]' THEN
               NEXT FIELD g_sw 
            END IF

         BEFORE FIELD sfb82
            LET p_flag_sfb82 = 'Y'
 
         AFTER FIELD sfb82        #部門廠商
            IF k_sfb.sfb82 IS NOT NULL THEN
               SELECT gem01 FROM gem_file WHERE gem01=k_sfb.sfb82
                  AND gemacti = 'Y'
               IF STATUS THEN
                  SELECT pmc03 FROM pmc_file WHERE pmc01 =k_sfb.sfb82
                     AND pmcacti = 'Y'
                  IF SQLCA.sqlcode THEN 
                     CALL cl_err3("sel","pmc_file",k_sfb.sfb82,"",STATUS,"","sel pmc",1)    #No.FUN-660128
                     NEXT FIELD sfb82
                  END IF
               END IF
            END IF
            LET p_flag_sfb82 = 'N'   #FUN-5C0063

        #------------No:MOD-9C0449 add
         AFTER INPUT
            #MOD-C30277--add--str--
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               RETURN
            END IF
            IF NOT p302_bom_chk() THEN NEXT FIELD sfb01 END IF   #TQC-C40168 add
            IF NOT cl_null(k_sfb.sfb15) AND NOT cl_null(k_sfb.sfb13) THEN
               IF k_sfb.sfb13 > k_sfb.sfb15 THEN
                  CALL cl_err(' ','asf-310',1)
                  NEXT FIELD sfb13
               END IF
            END IF
            #MOD-C30277--add--end--
            IF k_sfb.sfb08 <= 0 THEN 
               CALL cl_err('','axr-034',0)
               NEXT FIELD sfb08 
            END IF
        #------------No:MOD-9C0449 add
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(sfb01) 
                       CALL q_ksg(FALSE,TRUE,k_sfb.sfb01,k_sfb.sfb92) 
                            RETURNING k_sfb.sfb01,k_sfb.sfb92
                       DISPLAY BY NAME k_sfb.sfb01,k_sfb.sfb92 
                       NEXT FIELD sfb01
                  WHEN INFIELD(sfb82)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.default1 = k_sfb.sfb82
                        CALL cl_create_qry() RETURNING k_sfb.sfb82
                        DISPLAY BY NAME k_sfb.sfb82 
                        NEXT FIELD sfb82
                     OTHERWISE EXIT CASE
              END CASE
 
         ON ACTION qry_vender1   #查詢委外廠商
            IF p_flag_sfb82 = 'Y' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"
               LET g_qryparam.default1 = k_sfb.sfb82
               CALL cl_create_qry() RETURNING k_sfb.sfb82
               DISPLAY BY NAME k_sfb.sfb82
               NEXT FIELD sfb82
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT    
         ON ACTION controlg                        #No.TQC-A50073    
            CALL cl_cmdask()                       #No.TQC-A50073
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE 
      END IF
      MESSAGE "WAITING..." 
      CALL new.clear()
      LET g_rec_b = 0
      LET g_i=1

      IF lot!=0 THEN
         #----- 依批數展開
         LET mm_qty1=k_sfb.sfb08/lot
         #MOD-D20044 add begin----------------------------------
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = k_sfb.sfb05
         LET mm_qty1=s_digqty(mm_qty1,l_ima55)
         #MOD-D20044 add end------------------------------------
         FOR i=1 TO lot 
            LET new[g_i].new_part=k_sfb.sfb05
            IF i=lot THEN
               IF mm_qty1*(i+1)>k_sfb.sfb08 THEN
                  LET mm_qty1=k_sfb.sfb08-mm_qty1*(i-1)
               ELSE
                  LET mm_qty1=mm_qty1*i-k_sfb.sfb08
               END IF
            END IF
            LET new[g_i].new_qty=mm_qty1   
            LET new[g_i].b_date=k_sfb.sfb13
            LET new[g_i].e_date=k_sfb.sfb15
            LET new[g_i].ven_no=k_sfb.sfb82
            SELECT ima111,ima08,ima02,ima021                 #MOD-470043
              INTO new[g_i].new_no,new[g_i].wo_type,         #MOD-470043
                   new[g_i].ima02,new[g_i].ima021            #MOD-470043
             FROM ima_file WHERE ima01=k_sfb.sfb05
            IF new[g_i].wo_type='M' THEN
               LET new[g_i].wo_type='1'
            ELSE
               LET new[g_i].wo_type='7'
            END IF
            LET l_ima910=''
            SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=k_sfb.sfb05
            IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
            CALL p302_bom(0,k_sfb.sfb05,l_ima910,mm_qty1,k_sfb.sfb13,  #FUN-550112
                         #k_sfb.sfb15,k_sfb.sfb82)
                          k_sfb.sfb15,k_sfb.sfb82,g_i) #MOD-D70022 add 
            LET g_i=g_i+1
         END FOR
      ELSE
         #----- 依批量展開
         LET mm_qty1=lota   
         #MOD-D20044 add begin----------------------------------
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = k_sfb.sfb05
         LET mm_qty1=s_digqty(mm_qty1,l_ima55)
         #MOD-D20044 add end------------------------------------         
         LET l_mod= k_sfb.sfb08 MOD lota
         IF l_mod=0 THEN
            LET lot=k_sfb.sfb08/lota
         ELSE
            LET lot=k_sfb.sfb08/lota+1
         END IF
         FOR i=1 TO lot 
            LET new[g_i].new_part=k_sfb.sfb05
            IF i=lot THEN
               LET mm_qty1=k_sfb.sfb08-mm_qty1*(i-1)
            END IF
            LET new[g_i].new_qty=mm_qty1   
            IF new[g_i].new_qty>lota THEN
              CALL cl_err(new[i].new_qty,'asf-821',0)
              END IF
            LET new[g_i].b_date=k_sfb.sfb13
            LET new[g_i].e_date=k_sfb.sfb15
            LET new[g_i].ven_no=k_sfb.sfb82
             SELECT ima111,ima08,ima02,ima021                #MOD-470043
               INTO new[g_i].new_no,new[g_i].wo_type,        #MOD-470043
                    new[g_i].ima02,new[g_i].ima021           #MOD-470043
              FROM ima_file WHERE ima01=k_sfb.sfb05
            IF new[g_i].wo_type='M' THEN
               LET new[g_i].wo_type='1'
            ELSE
               LET new[g_i].wo_type='7'
            END IF
            LET l_ima910=''
            SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=k_sfb.sfb05
            IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
            CALL p302_bom(0,k_sfb.sfb05,l_ima910,mm_qty1,k_sfb.sfb13,  #FUN-550112
                         #k_sfb.sfb15,k_sfb.sfb82)
                          k_sfb.sfb15,k_sfb.sfb82,g_i) #MOD-D70022 add 
            LET g_i=g_i+1
         END FOR
      END IF
      LET g_i=g_i-1
      LET g_rec_b = g_i
      DISPLAY g_i TO FORMONLY.cnt 
      LET g_success='Y'
      BEGIN WORK
      CALL asfp302()
      CALL s_showmsg()           #NO.FUN-710026
      IF g_success='Y' THEN
         COMMIT WORK
         LET old_sfb01 = k_sfb.sfb01   #FUN-660119 add
         LET old_sfb92 = k_sfb.sfb92   #FUN-660119 add
         LET g_first = 'N'             #FUN-660119 add
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p302_w
END FUNCTION
 
#-----------------------------No.TQC-AC0238 add-------------------------------
FUNCTION p302_new_no(i)
DEFINE l_slip     LIKE smy_file.smyslip
DEFINE l_smy73    LIKE smy_file.smy73
DEFINE i          LIKE type_file.num5 
   LET g_errno = ' '
   LET l_slip = s_get_doc_no(new[i].new_no)
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-875'
   END IF
END FUNCTION
#-----------------------------No.TQC-AC0238 add-------------------------------
#-----------------------------No:CHI-9C0001 add-------------------------------
FUNCTION p302_time(p_sfb05,p_sfb08,p_date,p_cmd)

DEFINE p_cmd      LIKE type_file.chr1  #'1'代表推算預計完工日
                                       #'2'代表推算預計開工日
DEFINE l_ima59    LIKE ima_file.ima59
DEFINE l_ima60    LIKE ima_file.ima60
DEFINE l_ima61    LIKE ima_file.ima61
DEFINE l_time     LIKE sfb_file.sfb13
DEFINE l_date     LIKE sfb_file.sfb13
DEFINE li_result  LIKE type_file.num5 
DEFINE l_day      LIKE type_file.num5  
DEFINE i          LIKE type_file.num5  
DEFINE l_ima56    LIKE ima_file.ima56  
DEFINE p_sfb05    LIKE sfb_file.sfb05
DEFINE p_sfb08    LIKE sfb_file.sfb08
DEFINE p_date     LIKE sfb_file.sfb13
DEFINE l_ima601   LIKE ima_file.ima601   #TQC-B60297


   SELECT ima59,ima60,ima61,ima56,ima601 INTO l_ima59,l_ima60,l_ima61,l_ima56,l_ima601  #TQC-B60297 add ima601
      FROM ima_file WHERE ima01=p_sfb05

   LET l_time = p_date
   #應把日期拆開一天一天計算是否為工作日，如否則再往下一天推
    #LET l_day = (l_ima59+l_ima60*p_sfb08+l_ima61)            #TQC-B60297
     LET l_day = (l_ima59+l_ima60/l_ima601*p_sfb08+l_ima61)   #TQC-B60297
   WHILE TRUE
      LET li_result = 0
      CALL s_daywk(l_time) RETURNING li_result
      CASE 
        WHEN li_result = 0  #0:非工作日
          LET l_time = l_time + 1
          CONTINUE WHILE
        WHEN li_result = 1  #1:工作日
          EXIT WHILE
        WHEN li_result = 2  #2:無設定
          CALL cl_err(l_time,'mfg3153',0)
          EXIT WHILE
        OTHERWISE EXIT WHILE
      END CASE
   END WHILE
   LET p_date = l_time
   IF p_cmd = '1' THEN
      CALL s_aday(p_date,1,l_day) RETURNING l_date
   ELSE 
      CALL s_aday(p_date,-1,l_day) RETURNING l_date
   END IF
   RETURN l_date

END FUNCTION
#-----------------------------No:CHI-9C0001 add-------------------------------

FUNCTION asfp302()
   DEFINE l_name        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
   DEFINE l_za05        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
    DEFINE new_part      LIKE sfb_file.sfb05   #No.MOD-490217
    DEFINE l_item        LIKE ima_file.ima571  #No.MOD-490217
   DEFINE i,j           LIKE type_file.num10         #No.FUN-680121 INTEGER
   DEFINE ask           LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE l_ima910   LIKE ima_file.ima910        #FUN-550112
   DEFINE li_result     LIKE type_file.num5      #No.FUN-550067        #No.FUN-680121 SMALLINT
   DEFINE l_ksg930      LIKE ksg_file.ksg930     #FUN-670103
   DEFINE l_sfci        RECORD LIKE sfci_file.*  #NO.FUN-7B0018
   DEFINE l_flag        LIKE type_file.chr1      #NO.FUN-7B0018
   DEFINE l_sfbi        RECORD LIKE sfbi_file.*  #NO.FUN-7B0018
   DEFINE l_sfb39       LIKE sfb_file.sfb39      #No.FUN-880009
   DEFINE l_cnt         LIKE type_file.num5      #No.FUN-880009
   DEFINE l_cnt1        LIKE type_file.num5      #No.FUN-880009
   DEFINE l_bdate_t     LIKE sfb_file.sfb13   #No:CHI-9C0001 add
   DEFINE l_edate_t     LIKE sfb_file.sfb13   #No:CHI-9C0001 add
   DEFINE   l_qty1           LIKE sfb_file.sfb08            #No.TQC-B90123 add
   DEFINE   l_qty2           LIKE ima_file.ima56            #No.TQC-B90123 add
   DEFINE   l_ima56          LIKE ima_file.ima56            #No.TQC-B90123 add
   DEFINE   l_ima561         LIKE ima_file.ima561           #No.TQC-B90123 add
#  DEFINE   l_cnt3           LIKE type_file.num5            #TQC-BA0134  #TQC-BB0015 mark
   DEFINE l_i           LIKE type_file.num10   #MOD-D70022 add
   DEFINE l_smy60       LIKE smy_file.smy60    #MOD-D80129 add
   
   LET l_allow_insert =FALSE
   LET l_allow_delete =FALSE
 
   INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE ROW 
        LET i=ARR_CURR()
        LET l_bdate_t = new[i].b_date   #No:CHI-9C0001 add
        LET l_edate_t = new[i].e_date   #No:CHI-9C0001 add
#FUN-AB0025 ---------------STA
      AFTER FIELD new_part
        IF NOT cl_null(new[i].new_part) THEN
            IF NOT s_chk_item_no(new[i].new_part,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD new_part
            END IF
        END IF
#FUN-AB0025 ---------------END
 
      BEFORE FIELD new_qty 
        SELECT ima02,ima021 INTO new[i].ima02,new[i].ima021 FROM ima_file 
         WHERE ima01=new[i].new_part
           AND imaacti = 'Y'
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("sel","ima_file",new[i].new_part,"","asf-310","","",0)    #No.FUN-660128
           NEXT FIELD new_part
        END IF
 
      AFTER FIELD new_qty 
        IF new[i].new_qty IS NULL OR new[i].new_qty<0 THEN 
           NEXT FIELD new_qty 
          ELSE 
#TQC-B90123  --begin
            SELECT ima56,ima561 INTO l_ima56,l_ima561 
             FROM ima_file 
             WHERE ima01= k_sfb.sfb05 
            IF NOT cl_null(new[i].new_qty) THEN
               IF l_ima561 > 0 THEN #生產單位批量&最少生產數量
                  IF new[i].new_qty <l_ima561 THEN
                     CALL cl_err(l_ima561,'asf-307',0)
                     NEXT FIELD new_qty
                  END IF
               END IF
               IF NOT cl_null(l_ima56) AND l_ima56>0  THEN #生產單位批量
                  LET l_qty1 = new[i].new_qty * 1000
                  LET l_qty2 = l_ima56 * 1000
                  IF (l_qty1 MOD l_qty2) > 0 THEN
                     CALL cl_err(l_ima56,'asf-308',0)
                     NEXT FIELD new_qty
                  END IF
               END IF
            END IF 
#TQC-B90123  --end 
        END IF
 
      AFTER FIELD b_date
        IF new[i].b_date IS NOT NULL AND new[i].b_date!=' ' AND
           new[i].e_date IS NOT NULL AND new[i].e_date!=' ' THEN
          #---------------No:CHI-9C0001 add
           IF new[i].b_date != l_bdate_t OR cl_null(l_bdate_t) THEN
          #TQC-C80130--add--start--
              LET li_result = 0
              CALL s_daywk(new[i].b_date) RETURNING li_result
              IF li_result = 0 THEN      #0:非工作日
                 CALL cl_err(new[i].b_date,'mfg3152',1)
              END IF
              IF li_result = 2 THEN      #2:未設定
                 CALL cl_err(new[i].b_date,'mfg3153',1)
              END IF
          #TQC-C80130--add--end--
              IF cl_confirm("asf-983") THEN
                 CALL p302_time(new[i].new_part,new[i].new_qty,new[i].b_date,'1') 
                        RETURNING  new[i].e_date 
                 DISPLAY BY NAME new[i].e_date
                 LET l_bdate_t = new[i].b_date
                 LET l_edate_t = new[i].e_date
              END IF 
           END IF   
          #---------------No:CHI-9C0001 end 
       #TQC-C80130--add--start--
           IF new[i].b_date < k_sfb.sfb81 THEN
              CALL cl_err('','asf-867',1) 
              NEXT FIELD b_date
           END IF
       #TQC-C80130--add--end--
           IF new[i].e_date<new[i].b_date THEN
              CALL cl_err(new[i].b_date,'asf-310',1)    
              NEXT FIELD b_date
           END IF
        END IF
 
      AFTER FIELD e_date  
        IF new[i].b_date IS NOT NULL AND new[i].b_date!=' ' AND 
           new[i].e_date IS NOT NULL AND new[i].e_date!=' ' THEN
          #---------------No:CHI-9C0001 add
           IF new[i].e_date != l_edate_t OR cl_null(l_edate_t) THEN
       #TQC-C80130--add--start--
             LET li_result = 0
             CALL s_daywk(new[i].e_date) RETURNING li_result
             IF li_result = 0 THEN      #0:非工作日
                CALL cl_err(new[i].e_date,'mfg3152',1)
             END IF
             IF li_result = 2 THEN      #2:未設定
                CALL cl_err(new[i].e_date,'mfg3153',1)
             END IF
       #TQC-C80130--add--end--
              IF cl_confirm("asf-988") THEN
                 CALL p302_time(new[i].new_part,new[i].new_qty,new[i].e_date,'2') 
                        RETURNING  new[i].b_date 
                 IF new[i].b_date < g_today THEN LET new[i].b_date = g_today END IF
                 DISPLAY BY NAME new[i].b_date
                 LET l_bdate_t = new[i].b_date
                 LET l_edate_t = new[i].e_date
              END IF 
           END IF   
          #---------------No:CHI-9C0001 end 
        #TQC-C80130--add--start--
           IF new[i].e_date < k_sfb.sfb81 THEN
              CALL cl_err('','asf-868',1)     
              NEXT FIELD e_date
           END IF
       #TQC-C80130--add--end--
           IF new[i].e_date<new[i].b_date THEN 
              CALL cl_err(new[i].b_date,'mfg9234',0)
              NEXT FIELD b_date 
           END IF
        END IF
 
      AFTER FIELD new_no  
        CALL p302_new_no(i)                #No.TQC-AC0238
        IF NOT cl_null(g_errno) THEN       #No.TQC-AC0238
           CALL cl_err(new[i].new_no,g_errno,0)    #No.TQC-AC0238
           LET new[i].new_no = NULL        #No.TQC-AC0238
           DISPLAY BY NAME new[i].new_no   #No.TQC-AC0238
           NEXT FIELD new_no               #No.TQC-AC0238
        END IF                             #No.TQC-AC0238 
        IF cl_null(new[i].new_no) THEN 
           CALL cl_err(' ','asf-967',1)    #No.FUN-5A0223 add
           NEXT FIELD new_no 
        END IF 
        CALL s_check_no("asf",new[i].new_no,"","1","","","") 
             RETURNING li_result,new[i].new_no
        IF (NOT li_result) THEN
           NEXT FIELD new_no
        END IF
        
      AFTER FIELD wo_type
        IF cl_null(new[i].wo_type) THEN NEXT FIELD wo_type END IF
        IF new[i].wo_type NOT MATCHES '[17]' THEN NEXT FIELD wo_type END IF
 
      AFTER FIELD ven_no
        IF new[i].ven_no IS NOT NULL THEN
           IF new[i].wo_type=1 THEN
              SELECT gem02 FROM gem_file WHERE gem01=new[i].ven_no
                                           AND gemacti = 'Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    #No.FUN-660128
                   NEXT FIELD ven_no                    
              END IF
           END IF
           IF new[i].wo_type=7 THEN
              SELECT pmc03 FROM pmc_file WHERE pmc01=new[i].ven_no
                                           AND pmcacti = 'Y'
              IF STATUS THEN
                 CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc:",1)    #No.FUN-660128
                   NEXT FIELD ven_no                
              END IF
           END IF
        END IF
 
      AFTER ROW 
        IF INT_FLAG THEN 
           LET INT_FLAG=0 
           LET g_success='N' 
           CALL s_showmsg_init() #No.TQC-A90021
           #CALL new.clear() 
           #CALL p302_tm()
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM #No.TQC-A90021
           RETURN 
        END IF
 
        AFTER INPUT
          FOR j = 1 TO g_rec_b
            IF cl_null(new[j].new_no) THEN
               CALL cl_err('','asf-420',0)
               LET i = j
               CALL fgl_set_arr_curr(i)
               NEXT FIELD new_no
            END IF
          END FOR
 
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(new_part) 
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.default1 = new[i].new_part
#               CALL cl_create_qry() RETURNING new[i].new_part
                CALL q_sel_ima(FALSE, "q_ima","",new[i].new_part,"","","","","",'' ) 
                      RETURNING  new[i].new_part
#FUN-AA0059---------mod------------end-----------------
               DISPLAY new[i].new_part TO s_new[i].new_part 
               NEXT FIELD new_part
            WHEN INFIELD(new_qty) 
               LET g_cmd = "aimq102"," '1' "," '",new[i].new_part,"' "
               CALL cl_cmdrun(g_cmd CLIPPED)
            WHEN INFIELD(new_no)
               LET g_sql = "(smy73 <> 'Y' OR smy73 is null)"     #No.TQC-AC0238
               CALL smy_qry_set_par_where(g_sql)                 #No.TQC-AC0238
               LET g_t1 = s_get_doc_no(new[i].new_no)            #No.TQC-AC0238
               CALL q_smy(FALSE,FALSE,new[i].new_no,'ASF','1') RETURNING new[i].new_no   #TQC-670008
            #   LET new[i].new_no=g_t1                            #No.TQC-AC0238
               DISPLAY BY NAME new[i].new_no
               NEXT FIELD new_no
            WHEN INFIELD(ven_no)
             IF new[i].wo_type=1 THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = new[i].ven_no
               CALL cl_create_qry() RETURNING new[i].ven_no
               DISPLAY new[i].ven_no TO s_new[i].ven_no     
               NEXT FIELD ven_no
             ELSE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = new[i].ven_no
                 CALL cl_create_qry() RETURNING new[i].ven_no
                 DISPLAY new[i].ven_no TO s_new[i].ven_no     
                 NEXT FIELD ven_no
             END IF
            OTHERWISE EXIT CASE 
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        ON ACTION controls                                                                                                          
           CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")                                                                                      
      ON ACTION controlg               #No.TQC-A50073
         CALL cl_cmdask()              #No.TQC-A50073
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG=0 
      CALL s_showmsg_init() #No.TQC-A90021
      LET g_success='N' 
      RETURN 
   END IF
   
   
   #TQC-B90123  --begin
            SELECT ima56,ima561 INTO l_ima56,l_ima561 
             FROM ima_file 
             WHERE ima01= k_sfb.sfb05 
            IF NOT cl_null(new[i].new_qty) THEN
               IF l_ima561 > 0 THEN #生產單位批量&最少生產數量
                  IF new[i].new_qty <l_ima561 THEN
                     CALL cl_err(l_ima561,'asf-307',0)
                     LET g_success = 'N'
                     RETURN 
                  END IF
               END IF
               IF NOT cl_null(l_ima56) AND l_ima56>0  THEN #生產單位批量
                  LET l_qty1 = new[i].new_qty * 1000
                  LET l_qty2 = l_ima56 * 1000
                  IF (l_qty1 MOD l_qty2) > 0 THEN
                     CALL cl_err(l_ima56,'asf-308',0)
                     LET g_success = 'N'
                     RETURN 
                  END IF
               END IF
            END IF 
#TQC-B90123  --end 


   IF NOT cl_sure(19,0) THEN LET g_success='N' RETURN END IF
   LET ask=0
 
# FUN-B60116寫法問題:若單身有多筆，則用戶需多次做是否審核的確認動作
# TQC-BA0134寫法問題:此時尚未生成單身，永遠單據拋轉失敗
#---> TQC-BB0015 mark
# #FUN-B60116 add str----
#  FOR i=1 TO new.getLength()
#      LET l_sfb.sfb01 =new[i].new_no
#      LET l_slip = s_get_doc_no(l_sfb.sfb01)           
#      SELECT smyapr INTO l_smyapr FROM smy_file WHERE smyslip = l_slip
#      IF l_smyapr = 'N' THEN 
# #FUN-B60116 add end----
# 
# #TQC-BA0134  --begin
#  #IF cl_confirm('axm-108') THEN LET ask=1 END IF  #是否確認
#  IF cl_confirm('axm-108') THEN 
#     LET l_cnt3 = 0  
#     SELECT COUNT(*) INTO l_cnt3 FROM sfa_file WHERE sfa01 = l_sfb.sfb01
#     IF l_cnt3 = 0 THEN
#        CALL cl_err(l_sfb.sfb01,'mfg-009',0) 
#        LET g_success='N' 
#        RETURN
#     END IF
#     LET ask=1 
#  END IF  #是否確認
#  #TQC-BA0134  --end
#  
#      END IF  #FUN-B60116 add
#  END FOR     #FUN-B60116 add            
#---> TQC-BB0015 mark--end
#---> TQC-BB0015 add
   IF g_sma.sma27 = '1' THEN  #後面邏輯里不為1的不會自動生成備料，就不能給它自動審核了
      FOR i=1 TO new.getLength()
          LET l_sfb.sfb01 =new[i].new_no
          LET l_slip = s_get_doc_no(l_sfb.sfb01)
          SELECT smyapr INTO l_smyapr FROM smy_file WHERE smyslip = l_slip
          IF l_smyapr = 'N' THEN    #如果都做簽核處理，那麼直接沒必要提示是否自動審核，如果有部份或全部不做簽核處理，那麼只要提示一遍自動審核即可
             IF cl_confirm('axm-108') THEN LET ask=1 END IF  #是否確認
             EXIT FOR
          END IF
      END FOR
   END IF
#---> TQC-BB0015 add--end
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   CALL cl_outnam('asfp302') RETURNING l_name
   START REPORT p302_rep TO l_name
 
   #-->是否產生PBI 
   IF sfc_sw='Y' THEN 
      #-->產生PBI 檔
      LET l_sfc.sfc01   =k_sfb.sfb01
      LET l_sfc.sfcacti ='Y'
      LET l_sfc.sfcuser =g_user
      LET l_sfc.sfcgrup =g_grup
      LET l_sfc.sfcdate =g_today  #No.TQC-790077
      LET l_sfc.sfcoriu = g_user      #No.FUN-980030 10/01/04
      LET l_sfc.sfcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO sfc_file VALUES(l_sfc.*) 
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfci.* TO NULL
         LET l_sfci.sfci01 = l_sfc.sfc01
        #Mod No.TQC-AB0034
        #LET l_flag = s_ins_sfci(l_sfci.*,'')
         SELECT COUNT(*) INTO l_cnt FROM sfci_file
          WHERE sfci01 = l_sfci.sfci01
         IF l_cnt = 0 THEN
            LET l_flag = s_ins_sfci(l_sfci.*,'')
         END IF
        #End Mod No.TQC-AB0034
      END IF
      LET l_sfd.sfd01   =k_sfb.sfb01
      LET l_sfd.sfd02   =1
      LET l_sfd.sfd03   =k_sfb.sfb01
 
   END IF
   SELECT ksg930 INTO l_ksg930 FROM ksg_file
                                WHERE ksg01=k_sfb.sfb01
                                  AND ksg02=k_sfb.sfb92
   IF SQLCA.sqlcode THEN
      LET l_ksg930=NULL
   END IF
   # -------------
   # 陣列列印資料
   # -------------
   CALL s_showmsg_init()    #NO.FUN-710026
   FOR i=1 TO new.getLength()
   IF g_success='N' THEN                                                                                                          
      LET g_totsuccess='N'                                                                                                       
      LET g_success="Y"                                                                                                          
   END IF                    
 
        IF cl_null(new[i].new_part) THEN EXIT FOR END IF
        IF cl_null(new[i].new_no  ) THEN CONTINUE FOR END IF
        IF cl_null(new[i].new_qty)  THEN CONTINUE FOR END IF
        IF new[i].new_qty  = 0      THEN CONTINUE FOR END IF
        INITIALIZE l_sfb.* TO NULL
        LET l_sfb.sfb01 =new[i].new_no
        LET l_sfb.sfb02 =new[i].wo_type
        LET l_sfb.sfb04 ='1'
        LET l_sfb.sfb05 =new[i].new_part
        SELECT ima571,ima94 INTO l_item,k_sfb.sfb06 FROM ima_file 
         WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
         IF SQLCA.sqlcode THEN
           LET g_showmsg=l_sfb.sfb05,"/",'Y'                                  #NO.FUN-710026   
           CALL s_errmsg('ima01,imaacti',g_showmsg,l_sfb.sfb05,'aom-198',1)   #NO.FUN-710026
           LET g_success = 'N'
           CONTINUE FOR                                                       #NO.FUN-710026
        END IF
        LET l_slip = s_get_doc_no(l_sfb.sfb01)     #No.FUN-550067           
       #SELECT smy57,smyapr INTO l_smy57,l_smyapr FROM smy_file WHERE smyslip=l_slip #NO.3889  #No.TQC-9B0136  #MOD-D80129 mark
        SELECT smy57,smyapr,smy60 INTO l_smy57,l_smyapr,l_smy60 FROM smy_file WHERE smyslip=l_slip  #MOD-D80129 add smy60
        IF l_smy57[1,1] MATCHES '[Yy]' AND cl_null(k_sfb.sfb06) THEN
           CALL s_errmsg('smyslip', l_slip ,l_sfb.sfb05,'asf-301',1)    #NO.FUN-710026
           LET g_success = 'N'
           #ROLLBACK WORK  #No.TQC-A30046
           CONTINUE FOR                                                       #NO.FUN-710026
        END IF
        LET l_ima910=new[i].sfb95 #FUN-650193
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        SELECT bma01 FROM bma_file 
         WHERE bma01=l_sfb.sfb05
           AND bma06 = l_ima910   #FUN-550112
           AND bmaacti = 'Y'      #CHI-740001
        IF STATUS THEN
           LET g_showmsg=l_sfb.sfb05,"/",l_ima910                                   #NO.FUN-710026       
           CALL s_errmsg('bma01,bma06',g_showmsg,l_sfb.sfb05,'mfg5071',1)           #NO.FUN-710026
           LET g_success = 'N'
           #ROLLBACK WORK  #No.TQC-A30046
           CONTINUE FOR                                                       #NO.FUN-710026
        END IF
        #--(1)產生工單檔(sfb_file)---------------------------
        LET l_sfb.sfb06 = k_sfb.sfb06
        LET l_sfb.sfb071=k_sfb.sfb071
        LET l_sfb.sfb08 =new[i].new_qty
        LET l_sfb.sfb081=0   LET l_sfb.sfb09 =0   LET l_sfb.sfb10 =0
        LET l_sfb.sfb11 =0   LET l_sfb.sfb111=0   LET l_sfb.sfb121=0
        LET l_sfb.sfb122=0   LET l_sfb.sfb12 =0
        LET l_sfb.sfb13 =new[i].b_date
        LET l_sfb.sfb15 =new[i].e_date
        LET l_sfb.sfb23 ='N'   LET l_sfb.sfb24 ='N'
        LET l_sfb.sfb251=k_sfb.sfb251
        LET l_sfb.sfb27 =k_sfb.sfb27
        LET l_sfb.sfb28 =''
        LET l_sfb.sfb29 ='Y'
        LET l_sfb.sfb30 =k_sfb.sfb30
        LET l_sfb.sfb31 =k_sfb.sfb31
        LET l_sfb.sfb39 =k_sfb.sfb39
        LET l_sfb.sfb81 =k_sfb.sfb81
        LET l_sfb.sfb82 =new[i].ven_no
        #No.TQC-A70044  --Begin                                                 
        IF sfc_sw='Y' THEN                                                      
           LET l_sfb.sfb85 =k_sfb.sfb01                                         
        ELSE                                                                    
           LET l_sfb.sfb85 =NULL                                                
        END IF                                                                  
        #No.TQC-A70044  --End
       #FUN-B60116 mod str---
       #LET l_sfb.sfb44 = g_user          #No.TQC-A30046  
        SELECT ksf10 INTO l_sfb.sfb44 FROM ksf_file
         WHERE ksf01 = k_sfb.sfb01
       #FUN-B60116 mod end---
        LET l_sfb.sfb104= 'N'             #No.TQC-A30046
        LET l_sfb.sfb86 =''
        LET l_sfb.sfb89 =''  #FUN-C30114
        LET l_sfb.sfb91 =k_sfb.sfb01
        LET l_sfb.sfb92 =k_sfb.sfb92
        LET l_sfb.sfb98 =l_ksg930 #FUN-670103
        IF cl_null(l_sfb.sfb98) THEN  #MOD-D80129 add
           LET l_sfb.sfb98 = l_smy60  #MOD-D80129 add
        END IF                        #MOD-D80129 add
        LET l_sfb.sfb87 = 'N'    #97/08/21 modify
        LET l_sfb.sfb39 = '1'
        LET l_sfb.sfb41 = 'N'
        LET l_sfb.sfb99 = 'N'
        LET l_sfb.sfb17 = 0
        LET l_sfb.sfb95=l_ima910 #FUN-650193
        IF cl_null(l_sfb.sfb95) THEN
           LET l_sfb.sfb95 = ' '
        END IF
        LET l_sfb.sfbacti='Y'
        LET l_sfb.sfbuser=g_user
        LET l_sfb.sfbgrup=g_grup
        LET l_sfb.sfbdate=g_today
        LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
 
        LET l_sfb.sfbplant = g_plant #FUN-980008 add
        LET l_sfb.sfblegal = g_legal #FUN-980008 add
 
        CALL s_auto_assign_no("asf",l_sfb.sfb01,l_sfb.sfb81,"","sfb_file","sfb01","","","") 
        RETURNING li_result,l_sfb.sfb01                                                                                             
        IF (NOT li_result) THEN                                                                                                       
            LET g_success='N' 
            RETURN 
        END IF  #有問題
        #MOD-D70022 add begin---------------
        LET new[i].new_no = l_sfb.sfb01
        IF new[i].rid IS NOT NULL THEN
           LET l_i = new[i].rid
           LET l_sfb.sfb86 = new[l_i].new_no
           LET l_sfb.sfb89 = new[l_i].new_no
        END IF 
        #MOD-D70022 add end-----------------
        LET l_sfb.sfb93=l_smy57[1,1]  #BugNo:4737
        LET l_sfb.sfb94=l_smy57[2,2]
        IF l_sfb.sfb93='Y' THEN
           CALL s_asf_schdat1(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,
                         l_sfb.sfb01,l_sfb.sfb06,l_sfb.sfb02,l_item,    
                         l_sfb.sfb08,2)
              RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
        END IF
#CHI-B80053 -- begin --
        IF cl_null(l_sfb.sfb98) THEN
           SELECT ima34 INTO l_sfb.sfb98 FROM ima_file
            WHERE ima01 = l_sfb.sfb05
        END IF
#CHI-B80053 -- end --
        LET l_sfb.sfbmksg = l_smyapr                                            
        LET l_sfb.sfb43 = '0'           #FUN-B60116 add
        LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
        LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sfb_file VALUES(l_sfb.*)
        IF STATUS THEN
           CALL s_errmsg('sfb01', l_sfb.sfb01 ,k_sfb.sfb01,'asf-738',1)           #NO.FUN-710026     
              LET g_success='N' RETURN  
           CALL s_errmsg('sfb01', l_sfb.sfb01 ,k_sfb.sfb01,SQLCA.sqlcode,1)       #NO.FUN-710026      
              LET g_success='N' 
           CONTINUE FOR                                                       #NO.FUN-710026
        END IF
        IF NOT s_industry('std') THEN
           INITIALIZE l_sfbi.* TO NULL
           LET l_sfbi.sfbi01 = l_sfb.sfb01
           IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
              LET g_success='N' RETURN  
           END IF
        END IF
        #--(2)產生PBI檔(sfd_file)---------------------------
        IF sfc_sw='Y' THEN
           LET l_sfd.sfd01   =k_sfb.sfb01
           SELECT MAX(sfd02) INTO l_sfd.sfd02 FROM sfd_file
                  WHERE sfd01=k_sfb.sfb01
           IF l_sfd.sfd02 IS NULL THEN LET l_sfd.sfd02 = 0 END IF
           LET l_sfd.sfd02   =l_sfd.sfd02 + 1
           LET l_sfd.sfd03   =l_sfb.sfb01
           LET l_sfd.sfdconf = 'N'               #FUN-A90035 add
           LET l_sfd.sfd09   ='2'  #CHI-C60023
           LET  l_sfd.sfduser = g_user        #FUN-D10127
           LET  l_sfd.sfdgrup = g_grup        #FUN-D10127
           LET  l_sfd.sfddate = g_today       #FUN-D10127
           LET  l_sfd.sfdacti ='Y'            #FUN-D10127
           LET  l_sfd.sfdoriu = g_user        #FUN-D10127
           LET  l_sfd.sfdorig = g_grup        #FUN-D10127
           INSERT INTO sfd_file VALUES(l_sfd.*)
           IF STATUS THEN
               CALL s_errmsg('sfd01','k_sfb.sfb01',k_sfb.sfb01,SQLCA.sqlcode,1)                #NO.FUN-710026
                 LET g_success='N' 
                 CONTINUE FOR                                                       #NO.FUN-710026
           END IF
        END IF
        #--(2)產生製程檔(sfd_file)---------------------------
          CALL data_move() 
          LET k_sfb.sfb01 = l_sfb.sfb01
          LET k_sfb.sfb02 = l_sfb.sfb02
          LET k_sfb.sfb05 = l_sfb.sfb05
          LET k_sfb.sfb06 = l_sfb.sfb06
          LET k_sfb.sfb08 = l_sfb.sfb08
          LET k_sfb.sfb071 = l_sfb.sfb071
          LET k_sfb.sfb08 =  l_sfb.sfb08
          LET k_sfb.sfb13 =  l_sfb.sfb13
          LET k_sfb.sfb15 =  l_sfb.sfb15
          #-->產生製程
          LET l_slip = s_get_doc_no(l_sfb.sfb01)     #No.FUN-550067           
          SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
          IF l_smy57[1,1] MATCHES '[Yy]' THEN CALL i302_crrut() END IF 
          CALL data_back() 
 
          #-->產生備料檔
          IF g_sma.sma27='1' THEN
             CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) 
                  RETURNING l_minopseq
             CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                          l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                         #l_minopseq,l_sfb.sfb95)  #No.TQC-610003
                          l_minopseq,'',l_sfb.sfb95)  #No.TQC-610003  #FUN-BC0008 mod
              RETURNING g_cnt
              IF g_cnt = 0 THEN
                 CALL s_errmsg('smyslip', l_slip ,'s_cralc error','asf-385',1)         #NO.FUN-710026 
                 LET g_success = 'N'
                 CONTINUE FOR                                              #NO.FUN-710026
              END IF
        END IF
        SELECT sfb39 INTO l_sfb39 FROM sfb_file WHERE sfb01 = l_sfb.sfb01 
            IF l_sfb39='1' THEN 
               LET l_cnt=0 
               SELECT COUNT(*) INTO l_cnt 
                 FROM sfa_file 
                WHERE sfa01 = l_sfb.sfb01
               
               LET l_cnt1=0 
               SELECT COUNT(*) INTO l_cnt1 
                 FROM sfa_file 
                WHERE sfa01 = l_sfb.sfb01
                  AND sfa11 = 'E' 
               
               IF l_cnt <> 0 THEN
                  IF l_cnt = l_cnt1 THEN
                     UPDATE sfb_file SET sfb39 = '2'
                      WHERE sfb01 = l_sfb.sfb01
                  END IF 
               END IF
            END IF
        IF ask=1 THEN CALL i302_firm1(l_sfb.*) END IF
        OUTPUT TO REPORT p302_rep(l_sfb.*)
   END FOR
   #No.TQC-A30046  --Begin
   #IF g_success='N' THEN                                                                                                          
   #   LET g_totsuccess='N'                                                                                                       
   #   LET g_success="Y"                                                                                                          
   #END IF                    
   IF g_totsuccess = 'N' THEN LET g_success = 'N' END IF 
   #IF g_success = 'Y' THEN 
   #   COMMIT WORK
   #ELSE
   #   ROLLBACK WORK
   #END IF
   #No.TQC-A30046  --End  

   FINISH REPORT p302_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   UPDATE sfb_file SET sfb42=k_sfb.sfb42 WHERE sfb01=k_sfb.sfb01
   ERROR ""
END FUNCTION
 
#FUNCTION p302_bom(p_level,p_key,p_key2,p_qty,p_date,q_date,ven_b)       #FUN-550112
FUNCTION p302_bom(p_level,p_key,p_key2,p_qty,p_date,q_date,ven_b,p_rid)  #MOD-D70022  add p_rid
#No.FUN-A70034  --Begin
   DEFINE l_total      LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA        LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA  LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  

   DEFINE p_level     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_key       LIKE bma_file.bma01,  #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550112
#         p_qty       LIKE ima_file.ima26,          #No.FUN-680121 DEC(18,6)
          p_qty       LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          p_date      LIKE type_file.dat,           #No.FUN-680121 DATE
          p_rid       INTEGER,                      #MOD-D70022 add
          q_date      LIKE type_file.dat,           #No.FUN-680121 DATE
          ven_b       LIKE sfb_file.sfb82,          #No.FUN-680121 VARCHAR(10)
          l_ac,i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          arrno       LIKE type_file.num5,          #No.FUN-680121 SMALLINT #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #FUN-560230
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              ima55 LIKE ima_file.ima55,    #生產單位
              ima59 LIKE ima_file.ima59,
              ima60 LIKE ima_file.ima60,
              ima601 LIKE ima_file.ima601,  #No.FUN-840194
              ima61 LIKE ima_file.ima61,
              ima08 LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              ima111 LIKE ima_file.ima111,        #No.FUN-680121 VARCHAR(05) #No.FUN-550067 
              ima56 LIKE ima_file.ima56,          #FUN-710073 add 
              #No.FUN-A70034  --Begin
              bmb08  LIKE bmb_file.bmb08,
              bmb081 LIKE bmb_file.bmb081,
              bmb082 LIKE bmb_file.bmb082
              #No.FUN-A70034  --End  
          END RECORD
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE l_cnt       LIKE type_file.num5    #No:MOD-9C0079 add
 
    

    IF p_level>20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1 IF p_level > k_sfb.sfb42 THEN RETURN END IF
    LET arrno = 600
    DECLARE p302_c1 CURSOR FOR
          #No.FUN-A70034  --Begin
          #SELECT bmb03,bmb06/bmb07*(1+bmb08/100),bmb10,bmb18, #ima25,  #No:9027
          #       ima55,                                                #No:9027
          #       ima59,ima60,ima601,ima61,ima08,ima111,ima56 #No.FUN-840194 #FUN-710073 add ima56 
          SELECT bmb03,bmb06/bmb07,bmb10,bmb18,ima55,                                                #No:9027
                 ima59,ima60,ima601,ima61,ima08,ima111,ima56,
                 bmb08,bmb081,bmb082
          #No.FUN-A70034  --End  
                 FROM bmb_file, ima_file
                 WHERE bmb01=p_key 
                   AND bmb29=p_key2  #FUN-550112
                   AND bmb03=ima01
                   AND (bmb04<=k_sfb.sfb071)
                   AND (bmb05> k_sfb.sfb071 OR bmb05 IS NULL)
                   AND (ima08='X' OR ima08='M' OR ima08 = 'S')      #MOD-9B0070 add ima08='S'
    LET l_ac=1
    FOREACH p302_c1 INTO sr[l_ac].*  # 先將BOM單身存入BUFFER
       IF STATUS THEN 
         CALL cl_err('fore p302_cur:',STATUS,1) EXIT FOREACH    
       END IF
       #No.FUN-A70034  --Begin
       #LET sr[l_ac].bmb06=p302_unit_transfer(sr[l_ac].bmb03,
       #                       sr[l_ac].ima55,sr[l_ac].bmb10,sr[l_ac].bmb06)
       #LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       #No.FUN-A70034  --End  
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p302_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
       #No.FUN-A70034  --Begin
       CALL cralc_rate(p_key,sr[i].bmb03,p_qty,sr[i].bmb081,sr[i].bmb08,sr[i].bmb082,sr[i].bmb06,0)
            RETURNING l_total,l_QPA,l_ActualQPA
       LET sr[i].bmb06 = l_total
       LET sr[i].bmb06 = p302_unit_transfer(sr[i].bmb03,
                         sr[i].ima55,sr[i].bmb10,sr[i].bmb06)
       #No.FUN-A70034  --End  
       IF g_sw='Y' THEN
           IF sr[i].ima08='M' OR sr[i].ima08='S' THEN      #MOD-9B0070 modify
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM bma_file
              WHERE bma01=sr[i].bmb03
                AND bma06 = l_ima910[i]   
                AND bma05 IS NOT NULL
                AND bmaacti = 'Y'      
             IF l_cnt <= 0 THEN 
                CONTINUE FOR
             END IF
 
             LET g_i=g_i+1
             LET new[g_i].rid = p_rid  #MOD-D70022 add
             LET new[g_i].new_part= sr[i].bmb03
             SELECT ima02,ima021 INTO new[g_i].ima02,new[g_i].ima021
               FROM ima_file 
              WHERE ima01=new[g_i].new_part
             LET new[g_i].sfb95= p_key2 #FUN-650193
             LET new[g_i].new_qty = sr[i].bmb06
           #-----------------No:CHI-9C0001 modify
           # LET new[g_i].b_date  = p_date+sr[i].bmb18-
           #              (sr[i].ima59+sr[i].ima60/sr[i].ima601*sr[i].bmb06+sr[i].ima61)   #No.FUN-840194 #CHI-810015 mark還原   
           # LET new[g_i].e_date  = q_date+sr[i].bmb18-
           #              (sr[i].ima59+sr[i].ima60/sr[i].ima601*sr[i].bmb06+sr[i].ima61)  #No.FUN-840194 #CHI-810015 mark還原 

             LET new[g_i].e_date  = p_date+sr[i].bmb18
             CALL p302_time(new[g_i].new_part,new[g_i].new_qty,new[g_i].e_date,'2')
                             RETURNING new[g_i].b_date  
             IF cl_null(new[g_i].b_date) THEN
                LET new[g_i].e_date=g_today
             END IF
             IF new[g_i].e_date < g_today THEN LET new[g_i].e_date = g_today END IF 
           #-----------------No:CHI-9C0001 end
             LET new[g_i].ven_no  = ven_b
             LET new[g_i].new_no  = sr[i].ima111
             IF sr[i].ima08 = 'S' THEN
                LET new[g_i].wo_type  = '7'
             ELSE
                LET new[g_i].wo_type  = '1'
             END IF
          END IF    #No.MOD-610110 add
          CALL p302_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06,  #FUN-8B0035
                       #new[g_i].b_date,q_date,ven_b)
                        new[g_i].b_date,q_date,ven_b,g_i)    #MOD-D70022 add 
       ELSE
          IF sr[i].ima08!='M' AND sr[i].ima08!='X' AND sr[i].ima08!='S' THEN       #MOD-9B0070 add ima08!='S'
             LET g_i=g_i+1
             LET new[g_i].new_part= sr[i].bmb03
             SELECT ima02,ima021 INTO new[g_i].ima02,new[g_i].ima021
               FROM ima_file 
              WHERE ima01=new[g_i].new_part
             LET new[g_i].sfb95= p_key2 #FUN-650193
             LET new[g_i].new_qty = sr[i].bmb06
             LET new[g_i].b_date  = p_date+sr[i].bmb18-
                          (sr[i].ima59+sr[i].ima60/sr[i].ima601*sr[i].bmb06+sr[i].ima61)  #No.FUN-840194 #CHI-810015 mark還原                             
             LET new[g_i].e_date  = q_date
             LET new[g_i].ven_no  = ven_b
             LET new[g_i].new_no  = sr[i].ima111
             LET new[g_i].wo_type  = 1
             LET new[g_i].rid = p_rid  #MOD-D70022 add
             CALL p302_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06,  #FUN-8B0035
                          #new[g_i].b_date,q_date,ven_b)
                           new[g_i].b_date,q_date,ven_b,g_i)    #MOD-D70022 add 
          END IF
       END IF
    END FOR
    message ''
END FUNCTION
 
REPORT p302_rep(l_sfb)
  DEFINE  l_sfb RECORD LIKE sfb_file.*
  DEFINE  l_ima02      LIKE ima_file.ima02    #FUN-510029
  DEFINE  l_ima021     LIKE ima_file.ima021   #FUN-510029
  DEFINE  l_last_sw    STRING                  #NO.TQC-750225
  OUTPUT TOP MARGIN g_top_margin
  LEFT        MARGIN 0
  BOTTOM MARGIN g_bottom_margin
  PAGE        LENGTH g_page_line
  ORDER EXTERNAL BY l_sfb.sfb01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT g_x[10] clipped,k_sfb.sfb01
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1 
    LET l_last_sw = 'N'
    ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01=l_sfb.sfb05
      PRINT COLUMN g_c[31],l_sfb.sfb05,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],cl_numfor(l_sfb.sfb08,34,0),   #NO.TQC-750225
            COLUMN g_c[35],l_sfb.sfb13,
            COLUMN g_c[36],l_sfb.sfb15,
            COLUMN g_c[37],l_sfb.sfb01
 
   ON LAST ROW
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION p302_unit_transfer(p_bmb03,p_ima55,p_bmb10,p_qty)
DEFINE p_bmb03 LIKE bmb_file.bmb03,
       p_ima55 LIKE ima_file.ima55,
       p_bmb10 LIKE bmb_file.bmb10,
       p_qty   LIKE oeb_file.oeb13,        #No.FUN-680121 DEC(18,6)
       l_ret_qty   LIKE oeb_file.oeb13     #No.FUN-680121 DEC(18,6)
 
       IF p_ima55=p_bmb10 THEN RETURN p_qty END IF
 
       SELECT p_qty*(smd04/smd06) INTO l_ret_qty FROM smd_file
        WHERE smd01=p_bmb03 AND smd02=p_ima55 AND smd03=p_bmb10
       IF NOT STATUS THEN RETURN l_ret_qty END IF
       
       SELECT p_qty*(smd06/smd04) INTO l_ret_qty FROM smd_file
        WHERE smd01=p_bmb03 AND smd02=p_bmb10 AND smd03=p_ima55
       IF NOT STATUS THEN RETURN l_ret_qty END IF
 
       SELECT p_qty*(smc03/smc04) INTO l_ret_qty FROM smc_file
        WHERE smc01=p_ima55
          AND smc02=p_bmb10
          AND smcacti='Y'   #NO:4757
       IF NOT STATUS THEN RETURN l_ret_qty END IF
       
       SELECT p_qty*(smc04/smc03) INTO l_ret_qty FROM smc_file
        WHERE smc02=p_ima55 
          AND smc01=p_bmb10
          AND smcacti='Y'   #NO:4757
       IF NOT STATUS THEN RETURN l_ret_qty END IF
 
       RETURN p_qty
END FUNCTION
   
FUNCTION data_back()
      LET k_sfb.sfb01 = v_sfb.sfb01
      LET k_sfb.sfb02 = v_sfb.sfb02
      LET k_sfb.sfb05 = v_sfb.sfb05
      LET k_sfb.sfb06 = v_sfb.sfb06
      LET k_sfb.sfb08 = v_sfb.sfb08
      LET k_sfb.sfb071 = v_sfb.sfb071
      LET k_sfb.sfb08  = v_sfb.sfb08
      LET k_sfb.sfb13  = v_sfb.sfb13
      LET k_sfb.sfb15  = v_sfb.sfb15
END FUNCTION
   
FUNCTION data_move()
      LET v_sfb.sfb01 = k_sfb.sfb01
      LET v_sfb.sfb02 = k_sfb.sfb02
      LET v_sfb.sfb05 = k_sfb.sfb05
      LET v_sfb.sfb06 = k_sfb.sfb06
      LET v_sfb.sfb08 = k_sfb.sfb08
      LET v_sfb.sfb071 = k_sfb.sfb071
      LET v_sfb.sfb08  = k_sfb.sfb08
      LET v_sfb.sfb13  = k_sfb.sfb13
      LET v_sfb.sfb15  = k_sfb.sfb15
END FUNCTION
--------------------------------------
FUNCTION i302_crrut()
  DEFINE l_ecb RECORD LIKE ecb_file.*
  DEFINE l_ima571     LIKE ima_file.ima571
 
  IF not cl_null(k_sfb.sfb06) THEN
       #-->檢查製程追蹤產生否
       SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE ecm01=k_sfb.sfb01 
         IF g_cnt > 0 THEN
            DELETE FROM ecm_file WHERE ecm01=k_sfb.sfb01
            IF SQLCA.sqlerrd[3]=0 THEN
               LET g_success = 'N'
               CALL cl_err3("del","ecm_file",k_sfb.sfb01,"","asf-386","","",0)    #No.FUN-660128
               RETURN
            END IF  
         END IF
        LET l_ima571 = NULL
        SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01 = k_sfb.sfb05
       IF l_ima571 IS NULL THEN LET l_ima571 = ' ' END IF 
       SELECT ecu01 FROM ecu_file
       WHERE ecu01=l_ima571 AND ecu02=k_sfb.sfb06
         AND ecuacti = 'Y'  #CHI-C90006
       IF STATUS THEN
          SELECT ecu01 FROM ecu_file
           WHERE ecu01=k_sfb.sfb05
             AND ecu02=k_sfb.sfb06
             AND ecuacti = 'Y'  #CHI-C90006
          IF STATUS THEN
             CALL cl_err3("sel","ecu_file",k_sfb.sfb05,k_sfb.sfb06,STATUS,"","sel ecu:",0)    #No.FUN-660128
             RETURN
          ELSE
             LET g_ecu01=k_sfb.sfb05
          END IF
       ELSE
          LET g_ecu01=l_ima571
       END IF
       #------------------------
       #-->推開工/完工日期
       CALL s_asf_schdat1(0,k_sfb.sfb13,k_sfb.sfb15,k_sfb.sfb071,k_sfb.sfb01,
                  k_sfb.sfb06,k_sfb.sfb02,g_ecu01,k_sfb.sfb08 ,2)
          RETURNING g_cnt,k_sfb.sfb13,k_sfb.sfb15,k_sfb.sfb32,k_sfb.sfb24
       IF g_cnt < 0 THEN 
          CALL cl_err(k_sfb.sfb13,'mfg5076',0)
          LET g_success = 'N' RETURN 
       END IF
       DISPLAY BY NAME k_sfb.sfb13,k_sfb.sfb15,k_sfb.sfb24
       SELECT count(*) INTO g_cnt FROM ecm_file WHERE ecm01 = k_sfb.sfb01
                                               AND ecm03 <> 9999
       IF g_cnt > 0 THEN LET k_sfb.sfb24 = 'Y' ELSE LET k_sfb.sfb24 = 'N' END IF
 
       SELECT count(*) into g_cnt from sfb_file
        WHERE sfb01=k_sfb.sfb01                    #No.TQC-9A0130 mod
          AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )
       IF g_cnt > 0 THEN
          UPDATE sfb_file SET sfb24=k_sfb.sfb24 WHERE sfb01=k_sfb.sfb01
          SELECT sfb13,sfb15 INTO k_sfb.sfb13,k_sfb.sfb15 FROM sfb_file
                WHERE sfb01=k_sfb.sfb01
          DISPLAY BY NAME k_sfb.sfb13,k_sfb.sfb15,k_sfb.sfb24
       ELSE
          UPDATE sfb_file SET sfb15=k_sfb.sfb15, #預計完工日期 
                              sfb24=k_sfb.sfb24  #製程追蹤檔產生否
                        WHERE sfb01=k_sfb.sfb01
       END IF
  END IF
END FUNCTION
   
FUNCTION i302_firm1(g_sfb)
   DEFINE g_sfb RECORD LIKE sfb_file.* ,
          g_buf   LIKE ima_file.ima34         #No.FUN-680121 VARCHAR(10)
   DEFINE l_ecm03 LIKE ecm_file.ecm03   #No.B524
  DEFINE l_ima55 LIKE ima_file.ima55 
  DEFINE l_ecm57 LIKE ecm_file.ecm57 
  DEFINE l_flag   LIKE type_file.num5            #No.FUN-680121 SMALLINT
  DEFINE l_factor LIKE ima_file.ima31_fac        #No.FUN-680121 DEC(16,8)
 
   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_sfb.sfb01
   #無製程不可確認
#No:8049 add check sfb93 製程否= 'Y'
   IF g_sfb.sfb93 = 'Y' AND g_sfb.sfb24='N' THEN
      CALL cl_err('','asf-326',0)
      RETURN
   END IF
 
   IF g_sfb.sfb87='Y' THEN RETURN END IF
 
     UPDATE sfb_file SET sfb87 = 'Y',sfb43 = '1' WHERE sfb01=g_sfb.sfb01  #FUN-B60116 add sfb43
     IF SQLCA.sqlerrd[3]=0 THEN LET g_success='N' END IF
     #=========================================================
     #第一站投入量[ecm301]改在工單確認時才掛上
     IF g_sfb.sfb24='Y' THEN
        LET l_ecm03=0
        SELECT MIN(ecm03) INTO l_ecm03
          FROM ecm_file
         WHERE ecm01=g_sfb.sfb01
        IF STATUS THEN LET l_ecm03=0 END IF
 
        #---------------- 單位換算
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=g_sfb.sfb05
        IF STATUS THEN LET l_ima55=' ' END IF
#FUN-A60027 -----------mark start------------------------
#       SELECT ecm57 INTO l_ecm57 FROM ecm_file WHERE ecm01=g_sfb.sfb01
#                                                 AND ecm03=l_ecm03
#       IF STATUS THEN LET l_ecm57=' ' END IF
#       CALL s_umfchk(g_sfb.sfb05,l_ima55,l_ecm57)
#            RETURNING l_flag,l_factor     
#       IF l_flag=1 THEN
#          CALL cl_err('ima55/ecm57: ','abm-731',1)
#          LET g_success ='N' RETURN 
#       END IF
#       #----------------
#       UPDATE ecm_file SET ecm301=g_sfb.sfb08*l_factor
#        WHERE ecm01=g_sfb.sfb01
#          AND ecm03=l_ecm03
#       IF STATUS THEN 
#          CALL cl_err3("upd","ecm_file",g_sfb.sfb01,l_ecm03,STATUS,"","upd ecm301",0)    #No.FUN-660128
#          LET g_success='N'   
#       END IF
#FUN-A60027 -------mark  end-------------------------
     END IF
 
     IF g_sma.sma27 MATCHES '[13]' AND g_sfb.sfb23='Y' AND g_sfb.sfb04='1'
     THEN UPDATE sfb_file SET sfb04 = '2' WHERE sfb01=g_sfb.sfb01 #MOD-640300
          LET k_sfb.sfb04 ='2' #MOD-640300
          CALL i302_sfb04(g_sfb.sfb04) RETURNING g_buf
          DISPLAY g_buf TO sfb04_d
     END IF
     IF g_success='Y' THEN
        LET g_sfb.sfb87 ='Y'
     ELSE
        LET g_sfb.sfb87 ='N'
     END IF
END FUNCTION
 
FUNCTION i302_sfb04(p_sfb04)
    DEFINE p_sfb04      LIKE type_file.num5         #No.FUN-680121  SMALLINT
    DEFINE l_str        LIKE ima_file.ima34         #No.FUN-680121  VARCHAR(10)
 
     CASE WHEN p_sfb04 ='1' LET l_str=g_x[5] CLIPPED
          WHEN p_sfb04 ='2' LET l_str=g_x[6] CLIPPED
          WHEN p_sfb04 ='3' LET l_str=g_x[7] CLIPPED
          WHEN p_sfb04 ='4' LET l_str=g_x[8] CLIPPED
          WHEN p_sfb04 ='5' LET l_str=g_x[9] CLIPPED
          WHEN p_sfb04 ='6' LET l_str=g_x[10] CLIPPED
          WHEN p_sfb04 ='7' LET l_str=g_x[11] CLIPPED
          WHEN p_sfb04 ='8' LET l_str=g_x[12] CLIPPED
     END CASE
    RETURN l_str
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#TQC-C40168--add--str--
FUNCTION p302_bom_chk()
DEFINE   l_cnt        LIKE type_file.num10

   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM bma_file
    WHERE bma01=k_sfb.sfb05 AND bmaacti='Y'
   IF l_cnt =0 THEN
      CALL cl_err(k_sfb.sfb05,'abm-742',0)
      RETURN FALSE
   ELSE
      LET l_cnt =0 
      SELECT COUNT(*) INTO l_cnt FROM bma_file
      #WHERE (bma05 IS NULL OR bma05 >k_sfb.sfb071)  #MOD-CA0114 mark
       WHERE  bma05 <= k_sfb.sfb071                  #MOD-CA0114
         AND bma01 = k_sfb.sfb05 
      IF l_cnt =0 THEN                               #MOD-CA0114 mod
         CALL cl_err(k_sfb.sfb05,'abm-005',0)
         RETURN FALSE
      END IF
   END IF
   
   RETURN TRUE
END FUNCTION
#TQC-C40168--add--end--
