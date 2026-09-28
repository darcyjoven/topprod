DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
               #wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
               #wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE g_omf_1   DYNAMIC ARRAY OF RECORD
        omf10    LIKE omf_file.omf10,   #类型
        omf11    LIKE omf_file.omf11,   #出货单号
        oga02    LIKE oga_file.oga02,   #出货日期
        ogbud02  LIKE ogb_file.ogbud02, #客户订单号
        omf13    LIKE omf_file.omf13,   #料号
        ima02    LIKE ima_file.ima02,   #品名
        ima021   LIKE ima_file.ima021,  #规格
        omf07    LIKE omf_file.omf07,   #币种
        omf17    LIKE omf_file.omf17,   #单位
        sum_omf16    LIKE ogb_file.ogb12,   #汇总数量
        omf28    LIKE omf_file.omf28,       #原币单价
        omf29    LIKE omf_file.omf29,       #原币税前金额 
        omf29t   LIKE omf_file.omf29t,      #原币含税金额
        omf18    LIKE omf_file.omf18,       #本币单价
        omf19    LIKE omf_file.omf19,       #本币税前金额
        omf19t   LIKE omf_file.omf19t       #本币含税金额
                 END RECORD

DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_argv1         LIKE omf_file.omf00  
DEFINE g_argv2         LIKE gec_file.gec07 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_omf00         LIKE omf_file.omf00   #add by huanglf161114
DEFINE g_omf07         LIKE omf_file.omf07
DEFINE g_omf061        LIKE omf_file.omf061
DEFINE g_omf22         LIKE omf_file.omf22
DEFINE g_sql           STRING 
DEFINE g_gec07         LIKE gec_file.gec07 
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cxmq007_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmq007"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  LET g_argv1 = ARG_VAL(1)
  LET g_argv2 = ARG_VAL(2)
 IF NOT cl_null(g_argv1) THEN 
   LET g_omf00 = g_argv1
   LET g_gec07 = g_argv2
   CALL q007_q()
 END IF  
   CALL q007_menu()

    CLOSE WINDOW cxmq007_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q007_menu()
 
   WHILE TRUE
      CALL q007_bp("G")
      CASE g_action_choice
         WHEN "query"
         IF cl_null(g_argv1) THEN 
               CALL q007_q()
         END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omf_1),'','')
            END IF
         
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q007_q()    
    CLEAR FORM
    CALL g_omf_1.clear()
    IF NOT cl_null(g_argv1) THEN 
      LET g_wc = "1=1"
    ELSE 
     CONSTRUCT g_wc ON                     # 螢幕上取條件  #huanglf161104
        omf10,omf11,oga02,ogaud02,omf13,ima02,ima021,omf07,omf17,omf28,omf29,omf29t,omf18,omf19
        FROM s_omf_1[1].omf10,s_omf_1[1].omf11,s_omf_1[1].oga02,s_omf_1[1].ogbud02,s_omf_1[1].omf13,s_omf_1[1].ima02,
        s_omf_1[1].ima021,s_omf_1[1].omf07,s_omf_1[1].omf17,s_omf_1[1].omf28,s_omf_1[1].omf29,s_omf_1[1].omf29t,s_omf_1[1].omf18,s_omf_1[1].omf19
    
        BEFORE CONSTRUCT
          CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(omf11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_omf11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO omf11
                 NEXT FIELD omf11
              
              OTHERWISE
                 EXIT CASE
           END CASE
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
      ON ACTION about    
         CALL cl_about()  
      
      ON ACTION help       
         CALL cl_show_help()
      
      ON ACTION controlg    
         CALL cl_cmdask()    

      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    END IF 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q007_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q007_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_i       LIKE type_file.num5
DEFINE l_rec_b   LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_omf11   LIKE omf_file.omf11,
       l_omf13   LIKE omf_file.omf13,
       l_omf28   LIKE omf_file.omf28,
       l_omf18   LIKE omf_file.omf18,
       l_flag    LIKE type_file.chr1,
       t_azi04   LIKE azi_file.azi04
DEFINE  l_sum1   LIKE omf_file.omf19,
         l_sum2   LIKE omf_file.omf19,
         l_sum3   LIKE omf_file.omf19,
         l_sum4   LIKE omf_file.omf19,
         l_sum5   LIKE omf_file.omf19,
         l_sum6   LIKE omf_file.omf19,
         l_sum7   LIKE omf_file.omf16, 
         l_oha09  LIKE oha_file.oha09,
         l_omf19x  LIKE omf_file.omf19x,
         l_omf29x   LIKE omf_file.omf29x
DEFINE l_sql1 STRING 
DEFINE p_wc2  STRING

 IF cl_null(p_wc2) THEN
    LET p_wc2 = "1=1" 
 END IF 
 SELECT omf07,omf061,omf22 INTO g_omf07,g_omf061,g_omf22 FROM omf_file WHERE omf00 = g_omf00
 SELECT azi04 INTO t_azi04 FROM azi_file
 WHERE azi01 = g_omf07  
 CALL cre_omf_tmp()  #用来存储料号+本币单价+原币单价
 DECLARE sel_omf_cur CURSOR FOR
 SELECT DISTINCT omf11,omf13  FROM omf_file WHERE omf00=g_omf00
 FOREACH sel_omf_cur INTO l_omf11,l_omf13
   DECLARE sel_oomf_cur CURSOR FOR 
   SELECT omf28,omf18 FROM omf_file 
   WHERE omf00=g_omf00 AND omf11=l_omf11 AND omf13=l_omf13 #add by huanglf161114
   ORDER BY omf21 DESC
   OPEN sel_oomf_cur 
   FETCH sel_oomf_cur INTO l_omf28,l_omf18
   CLOSE sel_oomf_cur 
   INSERT INTO t670_omf_tmp  VALUES (l_omf11,l_omf13,l_omf28,l_omf18)
   IF STATUS THEN 
      CALL cl_err('ins tmp err',STATUS,1)
      EXIT FOREACH 
      LET l_flag='N'
   END IF    
   
 END FOREACH 
 IF l_flag='N' THEN
    RETURN
 END IF 
 LET l_i=1
 LET l_sum1=0
 LET l_sum2=0
 LET l_sum3=0
 LET l_sum4=0
 LET l_sum5=0
 LET l_sum6=0
 LET l_sum7=0
 
 LET l_sql1 = "SELECT omf10,omf11,'',ogbud02,omf13,ima02,ima021,omf07,omf17,sum(omf16),0,0,0,0,0,0 FROM 
               omf_file left join ogb_file on omf11=ogb01 AND omf12=ogb03,ima_file 
               WHERE omf00 = '",g_omf00,"' ",
               " AND omf13=ima01  AND ",p_wc2 CLIPPED, 
               " GROUP BY omf10,omf11,ogbud02,omf13,ima02,ima021,omf07,omf17"
 PREPARE sel_omf1_pre FROM l_sql1
 DECLARE sel_omf1_cur CURSOR FOR sel_omf1_pre
 FOREACH sel_omf1_cur INTO g_omf_1[l_i].*
   IF g_omf_1[l_i].omf10 = '2' THEN 
      LET l_oha09 = ''
      LET g_sql = " SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                  "  WHERE oha01 = '",g_omf_1[l_i].omf11,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_oha09_pre_1_aa FROM g_sql
      EXECUTE sel_oha09_pre_1_aa INTO l_oha09
   END IF 


   SELECT oga02 INTO g_omf_1[l_i].oga02 FROM oga_file WHERE oga01=g_omf_1[l_i].omf11  #出货日期
   SELECT omf28,omf18 INTO g_omf_1[l_i].omf28,g_omf_1[l_i].omf18 FROM t670_omf_tmp WHERE omf11=g_omf_1[l_i].omf11
   AND omf13=g_omf_1[l_i].omf13
   IF g_gec07 = 'Y' THEN    #含稅
      IF g_omf_1[l_i].sum_omf16 <> 0 THEN     
         LET g_omf_1[l_i].omf29 = cl_digcut((g_omf_1[l_i].omf28*g_omf_1[l_i].sum_omf16),t_azi04)/(1+g_omf061/100)    
         LET g_omf_1[l_i].omf29t = g_omf_1[l_i].sum_omf16 * g_omf_1[l_i].omf28
      ELSE
         IF l_oha09 = '5' THEN 
            LET g_omf_1[l_i].omf29 = cl_digcut((g_omf_1[l_i].omf28*(-1)),t_azi04)/(1+g_omf061/100)
            LET g_omf_1[l_i].omf29t =-1* g_omf_1[l_i].omf28
         END IF 
      END IF
   ELSE                     #不含稅
      #未稅金額=未稅單價*數量
      IF g_omf_1[l_i].sum_omf16 <> 0 THEN
         LET g_omf_1[l_i].omf29 = g_omf_1[l_i].sum_omf16 * g_omf_1[l_i].omf28
         LET g_omf_1[l_i].omf29 = cl_digcut(g_omf_1[l_i].omf29,t_azi04)
         LET g_omf_1[l_i].omf29t = g_omf_1[l_i].omf29 * (1+g_omf061/100) 
      ELSE
         IF l_oha09 = '5' THEN
            LET g_omf_1[l_i].omf29 = -1*g_omf_1[l_i].omf28
            LET g_omf_1[l_i].omf29 = cl_digcut(g_omf_1[l_i].omf29,t_azi04)
            LET g_omf_1[l_i].omf29t = g_omf_1[l_i].omf29 * (1+g_omf061/100)
         END IF
      END IF                                            
    END IF
    LET g_omf_1[l_i].omf29 = cl_digcut(g_omf_1[l_i].omf29,t_azi04)
    LET g_omf_1[l_i].omf29t = cl_digcut(g_omf_1[l_i].omf29t,t_azi04) #FUN-C60036 add
    LET g_omf_1[l_i].omf19 = g_omf_1[l_i].omf29 * g_omf22
    LET g_omf_1[l_i].omf19 = cl_digcut(g_omf_1[l_i].omf19,g_azi04)     #本幣
    LET g_omf_1[l_i].omf19t = g_omf_1[l_i].omf29t * g_omf22
    LET g_omf_1[l_i].omf19t = cl_digcut(g_omf_1[l_i].omf19t,g_azi04)   #本幣
    LET l_omf29x = g_omf_1[l_i].omf29t -g_omf_1[l_i].omf29 #原幣稅額
    LET l_omf29x = cl_digcut(l_omf29x,t_azi04)
    LET l_omf19x = g_omf_1[l_i].omf19t - g_omf_1[l_i].omf19
    LET l_omf19x = cl_digcut(l_omf19x,g_azi04) 
    LET l_sum1=l_sum1+g_omf_1[l_i].omf29     #原币税前金额合计
    LET l_sum2=l_sum2+l_omf29x    #原币税额合计
    LET l_sum3=l_sum3+g_omf_1[l_i].omf29t    #原币含税金额合计
    LET l_sum4=l_sum4+g_omf_1[l_i].omf19     #本币税前金额合计
    LET l_sum5=l_sum5+l_omf19x               #本币税额合计 
    LET l_sum6=l_sum6+g_omf_1[l_i].omf19t    #本币含税金额合计
    LET l_sum7=l_sum7+g_omf_1[l_i].sum_omf16
    LET l_i=l_i+1
          

 END FOREACH 
 

   DISPLAY l_sum1 TO FORMONLY.sum1
   DISPLAY l_sum2 TO FORMONLY.sum2
   DISPLAY l_sum3 TO FORMONLY.sum3
   DISPLAY l_sum4 TO FORMONLY.sum4
   DISPLAY l_sum5 TO FORMONLY.sum5
   DISPLAY l_sum6 TO FORMONLY.sum6
   DISPLAY l_sum7 TO FORMONLY.sum7
 
END FUNCTION

FUNCTION cre_omf_tmp()
DROP TABLE t670_omf_tmp
CREATE TEMP TABLE  t670_omf_tmp
(omf11   LIKE omf_file.omf11,
 omf13   LIKE omf_file.omf13,
 omf28   LIKE omf_file.omf28,
 omf18   LIKE omf_file.omf18)
DROP TABLE t6701_omf_tmp


END FUNCTION

 FUNCTION q007_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omf_1 TO s_omf_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
              
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
