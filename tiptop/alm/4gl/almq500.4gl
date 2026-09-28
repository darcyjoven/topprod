# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: almq500.4gl
# Descriptions...: 會員銷售資料查詢作業
# Date & Author..:NO.FUN-B30202 11/04/02 By huangtao 
# Modify.........: No.MOD-B40147 11/04/18 By huangtao 查詢條件組成的字符串溢出
# Modify.........: No.FUN-B50097 11/05/19 By huangtao 查詢會員銷售資料增加條件POS上傳方式
# Modify.........: No.FUN-B60085 11/06/20 By huangtao 銷售日期-->oga02，計算銷退
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No:FUN-B90118 12/01/11 by pauline 查詢時, 上傳方式是匯總時,資料顯示的來源改為lpl_file,加入ogb_file及ohb_file非POS交易的資料

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  
     g_lpl_1       RECORD 
                   t_lpl01    LIKE lpl_file.lpl01,
                   t_lplplant LIKE lpl_file.lplplant,
                   t_lpl02    LIKE type_file.chr100
                   END RECORD,
     g_lpl         DYNAMIC ARRAY OF RECORD
                   lpl01    LIKE lpl_file.lpl01,
                   lpl02    LIKE lpl_file.lpl02,
                   lplplant LIKE lpl_file.lplplant,
                   rtz13    LIKE rtz_file.rtz13,
                   lpl03    LIKE lpl_file.lpl03,
                   lpl04    LIKE lpl_file.lpl04,
                   lne05    LIKE lne_file.lne05,
                   lpl05    LIKE lpl_file.lpl05,
                   ima02    LIKE ima_file.ima02,
                   lpl06    LIKE lpl_file.lpl06,
                   lpl07    LIKE lpl_file.lpl07,
                   lpl08    LIKE lpl_file.lpl08
                   END RECORD,
     g_sql           STRING,
#     g_wc            LIKE type_file.chr1000,       #MOD-B40147  mark
     g_wc            STRING,                         #MOD-B40147  add
     g_cnt           LIKE type_file.num10, 
     g_rec_b         LIKE type_file.num5,      #單身筆數 
     l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_org        STRING
DEFINE g_ryz       RECORD LIKE ryz_file.*

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_lpl_1.t_lpl01 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF   
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time     
   SELECT * INTO g_ryz.* FROM ryz_file WHERE ryz01 = '0'   #FUN-B50097 add
   LET p_row = 2 LET p_col = 12
   OPEN WINDOW q500_w AT p_row,p_col              #顯示畫面
        WITH FORM "alm/42f/almq500"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)     
   CALL cl_ui_init() 
   IF NOT cl_null(g_lpl_1.t_lpl01) THEN
      CALL cl_set_comp_entry("t_lpl01",FALSE)
      LET g_lpl_1.t_lplplant = g_plant
      SELECT lpj08 INTO g_lpl_1.t_lpl02 FROM lpj_file
       WHERE lpj03 = g_lpl_1.t_lpl01
      IF cl_null(g_lpl_1.t_lpl02) THEN LET g_lpl_1.t_lpl02 = g_today END IF
      LET g_lpl_1.t_lpl02 = cl_cal(g_lpl_1.t_lpl02,-12,0),":",
                           MDY(MONTH(g_lpl_1.t_lpl02),DAY(g_lpl_1.t_lpl02),YEAR(g_lpl_1.t_lpl02))
   END IF
   CALL q500_q()
   CALL q500_menu()
   CLOSE WINDOW q500_w              #結束畫面
   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
        RETURNING g_time             
END MAIN

FUNCTION q500_menu()
   WHILE TRUE
     CALL q500_bp("G")
     CASE g_action_choice
       WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL q500_q()
         END IF
       WHEN "help"
          CALL cl_show_help()
        WHEN "exit"
            EXIT WHILE
        WHEN "controlg"
            CALL cl_cmdask()
#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpl),'','')
            END IF
#FUN-B90091 add END
      END CASE
   END WHILE
END FUNCTION

FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpl TO s_lpl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         
         CALL cl_about() 

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q500_q()
   LET g_cnt = 1
   DISPLAY '   ' TO FORMONLY.cn2 
   CALL q500_cs()
   
END FUNCTION

FUNCTION q500_cs()
DEFINE tok             base.StringTokenizer
DEFINE l_plant         LIKE lpl_file.lplplant
DEFINE l_count         LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE l_aza88         LIKE aza_file.aza88
DEFINE l_azw01         LIKE azw_file.azw01
DEFINE l_sql1          STRING,        #FUN-B90118 add
       l_sql2          STRING,        #FUN-B90118 add
       l_sql3          STRING         #FUN-B90118 add

   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
    CALL g_lpl.clear() 
   IF NOT cl_null(g_lpl_1.t_lpl01) THEN 
      CONSTRUCT g_wc ON lplplant,lpl02 FROM t_lplplant,t_lpl02
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         DISPLAY BY NAME g_lpl_1.t_lpl01,g_lpl_1.t_lplplant,g_lpl_1.t_lpl02

      ON ACTION controlp
        CASE
           WHEN INFIELD(t_lplplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azw13"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO t_lplplant
              NEXT FIELD t_lplplant
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

      AFTER CONSTRUCT
         IF cl_null(GET_FLDBUF(t_lplplant)) OR GET_FLDBUF(t_lplplant) = "*" THEN
            DECLARE azw01_cs CURSOR FOR SELECT azw01 FROM azw_file WHERE azwacti = 'Y'
            FOREACH azw01_cs INTO l_azw01
            LET g_org = g_org,"|",l_azw01
            END FOREACH
         ELSE
            LET g_org = GET_FLDBUF(t_lplplant)
         END IF
    END CONSTRUCT
    LET g_wc= g_wc," AND lpl01='",g_lpl_1.t_lpl01,"'"
   ELSE
     CONSTRUCT g_wc ON lpl01,lplplant,lpl02 FROM t_lpl01,t_lplplant,t_lpl02
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         DISPLAY BY NAME g_lpl_1.t_lpl01,g_lpl_1.t_lplplant,g_lpl_1.t_lpl02

      AFTER FIELD t_lpl01
         IF cl_null(GET_FLDBUF(t_lpl01)) THEN
            CALL cl_err('lpl01','sub-522',0)
            NEXT FIELD t_lpl01
         END IF

      
 
      ON ACTION controlp 
        CASE
           WHEN INFIELD(t_lpl01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpj03"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO t_lpl01
              NEXT FIELD t_lpl01
           WHEN INFIELD(t_lplplant) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azw13"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO t_lplplant
              NEXT FIELD t_lplplant
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
         
      AFTER CONSTRUCT
         IF cl_null(GET_FLDBUF(t_lplplant)) OR GET_FLDBUF(t_lplplant) = "*" THEN
            DECLARE azw01_cs1 CURSOR FOR SELECT azw01 FROM azw_file WHERE azwacti = 'Y'
            FOREACH azw01_cs1 INTO l_azw01
            LET g_org = g_org,"|",l_azw01
            END FOREACH
         ELSE
            LET g_org = GET_FLDBUF(t_lplplant)
         END IF
    END CONSTRUCT
   END IF
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    LET tok = base.StringTokenizer.createExt(g_org,"|",'',TRUE) 
    WHILE tok.hasMoreTokens() 
        LET l_plant = tok.nextToken() 
        IF cl_null(l_plant) THEN
           CONTINUE WHILE
        ELSE
           SELECT COUNT(*) INTO l_count  FROM azw_file WHERE azw01 = l_plant AND azwacti = 'Y'
           IF l_count = 0 THEN
              CONTINUE WHILE
           END IF
        END IF
       
       LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(l_plant,'aza_file') 
       PREPARE pre_aza88 FROM l_sql
       EXECUTE pre_aza88 INTO l_aza88
       IF l_aza88 = 'Y' AND g_ryz.ryz02 = '1' THEN
#FUN-B90118 mark START
#         LET g_wc = cl_replace_str(g_wc,"oga87","lpl01")
#         LET g_wc = cl_replace_str(g_wc,"ogaplant","lplplant")
##FUN-B60085 -------------------STA
##        LET g_wc = cl_replace_str(g_wc,"ogacond","lpl02")                                            
#         LET g_wc = cl_replace_str(g_wc,"oga02","lpl02")              
#         LET g_wc = cl_replace_str(g_wc,"oha87","lpl01")
#         LET g_wc = cl_replace_str(g_wc,"oha02","lpl02")
#         LET g_wc = cl_replace_str(g_wc,"ohaplant","lplplant")
##FUN-B60085 -------------------END                               
#         LET g_sql = " SELECT lpl01,lpl02,lplplant,lpl03,lpl04,lpl05,lpl06,lpl07,lpl08 ",
#                     " FROM ",cl_get_target_table(l_plant,'lpl_file'),
#                     " WHERE ",g_wc CLIPPED,
#                     " AND lplplant = '",l_plant,"'",
#                     " ORDER BY lpl02 DESC"
#FUN-B90118 mark END
#FUN-B90118 add START-----------------------------
       LET g_wc = cl_replace_str(g_wc,"oha87","lpl01")
       LET g_wc = cl_replace_str(g_wc,"oha02",'lpl02')
       LET g_wc = cl_replace_str(g_wc,"ohaplant","lplplant")

       LET l_sql1 = " SELECT lpl01, lpl02, lplplant, lpl03, lpl04, lpl05, lpl06, lpl07, lpl08",
             " FROM  ",cl_get_target_table(l_plant,'lpl_file'),
             " WHERE ",g_wc CLIPPED

       LET g_wc = cl_replace_str(g_wc,"lpl01","oga87")
       LET g_wc = cl_replace_str(g_wc,"lpl02","oga02")
       LET g_wc = cl_replace_str(g_wc,"lplplant","ogaplant")

       LET l_sql2 = " SELECT oga87, oga02, ogaplant, ogb48, ogb49, ogb04, ogb05, ogb16, ogb14t",
                    " FROM " ,cl_get_target_table(l_plant,'oga_file'),
                    "        INNER JOIN ",cl_get_target_table(l_plant,'ogb_file')," ON oga01 = ogb01",
                    " WHERE oga94 = 'N'",
                    " AND ",g_wc CLIPPED
       LET g_wc = cl_replace_str(g_wc,"oga87","oha87")
       LET g_wc = cl_replace_str(g_wc,"oga02","oha02")
       LET g_wc = cl_replace_str(g_wc,"ogaplant","ohaplant")

       LET l_sql3 = " SELECT oha87, oha02, ohaplant, ohb69, ohb70, ohb04, ohb05, (-1)*ohb16, (-1)*ohb14t",
                    " FROM oha_file"    ,
                    " INNER JOIN ohb_file",
                    " ON oha01 = ohb01",
                    " WHERE oha94 = 'N'",
                    " AND ",g_wc CLIPPED
       LET g_sql = " SELECT lpl01, lpl02, lplplant, lpl03, lpl04, lpl05, lpl06, SUM(lpl07), SUM(lpl08)",
                   " FROM ( ",l_sql1," UNION ALL ",l_sql2," UNION ALL ",l_sql3," )",
                   " GROUP BY lpl01, lpl02, lpl03, lpl04, lpl05, lpl06, lplplant",
                   "  ORDER BY lpl02 DESC"
#FUN-B90118 add END----------------------------
       ELSE
          LET g_wc = cl_replace_str(g_wc,"lpl01","oga87")
          LET g_wc = cl_replace_str(g_wc,"lplplant","ogaplant")
 #FUN-B60085 -------------------STA
 #        LET g_wc = cl_replace_str(g_wc,"lpl02","ogacond")                                              
          LET g_wc = cl_replace_str(g_wc,"lpl02","oga02")              
          LET g_wc = cl_replace_str(g_wc,"oha87","oga87")
          LET g_wc = cl_replace_str(g_wc,"oha02","oga02")
          LET g_wc = cl_replace_str(g_wc,"ohaplant","ogaplant")                                    
 #FUN-B60085 -------------------END
 #        LET g_sql = " SELECT oga87,ogacond,ogaplant,ogb48,ogb49,ogb04,ogb05,SUM(ogb16),SUM(ogb14t) ",        #FUN-B60085 mark
          LET g_sql = " SELECT oga87, oga02,ogaplant,ogb48, ogb49, ogb04, ogb05, SUM(ogb16), SUM(ogb14t) ",  #FUN-B60085
                      " FROM( SELECT oga87,oga02,ogaplant,ogb48,ogb49,ogb04,ogb05,ogb16,ogb14t ",              #FUN-B60085
                      " FROM ",cl_get_target_table(l_plant,'oga_file'),
                      " ,",cl_get_target_table(l_plant,'ogb_file'),
                      " WHERE oga01 = ogb01 AND ",g_wc CLIPPED,
                      " AND ogaconf = 'Y' ",
                      " AND ogaplant = '",l_plant,"'"
 #                    " GROUP BY oga87,ogacond,ogaplant,ogb48,ogb49,ogb04,ogb05 ",                          #FUN-B60085  mark
 #                    " ORDER BY ogacond DESC"                                                              #FUN-B60085  mark
 #FUN-B60085 ----------------STA
          LET g_wc = cl_replace_str(g_wc,"oga87","oha87")
          LET g_wc = cl_replace_str(g_wc,"oga02","oha02")
          LET g_wc = cl_replace_str(g_wc,"ogaplant","ohaplant")     
          LET g_sql =g_sql,"UNION ALL SELECT oha87 oga87,oha02 oga02,ohaplant ogaplant,ohb69 ogb48,",
                      "ohb70 ogb49,ohb04 ogb04,ohb05 ogb05,(-1)*ohb16 ogb16,(-1)*ohb14t ogb14t ",                  
                      " FROM ",cl_get_target_table(l_plant,'oha_file'),
                      " ,",cl_get_target_table(l_plant,'ohb_file'),      
                      " WHERE oha01 = ohb01 AND ",g_wc CLIPPED,
                      " AND ohaconf = 'Y' ",
                      " AND ohaplant = '",l_plant,"')",
                      " GROUP BY oga87,oga02,ogaplant,ogb48,ogb49,ogb04,ogb05 ", 
                      " ORDER BY oga02 DESC" 
 #FUN-B60085 ----------------END
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
       PREPARE q500_prepare FROM g_sql
       DECLARE q500_cs CURSOR FOR q500_prepare 
       CALL q500_b_fill() 
    END WHILE 
    LET g_org = ''
    DISPLAY g_rec_b TO FORMONLY.cn2    
END FUNCTION

FUNCTION q500_b_fill()

    FOREACH q500_cs INTO g_lpl[g_cnt].lpl01,g_lpl[g_cnt].lpl02,g_lpl[g_cnt].lplplant,
                         g_lpl[g_cnt].lpl03,g_lpl[g_cnt].lpl04,g_lpl[g_cnt].lpl05,
                         g_lpl[g_cnt].lpl06,g_lpl[g_cnt].lpl07,g_lpl[g_cnt].lpl08
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF                 
        IF NOT cl_null(g_lpl[g_cnt].lplplant) THEN
           SELECT rtz13 INTO g_lpl[g_cnt].rtz13 FROM rtz_file
            WHERE rtz01 =  g_lpl[g_cnt].lplplant 
        END IF
        IF NOT cl_null(g_lpl[g_cnt].lpl04)  THEN
           SELECT lne05 INTO  g_lpl[g_cnt].lne05 FROM lne_file
            WHERE lne01 = g_lpl[g_cnt].lpl04  
        END IF
        IF NOT cl_null(g_lpl[g_cnt].lpl05) THEN
           SELECT ima02 INTO g_lpl[g_cnt].ima02 FROM ima_file
            WHERE ima01 = g_lpl[g_cnt].lpl05
        END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lpl.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
 
END FUNCTION

#FUN-B30202
