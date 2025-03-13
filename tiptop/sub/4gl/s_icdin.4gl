# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: s_icdin.4gl   
# Descriptions...: 刻號/BIN入庫明細資料維護作業
# SYNTAX.........: s_icdin(p_ida28,p_ida01,p_ida02,
#                          p_ida03,p_ida04,p_ida13,
#                          p_tot,p_ida07,p_ida08,
#                          p_ida09,p_ida15,p_ida14,
#                          p_no,p_item) 
# Input parameter: 
##               : p_ida28 1：入  2：其它
##               : p_ida01 料件編號
##               : p_ida02 倉庫
##               : p_ida03 儲位 
##               : p_ida04 批號
##               : p_ida13 單位
##               : p_tot   數量
##               : p_ida07 單據編號
##               : p_ida08 單據項次
##               : p_ida09 單據日期
##               : p_ida15 母批
##               : p_ida14 母體編號
##               : p_no       原始單據
##               : p_item     原始單據項次
# Date & Author..: NO.FUN-7B0016 07/12/3 By ve007
# Modify.........: No.FUN-810038 08/01/25 By kim GP5.1 ICD
# Modify.........: No.FUN-830073 08/03/20 BY ve007    
# Modify.........: No.CHI-830032 08/03/28 By kim GP5.1整合測試修改
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-9A0009 09/10/06 By Smapmin 母批欄位改為不控管一定要輸入
# Modify.........: No.FUN-A20012 10/02/08 By chenls 对Yield(ida18)的控管
# Modify.........: No:MOD-A30138 10/04/02 By Summer 匯出excel功能修正
# Modify.........: No.FUN-B30192 11/05/09 By shenyang       改icb05為imaicd14 
# Modify.........: No.FUN-B30187 11/07/06 By jason 增加母批開窗
# Modify.........: No.FUN-B30110 11/07/13 By jason 加入"料件BIN"和"群組BIN"兩個action、YIELD(%)=DIE數/GROSS DIE 
# Modify.........: No.FUN-B30182 11/09/13 By jason 刻號﹧BIN入庫單身的BIN值要用挑的，多選後再帶出來
# Modify.........: No.FUN-BA0008 11/10/11 By jason die更新
# Modify.........: No.FUN-BA0059 11/10/17 By jason 片數為0但die數大於0時,要給0.001
# Modify.........: No.TQC-BA0136 11/10/25 By jason 存檔前判斷如果片數為null給0
# Modify.........: No.FUN-BA0107 11/11/09 By jason 母批default=第一筆的母批資料
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0084 11/12/20 By lixh1 增加數量欄位小數取位
# Modify.........: No.MOD-C30459 12/03/12 By bart 人工輸入入庫的刻號時，自動補成3位數
# Modify.........: No.MOD-C30405 12/03/14 By bart 未測wafer的錯誤訊息顯示問題
# Modify.........: No.FUN-C30302 12/04/13 By bart 刻號/BIN數量不等於單據數量時,詢問是否回寫
# Modify.........: No.TQC-C50062 12/05/08 By Sarah CP的片數應該是ida10+ida11
# Modify.........: No.TQC-C60011 12/06/04 By bart 當料號有做刻號/BIN管理或Datecode管理,且料件狀態為IC(3.未測IC或4.已測IC),進入「刻號/BIN明細維護」畫面刻號預設值帶000
# Modify.........: No.TQC-C60023 12/06/05 By bart 已測wafer,開啟刻號/BIN入庫畫面後,當進入BIN欄位的開窗,要彈出一個窗詢問要產生的刻號起迄,然後依照勾選的BIN值產生資料
# Modify.........: No.TQC-C60020 12/06/13 By bart 維護datecode
# Modify.........: No.TQC-C60184 12/06/26 By bart 離開畫面時都要詢問是否回寫
# Modify.........: No.TQC-C60186 12/06/26 By bart 預設數量
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-C90137 12/10/11 By Elise 將MOD-C30459修改段改為自動給2碼
# Modify.........: No:MOD-D30216 13/03/25 By bart CALL cl_err('p_ida01','sub-170',1) 的地方，改抓ida01的欄位名稱顯示
# Modify.........: No:MOD-D40155 13/04/22 By bart 將MOD-C90137修改段改為自動給3碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ida_lock RECORD LIKE ida_file.*   # FOR LOCK CURSOR TOUCH 
DEFINE g_ida_h RECORD 
                    ida01 LIKE ida_file.ida01,      #料件編號
                    ida02 LIKE ida_file.ida02,      #倉庫別
                    ida03 LIKE ida_file.ida03,      #儲位
                    ida04 LIKE ida_file.ida04,      #批號
                    ida07 LIKE ida_file.ida07,      #單據編號
                    ida08 LIKE ida_file.ida08,      #單據項次
                    ida13 LIKE ida_file.ida13,      #單位
                    tot   LIKE ida_file.ida10,      
                    tot_b LIKE ida_file.ida10,
                    odds  LIKE ida_file.ida10,
                    ima02 LIKE ima_file.ima02,
                    ima021 LIKE ima_file.ima021,
                    ida09 LIKE ida_file.ida09,      #異動日期
                    ida15 LIKE ida_file.ida15,      #母批
                    ida28 LIKE ida_file.ida28,      #異動別
                  # icb05 LIKE icb_file.icb05       #FUN-B30192
                    imaicd14 LIKE imaicd_file.imaicd14  #FUN-B30192
               END RECORD
DEFINE b_ida   RECORD LIKE ida_file.* 
DEFINE g_ida   DYNAMIC ARRAY of RECORD       
                    ida05 LIKE ida_file.ida05,    #刻號
                    ida06 LIKE ida_file.ida06,    #BIN
                    ida21 LIKE ida_file.ida21,    #pass bin
                    ida10 LIKE ida_file.ida10,    #實收數量
                    ida11 LIKE ida_file.ida11,    #不良數量
                    ida12 LIKE ida_file.ida12,    #報廢數量
                    ida14 LIKE ida_file.ida14,    #母體料號
                    ida15 LIKE ida_file.ida15,    #母批
                    ida17 LIKE ida_file.ida17,    #DIE數
                    ida16 LIKE ida_file.ida16,    #DATECODE
                    ida18 LIKE ida_file.ida18,    #YIELD
                    ida19 LIKE ida_file.ida19,    #TEST
                    ida20 LIKE ida_file.ida20,    #DEDUCT
                    ida22 LIKE ida_file.ida22,    #接單料號
                    ida26 LIKE ida_file.ida26,    #入庫否
                    ida27 LIKE ida_file.ida27,    #轉入否
                    ida29 LIKE ida_file.ida29     #備注
                END RECORD,
       g_ida_t RECORD         #程序變量備份值
                    ida05 LIKE ida_file.ida05,
                    ida06 LIKE ida_file.ida06,
                    ida21 LIKE ida_file.ida21,
                    ida10 LIKE ida_file.ida10,
                    ida11 LIKE ida_file.ida11,
                    ida12 LIKE ida_file.ida12,
                    ida14 LIKE ida_file.ida14,
                    ida15 LIKE ida_file.ida15,
                    ida17 LIKE ida_file.ida17,
                    ida16 LIKE ida_file.ida16,
                    ida18 LIKE ida_file.ida18,
                    ida19 LIKE ida_file.ida19,
                    ida20 LIKE ida_file.ida20,
                    ida22 LIKE ida_file.ida22,
                    ida26 LIKE ida_file.ida26, 
                    ida27 LIKE ida_file.ida27,
                    ida29 LIKE ida_file.ida29
                END RECORD,
       g_ida_o RECORD          #程序變量舊值       
                    ida05 LIKE ida_file.ida05,
                    ida06 LIKE ida_file.ida06,
                    ida21 LIKE ida_file.ida21,
                    ida10 LIKE ida_file.ida10,
                    ida11 LIKE ida_file.ida11,
                    ida12 LIKE ida_file.ida12,
                    ida14 LIKE ida_file.ida14,
                    ida15 LIKE ida_file.ida15,
                    ida17 LIKE ida_file.ida17,
                    ida16 LIKE ida_file.ida16,
                    ida18 LIKE ida_file.ida18,
                    ida19 LIKE ida_file.ida19,
                    ida20 LIKE ida_file.ida20,
                    ida22 LIKE ida_file.ida22,
                    ida26 LIKE ida_file.ida26, 
                    ida27 LIKE ida_file.ida27,
                    ida29 LIKE ida_file.ida29
               END RECORD
DEFINE   g_imaicd04   LIKE imaicd_file.imaicd04
DEFINE   g_imaicd08   LIKE imaicd_file.imaicd08 #FUN-BA0051
DEFINE   g_imaicd09   LIKE imaicd_file.imaicd09 #FUN-BA0051
#DEFINE   g_icb05      LIKE icb_file.icb05    #FUN-B30192
DEFINE   g_imaicd14   LIKE imaicd_file.imaicd14 #FUN-B30192
DEFINE   g_imaicd01   LIKE imaicd_file.imaicd01
DEFINE   g_pmniicd15  LIKE pmni_file.pmniicd15,
         g_rec_b      LIKE type_file.num5,           #單身變數
	 l_sum        LIKE ida_file.ida17,           #秀單身IDE數總和
         l_ac         LIKE type_file.num5            #目前處理的ARRAY CNT
DEFINE   g_cnt                 LIKE type_file.num5   
DEFINE   g_flag                LIKE type_file.num5   
DEFINE   g_msg                 LIKE type_file.chr10
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_no         LIKE ida_file.ida07,      #原始單據
         g_item       LIKE ida_file.ida08,      #原始單據項次
         g_open       LIKE type_file.chr1       #開窗挑選否
DEFINE   g_ida17      LIKE ida_file.ida17       #回傳值
DEFINE   g_idd13      LIKE idd_file.idd13    
DEFINE   g_rvbiicd08  LIKE rvbi_file.rvbiicd08   #datecode 
DEFINE   g_never      LIKE type_file.chr1 
DEFINE   g_wono       LIKE type_file.chr50      #工單單號 #FUN-B30187 
DEFINE   g_multi_flag LIKE TYPE_file.num5       #自動產生單身 #FUN-B30182
DEFINE   l_r          LIKE type_file.chr1       #FUN-C30302
DEFINE   g_ida11      LIKE ida_file.ida11       #TQC-C50062 add
DEFINE   g_numf       LIKE type_file.num5       #TQC-C60023
DEFINE   g_numt       LIKE type_file.num5       #TQC-C60023
 
FUNCTION s_icdin(p_ida28,p_ida01,p_ida02,p_ida03,
                 p_ida04,p_ida13,p_tot,p_ida07,
                 p_ida08,p_ida09,p_ida15,
                 p_ida14,p_no,p_item)
   DEFINE p_row,p_col  LIKE type_file.num5
   DEFINE p_ida28      LIKE ida_file.ida28, 
          p_ida01      LIKE ida_file.ida01, 
          p_ida02      LIKE ida_file.ida02,  
          p_ida03      LIKE ida_file.ida03, 
          p_ida04      LIKE ida_file.ida04,
          p_ida13      LIKE ida_file.ida13, 
          p_tot        LIKE ida_file.ida10, 
          p_ida07      LIKE ida_file.ida07, 
          p_ida08      LIKE ida_file.ida08, 
          p_ida09      LIKE ida_file.ida09,
          p_ida15      LIKE ida_file.ida15, 
          p_ida14      LIKE ida_file.ida14,
          p_no         LIKE ida_file.ida07, 
          p_item       LIKE ida_file.ida08 
   DEFINE l_msg        STRING  #MOD-D30216
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_flag = 1
   LET g_imaicd04 = NULL   
#  LET g_icb05 = NULL      #GROSS DIE   #FUN-B30192
   LET g_imaicd14 =NULL    #FUN-B30192
   LET g_imaicd01 = NULL   #母體編號
   LET g_pmniicd15 = NULL  #接單料號
 
   IF cl_null(p_ida03) THEN LET p_ida03 = ' ' END IF
   IF cl_null(p_ida04) THEN LET p_ida04 = ' ' END IF
   #1. chk傳入參數，除了母批，儲位，批號外，其它若為NULL則RETURN
       IF cl_null(p_ida01) THEN
          #CALL cl_err('p_ida01','sub-170',1) #MOD-D30216
          LET l_msg = cl_get_feldname('ida01',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida02) THEN
          #CALL cl_err('p_ida02','sub-170',1) #MOD-D30216
          LET l_msg = cl_get_feldname('ida01',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida13) THEN 
          #CALL cl_err('p_ida13','sub-170',1) #MOD-D30216
          LET l_msg = cl_get_feldname('ida13',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_tot) THEN
          #CALL cl_err('p_tot','sub-170',1) #MOD-D30216
          LET l_msg = cl_get_feldname('ida10',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida07) THEN
          #CALL cl_err('p_ida07','sub-170',1)  #MOD-D30216
          LET l_msg = cl_get_feldname('ida07',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida08) THEN
          #CALL cl_err('p_ida08','sub-170',1)  #MOD-D30216
          LET l_msg = cl_get_feldname('ida08',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida09) THEN
          #CALL cl_err('p_ida09','sub-170',1)  #MOD-D30216
          LET l_msg = cl_get_feldname('ida09',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF cl_null(p_ida28) THEN
          #CALL cl_err('p_ida28','sub-170',1)  #MOD-D30216
          LET l_msg = cl_get_feldname('ida28',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
 
      #若原始單號或原始單項次有值，則原始單號，原始項次都必須有值
       IF NOT cl_null(p_no) OR NOT cl_null(p_item) THEN
          IF cl_null(p_no) THEN
             #CALL cl_err('p_no','sub-170',1)  #MOD-D30216
             LET l_msg = cl_get_feldname('ida07',g_lang) #MOD-D30216
             CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
             RETURN 0,"N",0  #FUN-C30302
          END IF
          IF cl_null(p_item) THEN
             #CALL cl_err('p_item','sub-170',1)  #MOD-D30216
             LET l_msg = cl_get_feldname('ida08',g_lang)
             CALL cl_err(l_msg,'sub-170',1)  #MOD-D30216
             RETURN 0,"N",0  #FUN-C30302
          END IF
          LET g_no = p_no
          LET g_item = p_item
       END IF
      
   #2. CHK傳入參數合理性
       IF p_tot < 0 THEN
          #CALL cl_err('p_tot','afa-043',1)  #MOD-D30216
          LET l_msg = cl_get_feldname('ida10',g_lang) #MOD-D30216
          CALL cl_err(l_msg,'afa-043',1) #MOD-D30216
          RETURN 0,"N",0  #FUN-C30302
       END IF
 
   # 檢查同單號項次的料，倉，儲，批相同否(只要有一筆不同即RETURN)
       LET g_cnt = 0 
       SELECT COUNT(*) INTO g_cnt FROM ida_file
        WHERE ida07 = p_ida07
          AND ida08 = p_ida08
          AND (ida01 <> p_ida01 OR
               ida02 <> p_ida02 OR
               ida03 <> p_ida03 OR
               ida04 <> p_ida04)
 
       IF g_cnt > 0 THEN
          LET g_msg = '[',p_ida01 CLIPPED,']',
                      '[',p_ida02 CLIPPED,']',
                      '[',p_ida03 CLIPPED,']',
                      '[',p_ida04 CLIPPED,']'
          CALL cl_err(g_msg,'sub-177',1)
          RETURN 0,"N",0  #FUN-C30302
       END IF
       IF p_ida28 NOT MATCHES '[01]' THEN
          LET g_msg = 'p_ida28 NOT MATCHES [01]'
          CALL cl_err(g_msg,'!',1)
          RETURN 0,"N",0  #FUN-C30302
       END IF
     
     #3. CHK傳入料號的imaicd08='Y'，才可往下執行，否則RETURN  
       LET g_cnt = 0
       #FUN-BA0051 --START mark--
       #SELECT COUNT(*) INTO g_cnt FROM imaicd_file 
       # WHERE imaicd00 = p_ida01 AND imaicd08 = 'Y'
       #IF g_cnt = 0 THEN
       #FUN-BA0051 --END mark-- 
       IF NOT s_icdbin(p_ida01) THEN   #FUN-BA0051  
          CALL cl_err(p_ida01,'sub-175',1)
          RETURN 0,"N",0  #FUN-C30302
       END IF
  
     #4. LOCK 單頭   
       LET g_forupd_sql = "SELECT * from ida_file ",
                          " WHERE ida01 = ? ",
                          "   AND ida02 = ? ",
                          "   AND ida03 = ? ",
                          "   AND ida04 = ? ",
                          "   AND ida07 = ? ",
                          "   AND ida08 = ? ",
                          " FOR UPDATE  "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE s_icdin_lock_u CURSOR FROM g_forupd_sql
     
     #5. DEFAULT單頭資料(包含備份傳入參數資料)
       INITIALIZE g_ida_h.* TO NULL 
       LET g_ida_h.ida07 = p_ida07 
       LET g_ida_h.ida01 = p_ida01 
       LET g_ida_h.ida02 = p_ida02 
       LET g_ida_h.ida13 = p_ida13 
       LET g_ida_h.ida08 = p_ida08 
       LET g_ida_h.ida03 = p_ida03 
       LET g_ida_h.ida04 = p_ida04 
       LET g_ida_h.tot_b = 0
       LET g_ida_h.odds  = 0
       LET g_ida_h.tot   = p_tot
       IF cl_null(g_ida_h.ida03) THEN 
          LET g_ida_h.ida03 = ' '
       END IF
       IF cl_null(g_ida_h.ida04) THEN 
          LET g_ida_h.ida04 = ' '
       END IF
       SELECT ima02,ima021,imaicd01,imaicd04,imaicd08,imaicd09   #FUN-BA0051 add imaicd08,09
         INTO g_ida_h.ima02,g_ida_h.ima021,
              g_imaicd01,g_imaicd04,g_imaicd08,g_imaicd09        #FUN-BA0051 add imaicd08,09
         FROM ima_file,imaicd_file  #FUN-810038
        WHERE ima01 = p_ida01
          AND ima01=imaicd00   #FUN-810038
       IF SQLCA.SQLCODE THEN
          CALL cl_err('sel ima',SQLCA.SQLCODE,1)
          RETURN 0,"N",0  #FUN-C30302
       END IF
       
       IF NOT cl_null(p_ida14) THEN LET g_imaicd01 = p_ida14 END IF
 
       IF cl_null(g_imaicd04) OR cl_null(g_imaicd08) THEN   #FUN-BA0051 add OR cl_null(g_imaicd08)
          CALL cl_err(p_ida01,'sub-178',1)
          RETURN 0,"N",0  #FUN-C30302
       END IF
 
       #取得GROSS DIE 的預設值
    #   LET g_icb05 = NULL
       LET g_imaicd14 =NULL    #FUN-B30192 
     # SELECT icb05 INTO g_icb05 FROM icb_file                  #FUN-B30192--mark
     #    WHERE icb01 = p_ida14  #p_ida01                       #FUN-B30192--mark
       CALL s_icdfun_imaicd14(p_ida01)   RETURNING  g_imaicd14  #FUN-B30192
       LET g_ida_h.ida09 = p_ida09 
       LET g_ida_h.ida15 = p_ida15 
       #FUN-810038................begin
       #如果母批為NULL時,判斷若是未測wafer ,母批=批號
       IF cl_null(g_ida_h.ida15) THEN
          IF g_imaicd04='1' THEN
             LET g_ida_h.ida15= p_ida04
          END IF
       END IF
       #FUN-810038................end
       LET g_ida_h.ida28 = p_ida28
    #  LET g_ida_h.icb05 = g_icb05        #FUN-B30192
       LET g_ida_h.imaicd14 = g_imaicd14  #FUN-B30192   
       #接單料號(ida22)
       #若是收貨單呼叫此程序透過收貨單及項次串到采購單及項次，
       #再抓到采購單單身的 最終料號(pmn15)除此之外存""
       #SELECT DISTINCT(pmniicd15) INTO g_pmniicd15               #FUN-B30187 mark
       SELECT DISTINCT(pmniicd15),rvb34 INTO g_pmniicd15,g_wono   #FUN-B30187
          FROM pmni_file,rvb_file
         WHERE rvb04 = pmni01           #采購單號
           AND rvb03 = pmni02           #采購項次
           AND rvb01 = p_ida07         #收貨單號
           AND rvb02 = p_ida08         #收貨項次
       IF SQLCA.SQLCODE THEN
          LET g_pmniicd15 = ''
       END IF
       #TQC-C60020---begin
       IF g_prog = 'aimt302_icd' OR g_prog = 'aimt312_icd' THEN
          SELECT inbiicd028 INTO g_rvbiicd08
            FROM inbi_file 
           WHERE inbi01 = p_ida07
             AND inbi03 = p_ida08
       END IF 
       IF g_prog = 'aimt306_icd' THEN
          SELECT impiicd028 INTO g_rvbiicd08
            FROM impi_file 
           WHERE impi01 = p_ida07
             AND impi02 = p_ida08
       END IF 
       IF g_prog = 'asft620_icd' THEN
          SELECT sfviicd028 INTO g_rvbiicd08
            FROM sfvi_file 
           WHERE sfvi01 = p_ida07
             AND sfvi03 = p_ida08
       END IF 
       IF g_prog = 'axmt700_icd' OR g_prog = 'axmt840_icd' THEN
          SELECT ohbiicd028 INTO g_rvbiicd08
            FROM ohbi_file 
           WHERE ohbi01 = p_ida07
             AND ohbi03 = p_ida08
       END IF 
       IF g_prog = 'apmt200_icd' OR g_prog = 'apmt110_icd' THEN 
       #TQC-C60020---end
          SELECT rvbiicd08 INTO g_rvbiicd08
            FROM rvbi_file
	         WHERE rvbi01 = p_ida07       #收貨單號
             AND rvbi02 = p_ida08       #收貨項次
       END IF  #TQC-C60020
 
       OPEN WINDOW s_icdin_w AT 10,20 WITH FORM "sub/42f/s_icdin"
            ATTRIBUTE(STYLE=g_win_style CLIPPED)
       CALL cl_ui_locale("s_icdin")
 
      #7. 處理單頭單位換算,數量資料
       CALL s_icdin_process_h()
       IF NOT g_flag THEN 
          CLOSE WINDOW s_icdin_w #CHI-830032
          RETURN 0,"N",0  #FUN-C30302 
       END IF
 
      #8. 取單身/insert 單身
      #若有傳入原始單號，項次，則依idd資料產生
       IF NOT cl_null(p_no) AND NOT cl_null(p_item) THEN
          CALL s_icdin_process_b2()
       ELSE
          CALL s_icdin_process_b()
       END IF
 
       IF NOT g_flag THEN 
          CLOSE WINDOW s_icdin_w #CHI-830032
          RETURN 0,"N",0  #FUN-C30302
       END IF
       
      #9. show單頭資料/進MENU
       DISPLAY BY NAME g_ida_h.ida01,g_ida_h.ida02,
                       g_ida_h.ida03,g_ida_h.ida04,
                       g_ida_h.ida07,g_ida_h.ida08,
                       g_ida_h.ida13,g_ida_h.tot,
                       g_ida_h.tot_b,g_ida_h.odds,
                       g_ida_h.ima02,g_ida_h.ima021,
                     # g_ida_h.icb05    #FUN-B30192
                       g_ida_h.imaicd14 #FUN-B30192
       DISPLAY 1       TO FORMONLY.cnt
       DISPLAY g_rec_b TO FORMONLY.cn2
 
       CALL s_icdin_DIE() RETURNING l_sum    #顯示單身DIE 數
       DISPLAY l_sum TO FORMONLY.sum1
 
       CALL s_icdin_menu()
 
      #10. 結束畫面/回復 INT_FLAG/回復結果
       CLOSE WINDOW s_icdin_w  
      #LET INT_FLAG = 0 #CHI-830032 mark
 
 
       CALL s_icdin_DIE() RETURNING g_ida17
       RETURN g_ida17,l_r,g_ida_h.tot_b   #FUN-C30302
      
END FUNCTION
 
FUNCTION s_icdin_menu()
DEFINE w ui.Window       #MOD-A30138 add
DEFINE f ui.Form         #MOD-A30138 add
DEFINE page om.DomNode   #MOD-A30138 add


    WHILE TRUE
      CALL s_icdin_bp("G")
      CASE g_action_choice
           WHEN "detail"
                 CALL s_icdin_b()
           WHEN "help"
                 CALL cl_show_help()
           WHEN "exit"
                 #CALL s_icdin_calc_die()   #FUN-BA0008    #TQC-C60186
                 #FUN-C30302---begin
                 #IF g_ida_h.tot <> g_ida_h.tot_b THEN  #TQC-C60184
                    IF cl_confirm('aic-328') THEN
                       LET l_r = "Y"
                    ELSE
                       LET l_r = "N"
                    END IF 
                 #END IF #TQC-C60184
                 #FUN-C30302---end
                 EXIT WHILE
           WHEN "controlg"
                 CALL cl_cmdask()
           WHEN "exporttoexcel"
               #str MOD-A30138 mod
               #CALL cl_export_to_excel(ui.Interface.getRootNode(),
               #                        base.TypeInfo.create(g_ida),'','')
                LET w = ui.Window.getCurrent()
                LET f = w.getForm()
                LET page = f.FindNode("Table","s_ida")
                CALL cl_export_to_excel(page,base.TypeInfo.create(g_ida),'','')
               #end MOD-A30138 mod
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION s_icdin_bp(p_ud)
    DEFINE p_ud   LIKE type_file.chr1
    DEFINE l_cnt  LIKE type_file.num5  
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN RETURN END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel",FALSE)
 
  
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM rvb_file
       WHERE rvb01 = g_ida_h.ida07
         AND rvb02 = g_ida_h.ida08 
    IF l_cnt = 0 THEN
       CALL cl_set_comp_visible("ida26",FALSE)
    ELSE
       CALL cl_set_comp_visible("ida26",TRUE)     
    END IF
 
    CALL SET_COUNT(g_rec_b)
 
    DISPLAY ARRAY g_ida TO s_ida.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting(1,1)
       BEFORE ROW 
          LET l_ac = ARR_CURR()
       ON ACTION detail
          LET g_action_choice = "detail"
          LET l_ac = 1
          EXIT DISPLAY
       ON ACTION help
          LET g_action_choice = "help"
          EXIT DISPLAY
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice = "controlg"
          EXIT DISPLAY
       ON ACTION accept
          LET g_action_choice = "detail"
          LET l_ac = ARR_CURR()
          EXIT DISPLAY
       ON ACTION cancel
          LET INT_FLAG = FALSE
          LET g_action_choice = "exit"
          EXIT DISPLAY
       ON ACTION exporttoexcel
          LET g_action_choice = 'exporttoexcel'
          EXIT DISPLAY
       ON ACTION about
          CALL cl_about()
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
# 處理單頭單位換算，數量資料
FUNCTION s_icdin_process_h()
   DEFINE l_ida13      LIKE ida_file.ida13,
          l_factor     LIKE img_file.img21
     #1. 清空資料
       CALL g_ida.clear()
       INITIALIZE g_ida_o.* TO NULL 
       INITIALIZE g_ida_t.* TO NULL 
 
     #2. 取得img 單位，轉換成數量
       LET l_factor = 1
       SELECT img09 INTO l_ida13 FROM img_file
        WHERE img01 = g_ida_h.ida01
          AND img02 = g_ida_h.ida02
          AND img03 = g_ida_h.ida03
          AND img04 = g_ida_h.ida04
 
       IF SQLCA.sqlcode = 100 THEN  # 無img_file 資料  
          LET g_msg = '[',g_ida_h.ida01 CLIPPED,']',
                      '[',g_ida_h.ida02 CLIPPED,']',
                      '[',g_ida_h.ida03 CLIPPED,']',
                      '[',g_ida_h.ida04 CLIPPED,']'
          CALL cl_err(g_msg,'mfg6069',1)
          LET g_flag = 0
          RETURN
       END IF
 
       IF NOT cl_null(l_ida13) THEN
          IF l_ida13 <> g_ida_h.ida13 THEN
             CALL s_umfchk(g_ida_h.ida01,g_ida_h.ida13,
                           l_ida13) RETURNING g_cnt,l_factor
             IF g_cnt = 1 THEN
                LET g_msg = g_ida_h.ida13 CLIPPED,'->',
                            l_ida13
                CALL cl_err(g_msg,'aqc-500',1)
                LET  g_flag = 0
                RETURN
             END IF
             #單位轉換
             LET g_ida_h.ida13 = l_ida13
             LET g_ida_h.tot   = g_ida_h.tot * l_factor
          END IF
       END IF
END FUNCTION
# 取單身/INSERT 單身
FUNCTION s_icdin_process_b()
   
   #撈單身
   DECLARE cs_ida_b_cs CURSOR FOR
    SELECT ida05,ida06,ida21,ida10,ida11,ida12,
           ida14,ida15,ida17,ida16,ida18,ida19,
           ida20,ida22,ida26,ida27,ida29
       FROM ida_file
      WHERE ida01 = g_ida_h.ida01
        AND ida02 = g_ida_h.ida02
        AND ida03 = g_ida_h.ida03
        AND ida04 = g_ida_h.ida04
        AND ida07 = g_ida_h.ida07
        AND ida08 = g_ida_h.ida08
      ORDER BY ida05,ida06
 
   LET g_cnt = 1
   CALL g_ida.clear()
   FOREACH cs_ida_b_cs INTO g_ida[g_cnt].*
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_ida.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
   LET g_ida11 = 0   #TQC-C50062 add
   #計算單身數量合g_ida_h.tot_b/差異數量g_ida_h.odds
  #SELECT SUM(ida10) INTO g_ida_h.tot_b FROM ida_file                     #TQC-C50062 mark 
   SELECT SUM(ida10),SUM(ida11) INTO g_ida_h.tot_b,g_ida11 FROM ida_file  #TQC-C50062
    WHERE ida01 = g_ida_h.ida01
      AND ida02 = g_ida_h.ida02
      AND ida03 = g_ida_h.ida03
      AND ida04 = g_ida_h.ida04
      AND ida07 = g_ida_h.ida07
      AND ida08 = g_ida_h.ida08
   IF cl_null(g_ida_h.tot_b) THEN LET g_ida_h.tot_b = 0 END IF
  #str TQC-C50062 add
   IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
   #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
   IF g_imaicd04 = '2' THEN LET g_ida_h.tot_b = g_ida_h.tot_b + g_ida11 END IF
  #end TQC-C50062 add
   LET g_ida_h.odds = g_ida_h.tot - g_ida_h.tot_b
 
   #永遠都沒有機會走單身自動產生段
   LET g_never = 'Y'
   #當單料件(imaicd04) =1 且若單身數量tot < 單據數量 =>自動insert 單身
   IF g_never = 'N' AND 
      NOT cl_null(g_imaicd04) AND g_imaicd04 MATCHES '[01]' THEN
   # 若單據的數量非整數->四舍五入
      CALL cl_digcut(g_ida_h.tot,0) RETURNING g_ida_h.tot
      IF g_ida_h.odds > 0 THEN
         IF g_rec_b = 0 THEN
            CALL s_icdin_g_b(0,'g')
         ELSE
            CALL s_icdin_g_b(g_ida[g_rec_b].ida05,'g')
         END IF
         LET g_cnt = 1
         CALL g_ida.clear()
         FOREACH cs_ida_b_cs INTO g_ida[g_cnt].*
           LET g_cnt = g_cnt + 1
         END FOREACH
         SELECT SUM(ida10) INTO g_ida_h.tot_b FROM ida_file
          WHERE ida01 = g_ida_h.ida01
            AND ida02 = g_ida_h.ida02
            AND ida03 = g_ida_h.ida03
            AND ida04 = g_ida_h.ida04
            AND ida07 = g_ida_h.ida07
            AND ida08 = g_ida_h.ida08
         IF cl_null(g_ida_h.tot_b) THEN LET g_ida_h.tot_b = 0 END IF
         LET g_ida_h.odds = g_ida_h.tot - g_ida_h.tot_b 
         CALL g_ida.deleteElement(g_cnt)
         LET g_rec_b = g_cnt - 1
      END IF
   END IF
 
END FUNCTION
 
#自動產生單身
FUNCTION s_icdin_g_b(p_ida05,p_cmd)
 
   DEFINE p_ida05  LIKE type_file.num5 
   DEFINE l_ida  RECORD LIKE ida_file.*
   DEFINE l_cnt  LIKE type_file.num5  
   DEFINE p_cmd  LIKE type_file.chr1  #b:由單身呼叫 g:自動產生段
                            
   IF cl_null(p_ida05) THEN LET p_ida05 = 0 END IF 
 
   LET l_ida.ida01 = g_ida_h.ida01
   LET l_ida.ida02 = g_ida_h.ida02 
   LET l_ida.ida03 = g_ida_h.ida03
   LET l_ida.ida04 = g_ida_h.ida04 
   LET l_ida.ida06 = 'BIN00' 
   LET l_ida.ida07 = g_ida_h.ida07  
   LET l_ida.ida08 = g_ida_h.ida08   
   LET l_ida.ida09 = g_ida_h.ida09   
   LET l_ida.ida10 = 1              
   LET l_ida.ida11 = 0 
   LET l_ida.ida12 = 0 
   LET l_ida.ida13 = g_ida_h.ida13
   LET l_ida.ida14 = g_imaicd01
   LET l_ida.ida15 = g_ida_h.ida15 
   LET l_ida.ida16 = ''
 
#  LET l_ida.ida17 = g_ida_h.icb05     #FUN-B30192
   LET l_ida.ida17 = g_ida_h.imaicd14  #FUN-B30192 
#FUN-A20012 ---BEGIN                                                            
#   LET l_ida.ida18 = ''                                                        
   IF NOT cl_null(l_ida.ida10) AND NOT cl_null(l_ida.ida11)                     
      AND NOT cl_null(l_ida.ida12) THEN                                         
      LET l_ida.ida18 = (l_ida.ida11 + l_ida.ida12) / l_ida.ida10               
      LET l_ida.ida18 = (1 - l_ida.ida18) * 100                                 
   END IF                                                                       
#FUN-A20012 ---END
   LET l_ida.ida19 = '' 
   LET l_ida.ida20 = '' 
   LET l_ida.ida21 = 'N' 
   LET l_ida.ida22 = g_pmniicd15 
   LET l_ida.ida23 = '' 
   LET l_ida.ida24 = '' 
   LET l_ida.ida25 = ''  
   LET l_ida.ida26 = ''   
   LET l_ida.ida27 = 'N' 
   LET l_ida.ida28 = g_ida_h.ida28
   LET l_ida.ida29 = '' 
 
   LET l_ida.ida30 = ' '    #來源單號
   LET l_ida.ida31 = ' '    #來源項次
 
   LET l_ida.idaplant = g_plant   #FUN-980012 add
   LET l_ida.idalegal = g_legal   #FUN-980012 add
 
   #若為收貨單據，新增時預設入庫否(ida26) = 'Y'
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvb_file
      WHERE rvb01 = g_ida_h.ida07 
        AND rvb02 = g_ida_h.ida08
   IF l_cnt > 0 THEN
      LET l_ida.ida26 = 'Y'
   END IF
   
   #由單身呼叫，新增時欄位的default
   IF p_cmd = 'b' THEN
      LET b_ida.* = l_ida.*
      CALL s_icdin_move_to()
      RETURN
   END IF
 
   BEGIN WORK
 
   WHILE g_ida_h.odds > 0
       LET p_ida05 = p_ida05 + 1
       LET l_ida.ida05 = p_ida05 USING '&&&'
       IF l_ida.ida17 IS NULL THEN LET l_ida.ida17=0 END IF #TQC-BA0136 
       INSERT INTO ida_file VALUES(l_ida.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins ida_file',SQLCA.sqlcode,1)
          LET g_flag = 0
          ROLLBACK WORK
          RETURN 
       END IF
       LET g_ida_h.odds = g_ida_h.odds - 1
   END WHILE
 
   COMMIT WORK
END FUNCTION
 
FUNCTION s_icdin_b()                      #單身 
   DEFINE l_ac_t          LIKE type_file.num5,       #為取消的ARRAY CNT
          l_n             LIKE type_file.num5,        
          l_lock_sw       LIKE type_file.chr1,    #單身索住否
          p_cmd           LIKE type_file.chr1,    #處理狀態
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_ida10_tot     LIKE ida_file.ida10 
   DEFINE i               LIKE type_file.num5       
   DEFINE l_idc10         LIKE idc_file.idc10,   #FUN-B30187
          l_idc11         LIKE idc_file.idc10    #FUN-B30187
   DEFINE l_num_ida05     LIKE type_file.num5    #FUN-BA0051
   DEFINE l_cnt           LIKE type_file.num5    #TQC-C60185
   DEFINE l_i             LIKE type_file.num5    #TQC-C60185
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ida_h.ida01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   #檢查轉入否(ida27) 是否有等于'Y',若有 =Y的資料，則return
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ida_file
    WHERE ida01 = g_ida_h.ida01 
      AND ida02 = g_ida_h.ida02 
      AND ida03 = g_ida_h.ida03 
      AND ida04 = g_ida_h.ida04 
      AND ida07 = g_ida_h.ida07 
      AND ida08 = g_ida_h.ida08 
      AND ida27 = 'Y'
 
   IF g_cnt > 0 THEN 
      CALL cl_err('','sub-171',1)
      RETURN 
   END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT * FROM ida_file ",
                     " WHERE ida01 = ? AND ida02 = ? ",
                     "   AND ida03 = ? AND ida04 = ? ",
                     "   AND ida05 = ? AND ida06 = ? ",
                     "   AND ida07 = ? AND ida08 = ? ",
                     "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_icdin_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   WHILE TRUE
   
      INPUT ARRAY g_ida WITHOUT DEFAULTS FROM s_ida.*
                 ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                           APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
            LET g_before_input_done = FALSE
            CALL s_ida_set_entry_b()
            CALL s_ida_set_no_entry_b()
            LET g_before_input_done = TRUE
            CALL s_icdin_set_no_required()   #FUN-B30187
            CALL s_icdin_set_required()      #FUN-B30187
            CALL cl_set_act_visible("q_bin_g", g_imaicd08 = 'Y') #FUN-BA0051            
   
         BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
   
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               OPEN s_icdin_lock_u USING g_ida_h.ida01,
                                         g_ida_h.ida02,
                                         g_ida_h.ida03,
                                         g_ida_h.ida04,
                                         g_ida_h.ida07,
                                         g_ida_h.ida08
               IF STATUS THEN
                  CALL cl_err("OPEN s_icdin_lock_u",STATUS,1)
                  CLOSE s_icdin_lock_u
                  ROLLBACK WORK 
                  RETURN
               END IF
        
               FETCH s_icdin_lock_u INTO g_ida_lock.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ida_h.ida01,SQLCA.sqlcode,0)
                  CLOSE s_icdin_lock_u
                  ROLLBACK WORK 
                  RETURN
               END IF
   
               LET p_cmd='u'
               LET g_ida_t.* = g_ida[l_ac].*    #BACKUP
               LET g_ida_o.* = g_ida[l_ac].*    #BACKUP
               OPEN s_icdin_bcl USING g_ida_h.ida01,
                                      g_ida_h.ida02,
                                      g_ida_h.ida03,
                                      g_ida_h.ida04,
                                      g_ida_t.ida05,
                                      g_ida_t.ida06,
                                      g_ida_h.ida07,
                                      g_ida_h.ida08
               IF SQLCA.sqlcode THEN
                  CALL cl_err("OPEN s_icdin_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH s_icdin_bcl INTO b_ida.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FETCH s_icdin_bcl:',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL s_icdin_move_to()
                     LET g_ida_t.* = g_ida[l_ac].*    #BACKUP
                     LET g_ida_o.* = g_ida[l_ac].*    #BACKUP
                  END IF
               END IF
               CALL cl_show_fld_cont() 
            ELSE 
              IF l_allow_insert = FALSE THEN
                 RETURN
              END IF
            END IF
   
         BEFORE INSERT
           #防止刪除到0筆后，再度進入單身(當新增權限被取消時會發生)
            IF l_allow_insert = FALSE THEN
               RETURN
            END IF
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ida[l_ac].* TO NULL
            CALL s_ida_b_def()
            LET g_ida[l_ac].ida10 = 0
            LET g_ida[l_ac].ida11 = 0
            LET g_ida[l_ac].ida12 = 0
            LET g_ida[l_ac].ida21 = 'N'
            LET g_ida[l_ac].ida27 = 'N'
	        LET g_ida[l_ac].ida16 = g_rvbiicd08
            LET g_ida[l_ac].ida14 = g_imaicd01   #母體料號
            LET g_ida[l_ac].ida22 = g_pmniicd15  #接單料號
            LET g_ida[l_ac].ida26 = 'Y'          #入庫否
            LET g_numf = 1   #TQC-C60023
            LET g_numt = 1   #TQC-C60023
            #TQC-C60023---begin
            IF NOT cl_null(g_imaicd04) AND g_imaicd04 MATCHES '[01]' THEN
               CALL s_icdin_g_b(0,'b')
            END IF
            #TQC-C60023---end
            #FUN-BA0051 --START--
            #IF g_imaicd08 = 'N' AND g_imaicd09 = 'Y' THEN 
            #TQC-C60011---begin
            IF g_imaicd08 = 'Y' OR g_imaicd09 = 'Y' THEN 
               IF g_imaicd04 = '3' OR g_imaicd04 = '4' THEN
                  LET l_num_ida05 = 0
                  IF g_imaicd08 = 'N' AND g_imaicd09 = 'Y' THEN
                     #LET g_ida[l_ac].ida06 = ' '     #TQC-C60020
                     LET g_ida[l_ac].ida06 = 'BIN00'  #TQC-C60020
                  END IF       
               ELSE 
            #TQC-C60011---end
                  SELECT MAX(ida05) INTO l_num_ida05 FROM ida_file
                   WHERE ida01 = g_ida_h.ida01
                    AND  ida02 = g_ida_h.ida02
                    AND  ida03 = g_ida_h.ida03
                    AND  ida04 = g_ida_h.ida04
                    AND  ida07 = g_ida_h.ida07
                  IF cl_null(l_num_ida05) THEN LET l_num_ida05 = 0 END IF 
                  LET l_num_ida05 = l_num_ida05 + 1
               END IF    #TQC-C60011
               LET g_ida[l_ac].ida05 = l_num_ida05 USING '&&&' 
               #LET g_ida[l_ac].ida06 = ' '   #TQC-C60011  
               LET g_ida[l_ac].ida21 = 'N'           
            END IF    
            #FUN-BA0051 --END--  
            #TQC-C60023---begin 移到前面
            #IF NOT cl_null(g_imaicd04) AND g_imaicd04 MATCHES '[01]' THEN
            #   CALL s_icdin_g_b(0,'b')
            #END IF
            #TQC-C60023---end
            #FUN-B30187 mark --START--
            #IF g_imaicd04 = '4' THEN
            #   LET g_ida[l_ac].ida05 = '0'       # 刻號
            #   LET g_ida[l_ac].ida15 = g_ida_h.ida04  # 母批  
            #END IF
            #FUN-B30187 mark --END--
            #FUN-B30187 --START--
            #母批、DATACODE預設值
            DECLARE slot_def_c CURSOR FOR SELECT idc10,idc11 FROM idc_file 
                                           WHERE idc01 = g_ida_h.ida01
                                            AND  idc02 = g_ida_h.ida02
                                            AND  idc03 = g_ida_h.ida03
                                            AND  idc04 = g_ida_h.ida04
            OPEN slot_def_c                                            
            FETCH slot_def_c INTO g_ida[l_ac].ida15,g_ida[l_ac].ida16
            CLOSE slot_def_c
            #FUN-B30187 --END--
            #TQC-C60020---begin
            IF NOT cl_null(g_rvbiicd08) THEN
               LET g_ida[l_ac].ida16 = g_rvbiicd08
            END IF 
            #TQC-C60020---end
            
            #FUN-BA0107 --START--
            IF g_rec_b > 0 THEN 
               IF l_ac > 1 THEN
                  LET g_ida[l_ac].ida15 = g_ida[1].ida15
               ELSE
                  LET g_ida[l_ac].ida15 = g_ida[2].ida15    
               END IF
            END IF    
            #FUN-BA0107 --END--
 
            LET g_ida_t.* = g_ida[l_ac].*    #BACKUP
            LET g_ida_o.* = g_ida[l_ac].*    #BACKUP
            CALL cl_show_fld_cont() 
   
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           
            CALL s_icdin_move_back()
            #-----CHI-9A0009---------
            ## 加入判斷母批若沒有輸入
            #IF g_ida[l_ac].ida15 IS NULL THEN
            #   CALL cl_err(g_ida[l_ac].ida05,'sub-173',0)
            #   CALL g_ida.deleteElement(l_ac)
            #   CANCEL INSERT
            #END IF
            #-----END CHI-9A0009-----
 
            LET b_ida.ida30 = ' '    #來源單號 
            LET b_ida.ida31 = ' '    #來源項次

            IF b_ida.ida17 IS NULL THEN LET b_ida.ida17=0 END IF #TQC-BA0136
            INSERT INTO ida_file VALUES (b_ida.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('insert ida_file',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
            #同單據項次 ,相同刻號的入庫否狀態要相同
               IF NOT cl_null(g_ida[l_ac].ida26) THEN
                  UPDATE ida_file
                     SET ida26 = g_ida[l_ac].ida26
                   WHERE ida05 = g_ida_t.ida05  
                     AND ida07 = g_ida_h.ida07 
                     AND ida08 = g_ida_h.ida08 
               END IF
 
             
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL s_icdin_DIE() RETURNING l_sum  #顯示單身die數
               DISPLAY l_sum TO FORMONLY.sum1
 
            END IF
   
         AFTER FIELD ida05
            IF NOT cl_null(g_ida[l_ac].ida05) THEN
              #LET g_ida[l_ac].ida05 = g_ida[l_ac].ida05 USING '&&&'  #MOD-C30459  #MOD-C90137 mark
               LET g_ida[l_ac].ida05 = g_ida[l_ac].ida05 USING '&&&'  #MOD-C90137 #MOD-D40155
               IF NOT cl_null(g_ida[l_ac].ida06) THEN
                  IF cl_null(g_ida_t.ida05) OR
                     (g_ida_t.ida05 <> g_ida[l_ac].ida05) THEN
                     #檢查重復性
                     LET g_cnt = 0 
                     SELECT COUNT(*) INTO g_cnt FROM ida_file
                      WHERE ida01 = g_ida_h.ida01 
                        AND ida02 = g_ida_h.ida02 
                        AND ida03 = g_ida_h.ida03 
                        AND ida04 = g_ida_h.ida04 
                        AND ida05 = g_ida[l_ac].ida05 
                        AND ida06 = g_ida[l_ac].ida06 
                        AND ida07 = g_ida_h.ida07 
                        AND ida08 = g_ida_h.ida08 
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_ida[l_ac].ida05,'-239',0)
                        LET g_ida[l_ac].ida05 = g_ida_t.ida05
                        NEXT FIELD ida05
                     END IF
                  END IF
               END IF
    
              #料件狀態(imaicd04=(0,1,2) 已測wafer,同一刻號加總須小于等于1)
               IF g_imaicd04 MATCHES '[012]' THEN
                  LET l_ida10_tot = 0
                  LET g_ida11 = 0   #TQC-C50062 add
                 #SELECT SUM(ida10) INTO l_ida10_tot FROM ida_file                     #TQC-C50062 mark
                  SELECT SUM(ida10),SUM(ida11) INTO l_ida10_tot,g_ida11 FROM ida_file  #TQC-C50062
                   WHERE ida01 = g_ida_h.ida01
                     AND ida02 = g_ida_h.ida02
                     AND ida03 = g_ida_h.ida03
                     AND ida04 = g_ida_h.ida04
                     AND ida05 = g_ida[l_ac].ida05
                     AND ida07 = g_ida_h.ida07
                     AND ida08 = g_ida_h.ida08
                  IF cl_null(l_ida10_tot) THEN LET l_ida10_tot = 0 END IF
                 #str TQC-C50062 add
                  IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
                  #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
                  IF g_imaicd04 = '2' THEN LET l_ida10_tot = l_ida10_tot + g_ida11 END IF
                 #end TQC-C50062 add
                  IF p_cmd = 'a'  THEN
                     LET l_ida10_tot = l_ida10_tot + g_ida[l_ac].ida10
                  END IF
                  IF p_cmd = 'u' THEN   
                     #刻號沒換，要扣舊+新
                     IF g_ida[l_ac].ida05 = g_ida_t.ida05 THEN
                        LET l_ida10_tot = l_ida10_tot - g_ida_t.ida10 + g_ida[l_ac].ida10
                     END IF
                     #刻號要換，要+新
                     IF g_ida[l_ac].ida05<>g_ida_t.ida05 THEN
                        LET l_ida10_tot = l_ida10_tot + g_ida[l_ac].ida10
                     END IF
                  END IF
                  IF l_ida10_tot > 1 THEN
                     CALL cl_err(l_ida10_tot,'sub-176',0)
                     NEXT FIELD ida05
                  END IF
               END IF
            END IF
   
         AFTER FIELD ida06
            IF NOT cl_null(g_ida[l_ac].ida06) THEN
               IF NOT cl_null(g_ida[l_ac].ida05) THEN
                  IF cl_null(g_ida_t.ida06) OR
                     (g_ida_t.ida06 <> g_ida[l_ac].ida06) THEN
                     LET g_cnt = 0 
                     SELECT COUNT(*) INTO g_cnt FROM ida_file
                      WHERE ida01 = g_ida_h.ida01 
                        AND ida02 = g_ida_h.ida02 
                        AND ida03 = g_ida_h.ida03 
                        AND ida04 = g_ida_h.ida04 
                        AND ida05 = g_ida[l_ac].ida05 
                        AND ida06 = g_ida[l_ac].ida06 
                        AND ida07 = g_ida_h.ida07 
                        AND ida08 = g_ida_h.ida08 
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_ida[l_ac].ida06,'-239',0)
                        LET g_ida[l_ac].ida06 = g_ida_t.ida06
                        NEXT FIELD ida06
                     END IF
                     #2. 已測wafer 控卡:檢查所輸入之資料之Pass icf(icf04)<>'Y',則警告user輸入錯誤
                     CALL s_icdin_passicf_chk()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('chk pass icf:',g_errno,1)
                        LET g_ida[l_ac].ida06 = g_ida_t.ida06
                        NEXT FIELD ida06
                     ELSE
                        LET g_ida[l_ac].ida21 = 'Y'
                        DISPLAY BY NAME g_ida[l_ac].ida21
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD ida10
            IF NOT cl_null(g_ida[l_ac].ida10) THEN
               IF g_ida[l_ac].ida10<0 THEN
                  CALL cl_err(g_ida[l_ac].ida10,'aim-391',0)
                  NEXT FIELD ida10
               END IF
               #LET g_ida[l_ac].ida10 = s_digqty(g_ida[l_ac].ida10,g_ida_h.ida13)   #FUN-BB0084   #TQC-C60186
               DISPLAY BY NAME g_ida[l_ac].ida10  #FUN-BB0084 
               #料件狀態(imaicd04=(0,1,2) 已測wafer,同一刻號加總須小于等于1)
               IF g_imaicd04 MATCHES '[012]' THEN
                  LET l_ida10_tot = 0
                  LET g_ida11 = 0   #TQC-C50062 add
                 #SELECT SUM(ida10) INTO l_ida10_tot FROM ida_file                     #TQC-C50062 mark
                  SELECT SUM(ida10),SUM(ida11) INTO l_ida10_tot,g_ida11 FROM ida_file  #TQC-C50062
                   WHERE ida01 = g_ida_h.ida01
                     AND ida02 = g_ida_h.ida02
                     AND ida03 = g_ida_h.ida03
                     AND ida04 = g_ida_h.ida04
                     AND ida05 = g_ida[l_ac].ida05
                     AND ida07 = g_ida_h.ida07
                     AND ida08 = g_ida_h.ida08
                  IF cl_null(l_ida10_tot) THEN LET l_ida10_tot = 0 END IF
                 #str TQC-C50062 add
                  IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
                  #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
                  IF g_imaicd04 = '2' THEN LET l_ida10_tot = l_ida10_tot + g_ida11 END IF
                 #end TQC-C50062 add
                  IF p_cmd = 'a'  THEN
                     LET l_ida10_tot = l_ida10_tot + g_ida[l_ac].ida10
                  END IF
                  IF p_cmd = 'u' THEN
                     #刻號沒換，要扣舊+新
                     IF g_ida[l_ac].ida05 = g_ida_t.ida05 THEN
                        LET l_ida10_tot = l_ida10_tot - g_ida_t.ida10 + g_ida[l_ac].ida10
                     END IF
                     #刻號有換，要+新
                     IF g_ida[l_ac].ida05<>g_ida_t.ida05 THEN
                        LET l_ida10_tot = l_ida10_tot + g_ida[l_ac].ida10
                     END IF
                  END IF
                  IF l_ida10_tot > 1 THEN
                     CALL cl_err(l_ida10_tot,'sub-176',0)
                     NEXT FIELD ida10
                  END IF
               END IF
                    
               #已測 wafer 的資料，DIE數值由user自行輸入
               #所以不用default   
               IF g_imaicd04 MATCHES '[0-1]' THEN 
                  #DIE 數(ima17)=實體數量(ida10)*icb05 
                  IF cl_null(g_ida_o.ida10) OR
                     g_ida[l_ac].ida10 <> g_ida_o.ida10 THEN
                  #  LET g_ida[l_ac].ida17 = g_ida[l_ac].ida10 * g_ida_h.icb05 #FUN-B30192
                     LET g_ida[l_ac].ida17 = g_ida[l_ac].ida10 * g_ida_h.imaicd14 #FUN-B30192
                  END IF
               END IF 
               #TQC-C60186---begin
               IF g_imaicd04 = 2 THEN 
                  IF g_ida_t.ida10 = 0 THEN
                     LET g_ida[l_ac].ida17 = g_ida[l_ac].ida10 * g_ida_h.imaicd14
                  END IF 
               END IF 
               #TQC-C60186---end
#No.FUN-A20012 ---add begin                                                     
               IF NOT s_ida_check() THEN                                        
                  NEXT FIELD ida10                                              
               END IF                                                           
#No.FUN-A20012 ---add end 
            END IF
         
            LET g_ida_o.ida10 = g_ida[l_ac].ida10
 
         AFTER FIELD ida11
            IF NOT cl_null(g_ida[l_ac].ida11) THEN
               IF g_ida[l_ac].ida11<0 THEN
                  CALL cl_err(g_ida[l_ac].ida11,'aim-391',0)
                  NEXT FIELD ida11
               END IF
               #LET g_ida[l_ac].ida11 = s_digqty(g_ida[l_ac].ida11,g_ida_h.ida13)   #FUN-BB0084 #TQC-C60186
               DISPLAY BY NAME g_ida[l_ac].ida11  #FUN-BB0084 
#No.FUN-A20012 ---add begin                                                     
               IF NOT s_ida_check() THEN                                        
                  NEXT FIELD ida11                                              
               END IF                                                           
#No.FUN-A20012 ---add end
            END IF
   
         AFTER FIELD ida12
            IF NOT cl_null(g_ida[l_ac].ida12) THEN
               IF g_ida[l_ac].ida12<0 THEN
                  CALL cl_err(g_ida[l_ac].ida12,'aim-391',0)
                  NEXT FIELD ida12
               END IF
               #LET g_ida[l_ac].ida12 = s_digqty(g_ida[l_ac].ida12,g_ida_h.ida13)   #FUN-BB0084 #TQC-C60186
               DISPLAY BY NAME g_ida[l_ac].ida12  #FUN-BB0084 
#No.FUN-A20012 ---add begin                                                     
               IF NOT s_ida_check() THEN                                        
                  NEXT FIELD ida12                                              
               END IF                                                           
#No.FUN-A20012 ---add end
            END IF
         
         #-----CHI-9A0009---------
         ##加入判斷母批是否有維護 
         #AFTER FIELD ida15
         #   IF cl_null(g_ida[l_ac].ida15) THEN
         #      CALL cl_err(g_ida[l_ac].ida05,'sub-173',0)
         #      NEXT FIELD ida15   
         #   END IF 
         #-----END CHI-9A0009-----
   
         AFTER FIELD ida21
            IF NOT cl_null(g_ida[l_ac].ida21) THEN
               IF g_ida[l_ac].ida21 NOT MATCHES '[YN]' THEN
                  NEXT FIELD ida21
               END IF
            END IF
 
         ON CHANGE ida26   #入庫否
            IF NOT cl_null(g_ida[l_ac].ida26) THEN
               IF g_ida[l_ac].ida26 = 'Y' THEN
                  FOR i = 1 TO g_rec_b
                      IF g_ida[l_ac].ida05 = g_ida[i].ida05 THEN
                         LET g_ida[i].ida26 = 'Y'
                         DISPLAY BY NAME g_ida[i].ida26
                      END IF
                  END FOR
               ELSE
                  FOR i = 1 TO g_rec_b
                      IF g_ida[l_ac].ida05 = g_ida[i].ida05 THEN
                         LET g_ida[i].ida26 = 'N'
                         DISPLAY BY NAME g_ida[i].ida26
                      END IF
                  END FOR
               END IF
            END IF
         
         #已測wafer 之料號，DIE數值由user自行輸入
         #輸入后檢查同刻號DIE數值加總不可超越Gross die數
         AFTER FIELD ida17
            IF g_ida[l_ac].ida17 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD ida17
            END IF
            IF NOT cl_null(g_ida[l_ac].ida17) THEN
               IF (g_ida[l_ac].ida17 != g_ida_t.ida17)
                  OR p_cmd = 'a' THEN
                  CALL s_icdin_die_chk(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('chk die:',g_errno,1)
                     LET g_ida[l_ac].ida17 = g_ida_t.ida17
                     NEXT FIELD ida17
                  END IF
               END IF
               #TQC-C60186---begin
               IF g_imaicd04 = 2 THEN 
                  LET l_cnt = 0
                  FOR l_i = 1 TO g_ida.getLength()
                     IF g_ida[l_ac].ida05 = g_ida[l_i].ida05 THEN
                        LET l_cnt = l_cnt + 1
                     END IF 
                  END FOR 
                  IF g_ida_t.ida17 = 0 AND l_cnt > 1 THEN
                     LET g_ida[l_ac].ida10 = g_ida[l_ac].ida17 / g_ida_h.imaicd14
                  END IF 
               END IF 
               #TQC-C60186---end
            END IF
            #FUN-B30110 --START--
            #YIELD(%)
            IF g_ida[l_ac].ida17 > 0 THEN
               LET g_ida[l_ac].ida18 = g_ida[l_ac].ida17 / g_ida_h.imaicd14 * 100
            END IF 
            #FUN-B30110 --START--
 
         BEFORE DELETE                       #是否取消單身  
            IF NOT cl_null(g_ida_t.ida05) AND 
               NOT g_ida_t.ida06 IS NULL THEN   #FUN-BA0051  
               #NOT cl_null(g_ida_t.ida06) THEN #FUN-BA0051 mark
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF
               DELETE FROM ida_file
                WHERE ida01 = g_ida_h.ida01 
                  AND ida02 = g_ida_h.ida02 
                  AND ida03 = g_ida_h.ida03 
                  AND ida04 = g_ida_h.ida04 
                  AND ida05 = g_ida_t.ida05 
                  AND ida06 = g_ida_t.ida06 
                  AND ida07 = g_ida_h.ida07 
                  AND ida08 = g_ida_h.ida08 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('delete ida_file',SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF 
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cn2
	       CALL s_icdin_DIE() RETURNING l_sum  #顯示單身die數
               DISPLAY l_sum TO FORMONLY.sum1
            END IF
            COMMIT WORK
   
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ida[l_ac].* = g_ida_t.*
               CLOSE s_icdin_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ida[l_ac].ida05,-263,1)
               LET g_ida[l_ac].* = g_ida_t.*
            ELSE
               CALL s_icdin_move_back()
               UPDATE ida_file SET * = b_ida.*
                WHERE ida01 = g_ida_h.ida01 
                  AND ida02 = g_ida_h.ida02 
                  AND ida03 = g_ida_h.ida03 
                  AND ida04 = g_ida_h.ida04 
                  AND ida05 = g_ida_t.ida05 
                  AND ida06 = g_ida_t.ida06 
                  AND ida07 = g_ida_h.ida07 
                  AND ida08 = g_ida_h.ida08 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('update ida_file',SQLCA.sqlcode,0)
                  LET g_ida[l_ac].* = g_ida_t.*
                  ROLLBACK WORK
               ELSE
                  #同單據項次，相同刻號的入庫狀態要相同
                  IF NOT cl_null(g_ida[l_ac].ida26) THEN
                      UPDATE ida_file 
                         SET ida26 = g_ida[l_ac].ida26 
                       WHERE ida05 = g_ida_t.ida05  #刻號 
                         AND ida07 = g_ida_h.ida07  #單據編號
                         AND ida08 = g_ida_h.ida08  #項次
                  END IF  
 
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
   
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            LET g_ida11 = 0   #TQC-C50062 add
           #SELECT SUM(ida10) INTO g_ida_h.tot_b FROM ida_file                      #TQC-C50062 mark
            SELECT SUM(ida10),SUM(ida11) INTO g_ida_h.tot_b,g_ida11 FROM ida_file   #TQC-C50062
             WHERE ida01 = g_ida_h.ida01 
               AND ida02 = g_ida_h.ida02
               AND ida03 = g_ida_h.ida03
               AND ida04 = g_ida_h.ida04
               AND ida07 = g_ida_h.ida07
               AND ida08 = g_ida_h.ida08
           #str TQC-C50062 add
            IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
            #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
            IF g_imaicd04 = '2' THEN LET g_ida_h.tot_b = g_ida_h.tot_b + g_ida11 END IF
           #end TQC-C50062 add
            LET g_ida_h.odds = g_ida_h.tot - g_ida_h.tot_b
            DISPLAY BY NAME g_ida_h.odds,g_ida_h.tot_b
                           
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ida[l_ac].* = g_ida_t.*
               END IF
               CLOSE s_icdin_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE s_icdin_bcl
            COMMIT WORK
         #FUN-B30187 --START--   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ida15)   #母批
                  CALL q_slot(FALSE,TRUE,g_ida[l_n].ida15,'',g_wono)
                     RETURNING g_ida[l_n].ida15
                     DISPLAY BY NAME g_ida[l_n].ida15
                     NEXT FIELD ida15
               #FUN-B30110 --START--      
               WHEN INFIELD(ida06)   #BIN
                  LET g_numf = 1   #TQC-C60023
                  LET g_numt = 1   #TQC-C60023
                  #TQC-C60023---begin
                  IF g_imaicd04 = '2' AND g_rec_b = 0 THEN  
                     CALL s_icdin_mark()
                  END IF 
                  #TQC-C60023---end
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bin"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.arg1     = g_ida_h.ida01                  
                  #CALL cl_create_qry() RETURNING g_ida[l_n].ida06,g_ida[l_n].ida21   #FUN-B30182 mark                 
                  #DISPLAY BY NAME g_ida[l_n].ida06,g_ida[l_n].ida21                  #FUN-B30182 mark  
                  #NEXT FIELD ida06                                                   #FUN-B30182 mark
                  
                  #FUN-B30182 --START--
                  IF g_rec_b > 0 THEN                
                     CALL cl_create_qry() RETURNING g_ida[l_n].ida06,g_ida[l_n].ida21
                     DISPLAY BY NAME g_ida[l_n].ida06,g_ida[l_n].ida21
                     NEXT FIELD ida06
                  ELSE
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     IF NOT cl_null(g_qryparam.multiret) THEN
                       CALL s_icdin_multi_ida06(g_qryparam.multiret,'1')                    
                       CALL s_icdin_process_b()
                       LET g_flag = TRUE 
                       EXIT INPUT
                     END IF   
                  END IF
                  #FUN-B30182 --END--   
               #FUN-B30110 --END--                     
               OTHERWISE EXIT CASE
               END CASE
         #FUN-B30187 --END--      
         ON ACTION CONTROLG
            CALL cl_cmdask()
   
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          #FUN-B30110 --START--                
         ON ACTION q_bin_g   #查詢群組BIN
            IF NOT g_imaicd04 MATCHES '[01]' THEN 
               LET g_numf = 1   #TQC-C60023
               LET g_numt = 1   #TQC-C60023
               #TQC-C60023---begin
               IF g_imaicd04 = '2' AND g_rec_b = 0 THEN  
                  CALL s_icdin_mark()
               END IF 
               #TQC-C60023---end
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bin_g"
               LET g_qryparam.construct = "N"
               LET g_qryparam.arg1     = g_ida_h.ida01                  
               #CALL cl_create_qry() RETURNING g_ida[l_n].ida06,g_ida[l_n].ida21   #FUN-B30182 mark
               #DISPLAY BY NAME g_ida[l_n].ida06,g_ida[l_n].ida21                  #FUN-B30182 mark
               #NEXT FIELD ida06                                                   #FUN-B30182 mark  
               
               #FUN-B30182 --START--
               IF g_rec_b > 0 THEN                
                  CALL cl_create_qry() RETURNING g_ida[l_n].ida06,g_ida[l_n].ida21
                  DISPLAY BY NAME g_ida[l_n].ida06,g_ida[l_n].ida21
                  NEXT FIELD ida06
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  IF NOT cl_null(g_qryparam.multiret) THEN
                    CALL s_icdin_multi_ida06(g_qryparam.multiret,'2')                    
                    CALL s_icdin_process_b()
                    LET g_flag = TRUE 
                    EXIT INPUT
                  END IF   
               END IF
               #FUN-B30182 --END--
            END IF                    
         #FUN-B30110 --END--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION about
            CALL cl_about()
      END INPUT
      #MOD-C30405---begin mark
      #IF g_imaicd04 = 1 AND g_ida_h.odds < 0 THEN
      #   LET g_msg = cl_getmsg('TSD0029',g_lang)
      #   LET g_msg = g_msg CLIPPED,(-1 * g_ida_h.odds USING '<<<<<')
      #   LET g_msg = g_msg CLIPPED,cl_getmsg('TSD003',g_lang)
      #   CALL cl_err(g_msg,'!',1)
      #   CONTINUE WHILE
      #END IF
 
      #IF g_imaicd04 <> 1 AND g_ida_h.odds < 0 THEN
      #MOD-C30405---end mark
      IF g_ida_h.odds < 0 THEN            #MOD-C30405
         CALL cl_err('','sub-172',1)
      END IF
      EXIT WHILE
   END WHILE

   #FUN-B30182 --START--
   IF g_multi_flag THEN
      LET g_multi_flag = FALSE
      CALL s_icdin_b()
   END IF
   #FUN-B30182 --START--
 
   CLOSE s_icdin_bcl
   COMMIT WORK
END FUNCTION

#TQC-C60023---begin
FUNCTION s_icdin_mark() 
   OPEN WINDOW s_icdin_1_w AT 10,20
        WITH FORM "sub/42f/s_icdin_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
        CALL cl_ui_locale("s_icdin_1")
                  
        INPUT g_numf,g_numt FROM numf,numt
                  
        BEFORE INPUT
           LET g_numf = 1
           LET g_numt = g_ida_h.tot
           DISPLAY g_numf TO numf
           DISPLAY g_numt TO numt
                    
        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION HELP
           CALL cl_show_help()

        AFTER INPUT 
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_numf = 1
              LET g_numt = 1
              CLOSE WINDOW s_icdin_1_w
           END IF  
        END INPUT 
        CLOSE WINDOW s_icdin_1_w
END FUNCTION 
#TQC-C60023---end

#No.FUN-A20012 ----add begin                                                    
FUNCTION s_ida_check()                                                          
                                                                                
   DEFINE l_ida18   LIKE ida_file.ida18                                         
   IF g_ida[l_ac].ida10 < g_ida[l_ac].ida11 + g_ida[l_ac].ida12 THEN            
      CALL cl_err("","sub-521",1)                                               
      RETURN FALSE                                                              
   END IF                                                                       
   IF NOT cl_null(g_ida[l_ac].ida10) AND NOT cl_null(g_ida[l_ac].ida11)         
                                     AND NOT cl_null(g_ida[l_ac].ida12) THEN    
      LET l_ida18 = (g_ida[l_ac].ida11 + g_ida[l_ac].ida12) / g_ida[l_ac].ida10 
      LET l_ida18 = (1 - l_ida18) * 100                                         
      LET g_ida[l_ac].ida18 = l_ida18                                           
      DISPLAY BY NAME g_ida[l_ac].ida18                                         
   END IF                                                                       
   RETURN TRUE                                                                  
END FUNCTION                                                                    
#No.FUN-A20012 ----add end
 
FUNCTION s_ida_b_def()
   LET b_ida.ida01 = g_ida_h.ida01
   LET b_ida.ida02 = g_ida_h.ida02 
   LET b_ida.ida03 = g_ida_h.ida03
   LET b_ida.ida04 = g_ida_h.ida04 
   LET b_ida.ida07 = g_ida_h.ida07  
   LET b_ida.ida08 = g_ida_h.ida08   
   LET b_ida.ida09 = g_ida_h.ida09   
   LET b_ida.ida13 = g_ida_h.ida13
   LET b_ida.ida28 = g_ida_h.ida28 
   IF cl_null(b_ida.ida03) THEN LET b_ida.ida03 = ' ' END IF
   IF cl_null(b_ida.ida04) THEN LET b_ida.ida04 = ' ' END IF
END FUNCTION
 
 
FUNCTION s_icdin_move_to()
    LET g_ida[l_ac].ida05 = b_ida.ida05
    LET g_ida[l_ac].ida06 = b_ida.ida06
    LET g_ida[l_ac].ida21 = b_ida.ida21
    LET g_ida[l_ac].ida10 = b_ida.ida10
    LET g_ida[l_ac].ida11 = b_ida.ida11
    LET g_ida[l_ac].ida12 = b_ida.ida12
    LET g_ida[l_ac].ida14 = b_ida.ida14
    LET g_ida[l_ac].ida15 = b_ida.ida15
    LET g_ida[l_ac].ida17 = b_ida.ida17
    LET g_ida[l_ac].ida16 = b_ida.ida16
    LET g_ida[l_ac].ida18 = b_ida.ida18
    LET g_ida[l_ac].ida19 = b_ida.ida19
    LET g_ida[l_ac].ida20 = b_ida.ida20
    LET g_ida[l_ac].ida22 = b_ida.ida22
    LET g_ida[l_ac].ida26 = b_ida.ida26
    LET g_ida[l_ac].ida27 = b_ida.ida27
    LET g_ida[l_ac].ida29 = b_ida.ida29
END FUNCTION
 
 
FUNCTION s_icdin_move_back()
    LET b_ida.ida05 = g_ida[l_ac].ida05
    LET b_ida.ida06 = g_ida[l_ac].ida06
    LET b_ida.ida21 = g_ida[l_ac].ida21
    LET b_ida.ida10 = g_ida[l_ac].ida10
    LET b_ida.ida11 = g_ida[l_ac].ida11
    LET b_ida.ida12 = g_ida[l_ac].ida12
    LET b_ida.ida14 = g_ida[l_ac].ida14
    LET b_ida.ida15 = g_ida[l_ac].ida15
    LET b_ida.ida17 = g_ida[l_ac].ida17
    LET b_ida.ida16 = g_ida[l_ac].ida16
    LET b_ida.ida18 = g_ida[l_ac].ida18
    LET b_ida.ida19 = g_ida[l_ac].ida19
    LET b_ida.ida20 = g_ida[l_ac].ida20
    LET b_ida.ida22 = g_ida[l_ac].ida22
    LET b_ida.ida26 = g_ida[l_ac].ida26
    LET b_ida.ida27 = g_ida[l_ac].ida27
    LET b_ida.ida29 = g_ida[l_ac].ida29
    LET b_ida.idaplant = g_plant   #FUN-980012 add
    LET b_ida.idalegal = g_legal   #FUN-980012 add
END FUNCTION
 
 
FUNCTION s_ida_set_entry_b()
    IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("ida05,ida06,ida10,ida11,ida12",TRUE)
    END IF
    IF g_imaicd04 = '2' THEN
       CALL cl_set_comp_entry("ida17",TRUE)
    END IF
    #FUN-BA0051 --START--
    IF g_imaicd08 = 'Y' THEN
       CALL cl_set_comp_entry("ida06,ida21",TRUE)
    END IF
    #FUN-BA0051 --END-- 
END FUNCTION
 
FUNCTION s_ida_set_no_entry_b()
    IF NOT g_before_input_done THEN
       IF g_imaicd04 MATCHES '[01]' THEN
       #開放刻號欄位可自行輸入
          CALL cl_set_comp_entry("ida06,ida10,ida11,ida12",FALSE)
       END IF  
    END IF
 
    IF g_imaicd04 != '2' THEN
       CALL cl_set_comp_entry("ida17",FALSE)
    END IF
    #未測wafer 之料號的die數值默認為Gross die
    #FUN-BA0051 --START--
    IF g_imaicd08 = 'N' THEN
       CALL cl_set_comp_entry("ida06,ida21",FALSE)
    END IF
    #FUN-BA0051 --END-- 
END FUNCTION
 
FUNCTION s_icdin_DIE() 
   DEFINE l_ida17 LIKE ida_file.ida17
   CASE 
       WHEN g_imaicd04 = '1' OR g_imaicd04 = '0'
            SELECT SUM(ida17) INTO l_ida17 FROM ida_file
             WHERE ida01 = g_ida_h.ida01
               AND ida02 = g_ida_h.ida02
               AND ida03 = g_ida_h.ida03
               AND ida04 = g_ida_h.ida04
               AND ida07 = g_ida_h.ida07
               AND ida08 = g_ida_h.ida08
               AND ida17 IS NOT NULL
       WHEN g_imaicd04 = '2'
            SELECT SUM(ida17) INTO l_ida17 FROM ida_file
             WHERE ida01 = g_ida_h.ida01
               AND ida02 = g_ida_h.ida02
               AND ida03 = g_ida_h.ida03
               AND ida04 = g_ida_h.ida04
               AND ida07 = g_ida_h.ida07
               AND ida08 = g_ida_h.ida08
               AND ida17 IS NOT NULL
               AND ida21 = 'Y'
       OTHERWISE
            LET l_ida17 = 0
   END CASE
   IF cl_null(l_ida17) THEN LET l_ida17 = 0 END IF
   RETURN l_ida17
END FUNCTION
 
#若有傳入原始單號項次，依原始單號項次的idd產生ida
#取單身/insert 單身
FUNCTION s_icdin_process_b2()
   DEFINE l_sql    STRING,              
          l_rvu00  LIKE rvu_file.rvu00  
 
   DEFINE l_sfs03  LIKE sfs_file.sfs03,   #工單號
          l_sfs04  LIKE sfs_file.sfs04,   #料
          l_sfs06  LIKE sfs_file.sfs06,   #發料單位
          l_sfs10  LIKE sfs_file.sfs10    #作業編號
 
   #撈單身
   DECLARE cs_ida_b2_cs CURSOR FOR
    SELECT ida05,ida06,ida21,ida10,ida11,ida12,
           ida14,ida15,ida17,ida16,ida18,ida19,
           ida20,ida22,ida26,ida27,ida29
     FROM ida_file
     WHERE ida01 = g_ida_h.ida01
       AND ida02 = g_ida_h.ida02
       AND ida03 = g_ida_h.ida03
       AND ida04 = g_ida_h.ida04
       AND ida07 = g_ida_h.ida07
       AND ida08 = g_ida_h.ida08
     ORDER BY ida05,ida06
 
   LET g_cnt = 1
   CALL g_ida.clear()
   FOREACH cs_ida_b2_cs INTO g_ida[g_cnt].*
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_ida.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   
   LET g_ida11 = 0  #TQC-C50062 add
   #計算單身數量合g_ida_h.tot_b/差異數量g_ida_h.odds
  #SELECT SUM(ida10) INTO g_ida_h.tot_b FROM ida_file                     #TQC-C50062 mark
   SELECT SUM(ida10),SUM(ida11) INTO g_ida_h.tot_b,g_ida11 FROM ida_file  #TQC-C50062
    WHERE ida01 = g_ida_h.ida01
      AND ida02 = g_ida_h.ida02
      AND ida03 = g_ida_h.ida03
      AND ida04 = g_ida_h.ida04
      AND ida07 = g_ida_h.ida07
      AND ida08 = g_ida_h.ida08
   IF cl_null(g_ida_h.tot_b) THEN LET g_ida_h.tot_b = 0 END IF
  #str TQC-C50062 add
   IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
   #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
   IF g_imaicd04 = '2' THEN LET g_ida_h.tot_b = g_ida_h.tot_b + g_ida11 END IF
  #end TQC-C50062 add
   LET g_ida_h.odds = g_ida_h.tot - g_ida_h.tot_b
 
 
   LET l_rvu00 = ''
   SELECT rvv03 INTO l_rvu00
      FROM rvv_file
     WHERE rvv01 = g_ida_h.ida07  
       AND rvv02 = g_ida_h.ida08   
       AND rvv04 = g_no                 
       AND rvv05 = g_item        
   
   #取得原始單據項次的出入庫數量
   LET l_sql = "SELECT SUM(idd13 ) FROM idd_file",        #料號
               "   WHERE idd01 = '",g_ida_h.ida01,"'"  #倉庫   
          
   #若為工單要撈所有的發料來源
   SELECT sfb01 FROM sfb_file WHERE sfb01 = g_no
   IF SQLCA.sqlcode = 100 THEN  #非工單
      LET l_sql = l_sql CLIPPED, 
                  " AND idd10 = '",g_no,"'",                 #原始單據
                  " AND idd11 = ",g_item,                    #原始項次
                  #排除已存在本張或他張未過張之來源退單據的刻號明細資料
                  "  AND (idd05 || idd06) NOT IN",  
                  "      (SELECT ida05 || ida06 FROM ida_file",
                  "        WHERE ida01 = '",g_ida_h.ida01,"'",
                  "          AND ida30 = '",g_no,"'",
                  "          AND ida31 = ",g_item,")",
                  #排除已存在本張或他張已過賬之來源退單據的刻號明細資料
                  "  AND (idd05 || idd06) NOT IN",
                  "      (SELECT idd05 || idd06 FROM idd_file",
                  "        WHERE idd01 = '",g_ida_h.ida01,"'",
                  "          AND idd30 = '",g_no,"'",
                  "          AND idd31 = ",g_item,")"
      #FUN-B30187 --START--
      SELECT DISTINCT rvb34 INTO g_wono FROM rvb_file
       WHERE rvb01 = g_no AND rvb02 = g_item
      #FUN-B30187 --END--
   ELSE
      SELECT sfs03,sfs04,sfs06,sfs10 INTO l_sfs03,l_sfs04,l_sfs06,l_sfs10
        FROM sfs_file                       #取得退料單身資料
       WHERE sfs01 = g_ida_h.ida07
         AND sfs02 = g_ida_h.ida08
 
      LET l_sql = l_sql CLIPPED, 
                  " AND (idd10 ||idd11) IN ",          #原始單據/項次 
                  "     (SELECT sfe02 || sfe28 FROM sfp_file,sfe_file ",
                  "       WHERE sfp01 = sfe02 AND sfp06 IN('1','D') ",#成套發料資料     #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
                  "         AND sfp04 = 'Y' ",                  #已扣賬
                  "         AND sfe01 = '",l_sfs03,"' ",        #工單號
                  "         AND sfe07 = '",l_sfs04,"' ",        #料 
                  "         AND sfe17 = '",l_sfs06,"' ",        #發料單位
                  "         AND sfe14 = '",l_sfs10,"' )",       #作業編號 
                 # "  AND (idd05 || idd06) NOT IN",  
                 # "      (SELECT ida05 || ida06 FROM ida_file",
                 # "        WHERE ida01 = '",g_ida_h.ida01,"'",
                 # "          AND ida30 = '",g_no,"'",
                 # "          AND ida31 = ",g_item,")",
                 # "  AND (idd05 || idd06) NOT IN",
                 # "      (SELECT idd05 || idd06 FROM idd_file",
                 # "        WHERE idd01 = '",g_ida_h.ida01,"'",
                 # "          AND idd30 = '",g_no,"'",
                 # "          AND idd31 = ",g_item,")"
                  "   AND (idd05||idd06) NOT IN",
                  "       (SELECT ida05||ida06 FROM ida_file",
                  "         WHERE ida01 = '",g_ida_h.ida01,"'",
                  "           AND (ida07||ida08) IN ",
                  "               (SELECT sfs01||sfs02 FROM sfp_file,sfs_file ",
                  "                 WHERE sfp01 = sfs01 AND sfp06 = '6' ", 
                  "                   AND sfp04 = 'N' ",           #未扣賬 
                  "                   AND sfs03 = '",l_sfs03,"' ", #工單號
                  "                   AND sfs04 = '",l_sfs04,"' ", #料
                  "                   AND sfs06 = '",l_sfs06,"' ", #發料單位
                  "                   AND sfs10 = '",l_sfs10,"'))",#作業編號
                  "   AND (idd05 || idd06) NOT IN",  
                  "       (SELECT idd05 || idd06 FROM idd_file",
                  "         WHERE idd01 = '",g_ida_h.ida01,"'", 
                  "           AND idd07 = '",g_ida_h.ida13,"'",
                  "           AND (idd10 || idd11) IN ",
                  "               (SELECT sfe02||sfe28 FROM sfp_file,sfe_file ",
                  "                 WHERE sfp01 = sfe02 AND sfp06 = '6'",#成套退
                  "                   AND sfp04 = 'Y' ",                 #已扣賬
                  "                   AND sfe01 = '",l_sfs03,"' ",       #工單號
                  "                   AND sfe07 = '",l_sfs04,"' ",       #料
                  "                   AND sfe17 = '",l_sfs06,"' ",       #發料單位
                  "                   AND sfe14 = '",l_sfs10,"'))"       #作業編號
      LET g_wono = g_no   #FUN-B30187
   END IF
 
   IF l_rvu00 = '1' THEN #入庫單
      LET l_sql = l_sql CLIPPED,"  AND idd24 = 'Y'"
   END IF
   IF l_rvu00 = '2' THEN #驗退單
      LET l_sql = l_sql CLIPPED,"  AND idd24 = 'N'"
   END IF
 
   PREPARE idd13_sum_pre FROM l_sql
   DECLARE idd13_sum_dec CURSOR FOR idd13_sum_pre
   OPEN idd13_sum_dec
   FETCH idd13_sum_dec INTO g_idd13
   
   #當單料件狀(imaicd04)=(0-2)，且若單身數量tot<單據數量=>自動insert 單身
   IF NOT cl_null(g_imaicd04) THEN
      #若單據的數量非整量>四舍五入
      IF g_ida_h.odds > 0 THEN
         IF g_rec_b = 0 AND (g_ida_h.tot = g_idd13) THEN
            CALL s_icdin_g_b2(0) #不開窗，直接全部insert
         ELSE
            CALL s_icdin_g_b2(1) #開窗挑選 
         END IF
         LET g_cnt = 1
         CALL g_ida.clear()
         FOREACH cs_ida_b2_cs INTO g_ida[g_cnt].*
           LET g_cnt = g_cnt + 1
         END FOREACH
         LET g_ida11 = 0  #TQC-C50062 add
        #SELECT SUM(ida10) INTO g_ida_h.tot_b FROM ida_file                     #TQC-C50062 mark
         SELECT SUM(ida10),SUM(ida11) INTO g_ida_h.tot_b,g_ida11 FROM ida_file  #TQC-C50062
          WHERE ida01 = g_ida_h.ida01
            AND ida02 = g_ida_h.ida02
            AND ida03 = g_ida_h.ida03
            AND ida04 = g_ida_h.ida04
            AND ida07 = g_ida_h.ida07
            AND ida08 = g_ida_h.ida08
         IF cl_null(g_ida_h.tot_b) THEN LET g_ida_h.tot_b = 0 END IF
        #str TQC-C50062 add
         IF cl_null(g_ida11) THEN LET g_ida11 = 0 END IF
         #當料件型態為2.已測WAFER時,計算單身數量需連ida11一併納入
         IF g_imaicd04 = '2' THEN LET g_ida_h.tot_b = g_ida_h.tot_b + g_ida11 END IF
        #end TQC-C50062 add
         LET g_ida_h.odds = g_ida_h.tot - g_ida_h.tot_b 
         CALL g_ida.deleteElement(g_cnt)
         LET g_rec_b = g_cnt - 1
      END IF
   END IF
END FUNCTION
 
FUNCTION s_icdin_g_b2(p_type)
   DEFINE p_type    LIKE type_file.num5,
          p_row     LIKE type_file.num5,
          p_col     LIKE type_file.num5 
   DEFINE l_cnt     LIKE type_file.num5 
   DEFINE l_rec_b   LIKE type_file.num5 
   DEFINE l_ida RECORD LIKE ida_file.*
   DEFINE l_idd  DYNAMIC ARRAY OF RECORD 
                     select    LIKE type_file.chr1,
                     idd01 LIKE idd_file.idd01,
                     idd02 LIKE idd_file.idd02,
                     idd03 LIKE idd_file.idd03,
                     idd04 LIKE idd_file.idd04,
                     idd05 LIKE idd_file.idd05,
                     idd06 LIKE idd_file.idd06,
                     idd22 LIKE idd_file.idd22,
                     idd16 LIKE idd_file.idd16,
                     idd13 LIKE idd_file.idd13,
                     idd18 LIKE idd_file.idd18,
                     idd10 LIKE idd_file.idd10,
                     idd11 LIKE idd_file.idd11
                    END RECORD
   DEFINE l_idd2 RECORD LIKE idd_file.*   
   DEFINE l_tot     LIKE idd_file.idd13
   DEFINE i         LIKE type_file.num5
   DEFINE l_rvu00   LIKE rvu_file.rvu00
   DEFINE l_idd3  RECORD
                     select    LIKE type_file.chr1,
                     idd01 LIKE idd_file.idd01,  
                     idd02 LIKE idd_file.idd02,
                     idd03 LIKE idd_file.idd03,
                     idd04 LIKE idd_file.idd04,
                     idd05 LIKE idd_file.idd05,
                     idd06 LIKE idd_file.idd06,
                     idd22 LIKE idd_file.idd22,
                     idd16 LIKE idd_file.idd16,
                     idd13 LIKE idd_file.idd13,
                     idd18 LIKE idd_file.idd18,
                     idd10 LIKE idd_file.idd10,
                     idd11 LIKE idd_file.idd11
                     END RECORD
   DEFINE l_sql      STRING 
   DEFINE l_idd24    LIKE idd_file.idd24  #入庫否    
 
   DEFINE l_sfs03    LIKE sfs_file.sfs03,           #工單號
          l_sfs04    LIKE sfs_file.sfs04,           #料
          l_sfs06    LIKE sfs_file.sfs06,           #發料單位
          l_sfs10    LIKE sfs_file.sfs10            #作業編號
 
   #若為工單還需由來源單號(工單)找發料單
   SELECT sfb01 FROM sfb_file WHERE sfb01 = g_no
   IF SQLCA.sqlcode = 100 THEN     #非工單
      LET l_sql = "SELECT 'N',idd01,idd02,idd03,idd04, ",
                  "       idd05,idd06,idd22,idd16,idd13,",
                  "       idd18,idd10,idd11,idd24 ",
                  "  FROM idd_file ",
                  " WHERE idd01 = '",g_ida_h.ida01,"'",
                  "  AND idd07 = '",g_ida_h.ida13,"'",
                  "  AND idd10 = '",g_no,"'",
                  "  AND idd11 = ",g_item,
                  "  AND (idd05 || idd06) NOT IN",
                  "      (SELECT ida05 || ida06 FROM ida_file",
                  "        WHERE ida01 = '",g_ida_h.ida01,"'",
                  "          AND ida30 = '",g_no,"'",
                  "          AND ida31 = ",g_item,")",
                  "  AND (idd05 || idd06) NOT IN", 
                  "      (SELECT idd05 || idd06 FROM idd_file",
                  "        WHERE idd01 = '",g_ida_h.ida01,"'",
                  "          AND idd30 = '",g_no,"'",
                  "          AND idd31 = ",g_item,")"
 
   ELSE
      SELECT sfs03,sfs04,sfs06,sfs10 INTO l_sfs03,l_sfs04,l_sfs06,l_sfs10
        FROM sfs_file                     #取得退料單資料
       WHERE sfs01 = g_ida_h.ida07 AND sfs02 = g_ida_h.ida08
 
      LET l_sql = "SELECT 'N',idd01,idd02,idd03,idd04, ",
                  "       idd05,idd06,idd22,idd16,idd13,",
                  "       idd18,idd10,idd11,idd24 ",
                  "  FROM idd_file ",
                  " WHERE idd01 = '",g_ida_h.ida01,"'",
                  "   AND idd07 = '",g_ida_h.ida13,"'",
                  "   AND (idd10 || idd11) IN ",         #原始單據/項次
                  "       (SELECT sfe02 || sfe28 FROM sfp_file,sfe_file ",
                  "         WHERE sfp01 = sfe02 AND sfp06 IN ('1','D') ", #成套發料資料    #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
                  "           AND sfp04 = 'Y' ",                   #已扣賬
                  "           AND sfe01 = '",l_sfs03,"' ",         #工單號
                  "           AND sfe07 = '",l_sfs04,"' ",         #料
                  "           AND sfe17 = '",l_sfs06,"' ",         #發料單位
                  "           AND sfe14 = '",l_sfs10,"' )",        #作業編號
                  "   AND (idd05||idd06) NOT IN",
                  "       (SELECT ida05||ida06 FROM ida_file",
                  "         WHERE ida01 = '",g_ida_h.ida01,"'",
                  "           AND (ida07||ida08) IN ",
                  "               (SELECT sfs01||sfs02 FROM sfp_file,sfs_file ",
                  "                 WHERE sfp01 = sfs01 AND sfp06 = '6' ", 
                  "                   AND sfp04 = 'N' ",           #未扣賬
                  "                   AND sfs03 = '",l_sfs03,"' ", #工單號
                  "                   AND sfs04 = '",l_sfs04,"' ", #料
                  "                   AND sfs06 = '",l_sfs06,"' ", #發料單位
                  "                   AND sfs10 = '",l_sfs10,"'))",#作業編號
                  "   AND (idd05 || idd06) NOT IN",  
                  "       (SELECT idd05 || idd06 FROM idd_file",
                  "         WHERE idd01 = '",g_ida_h.ida01,"'",
                  "           AND idd07 = '",g_ida_h.ida13,"'",
                  "           AND (idd10 || idd11) IN ",
                  "               (SELECT sfe02||sfe28 FROM sfp_file,sfe_file ",
                  "                 WHERE sfp01 = sfe02 AND sfp06 = '6'", #成套退
                  "                   AND sfp04 = 'Y' ",                  #已扣賬
                  "                   AND sfe01 = '",l_sfs03,"' ",        #工單號
                  "                   AND sfe07 = '",l_sfs04,"' ",        #料
                  "                   AND sfe17 = '",l_sfs06,"' ",        #發料單位
                  "                   AND sfe14 = '",l_sfs10,"'))"        #作業編號
   END IF
   PREPARE g_b2_pre FROM l_sql
 
   DECLARE g_b2_cs CURSOR FOR g_b2_pre
   #若為工單還需由來源單號(工單)找發料單
        
 
   LET l_cnt = 1
 
   FOREACH g_b2_cs INTO l_idd3.*,l_idd24
      #若為入庫單號且來源單號為收貨單時，只可出現入庫否='Y' 的刻號資料供挑選
      #若為驗退單號且來源單號為收貨單時，只可出現入庫否='N' 的刻號資料供挑選 
      LET l_rvu00 = ''
      SELECT rvv03 INTO l_rvu00
         FROM rvv_file
        WHERE rvv01 = g_ida_h.ida07   #入庫單號/退貨單號
          AND rvv02 = g_ida_h.ida08   #入庫單號/退貨單號項次
          AND rvv04 = g_no                  #收貨單號  
          AND rvv05 = g_item                #收貨項次
      IF l_rvu00 = '1' THEN 
         IF l_idd24 = 'N' THEN
            CONTINUE FOREACH
         END IF
      END IF
      IF l_rvu00 = '2' THEN
         IF l_idd24 = 'Y' THEN
            CONTINUE FOREACH
         END IF 
      END IF
 
      LET l_idd[l_cnt].* = l_idd3.*
  
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_idd.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
 
   IF l_rec_b = 0 THEN RETURN END IF
   IF p_type = 1 THEN
      LET p_row = 2 LET p_col = 30
      OPEN WINDOW s_icdin_w2 AT p_row,p_col WITH FORM "sub/42f/s_icdin_w2"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("s_icdin_w2")
 
      INPUT ARRAY l_idd WITHOUT DEFAULTS FROM s_idd.*
                 ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE INPUT
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
         
         #同一刻號，要一起勾起或不勾起，要同時
         ON CHANGE select   
            IF NOT cl_null(l_idd[l_ac].select) THEN
               IF l_idd[l_ac].select = 'Y' THEN
             
                  LET l_tot = 0
                  FOR i = 1 TO l_rec_b
                      IF l_idd[l_ac].idd05 = l_idd[i].idd05 THEN
                         LET l_tot = l_tot + l_idd[i].idd13
                      ELSE
                         IF l_idd[i].select = 'Y' THEN
                            LET l_tot = l_tot + l_idd[i].idd13
                         END IF
                      END IF
                  END FOR
                  IF l_tot <= g_ida_h.odds THEN
                     FOR i = 1 TO l_rec_b
                        IF l_idd[l_ac].idd05 = l_idd[i].idd05 THEN
                           LET l_idd[i].select = 'Y'
                           DISPLAY BY NAME l_idd[i].select
                        END IF
                     END FOR
                  END IF
 
               ELSE
                  FOR i = 1 TO l_rec_b
                      IF l_idd[l_ac].idd05 = l_idd[i].idd05
                         THEN
                         LET l_idd[i].select = 'N'
                         DISPLAY BY NAME l_idd[i].select
                      END IF
                  END FOR
               END IF
            END IF
 
 
         AFTER FIELD select
            IF l_idd[l_ac].select NOT MATCHES '[YN]' THEN
               NEXT FIELD select
            END IF
            #檢查勾選的入庫總數是否超過可入庫數量    
            IF l_idd[l_ac].select = 'Y' THEN
               LET l_tot = 0
               FOR i = 1 TO l_rec_b
                   IF l_idd[i].select = 'Y' THEN
                      LET l_tot = l_tot + l_idd[i].idd13
                   END IF
               END FOR
               IF l_tot > g_ida_h.odds THEN
                  CALL cl_err('','sub-174',0)
                  LET l_idd[l_ac].select = 'N'
                  DISPLAY BY NAME l_idd[l_ac].select
                  NEXT FIELD select
               END IF
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
         ON ACTION CONTROLF 
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name               
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)     
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()  
            CONTINUE INPUT    
 
         ON ACTION about   
            CALL cl_about()
 
         ON ACTION help 
            CALL cl_show_help()   
      END INPUT
      CLOSE WINDOW s_icdin_w2
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         RETURN
      END IF
   ELSE
      FOR l_cnt = 1 TO l_rec_b LET l_idd[l_cnt].select = 'Y' END FOR
   END IF
 
   BEGIN WORK
   FOR l_cnt = 1 TO l_rec_b
       IF l_idd[l_cnt].select = 'N' THEN CONTINUE FOR END IF
       SELECT * INTO l_idd2.* FROM idd_file
        WHERE idd01 = g_ida_h.ida01      #料件
          AND idd02 = l_idd[l_cnt].idd02 #倉庫
          AND idd03 = l_idd[l_cnt].idd03 #儲位
          AND idd04 = l_idd[l_cnt].idd04 #批號
          AND idd05 = l_idd[l_cnt].idd05 
          AND idd06 = l_idd[l_cnt].idd06
          AND idd10 = l_idd[l_cnt].idd10
          AND idd11 = l_idd[l_cnt].idd11
       IF SQLCA.sqlcode THEN
          CALL cl_err('ins ida_file',SQLCA.sqlcode,1)
          LET g_flag = 0
          ROLLBACK WORK
          RETURN 
       END IF
       INITIALIZE l_ida.* TO NULL
       LET l_ida.ida01 = g_ida_h.ida01   #料號
       LET l_ida.ida02 = g_ida_h.ida02   #倉庫
       LET l_ida.ida03 = g_ida_h.ida03   #儲位
       LET l_ida.ida04 = g_ida_h.ida04   #批號
       LET l_ida.ida05 = l_idd2.idd05    #刻號
       LET l_ida.ida06 = l_idd2.idd06    #icf
       LET l_ida.ida07 = g_ida_h.ida07   #單據編號
       LET l_ida.ida08 = g_ida_h.ida08   #單據項次
       LET l_ida.ida09 = g_ida_h.ida09   #異動日期
       LET l_ida.ida10 = l_idd2.idd13    #時收數量 
       LET l_ida.ida11 = 0                     #不良數量 
       LET l_ida.ida12 = 0                     #報廢數量
       LET l_ida.ida13 = g_ida_h.ida13   #單位
       #LET l_ida.ida10 = s_digqty(l_ida.ida10,l_ida.ida13)   #FUN-BB0084 #TQC-C60186
       LET l_ida.ida14 = l_idd2.idd15    #母體料號 
       LET l_ida.ida15 = l_idd2.idd16    #母批 
       LET l_ida.ida16 = l_idd2.idd17    #DATECODE
       LET l_ida.ida17 = l_idd2.idd18    #PASS icf
       LET l_ida.ida18 = l_idd2.idd19    #接單料號
       LET l_ida.ida19 = l_idd2.idd20    
       LET l_ida.ida20 = l_idd2.idd21    
       LET l_ida.ida21 = l_idd2.idd22    
       LET l_ida.ida22 = l_idd2.idd23    
       LET l_ida.ida23 = '' 
       LET l_ida.ida24 = '' 
       LET l_ida.ida25 = ''
       LET l_ida.ida26 = '' 
       LET l_ida.ida27 = 'N'                   #轉入否 
       LET l_ida.ida28 = g_ida_h.ida28   #異動別  (出入庫別)
       LET l_ida.ida29 = l_idd2.idd25    #備注
     
       LET l_ida.ida30 = l_idd2.idd10    #來源單號
       LET l_ida.ida31 = l_idd2.idd11    #來源項次
 
       LET l_ida.idaplant = g_plant   #FUN-980012 add
       LET l_ida.idalegal = g_legal   #FUN-980012 add

       IF l_ida.ida17 IS NULL THEN LET l_ida.ida17=0 END IF #TQC-BA0136 
       INSERT INTO ida_file VALUES(l_ida.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins ida_file',SQLCA.sqlcode,1)
          LET g_flag = 0
          ROLLBACK WORK
          RETURN 
       END IF
   END FOR
 
   COMMIT WORK
END FUNCTION
 
FUNCTION s_icdin_passicf_chk()
 #  DEFINE l_imaicd06 LIKE ima_file.ima06,
    DEFINE l_imaicd06 LIKE imaicd_file.imaicd06,      #No.FUN-830073
          l_imaicd04 LIKE imaicd_file.imaicd04,
          l_icf04 LIKE icf_file.icf04
   DEFINE l_flag      LIKE type_file.chr1
 
   LET g_errno = ''
   LET l_imaicd06 = ''
   LET l_imaicd04 = ''
 
   #取得該料件之內編子體(Wafer 料號)料件狀態
   SELECT imaicd06,imaicd04 INTO l_imaicd06,l_imaicd04
      FROM imaicd_file
     WHERE imaicd00 = g_ida_h.ida01
 
   IF l_imaicd04 NOT MATCHES '[24]' THEN RETURN END IF   
 
   LET l_flag = '1'
 
   #case1. 先用該料件號以及icf值串icf_file
   LET l_icf04 = ''
   SELECT icf04 INTO l_icf04
     FROM icf_file
    WHERE icf01 = g_ida_h.ida01
      AND icf02 = g_ida[l_ac].ida06
   IF SQLCA.SQLCODE = 100 THEN
      LET l_flag = '2'
   ELSE
      IF SQLCA.SQLCODE != 0 THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN
      END IF
   END IF
 
   #case2. case1串不到時，改用該料件號的wafer料號(imaicd06) 串icf_file
   IF l_flag = '2' THEN  
      IF NOT cl_null(l_imaicd06) THEN
         SELECT icf04 INTO l_icf04
           FROM icf_file
           WHERE icf01 = l_imaicd06
             AND icf02 = g_ida[l_ac].ida06
         IF SQLCA.SQLCODE = 100 THEN
            LET l_flag = '3'
         ELSE
            IF SQLCA.SQLCODE != 0 THEN
               LET g_errno = SQLCA.SQLCODE
               RETURN
            END IF
         END IF
      ELSE
         LET l_flag = '3'
      END IF
   END IF
 
  #case3. case2也串不到時，再改用傳入參數母體料號來串icf_file 
  IF l_flag = '3' THEN
      SELECT icf04 INTO l_icf04
        FROM icf_file
       WHERE icf01 = g_imaicd01
         AND icf02 = g_ida[l_ac].ida06
      IF SQLCA.SQLCODE THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN
      END IF
   END IF
   
  #Pass icf 不等于'Y' ,則錯誤 
   IF l_icf04 != 'Y' THEN
      LET g_errno = 'sub-179'
   END IF
END FUNCTION 
 
#2.2 已測wafer 控卡：若所輸入同刻號之總die 數超過Gross die ,則警告use 輸入錯誤
FUNCTION s_icdin_die_chk(p_cmd)
   DEFINE l_ida17   LIKE ida_file.ida17
   DEFINE p_cmd          LIKE type_file.chr1
 
   LET g_errno = ' '
  
   IF p_cmd NOT MATCHES '[au]' THEN RETURN END IF
 
   LET l_ida17 = 0
   SELECT SUM(ida17) INTO l_ida17
      FROM ida_file
     WHERE ida01 = g_ida_h.ida01
       AND ida02 = g_ida_h.ida02
       AND ida03 = g_ida_h.ida03
       AND ida04 = g_ida_h.ida04
       AND ida05 = g_ida[l_ac].ida05
   IF cl_null(l_ida17) THEN LET l_ida17 = 0 END IF
 
   IF p_cmd = 'a' THEN
      LET l_ida17 = l_ida17 + g_ida[l_ac].ida17
   END IF
   IF p_cmd = 'u' THEN
      LET l_ida17 = l_ida17 - g_ida_t.ida17 + g_ida[l_ac].ida17
   END IF
   #該料件為已測wafer ,所輸入同刻號之總die 數已超過gross die ,請查核！！
#  IF l_ida17 > g_ida_h.icb05 THEN    #FUN-B30192
   IF l_ida17 > g_ida_h.imaicd14 THEN #FUN-B30192
      LET g_errno = 'sub-180'          
   END IF
END FUNCTION 

#FUN-B30187 --START--
FUNCTION s_icdin_set_required()
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09,
       l_imaicd13 LIKE imaicd_file.imaicd13

   #DateCode否/批號管控否     
   IF NOT cl_null(g_ida_h.ida01) THEN
      SELECT imaicd09,imaicd13 INTO l_imaicd09,l_imaicd13 FROM imaicd_file
       WHERE imaicd00 = g_ida_h.ida01
       IF l_imaicd09 = 'Y' THEN CALL cl_set_comp_required("ida16",TRUE) END IF
       IF l_imaicd13 = 'Y' THEN CALL cl_set_comp_required("ida15",TRUE) END IF
   END IF    
   
END FUNCTION
 
FUNCTION s_icdin_set_no_required()
   CALL cl_set_comp_required("ida15,ida16",FALSE) 
END FUNCTION 
#FUN-B30187 --END--

#FUN-B30182 --START--
FUNCTION s_icdin_multi_ida06(l_multi_ida06,p_type)
DEFINE l_multi_ida06 STRING
DEFINE tok           base.StringTokenizer
DEFINE l_ida RECORD  LIKE ida_file.* 
DEFINE p_type  LIKE type_file.chr1
DEFINE l_count LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5   #TQC-C60023
DEFINE tok1           base.StringTokenizer  #TQC-C60186
DEFINE l_ida10 LIKE ida_file.ida10 #TQC-C60186
#TQC-C60186 
   #TQC-C60186---begin
   LET tok1 = base.StringTokenizer.create(l_multi_ida06,"|")
   LET l_count = 0
   WHILE tok1.hasMoreTokens()
      LET l_ida.ida06 = tok1.nextToken()
      LET l_count = l_count + 1
   END WHILE 
   IF l_count = 1 THEN
      LET l_ida10 = 1
   ELSE
      LET l_ida10 = 0
   END IF 
   #TQC-C60186---end
   LET tok = base.StringTokenizer.create(l_multi_ida06,"|")
   LET l_count = 1
   WHILE tok.hasMoreTokens()
      IF cl_null(g_numf) OR g_numf < 1 THEN LET g_numf = 1 END IF  #TQC-C60023
      IF cl_null(g_numt) OR g_numt < 1 THEN LET g_numt = 1 END IF  #TQC-C60023
      LET l_ida.ida06 = tok.nextToken()
      
      FOR l_i = g_numf TO g_numt   #TQC-C60023 
      #預設
      LET l_ida.ida01 = g_ida_h.ida01
      LET l_ida.ida02 = g_ida_h.ida02 
      LET l_ida.ida03 = g_ida_h.ida03
      LET l_ida.ida04 = g_ida_h.ida04
      LET l_ida.ida07 = g_ida_h.ida07  
      LET l_ida.ida08 = g_ida_h.ida08   
      LET l_ida.ida09 = g_ida_h.ida09   
      LET l_ida.ida10 = 0       
      LET l_ida.ida11 = 0 
      LET l_ida.ida12 = 0 
      LET l_ida.ida13 = g_ida_h.ida13
      LET l_ida.ida14 = g_imaicd01
      LET l_ida.ida15 = g_ida_h.ida15
      LET l_ida.ida16 = ''      
      LET l_ida.ida17 = 0      
      LET l_ida.ida18 = 0     
      LET l_ida.ida19 = '' 
      LET l_ida.ida20 = '' 
      LET l_ida.ida21 = 'N' 
      LET l_ida.ida22 = g_pmniicd15 
      LET l_ida.ida23 = '' 
      LET l_ida.ida24 = '' 
      LET l_ida.ida25 = ''  
      LET l_ida.ida26 = 'Y'   
      LET l_ida.ida27 = 'N' 
      LET l_ida.ida28 = g_ida_h.ida28
      LET l_ida.ida29 = '' 
      LET l_ida.ida30 = ' '    #來源單號
      LET l_ida.ida31 = ' '    #來源項次
      LET l_ida.idaplant = g_plant   
      LET l_ida.idalegal = g_legal   

      #參照第一筆輸入     
      IF NOT cl_null(g_ida[1].ida10) THEN LET l_ida.ida10 = g_ida[1].ida10 END IF   #實收數量
      IF NOT cl_null(g_ida[1].ida15) THEN LET l_ida.ida15 = g_ida[1].ida15 END IF   #母批
      IF NOT cl_null(g_ida[1].ida16) THEN LET l_ida.ida16 = g_ida[1].ida16 END IF   #DATACODE
      IF NOT cl_null(g_ida[1].ida17) THEN LET l_ida.ida17 = g_ida[1].ida17 END IF   #DIE數
      IF NOT cl_null(g_ida[1].ida18) THEN LET l_ida.ida18 = g_ida[1].ida18 END IF   #YIELD(%)
      #TQC-C60023---begin
      #IF NOT cl_null(g_ida[1].ida05) THEN                                           #刻號     
      #   LET l_ida.ida05 = g_ida[1].ida05
      #ELSE 
      #   LET l_ida.ida05 = l_count USING '&&&'       
      #END IF  
      IF g_imaicd04 = '3' OR g_imaicd04 = '4' THEN 
         LET l_ida.ida05 = '000' USING '&&&'
      ELSE 
         LET l_ida.ida05 = l_i USING '&&&'
      END IF 
      #TQC-C60023---end
      #TQC-C60186---begin
      IF l_ida10 = 1 THEN
        LET  l_ida.ida10 = 1
      END IF  
      #TQC-C60186---end 
      CASE p_type
         WHEN '1'
            SELECT icf04 INTO l_ida.ida21 FROM icf_file
               WHERE icf02 =  l_ida.ida06 AND icf01 = l_ida.ida01
         WHEN '2'
            SELECT icf04 INTO l_ida.ida21 FROM icf_file
               WHERE icf02 =  l_ida.ida06 
                AND icf01 IN(SELECT imaicd01 FROM imaicd_file WHERE imaicd00 = l_ida.ida01)
      END CASE 

      IF l_ida.ida17 IS NULL THEN LET l_ida.ida17=0 END IF #TQC-BA0136      
      INSERT INTO ida_file VALUES (l_ida.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('insert ida_file',SQLCA.sqlcode,0)
      END IF
      LET l_count = l_count + 1
      END FOR  #TQC-C60023
   END WHILE
   LET g_multi_flag = 1
END FUNCTION
#FUN-B30182 --END--
#FUN-BA0008  --START--
FUNCTION s_icdin_calc_die()
   DEFINE l_ida05 LIKE ida_file.ida05
   DEFINE l_ida RECORD LIKE ida_file.*
   DEFINE l_sum_ida10  LIKE ida_file.ida10  #FUN-BA0059
   DEFINE l_sum_ida17  LIKE ida_file.ida17
   DEFINE l_ida10 LIKE ida_file.ida10
   DEFINE l_icf05 LIKE icf_file.icf05
   DEFINE l_sql STRING

   IF g_imaicd04 NOT MATCHES '[012]' THEN RETURN END IF
   LET l_sql = "SELECT SUM(ida17) FROM ida_file WHERE ida01=? AND ida02=? ",
               "   AND ida03=? AND ida04=? ",
               "   AND ida05=? ",
               "   AND ida07=? AND ida08=? ",
               "   AND ida17 IS NOT NULL "
   PREPARE calc_die_upd FROM l_sql

   #FUN-BA0059(S)
   #將所有片數歸0,以便後面重新計算
   UPDATE ida_file SET ida10 = 0 ,ida11 = 0
    WHERE ida07 = g_ida_h.ida07
      AND ida08 = g_ida_h.ida08
      AND ida17 IS NOT NULL
      
   LET l_sql = "SELECT SUM(ida10+ida11) FROM ida_file WHERE ida01=? AND ida02=? ",
               "   AND ida03=? AND ida04=?  ",
               "   AND ida05=? AND ida06<>? ",
               "   AND ida07=? AND ida08=?  ",
               "   AND ida17 IS NOT NULL    "
   PREPARE calc_die_upd2 FROM l_sql
   #FUN-BA0059(E)

   LET l_ida05=' '
   DECLARE calc_die_c1 CURSOR FOR 
      SELECT * FROM ida_file WHERE ida07 = g_ida_h.ida07
                               AND ida08 = g_ida_h.ida08
                              ORDER BY ida05,ida17,ida06  #FUN-BA0059 add ida17 
   FOREACH calc_die_c1 INTO l_ida.*
      IF l_ida05 <> l_ida.ida05 THEN
         EXECUTE calc_die_upd INTO l_sum_ida17
           USING l_ida.ida01,l_ida.ida02,l_ida.ida03,
                 l_ida.ida04,l_ida.ida05,
                 l_ida.ida07,l_ida.ida08
      END IF
      IF l_sum_ida17 IS NULL THEN LET l_sum_ida17 = 0 END IF
      IF l_sum_ida17 <> 0 THEN
         LET l_ida10 = l_ida.ida17/l_sum_ida17
         LET l_ida10 = s_trunc(l_ida10,3)
         #FUN-BA0059(S)
         IF l_ida.ida17 > 0 AND l_ida10 = 0 THEN
            LET l_ida10 = 0.001
         END IF
         #計算此刻號片數總合是否>1
         EXECUTE calc_die_upd2 INTO l_sum_ida10
           USING l_ida.ida01,l_ida.ida02,l_ida.ida03,
                 l_ida.ida04,l_ida.ida05,l_ida.ida06,
                 l_ida.ida07,l_ida.ida08
         IF l_sum_ida10 + l_ida10 > 1 THEN
            LET l_ida10 = l_ida10 - (l_sum_ida10 + l_ida10 - 1)
            IF l_ida10 < 0 THEN
               LET l_ida10 = 0
            END IF
         END IF
         #FUN-BA0059(E)
         LET l_icf05=NULL
         SELECT icf05 INTO l_icf05 FROM icf_file 
          WHERE icf01=l_ida.ida01 AND icf02=l_ida.ida06
         IF cl_null(l_icf05) THEN
            SELECT icf05 INTO l_icf05 FROM icf_file 
             WHERE icf01=l_ida.ida14 AND icf02=l_ida.ida06
         END IF
         IF cl_null(l_icf05) THEN LET l_icf05 = '0' END IF
         #LET l_ida10 = s_digqty(l_ida10,l_ida.ida13)    #FUN-BB0084 #TQC-C60186
         CASE l_icf05
            WHEN '0'
               UPDATE ida_file SET ida10 = l7_ida10 ,ida11 = 0, ida12 =0
                WHERE ida01=l_ida.ida01 AND ida02=l_ida.ida02 AND ida03=l_ida.ida03 AND ida04=l_ida.ida04 
                  AND ida05=l_ida.ida05 AND ida06=l_ida.ida06 AND ida07=l_ida.ida07 AND ida08=l_ida.ida08
            OTHERWISE
               UPDATE ida_file SET ida10 = 0 ,ida11 = l_ida10, ida12 =0
                WHERE ida01=l_ida.ida01 AND ida02=l_ida.ida02 AND ida03=l_ida.ida03 AND ida04=l_ida.ida04 
                  AND ida05=l_ida.ida05 AND ida06=l_ida.ida06 AND ida07=l_ida.ida07 AND ida08=l_ida.ida08
         END CASE
      END IF
      LET l_ida05=l_ida.ida05
   END FOREACH

   #尾差攤至片數最大的那筆
   DECLARE calc_die_c2 CURSOR FOR 
      SELECT ida05,SUM(ida10+ida11) FROM ida_file 
       WHERE ida07 = g_ida_h.ida07 AND ida08 = g_ida_h.ida08
       GROUP BY ida05
       ORDER BY ida05 
   FOREACH calc_die_c2 INTO l_ida05,l_ida10
      LET l_ida10 = 1 - l_ida10
      IF l_ida10 > 0 THEN
         INITIALIZE l_ida.* TO NULL
         LET l_sql = "SELECT * FROM ida_file WHERE ida07 = '",g_ida_h.ida07,"'",
                     "   AND ida08 = ",g_ida_h.ida08,
                     "   AND ida05 = '",l_ida05,"'",
                     " AND ida10 < 1 ORDER BY ida10 DESC"
         PREPARE calc_die_p3 FROM l_sql
         EXECUTE calc_die_p3 INTO l_ida.*
         #LET l_ida10 = s_digqty(l_ida10,l_ida.ida13)     #FUN-BB0084 #TQC-C60186
         UPDATE ida_file SET ida10 = ida10 + l_ida10
          WHERE ida01=l_ida.ida01 AND ida02=l_ida.ida02 AND ida03=l_ida.ida03 AND ida04=l_ida.ida04 
            AND ida05=l_ida.ida05 AND ida06=l_ida.ida06 AND ida07=l_ida.ida07 AND ida08=l_ida.ida08
      END IF
   END FOREACH
END FUNCTION
#FUN-BA0008  --END--
#No.FUN-7B0016
