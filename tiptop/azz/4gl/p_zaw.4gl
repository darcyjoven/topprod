# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zaw.4gl
# Descriptions...: CR報表格式設定作業
# Date & Author..: 07/03/30 By joyce      #No.FUN-720025 
# Modify.........: No.FUN-740010 07/04/03 By joyce 1.新增狀態頁籤 2.查詢時單身下條件卻仍顯示全部資料
# Modify.........: No.TQC-740034 07/04/09 By joyce 1.總筆數計算有誤 2.新增完後馬上按修改會有錯誤
# Modify.........: No.TQC-740075 07/04/13 By wujie 在p_zaw_q()中“CLEAR FROM”寫錯了，應該是“CLEAR FORM”
# Modify.........: No.FUN-780023 07/08/09 By jacklai 增加行業別欄位
# Modify.........: No.TQC-7B0135 07/11/26 By jacklai 當報表為客製報表時, 移除在刪除時出現[此筆資料為標準報表]的訊息
# Modify.........: No.FUN-840219 08/04/30 By alex 修正修改+新增單身會造成user error的問題
# Modify.........: No.FUN-850105 By Hiko 08/06/06 增加報表Time Out的設定
# Modify.........: No.MOD-880053 08/08/07 By clover 修改單頭"狀態"到單身
# Modify.........: No.FUN-8C0025 08/12/29 By tsai_yen CR報表格式設定作業
# Modify.........: No.FUN-920131 09/01/09 By tsai_yen 1.報表紙張設定(紙張名稱、紙張方向), 2.全型空白改成半型
# Modify.........: No.FUN-910012 09/01/08 By tsai_yen 在CR報表列印 TIPTOP 簽核欄
# Modify.........: No.FUN-940101 09/06/08 By tsai_yen 增加標準樣板紙張Letter和US Std Fanfold，而且不論大小寫都轉成正確拼字
# Modify.........: No.TQC-960067 09/06/24 By liuxqa 增加復制時，控管zaw04,zaw05的值。
# Modify.........: No.FUN-970066 09/07/17 By tsai_yen TIPTOP簽核設定加上客製模組
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0052 09/12/08 By Dido 放大鏡無作用 
# Modify.........: No:TQC-A30061 10/03/11 By Carrier zaworiu/zaworig 放单身
# Modify.........: No:FUN-A40077 10/04/28 By tsai_yen 加報表的樣板紙張格式"s1"選項
# Modify.........: No:FUN-A50047 10/05/11 By tsai_yen 報表簽核欄加入大陸模組
# Modify.........: No:FUN-A80040 10/08/30 By tsai_yen 加報表的樣板紙張格式"x0"選項:寬度84cm,高度200cm
# Modify.........: No:TQC-B30167 11/03/23 By CaryHsu 修改因為列印簽核位置沒有預設值造成新增時的錯誤與修改的狀態下無法變更的情況。
# Modify.........: No:TQC-B30172 11/03/23 By CaryHsu 修改因為列印簽核位置沒有預設值造成新增時的錯誤與修改的狀態下無法變更的情況。
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80078 11/08/08 By tsai_yen 加報表的樣板紙張格式"y0":寬84cm,長520cm
# Modify.........: No.FUN-B90094 11/09/14 By downheal 修正「更改」功能的顯示BUG 
# Modify.........: No.FUN-BB0127 11/12/19 By downheal 傳入p_cr_apr的參數，由模組代號改為程式代號 
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zaw            RECORD
         zaw01          LIKE zaw_file.zaw01,   # 程式代碼
         gaz03          LIKE gaz_file.gaz03,   # 程式名稱
         zaw02          LIKE zaw_file.zaw02,   # 樣板代號
         zaw05          LIKE zaw_file.zaw05,   # 使用者
         zx02           LIKE zx_file.zx02,     # 使用者姓名
         zaw04          LIKE zaw_file.zaw04,   # 權限類別
         zw02           LIKE zw_file.zw02,     # 權限類別說明
         zaw10          LIKE zaw_file.zaw10,   # 行業別    #No.FUN-780023
         zaw03          LIKE zaw_file.zaw03,   # 客製否
         zaw11          LIKE zaw_file.zaw11,   # Time out  # No.FUN-850105
         zaw12          LIKE zaw_file.zaw12,   #列印簽核                    #FUN-910012
         zaw13          LIKE zaw_file.zaw13    #列印簽核位置(A:頁尾,B:表尾)    #FUN-910012
#         zawuser        LIKE zaw_file.zawuser, # 資料所有者    #MOD-880053
#         zawgrup        LIKE zaw_file.zawgrup, # 部門          #MOD-880053
#         zawmodu        LIKE zaw_file.zawmodu, # 資料修改者
#         zawdate        LIKE zaw_file.zawdate  # 最近修改日
                    END RECORD,
       g_zaw_t          RECORD
         zaw01          LIKE zaw_file.zaw01,   # 程式代碼
         gaz03          LIKE gaz_file.gaz03,   # 程式名稱
         zaw02          LIKE zaw_file.zaw02,   # 樣板代號
         zaw05          LIKE zaw_file.zaw05,   # 使用者
         zx02           LIKE zx_file.zx02,     # 使用者姓名
         zaw04          LIKE zaw_file.zaw04,   # 權限類別
         zw02           LIKE zw_file.zw02,     # 權限類別說明
         zaw10          LIKE zaw_file.zaw10,   # 行業別    #No.FUN-780023
         zaw03          LIKE zaw_file.zaw03,   # 客製否
         zaw11          LIKE zaw_file.zaw11,   # Time out  # No.FUN-850105
         zaw12          LIKE zaw_file.zaw12,   #列印簽核                    #FUN-910012
         zaw13          LIKE zaw_file.zaw13    #列印簽核位置(A:頁尾,B:表尾)    #FUN-910012
#         zawuser        LIKE zaw_file.zawuser, # 資料所有者   #MOD-880053
#         zawgrup        LIKE zaw_file.zawgrup, # 部門         #MOD-880053
#         zawmodu        LIKE zaw_file.zawmodu, # 資料修改者
#         zawdate        LIKE zaw_file.zawdate  # 最近修改日
                    END RECORD,
       g_zaw_lock       RECORD LIKE zaw_file.*,
       g_zaw_b          DYNAMIC ARRAY of RECORD
         zaw07          LIKE zaw_file.zaw07,
         zaw06          LIKE zaw_file.zaw06,
         zaw08          LIKE zaw_file.zaw08,
         zaw09          LIKE zaw_file.zaw09,
         paper          LIKE zaw_file.zaw14,   # 樣板紙張(ComboBox)    #FUN-920131
         custompaper    LIKE zaw_file.zaw14,   # 自訂紙張              #FUN-920131
         zaw14          LIKE zaw_file.zaw14,   # 紙張名稱              #FUN-920131
         zaw15          LIKE zaw_file.zaw15,   # 紙張方向(縱向&橫向)  #FUN-920131
         zawuser        LIKE zaw_file.zawuser, # 資料所有者  #MOD-880053
         zawgrup        LIKE zaw_file.zawgrup, # 部門        #MOD-880053
         zawmodu        LIKE zaw_file.zawmodu, # 資料修改者  #MOD-880053
         zawdate        LIKE zaw_file.zawdate,
         #No.TQC-A30061  --Begin 
         zaworiu        LIKE zaw_file.zaworiu,
         zaworig        LIKE zaw_file.zaworig
         #No.TQC-A30061  --End   
 
                    END RECORD,
       g_zaw_b_t        RECORD                                      # 變數舊值
         zaw07          LIKE zaw_file.zaw07,
         zaw06          LIKE zaw_file.zaw06,
         zaw08          LIKE zaw_file.zaw08,
         zaw09          LIKE zaw_file.zaw09,
         paper          LIKE zaw_file.zaw14,   # 紙張名稱(ComboBox)    #FUN-920131
         custompaper    LIKE zaw_file.zaw14,   # 自訂紙張              #FUN-920131
         zaw14          LIKE zaw_file.zaw14,   # 紙張名稱              #FUN-920131
         zaw15          LIKE zaw_file.zaw15,   # 紙張方向(縱向&橫向)  #FUN-920131
         zawuser        LIKE zaw_file.zawuser, # 資料所有者   #MOD-880053
         zawgrup        LIKE zaw_file.zawgrup, # 部門         #MOD-880053
         zawmodu        LIKE zaw_file.zawmodu, # 資料修改者   #MOD-880053
         zawdate        LIKE zaw_file.zawdate, # 最近修改日   #MOD-880053
         #No.TQC-A30061  --Begin 
         zaworiu        LIKE zaw_file.zaworiu,
         zaworig        LIKE zaw_file.zaworig
         #No.TQC-A30061  --End   
                    END RECORD
DEFINE g_cnt            LIKE type_file.num10,
       g_cnt2           LIKE type_file.num10,
       g_wc             STRING,
       g_wc2            STRING,
       g_sql            STRING,
       g_ss             LIKE type_file.chr1,     # 決定後續步驟
       g_rec_b          LIKE type_file.num5,     # 單身筆數
       l_ac             LIKE type_file.num5      # 目前處理的ARRAY CNT
DEFINE g_msg               STRING  #FUN-840219 #LIKE type_file.chr1000   # VARCHAR(72)
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_n                 LIKE type_file.num10
DEFINE g_zaw01_zz          LIKE type_file.chr1
DEFINE g_count             LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10                           #FUN-920131
DEFINE g_paper DYNAMIC ARRAY OF RECORD            # 標準紙張                #FUN-920131
         paper          LIKE zaw_file.zaw14,      # 紙張名稱(標準)
         ori            LIKE zaw_file.zaw15,      # 紙張方向(縱向&橫向)
         ori_n          LIKE type_file.num10      # 紙張方向數(1:只有一種方向,2:有二種方向)
       END RECORD
DEFINE g_custom_i          STRING                 # 自訂紙張在g_paper的第幾個  #FUN-920131
DEFINE g_custom_j          LIKE type_file.num5    #FUN-A80040
DEFINE g_open_cr_apr       LIKE type_file.chr1    #是否要開視窗p_cr_apr      #FUN-910012
DEFINE g_zz01              LIKE zz_file.zz01      #程式代號                 #FUN-BB0127 由zz011改為zz01
DEFINE g_cmd               STRING                                          #FUN-910012
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_zaw_t.zaw01 = NULL
 
   OPEN WINDOW p_zaw_w WITH FORM "azz/42f/p_zaw"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   CALL p_zaw_gcw_act()  #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025
   CALL p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效      #FUN-910012
 
   CALL cl_set_combo_lang("zaw06")
   CALL cl_set_combo_industry("zaw10")    #No.FUN-780023
   ###FUN-920131 START ###
   CALL cl_set_comp_required("zaw08,paper,zaw15", TRUE) #必填欄位
   
   ###FUN-A80040 START ###
   LET g_custom_j = 1
   LET g_paper[g_custom_j].paper = "A4"
   LET g_paper[g_custom_j].ori = "P"       #縱向
   LET g_paper[g_custom_j].ori_n = 2       #紙張方向數(1:只有一種方向,2:有二種方向)
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "A3"
   LET g_paper[g_custom_j].ori = "P" 
   LET g_paper[g_custom_j].ori_n = 2
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "A2"
   LET g_paper[g_custom_j].ori = "L"       #橫向
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "A1"
   LET g_paper[g_custom_j].ori = "L"
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "A0"
   LET g_paper[g_custom_j].ori = "L"
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "s0"
   LET g_paper[g_custom_j].ori = "L"
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "s1"    #FUN-A40077
   LET g_paper[g_custom_j].ori = "P"       #FUN-A40077
   LET g_paper[g_custom_j].ori_n = 1       #FUN-A40077
   ###FUN-940101 START ###        #FUN-A40077
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "x0"    #FUN-A80040
   LET g_paper[g_custom_j].ori = "L"       #FUN-A80040
   LET g_paper[g_custom_j].ori_n = 1       #FUN-A80040
   LET g_custom_j = g_custom_j + 1         #FUN-B80078
   LET g_paper[g_custom_j].paper = "y0"    #FUN-B80078
   LET g_paper[g_custom_j].ori = "L"       #FUN-B80078
   LET g_paper[g_custom_j].ori_n = 1       #FUN-B80078
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "Letter"  
   LET g_paper[g_custom_j].ori = "P"       #縱向
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "US Std Fanfold"  #14 7/8*11(37.78*27.94cm)連續報表紙
   LET g_paper[g_custom_j].ori = "P"       
   LET g_paper[g_custom_j].ori_n = 1
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "中一刀"  
   LET g_paper[g_custom_j].ori = "P"       
   LET g_paper[g_custom_j].ori_n = 1
   ###FUN-940101 END ###
   LET g_custom_j = g_custom_j + 1
   LET g_paper[g_custom_j].paper = "O"     #其它,都要放在最後一個
   LET g_paper[g_custom_j].ori = "P"   
   LET g_paper[g_custom_j].ori_n = 2
   LET g_custom_i = g_custom_j
   ###FUN-920131 END ### 
   ###FUN-A80040 END ### 
   
   #No.FUN-780023 --start--
   LET g_forupd_sql = " SELECT * from zaw_file ",
                       "  WHERE zaw01 = ? AND zaw02 = ? AND zaw03 = ? ",
                         " AND zaw04 = ? AND zaw05 = ? AND zaw10 = ? ", 
                         " FOR UPDATE "
   #No.FUN-780023 --end--
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zaw_cl CURSOR FROM g_forupd_sql
 
   CALL p_zaw_menu()
 
   CLOSE WINDOW p_zaw_w                       # 結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p_zaw_curs(l_flag)                         # QBE 查詢資料
 
   DEFINE  l_flag   LIKE type_file.chr1   #STRING  #FUN-840219
   DEFINE  l_paper1 STRING                #FUN-920131
   DEFINE  l_paper2 STRING                #FUN-920131
   DEFINE  l_si     STRING                #FUN-920131
   DEFINE  l_j      LIKE type_file.num10  #FUN-920131
   
   
   CLEAR FORM                                    # 清除畫面
   CALL g_zaw_b.clear()
 
   IF l_flag = "1" THEN
      CONSTRUCT g_wc ON zaw01,zaw02,zaw05,zaw04,zaw10,zaw03,zaw12,zaw13   #FUN-910012 加zaw12,zaw13
    #                    zawuser,zawgrup,zawmodu,zawdate      #MOD-880053
                   FROM zaw01,zaw02,zaw05,zaw04,zaw10,zaw03,zaw12,zaw13   #FUN-910012 加zaw12,zaw13
    #                    zawuser,zawgrup,zawmodu,zawdate      #MOD-880053
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(zaw01)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_zz"                           #MOD-9C0052 mark
               LET g_qryparam.form = "q_zaw3"                         #MOD-9C0052
               LET g_qryparam.arg1 =  g_lang                          #MOD-9C0052
               LET g_qryparam.state = "c"                             #MOD-9C0052
               LET g_qryparam.default1 = g_zaw.zaw01
            #  CALL cl_create_qry() RETURNING g_zaw.zaw01             #MOD-9C0052 mark
               CALL cl_create_qry() RETURNING g_qryparam.multiret     #MOD-9C0052
            #  DISPLAY BY NAME g_zaw.zaw01                            #MOD-9C0052 mark
            #  DISPLAY BY NAME g_zaw.gaz03                            #MOD-9C0052 mark
               DISPLAY g_qryparam.multiret TO zaw01                   #MOD-9C0052 
               NEXT FIELD zaw01
 
            #-MOD-9C0052-add-
             WHEN INFIELD(zaw05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"          
                LET g_qryparam.default1 = g_zaw.zaw05 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO zaw05
                NEXT FIELD zaw05
 
             WHEN INFIELD(zaw04)                    
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zw"
                LET g_qryparam.default1 = g_zaw.zaw04 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO zaw04
                NEXT FIELD zaw04
            #-MOD-9C0052-end-
            OTHERWISE
               EXIT CASE
         END CASE
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zawuser', 'zawgrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
       #  CONSTRUCT g_wc2 ON zaw07,zaw06,zaw08,zaw09
       #       FROM s_zaw[1].zaw07,s_zaw[1].zaw06,s_zaw[1].zaw08,s_zaw[1].zaw09
        CONSTRUCT g_wc2 ON zaw07,zaw06,zaw08,zaw09,paper,custompaper,zaw15,zawuser,zawgrup,zawmodu,zawdate,   #FUN-920131 add paper,custompaper,zaw15
                           zaworiu,zaworig         #No.TQC-A30061
             FROM s_zaw[1].zaw07,s_zaw[1].zaw06,s_zaw[1].zaw08,s_zaw[1].zaw09,s_zaw[1].paper,s_zaw[1].custompaper,s_zaw[1].zaw15,   #FUN-920131 add paper,custompaper,zaw15
                  s_zaw[1].zawuser,s_zaw[1].zawgrup,s_zaw[1].zawmodu,s_zaw[1].zawdate, #MOD-880053
                  s_zaw[1].zaworiu,s_zaw[1].zaworig                        #No.TQC-A30061
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help
               CALL cl_show_help()
 
            ON ACTION controlg
               CALL cl_cmdask()
 
         END CONSTRUCT
 
         IF INT_FLAG THEN RETURN END IF
 
   END IF
 
   ###FUN-920131 START ###
   #查詢紙張
   FOR g_i=1 TO g_custom_i
      LET l_si = g_i
      LET l_paper1 = "paper='",l_si CLIPPED,"'"
      LET l_paper2 = ""
      IF l_si <> g_custom_i THEN   #標準紙張
         LET l_paper2 = "zaw14='",g_paper[g_i].paper CLIPPED,"'"         
      ELSE   #自訂紙張
         FOR l_j=1 TO (g_custom_i-1)
            IF l_j =1 THEN
               LET l_paper2 = l_paper2 CLIPPED,"'",g_paper[l_j].paper,"'"
            ELSE
               LET l_paper2 = l_paper2 CLIPPED,",'",g_paper[l_j].paper,"'"
            END IF
         END FOR
         IF NOT cl_null(l_paper2) THEN
            LET l_paper2 = "zaw14 NOT IN(",l_paper2 CLIPPED,")"
         END IF
      END IF
      
      LET g_wc2 = cl_replace_str(g_wc2,l_paper1,l_paper2)
   END FOR   
   
   LET g_wc2 = cl_replace_str(g_wc2,"custompaper='","zaw14='")
   LET g_wc2 = cl_replace_str(g_wc2,"custompaper like '","zaw14 like '")
   ###FUN-920131 END ###
   
   LET g_sql=" SELECT UNIQUE zaw01,'',zaw02,zaw05,'',zaw04,'',zaw10, ",  #No.FUN-780023
                           " zaw03,zaw11,zaw12,zaw13 ",    #FUN-910012 加zaw12,zaw13
               " FROM zaw_file ",
              " WHERE ", g_wc CLIPPED,
                " AND ", g_wc2 CLIPPED,
              " ORDER BY zaw01,zaw02,zaw05,zaw04,zaw10 "
   
   PREPARE p_zaw_prepare FROM g_sql          # 預備一下
   DECLARE p_zaw_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_zaw_prepare
 
END FUNCTION
 
FUNCTION p_zaw_count()
 
   LET g_sql= "SELECT UNIQUE zaw01,zaw02,zaw05,zaw04,zaw10,zaw03,zaw11,zaw12,zaw13",     #No.FUN-780023   #FUN-910012 加zaw12,zaw13
      #                     " zawuser,zawgrup,zawmodu,zawdate",               #No.MOD-880053
               " FROM zaw_file ",
              " WHERE ", g_wc CLIPPED,
                " AND ", g_wc2 CLIPPED,      # No.TQC-740034
              " ORDER BY zaw01,zaw02,zaw05,zaw04,zaw10 "
 
   PREPARE p_zaw_precount FROM g_sql
   DECLARE p_zaw_count CURSOR FOR p_zaw_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH p_zaw_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   LET g_row_count=g_rec_b
END FUNCTION
 
FUNCTION p_zaw_menu()
 
   WHILE TRUE
      CALL p_zaw_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_zaw_a()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_zaw_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_zaw_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_zaw_q()
            ELSE
               LET g_curs_index = 0
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zaw_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_zaw_u()
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "about"
            CALL cl_about()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         ###FUN-8C0025 START ###
         WHEN "gcw_act"                         #報表檔名設定
            CALL p_zaw_gcw()    
            CALL p_zaw_filename_show()          #顯示報表檔案設定      
         ###FUN-8C0025 END ###
         
         ###FUN-910012 START ###
         WHEN "cr_apr_act"                      #報表簽核欄維護作業            
            IF g_open_cr_apr = "Y" THEN
               LET g_cmd = "p_cr_apr '",g_zz01 CLIPPED,"'"  #No.FUN-BB0127 改為傳入程式代號g_zz01
               CALL cl_cmdrun(g_cmd)
            END IF
         ###FUN-910012 END ###
      END CASE
      
      CALL p_zaw_gcw_act()  #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025
      CALL p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效      #FUN-910012
   END WHILE
END FUNCTION
 
FUNCTION p_zaw_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_zaw.* TO NULL
   CALL g_zaw_b.clear()
 
   # 預設值及將數值類變數清成零
   INITIALIZE g_zaw_t.* TO NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_zaw.zaw03="N"
      LET g_zaw.zaw05=g_user
      LET g_zaw.zaw04='default'
      LET g_zaw.zaw10=g_sma.sma124  #No.FUN-780023
     #LET g_zaw.zaw11=''            #No.FUN-850105
     LET g_zaw_b_t.zawuser = g_user    #No.MOD-880053
     LET g_zaw_b_t.zawgrup = g_grup
     LET g_zaw_b_t.zawdate = g_today

      ###No.TQC-B30167 Start ###
      LET g_zaw.zaw13 = "1"
      ###No.TQC-B30167 End ###         
 
      CALL p_zaw_desc("zaw04",g_zaw.zaw04)
      CALL p_zaw_desc("zaw05",g_zaw.zaw05)
 
      CALL p_zaw_i("a")                           # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
        CLEAR FORM                                # 清單頭
        CALL g_zaw_b.clear()                      # 清單身
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
      END IF
      LET g_rec_b = 0   
 
      IF g_ss='N' THEN
         CALL g_zaw_b.clear()
      ELSE
         CALL p_zaw_b_fill('1=1','1=1')             # 單身
      END IF
 
      CALL g_zaw_b.clear()
      CALL p_zaw_b()                          # 輸入單身
      LET g_zaw_t.* = g_zaw.*
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p_zaw_u()
	 
	 #No.FUN-B90094 修正「更改」功能的顯示BUG: 增加另一暫存資料表 --start-- 
   DEFINE  l_zaw          RECORD
		         zaw01          LIKE zaw_file.zaw01,   # 程式代碼
		         gaz03          LIKE gaz_file.gaz03,   # 程式名稱
		         zaw02          LIKE zaw_file.zaw02,   # 樣板代號
		         zaw05          LIKE zaw_file.zaw05,   # 使用者
		         zx02           LIKE zx_file.zx02,     # 使用者姓名
		         zaw04          LIKE zaw_file.zaw04,   # 權限類別
		         zw02           LIKE zw_file.zw02,     # 權限類別說明
		         zaw10          LIKE zaw_file.zaw10,   # 行業別    #No.FUN-780023
		         zaw03          LIKE zaw_file.zaw03,   # 客製否
		         zaw11          LIKE zaw_file.zaw11,   # Time out  # No.FUN-850105
		         zaw12          LIKE zaw_file.zaw12,   #列印簽核                    #FUN-910012
		         zaw13          LIKE zaw_file.zaw13    #列印簽核位置(A:頁尾,B:表尾)    #FUN-910012
	         END RECORD
   #No.FUN-B90094 修正「更改」功能的顯示BUG: 增加另一暫存資料表 --end--
   
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaw.zaw01) THEN    #FUN-840219
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zaw_t.* = g_zaw.*
 
   BEGIN WORK
   OPEN p_zaw_cl USING g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw03,
                       g_zaw.zaw04,g_zaw.zaw05,g_zaw.zaw10     #No.FUN-780023
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zaw_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zaw_cl INTO g_zaw_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zaw01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zaw_cl
      ROLLBACK WORK
      RETURN
   END IF
 
#   LET g_zaw.zawmodu = g_user  #MOD-88053
#   LET g_zaw.zawdate = g_today #MOD-88053   
 
   DISPLAY BY NAME g_zaw.*
 
   WHILE TRUE
      CALL p_zaw_i("u")
      IF INT_FLAG THEN
         LET g_zaw.* = g_zaw_t.* 
         DISPLAY BY NAME g_zaw.*
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE zaw_file SET zaw01 = g_zaw.zaw01, zaw02 = g_zaw.zaw02,
                          zaw03 = g_zaw.zaw03, zaw04 = g_zaw.zaw04,
                          zaw05 = g_zaw.zaw05,
                          zaw10 = g_zaw.zaw10,       #FUN-780023
                          zaw11 = g_zaw.zaw11,       #FUN-850105
                          zaw12 = g_zaw.zaw12,       #FUN-910012
                          zaw13 = g_zaw.zaw13,       #FUN-910012 
#                          zawmodu = g_zaw.zawmodu,  #FUN-840219   #MOD-880053
#                          zawdate = g_zaw.zawdate   #FUN-840219   #MOD-880053
                          zawmodu = g_user , zawdate = g_today     #MOD-880053
       WHERE zaw01 = g_zaw_t.zaw01 AND zaw02 = g_zaw_t.zaw02
         AND zaw03 = g_zaw_t.zaw03 AND zaw04 = g_zaw_t.zaw04
         AND zaw05 = g_zaw_t.zaw05
         AND zaw10 = g_zaw_t.zaw10      #No.FUN-780023
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_zaw.zaw01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE p_zaw_cl 
   COMMIT WORK

	 #No.FUN-B90094 修正「更改」功能的顯示BUG --start-- 
   LET l_zaw.* = g_zaw.*
   CLOSE p_zaw_b_curs
   OPEN p_zaw_b_curs
   CALL p_zaw_fetch('F')
   WHILE TRUE
       IF l_zaw.zaw02 = g_zaw.zaw02 AND l_zaw.zaw03 = g_zaw.zaw03 AND l_zaw.zaw04 = g_zaw.zaw04 AND l_zaw.zaw05 = g_zaw.zaw05 AND l_zaw.zaw10 = g_zaw.zaw10 AND l_zaw.zaw13 = g_zaw.zaw13 AND l_zaw.zx02 = g_zaw.zx02 AND l_zaw.zw02 = g_zaw.zw02
       THEN
           EXIT WHILE
       END IF
       CALL p_zaw_fetch('N')
   END WHILE
   #No.FUN-B90094 修正「更改」功能的顯示BUG --end-- 
END FUNCTION
 
 
 
FUNCTION p_zaw_i(p_cmd)                           # 處理INPUT
   DEFINE   p_cmd      LIKE type_file.chr1                    # a:輸入 u:更改
   DEFINE   l_zwacti   LIKE zw_file.zwacti
 
   LET g_ss = 'N'
   DISPLAY BY NAME g_zaw.zaw01, g_zaw.zaw02, g_zaw.zaw03, g_zaw.zaw04,
                   g_zaw.zaw05, g_zaw.zaw10, g_zaw.zaw11, g_zaw.zaw12, g_zaw.zaw13  #FUN-850105 #FUN-910012 加zaw12,zaw13
            #       g_zaw.zawuser,g_zaw.zawgrup,g_zaw.zawdate,g_zaw.zawmodu  #MOD-880053
 
   INPUT g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw05,g_zaw.zaw04,g_zaw.zaw10,
         g_zaw.zaw03,g_zaw.zaw11,g_zaw.zaw12,g_zaw.zaw13 WITHOUT DEFAULTS  #FUN-910012 加zaw12,zaw13
    FROM zaw01,zaw02,zaw05,zaw04,zaw10,zaw03,zaw11,zaw12,zaw13             # FUN-850105  #FUN-910012 加zaw12,zaw13
   
   BEFORE INPUT
      LET g_before_input_done = FALSE
      CALL p_zaw_set_entry(p_cmd)
      CALL p_zaw_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE   
 
      IF p_cmd = 'u' THEN
         IF g_zaw.zaw05 = 'default' THEN
            IF g_zaw.zaw04 <> 'default' THEN
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
            IF g_zaw.zaw04 = 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            END IF
         END IF
      END IF
 
      ###FUN-910012 START ###   
      IF cl_null(g_zaw.zaw12) THEN
         LET g_zaw.zaw12 = "N"
      END IF
      IF g_zaw.zaw12="Y" THEN
         CALL cl_set_comp_entry("zaw13",TRUE)
      ELSE
         CALL cl_set_comp_entry("zaw13",FALSE)
      END IF
      ###FUN-910012 END ### 
      
   AFTER FIELD zaw01
      IF NOT cl_null(g_zaw.zaw01) THEN
         IF g_zaw.zaw01 <> g_zaw_t.zaw01 OR cl_null(g_zaw_t.zaw01) THEN
            CALL p_zaw_chkzaw01()
            IF g_zaw01_zz = "N" THEN
               CALL cl_err(g_zaw.zaw01,'azz-052',1)
               IF p_cmd = 'u' THEN
                  LET g_zaw.zaw05 = g_zaw_t.zaw05
               END IF
               NEXT FIELD zaw01
            END IF
            CALL p_zaw_desc("zaw01",g_zaw.zaw01)
 
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM zaw_file
             WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
               AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
               AND zaw05 = g_zaw.zaw05
               AND zaw10 = g_zaw.zaw10      #No.FUN-780023
            IF g_cnt >  0 THEN
               IF p_cmd = 'a' THEN
                  LET g_ss = 'Y'
                  CALL p_zaw_desc("zaw01",g_zaw.zaw01)
               ELSE
                  NEXT FIELD zaw01
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_zaw.zaw01,g_errno,0)
               NEXT FIELD zaw01
            END IF
 
         END IF
#        SELECT COUNT(*) INTO g_cnt2 FROM zaw_file
#         WHERE zaw01 = g_zaw.zaw01 AND zaw02 <> 'voucher'
#        SELECT COUNT(*) INTO g_cnt FROM zaw_file
#         WHERE zaw01 = g_zaw.zaw01 AND zaw02 = 'voucher'
#        IF g_cnt2 > 0 OR g_cnt > 0 THEN
#            IF g_cnt > 0 THEN
#               LET g_zaw.zaw02 = 'voucher'
#               DISPLAY g_zaw.zaw02 TO zaw02
#            END IF
#            IF g_cnt = 0 AND g_zaw.zaw02 = 'voucher' THEN
#               LET g_zaw.zaw02 = ''
#               DISPLAY g_zaw.zaw02 TO zaw02
#            END IF
#        END IF
      END IF
 
     AFTER FIELD zaw02
         LET g_count = 0
         SELECT COUNT(*) INTO g_count FROM zaw_file
          WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
            AND zaw03 = g_zaw.zaw03 AND zaw04 = "default"
            AND zaw05 = "default"
            AND zaw10 = g_zaw.zaw10      #No.FUN-780023
         IF g_count = 0 THEN
            LET g_zaw.zaw04 = "default"
            CALL p_zaw_desc("zaw04",g_zaw.zaw04)
            LET g_zaw.zaw05 = "default"
            CALL p_zaw_desc("zaw05",g_zaw.zaw05)
         END IF
 
   BEFORE FIELD zaw05
      CALL p_zaw_set_entry(p_cmd)
 
   AFTER FIELD zaw05
      IF NOT cl_null(g_zaw.zaw05) THEN
         IF g_zaw.zaw05 <> g_zaw_t.zaw05 OR cl_null(g_zaw_t.zaw05) THEN
            IF g_zaw_t.zaw04 CLIPPED = "default" AND g_zaw_t.zaw05 CLIPPED = "default" THEN
               SELECT COUNT(UNIQUE zaw05) INTO g_cnt FROM zaw_file
                WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw_t.zaw02
                  AND zaw03 <> g_zaw_t.zaw03 AND zaw04 = g_zaw_t.zaw04
                  AND zaw05 = g_zaw_t.zaw05
                  AND zaw10 = g_zaw_t.zaw10      #No.FUN-780023
               IF g_cnt = 0 THEN
                  CALL cl_err(g_zaw.zaw05,'azz-086',0)
                  LET g_zaw.zaw05 = g_zaw_t.zaw05
                  NEXT FIELD zaw05
               END IF
            END IF
            IF g_zaw.zaw05 CLIPPED  <> 'default' THEN
               SELECT COUNT(*) INTO g_cnt FROM zx_file
                WHERE zx01 = g_zaw.zaw05 
               IF g_cnt = 0 THEN
                   CALL cl_err(g_zaw.zaw05,'mfg1312',0)
                   NEXT FIELD zaw05
               END IF
            END IF
            IF g_zaw.zaw05 = 'default' THEN
               IF g_zaw.zaw04 <> 'default' THEN
                  CALL cl_set_comp_entry("zaw04",TRUE)
                  CALL cl_set_comp_entry("zaw05",FALSE)
               ELSE
                  CALL cl_set_comp_entry("zaw04",TRUE)
                  CALL cl_set_comp_entry("zaw05",TRUE)
               END IF
            ELSE
               IF g_zaw.zaw04 = 'default' THEN
                  CALL cl_set_comp_entry("zaw05",TRUE)
                  CALL cl_set_comp_entry("zaw04",FALSE)
               END IF
            END IF
##因為有多個key值,所以key值重複的check in AFTER INPUT
#            LET g_cnt = 0
#            SELECT COUNT(UNIQUE zaw05) INTO g_cnt FROM zaw_file
#             WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
#                   zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
#               AND zaw05 = g_zaw.zaw05
#            IF g_cnt > 0 THEN
#               CALL cl_err(g_zaw.zaw05,-239,0)
#               LET g_zaw.zaw05 = g_zaw_t.zaw05
#               NEXT FIELD zaw05
#            END IF
         END IF
      END IF
      CALL p_zaw_desc("zaw05",g_zaw.zaw05)
      CALL p_zaw_set_no_entry(p_cmd)
 
     BEFORE FIELD zaw04
         CALL p_zaw_set_entry(p_cmd)
 
     AFTER FIELD zaw04
         IF NOT cl_null(g_zaw.zaw04) THEN
            IF g_zaw.zaw04 <> g_zaw_t.zaw04 OR cl_null(g_zaw_t.zaw04) THEN
               IF g_zaw_t.zaw05 CLIPPED = "default" AND g_zaw_t.zaw04 CLIPPED = "default" THEN
                  SELECT COUNT(UNIQUE zaw04) INTO g_cnt FROM zaw_file
                   WHERE zaw01 = g_zaw.zaw01 AND zaw02 <> g_zaw_t.zaw02
                     AND zaw03 = g_zaw_t.zaw03 AND zaw04 = g_zaw.zaw04
                     AND zaw05 = g_zaw_t.zaw05
                     AND zaw10 = g_zaw.zaw10      #No.FUN-780023
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_zaw.zaw04,'azz-086',0)
                     LET g_zaw.zaw04 = g_zaw_t.zaw04
                     NEXT FIELD zaw04
                  END IF
               END IF
            END IF
            IF g_zaw.zaw04 CLIPPED  <> 'default' THEN
               SELECT zwacti INTO l_zwacti FROM zw_file
                WHERE zw01 = g_zaw.zaw04 
               IF STATUS THEN
                   CALL cl_err('select '||g_zaw.zaw04||" ",STATUS,0)
                   NEXT FIELD zaw04
               ELSE
                  IF l_zwacti != "Y" THEN
                     CALL cl_err_msg(NULL,"azz-218",g_zaw.zaw04 CLIPPED,10)
                     NEXT FIELD zaw04
                  END IF
               END IF
            END IF
         END IF
         CALL p_zaw_desc("zaw04",g_zaw.zaw04)
         CALL p_zaw_set_no_entry(p_cmd)
         IF g_zaw.zaw04 = 'default' THEN
            IF g_zaw.zaw05 <> 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
            IF g_zaw.zaw04 = 'default' THEN
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            END IF
         END IF
 
   AFTER FIELD zaw03
         LET g_cnt = 0
         IF g_zaw.zaw03 <> g_zaw_t.zaw03 OR cl_null(g_zaw_t.zaw03) THEN
            SELECT COUNT(*) INTO g_cnt FROM zaw_file
             WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
               AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
               AND zaw05 = g_zaw.zaw05
               AND zaw10 = g_zaw.zaw10      #No.FUN-780023
            IF g_cnt >  0 THEN
               CALL cl_err(" ",-239,1)
               NEXT FIELD zaw01
            END IF
         END IF
 
   # No.FUN-850105 ---start---
   AFTER FIELD zaw11
     IF NOT cl_null(g_zaw.zaw11) THEN
        IF g_zaw.zaw11 <= 0  OR g_zaw.zaw11 > 1000 THEN
           CALL cl_err('','azz-530',1)
           LET g_zaw.zaw11 = g_zaw_t.zaw11
           DISPLAY BY NAME g_zaw.zaw11
           NEXT FIELD zaw11
        END IF
     END IF
   # No.FUN-850105 --- end ---
 
   ###FUN-910012 START ###   
   ON CHANGE zaw12
      IF cl_null(g_zaw.zaw12) THEN
         LET g_zaw.zaw12 = "N"
      END IF
      IF g_zaw.zaw12="Y" THEN
         CALL cl_set_comp_entry("zaw13",TRUE)
         CALL cl_set_comp_required("zaw13", TRUE)  #預設為必填欄位
         IF cl_null(g_zaw.zaw13) THEN
               LET g_zaw.zaw13 = "1" 
         END IF
      ELSE
         CALL cl_set_comp_entry("zaw13",FALSE)
         CALL cl_set_comp_required("zaw13", FALSE) #預設為非必填欄位
      END IF
      
   BEFORE FIELD zaw13
      IF cl_null(g_zaw.zaw12) THEN
         LET g_zaw.zaw12 = "N"
      END IF
      IF g_zaw.zaw12="Y" THEN
         CALL cl_set_comp_entry("zaw13",TRUE)
         CALL cl_set_comp_required("zaw13", TRUE)  #預設為必填欄位
         IF cl_null(g_zaw.zaw13) THEN
               LET g_zaw.zaw13 = "1" 
         END IF
      ELSE
         CALL cl_set_comp_entry("zaw13",FALSE)
         CALL cl_set_comp_required("zaw13", FALSE) #預設為非必填欄位
      END IF
   ###FUN-910012 END ###
   
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF

           ###No.TQC-B30167 Start ###
           IF cl_null(g_zaw.zaw13) THEN
               LET g_zaw.zaw13 = "1"  
           END IF
           ###No.TQC-B30167 End ###

           IF (p_cmd = 'a') THEN
             IF g_zaw.zaw04 <> 'default' OR g_zaw.zaw05 <> 'default' THEN
                SELECT COUNT(*) INTO g_cnt FROM zaw_file
                 WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
                   AND zaw03 = g_zaw.zaw03 AND zaw04 = 'default'
                   AND zaw05 = 'default'
                   AND zaw10 = g_zaw.zaw10      #No.FUN-780023
                IF g_cnt = 0 THEN
                   CALL cl_err(g_zaw.zaw01,'azz-086',1)
                   NEXT FIELD zaw01
                END IF
             END IF
             SELECT COUNT(*) INTO g_cnt FROM zaw_file
              WHERE zaw01 = g_zaw.zaw01 AND zaw05 = "default"
              AND zaw03 = g_zaw.zaw03
             IF g_cnt = 0 THEN
                IF (g_zaw.zaw05 <> "default")  THEN
                   CALL cl_err(g_zaw.zaw01,'azz-086',1)
                   LET g_zaw.zaw01 = g_zaw_t.zaw01
                   LET g_zaw.gaz03 = g_zaw_t.gaz03
                   LET g_zaw.zaw02 = g_zaw_t.zaw02
                   LET g_zaw.zaw03 = "N"
                   DISPLAY BY NAME g_zaw.*
                   NEXT FIELD zaw01
                END IF
             END IF
             SELECT COUNT(*) INTO g_cnt FROM zaw_file
              WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
                AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
                AND zaw05 = g_zaw.zaw05
                AND zaw10 = g_zaw.zaw10      #No.FUN-780023
             IF g_cnt > 0  THEN
               CALL cl_err(g_zaw.zaw01,-239,1)
               NEXT FIELD zaw01
             END IF
           ELSE
               IF g_zaw_t.zaw01 <> g_zaw.zaw01 OR g_zaw_t.zaw02 <> g_zaw.zaw02
                  OR g_zaw_t.zaw03 <> g_zaw.zaw03 OR g_zaw_t.zaw04 <> g_zaw.zaw04 THEN
                  IF g_zaw_t.zaw05 = "default" THEN
                     IF g_zaw_t.zaw01 <> g_zaw.zaw01 OR g_zaw_t.zaw02 <> g_zaw.zaw02
                        OR g_zaw_t.zaw03 <> g_zaw.zaw03 OR g_zaw_t.zaw05 <> g_zaw.zaw05  THEN
 
                          SELECT COUNT(*) INTO g_cnt FROM zaw_file
                           WHERE zaw01 = g_zaw_t.zaw01 AND zaw05 <> "default"
                             AND zaw03 = g_zaw.zaw03
 
                          SELECT COUNT(*) INTO g_cnt2 FROM zaw_file
                           WHERE zaw01 = g_zaw_t.zaw01 AND zaw05 = "default"
                             AND zaw03 = g_zaw.zaw03 AND zaw02 <> g_zaw11
 
                          IF g_cnt > 0 AND g_cnt2 = 0 THEN
                             CALL cl_err(g_zaw_t.zaw01,'azz-086',1)
                             NEXT FIELD zaw01
                          ELSE IF g_zaw_t.zaw05 <> g_zaw.zaw05 AND g_cnt2 = 0 THEN
                             CALL cl_err(g_zaw_t.zaw01,'azz-086',1)
                             NEXT FIELD zaw05
                          END IF
                          END IF
                          SELECT COUNT(*) INTO g_cnt FROM zaw_file
                          WHERE zaw01 = g_zaw.zaw01 AND zaw05 = g_zaw.zaw05
                          AND zaw03 = g_zaw.zaw03 AND zaw02 = g_zaw.zaw02
                          IF g_cnt > 0  THEN
                            CALL cl_err(g_zaw.zaw01,-239,1)
                            NEXT FIELD zaw01
                          END IF
                          IF g_zaw.zaw05 <> "default" THEN
                            SELECT COUNT(*) INTO g_cnt FROM zaw_file
                            WHERE zaw01 = g_zaw.zaw01 AND zaw05 = "default"
                              AND zaw03 = g_zaw.zaw03
                            IF g_cnt = 0  THEN
                               CALL cl_err(g_zaw.zaw01,'azz-086',1)
                               NEXT FIELD zaw01
                            END IF
                          END IF
                     END IF
                  ELSE
                    IF g_zaw_t.zaw01 <> g_zaw.zaw01 OR g_zaw_t.zaw05 <> g_zaw.zaw05
                       OR g_zaw_t.zaw03 <> g_zaw.zaw03 OR g_zaw_t.zaw02 <> g_zaw.zaw02  THEN
                      SELECT COUNT(*) INTO g_cnt FROM zaw_file
                       WHERE zaw01 = g_zaw.zaw01 AND zaw05 = "default"
                         AND zaw03 = g_zaw.zaw03
                      IF g_cnt = 0 THEN
                           CALL cl_err(g_zaw.zaw01,'azz-086',1)
                           NEXT FIELD zaw01
                      END IF
                      SELECT COUNT(*) INTO g_cnt FROM zaw_file
                       WHERE zaw01 = g_zaw.zaw01 AND zaw05 = g_zaw.zaw05
                         AND zaw03 = g_zaw.zaw03 AND zaw02 = g_zaw.zaw02
                         AND zaw04 = g_zaw.zaw04
                         AND zaw10 = g_zaw.zaw10      #No.FUN-780023
                      IF g_cnt > 0  THEN
                        CALL cl_err(g_zaw.zaw01,-239,1)
                        NEXT FIELD zaw01
                      END IF
                    END IF
                  END IF
               END IF
            END IF
 
     ON ACTION controlp
         CASE
            WHEN INFIELD(zaw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= g_zaw.zaw01
               CALL cl_create_qry() RETURNING g_zaw.zaw01
               DISPLAY g_zaw.zaw01 TO zaw01
               CALL p_zaw_desc("zaw01",g_zaw.zaw01)
               NEXT FIELD zaw01
 
            WHEN INFIELD(zaw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = g_zaw.zaw05
               CALL cl_create_qry() RETURNING g_zaw.zaw05
               DISPLAY g_zaw.zaw05 TO zaw05
               CALL p_zaw_desc("zaw05",g_zaw.zaw05)
               NEXT FIELD zaw05
 
            WHEN INFIELD(zaw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zaw.zaw04
               CALL cl_create_qry() RETURNING g_zaw.zaw04
               DISPLAY g_zaw.zaw04 TO zaw.zaw04
               CALL p_zaw_desc("zaw04",g_zaw.zaw04)
               NEXT FIELD zaw04
 
            OTHERWISE
               EXIT CASE
         END CASE
 
       ON ACTION controlg
         CALL cl_cmdask()
 
       ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
   END INPUT
   CALL cl_set_comp_entry("zaw05,zaw04",TRUE)
 
END FUNCTION
 
FUNCTION p_zaw_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CLEAR FORM       #No.TQC-740075
   INITIALIZE g_zaw.*,g_zaw_t.* TO NULL
   CALL g_zaw_b.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_zaw_curs("1")                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_zaw_b_curs                             #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zaw.zaw01,g_zaw.gaz03 TO NULL
   ELSE
      CALL p_zaw_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_zaw_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
    
   CALL p_zaw_gcw_act()  #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025
   CALL p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效      #FUN-910012
END FUNCTION
 
FUNCTION p_zaw_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1                       #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zaw_b_curs INTO g_zaw.*
      WHEN 'P' FETCH PREVIOUS p_zaw_b_curs INTO g_zaw.*
      WHEN 'F' FETCH FIRST    p_zaw_b_curs INTO g_zaw.*
      WHEN 'L' FETCH LAST     p_zaw_b_curs INTO g_zaw.*
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
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
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_zaw_b_curs INTO g_zaw.*
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zaw.zaw01,SQLCA.sqlcode,0)
      INITIALIZE g_zaw.* TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zaw_show()
   END IF
END FUNCTION
 
FUNCTION p_zaw_show()                         # 將資料顯示在畫面上
   LET g_zaw_t.* = g_zaw.*
   DISPLAY BY NAME g_zaw.*
   CALL p_zaw_desc("zaw01",g_zaw.zaw01)
   CALL p_zaw_desc("zaw04",g_zaw.zaw04)
   CALL p_zaw_desc("zaw05",g_zaw.zaw05)
   CALL p_zaw_b_fill(g_wc,g_wc2)                    # 單身
   CALL p_zaw_gcw_act()                       #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025 
   CALL p_cr_apr_act()                        #報表簽核欄維護作業按鈕是否有效      #FUN-910012
   CALL p_zaw_filename_show()                 #顯示報表檔案設定 #FUN-8C0025
END FUNCTION
 
 
FUNCTION p_zaw_r()   
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaw.zaw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN p_zaw_cl USING g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw03,g_zaw.zaw04,
                       g_zaw.zaw05,g_zaw.zaw10      #No.FUN-780023
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zaw_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zaw_cl INTO g_zaw_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zaw01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zaw_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_zaw.zaw05 = "default" AND g_zaw.zaw04 = "default" AND g_zaw.zaw03 = "N" THEN #No.TQC-7B0135
       SELECT COUNT(*) INTO g_cnt FROM zaw_file
        WHERE zaw01 = g_zaw.zaw01 AND zaw03 = g_zaw.zaw03
          AND ((zaw05 <> "default" AND zaw04 = "default")
               OR (zaw05 = "default" AND zaw04 <> "default"))
          AND zaw10 = g_zaw.zaw10       #No.FUN-780023
 
       SELECT COUNT(*) INTO g_cnt2 FROM zaw_file
        WHERE zaw01 = g_zaw.zaw01 AND zaw03 = g_zaw.zaw03
          AND zaw02 <> g_zaw.zaw02
          AND zaw05 = "default" AND zaw04 = "default"
          AND zaw10 = g_zaw.zaw10       #No.FUN-780023
 
       IF g_cnt > 0 AND g_cnt2 = 0 THEN
          CALL cl_err(g_zaw.zaw01,'azz-086',1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
    #IF g_zaw.zaw05 = "default" AND g_zaw.zaw04 = "default" THEN    #No.TQC-7B0135
    IF g_zaw.zaw05 = "default" AND g_zaw.zaw04 = "default" AND g_zaw.zaw03 = "N" THEN    #No.TQC-7B0135
       IF cl_confirm("azz-077") THEN
          DELETE FROM zaw_file WHERE zaw01 = g_zaw.zaw01 AND zaw03 = g_zaw.zaw03
                  AND zaw05 = g_zaw.zaw05 AND zaw02 = g_zaw.zaw02
                  AND zaw04 = g_zaw.zaw04
                  AND zaw10 = g_zaw.zaw10       #No.FUN-780023
          IF SQLCA.sqlcode THEN
             CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
          ELSE
             ###FUN-8C0025 START #
             #刪除報表檔名設定
             DELETE FROM gcw_file 
                WHERE gcw01 = g_zaw.zaw01 AND gcw02 = g_zaw.zaw02 AND gcw03 = g_zaw.zaw04 AND gcw04 = g_zaw.zaw05 AND gcw12 = g_zaw.zaw10
             IF SQLCA.sqlcode THEN
                CALL cl_err('DELETE gcw_file:',SQLCA.sqlcode,0)
             END IF
             ###FUN-8C0025 END # 
             CLEAR FORM
             CALL g_zaw_b.clear()
             CALL p_zaw_count()
#FUN-B50065------begin---
             IF g_row_count=0 OR cl_null(g_row_count) THEN
                CLOSE p_zaw_cl        
                COMMIT WORK
                RETURN
             END IF
#FUN-B50065------end-----
             DISPLAY g_row_count TO FORMONLY.cnt
             OPEN p_zaw_b_curs
             IF g_curs_index = g_row_count + 1 THEN
                LET g_jump = g_row_count
                CALL p_zaw_fetch('L')
             ELSE
                LET g_jump = g_curs_index
                LET g_no_ask = TRUE
                CALL p_zaw_fetch('/')
             END IF
          END IF
       END IF
    ELSE
       IF cl_delh(0,0) THEN                   #確認一下
          DELETE FROM zaw_file WHERE zaw01 = g_zaw.zaw01 AND zaw03 = g_zaw.zaw03
                  AND zaw05 = g_zaw.zaw05 AND zaw02 = g_zaw.zaw02
                  AND zaw04 = g_zaw.zaw04
                  AND zaw10 = g_zaw.zaw10       #No.FUN-780023
          IF SQLCA.sqlcode THEN
             CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
          ELSE
             ###FUN-920131 START #
             #刪除報表檔名設定
             DELETE FROM gcw_file 
                WHERE gcw01 = g_zaw.zaw01 AND gcw02 = g_zaw.zaw02 AND gcw03 = g_zaw.zaw04 AND gcw04 = g_zaw.zaw05 AND gcw12 = g_zaw.zaw10
             IF SQLCA.sqlcode THEN
                CALL cl_err('DELETE gcw_file:',SQLCA.sqlcode,0)
             END IF
             ###FUN-920131 END # 
             CLEAR FORM
             CALL g_zaw_b.clear()
             CALL p_zaw_count()
#FUN-B50065------begin---
             IF g_row_count=0 OR cl_null(g_row_count) THEN
                CLOSE p_zaw_cl
                COMMIT WORK
                RETURN
             END IF
#FUN-B50065------end-----
             DISPLAY g_row_count TO FORMONLY.cnt
             OPEN p_zaw_b_curs
             IF g_curs_index = g_row_count + 1 THEN
                LET g_jump = g_row_count
                CALL p_zaw_fetch('L')
             ELSE
                LET g_jump = g_curs_index
                LET g_no_ask = TRUE
                CALL p_zaw_fetch('/')
             END IF
          END IF
       END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION p_zaw_b()                                # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,  # VARCHAR(01),             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,  # VARCHAR(01),             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE k,i LIKE type_file.num10
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaw.zaw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
  # LET g_forupd_sql= "SELECT zaw07,zaw06,zaw08,zaw09", 
    LET g_forupd_sql= "SELECT zaw07,zaw06,zaw08,zaw09,zaw14,zaw15,zawuser,zawgrup,zawmodu,zawdate,",  #MOD-880053   #FUN-920131 add zaw14,zaw15
                      "       zaworiu,zaworig  ",                 #No.TQC-A30061
                      " FROM zaw_file",
                     "  WHERE zaw01 = ? AND zaw02 = ? AND zaw03 = ? ",
                       " AND zaw04 = ? AND zaw10 = ? AND zaw05 = ? AND zaw06 = ? AND zaw07 = ? ",   #No.FUN-780023
                       " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zaw_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   IF g_rec_b > 0 THEN LET l_ac = 1 END IF
 
   INPUT ARRAY g_zaw_b WITHOUT DEFAULTS FROM s_zaw.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zaw_b_t.* = g_zaw_b[l_ac].*    #BACKUP
            LET g_before_input_done = FALSE
            CALL p_zaw_set_entry_b(p_cmd)
       #    CALL p_zaw_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            OPEN p_zaw_bcl USING g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw03,
                                 g_zaw.zaw04,g_zaw.zaw10,g_zaw.zaw05,g_zaw_b_t.zaw06,g_zaw_b_t.zaw07    #No.FUN-780023
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zaw_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zaw_bcl INTO g_zaw_b[l_ac].zaw07,g_zaw_b[l_ac].zaw06,
                                    g_zaw_b[l_ac].zaw08,g_zaw_b[l_ac].zaw09,g_zaw_b[l_ac].zaw14,g_zaw_b[l_ac].zaw15,   #FUN-920131 add zaw14,zaw15
                                    g_zaw_b[l_ac].zawuser,g_zaw_b[l_ac].zawgrup, #MOD-880053
                                    g_zaw_b[l_ac].zawmodu,g_zaw_b[l_ac].zawdate, #MOD-880053
                                    g_zaw_b[l_ac].zaworiu,g_zaw_b[l_ac].zaworig  #No.TQC-A30061
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zaw_b_t.zaw07,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE   #FUN-920131
                  CALL p_zaw_paper(l_ac)            #樣板紙張          #FUN-920131
                  CALL p_zaw_paper_required(l_ac)   #紙張設定的必填欄位   #FUN-920131  
               END IF
            END IF
     # mark by joyce
     #       IF g_zaw_b[l_ac].zaw09 = 1 THEN
     #          CALL zaw_set_no_entry()
     #       ELSE
     #          CALL zaw_set_entry()
     #       END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zaw_b[l_ac].* TO NULL
         LET g_zaw_b_t.* = g_zaw_b[l_ac].*
         LET g_before_input_done = FALSE
         CALL p_zaw_set_entry_b(p_cmd)
         CALL p_zaw_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
#        LET g_zaw.zawmodu = NULL      #FUN-840219
         LET g_zaw_b[l_ac].zawuser=g_user        #MOD-880053
         LET g_zaw_b[l_ac].zawgrup=g_grup       #MOD-880053
         LET g_zaw_b[l_ac].zawdate=g_today       #MOD-880053
         LET g_zaw_b[l_ac].zaworiu=g_user       #No.TQC-A30061
         LET g_zaw_b[l_ac].zaworig=g_grup       #No.TQC-A30061
 
         NEXT FIELD zaw07
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         INSERT INTO zaw_file(zaw01,zaw02,zaw03,zaw04,zaw05,zaw10,zaw11,zaw12,zaw13,  #FUN-780023   #FUN-850105  #FUN-910012 加zaw12,zaw13
                              zawuser,zawgrup,zawmodu,zawdate,    
                              zaw06,zaw07,zaw08,zaw09,zaw14,zaw15,zaworiu,zaworig)   #FUN-920131 add zaw14,zaw15
         VALUES (g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw03,
                 g_zaw.zaw04,g_zaw.zaw05,
                 g_zaw.zaw10,g_zaw.zaw11,g_zaw.zaw12,g_zaw.zaw13,   #No.FUN-780023   #FUN-850105  #FUN-910012 加zaw12,zaw13
                 g_zaw_b[l_ac].zawuser,g_zaw_b[l_ac].zawgrup,   #MOD-880053
                 g_zaw_b[l_ac].zawmodu,g_zaw_b[l_ac].zawdate,  #FUN-740010
                 g_zaw_b[l_ac].zaw06,g_zaw_b[l_ac].zaw07,
                 g_zaw_b[l_ac].zaw08,g_zaw_b[l_ac].zaw09,g_zaw_b[l_ac].zaw14,g_zaw_b[l_ac].zaw15,
                 g_zaw_b[l_ac].zaworiu,g_zaw_b[l_ac].zaworig)          #No.TQC-A30061
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_zaw.zaw01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
     BEFORE FIELD zaw07
        IF g_zaw_b[l_ac].zaw07 IS NULL OR g_zaw_b[l_ac].zaw07 = 0 THEN
           SELECT MAX(zaw07)+1 INTO g_zaw_b[l_ac].zaw07
             FROM zaw_file WHERE zaw01 = g_zaw.zaw01
              AND zaw05 = g_zaw.zaw05 AND zaw03 = g_zaw.zaw03
              AND zaw02 = g_zaw.zaw02 AND zaw04 = g_zaw.zaw04
              AND zaw10 = g_zaw.zaw10   #No.FUN-780023
           IF g_zaw_b[l_ac].zaw07 IS NULL THEN
              LET g_zaw_b[l_ac].zaw07 = 1
           END IF
        END IF
 
     AFTER FIELD zaw07
        IF g_zaw_b[l_ac].zaw07 < 1 THEN
            NEXT FIELD zaw07
        END IF
        IF NOT cl_null(g_zaw_b[l_ac].zaw07) THEN
           IF g_zaw_b[l_ac].zaw07 != g_zaw_b_t.zaw07 OR g_zaw_b_t.zaw07 IS NULL THEN
              SELECT COUNT(*) INTO l_n FROM zaw_file
               WHERE zaw01 = g_zaw.zaw01 AND zaw07 = g_zaw_b[l_ac].zaw07
                 AND zaw06 = g_zaw_b[l_ac].zaw06 AND zaw05 = g_zaw.zaw05
                 AND zaw03 = g_zaw.zaw03 AND zaw02 = g_zaw.zaw02
                 AND zaw04 = g_zaw.zaw04
                 AND zaw10 = g_zaw.zaw10    #No.FUN-780023
              IF l_n > 0 THEN
                 CALL cl_err(g_zaw_b[l_ac].zaw07,-239,0)
                 LET g_zaw_b[l_ac].zaw07 = g_zaw_b_t.zaw07
                 NEXT FIELD zaw07
              ###FUN-920131 START ### 
              ELSE
                 #新資料行預設紙張
                 LET g_zaw_b[l_ac].paper = "1"
                 CALL p_zaw_zaw14(l_ac,"Y")                 #報表紙張
                 CALL p_zaw_paper_required(l_ac)            #紙張設定的必填欄位
              ###FUN-920131 END ### 
              END IF
           END IF
        END IF
 
      ###FUN-920131 START ###  
      ON CHANGE paper                         
         LET g_zaw_b[l_ac].custompaper = ""         
         CALL p_zaw_zaw14(l_ac,"Y")                 #報表紙張,標準紙張存入zaw14
         CALL p_zaw_paper_required(l_ac)            #紙張設定的必填欄位
         IF g_zaw_b[l_ac].paper = g_custom_i THEN   #自訂紙張
            NEXT FIELD custompaper
         ELSE            
            IF g_paper[g_zaw_b[l_ac].paper].ori_n = 2 THEN   #可以改紙張方向
               NEXT FIELD zaw15
            END IF
         END IF
      
      ON CHANGE custompaper
         CALL p_zaw_paper_cas(g_zaw_b[l_ac].custompaper) RETURNING g_zaw_b[l_ac].custompaper   #FUN-940101              
         CALL p_zaw_zaw14(l_ac,"Y")                 #報表紙張,自訂紙張存入zaw14
         CALL p_zaw_paper_required(l_ac)            #紙張設定的必填欄位   
         NEXT FIELD zaw15   
      ###FUN-920131 END ###
      
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zaw_b_t.zaw06)) AND (NOT cl_null(g_zaw_b_t.zaw07)) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zaw_file
             WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
               AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
               AND zaw05 = g_zaw.zaw05
               AND zaw10 = g_zaw.zaw10      #No.FUN-780023
               AND zaw06 = g_zaw_b[l_ac].zaw06
               AND zaw07 = g_zaw_b[l_ac].zaw07
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_zaw_b[l_ac].zaw07,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zaw_b[l_ac].* = g_zaw_b_t.*
            CLOSE p_zaw_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaw_b[l_ac].zaw07,-263,1)
            LET g_zaw_b[l_ac].* = g_zaw_b_t.*
         ELSE
            CALL p_zaw_zaw14(l_ac,"N")               #報表紙張   #FUN-920131
            
            UPDATE zaw_file
               SET zaw06 = g_zaw_b[l_ac].zaw06,
                   zaw07 = g_zaw_b[l_ac].zaw07,
                   zaw08 = g_zaw_b[l_ac].zaw08,
                   zaw09 = g_zaw_b[l_ac].zaw09,
                   zaw14 = g_zaw_b[l_ac].zaw14,  #FUN-920131
                   zaw15 = g_zaw_b[l_ac].zaw15,  #FUN-920131
                   zawmodu = g_user,        #MOD-880053
                   zawdate = g_today        #MOD-880053 
             WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
               AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
               AND zaw05 = g_zaw.zaw05
               AND zaw10 = g_zaw.zaw10  #No.FUN-780023
               AND zaw06 = g_zaw_b_t.zaw06
               AND zaw07 = g_zaw_b_t.zaw07
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_zaw_b[l_ac].zaw07,SQLCA.sqlcode,0)
               LET g_zaw_b[l_ac].* = g_zaw_b_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
          CALL zaw_set_entry()
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zaw_b[l_ac].* = g_zaw_b_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zaw_b.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_zaw_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 Add
         CLOSE p_zaw_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE p_zaw_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zaw_b_fill(p_wc,p_wc2)                #BODY FILL UP
   DEFINE   p_wc     STRING,  #FUN-840219 LIKE type_file.chr1000,     # VARCHAR(300)
            p_wc2    STRING   #FUN-840219 LIKE type_file.chr1000
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
 
   LET g_sql = "SELECT zaw07,zaw06,zaw08,zaw09,zaw14,zaw15,zawuser,zawgrup,zawmodu,zawdate,", #MOD-88053   #FUN-920131 add zaw14,zaw15
               "       zaworiu,zaworig   ",                #No.TQC-A30061
               "  FROM zaw_file ",
               " WHERE zaw01 = '",g_zaw.zaw01 CLIPPED,"' ",
                 " AND zaw02 = '",g_zaw.zaw02 CLIPPED,"' ",
                 " AND zaw03 = '",g_zaw.zaw03 CLIPPED,"' ",
                 " AND zaw04 = '",g_zaw.zaw04 CLIPPED,"' ",
                 " AND zaw05 = '",g_zaw.zaw05 CLIPPED,"' ",
                 " AND zaw10 = '",g_zaw.zaw10 CLIPPED,"' ",     #No.FUN-780023
                 " AND ",p_wc CLIPPED,
                 " AND ",p_wc2 CLIPPED,
               " ORDER BY zaw07,zaw06"
 
    PREPARE p_zaw_prepare3 FROM g_sql           #預備一下
    DECLARE zaw_curs3 CURSOR FOR p_zaw_prepare3
 
    CALL g_zaw_b.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH zaw_curs3 INTO g_zaw_b[g_cnt].zaw07,g_zaw_b[g_cnt].zaw06,
                           g_zaw_b[g_cnt].zaw08,g_zaw_b[g_cnt].zaw09,g_zaw_b[g_cnt].zaw14,g_zaw_b[g_cnt].zaw15,   #FUN-920131 add zaw14,zaw15
                           g_zaw_b[g_cnt].zawuser,g_zaw_b[g_cnt].zawgrup,  #MOD-880053
                           g_zaw_b[g_cnt].zawmodu,g_zaw_b[g_cnt].zawdate,
                           g_zaw_b[g_cnt].zaworiu,g_zaw_b[g_cnt].zaworig   #No.TQC-A30061
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE   #FUN-920131
          CALL p_zaw_paper(g_cnt)   #樣板紙張   #FUN-920131
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zaw_b.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zaw_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL p_zaw_gcw_act()  #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025 
   CALL p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效      #FUN-910012
   
   DISPLAY ARRAY g_zaw_b TO s_zaw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_set_combo_lang("zaw06")
         CALL cl_set_combo_industry("zaw10")      #No.FUN-780023
         INITIALIZE g_zaw.gaz03 TO NULL
         CALL p_zaw_desc("zaw01",g_zaw.zaw01)
         CALL p_zaw_desc("zaw05",g_zaw.zaw05)
         CALL p_zaw_desc("zaw04",g_zaw.zaw04)
         CALL p_zaw_filename_show()              #FUN-8C0025   #顯示報表檔案設定
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_zaw_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION previous                         # P.上筆
         CALL p_zaw_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION jump                             # 指定筆
         CALL p_zaw_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION next                             # N.下筆
         CALL p_zaw_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION last                             # 最終筆
         CALL p_zaw_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION about
         LET g_action_choice="about"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ###FUN-8C0025 START ###
      ON ACTION gcw_act                          #報表檔名設定
         LET g_action_choice="gcw_act"
         EXIT DISPLAY
      ###FUN-8C0025 END ###
      
      ###FUN-910012 START ###
      ON ACTION cr_apr_act                       #報表簽核欄維護作業
         LET g_action_choice="cr_apr_act"
         EXIT DISPLAY
      ###FUN-910012 END ###
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL p_zaw_gcw_act()  #有資料才顯示"CR報表檔名設定"按鈕   #FUN-8C0025
   CALL p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效      #FUN-910012
END FUNCTION
 
FUNCTION p_zaw_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE zaw_file.zaw01,
            l_oldfe    LIKE zaw_file.zaw01,
            l_newfe2   LIKE zaw_file.zaw02,
            l_oldfe2   LIKE zaw_file.zaw02,
            l_newfe3   LIKE zaw_file.zaw03,
            l_oldfe3   LIKE zaw_file.zaw03,
            l_newfe4   LIKE zaw_file.zaw04,
            l_oldfe4   LIKE zaw_file.zaw04,
            l_newfe5   LIKE zaw_file.zaw05,
            l_oldfe5   LIKE zaw_file.zaw05,
            l_newfe10  LIKE zaw_file.zaw10,     #No.FUN-780023
            l_oldfe10  LIKE zaw_file.zaw10,     #No.FUN-780023
#           l_newfe6   LIKE zaw_file.zaw06,
#           l_oldfe6   LIKE zaw_file.zaw06,
#           l_newfe7   LIKE zaw_file.zaw07,
#           l_oldfe7   LIKE zaw_file.zaw07,
#           l_newfe8   LIKE zaw_file.zaw08,
#           l_oldfe8   LIKE zaw_file.zaw08,
#           l_newfe9   LIKE zaw_file.zaw09,
#           l_oldfe9   LIKE zaw_file.zaw09,
            l_newfe11  LIKE zaw_file.zaw11,     #No.FUN-850105
            l_oldfe11  LIKE zaw_file.zaw11,     #No.FUN-850105
            l_newfe12  LIKE zaw_file.zaw12,     #FUN-910012
            l_oldfe12  LIKE zaw_file.zaw12,     #FUN-910012
            l_newfe13  LIKE zaw_file.zaw13,     #FUN-910012
            l_oldfe13  LIKE zaw_file.zaw13,     #FUN-910012
            l_zwacti   LIKE zw_file.zwacti
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaw.zaw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe,l_newfe2,l_newfe5,l_newfe4,l_newfe10,l_newfe3,l_newfe11,l_newfe12,l_newfe13 WITHOUT DEFAULTS   #FUN-850105  #FUN-910012 加zaw12,zaw13
    FROM zaw01,zaw02,zaw05,zaw04,zaw10,zaw03,zaw11,zaw12,zaw13   #FUN-910012 加zaw12,zaw13
 
      BEFORE INPUT
         DISPLAY BY NAME g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw03,
                         g_zaw.zaw04,g_zaw.zaw05,g_zaw.zaw10,g_zaw.zaw11,g_zaw.zaw12,g_zaw.zaw13 #FUN-780023   #FUN-850105  #FUN-910012 加zaw12,zaw13
         DISPLAY ' ' TO gaz03
         LET l_newfe = g_zaw.zaw01
         LET l_newfe2 = g_zaw.zaw02
         LET l_newfe3 = g_zaw.zaw03
         LET l_newfe4 = g_zaw.zaw04
         LET l_newfe5 = g_zaw.zaw05
         LET l_newfe10 = g_zaw.zaw10    #No.FUN-780023
         LET l_newfe11 = g_zaw.zaw11    #No.FUN-850105
         LET l_newfe12 = g_zaw.zaw12    #FUN-910012 
         LET l_newfe13 = g_zaw.zaw13    #FUN-910012
 
      AFTER FIELD zaw01
         IF cl_null(l_newfe) THEN
            NEXT FIELD zaw01
         END IF
         LET g_cnt = 0
         SELECT COUNT(UNIQUE zz01) INTO g_cnt FROM zz_file
          WHERE zz01 = l_newfe
         IF g_cnt = 0  THEN
             CALL cl_err(l_newfe,'azz-053',1)
             NEXT FIELD zaw01
         END IF
         CALL p_zaw_desc("zaw01",l_newfe)
 
     AFTER FIELD zaw02
         LET g_count = 0
         SELECT COUNT(*) INTO g_count FROM zaw_file
          WHERE zaw01 = l_newfe AND zaw02 = l_newfe2
            AND zaw03 = l_newfe3 AND zaw04 = "default"
            AND zaw05 = "default"
            AND zaw10 = l_newfe10       #No.FUN-780023
         IF g_count = 0 THEN
            LET l_newfe4 = "default"
            CALL p_zaw_desc("zaw04",l_newfe4)
            LET l_newfe5 = "default"
            CALL p_zaw_desc("zaw05",l_newfe5)
         END IF
 
     BEFORE FIELD zaw05
         IF l_newfe5 = 'default' THEN
            CALL cl_set_comp_entry("zaw05",TRUE)
         END IF
 
      AFTER FIELD zaw05
         IF cl_null(l_newfe5) THEN
            NEXT FIELD zaw05
         END IF
         IF l_newfe5 CLIPPED  <>'default' THEN
            SELECT COUNT(*) INTO g_cnt FROM zx_file
             WHERE zx01 = l_newfe5 
            IF g_cnt = 0 THEN
                CALL cl_err(l_newfe5,'mfg1312',0)
                NEXT FIELD zaw05
            END IF
         END IF
         CALL p_zaw_desc("zaw05",l_newfe5)
         IF l_newfe5 = 'default' THEN
            IF l_newfe4 <> 'default' THEN
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
            IF l_newfe4 = 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            END IF
         END IF
 
     BEFORE FIELD zaw04
         IF l_newfe4 = 'default' THEN
            CALL cl_set_comp_entry("zaw04",TRUE)
         END IF
 
     AFTER FIELD zaw04
         IF cl_null(l_newfe4) THEN
            NEXT FIELD zaw04
         END IF
         IF l_newfe4 CLIPPED  <> 'default' THEN
            SELECT zwacti INTO l_zwacti FROM zw_file
             WHERE zw01 = l_newfe4 
            IF STATUS THEN
                CALL cl_err('select '||l_newfe4||" ",STATUS,0)
                NEXT FIELD zaw04
            ELSE
               IF l_zwacti != "Y" THEN
                  CALL cl_err_msg(NULL,"azz-218",l_newfe4 CLIPPED,10)
                  NEXT FIELD zaw4
               END IF
            END IF
         END IF
         CALL p_zaw_desc("zaw04",l_newfe4)
         IF l_newfe4 = 'default' THEN
            IF l_newfe5 <> 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
#            IF l_newfe4 = 'default' THEN   #No.TQC-960067 mark
            IF l_newfe5 = 'default' THEN    #No.TQC-960067 mod
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            END IF
         END IF
 
      ###FUN-910012 START ###   
      ON CHANGE zaw12
         IF cl_null(l_newfe12) THEN
            LET l_newfe12 = "N"
         END IF
         IF l_newfe12="Y" THEN
            CALL cl_set_comp_entry("zaw13",TRUE)
            CALL cl_set_comp_required("zaw13", TRUE)  #預設為必填欄位
            IF cl_null(l_newfe13) THEN
               LET l_newfe13 = "1" 
            END IF
         ELSE
            CALL cl_set_comp_entry("zaw13",FALSE)
            CALL cl_set_comp_required("zaw13", FALSE) #預設為非必填欄位
         END IF
 
      BEFORE FIELD zaw13
         IF cl_null(l_newfe12) THEN
            LET l_newfe12 = "N"
         END IF
         IF l_newfe12="Y" THEN
            CALL cl_set_comp_entry("zaw13",TRUE)
            CALL cl_set_comp_required("zaw13", TRUE)  #預設為必填欄位
            IF cl_null(l_newfe13) THEN
               LET l_newfe13 = "1" 
            END IF
         ELSE
            CALL cl_set_comp_entry("zaw13",FALSE)
            CALL cl_set_comp_required("zaw13", FALSE) #預設為非必填欄位
         END IF
      ###FUN-910012 END ### 
         
      AFTER INPUT
            IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
            END IF

            ###No.TQC-B30167 Start ###
            IF cl_null(l_newfe13) THEN
               LET l_newfe13 = "1" 
            END IF
            ###No.TQC-B30167 End ###
           
            IF l_newfe4 <> 'default' OR l_newfe5 <> 'default' THEN
               SELECT COUNT(*) INTO g_cnt FROM zaw_file
                WHERE zaw01 = l_newfe AND zaw02 = l_newfe2 AND zaw03 = l_newfe3
                  AND zaw04 = 'default' AND zaw05 = 'default'
                  AND zaw10 = l_newfe10     #No.FUN-780023
               IF g_cnt = 0 THEN
                  CALL cl_err(l_newfe,'azz-086',1)
                  NEXT FIELD zaw01
               END IF
            END IF
            SELECT COUNT(*) INTO g_cnt FROM zaw_file
            WHERE zaw01 = l_newfe AND zaw05 = l_newfe5 AND zaw03=l_newfe3
              AND zaw02 = l_newfe2 AND zaw04 = l_newfe4
              AND zaw10 = l_newfe10     #No.FUN-780023
            IF g_cnt > 0  THEN
               CALL cl_err(l_newfe,-239,1)
               NEXT FIELD zaw01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM zaw_file
             WHERE zaw01 = l_newfe AND zaw05 = "default"
             AND zaw03 = l_newfe3
            IF g_cnt = 0 THEN
               IF (l_newfe5 <> "default")  THEN
                  CALL cl_err(l_newfe,'azz-086',1)
                  NEXT FIELD zaw01
               END IF
            END IF
 
     ON ACTION controlp
         CASE
            WHEN INFIELD(zaw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= l_newfe
               CALL cl_create_qry() RETURNING l_newfe
               DISPLAY l_newfe TO zaw01
               CALL p_zaw_desc("zaw01",l_newfe)
               NEXT FIELD zaw01
 
            WHEN INFIELD(zaw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = l_newfe5
               CALL cl_create_qry() RETURNING l_newfe5
               DISPLAY l_newfe5 TO zaw05
               CALL p_zaw_desc("zaw05",l_newfe5)
               NEXT FIELD zaw05
 
            WHEN INFIELD(zaw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = l_newfe4
               CALL cl_create_qry() RETURNING l_newfe4
               DISPLAY l_newfe4 TO zaw04
               CALL p_zaw_desc("zaw04",l_newfe4)
               NEXT FIELD zaw04
 
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
   CALL cl_set_comp_entry("zaw05,zaw04",TRUE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_zaw.zaw01, g_zaw.zaw02, g_zaw.zaw03,
                      g_zaw.zaw04, g_zaw.zaw05, g_zaw.zaw10 #FUN-780023
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM zaw_file WHERE zaw01 = g_zaw.zaw01 AND zaw02 = g_zaw.zaw02
                            AND zaw03 = g_zaw.zaw03 AND zaw04 = g_zaw.zaw04
                            AND zaw05 = g_zaw.zaw05 AND zaw10 = g_zaw.zaw10 #FUN-780023
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zaw.zaw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET zaw01 = l_newfe,                              # 資料鍵值
          zaw02 = l_newfe2,
          zaw03 = l_newfe3,
          zaw04 = l_newfe4,
          zaw05 = l_newfe5,
          zaw10 = l_newfe10,    #No.FUN-780023
          zaw11 = l_newfe11,    #No.FUN-850105
          zaw12 = l_newfe12,    #FUN-910012 
          zaw13 = l_newfe13,    #FUN-910012
          zawuser = g_user,    
          zawgrup = g_grup,
          zaworiu = g_user,     #No.TQC-A30061
          zaworig = g_grup,     #No.TQC-A30061
          zawmodu = NULL,
          zawdate = g_today
   INSERT INTO zaw_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('zaw:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldfe = g_zaw.zaw01
   LET l_oldfe2 = g_zaw.zaw02
   LET l_oldfe3 = g_zaw.zaw03
   LET l_oldfe4 = g_zaw.zaw04
   LET l_oldfe5 = g_zaw.zaw05
   LET l_oldfe10 = g_zaw.zaw10      #No.FUN-780023
   LET l_oldfe11 = g_zaw.zaw11      #No.FUN-850105
   LET l_oldfe12 = g_zaw.zaw12      #FUN-910012
   LET l_oldfe13 = g_zaw.zaw13      #FUN-910012
   LET g_zaw.zaw01 = l_newfe
   LET g_zaw.zaw05 = l_newfe5
   LET g_zaw.zaw03 = l_newfe3
   LET g_zaw.zaw02 = l_newfe2
   LET g_zaw.zaw04 = l_newfe4
   LET g_zaw.zaw10 = l_newfe10      #No.FUN-780023
   LET g_zaw.zaw11 = l_newfe11      #No.FUN-850105
   LET g_zaw.zaw12 = l_newfe12      #FUN-910012
   LET g_zaw.zaw13 = l_newfe13      #FUN-910012
 
   LET g_wc = " zaw01 = '",l_newfe,"' AND zaw02 = '",l_newfe2,"' ",
              " AND zaw03 = '",l_newfe3,"' AND zaw04 = '",l_newfe4,"'",
              " AND zaw10 = '",l_newfe10,"'",        #No.FUN-780023
              " AND zaw05 = '",l_newfe5,"'"
              
   CALL p_zaw_curs("2")
   OPEN p_zaw_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zaw.zaw01,g_zaw.gaz03 TO NULL
   ELSE
      CALL p_zaw_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_zaw_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
 
FUNCTION p_zaw_desc(l_column,l_value)
DEFINE l_column   STRING,
       l_value    LIKE type_file.chr10
 
   CASE l_column
        WHEN "zaw01"
             SELECT gaz03 INTO g_zaw.gaz03 FROM gaz_file
              WHERE gaz01 = l_value AND gaz02 = g_lang
             IF SQLCA.SQLCODE THEN
                LET g_zaw.gaz03 = ""
             END IF
             DISPLAY g_zaw.gaz03 TO gaz03
        WHEN "zaw04"
             SELECT zw02 INTO g_zaw.zw02 FROM zw_file
              WHERE zw01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_zaw.zw02 = ""
             END IF
             IF l_value = "default" THEN
                LET g_zaw.zw02 = "default"
             END IF
             DISPLAY g_zaw.zw02 TO zw02
        WHEN "zaw05"
             SELECT zx02 INTO g_zaw.zx02 FROM zx_file
              WHERE zx01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_zaw.zx02 = ""
             END IF
             IF l_value = "default" THEN
                LET g_zaw.zx02 = "default"
             END IF
             DISPLAY g_zaw.zx02 TO zx02
   END CASE
END FUNCTION
 
FUNCTION zaw_set_entry()
   CALL cl_set_comp_entry("zaw02", TRUE)
 
END FUNCTION
 
FUNCTION zaw_set_no_entry()
   CALL cl_set_comp_entry("zaw02", FALSE)
END FUNCTION
 
FUNCTION p_zaw_chkzaw01()
 DEFINE li_i1    LIKE type_file.num5
 DEFINE li_i2    LIKE type_file.num5
 DEFINE lc_zz08  LIKE zz_file.zz08
 DEFINE lc_db    LIKE zta_file.zta03    # VARCHAR(3)
 DEFINE ls_str   STRING
 DEFINE lc_zaw01 LIKE zaw_file.zaw01
 
   LET lc_db=cl_db_get_database_type()
   CASE lc_db
        WHEN "ORA"
           LET lc_zz08="%",g_zaw.zaw01 CLIPPED,"%"
           SELECT COUNT(*) INTO li_i1 FROM zz_file
            WHERE zz08 LIKE lc_zz08
        WHEN "IFX"
           LET lc_zz08="*",g_zaw.zaw01 CLIPPED,"*"
           SELECT COUNT(*) INTO li_i1 FROM zz_file
            WHERE zz08 MATCHES lc_zz08
        WHEN "MSV"    #FUN-840219
           LET lc_zz08="%",g_zaw.zaw01 CLIPPED,"%"
           SELECT COUNT(*) INTO li_i1 FROM zz_file
            WHERE zz08 LIKE lc_zz08
   END CASE
   SELECT COUNT(*) INTO g_cnt from zz_file where zz01= g_zaw.zaw01
   LET g_zaw01_zz ="N"
   IF li_i1 > 0 THEN
      SELECT COUNT(*) INTO g_cnt2 FROM gak_file WHERE gak01 = g_zaw.zaw01
      IF g_cnt2 > 0 THEN
         LET g_zaw01_zz = "Y"
      END IF
      RETURN
   ELSE
      IF (li_i1 = 0 AND g_cnt = 0 )THEN
         LET g_zaw01_zz = "N"
         RETURN
      ELSE
         SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01 = g_zaw.zaw01
         LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
         LET li_i1 = ls_str.getIndexOf("i/",1)
         LET li_i2 = ls_str.getIndexOf(" ",li_i1)
         IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
         LET lc_zaw01 = ls_str.subString(li_i1+2,li_i2)
         CALL cl_err_msg(NULL,"azz-060",g_zaw.zaw01 CLIPPED|| "|" || lc_zaw01 CLIPPED,10)
         LET g_zaw.zaw01 = lc_zaw01 CLIPPED
         LET g_zaw01_zz = "Y"
         DISPLAY g_zaw.zaw01 TO zaw01
      END IF
   END IF
END FUNCTION
 
FUNCTION p_zaw_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
   IF INFIELD(zaw05) THEN
      IF g_zaw.zaw05 = 'default' THEN
         CALL cl_set_comp_entry("zaw05",TRUE)
      END IF
   END IF
   IF INFIELD(zaw04) THEN
      IF g_zaw.zaw04 = 'default' THEN
         CALL cl_set_comp_entry("zaw04",TRUE)
      END IF
   END IF
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zaw01,zaw06,zaw07,",TRUE)   #FUN-910012 
   END IF
END FUNCTION
 
FUNCTION p_zaw_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
   IF INFIELD(zaw05) THEN
      IF p_cmd = 'u' THEN
         IF g_zaw.zaw05 = 'default' THEN
            IF g_zaw.zaw04 <> 'default' THEN
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
            IF g_zaw.zaw04 = 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_zaw.zaw05) AND g_zaw.zaw05 <> 'default' THEN
               LET g_zaw.zaw04 = 'default'
               CALL cl_set_comp_entry("zaw04",FALSE)
            END IF
         END IF
      END IF
   END IF
 
   IF INFIELD(zaw04) THEN
      IF p_cmd = 'u' THEN
         IF g_zaw.zaw04 = 'default' THEN
            IF g_zaw.zaw05 <> 'default' THEN
               CALL cl_set_comp_entry("zaw05",TRUE)
               CALL cl_set_comp_entry("zaw04",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",TRUE)
            END IF
         ELSE
            IF g_zaw.zaw05 = 'default' THEN
               CALL cl_set_comp_entry("zaw04",TRUE)
               CALL cl_set_comp_entry("zaw05",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_zaw.zaw04) AND g_zaw.zaw04 <> 'default' THEN
               LET g_zaw.zaw05 = 'default'
               CALL cl_set_comp_entry("zaw05",FALSE)
            END IF
         END IF
      END IF
   END IF
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zaw01,zaw06,zaw07,",FALSE)   #FUN-910012 
   END IF
   #--END
END FUNCTION
 
FUNCTION p_zaw_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       # VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zaw07,zaw06,zaw08,zaw09,,paper,custompaper,zaw15",TRUE)  #MOD-88053   #FUN-920131 add paper,custompaper,zaw15  #FUN-910012 
   END IF
 
END FUNCTION
 
FUNCTION p_zaw_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       # VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zaw07,zaw06,zaw08,zaw09,zaw13,paper,custompaper,zaw15",FALSE)   #FUN-920131 add paper,custompaper,zaw15  #FUN-910012 zaw13
   END IF
 
END FUNCTION
 
#---- end FUN-720025 ----#
 
###FUN-920131 START ###
FUNCTION p_zaw_paper(p_cnt)  #樣板紙張
  DEFINE p_cnt          LIKE type_file.num10   #單身行數
  DEFINE l_si           STRING
 
  IF NOT cl_null(g_zaw_b[p_cnt].zaw14) THEN  
      LET l_si = NULL
      #樣板紙張
      FOR g_i=1 TO g_paper.getLength()         
         IF g_zaw_b[p_cnt].zaw14 = g_paper[g_i].paper THEN
            LET l_si = g_i
            LET g_zaw_b[p_cnt].paper = l_si CLIPPED
         END IF         
      END FOR
      
      #自訂紙張      
      IF cl_null(l_si) THEN
         LET g_zaw_b[p_cnt].paper = g_custom_i   #樣板紙張：其他
         LET g_zaw_b[p_cnt].custompaper = g_zaw_b[p_cnt].zaw14
      END IF
  ELSE
     LET g_zaw_b[p_cnt].paper = ""
     LET g_zaw_b[p_cnt].zaw15 = ""
  END IF  
END FUNCTION
 
 
FUNCTION p_zaw_paper_required(p_cnt)     #紙張設定的必填欄位 
   DEFINE p_cnt          LIKE type_file.num10   #單身行數
   
   CALL cl_set_comp_required("custompaper", FALSE)       #非必填欄位
   CALL cl_set_comp_entry("zaw15",FALSE)
   IF NOT cl_null(g_zaw_b[p_cnt].paper) THEN             #有設定紙張 
      #自訂紙張是否為必填欄位
      IF g_zaw_b[p_cnt].paper = g_custom_i THEN
         CALL cl_set_comp_required("custompaper", TRUE)  #必填欄位 
         CALL cl_set_comp_entry("custompaper",TRUE)      
      ELSE
         CALL cl_set_comp_required("custompaper", FALSE) #非必填璁?
         CALL cl_set_comp_entry("custompaper",FALSE)
      END IF
      #是否可改紙張方向
      IF g_paper[g_zaw_b[p_cnt].paper].ori_n = 2 THEN
         CALL cl_set_comp_entry("zaw15",TRUE)
      END IF
   END IF
END FUNCTION
 
 
FUNCTION p_zaw_zaw14(p_cnt,p_ori)   #報表紙張
  DEFINE p_cnt          LIKE type_file.num10   #單身行數
  DEFINE p_ori          LIKE type_file.chr1    #預設紙張方向 Y:是,N:否
  DEFINE l_si           STRING
 
  IF NOT cl_null(g_zaw_b[p_cnt].paper) THEN       
      FOR g_i=1 TO g_paper.getLength()  
         LET l_si = g_i
         
         ###FUN-940101 START ###
         #自訂紙張等於標準紙張
         IF NOT cl_null(g_zaw_b[p_cnt].custompaper) THEN
            IF g_zaw_b[p_cnt].custompaper = g_paper[g_i].paper THEN
               LET g_zaw_b[p_cnt].paper = l_si
            END IF
         END IF
         ###FUN-940101 END ###
         
         IF g_zaw_b[p_cnt].paper = l_si CLIPPED THEN
            #樣板紙張:標準
            IF g_zaw_b[p_cnt].paper <> g_custom_i THEN   #不是"其他"
               LET g_zaw_b[p_cnt].zaw14 = g_paper[g_i].paper CLIPPED
               LET g_zaw_b[p_cnt].custompaper = ""
            ELSE
               LET g_zaw_b[p_cnt].zaw14 = g_zaw_b[p_cnt].custompaper CLIPPED
            END IF
            #預設紙張方向
            IF p_ori = "Y" THEN
               IF g_paper[g_i].ori_n = 1
                  OR (g_paper[g_i].ori_n > 1 AND (cl_null(g_zaw_b[p_cnt].zaw15))) THEN
                     LET g_zaw_b[p_cnt].zaw15 = g_paper[g_i].ori CLIPPED
               END IF
            END IF
         END IF
      END FOR
  ELSE
     LET g_zaw_b[p_cnt].zaw14 = ""
     LET g_zaw_b[p_cnt].zaw15 = ""
  END IF
END FUNCTION
###FUN-920131 END ###
 
 
###FUN-940101 START ###
#不論大小寫都轉成正確拼字:"Letter","US Std Fanfold"
FUNCTION p_zaw_paper_cas(p_paper)  
   DEFINE  p_paper  STRING   #樣板紙張
   DEFINE  l_paper  STRING   #正確的樣板紙張
   DEFINE  l_str    STRING
 
   LET l_paper = p_paper
   IF NOT cl_null(p_paper) THEN
      #不論大小寫都轉成正確拼字:"Letter","US Std Fanfold"
      LET l_str = p_paper.touppercase()
      IF l_str = "LETTER" THEN
         LET l_paper = "Letter"
      END IF
      IF l_str = "US STD FANFOLD" THEN
         LET l_paper = "US Std Fanfold"
      END IF
   END IF
   
   RETURN l_paper
END FUNCTION
###FUN-940101 END ###
 
 
###FUN-8C0025 START #
#CR報表格式設定作業
FUNCTION p_zaw_gcw()
   DEFINE ls_tmp           STRING
   DEFINE l_i,l_x,l_y      LIKE type_file.num5   
   DEFINE l_gcw   RECORD 
             gcw01         LIKE gcw_file.gcw01,      #程式代號
             gcw02         LIKE gcw_file.gcw02,      #樣板代號
             gcw03         LIKE gcw_file.gcw03,      #權限類別
             gcw04         LIKE gcw_file.gcw04,      #使用者
             gcw05         LIKE gcw_file.gcw05,      #報表檔案命名第一段
             gcw06         LIKE gcw_file.gcw06,      #報表檔案命名第二段
             gcw07         LIKE gcw_file.gcw07,      #報表檔案命名第三段
             gcw08         LIKE gcw_file.gcw08,      #報表檔案命名第四段
             gcw09         LIKE gcw_file.gcw09,      #報表檔案命名第五段
             gcw10         LIKE gcw_file.gcw10,      #報表檔案命名第六段
             gcw11         LIKE gcw_file.gcw11,      #重複時覆寫
             gcw12         LIKE gcw_file.gcw12       #行業別
             END RECORD
 
   IF cl_null(g_zaw.zaw01) or cl_null(g_zaw.zaw02) or cl_null(g_zaw.zaw03) or cl_null(g_zaw.zaw04) or cl_null(g_zaw.zaw10) THEN       
      RETURN 
   END IF
   
   OPEN WINDOW p_zaw_gcw_w AT 10,03 WITH FORM "azz/42f/p_zaw_gcw"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_zaw_gcw")   
 
   CALL cl_set_comp_entry("gcw11",TRUE)
   CALL cl_set_combo_industry("zaw10")   #行業別
      
   WHILE TRUE     
      DECLARE p_zaw_gcw_c CURSOR FOR
           SELECT gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12 FROM gcw_file
              WHERE gcw01 = g_zaw.zaw01 AND gcw02 = g_zaw.zaw02 AND gcw03 = g_zaw.zaw04 AND gcw04 = g_zaw.zaw05 AND gcw12 = g_zaw.zaw10
    
      LET l_i = 0
      FOREACH p_zaw_gcw_c INTO l_gcw.*
         LET l_i = l_i + 1
      END FOREACH
      
      IF l_i = 0 THEN
         LET l_gcw.gcw11 = "Y"
      END IF
 
      DISPLAY g_zaw.zaw01,g_zaw.zaw02,g_zaw.zaw04,g_zaw.zaw05,g_zaw.zaw10,l_gcw.gcw11,g_zaw.gaz03,g_zaw.zx02,g_zaw.zw02
         TO zaw01,zaw02,zaw04,zaw05,zaw10,gcw11,gaz03,zx02,zw02
 
      INPUT BY NAME l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11 WITHOUT DEFAULTS     
         ON CHANGE gcw05
            #檢查檔名段落是否重覆
            IF l_gcw.gcw05=l_gcw.gcw06 OR l_gcw.gcw05=l_gcw.gcw07 OR l_gcw.gcw05=l_gcw.gcw08 OR l_gcw.gcw05=l_gcw.gcw09 OR l_gcw.gcw05=l_gcw.gcw10 THEN
              CALL cl_err('1','azz1000',1)
            END IF
          
         ON CHANGE gcw06
            #檢查檔名段落是否重覆
            IF l_gcw.gcw06=l_gcw.gcw05 OR l_gcw.gcw06=l_gcw.gcw07 OR l_gcw.gcw06=l_gcw.gcw08 OR l_gcw.gcw06=l_gcw.gcw09 OR l_gcw.gcw06=l_gcw.gcw10 THEN
              CALL cl_err('2','azz1000',1)
            END IF     
                
         ON CHANGE gcw07
            #檢查檔名段落是否重覆
            IF l_gcw.gcw07=l_gcw.gcw05 OR l_gcw.gcw07=l_gcw.gcw06 OR l_gcw.gcw07=l_gcw.gcw08 OR l_gcw.gcw07=l_gcw.gcw09 OR l_gcw.gcw07=l_gcw.gcw10 THEN
              CALL cl_err('3','azz1000',1)
            END IF
  
         ON CHANGE gcw08
            #檢查檔名段落是否重覆
            IF l_gcw.gcw08=l_gcw.gcw05 OR l_gcw.gcw08=l_gcw.gcw06 OR l_gcw.gcw08=l_gcw.gcw07 OR l_gcw.gcw08=l_gcw.gcw09 OR l_gcw.gcw08=l_gcw.gcw10 THEN
              CALL cl_err('4','azz1000',1)
            END IF
  
         ON CHANGE gcw09
            #檢查檔名段落是否重覆
            IF l_gcw.gcw09=l_gcw.gcw05 OR l_gcw.gcw09=l_gcw.gcw06 OR l_gcw.gcw09=l_gcw.gcw07 OR l_gcw.gcw09=l_gcw.gcw08 OR l_gcw.gcw09=l_gcw.gcw10 THEN
              CALL cl_err('5','azz1000',1)
            END IF
 
         ON CHANGE gcw10
            #檢查檔名段落是否重覆
            IF l_gcw.gcw10=l_gcw.gcw05 OR l_gcw.gcw10=l_gcw.gcw06 OR l_gcw.gcw10=l_gcw.gcw07 OR l_gcw.gcw10=l_gcw.gcw08 OR l_gcw.gcw10=l_gcw.gcw09 THEN
              CALL cl_err('6','azz1000',1)
            END IF
 
      END INPUT
  
      IF cl_null(l_gcw.gcw11) THEN 
         LET l_gcw.gcw11 = "N"
      END IF
      
      IF INT_FLAG THEN   #按"取消"
         LET INT_FLAG = 0
         CLOSE WINDOW p_zaw_gcw_w         
         RETURN
      ELSE
      
         #新增
         IF l_i = 0 THEN
            #設主鍵與zaw相同
            LET l_gcw.gcw01 = g_zaw.zaw01   #程式代號
            LET l_gcw.gcw02 = g_zaw.zaw02   #樣板代號
            LET l_gcw.gcw03 = g_zaw.zaw04   #權限類別
            LET l_gcw.gcw04 = g_zaw.zaw05   #使用者
            LET l_gcw.gcw12 = g_zaw.zaw10   #行業別
            
            INSERT INTO gcw_file (gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12)
               VALUES (l_gcw.gcw01,l_gcw.gcw02,l_gcw.gcw03,l_gcw.gcw04,l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11,l_gcw.gcw12)
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF
      
         #修改
         IF l_i > 0 THEN         
            UPDATE gcw_file
               SET gcw05 = l_gcw.gcw05,
                   gcw06 = l_gcw.gcw06,
                   gcw07 = l_gcw.gcw07,
                   gcw08 = l_gcw.gcw08,
                   gcw09 = l_gcw.gcw09,
                   gcw10 = l_gcw.gcw10,
                   gcw11 = l_gcw.gcw11
               WHERE gcw01 = l_gcw.gcw01 AND gcw02 = l_gcw.gcw02 AND gcw03 = l_gcw.gcw03 AND gcw04 = l_gcw.gcw04 AND gcw12 = l_gcw.gcw12
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF
         
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE WINDOW p_zaw_gcw_w
   RETURN
END FUNCTION
 
 
FUNCTION p_zaw_gcw_act ()
   #有資料才顯示"CR報表檔名設定"按鈕
   IF (NOT cl_null(g_zaw.zaw01)) AND (NOT cl_null(g_zaw.zaw02)) AND (NOT cl_null(g_zaw.zaw04)) AND (NOT cl_null(g_zaw.zaw05)) AND (NOT cl_null(g_zaw.zaw10)) THEN
      CALL cl_set_act_visible("gcw_act", TRUE)               
         ELSE
      CALL cl_set_act_visible("gcw_act", FALSE)    
   END IF
END FUNCTION
 
 
FUNCTION p_zaw_filename_show()
   DEFINE l_gcw   RECORD   LIKE gcw_file.*
   DEFINE l_filename       STRING               #報表檔名設定
   DEFINE l_str            STRING
   
   INITIALIZE l_gcw.* TO NULL
   LET l_filename = NULL
   SELECT * INTO l_gcw.* FROM gcw_file          #FUN-920131 全型空白改成半型
      WHERE gcw01 = g_zaw.zaw01 AND gcw02 = g_zaw.zaw02 AND gcw03 = g_zaw.zaw04 AND gcw04 = g_zaw.zaw05 AND gcw12 = g_zaw.zaw10
   
   IF (NOT cl_null(l_gcw.gcw05)) OR (NOT cl_null(l_gcw.gcw06)) OR (NOT cl_null(l_gcw.gcw07)) OR (NOT cl_null(l_gcw.gcw08)) OR (NOT cl_null(l_gcw.gcw09)) OR (NOT cl_null(l_gcw.gcw10)) THEN
      CALL p_zaw_filename_lang(l_gcw.gcw05) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      CALL p_zaw_filename_lang(l_gcw.gcw06) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      CALL p_zaw_filename_lang(l_gcw.gcw07) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      CALL p_zaw_filename_lang(l_gcw.gcw08) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      CALL p_zaw_filename_lang(l_gcw.gcw09) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      CALL p_zaw_filename_lang(l_gcw.gcw10) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED 
      
      LET l_filename = l_filename.substring(1,l_filename.getLength()-1)   #刪除最後一個分隔符號
   ELSE 
      LET l_filename = NULL
   END IF
   DISPLAY l_filename TO filename
 
END FUNCTION
 
 
FUNCTION p_zaw_filename_lang(p_index)
   DEFINE p_index          LIKE    gcw_file.gcw05
   DEFINE l_sql            STRING
   DEFINE l_gae04          LIKE    gae_file.gae04
   
   IF NOT cl_null(p_index) THEN
      LET l_sql = "SELECT gae04 FROM gae_file"
      LET l_sql = l_sql ," WHERE gae01 = 'p_zaw_gcw' AND gae02 = 'gcw05_" ,p_index ,"' AND gae03 = '" ,g_lang ,"' AND gae12 = 'std'"
      LET l_sql = l_sql ," ORDER BY gae11"   #有客製p_perlang資料就先取客製的
   
      DECLARE p_zaw_filename_lang_curs CURSOR FROM l_sql
      FOREACH p_zaw_filename_lang_curs INTO l_gae04
      END FOREACH
   END IF
   
   IF NOT cl_null(l_gae04) THEN
      LET l_gae04 = l_gae04 CLIPPED,"_"
   END IF
   RETURN l_gae04
END FUNCTION
###FUN-8C0025 END #
 
 
###FUN-910012 START ###
FUNCTION p_cr_apr_act()   #報表簽核欄維護作業按鈕是否有效
   DEFINE l_sys_apr         STRING                 #p_cr_apr可接受的模組
   DEFINE l_tok             base.StringTokenizer
   DEFINE l_tmp             STRING
   DEFINE l_c               STRING                 #標準客製模組  #FUN-A50047
   DEFINE l_g               STRING                 #大陸模組     #FUN-A50047
   DEFINE l_cg              STRING                 #大陸客製模組  #FUN-A50047
      
   LET g_open_cr_apr = "N"    #是否要開視窗p_cr_apr
   CALL cl_set_act_visible("cr_apr_act", FALSE)
   
   IF cl_null(g_zaw.zaw01) or cl_null(g_zaw.zaw02) or cl_null(g_zaw.zaw03) or cl_null(g_zaw.zaw04) or cl_null(g_zaw.zaw10) THEN       
      RETURN 
   END IF

   LET g_zz01 = g_zaw.zaw01   #No.FUN-BB0127 改為傳入程式代號而非模組代號
   LET g_open_cr_apr = "Y"    #No.FUN-BB0127
   
#No.FUN-BB0127 --start-- 改為傳入程式代號，不需處理模組別
   #模組  
   #SELECT zz011 INTO g_zz011 FROM zz_file WHERE zz01=g_zaw.zaw01
   #IF SQLCA.sqlcode THEN
      #CALL cl_err3("sel","zz_file",g_zaw.zaw01,"",SQLCA.sqlcode,"","",0)
      #RETURN
   #END IF
 #
   #LET l_sys_apr = "AAP,ABX,ACO,AFA,ANM,APY,ARM,ABM,AIM,APM,ASF,AEM,ASR,AQC,AXM,AXR,AXS,AGL"   #可接受的模組：p_zaw、p_cr_apr設定值相同
                   #"CAP,CBX,CCO,CFA,CNM,CPY,CRM,CBM,CIM,CPM,CSF,CEM,CSR,CQC,CXM,CXR,CXS,CGL"  #FUN-970066 加入客製模組   #FUN-A50047 mark
   #LET l_tok = base.StringTokenizer.createExt(l_sys_apr CLIPPED,",","",TRUE)	#指定分隔符號
   #WHILE l_tok.hasMoreTokens()	#依序取得子字串
      #LET l_tmp = l_tok.nextToken()
      #LET l_tmp = l_tmp.trim()
      #LET l_c = "C",l_tmp.substring(2,l_tmp.getlength())  #FUN-A50047
      #LET l_g = "G",l_tmp.substring(2,l_tmp.getlength())  #FUN-A50047
      #LET l_cg = "C",l_g                                  #FUN-A50047
#
      #IF g_zz011 = l_tmp OR g_zz011 = l_c 
        #OR g_zz011 = l_g OR g_zz011 = l_cg THEN           #FUN-A50047
         #LET g_open_cr_apr = "Y"
      #END IF
   #END WHILE
#No.FUN-BB0127 --end--

   #顯示按鈕 
   IF g_open_cr_apr = "Y" THEN
      CALL cl_set_act_visible("cr_apr_act", TRUE)
   END IF
END FUNCTION
###FUN-910012 END ###
