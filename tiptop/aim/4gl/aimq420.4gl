# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimq420.4gl
# Descriptions...: 料件庫存數量查詢For多屬性管理
# Date & Author..: 05/01/24 By Lifeng
# Comments ......:
#      這支作業從aimq420.4gl拷貝而來,刪除了單頭部分下條件的各個欄位,
#  而改在單身中間以INPUT(非原來的CONSTRUCT)方式下條件,并按照多屬性管
#  理的要求做了相應的調整,增加了按照料件屬性組動態提供明細屬性供查詢
#  的功能,以適應多屬性料號管理的要求
#------MODIFICATIION-------MODIFICATION-------MODIFIACTION-------
# Modify         : No.MOD-530868 05/03/30 by alexlin VAR CHAR->CHAR
# Modify         : No.FUN-640013 06/04/08 By Lifeng 料件多屬性新機制修改
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-660059 06/06/13 By Rayven imandx_file改imx_file有些欄位修改有誤，重新修正
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790006 07/09/03 By lumingxing 匯出EXCEL匯出的值多一空白行
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm     RECORD
            wc    LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)
            wc2   LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)
           END RECORD,
    g_ima  RECORD
            ima01  LIKE ima_file.ima01, # 料件編號
            ima02  LIKE ima_file.ima02, # 品名規格
            ima021 LIKE ima_file.ima021 # 品名規格
           END RECORD,
 
    #------------------------------------------------------------
    # 2005-01-24 Add By Lifeng Start
    #這個數組用于存放屏幕上各個列的顯示情況和當前值
    g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr3,   #欄位名稱，從't01'~'t20' #No.FUN-690026 VARCHAR(3)
            imx000    LIKE type_file.chr8,   #該欄位在imx_file中對應的欄位名稱#No.FUN-690026 VARCHAR(8)
            visible   LIKE type_file.chr1,   #是否可見，'Y'或'N'  #No.FUN-690026 VARCHAR(1)
            value     LIKE ima_file.ima01    #存放當前當前值
            END RECORD,
    g_img DYNAMIC ARRAY OF RECORD
            img01   LIKE img_file.img01, # 料件編號
            t01     LIKE imx_file.imx01, # 明細屬性欄位
            t02     LIKE imx_file.imx01, # 明細屬性欄位
            t03     LIKE imx_file.imx01, # 明細屬性欄位
            t04     LIKE imx_file.imx01, # 明細屬性欄位
            t05     LIKE imx_file.imx01, # 明細屬性欄位
            t06     LIKE imx_file.imx01, # 明細屬性欄位
            t07     LIKE imx_file.imx01, # 明細屬性欄位
            t08     LIKE imx_file.imx01, # 明細屬性欄位
            t09     LIKE imx_file.imx01, # 明細屬性欄位
            t10     LIKE imx_file.imx01, # 明細屬性欄位
            t11     LIKE imx_file.imx01, # 明細屬性欄位
            t12     LIKE imx_file.imx01, # 明細屬性欄位
            t13     LIKE imx_file.imx01, # 明細屬性欄位
            t14     LIKE imx_file.imx01, # 明細屬性欄位
            t15     LIKE imx_file.imx01, # 明細屬性欄位
            t16     LIKE imx_file.imx01, # 明細屬性欄位
            t17     LIKE imx_file.imx01, # 明細屬性欄位
            t18     LIKE imx_file.imx01, # 明細屬性欄位
            t19     LIKE imx_file.imx01, # 明細屬性欄位
            t20     LIKE imx_file.imx01, # 明細屬性欄位
            img02   LIKE img_file.img02, #倉庫編號
            img03   LIKE img_file.img03, #存放位置
            img04   LIKE img_file.img04, #存放批號
            img23   LIKE img_file.img23, #是否為可用倉庫
            img09   LIKE img_file.img09, #庫存單位
            img10   LIKE img_file.img10, #庫存數量
            img21   LIKE img_file.img21, #Factor
            img37   LIKE img_file.img37  # Expire date
        END RECORD,
    #這個記錄專門用于下條件
 
    g_construct ARRAY[1] OF RECORD
            img01   LIKE img_file.img01, # 料件編號
            t01     LIKE imx_file.imx01, # 明細屬性欄位
            t02     LIKE imx_file.imx01, # 明細屬性欄位
            t03     LIKE imx_file.imx01, # 明細屬性欄位
            t04     LIKE imx_file.imx01, # 明細屬性欄位
            t05     LIKE imx_file.imx01, # 明細屬性欄位
            t06     LIKE imx_file.imx01, # 明細屬性欄位
            t07     LIKE imx_file.imx01, # 明細屬性欄位
            t08     LIKE imx_file.imx01, # 明細屬性欄位
            t09     LIKE imx_file.imx01, # 明細屬性欄位
            t10     LIKE imx_file.imx01, # 明細屬性欄位
            t11     LIKE imx_file.imx01, # 明細屬性欄位
            t12     LIKE imx_file.imx01, # 明細屬性欄位
            t13     LIKE imx_file.imx01, # 明細屬性欄位
            t14     LIKE imx_file.imx01, # 明細屬性欄位
            t15     LIKE imx_file.imx01, # 明細屬性欄位
            t16     LIKE imx_file.imx01, # 明細屬性欄位
            t17     LIKE imx_file.imx01, # 明細屬性欄位
            t18     LIKE imx_file.imx01, # 明細屬性欄位
            t19     LIKE imx_file.imx01, # 明細屬性欄位
            t20     LIKE imx_file.imx01, # 明細屬性欄位
            img02   LIKE img_file.img02, #倉庫編號
            img03   LIKE img_file.img03, #存放位置
            img04   LIKE img_file.img04, #存放批號
            img23   LIKE img_file.img23, #是否為可用倉庫
            img09   LIKE img_file.img09, #庫存單位
            img10   LIKE img_file.img10, #庫存數量
            img21   LIKE img_file.img21, #Factor
            img37   LIKE img_file.img37  # Expire date
        END RECORD,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之后進入next  #No.FUN-690026 SMALLINT
    g_sql           LIKE type_file.chr1000,#WHERE CONDITION  #No.FUN-690026 VARCHAR(1000)
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    g_tot           LIKE type_file.num10,  #No.FUN-690026 INTEGER
    g_select        LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
 
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8      #No.FUN-6A0074
   DEFINE l_sl    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_i     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_msg   LIKE type_file.chr3     #No.FUN-690026 VARCHAR(3)
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q420_w AT p_row,p_col
         WITH FORM "aim/42f/aimq420"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    #隱藏子料件號及明細屬性欄位
    CALL cl_set_comp_visible('img01',FALSE)
    FOR l_i = 1 TO 20
        LET l_msg = 't',l_i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
    END FOR
 
    CALL q420_menu()
    CLOSE WINDOW q420_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q420_cs()
   DEFINE
      l_cnt        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
      l_i          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
      l_msg        LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
      l_hasimx     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
      #這個數組用于接收各個屬性列的詳細信息
      g_agb        ARRAY[10] OF RECORD
                   agb03 LIKE agb_file.agb03,  #屬性代碼
                   agc02 LIKE agc_file.agc02,  #屬性的中文描述
                   agc03 LIKE agc_file.agc03,  #欄位長度
                   agc04 LIKE agc_file.agc04,  #欄位使用方式□1隨便輸，
                                               #2選擇,3有范圍的輸入
                   agc05 LIKE agc_file.agc05,  #欄位限定起始值
                   agc06 LIKE agc_file.agc06   #欄位限定截至值
                   END RECORD,
      ls_ima01     STRING,
      ls_like      base.StringBuffer,
      lsb_item     base.StringBuffer,
      lsb_value    base.StringBuffer,
      l_agd02      LIKE agd_file.agd02,
      l_agd03      LIKE agd_file.agd03,
      l_wc         LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(500)
 
 
      CLEAR FORM #清除畫面
      CALL g_img.clear()
      CALL g_value.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL	
      INITIALIZE g_ima.* TO NULL	
 
      #首先隱藏所有明細屬性欄位,以后根據用戶輸入的料號來決定怎樣顯示
      CALL cl_set_comp_visible('img01',FALSE)
      FOR l_i = 1 TO 20
          LET l_msg = 't',l_i USING '&&'
          CALL cl_set_comp_visible(l_msg,FALSE)
      END FOR
      
           CALL cl_set_head_visible("grid01","YES")   #No.FUN-6B0030
      #對單頭下條件
      INPUT BY NAME g_ima.ima01 WITHOUT DEFAULTS
         ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.default1 = g_ima.ima01
               CALL cl_create_qry() RETURNING g_ima.ima01
               DISPLAY BY NAME g_ima.ima01
               NEXT FIELD ima01
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      END INPUT
 
      IF INT_FLAG THEN  RETURN  END IF
 
      #以INPUT方式來接受條件查詢并自己手工合成條件
      INPUT ARRAY g_img WITHOUT DEFAULTS FROM s_img.*
            ATTRIBUTE(COUNT=1,MAXCOUNT=1,UNBUFFERED,INSERT ROW=TRUE,
                      DELETE ROW=TRUE,APPEND ROW=TRUE)
          BEFORE INPUT
          #顯示明細屬性欄位
          #首先隱藏所有明細屬性欄位，因為要應付用戶沒有確認而多次
          #修改ima01欄位的內容的情況，避免顯示出不對的東東
          CALL cl_set_comp_visible('img01',FALSE)
          FOR l_i = 1 TO 20
              LET l_msg = 't',l_i USING '&&'
              CALL cl_set_comp_visible(l_msg,FALSE)
          END FOR
          #以下代碼的說明可以參考saxmt400.4gl By Lifeng
          IF NOT cl_null(g_ima.ima01) THEN
             IF cl_is_multi_feature_manage(g_ima.ima01) = TRUE THEN
                CALL g_agb.clear()
                DECLARE agb_cur CURSOR FOR
                SELECT agb03,agc02,agc03,agc04,agc05,agc06
                  FROM agb_file,agc_file,ima_file
                 WHERE agb01 = imaag AND agc01 = agb03
                   AND ima01 = g_ima.ima01
                 ORDER BY agb02
 
                LET l_i = 1
                FOREACH agb_cur INTO g_agb[l_i].*
                   #判斷循環的正確性
                   IF STATUS THEN
                      CALL cl_err('foreach agb',STATUS,0)
                      EXIT FOREACH
                   END IF
 
                   #判斷當前這一個屬性列的取值方式
                   IF g_agb[l_i].agc04 = 2 THEN  #如果是預定義值則顯示組合框
                      #隱藏本組對應的編輯框
                      LET l_msg = 't',2*l_i-1 USING '&&'
                      CALL cl_set_comp_visible(l_msg,FALSE)
                      #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                      LET g_value[2*l_i-1].fname = l_msg
                      LET g_value[2*l_i-1].visible = 'N'
#                     LET g_value[2*l_i-1].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                      LET g_value[2*l_i-1].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
 
                      #設置組合框對應列的列標題
                      LET l_msg = 't',2*l_i USING '&&'
                      CALL cl_set_comp_att_text(l_msg,g_agb[l_i].agc02)
                      CALL cl_set_comp_visible(l_msg,TRUE)
                      #CALL q420_set_col_width(l_msg,LENGTH(g_agb[l_i].agc02))
                      #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                      LET g_value[2*l_i].fname = l_msg
                      LET g_value[2*l_i].visible = 'Y'
#                     LET g_value[2*l_i].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                      LET g_value[2*l_i].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
                      #填充組合框中的選項
                      LET lsb_item  = base.StringBuffer.create()
                      LET lsb_value = base.StringBuffer.create()
                      DECLARE agd_cur CURSOR FOR
                      SELECT agd02,agd03 FROM agd_file
                       WHERE agd01 = g_agb[l_i].agb03
                      FOREACH agd_cur INTO l_agd02,l_agd03
                        IF STATUS THEN
                           CALL cl_err('foreach agb',STATUS,0)
                           EXIT FOREACH
                        END IF
                        #lsb_value放選項的說明
                        CALL lsb_value.append(l_agd03 CLIPPED || ",")
                        #lsb_item放選項的值
                        CALL lsb_item.append(l_agd02 CLIPPED || ",")
                      END FOREACH
                      CALL cl_set_combo_items(l_msg,lsb_item.toString(),
                                                 lsb_value.toString())
                   ELSE  #否則顯示文本框
                      #隱藏本組對應的組合框
                      LET l_msg = 't',2*l_i USING '&&'
                      CALL cl_set_comp_visible(l_msg,FALSE)
                      #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                      LET g_value[2*l_i].fname = l_msg
                      LET g_value[2*l_i].visible = 'N'
#                     LET g_value[2*l_i].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                      LET g_value[2*l_i].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
 
                      #設置編輯框對應列的列標題
                      LET l_msg = 't',2*l_i-1 USING '&&'
                      CALL cl_set_comp_att_text(l_msg,g_agb[l_i].agc02)
                      CALL cl_set_comp_visible(l_msg,TRUE)
                      #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                      LET g_value[2*l_i-1].fname = l_msg
                      LET g_value[2*l_i-1].visible = 'Y'
#                     LET g_value[2*l_i-1].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                      LET g_value[2*l_i-1].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
                   END IF
 
                   LET l_i = l_i + 1
                   #這里防止下標溢出導致錯誤
                   IF l_i = 11 THEN EXIT FOREACH END IF
              END FOREACH
 
              #將剩下的列都設置為不可見
              FOR l_i = l_i TO 10
                 #下面是兩組控件
                  LET l_msg = 't',2*l_i-1 USING '&&'
                  CALL cl_set_comp_visible(l_msg,FALSE)
                  #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                  LET g_value[2*l_i-1].fname = l_msg
                  LET g_value[2*l_i-1].visible = 'N'
#                 LET g_value[2*l_i-1].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                  LET g_value[2*l_i-1].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
 
                  LET l_msg = 't',2*l_i USING '&&'
                  CALL cl_set_comp_visible(l_msg,FALSE)
                  #同時要把控件名和是否顯示的信息寫到對應的g_value數組項中去
                   LET g_value[2*l_i].fname = l_msg
                 LET g_value[2*l_i].visible = 'N'
#                 LET g_value[2*l_i].imx000 = 'imx000',l_i USING '&&'  #No.TQC-660059  MARK
                  LET g_value[2*l_i].imx000 = 'imx',l_i USING '&&'  #No.TQC-660059
              END FOR
             END IF
          END IF
 
          AFTER FIELD t01
             IF NOT cl_null(g_img[1].t01) THEN
                LET g_value[1].value = g_img[1].t01 END IF
 
          AFTER FIELD t02
             IF NOT cl_null(g_img[1].t02) THEN
                LET g_value[2].value = g_img[1].t02 END IF
 
          AFTER FIELD t03
             IF NOT cl_null(g_img[1].t03) THEN
                LET g_value[3].value = g_img[1].t03 END IF
 
          AFTER FIELD t04
             IF NOT cl_null(g_img[1].t04) THEN
                LET g_value[4].value = g_img[1].t04 END IF
 
          AFTER FIELD t05
             IF NOT cl_null(g_img[1].t05) THEN
                LET g_value[5].value = g_img[1].t05 END IF
 
          AFTER FIELD t06
             IF NOT cl_null(g_img[1].t06) THEN
                LET g_value[6].value = g_img[1].t06 END IF
 
          AFTER FIELD t07
             IF NOT cl_null(g_img[1].t07) THEN
                LET g_value[7].value = g_img[1].t07 END IF
 
          AFTER FIELD t08
             IF NOT cl_null(g_img[1].t08) THEN
                LET g_value[8].value = g_img[1].t08 END IF
 
          AFTER FIELD t09
             IF NOT cl_null(g_img[1].t09) THEN
                LET g_value[9].value = g_img[1].t09 END IF
 
          AFTER FIELD t10
             IF NOT cl_null(g_img[1].t10) THEN
                LET g_value[10].value = g_img[1].t10 END IF
 
          AFTER FIELD t11
             IF NOT cl_null(g_img[1].t11) THEN
                LET g_value[11].value = g_img[1].t11 END IF
 
          AFTER FIELD t12
             IF NOT cl_null(g_img[1].t12) THEN
                LET g_value[12].value = g_img[1].t12 END IF
 
          AFTER FIELD t13
             IF NOT cl_null(g_img[1].t13) THEN
                LET g_value[13].value = g_img[1].t13 END IF
 
          AFTER FIELD t14
             IF NOT cl_null(g_img[1].t14) THEN
                LET g_value[14].value = g_img[1].t14 END IF
 
          AFTER FIELD t15
             IF NOT cl_null(g_img[1].t15) THEN
                LET g_value[15].value = g_img[1].t15 END IF
 
          AFTER FIELD t16
             IF NOT cl_null(g_img[1].t16) THEN
                LET g_value[16].value = g_img[1].t16 END IF
 
          AFTER FIELD t17
             IF NOT cl_null(g_img[1].t17) THEN
                LET g_value[17].value = g_img[1].t17 END IF
 
          AFTER FIELD t18
             IF NOT cl_null(g_img[1].t18) THEN
                LET g_value[18].value = g_img[1].t18 END IF
 
          AFTER FIELD t19
             IF NOT cl_null(g_img[1].t19) THEN
                LET g_value[19].value = g_img[1].t19 END IF
 
          AFTER FIELD t20
             IF NOT cl_null(g_img[1].t20) THEN
                LET g_value[20].value = g_img[1].t20 END IF
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
      END INPUT
 
      LET tm.wc = ' 1=1'
      LET tm.wc2 = ' 1=1'
      LET l_wc = ''
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET tm.wc = ' 1=2'   #如果用戶選擇取消則給出一個永遠滿足不了的條件
      ELSE
         #下面是根據各個欄位的輸入情況手工合成條件
         IF NOT cl_null(g_ima.ima01) THEN
            LET ls_ima01 = g_ima.ima01
            #如果用戶輸入了×或？進行模糊匹配則不自動添加％，而是使用原來的進行替換
            IF (ls_ima01.getIndexOf('*',1) > 0)OR(ls_ima01.getIndexOf('?',1) > 0) THEN
               LET ls_like = base.stringBuffer.Create()
               CALL ls_like.append(ls_ima01)
               CALL ls_like.replace('*','%',0)  #將所有*替換成%
               CALL ls_like.replace('?','_',0)  #將所有?替換成_
               LET tm.wc = tm.wc,' AND ima01 LIKE ''',ls_like.toString(),''''
            ELSE
               LET tm.wc = tm.wc,' AND ima01 LIKE ''',g_ima.ima01,'%'' '
            END IF
         END IF
         IF NOT cl_null(g_img[1].img02) THEN
            LET tm.wc2 = tm.wc2,' AND img02 = ''',g_img[1].img02,''' '
         END IF
         IF NOT cl_null(g_img[1].img03) THEN
            LET tm.wc2 = tm.wc2,' AND img03 = ''',g_img[1].img03,''' '
         END IF
         IF NOT cl_null(g_img[1].img04) THEN
            LET tm.wc2 = tm.wc2,' AND img04 = ''',g_img[1].img04,''' '
         END IF
         #下面根據用戶選擇明細屬性來合成條件以及合成選擇欄位
         #所謂選擇欄位是指從imx_file中取得的資料，因為屏幕數組中一共
         #有20個變量，而imx_file中只有10個欄位，所以有一半以上的欄位
         #是需要使用SELECT '' AS txx的形式填充的，下面的語句就是把所有
         #顯示出來的數組中都填充入imx_file表中的內容，而不顯示欄位都
         #用''來填充
         LET g_select = ''
         FOR l_i = 1 TO 20 STEP 2
             IF (g_value[l_i].visible = 'Y')OR
                (g_value[l_i+1].visible = 'Y') THEN
                IF g_value[l_i].visible = 'Y' THEN
                   #欄位顯示則要從數據表中去欄位
                   LET g_select = g_select,'rtrim(',g_value[l_i].imx000,
                                  ') as ',g_value[l_i].fname,','
                   #如果不僅顯示而且還輸入了條件則把條件記錄加入到語句中
                   IF NOT cl_null(g_value[l_i].value) THEN
                      LET l_wc = l_wc,' AND rtrim(',g_value[l_i].imx000,') = ''',
                                 g_value[l_i].value,''' '
                   END IF
                   #同時顯示同組的另一個欄位為空
                   LET g_select = g_select,''' '' as ',g_value[l_i+1].fname,','
                ELSE
                   #同時顯示同組的另一個欄位為空
                   LET g_select = g_select,''' '' as ',g_value[l_i].fname,','
                   #欄位顯示則要從數據表中去欄位
                   LET g_select = g_select,'rtrim(',g_value[l_i+1].imx000,
                                  ') as ',g_value[l_i+1].fname,','
                   #如果不僅顯示而且還輸入了條件則把條件記錄加入到語句中
                   IF NOT cl_null(g_value[l_i+1].value) THEN
                      LET l_wc = l_wc,' AND rtrim(',g_value[l_i+1].imx000,') = ''',
                                 g_value[l_i+1].value,''' '
                   END IF
                END IF
             ELSE
                #如果不顯示則不從數據表中取欄位
                LET g_select = g_select,''' '' as ',g_value[l_i].fname,','
                LET g_select = g_select,''' '' as ',g_value[l_i+1].fname,','
             END IF
         END FOR
         IF NOT cl_null(l_wc) THEN
            LET tm.wc2 = tm.wc2 CLIPPED,l_wc
         END IF
   END IF
 
  #關于tm.wc,tm.wc2以及l_wc的作用:
  #tm.wc用于存放從ima_file中下條件的語句,tm.wc2用于存放從img_file中下條件
  #的語句,這兩個變量的定義是和標准作業aimq420中完全相同的,而l_wc中存放的
  #是從imx_file中下條件的語句,是新增加的
 
   MESSAGE ' WAIT '
   LET g_sql = "SELECT ima01 FROM ima_file",
               " WHERE ima01 = '",g_ima.ima01,"'",
               " ORDER BY ima01"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagcup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagcup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   PREPARE q420_prepare FROM g_sql
   DECLARE q420_cs                         #SCROLL CURSOR
      SCROLL CURSOR FOR q420_prepare
 
   LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ima01 = '",g_ima.ima01,"'"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagcup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagcup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q420_pp  FROM g_sql
   DECLARE q420_count   CURSOR FOR q420_pp
END FUNCTION
 
FUNCTION q420_menu()
 
   WHILE TRUE
      CALL q420_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q420_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q420_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q420_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q420_count
       FETCH q420_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q420_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q420_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q420_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q420_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q420_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q420_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q420_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT ima01,ima02,ima021 INTO g_ima.*
      FROM ima_file
     WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q420_show()
END FUNCTION
 
FUNCTION q420_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q420_b_fill() #單身
END FUNCTION
 
FUNCTION q420_b_fill()              #BODY FILL UP
#FUN-640013 Modify By Lifeng Start --
#在料件多屬性新機制下，imx_file中已經增加了一個新欄位imx00母料件編號
#因此在下面的查詢語句中不用再使用不可靠的前綴加LIKE的方式，而直接采用
#等于母料件編號的方式 
#   LET g_sql = "SELECT img01,",g_select,
#               " img02,img03,img04,img23,img09,img10,img21,img37",
#               " FROM img_file,imx_file,ima_file_file ima1, ima_file ima2",
#               " WHERE ima2.ima01 = '",g_ima.ima01,"'",
#               "   AND ima1.imaag1 = ima2.imaag",
#               "   AND img01 = rtrim(imx000) AND img01 = ima1.ima01 ",
#               "   AND ",tm.wc2 CLIPPED
 
   LET g_sql = "SELECT img01,",g_select,
               " img02,img03,img04,img23,img09,img10,img21,img37",
               " FROM imx_file, img_file  ",
               " WHERE imx00 ='",g_ima.ima01,"'",
               " AND img01 = rtrim(imx000) AND ",tm.wc2 CLIPPED
#FUN-640013 End --               
 
    PREPARE q420_pb FROM g_sql
    DECLARE q420_bcs                       #BODY CURSOR
        CURSOR FOR q420_pb
   CALL g_img.clear()
   LET g_tot = 0
   LET g_cnt = 1
   FOREACH q420_bcs INTO g_img[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     LET g_tot = g_tot + g_img[g_cnt].img10
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err('',9035,0)
        EXIT FOREACH
     END IF
   END FOREACH
   CALL g_img.deleteElement(g_cnt)  #TQC-790006
 
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_tot TO FORMONLY.tot
 
END FUNCTION
 
FUNCTION q420_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
         #LET l_ac = ARR_CURR()
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q420_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION previous
         CALL q420_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION jump
         CALL q420_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION next
         CALL q420_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION last
         CALL q420_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
#        LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q420_bp_refresh()
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
{
FUNCTION q420_set_col_width(p_name,p_width)
DEFINE
  p_name            STRING,
  p_width           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
 
  lwin_curr         ui.Window,
  lnode_win         om.DomNode,
  llst_items        om.NodeList,
  lnode_item        om.DomNode,
  lnode_child       om.DomNode,
  ls_item_name      STRING,
  li_i              LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  LET lwin_curr = ui.Window.getCurrent()
  LET lnode_win = lwin_curr.getNode()
  LET llst_items = lnode_win.selectByPath("//Form//*")
 
  FOR li_i = 1 TO llst_items.getLength()
      LET lnode_item = llst_items.item(li_i)
      LET ls_item_name = lnode_item.getAttribute("colname")
 
      IF ls_item_name IS NULL THEN
         CONTINUE FOR
      END IF
 
     LET ls_item_name = ls_item_name.trim()
 
     IF (ls_item_name.equals(p_name)) THEN
        LET lnode_child = lnode_item.getFirstChild()
        CALL lnode_child.setAttribute("Width",p_width)
        EXIT FOR
     END IF
  END FOR
 
END FUNCTION
}
