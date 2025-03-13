# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axri020.4gl
# Descriptions...: 發票簿主檔維護
# Date & Author..: 95/02/07 By Danny
# Modi...........: No.A097 031125 ching CH 紅字發票處理
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0100 05/01/05 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560198 05/07/05 By vivien 發票欄位加大后截位修改
# Modify.........: No.FUN-560127 05/07/07 By Nicola 截止發票號碼不應可以小於起始號碼
# Modify.........: No.MOD-560154 05/08/03 By Smapmin 判斷發票號碼是否重複
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-5A0028 05/11/28 By Smapmin 應檢查起訖號碼長度不同，並提示警告訊息.
#                                                    台灣版聯數為2,3應檢查是否為2碼英文8碼數字.
#                                                    並與(amdi010)amb_file之年月字軌號碼作勾稽.
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: NO.TQC-630265 06/03/29 BY yiting 一按"查詢"就出現閒置時間過長
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.MOD-670065 06/07/14 By Nicola cnt1,cnt2改為decimal(10,0)
# Modify.........: No.FUN-680123 06/08/29 By hongmei欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-6B0042 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-710202 07/01/31 By Smapmin 月份需於1~12
# Modify.........: No.TQC-720011 07/02/05 By Smapmin 修改筆數計算
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730064 07/03/15 By Smapmin 字軌的判斷只適用台灣版
# Modify.........: No.MOD-750029 07/05/08 By Smapmin 修正FUN-5B0116
# Modify.........: No.CHI-750013 07/05/09 By kim 補過單
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-840182 08/04/20 By Sarah 將AFTER FIELD oom07裡,判斷流水號不可全為'0'的check點拿掉(因實務上是有可能從00000000開始)
# Modify.........: No.MOD-850264 08/05/26 By claire 輸入截止發票號.程式當掉,調整MOD-840182
# Modify.........: No.FUN-770040 08/06/04 By Smapmin 發票聯數增加4.收據
# Modify.........: No.MOD-870170 08/07/14 By wujie   對于不同的類型，其起始和截至號碼不能重疊，但是實際業務中對于不同的類別一定會有重復編號的情形出現
# Modify.........: No.TQC-870031 08/07/21 By chenyu 類型修改時，發票號碼重復不會報錯
# Modify.........: No.FUN-830148 08/09/23 By dxfwo  將報表輸出改為CR
# Modify.........: No.MOD-960300 09/06/25 By Carrier 發票編號重疊問題處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/19 By hongmei add oom13申報統編
# Modify.........: No.FUN-9B0044 09/11/06 By wujie   5.2SQL转标准语法
# Modify.........: No.TQC-9B0042 09/11/12 By wujie   查询时程序down出 
# Modify.........: No:MOD-9B0121 09/11/18 By Sarah BEFORE INSERT段將g_oom01與g_oom02清空的程式段需mare
# Modify.........: No:FUN-990053 09/09/16 By hongmei s_chkban前先检查aza21 = 'Y'   
# Modify.........: No:MOD-9C0360 09/12/22 By sabrina 抓取amb_file的月份條件調整為區間抓法
# Modify.........: No:MOD-9C0368 09/12/24 By sabrina 將amb03_cs CURSOR定義移到i202_b()段一開始
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20055 10/02/25 By Cockroach 添加oom14,oompos兩字段
# Modify.........: No.FUN-A30030 10/03/23 By Cockroach 添加pos管控
# Modify.........: No:TQC-A40006 10/04/01 By wujie   大陆版去除C选项
# Modify.........: No:TQC-A70123 10/07/29 By xiaofeizhu 修改點擊"已開日期"退出系統BUG
# Modify.........: No:MOD-AA0062 10/10/12 By Dido 檢核統一編號邏輯調整 
# Modify.........: No.TQC-AB0038 10/11/07 By vealxu sybase err
# Modify.........: No:MOD-B20003 11/02/08 By Dido 刪除時需檢核此區間是否已開立發票,若有開立則不可刪除 
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:MOD-B50169 11/05/20 By Dido oom13 設定為必要欄位,若為單一申報則帶預設值 
# Modify.........: No:TQC-B60214 11/06/20 By yinhy 開窗修改發放門店(oom14)的值，點退被出，發放門店的值被還原，但門店名稱的值被清空了
# Modify.........: No:FUN-B70036 11/07/13 By yangxf 資料的狀態須已傳POS否為'1.新增未下傳'，或者已傳POS否為'3.已下傳'，才能刪除！
# Modify.........: No:TQC-B70165 11/07/22 By guoch pos栏位进行隐藏
# Modify.........: No:TQC-B80151 11/08/18 By guoch 发票是否重复检查有bug，进行修正
# Modify.........: No.FUN-B80139 11/08/22 By nanbing oom04增加5.二聯式收銀機發票、6.三聯式收銀機發票 項目
# Modify.........: No.FUN-B90130 11/10/18 By wujie 大陆发票簿改善 
# Modify.........: No.MOD-C10068 12/01/08 By Polly 聯數為收據或不申報，則不需控卡axr-019
# Modify.........: No:FUN-B70075 12/01/18 By nanbing 添加已傳POS否的狀態4.修改中，不下傳
# Modify.........: No.MOD-C10211 12/02/02 By Polly 發票為每月維護時，需多判斷上一個月是否有存在發票號碼
# Modify.........: No.MOD-C30400 12/03/10 By minpp after field oom021 增加檢查是否存在 amdi010 的 amb07 中,若不存在則提示 axr-019 訊息 
# Modify.........: No.MOD-C30062 12/03/08 By Polly 增加判斷，如為大陸地區oom13欄位不用輸入
# Modify.........: No.FUN-C40078 12/04/27 By Lori 增加oma17,oma18,ryc03,並控制 aza26 為 '0.台灣' 時, oom17 才顯示
# Modify.........: No.FUN-C50034 12/05/09 By pauline 修正當進入單身時程式會關閉問題
# Modify.........: No.MOD-CA0111 12/10/19 By Polly 同一區段發票編號檢核不可重覆
# Modify.........: No.TQC-CA0054 12/10/24 By SunLM oom16赋初始值为 ' '
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_oom01         LIKE oom_file.oom01,
    g_oom02         LIKE oom_file.oom02,
    g_oom021        LIKE oom_file.oom021,
    g_oom01_t       LIKE oom_file.oom01,
    g_oom02_t       LIKE oom_file.oom02,
    g_oom021_t       LIKE oom_file.oom021,
    g_oom11         LIKE oom_file.oom11,    #起始流水位數
    g_oom12         LIKE oom_file.oom12,    #截止流水位數
    g_oom           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        oom03       LIKE oom_file.oom03,
        oom04       LIKE oom_file.oom04,
        oom05       LIKE oom_file.oom05,
        oom06       LIKE oom_file.oom06,
#No.FUN-B90130 --begin 
        oom15       LIKE oom_file.oom15,
        oom16       LIKE oom_file.oom16,   
#No.FUN-B90130 --end
        oom07       LIKE oom_file.oom07,
        oom08       LIKE oom_file.oom08,
        oom17       LIKE oom_file.oom17,      #FUN-C40078 Add
        oom09       LIKE oom_file.oom09,
        oom10       LIKE oom_file.oom10,
       #cnt1        LIKE cre_file.cre08,      #FUN-C40078 Mark #No.FUN-680123 DECIMAL(10,0)
       #cnt2        LIKE cre_file.cre08,      #FUN-C40078 Mark  #No.FUN-680123 DECIMAL(10,0) 
        cnt1        LIKE type_file.num10,      #FUN-C40078 
        cnt2        LIKE type_file.num10,      #FUN-C40078 
        oom13       LIKE oom_file.oom13,        #FUN-970108 add       
        oom14       LIKE oom_file.oom14,      #FUN-A20055 ADD
        oom14_desc  LIKE azp_file.azp02,      #FUN-A20055 ADD
        oom18       LIKE oom_file.oom18,      #FUN-C40078 Add
        ryc03       LIKE ryc_file.ryc03,      #FUN-C40078 Add
        oompos      LIKE oom_file.oompos      #FUN-A20055 ADD
                    END RECORD,
    g_oom_t         RECORD                     #程式變數 (舊值)
        oom03       LIKE oom_file.oom03,
        oom04       LIKE oom_file.oom04,
        oom05       LIKE oom_file.oom05,
        oom06       LIKE oom_file.oom06,
#No.FUN-B90130 --begin 
        oom15       LIKE oom_file.oom15,
        oom16       LIKE oom_file.oom16,   
#No.FUN-B90130 --end
        oom07       LIKE oom_file.oom07,
        oom08       LIKE oom_file.oom08,
        oom17       LIKE oom_file.oom17,      #FUN-C40078 Add
        oom09       LIKE oom_file.oom09,
        oom10       LIKE oom_file.oom10,
       #cnt1        LIKE cre_file.cre08,      #FUN-C40078 Mark #No.FUN-680123 DECIMAL(10,0)
       #cnt2        LIKE cre_file.cre08,      #FUN-C40078 Mark #No.FUN-680123 DECIMAL(10,0)
        cnt1        LIKE type_file.num10,      #FUN-C40078
        cnt2        LIKE type_file.num10,      #FUN-C40078  
        oom13       LIKE oom_file.oom13,        #FUN-970108 add
        oom14       LIKE oom_file.oom14,      #FUN-A20055 ADD
        oom14_desc  LIKE azp_file.azp02,      #FUN-A20055 ADD
        oom18       LIKE oom_file.oom18,      #FUN-C40078 Add
        ryc03       LIKE ryc_file.ryc03,      #FUN-C40078 Add
        oompos      LIKE oom_file.oompos      #FUN-A20055 ADD
                    END RECORD,
    g_tot1,g_tot2   LIKE type_file.num20,      #No.TQC-9B0042
    g_wc,g_sql      string,                    #No.FUN-580092 HCN  
    g_rec           LIKE type_file.num5,       #單身筆數 #No.FUN-680123 SMALLINT
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT #No.FUN-680123 SMALLINT
    l_sl            LIKE type_file.num5        #目前處理的SCREEN LINE #No.FUN-680123 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(72)
DEFINE g_rec_b      LIKE type_file.num5        #No.FUN-680123 SMALLINT

--mi
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_table        STRING,                      ### FUN-830148 ###                                                                   
       g_str          STRING                       ### FUN-830148 ### 
         
MAIN
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680123  SMALLINT
    OPTIONS                                          #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
 
### *** FUN-830148 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "oom01.oom_file.oom01,",
                "oom02.oom_file.oom02,",
                "oom03.oom_file.oom03,",
                "oom04.oom_file.oom04,",
                "oom05.oom_file.oom05,",
                "oom06.oom_file.oom06,",
                "oom07.oom_file.oom07,",
                "oom08.oom_file.oom08,",
                "oom17.oom_file.oom17,",       #FUN-C40078 Add
                "oom09.oom_file.oom09,",
                "oom10.oom_file.oom10,",
                "l_cnt1.type_file.num5,",
                "l_cnt2.type_file.num5,",
                "oom13.oom_file.oom13,",       #FUN-970108 add
                "oom18.oom_file.oom18"         #FUN-C40078 Add
    LET l_table = cl_prt_temptable('axri020',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                        
                " VALUES(?, ?, ?, ?, ?, ?,                                                                                    
                         ?, ?, ?, ?, ?, ?,?,?,?)"  #FUN-C40078 add ?,?    #FUN-970108 ?                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
    LET g_oom01 =NULL                      #清除鍵值
    LET g_oom02 =NULL                      #清除鍵值
    LET g_oom021 =NULL                      #清除鍵值
    LET g_oom01_t = NULL
    LET g_oom02_t = NULL
    LET g_oom021_t = NULL
    LET p_row = 3 LET p_col = 10
#No.FUN-B90130 --begin  
#    IF g_aza.aza26 = '2' THEN  #No.A097
#      OPEN WINDOW i020_w AT p_row,p_col              #顯示畫面
#        WITH FORM "gxr/42f/gxri020"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    ELSE
#      OPEN WINDOW i020_w AT p_row,p_col              #顯示畫面
#        WITH FORM "axr/42f/axri020"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    END IF
   OPEN WINDOW i020_w AT p_row,p_col              #顯示畫面
     WITH FORM "axr/42f/axri020"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#No.FUN-B90130 --end 

   IF g_azw.azw04<>'2' THEN      #FUN-A20055 ADD
      CALL cl_set_comp_visible('oom14,oom14_desc',FALSE)
   ELSE
      CALL cl_set_comp_visible('oom14,oom14_desc',TRUE)
    #TQC-B70165 --begin mark
     # IF g_aza.aza88 = 'N' THEN
     #    CALL cl_set_comp_visible('oompos',FALSE)
     # ELSE
     #    CALL cl_set_comp_visible('oompos',TRUE)
     # END IF
    #TQC-B70165 --end  mark
   END IF
   #TQC-B70165  --begin
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('oompos',FALSE)
   ELSE
      CALL cl_set_comp_visible('oompos',TRUE)
   END IF
   #TQC-B70165  --end
   #No.FUN-B90130 --begin
   IF g_aza.aza26 <> '2' THEN
      CALL cl_set_comp_visible('oom15,oom16',FALSE)
   ELSE   
      CALL cl_set_comp_visible('oom13',FALSE)
   END IF   
   #No.FUN-B90130 --end

    #FUN-C40078--Add Begin-------
    IF g_aza.aza26 <> '0' THEN
       CALL cl_set_comp_visible('oom17',FALSE)
    ELSE
       CALL cl_set_comp_visible('oom17',TRUE)
    END IF
    #FUN-C40078--Add End---------

    CALL cl_ui_init()
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION i020_cs()
    CLEAR FORM                             #清除畫面
    CALL g_oom.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INITIALIZE g_oom01 TO NULL    #No.FUN-750051
    INITIALIZE g_oom02 TO NULL    #No.FUN-750051
    INITIALIZE g_oom021 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON oom01,oom02,oom021,
                      oom03,oom04,oom05,oom06,oom15,oom16,oom07,oom08,oom17,       #FUN-C40078 Add
                      oom09,oom10,oom13,oom14,oom18,oompos                         #FUN-C40078 Add
                 FROM oom01,oom02,oom021,
                      oom03,oom04,oom05,oom06,oom15,oom16,oom07,oom08,oom17,       #FUN-C40078 Add
                      oom09,oom10,oom13,oom14,oom18,oompos                         #FUN-C40078 Add
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION qbe_select
        CALL cl_qbe_select()
      ON ACTION qbe_save
        CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oomuser', 'oomgrup')
 
    LET g_sql= "SELECT UNIQUE oom01,oom02,oom021 FROM oom_file ", 
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i020_prepare FROM g_sql      #預備一下
    DECLARE i020_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i020_prepare
   LET g_sql="SELECT COUNT(*) FROM ",
             " (SELECT COUNT(*) FROM oom_file WHERE ",g_wc CLIPPED,
           # " GROUP BY oom01,oom02,oom021)"                          #TQC-AB0038 mark
             " GROUP BY oom01,oom02,oom021) t "                       #TQC-AB0038  add 
   PREPARE i020_precount FROM g_sql
   DECLARE i020_count CURSOR FOR i020_precount
END FUNCTION
 
FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL i020_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL i020_q()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL i020_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL i020_o()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
 
           WHEN "exporttoexcel"
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel
                  (ui.Interface.getRootNode(),base.TypeInfo.create(g_oom),'','')
               END IF
           WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_oom01 IS NOT NULL THEN
                  LET g_doc.column1 = "oom01"
                  LET g_doc.column2 = "oom02"
                  LET g_doc.column3 = "oom021"
                  LET g_doc.value1 = g_oom01
                  LET g_doc.value2 = g_oom02
                  LET g_doc.value3 = g_oom021
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i020_a()
   #FUN-C40078--Add Begin-------
    IF g_aza.aza26 = '0' THEN
       CALL cl_set_comp_entry('oom17',FALSE)
    END IF
    #FUN-C40078--Add End---------

    MESSAGE ""
    CLEAR FORM
   CALL g_oom.clear()
    INITIALIZE g_oom01 LIKE oom_file.oom01
    INITIALIZE g_oom02 LIKE oom_file.oom02
    INITIALIZE g_oom021 LIKE oom_file.oom021
    LET g_oom01_t = NULL
    LET g_oom02_t = NULL
    LET g_oom021_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i020_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_oom.clear()
        LET g_rec_b = 0
 
        CALL i020_b()                      #輸入單身
        LET g_oom01_t = g_oom01            #保留舊值
        LET g_oom02_t = g_oom02            #保留舊值
        LET g_oom021_t = g_oom021          #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i020_u()
    #FUN-C40078--Add Begin-------
    IF g_aza.aza26 = '0' THEN
       CALL cl_set_comp_entry('oom17',FALSE)
    END IF
    #FUN-C40078--Add End---------

    IF g_oom01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oom02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oom021 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oom01_t = g_oom01
    LET g_oom02_t = g_oom02
    LET g_oom021_t = g_oom021
    BEGIN WORK
    WHILE TRUE
        CALL i020_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_oom01=g_oom01_t
            LET g_oom02=g_oom02_t
            LET g_oom021=g_oom021_t
            DISPLAY g_oom01,g_oom02,g_oom021 TO oom01,oom02,oom021
                                                  #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_oom01 != g_oom01_t THEN        #更改單頭值
            UPDATE oom_file SET oom01 = g_oom01, #更新DB
                                oom02 = g_oom02,
                                oom021= g_oom021
                          WHERE oom01 = g_oom01_t          #COLAUTH?
                            AND oom02 = g_oom02_t
                            AND oom021= g_oom021_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oom_file",g_oom01_t,g_oom02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660116
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i020_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改 #No.FUN-680123 VARCHAR(1)
    l_n             LIKE type_file.num5,     #No.FUN-680123 SMALLINT
    l_oom01         LIKE oom_file.oom01,
    l_oom02         LIKE oom_file.oom02,
    l_cnt           LIKE type_file.num5      #MOD-C30400 add
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_oom01,g_oom02,g_oom021 WITHOUT DEFAULTS FROM oom01,oom02,oom021
 
 
        AFTER FIELD oom02
           IF NOT cl_null(g_oom02) THEN
              IF g_oom02 < 1 OR g_oom02 > 12 THEN NEXT FIELD oom02 END IF   #MOD-710202
              LET g_oom021 = g_oom02 + 1
              DISPLAY g_oom021 TO oom021
              SELECT COUNT(*) INTO l_n FROM oom_file    #判斷發票年月是否重覆
                 WHERE oom01=g_oom01                    #01/11/16 增
                  AND  oom02=g_oom02                    #例 2001/1-1 與2001/1-2
              IF  l_n >0 THEN                           #同時存在是錯的
                  CALL cl_err(g_oom01,-239,0)
                  NEXT FIELD oom02
              END IF
              SELECT COUNT(*) INTO l_n FROM oom_file    #判斷發票年月是否重覆
               WHERE oom01=g_oom01                      #01/11/16 增
                 AND oom021=g_oom02                     #例 2001/1-2 與2001/2-3
              IF  l_n >0 THEN                           #同時存在是錯的
                  CALL cl_err(g_oom01,-239,0)
                  NEXT FIELD oom02
              END IF
           END IF
 
        AFTER FIELD oom021
           IF NOT cl_null(g_oom02) THEN
              IF g_oom021 < 1 OR g_oom021 > 12 THEN NEXT FIELD oom021 END IF   #MOD-710202
              IF g_oom021 < g_oom02 THEN NEXT FIELD oom02 END IF
              #MOD-C30400--ADD--STR
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM amb_file 
               WHERE amb01=g_oom01
                AND  amb02=g_oom02
                AND  amb07=g_oom021
               IF l_cnt =0 THEN
                  CALL cl_err(g_oom021,'axr-019',1)
                  NEXT FIELD  oom021
               END IF
              #MOD-C30400--ADD--END
              SELECT UNIQUE oom01,oom02,oom021
                FROM oom_file WHERE oom01=g_oom01 AND oom02=g_oom02
                                AND oom021=g_oom021
              IF NOT STATUS THEN
                 CALL cl_err(g_oom01,-239,0)
                 LET g_oom01=g_oom01_t
                 LET g_oom02=g_oom02_t
                 LET g_oom021=g_oom021_t
                 NEXT FIELD oom01
              END IF
           END IF
 
        AFTER INPUT     #97/05/22 modify
          IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i020_q()
 
    --mi
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_oom01 TO NULL        #No.FUN-6B0042
    --#
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i020_cs()                    #取得查詢條件
    IF INT_FLAG THEN   LET INT_FLAG = 0 RETURN END IF
    --mi
   #FUN-C40078--Mark Begin---
   #OPEN i020_count
   #FETCH i020_count INTO g_row_count
   #DISPLAY g_row_count TO FORMONLY.cnt  #FUN-A20055 MARK
   #FUN-C40078--Mark End----
    --#
    OPEN i020_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err(g_oom01,SQLCA.sqlcode,0)
        INITIALIZE g_oom01 TO NULL
    ELSE
        CALL i020_fetch('F')            #讀出TEMP第一筆並顯示
        #FUN-C40078--Add Begin---
        OPEN i020_count
        FETCH i020_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        #FUN-C40078--Add End-----
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i020_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式   #No.FUN-680123 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數 #No.FUN-680123 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i020_bcs INTO g_oom01,g_oom02,g_oom021
        WHEN 'P' FETCH PREVIOUS i020_bcs INTO g_oom01,g_oom02,g_oom021
        WHEN 'F' FETCH FIRST    i020_bcs INTO g_oom01,g_oom02,g_oom021
        WHEN 'L' FETCH LAST     i020_bcs INTO g_oom01,g_oom02,g_oom021
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i020_bcs INTO g_oom01,g_oom02,g_oom021 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_oom01,SQLCA.sqlcode,0)
        INITIALIZE g_oom01  TO NULL  #TQC-6B0105
        INITIALIZE g_oom02  TO NULL  #TQC-6B0105
        INITIALIZE g_oom021 TO NULL  #TQC-6B0105
    ELSE
        CALL i020_show()
        CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i020_show()
    DISPLAY g_oom01,g_oom02,g_oom021
         TO oom01,oom02,oom021 #單頭
    CALL i020_bf(g_wc)         #單身
    DISPLAY g_tot1,g_tot2 TO tot1,tot2
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

#單身
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680123 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680123 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680123 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680123 VARCHAR(1)
    l_cnt           LIKE type_file.num5,      #No.FUN-680123 SMALLINT
    l_oom02         LIKE oom_file.oom02,
    l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680123 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680123 SMALLINT
DEFINE l_i          LIKE type_file.num5       #FUN-560198        #No.FUN-680123 SMALLINT
DEFINE l_j          LIKE type_file.num5       #MOD-5A0028        #No.FUN-680123 SMALLINT
DEFINE l_amb03      LIKE amb_file.amb03       #MOD-5A0028
DEFINE l_oompos     LIKE oom_file.oompos      #FUN-B70075 ADD  
DEFINE l_yy         LIKE oom_file.oom02       #MOD-C10211 add

    LET g_action_choice = ""
    IF g_oom01 IS NULL THEN RETURN END IF
    IF g_oom02 IS NULL THEN RETURN END IF
    

    CALL cl_opmsg('b')

    DECLARE amb03_cs CURSOR FOR
       SELECT amb03 FROM amb_file
        WHERE amb01 = g_oom01
          AND amb02 <= g_oom02    #MOD-9C0360 = modify <= 
          AND amb07 >= g_oom021   #MOD-9C0360 = modify >=
 
    LET g_forupd_sql = " SELECT oom03,oom04,oom05,oom06,oom15,oom16,oom07,oom08,",       #No.FUN-560198  #No.FUN-B90130 
                       "        oom17,",                                                 #FUN-C40078 Add oom17                     
                       "        oom09,oom10,0,0,oom13,oom14,'',",
                       "        oom18,'',",                                              #FUN-C40078 Add oom18,''
                       "        oompos,oom11,oom12,oom01,oom02,oom021", #FUN-A20055 ADD OOM14,OOMPOS        #wujie 091021
                       "  FROM oom_file  ",
                       " WHERE oom01 =? ",
                       "   AND oom02 =? ",
                       "   AND oom021=? ",
                       "   AND oom03 =? ",
                       "   AND oom04 =? ",
                       "   AND oom05 =? ",
                       "   AND oom15 =? "   #No.FUN-B90130
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        IF g_rec_b=0 THEN CALL g_oom.clear() END IF
 
 
        INPUT ARRAY g_oom WITHOUT DEFAULTS FROM s_oom.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
            #FUN-C40078--Add Begin---
            CALL cl_set_comp_entry('oom17',FALSE)
           #IF g_oom[l_ac].oom17 = 'Y' OR p_cmd = 'u' THEN  #FUN-C50034 mark
           #   CALL i020_set_no_entry()
           #ELSE
           #   CALL i020_set_entry()
           #END IF
           #FUN-C50034 mark
            #FUN-C40078--Add End-----
        
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           # BEGIN WORK                #FUN-B70075 MARK
            IF g_rec_b >= l_ac THEN
                LET g_oom_t.* = g_oom[l_ac].*  #BACKUP
                LET p_cmd='u'
               #FUN-C50034 add START
                IF g_oom[l_ac].oom17 = 'Y' THEN   #FUN-C50034 add
                   CALL i020_set_no_entry()
                ELSE                              #FUN-C50034 add
                   CALL i020_set_entry()          #FUN-C50034 add
                END IF                            #FUN-C50034 add
               #FUN-C50034 add END
                #FUN-B70075 Add Begin---
                IF g_aza.aza88 = 'Y' THEN
                   UPDATE oom_file SET oompos = '4'
                    WHERE oom01 = g_oom01 AND oom02 = g_oom02
                      AND oom021 = g_oom021
                      AND oom03 = g_oom_t.oom03
                      AND oom04 = g_oom_t.oom04 AND oom05 = g_oom_t.oom05
                      AND oom15 = g_oom_t.oom15    
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","oom_file",g_oom01_t,"",SQLCA.sqlcode,"","",1)
                      LET l_lock_sw = 'Y'
                   END IF
                   LET l_oompos = g_oom[l_ac].oompos
                   LET g_oom[l_ac].oompos = '4'
                   DISPLAY BY NAME g_oom[l_ac].oompos
                END IF
                BEGIN WORK
                #FUN-B70075 Add End-----
                OPEN i020_bcl USING g_oom01,g_oom02,g_oom021,g_oom_t.oom03,g_oom_t.oom04,g_oom_t.oom05,g_oom_t.oom15    #No.FUN-B90130
                IF STATUS THEN
                   CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                   CLOSE i020_bcl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH i020_bcl INTO g_oom[l_ac].*,g_oom11,g_oom12,g_oom01,g_oom02,g_oom021  #wujie 091021
                IF SQLCA.sqlcode THEN
                   CALL cl_err('',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   #LET g_oom_t.*=g_oom[l_ac].*  #No.TQC-B60214
                   IF l_ac <= l_n then                   #DISPLAY NEWEST
                      IF NOT cl_null(g_oom11) AND NOT cl_null(g_oom12) THEN
                         LET g_oom[l_ac].cnt1 = g_oom[l_ac].oom08[g_oom11,g_oom12]-
                                                g_oom[l_ac].oom07[g_oom11,g_oom12]+1
                         LET g_oom[l_ac].cnt2 = g_oom[l_ac].oom09[g_oom11,g_oom12]-
                                                g_oom[l_ac].oom07[g_oom11,g_oom12]+1
                      END IF
                      IF cl_null(g_oom[l_ac].cnt1) THEN LET g_oom[l_ac].cnt1=0 END IF
                      IF cl_null(g_oom[l_ac].cnt2) THEN LET g_oom[l_ac].cnt2=0 END IF
                      IF NOT cl_null(g_oom[l_ac].oom14) THEN   #FUN-A20055
                         SELECT azp02 INTO g_oom[l_ac].oom14_desc
                           FROM azp_file
                          WHERE azp01=g_oom[l_ac].oom14
                         DISPLAY  BY NAME g_oom[l_ac].oom14_desc
                      END IF
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
             CALL i020_set_no_required()  #FUN-970108 
             CALL i020_set_required()     #FUN-970108
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_oom[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_oom[l_ac].* TO s_oom.*
              CALL g_oom.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_oom[l_ac].oom16 IS NULL THEN LET g_oom[l_ac].oom16 = ' ' END IF #TQC-CA0054 add

            INSERT INTO oom_file(oom01,oom02,oom021,oom03,oom04,
                                 oom05,oom06,oom07,oom08,
                                 oom17,                            #FUN-C40078 Add oom17
                                 oom09,oom10,
                                 oom11,oom12,oom13,                #No.FUN-560198 #FUN-970108
                                 oom14,oom18,oompos,               #FUN-C40078 Add oom18       #FUN-A20055 ADD
                                 oomuser,oomgrup,oommodu,oomdate,oomoriu,oomorig,oom15,oom16)  #No.FUN-B90130 add oom15,oom16
                    VALUES(g_oom01,g_oom02,g_oom021,g_oom[l_ac].oom03,
                           g_oom[l_ac].oom04,g_oom[l_ac].oom05,
                           g_oom[l_ac].oom06,g_oom[l_ac].oom07,
                           g_oom[l_ac].oom08,
                           g_oom[l_ac].oom17,                    #FUN-C40078 Add
                           g_oom[l_ac].oom09,
                           g_oom[l_ac].oom10,
                           g_oom11,g_oom12,g_oom[l_ac].oom13,     #No.FUN-560198 #FUN-970108
                           g_oom[l_ac].oom14,           #FUN-A20055 ADD
                           g_oom[l_ac].oom18,
                           g_oom[l_ac].oompos,          #FUN-A20055 ADD
                           g_user,g_grup,' ',g_today, g_user, g_grup,g_oom[l_ac].oom15,g_oom[l_ac].oom16)      #No.FUN-980030 10/01/04  insert columns oriu, orig #No.FUN-B90130 add oom15,oom16 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","oom_file",g_oom01,g_oom[l_ac].oom03,SQLCA.sqlcode,"","",1)  #No.FUN-660116
                CANCEL INSERT
            ELSE
                CALL i020_tot()
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            BEGIN WORK                     #FUN-B70075 ADD
            LET p_cmd='a'
            INITIALIZE g_oom[l_ac].* TO NULL      #900423
            LET g_oom_t.* = g_oom[l_ac].*         #新輸入資料
            LET g_oom[l_ac].oom03='1'
            LET g_oom[l_ac].oom17='N'             #FUN-C40078
            CALL i020_set_entry()                 #FUN-C40078
           #-MOD-B50169-add-
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM ama_file
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt = 1 THEN
               SELECT ama02 INTO g_oom[l_ac].oom13 
                 FROM ama_file
            END IF 
           #-MOD-B50169-end-
            #LET g_oom[l_ac].oompos = 'N'          #FUN-A20055 add
            LET g_oom[l_ac].oompos = '1'          #FUN-B40071
            LET l_oompos = '1'                    #FUN-B70075 ADD
#No.FUN-B90130 --begin
            IF g_aza.aza26 <> '2' THEN  
               LET g_oom[l_ac].oom15 = ' ' 
            END IF  
#No.FUN-B90130 --end
            DISPLAY BY NAME g_oom[l_ac].oompos  
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oom03
 
        AFTER FIELD oom04
          IF NOT cl_null(g_oom[l_ac].oom04) THEN
#No.FUN-B90130 --begin   
#             IF g_aza.aza26 = '2' THEN     #No.A097
#                #IF g_oom[l_ac].oom04 NOT MATCHES'[ABX]' THEN     #No.TQC-A40006 #No.MOD-B80299 mark
#                 IF g_oom[l_ac].oom04 NOT MATCHES'[ABC]' THEN     #No.MOD-B80299 add
#                    NEXT FIELD oom04
#                 END IF
#             ELSE
                 IF g_oom[l_ac].oom04 NOT MATCHES'[023X456]' THEN   #FUN-770040 #FUN-B80139 增加56
                    NEXT FIELD oom04
                 END IF
#             END IF
#No.FUN-B90130 --end             
             IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oom[l_ac].oom04 <> g_oom_t.oom04 
                            OR g_oom[l_ac].oom07 <> g_oom_t.oom07
                            OR g_oom[l_ac].oom08 <> g_oom_t.oom08  OR g_oom[l_ac].oom16 <> g_oom_t.oom16) THEN   #No.FUN-B90130 
                CALL i020_check()
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_oom[l_ac].oom04,g_errno,1)
                   NEXT FIELD oom04
                END IF
             END IF
          END IF
 
        BEFORE FIELD oom05                            #default 序號
            IF g_oom[l_ac].oom05 IS NULL OR g_oom[l_ac].oom05 = 0 THEN
                SELECT max(oom05)+1 INTO g_oom[l_ac].oom05
                   FROM oom_file WHERE oom01 = g_oom01
                                   AND oom02 = g_oom02
                                   AND oom021= g_oom021
                                   AND oom03 = g_oom[l_ac].oom03
                                   AND oom04 = g_oom[l_ac].oom04
                IF g_oom[l_ac].oom05 IS NULL THEN
                    LET g_oom[l_ac].oom05 = 1
                END IF
                DISPLAY g_oom[l_ac].oom05 TO s_oom[l_sl].oom05
            END IF
 
        AFTER FIELD oom05                        #check 序號是否重複
            IF NOT cl_null(g_oom[l_ac].oom05) THEN
               IF g_oom[l_ac].oom05 != g_oom_t.oom05 OR
                  g_oom[l_ac].oom04 != g_oom_t.oom04 OR
                  g_oom[l_ac].oom03 != g_oom_t.oom03 OR
                  g_oom_t.oom05 IS NULL THEN
                  SELECT count(*) INTO l_n FROM oom_file
                      WHERE oom01 = g_oom01
                        AND oom02 = g_oom02
                        AND oom021= g_oom021
                        AND oom03 = g_oom[l_ac].oom03
                        AND oom04 = g_oom[l_ac].oom04
                        AND oom05 = g_oom[l_ac].oom05
                  IF l_n > 0 THEN
                      LET g_oom[l_ac].oom05 = g_oom_t.oom05
                      CALL cl_err('',-239,0)
                      NEXT FIELD oom03
                  END IF
               END IF
            END IF
        AFTER FIELD oom06
          IF NOT cl_null(g_oom[l_ac].oom06) THEN
             IF g_oom[l_ac].oom06 NOT MATCHES '[12]' THEN
                NEXT FIELD oom06
             END IF
          END IF
 
        AFTER FIELD oom07
          IF NOT cl_null(g_oom[l_ac].oom07) THEN
              IF g_aza.aza26 = '0' AND g_oom[l_ac].oom04 MATCHES '[2356]' THEN #FUN-B80139 增加56
                 IF length(g_oom[l_ac].oom07) <> '10' THEN
                    CALL cl_err('','axr-021',0)
                    NEXT FIELD oom07
                 END IF
                 FOR l_j = 1 TO 2
                    IF g_oom[l_ac].oom07[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                         CALL cl_err('','axr-017',0)
                         NEXT FIELD oom07
                    END IF
                 END FOR
                 FOR l_j = 3 TO 10
                     IF g_oom[l_ac].oom07[l_j,l_j] NOT MATCHES '[0-9]' THEN
                        CALL cl_err('','axr-018',0)
                        NEXT FIELD oom07
                     END IF
                 END FOR
              END IF
             #IF g_aza.aza26 = '0' THEN                                                    #MOD-730064 #MOD-C100
              IF g_aza.aza26 = '0' AND g_oom[l_ac].oom04 NOT MATCHES '[4X]' THEN           #MOD-C10068 add
                 LET l_amb03 = ' '
                 FOREACH amb03_cs INTO l_amb03
                    IF g_oom[l_ac].oom07[1,2] <> l_amb03 THEN
                       CONTINUE FOREACH
                    ELSE
                       EXIT FOREACH
                    END IF
                 END FOREACH
                 IF g_oom[l_ac].oom07[1,2] <> l_amb03 THEN
                    CALL cl_err('','axr-019',0)
                    NEXT FIELD oom07
                 END IF
              END IF   #MOD-730064
             CALL i020_oom11(g_oom[l_ac].oom07) #MOD-850264 cancel mark
             IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oom[l_ac].oom04 <> g_oom_t.oom04
                            OR g_oom[l_ac].oom07 <> g_oom_t.oom07
                            OR g_oom[l_ac].oom08 <> g_oom_t.oom08  OR g_oom[l_ac].oom16 <> g_oom_t.oom16) THEN   #No.FUN-B90130
                CALL i020_check()
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_oom[l_ac].oom07,g_errno,1)
                   NEXT FIELD oom07
                END IF
             END IF
            #-------------MOD-CA0111-----------------(S)
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt
               FROM oom_file
              WHERE oom01 = g_oom01
                AND oom02 = g_oom02
                AND oom021= g_oom021
                AND oom07 = g_oom[l_ac].oom07
             IF l_cnt > 0 THEN
                CALL cl_err(g_oom[l_ac].oom07,'alm-953',1)
                NEXT FIELD oom07
             END IF
             LET l_cnt = 0
            #-------------MOD-CA0111-----------------(E)
            #---------------------------------MOD-C10211----------------------------------start
             IF g_oom02 = g_oom021 THEN
                LET l_yy = g_oom02 -1
                SELECT COUNT(*) INTO l_cnt
                  FROM oom_file
                 WHERE oom01 = g_oom01
                   AND oom02 = l_yy
                   AND oom021= oom02
                   AND oom07 = g_oom[l_ac].oom07
                IF l_cnt > 0 THEN
                   CALL cl_err(g_oom[l_ac].oom07,'alm-953',1)
                   NEXT FIELD oom07
                END IF
             END IF
            #---------------------------------MOD-C10211------------------------------------end
             DISPLAY BY NAME g_oom[l_ac].oom07
         END IF
 
           IF cl_null(g_oom[l_ac].oom08) THEN
              LET g_oom[l_ac].oom08 = g_oom[l_ac].oom07
              DISPLAY BY NAME g_oom[l_ac].oom08
           END IF
 
        AFTER FIELD oom08
          IF NOT cl_null(g_oom[l_ac].oom08) THEN
              IF g_aza.aza26 = '0' AND g_oom[l_ac].oom04 MATCHES '[2356]' THEN #FUN-B80139 增加56
                 IF length(g_oom[l_ac].oom08) <> '10' THEN
                    CALL cl_err('','axr-021',0)
                    NEXT FIELD oom08
                 END IF
                 FOR l_j = 1 TO 2
                    IF g_oom[l_ac].oom08[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                       CALL cl_err('','axr-017',0)
                       NEXT FIELD oom08
                    END IF
                 END FOR
                 FOR l_j = 3 TO 10
                     IF g_oom[l_ac].oom08[l_j,l_j] NOT MATCHES '[0-9]' THEN
                        CALL cl_err('','axr-018',0)
                        NEXT FIELD oom08
                     END IF
                 END FOR
              END IF
             #IF g_aza.aza26 = '0' THEN                                                    #MOD-730064 #MOD-C100
              IF g_aza.aza26 = '0' AND g_oom[l_ac].oom04 NOT MATCHES '[4X]' THEN           #MOD-C10068 add
                 LET l_amb03 = ' '
                 FOREACH amb03_cs INTO l_amb03
                    IF g_oom[l_ac].oom08[1,2] <> l_amb03 THEN
                       CONTINUE FOREACH
                    ELSE
                       EXIT FOREACH
                    END IF
                 END FOREACH
                 IF g_oom[l_ac].oom08[1,2] <> l_amb03 THEN
                    CALL cl_err('','axr-019',0)
                    NEXT FIELD oom08
                 END IF
              END IF   #MOD-730064
              IF length(g_oom[l_ac].oom07) <> length(g_oom[l_ac].oom08) THEN
                 CALL cl_err ('','axr-020',1)
                 NEXT FIELD oom07
              END IF
 
             IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oom[l_ac].oom04 <> g_oom_t.oom04
                            OR g_oom[l_ac].oom07 <> g_oom_t.oom07
                            OR g_oom[l_ac].oom08 <> g_oom_t.oom08  OR g_oom[l_ac].oom16 <> g_oom_t.oom16) THEN   #No.FUN-B90130
                CALL i020_check()
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_oom[l_ac].oom08,g_errno,1)
                   NEXT FIELD oom08
                END IF
             END IF
 
             IF NOT cl_null(g_oom[l_ac].oom07)     #判斷發票前兩碼為相同01/11/16
                AND NOT cl_null(g_oom[l_ac].oom08) THEN
             IF g_oom11 > 1 THEN
                IF g_oom[l_ac].oom07[1,g_oom11-1] <> g_oom[l_ac].oom08[1,g_oom11-1] THEN
                    CALL cl_err(g_oom[l_ac].oom07,'axr-907',0)
                    NEXT FIELD oom07
                END IF
             END IF
             END IF
             IF NOT cl_null(g_oom11) AND NOT cl_null(g_oom12) THEN
                LET g_oom[l_ac].cnt1=g_oom[l_ac].oom08[g_oom11,g_oom12]-
                                     g_oom[l_ac].oom07[g_oom11,g_oom12]+1
             END IF
               DISPLAY BY NAME g_oom[l_ac].oom08
               DISPLAY BY NAME g_oom[l_ac].cnt1
             IF cl_null(g_oom[l_ac].cnt1) THEN LET g_oom[l_ac].cnt1=0 END IF
          END IF
 
        AFTER FIELD oom09
          IF NOT cl_null(g_oom11) AND NOT cl_null(g_oom12) THEN
          IF g_oom11 > 0 AND g_oom12 > 0 THEN                              #TQC-A70123 Add
             LET g_oom[l_ac].cnt2=g_oom[l_ac].oom09[g_oom11,g_oom12]-
                                  g_oom[l_ac].oom07[g_oom11,g_oom12]+1
               DISPLAY BY NAME g_oom[l_ac].oom09
               DISPLAY BY NAME g_oom[l_ac].cnt2
           END IF                                                          #TQC-A70123 Add 
           END IF                                                                 DISPLAY BY NAME g_oom[l_ac].oom09
          IF cl_null(g_oom[l_ac].cnt2) THEN LET g_oom[l_ac].cnt2=0 END IF
               DISPLAY g_oom[l_ac].cnt2 TO s_oom[l_sl].cnt2
 
        BEFORE FIELD oom13
           IF l_ac > 1 THEN
              IF cl_null(g_oom[l_ac].oom13) THEN 
                 LET g_oom[l_ac].oom13 = g_oom[l_ac-1].oom13
              END IF    
           END IF 
           DISPLAY BY NAME g_oom[l_ac].oom13      
              
        AFTER FIELD oom13
           IF NOT cl_null(g_oom[l_ac].oom13) THEN   
              SELECT COUNT(*) INTO l_cnt FROM ama_file
               WHERE ama02 = g_oom[l_ac].oom13
                IF l_cnt = 0 THEN 
                   CALL cl_err("","mfg9329",1) 
                END IF
               #IF g_aza.aza21 = 'Y' OR NOT s_chkban(g_oom[l_ac].oom13) THEN #FUN-990053 mod  #MOD-AA0062 mark
                IF g_aza.aza21 = 'Y' AND NOT s_chkban(g_oom[l_ac].oom13) AND g_aza.aza26 <> '2' THEN #FUN-990053 mod #MOD-AA0062  #No.FUN-B90130
                   CALL cl_err("","mfg7015",1)
                   NEXT FIELD oom13
                END IF
           ELSE 
           	  IF g_aza.aza94 = 'Y' AND g_aza.aza26 <> '2' THEN   #No.FUN-B90130           	     
           	     CALL cl_err('oom13 is null: ','aap-099',0) 
           	     NEXT FIELD oom13
              END IF       
           END IF

      #FUN-A20055 ADD--------------------------------------------
        AFTER FIELD oom14
           IF NOT cl_null(g_oom[l_ac].oom14) THEN
              IF g_oom_t.oom14 IS NULL OR
                 (g_oom[l_ac].oom14 !=g_oom_t.oom14) THEN
                 CALL i020_oom14()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_oom_t.oom14,g_errno,0)
                    LET g_oom[l_ac].oom14=g_oom_t.oom14
                    DISPLAY BY NAME g_oom[l_ac].oom14
                    NEXT FIELD oom14
                 END IF
              END IF
           END IF
      #FUN-A20055 ADD END----------------------------------------

      #FUN-C40078--Add Begin---
        AFTER FIELD oom18
           IF g_oom_t.oom18 IS NULL OR
              (g_oom[l_ac].oom18 !=g_oom_t.oom18) THEN
              CALL i020_oom18()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oom_t.oom18,g_errno,0)
                 LET g_oom[l_ac].oom18=g_oom_t.oom18
                 DISPLAY BY NAME g_oom[l_ac].oom18
                 NEXT FIELD oom18
              END IF
           END IF
      #FUN-C40078--Add End-----

                  
      #No.FUN-B90130 --begin 
        AFTER FIELD oom16
            IF g_oom[l_ac].oom16 IS NULL THEN LET g_oom[l_ac].oom16 =' ' END IF 
            IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oom[l_ac].oom04 <> g_oom_t.oom04
                           OR g_oom[l_ac].oom07 <> g_oom_t.oom07
                           OR g_oom[l_ac].oom08 <> g_oom_t.oom08  OR g_oom[l_ac].oom16 <> g_oom_t.oom16) THEN               
               CALL i020_check()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_oom[l_ac].oom16,g_errno,1)
                  NEXT FIELD oom16
               END IF
            END IF

             
        AFTER FIELD oom15
            IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oom[l_ac].oom04 <> g_oom_t.oom04
                           OR g_oom[l_ac].oom07 <> g_oom_t.oom07
                           OR g_oom[l_ac].oom08 <> g_oom_t.oom08 OR g_oom[l_ac].oom15 <> g_oom_t.oom15 OR g_oom[l_ac].oom16 <> g_oom_t.oom16) THEN               
               CALL i020_check()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_oom[l_ac].oom15,g_errno,1)
                  NEXT FIELD oom15 
               END IF
            END IF
        #No.FUN-B90130 --end 
 
        BEFORE DELETE                            #是否取消單身
            #FUN-C40078--Add Begin---
            IF g_oom_t.oom17 = 'Y' THEN
               CALL cl_err('','axr-165', 1)
               CANCEL DELETE
            END IF
            #FUN-C40078--Add End-----
            IF g_oom_t.oom03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              #FUN-A30030 ADD---------------------------  
              ##FUN-A20055 ADD-------------------
              # IF g_oom_t.oompos ='Y' THEN  
              #    CALL cl_err("", 'aim-945',0)
              #    CANCEL DELETE
              # END IF
              ##FUN-A20055 ADD END---------------
                IF g_aza.aza88 = 'Y' THEN
                  #FUN-B40071 --START--
                   #IF g_oom[l_ac].oompos='N' THEN
                   #  #CALL cl_err('','art-648',0)
                   #   CALL cl_err('','aim-945',0)
                   #   CANCEL DELETE
                   #END IF
#                  IF g_oom[l_ac].oompos='1' OR g_oom[l_ac].oompos='2' THEN    #FUN-B70036   mark             
                   #IF g_oom[l_ac].oompos='1' OR g_oom[l_ac].oompos='3' THEN    #FUN-B70036  #FUN-B70075 MARK
                   IF l_oompos = '1' OR l_oompos = '3' THEN                                 #FUN-B70075 ADD 
                   ELSE                                                        #FUN-B70036 
                      CALL cl_err('','apc-139',0)            
                      CANCEL DELETE
                   END IF     
                  #FUN-B40071 --END--
                END IF
              #FUN-A30030 END---------------------------
               #-MOD-B20003-add-
                LET l_cnt = 0
                SELECT COUNT(*) into l_cnt
                  FROM ome_file
                 WHERE ome01 BETWEEN g_oom_t.oom07 AND g_oom_t.oom08
                   AND (ome03 = g_oom_t.oom16 OR ome03 = ' ')    #No.FUN-B90130
                IF l_cnt > 0 THEN
                   CALL cl_err('','atm-366', 1)
                   CANCEL DELETE
                END IF 
               #-MOD-B20003-end-

                DELETE FROM oom_file
                    WHERE oom01 = g_oom01
                      AND oom02 = g_oom02
                      AND oom021= g_oom021
                      AND oom03 = g_oom_t.oom03
                      AND oom04 = g_oom_t.oom04
                      AND oom05 = g_oom_t.oom05
                      AND oom15 = g_oom_t.oom15    #No.FUN-B90130

                IF SQLCA.sqlcode THEN
                    LET l_ac_t = l_ac
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
               LET g_rec_b = g_rec_b-1
               CALL i020_tot()
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oom[l_ac].* = g_oom_t.*
               CLOSE i020_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF

           #FUN-A30030 ADD-----------------------
            IF g_aza.aza88 = 'Y' THEN
              #FUN-B40071 --START--
               #LET g_oom[l_ac].oompos='N'
               #IF g_oom[l_ac].oompos <> '1' THEN  #FUN-B70075 MARK
               IF l_oompos <> '1' THEN            #FUN-B70075 ADD
                  LET g_oom[l_ac].oompos='2'
               ELSE                               #FUN-B70075 ADD
                  LET g_oom[l_ac].oompos='1'      #FUN-B70075 ADD
               END IF
              #FUN-B40071 --END--
               DISPLAY BY NAME g_oom[l_ac].oompos
            END IF
           #FUN-A30030 END-----------------------
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oom[l_ac].oom03,-263,1)
               LET g_oom[l_ac].* = g_oom_t.*
            ELSE
               IF g_oom[l_ac].oom16 IS NULL THEN LET g_oom[l_ac].oom16 = ' ' END IF #TQC-CA0054 add
               
               UPDATE oom_file SET oom03=g_oom[l_ac].oom03,
                                   oom04=g_oom[l_ac].oom04,
                                   oom05=g_oom[l_ac].oom05,
                                   oom06=g_oom[l_ac].oom06,
                                   oom07=g_oom[l_ac].oom07,
                                   oom08=g_oom[l_ac].oom08,
                                   oom09=g_oom[l_ac].oom09,
                                   oom10=g_oom[l_ac].oom10, 
                                   oom15=g_oom[l_ac].oom15,    #No.FUN-B90130  
                                   oom16=g_oom[l_ac].oom16,    #No.FUN-B90130
                                   oom11=g_oom11,           #No.FUN-560198
                                   oom12=g_oom12,           #No.FUN-560198
                                   oom13=g_oom[l_ac].oom13, #FUN-970108
                                   oom14=g_oom[l_ac].oom14,  #FUN-A20055 ADD
                                   oom17=g_oom[l_ac].oom17,  #FUN-C40078 ADD
                                   oom18=g_oom[l_ac].oom18,  #FUN-C40078 ADD
                                   oompos=g_oom[l_ac].oompos, #FUN-A20055 ADD
                                   oommodu = g_user,
                                   oomdate = g_today
                             WHERE oom01=g_oom01
                               AND oom02=g_oom02
                               AND oom021=g_oom021
                               AND oom03=g_oom_t.oom03
                               AND oom04=g_oom_t.oom04
                               AND oom05=g_oom_t.oom05
                               AND oom15 = g_oom_t.oom15   #No.FUN-B90130
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","oom_file",g_oom01,g_oom_t.oom03,SQLCA.sqlcode,"","",1)  #No.FUN-660116
                   LET g_oom[l_ac].* = g_oom_t.*
                   ROLLBACK WORK
               ELSE
                   CALL i020_tot()
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_oom[l_ac].* = g_oom_t.*
                #FUN-D30032--add--str--
                ELSE
                   CALL g_oom.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30032--add--end--
                END IF
                CLOSE i020_bcl
                ROLLBACK WORK
                #FUN-B70075 Add Begin---
                IF p_cmd = 'u' THEN
                   IF g_aza.aza88 = 'Y' THEN
                      UPDATE oom_file SET oompos = l_oompos
                       WHERE oom01 = g_oom01 AND oom02 = g_oom02
                         AND oom021 = g_oom021
                         AND oom03 = g_oom_t.oom03
                         AND oom04 = g_oom_t.oom04 AND oom05 = g_oom_t.oom05 
                         AND oom15 = g_oom_t.oom15   #No.FUN-B90130   

                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         CALL cl_err3("upd","oom_file",g_oom01_t,"",SQLCA.sqlcode,"","",1)
                      END IF
                      LET g_oom[l_ac].oompos = l_oompos 
                      DISPLAY BY NAME g_oom[l_ac].oompos
                   END IF
                END IF
                #FUN-B70075 Add End-----
                EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE i020_bcl
            COMMIT WORK
            CALL g_oom.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oom13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama02"
               LET g_qryparam.default1 = g_oom[l_ac].oom13
               CALL cl_create_qry() RETURNING g_oom[l_ac].oom13
               DISPLAY BY NAME g_oom[l_ac].oom13
               NEXT FIELD oom13
            WHEN INFIELD(oom14)                     #FUN-A20055 ADD
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_oom[l_ac].oom14
               CALL cl_create_qry() RETURNING g_oom[l_ac].oom14
               DISPLAY BY NAME g_oom[l_ac].oom14
               CALL i020_oom14()
               NEXT FIELD oom14
            #FUN-C40078--Add Begin---
            WHEN INFIELD(oom18)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ryc1"
               LET g_qryparam.default1 = g_oom[l_ac].oom18
               LET g_qryparam.default2 = g_oom[l_ac].ryc03
               LET g_qryparam.arg1 = g_oom[l_ac].oom14
               CALL cl_create_qry() RETURNING g_oom[l_ac].oom18,g_oom[l_ac].ryc03
               DISPLAY BY NAME g_oom[l_ac].oom18
               DISPLAY BY NAME g_oom[l_ac].ryc03
               NEXT FIELD oom18
            #FUN-C40078--Add End-----

            OTHERWISE EXIT CASE
         END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
    CLOSE i020_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i020_tot()
DEFINE l_oom07 LIKE oom_file.oom07 
DEFINE l_oom08 LIKE oom_file.oom08 
DEFINE l_oom09 LIKE oom_file.oom09 
DEFINE l_oom11 LIKE oom_file.oom11 
DEFINE l_oom12 LIKE oom_file.oom12 

   LET g_tot1 = 0
   LET g_tot2 = 0
   LET l_oom07 = 1 
   LET l_oom08 = 1 
   LET l_oom09 = 1 
   LET l_oom11 = 1 
   LET l_oom12 = 1 
   LET g_sql = "SELECT oom07,oom08,oom09,oom11,oom12 FROM oom_file",
                " WHERE oom01 = '",g_oom01,"'",
                "   AND oom02 = '",g_oom02,"'",
                "   AND oom021= '",g_oom021,"'"
   PREPARE i020_tot_pre FROM g_sql      #預備一下 
   DECLARE i020_tot_cs CURSOR FOR i020_tot_pre
   FOREACH i020_tot_cs INTO l_oom07,l_oom08,l_oom09,l_oom11,l_oom12
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_oom07) THEN 
          LET l_oom07 = 0
       END IF
       IF cl_null(l_oom08) THEN 
          LET l_oom08 = 0
       END IF
       IF cl_null(l_oom11) THEN 
          CONTINUE FOREACH
       END IF
       IF cl_null(l_oom12) THEN 
          CONTINUE FOREACH
       END IF
       LET g_tot1=g_tot1+ l_oom08[l_oom11,l_oom12]-l_oom07[l_oom11,l_oom12]+1
       IF cl_null(l_oom09) THEN 
          CONTINUE FOREACH
       END IF
       LET g_tot2=g_tot2+ l_oom09[l_oom11,l_oom12]-l_oom07[l_oom11,l_oom12]+1
   END FOREACH
      IF cl_null(g_tot1) THEN LET g_tot1=0 END IF
      IF cl_null(g_tot2) THEN LET g_tot2=0 END IF
      DISPLAY g_tot1,g_tot2 TO tot1,tot2
END FUNCTION
 
 
FUNCTION i020_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
 
    CONSTRUCT l_wc ON oom03,oom04,oom05,oom06,oom15,oom16,oom07,oom08,oom17,       #FUN-C40078 Add oom17
                      oom09,oom10,oom13,oom14,oom18,oompos                         #FUN-C40078 Add oom18  #FUN-A20055 ADD14,pos   #FUN-970108 add oom13  #No.FUN-B90130 add oom15,oom16
                      FROM s_oom[1].oom03,s_oom[1].oom04,s_oom[1].oom05,
                      s_oom[1].oom06,s_oom[1].oom15,s_oom[1].oom16,s_oom[1].oom07,s_oom[1].oom08,  #No.FUN-B90130
                      s_oom[1].oom17,                                 #FUN-C40078 Add
                      s_oom[1].oom09,s_oom[1].oom10,s_oom[1].oom13,   #FUN-970108
                      s_oom[1].oom14,s_oom[1].oom18,s_oom[1].oompos   #FUN-C40078 Add oom18        #FUN-A20055 ADD      

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE WHEN INFIELD(oom13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ama02"
                 LET g_qryparam.state= "c"
                 LET g_qryparam.default1 = g_oom[1].oom13
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oom13
                 NEXT FIELD oom13  
              WHEN INFIELD(oom14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state= "c"
                 LET g_qryparam.default1 = g_oom[1].oom14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oom14
                 NEXT FIELD oom14
              #FUN-C40078--Add Begin---
              WHEN INFIELD(oom18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryc1"
                 LET g_qryparam.state= "c"
                 LET g_qryparam.default1 = g_oom[1].oom18
                 LET g_qryparam.default2 = g_oom[1].ryc03
                 LET g_qryparam.arg1 = g_oom[1].oom14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oom18
                 NEXT FIELD oom18
              #FUN-C40078--Add End-----

           OTHERWISE EXIT CASE
        END CASE
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i020_bf(l_wc)
END FUNCTION
 
FUNCTION i020_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
 
    LET g_sql =
       "SELECT oom03,oom04,oom05,oom06,oom15,oom16,oom07,oom08,",  #No.FUN-560198   #No.FUN-B90130
       "       oom17,",                                            #FUN-C40078 Add oom17
       "       oom09,oom10,0,0,oom13,oom14,'',",                   #FUN-970108 add oom13
       "       oom18,'',",                                         #FUN-C40078 Add oom18,''
       "       oompos,oom11,oom12 ", #FUN-A20055 ADD OOM14,OOMPOS  #No.FUN-560198
       "  FROM oom_file",
     # " WHERE oom01 = '",g_oom01,"' AND ",p_wc CLIPPED ,           #FUN-AB0038 mark
     # "   AND oom02 = '",g_oom02,"'",                              #FUN-AB0038 mark
     # "   AND oom021= '",g_oom021,"'",                             #FUN-AB0038 mark
       " WHERE oom01 = ",g_oom01," AND ",p_wc CLIPPED ,             #FUN-AB0038 
       "   AND oom02 = ",g_oom02,                                   #FUN-AB0038
       "   AND oom021= ",g_oom021,                                  #FUN-AB0038  
       " ORDER BY oom03,oom04,oom05,oom07"
    PREPARE i020_prepare2 FROM g_sql      #預備一下
    DECLARE oom_cs CURSOR FOR i020_prepare2
    CALL g_oom.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET g_rec = 0
    LET g_tot1=0
    LET g_tot2=0
    FOREACH oom_cs INTO g_oom[g_cnt].*,g_oom11,g_oom12    #No.FUN-560198
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF NOT cl_null(g_oom[g_cnt].oom14) THEN      #FUN-A20055
         SELECT azp02 INTO g_oom[g_cnt].oom14_desc 
           FROM azp_file
          WHERE azp01 = g_oom[g_cnt].oom14
         DISPLAY BY NAME g_oom[g_cnt].oom14_desc
      END IF

      #FUN-C40078--Add Begin---
      IF g_oom[g_cnt].oom17 = 'Y' THEN
         CALL cl_set_comp_entry('oom04',FALSE)
         CALL cl_set_comp_entry('oom07',FALSE)
         CALL cl_set_comp_entry('oom08',FALSE)
         CALL cl_set_comp_entry('oom13',FALSE)
      END IF
    
      IF NOT cl_null(g_oom[g_cnt].oom18) THEN
         SELECT ryc03 INTO g_oom[g_cnt].ryc03 FROM ryc_file
          WHERE ryc01 = g_plant
            AND ryc02 = g_oom[g_cnt].oom18
          DISPLAY BY NAME g_oom[g_cnt].ryc03
      END IF
      #FUN-C40078--Add End-----
  
      IF NOT cl_null(g_oom11) AND NOT cl_null(g_oom12) THEN
         LET g_oom[g_cnt].cnt1 = g_oom[g_cnt].oom08[g_oom11,g_oom12]-
                                 g_oom[g_cnt].oom07[g_oom11,g_oom12]+1
         LET g_oom[g_cnt].cnt2 = g_oom[g_cnt].oom09[g_oom11,g_oom12]-
                                 g_oom[g_cnt].oom07[g_oom11,g_oom12]+1
         IF cl_null(g_oom[g_cnt].cnt1) THEN LET g_oom[g_cnt].cnt1 = 0 END IF
         IF cl_null(g_oom[g_cnt].cnt2) THEN LET g_oom[g_cnt].cnt2 = 0 END IF
      END IF
        CALL i020_tot()
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oom.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oom TO s_oom.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION related_document                #No.FUN-6B0042  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i020_o()
    DEFINE
        l_oom           RECORD LIKE oom_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680123 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680123 VARCHAR(20)  # External(Disk) file name 
        l_za05          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(40) 
DEFINE  l_cnt1,l_cnt2   LIKE type_file.num5      #No.FUN-830148
 
    IF g_wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830148 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830148                                       
     #------------------------------ CR (2) ------------------------------#
    
    LET g_sql="SELECT * FROM oom_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i020_co                         # SCROLL CURSOR
         CURSOR FOR i020_p1
 
    LET l_cnt1 = 0                                                                #FUN-830148                                                                                                                                   
    LET l_cnt2 = 0                                                                #FUN-830148
 
    FOREACH i020_co INTO l_oom.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
            IF NOT cl_null(l_oom.oom11) AND NOT cl_null(l_oom.oom12) THEN                                                                 
               LET l_cnt1=l_oom.oom08[l_oom.oom11,l_oom.oom12]-l_oom.oom07[l_oom.oom11,l_oom.oom12]+1                                                 
               LET l_cnt2=l_oom.oom09[l_oom.oom11,l_oom.oom12]-l_oom.oom07[l_oom.oom11,l_oom.oom12]+1                                                 
               IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF                                                                        
               IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF                                                                        
            END IF
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830148 *** ##                                                      
         EXECUTE insert_prep USING
                 l_oom.oom01,l_oom.oom02,l_oom.oom03,l_oom.oom04,l_oom.oom05,
                 l_oom.oom06,l_oom.oom07,l_oom.oom08,l_oom.oom09,l_oom.oom10,
                 l_cnt1,l_cnt2,l_oom.oom13    #FUN-970108
     #------------------------------ CR (3) ------------------------------#
    LET l_cnt1 = 0                                                                #FUN-830148                                       
    LET l_cnt2 = 0                                                                #FUN-830148
 
    END FOREACH
 
 
    CLOSE i020_co
    ERROR ""
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(g_wc,'oom01,oom02,oom021 FROM oom01,oom02,oom021')                                                                                         
              RETURNING g_wc                                                                                                       
      END IF                                                                                                                        
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830148 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc,";",g_aza.aza26                                                                              
    CALL cl_prt_cs3('axri020','axri020',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
FUNCTION i020_oom11(p_oom07)           #計算起始、截止流水號位數
DEFINE p_oom07 LIKE oom_file.oom07,    #起始發票號碼
       l_i     LIKE type_file.num5     #計算發票號碼位數  #No.FUN-680123 SMALLINT
 
   LET g_oom12 = LENGTH(p_oom07)
   FOR l_i = 1 TO g_oom12
      IF p_oom07[l_i,l_i] MATCHES "[0123456789]" THEN
         LET g_oom11 = l_i
         EXIT FOR
      END IF
   END FOR
END FUNCTION

#FUN-A20055 ADD----------------------
FUNCTION i020_oom14()
 DEFINE l_azp02  LIKE azp_file.azp02
 
 LET g_errno = ''
 SELECT azp02 INTO g_oom[l_ac].oom14_desc FROM azp_file
  WHERE azp01 = g_oom[l_ac].oom14
  CASE WHEN SQLCA.sqlcode = 100 LET g_errno ='aap-025'
       OTHERWISE 
       LET g_errno = SQLCA.sqlcode USING '-------'
       DISPLAY BY NAME g_oom[l_ac].oom14_desc 
  END CASE 
  DISPLAY BY NAME g_oom[l_ac].oom14_desc  #No.TQC-B60214
END FUNCTION
#FUN-A20055 ADD END -----------------

#FUN-C40078 Add----------------------
FUNCTION i020_oom18()
   IF cl_null(g_oom[l_ac].oom18) THEN
      LET g_oom[l_ac].ryc03 = ''
   ELSE
      SELECT ryc03 INTO g_oom[l_ac].ryc03 FROM ryc_file
       WHERE ryc01 = g_plant
         AND ryc02 = g_oom[l_ac].oom18

      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ryc_file",g_plant,g_oom[l_ac].oom18,SQLCA.sqlcode,"","sel ryc:",0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   DISPLAY BY NAME g_oom[l_ac].ryc03
END FUNCTION
#FUN-C40078 Add End------------------

FUNCTION i020_check()
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_sql     STRING
 
   LET g_errno = ''
   IF cl_null(g_oom[l_ac].oom04) THEN RETURN END IF
   IF cl_null(g_oom[l_ac].oom07) THEN RETURN END IF
   IF cl_null(g_oom[l_ac].oom08) THEN RETURN END IF
 
   IF cl_null(g_oom11) OR cl_null(g_oom12) THEN   #FUN-A20055 add
      RETURN
   END IF
         
   IF g_oom[l_ac].oom07[g_oom11,g_oom12] > g_oom[l_ac].oom08[g_oom11,g_oom12] THEN
      LET g_errno = 'axr-934'
      RETURN
   END IF
 
   LET l_cnt = 0
 
   LET l_sql = " SELECT COUNT(*) FROM oom_file ",
               "  WHERE oom07 <= '",g_oom[l_ac].oom08,"'",
               "    AND oom08 >= '",g_oom[l_ac].oom07,"'",
         #TQC-B80151 -begin
               "    AND NOT (oom01 = ? ",
               "    AND oom02 = ? ",
               "    AND oom021= ? ",
               "    AND oom03 = ? ",
               "    AND oom05 = ? )"
         #TQC-B80151 -end      
         #TQC-B80151 -begin mark
         #      "    AND oom01 <> ? ",
         #      "    AND oom02 <> ? ",
         #      "    AND oom021<> ? ",
         #      "    AND oom03 <> ? ",
         #      "    AND oom05 <> ? "
         #TQC-B80151 -end  mark

   IF g_aza.aza26 = '2' THEN
      LET l_sql = l_sql CLIPPED,
#No.FUN-B90130 --begin
               "    AND oom04 = '",g_oom[l_ac].oom04,"'",
               "    AND oom16 = '",g_oom[l_ac].oom16,"'"
#No.FUN-B90130 --end
   ELSE
      LET l_sql = l_sql CLIPPED,
               "    AND oom04 <> '",g_oom[l_ac].oom04,"'"
   END IF

   PREPARE i020_check_p1 FROM l_sql
   EXECUTE i020_check_p1 USING g_oom01,g_oom02,g_oom021,g_oom[l_ac].oom03,g_oom[l_ac].oom05 INTO l_cnt
   IF l_cnt > 0 THEN
      LET g_errno = 'axr-307'
      RETURN
   END IF
END FUNCTION

 
FUNCTION i020_set_no_required()
 IF g_aza.aza26 = '2' THEN                   #MOD-C30062 add
    CALL cl_set_comp_required("oom13",FALSE) #MOD-B50169 mark #MOD-C30062 remake
 END IF
END FUNCTION

 
FUNCTION i020_set_required()
  #IF g_aza.aza94 = 'Y' THEN                  #MOD-C30062 mark
     #CALL cl_set_comp_required("oom13",TRUE) #MOD-B50169 mark
  #END IF                                     #MOD-C30062 mark

END FUNCTION

#FUN-C40078--Add Begin---
FUNCTION i020_set_entry()
   CALL cl_set_comp_entry('oom04',TRUE)
   CALL cl_set_comp_entry('oom07',TRUE)
   CALL cl_set_comp_entry('oom08',TRUE)
   CALL cl_set_comp_entry('oom13',TRUE)
END FUNCTION

FUNCTION i020_set_no_entry()
   CALL cl_set_comp_entry('oom04',FALSE)
   CALL cl_set_comp_entry('oom07',FALSE)
   CALL cl_set_comp_entry('oom08',FALSE)
   CALL cl_set_comp_entry('oom13',FALSE)
END FUNCTION
#FUN-C40078--Add End-----
#No.FUN-9C0072 精簡程式碼

