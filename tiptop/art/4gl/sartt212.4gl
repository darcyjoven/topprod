# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sartt212.4gl
# Descriptions...: 供artt212,artt215兩支程序調用
# Date & Author..: No:FUN-960130 09/07/07 By  Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0068 09/11/10 BY lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30050 10/03/15 By Cockroach ADD oriu/orig
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:FUN-A50071 10/05/19 By lixia 程序增加POS單號字段 并增加相应管控
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No:FUN-A70130 10/08/16 By huangtao 修改單據性質,q_smy改为q_oay
# Modify.........: No:FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No:FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管 
# Modify.........: No:FUN-AB0078 11/11/17 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:TQC-AB0290 10/11/30 By huangtao 
# Modify.........: No:TQC-B10011 11/01/05 By shenyang 修改5.25PT bug
# Modify.........: No:TQC-B10048 11/01/10 By shiwuying 取帳面數量時檢查是否有庫存備份
# Modify.........: No:TQC-B20082 11/02/21 By huangtao rut07掛賬數量已改為No Use
# Modify.........: No.TQC-B30102 11/03/10 By lixia tlf修改
# Modify.........: No.FUN-B30207 11/04/07 By baogc 列印功能修改
# Modify.........: No.FUN-B40080 11/04/25 By rainy 串artr210時，bgjob不可傳'Y'
# Modify.........: No:FUN-B40062 11/04/26 By shiwuying 料号控管不可输入商户料号和联营料号
# Modify.........: No:FUN-B40039 11/04/26 By shiwuying 增加料号异动查询功能
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60118 11/06/22 By yangxf 過單
# Modify.........: No.TQC-B80044 11/08/03 By lilingyu rollback work和cl_err3的位置顛倒,導致報錯訊息不准確
# Modyfy.........: No.FUN-B90103 11/11/03 By xjll 增加服飾二維
# Modify.........: No.FUN-910088 12/01/15 By chenjing 增加數量欄位小數取位   
# Modify.........: No.FUN-C20006 12/02/03 By xjll 非子母料件bug 修改 
# Modify.........: No:TQC-C20348 12/02/22 By lixiang  服飾流通業商品策略，採購策略的修改
# Modify.........: No:TQC-C20512 12/02/29 By xjll  料件异動查詢應查詢母料件對應的子料件的庫存异動
# Modify.........: No:MOD-C30217 12/03/12 By xjll  服飾bug 修改
# Modify.........: No.MOD-C30051 12/03/20 By SunLM 盤差調整單，調整庫存時沒有判斷關帳日期和現行年月
# Modify.........: No.TQC-C30348 12/03/20 By SunLM 修正MOD-C30051
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60100 12/06/27 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C90123 12/09/29 By baogc 過濾供應廠商時，用g_plant抓取採購策略
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:MOD-CB0265 13/01/04 By Vampire 調整列印盤點清冊時,組g_wc改用其他變數
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt212.global"
GLOBALS "../../axm/4gl/s_slk.global"   #FUN-B90103--add
#FUN-B90103--add---begin-----
DEFINE g_ruxslk  DYNAMIC ARRAY OF RECORD  
           ruxslk02      LIKE ruxslk_file.ruxslk02,
           ruxslk03      LIKE ruxslk_file.ruxslk03,
           ruxslk03_desc LIKE ima_file.ima02,
           ruxslk04      LIKE ruxslk_file.ruxslk04,
           ruxslk04_desc LIKE gfe_file.gfe02,
           ruxslk06      LIKE ruxslk_file.ruxslk06,
           ruxslk09      LIKE ruxslk_file.ruxslk09
             END RECORD,
        g_ruxslk_t  RECORD
           ruxslk02      LIKE ruxslk_file.ruxslk02,
           ruxslk03      LIKE ruxslk_file.ruxslk03,
           ruxslk03_desc LIKE ima_file.ima02,
           ruxslk04      LIKE ruxslk_file.ruxslk04,
           ruxslk04_desc LIKE gfe_file.gfe02,
           ruxslk06      LIKE ruxslk_file.ruxslk06,
           ruxslk09      LIKE ruxslk_file.ruxslk09  
             END RECORD,
       g_ruxslk_o  RECORD
           ruxslk02      LIKE ruxslk_file.ruxslk02,
           ruxslk03      LIKE ruxslk_file.ruxslk03,
           ruxslk03_desc LIKE ima_file.ima02,
           ruxslk04      LIKE ruxslk_file.ruxslk04,
           ruxslk04_desc LIKE gfe_file.gfe02,
           ruxslk06      LIKE ruxslk_file.ruxslk06,
           ruxslk09      LIKE ruxslk_file.ruxslk09
             END RECORD
DEFINE g_rec_b2   LIKE type_file.num5,
       l_ac2      LIKE type_file.num5,
       l_ac3      LIKE  type_file.num5,
       g_rec_b3   LIKE  type_file.num5,
       p_cmd3     LIKE  type_file.chr1,
       li_a       LIKE  type_file.chr1,
       g_wc3      STRING
#FUN-B90103-----end------------
DEFINE g_b_flag  LIKE type_file.chr1   #FUN-D30033 add

FUNCTION t212(p_argv1)
DEFINE l_time    LIKE type_file.chr8,
       p_argv1   LIKE ruw_file.ruw00
       
   WHENEVER ERROR CONTINUE
   
   LET g_argv1=p_argv1
   
   LET g_forupd_sql = "SELECT * FROM ruw_file WHERE ruw00 = ? AND ruw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t212_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
#FUN-B90103---------add--begin---
IF s_industry("slk")  AND g_argv1= '1' THEN
OPEN WINDOW t212_w AT p_row,p_col WITH FORM "art/42f/artt212_slk"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
ELSE
##FUN-B90103-----end-------------
    
   OPEN WINDOW t212_w AT p_row,p_col WITH FORM "art/42f/artt212"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
END IF
#FUN-B90103--#add 
   CALL cl_ui_init()
   IF g_argv1 = '2' THEN
      CALL cl_set_act_visible("create_check,get_store",FALSE)
      CALL cl_set_act_visible("update_store",TRUE)
   ELSE
      CALL cl_set_act_visible("create_check,get_store",TRUE)
      CALL cl_set_act_visible("update_store",FALSE)
   END IF
   
   IF g_argv1 = '2' THEN
      CALL cl_set_comp_visible("ruw08,ruw09",TRUE)
      CALL cl_set_comp_visible("ruw10",FALSE)               #No.FUN-A50071
   ELSE
      CALL cl_set_comp_visible("ruw08,ruw09",FALSE)
      CALL cl_set_comp_visible("ruw10",g_aza.aza88 = 'Y')   #No.FUN-A50071 
   END IF
   LET g_ruw.ruw00 = g_argv1
   DISPLAY BY NAME g_ruw.ruw00

   CALL cl_set_comp_visible("ruwpos",FALSE) # No:FUN-B50042
#FUN-B90103---------add-----------
IF s_industry("slk") AND g_argv1 = '1' THEN
   LET li_a=TRUE
   CALL cl_set_act_visible("controlb",FALSE) 
END IF   
#FUN-B90103--------end-----------
   CALL t212_menu()
   CLOSE WINDOW t212_w
END FUNCTION
 
FUNCTION t212_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   DISPLAY g_argv1 TO ruw00
   CALL g_rux.clear()
#FUN-B90103---add--begin--
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL g_ruxslk.clear()
   CALL g_imx.clear()
END IF
#FUN-B90103---end---------
  
   IF NOT cl_null(g_argv3) THEN
      LET g_wc = " ruw01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ruw.* TO NULL
#FUN-B90103---------------------begin----------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON ruw01,ruw02,ruw03,ruw04,ruw05,    #FUN-A50071 add ruw10
             #                  ruw06,ruwconf,ruwcond,ruwconu,ruwmksg,   #FUN-870100                  #TQC-AB0290   mark
                                ruw06,ruwconf,ruwcond,ruwconu,                                        #TQC-AB0290
             #                  ruw900,ruwplant,ruw07,ruw08,ruw09,ruw10,ruwpos,ruwuser,  #FUN-870100  #TQC-AB0290   mark
                                ruwplant,ruw07,ruw08,ruw09,ruw10,ruwpos,ruwuser,                      #TQC-AB0290     
                                ruwgrup,ruwmodu,ruwdate,ruwacti,ruwcrat
                               ,ruworiu,ruworig                          #TQC-A30050  ADD
                                
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         END CONSTRUCT

      CONSTRUCT g_wc3 ON ruxslk02,ruxslk03,
                         ruxslk04,ruxslk06,ruxslk09
                    FROM s_ruxslk[1].ruxslk02,s_ruxslk[1].ruxslk03,
                         s_ruxslk[1].ruxslk04,s_ruxslk[1].ruxslk06,
                         s_ruxslk[1].ruxslk09
          BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT

      CONSTRUCT g_wc2 ON rux02,rux03,rux04,rux05,rux06,rux07,rux08,rux09
              FROM s_rux[1].rux02,s_rux[1].rux03,s_rux[1].rux04,
                   s_rux[1].rux05,s_rux[1].rux06,s_rux[1].rux07,
                   s_rux[1].rux08,s_rux[1].rux09
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        END CONSTRUCT
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw01"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw01
                  NEXT FIELD ruw01
      
               WHEN INFIELD(ruw02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw02"
                  LET g_qryparam.arg1 = g_argv1 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw02
                  NEXT FIELD ruw02
                  
               WHEN INFIELD(ruw03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw03"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw03
                  NEXT FIELD ruw03
       
               WHEN INFIELD(ruw05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw05_1"
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.where=" ruwplant= '",g_plant,"' "  #No.FUN-AA0049
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw05
                  NEXT FIELD ruw05
                  
               WHEN INFIELD(ruw06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw06"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw06
                  NEXT FIELD ruw06
                  
               WHEN INFIELD(ruwconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                       
                  LET g_qryparam.form ="q_ruwconu" 
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO ruwconu                                                                              
                  NEXT FIELD ruwconu
               WHEN INFIELD(rux03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.form ="q_rux03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rux03
                  NEXT FIELD rux03
               WHEN INFIELD(rux04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.form ="q_rux04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rux04
                  NEXT FIELD rux04

                WHEN INFIELD(ruxslk03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.form ="q_ruxslk03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruxslk03
                  NEXT FIELD ruxslk03
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION accept
            EXIT DIALOG

         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG
      END DIALOG
##FUN-B90103-------------end------------------- 
#FUN-B90103------------mark---begin------
#     END CONSTRUCT
#     
#     IF INT_FLAG THEN
#        RETURN
#     END IF
#  END IF
#
#  #Begin:FUN-980030
#  #   IF g_priv2='4' THEN
#  #      LET g_wc = g_wc clipped," AND ruwuser = '",g_user,"'"
#  #   END IF
#
#  #   IF g_priv3='4' THEN
#  #      LET g_wc = g_wc clipped," AND ruwgrup MATCHES '",g_grup CLIPPED,"*'"
#  #   END IF
#
#  #   IF g_priv3 MATCHES "[5678]" THEN
#  #      LET g_wc = g_wc clipped," AND ruwgrup IN ",cl_chk_tgrup_list()
#  #   END IF
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruwuser', 'ruwgrup')
#  #End:FUN-980030
#
#  IF NOT cl_null(g_argv4) THEN
#     LET g_wc2 = ' 1=1'     
#  ELSE
#     CONSTRUCT g_wc2 ON rux02,rux03,rux04,rux05,rux06,rux07,rux08,rux09
#             FROM s_rux[1].rux02,s_rux[1].rux03,s_rux[1].rux04,
#                  s_rux[1].rux05,s_rux[1].rux06,s_rux[1].rux07,
#                  s_rux[1].rux08,s_rux[1].rux09
#
#        BEFORE CONSTRUCT
#           CALL cl_qbe_display_condition(lc_qbe_sn)
#  
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(rux03)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = 'c'
#                 LET g_qryparam.arg1 = g_argv1
#                 LET g_qryparam.form ="q_rux03_1"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO rux03
#                 NEXT FIELD rux03
#              WHEN INFIELD(rux04)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = 'c'
#                 LET g_qryparam.arg1 = g_argv1
#                 LET g_qryparam.form ="q_rux04"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO rux04
#                 NEXT FIELD rux04
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#   
#        ON ACTION about
#           CALL cl_about()
#   
#        ON ACTION HELP
#           CALL cl_show_help()
#   
#        ON ACTION controlg
#           CALL cl_cmdask()
#   
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#
#     END CONSTRUCT
#FUN-B90103--------------mark-----end---------   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
#FUN-B90103-------add--begin--
IF cl_null(g_wc2) THEN LET g_wc2=" 1=1"  END IF
IF s_industry("slk") AND g_argv1 = '1' THEN
IF cl_null(g_wc3) THEN LET g_wc3=" 1=1"  END IF
END IF
#FUN-B90103--------end-------- 
IF NOT s_industry("slk") OR g_argv1 = '2' THEN
#FUN-B90103--add--
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT ruw00,ruw01 FROM ruw_file ",
                  " WHERE ruw00 = '",g_argv1,"' AND ", 
                  g_wc CLIPPED,
                  " ORDER BY ruw00,ruw01"
   ELSE
      LET g_sql = "SELECT UNIQUE ruw00,ruw01",
                  "  FROM ruw_file, rux_file ",
                  " WHERE ruw01 = rux01 AND ruw00 = rux00 ",
                  "   AND ruw00 ='",g_argv1,"' AND ", 
                  g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY ruw00,ruw01"
   END IF
END IF
#FUN-B90103--add
#FUN-B90103-------add---begin---
IF s_industry("slk")  AND g_argv1 = '1' THEN
   IF g_wc3=" 1=1"  AND g_wc2=" 1=1" THEN
      LET g_sql = "SELECT ruw00,ruw01 FROM ruw_file ",
                  " WHERE ruw00 = '",g_argv1,"' AND ",
                    g_wc CLIPPED,
                  " ORDER BY ruw00,ruw01"
   ELSE
      LET g_sql = "SELECT UNIQUE ruw00,ruw01",
                  "  FROM ruw_file, rux_file,ruxslk_file ",
                  " WHERE ruw01 = rux01 AND ruw00 = rux00 ",
                  " AND ruw01=ruxslk01 AND ruw00 = ruxslk00 ",
                  " AND ruw00 ='",g_argv1,"' AND ",
                  g_wc CLIPPED, " AND ",g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                  " ORDER BY ruw00,ruw01"
   END IF 
END IF
#FUN-B90103-------end----------- 
   PREPARE t212_prepare FROM g_sql
   DECLARE t212_cs
       SCROLL CURSOR WITH HOLD FOR t212_prepare
IF NOT s_industry("slk") OR g_argv1 = '2' THEN
#FUN-B90103---add--
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM ruw_file WHERE ruw00 ='",g_argv1,
                "' AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT ruw01) FROM ruw_file,rux_file WHERE ",
                "rux01=ruw01 AND ruw00 = rux00 AND ",
                " ruw00 = '",g_argv1,"' AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
END IF
#FUN-B90103---add--
#FUN-B90103-------begin---------
IF s_industry("slk") AND g_argv1 = '1' THEN
  
   IF g_wc3 = " 1=1"  AND g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(*) FROM ruw_file WHERE ruw00 ='",g_argv1,
                "' AND ",g_wc CLIPPED
   ELSE
         LET g_sql="SELECT COUNT(DISTINCT ruw01) FROM ruw_file,rux_file,ruxslk_file WHERE ",
                "rux01=ruw01 AND ruw00 = rux00 AND ruw01=ruxslk01 AND ruw00=ruxslk00 AND ",
                " ruw00 = '",g_argv1,"' AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
   END IF
END IF
#FUN-B90103-------end-----------
   PREPARE t212_precount FROM g_sql
   DECLARE t212_count CURSOR FOR t212_precount
 
END FUNCTION
 
FUNCTION t212_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
   DEFINE l_wc         STRING #MOD-CB0265 add
 
   WHILE TRUE
      CALL t212_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t212_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t212_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t212_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t212_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t212_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t212_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t212_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
###-FUN-B30207- MARK - BEGIN --------------------------------
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL t212_out()
#           END IF
###-FUN-B30207- MARK -  END  --------------------------------

###-FUN-B30207- ADD - BEGIN ---------------------------------
         WHEN "output"
            IF cl_chk_act_auth() AND NOT cl_null(g_ruw.ruw01) THEN
               MENU "" ATTRIBUTE(STYLE="popup")
                  ON ACTION t212_p_query
                     CALL t212_out()
                  ON ACTION t212_cr
                    #MOD-CB0265 mark start -----
                    #IF g_wc IS NULL AND g_ruw.ruw01 IS NOT NULL THEN
                    #   LET g_wc = "ruw01 = '",g_ruw.ruw01,"'"
                    #END IF
                    #IF g_wc IS NULL THEN
                    #MOD-CB0265 mark end   -----
                    #MOD-CB0265 add start -----
                     LET l_wc = g_wc
                     IF l_wc IS NULL AND g_ruw.ruw01 IS NOT NULL THEN
                        LET l_wc = "ruw01 = '",g_ruw.ruw01,"'"
                     END IF
                     IF l_wc IS NULL THEN
                    #MOD-CB0265 add end   -----
                        CALL cl_err('','9057',0)
                        RETURN
                     END IF
                     IF g_wc2 IS NULL THEN
                        LET g_wc2 = ' 1=1'
                     END IF
                    #MOD-CB0265 mark start -----
                    #LET g_wc = g_wc CLIPPED," AND ",g_wc2
                    #LET g_wc= cl_replace_str(g_wc,"'","\"")
                    #MOD-CB0265 mark end   -----
                    #MOD-CB0265 add start -----
                     LET l_wc = l_wc CLIPPED," AND ",g_wc2
                     LET l_wc = cl_replace_str(l_wc,"'","\"")
                    #MOD-CB0265 add end   -----
                    #LET g_msg = "artr210 ",  #FUN-C30085 mark
                     LET g_msg = "artg210 ",  #FUN-C30085 add
                                 " '",g_today CLIPPED,"' ''",
                                #" '",g_lang CLIPPED,"' 'Y' '' '1'",   #FUN-B40080
                                 " '",g_lang CLIPPED,"' 'N' '' '1'",   #FUN-B40080
                                 " '",l_wc,"'"  #MOD-CB0265 add
                                #" '",g_wc,"'"  #MOD-CB0265 mark
                     CALL cl_cmdrun_wait(g_msg)
               END MENU
            END IF
###-FUN-B30207- ADD -  END  ---------------------------------
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t212_yes()
            END IF
 
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t212_no()
            END IF
            
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t212_void(1)
            END IF
         #FUN-D20039 ------------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t212_void(2)
            END IF
         #FUN-D20039 ------------end 
        WHEN "create_check"
	   IF cl_chk_act_auth() THEN
              CALL t212_create()
           END IF
        WHEN "get_store"
	   IF cl_chk_act_auth() THEN
              CALL t212_get_store()
           END IF
         WHEN "update_store"
            IF cl_chk_act_auth() THEN
               CALL t212_update_store()
            END IF
        #FUN-B40039 Begin---
         WHEN "sel_item"
            IF cl_chk_act_auth() THEN
#TQC-C20512--mark-------------------------
#FUN-B90103------------begin--------
#IF s_industry("slk") AND g_argv1 = '1' THEN
#              IF l_ac2 > 0 THEN
#                 LET g_msg = " aimq231 '",g_ruxslk[l_ac2].ruxslk03,"' '",g_ruw.ruw05,"' "
#                 CALL cl_cmdrun_wait(g_msg)
#              END IF
#ELSE
#FUN-B90103------------end----------

               IF l_ac > 0 THEN
                  LET g_msg = " aimq231 '",g_rux[l_ac].rux03,"' '",g_ruw.ruw05,"' "
                  CALL cl_cmdrun_wait(g_msg)
               END IF
#END IF   
#FUN-B90103---add
#TQC-C20512--mark---end---------------------
            END IF
        #FUN-B40039 End-----
               
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rux),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ruw.ruw01 IS NOT NULL THEN
                 LET g_doc.column1 = "ruw01"
                 LET g_doc.value1 = g_ruw.ruw01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
#調整庫存
FUNCTION t212_update_store()
DEFINE l_sql        STRING
DEFINE l_img01      LIKE img_file.img01
DEFINE l_img02      LIKE img_file.img02
DEFINE l_img03      LIKE img_file.img03
DEFINE l_img04      LIKE img_file.img04
DEFINE l_rty06      LIKE rty_file.rty06
DEFINE l_rux02      LIKE rux_file.rux02
DEFINE l_rux03      LIKE rux_file.rux03
DEFINE l_rux04      LIKE rux_file.rux04
DEFINE l_rux06      LIKE rux_file.rux06
DEFINE l_rux08      LIKE rux_file.rux08
DEFINE l_img09      LIKE img_file.img09
DEFINE l_img10      LIKE img_file.img10
DEFINE l_img26      LIKE img_file.img26
DEFINE l_yy,l_mm    LIKE type_file.num5 #MOD-C30051
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruW00=g_ruw.ruw00 
 
   IF g_ruw.ruwconf <> 'Y' THEN CALL cl_err('','art-417',0) RETURN END IF
   IF g_ruw.ruw08 = 'Y' THEN CALL cl_err('','art-429',0) RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF

#MOD-C30051 add begin
   IF g_prog = 'artt215' THEN 
      CALL cl_set_comp_required("ruw09",TRUE)
      CALL cl_set_comp_entry("ruw09",TRUE)
      INPUT g_ruw.ruw09 FROM ruw09

         AFTER FIELD ruw09
           IF NOT cl_null(g_ruw.ruw09) THEN           
              IF g_sma.sma53 IS NOT NULL AND g_ruw.ruw09 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0)
                 NEXT FIELD ruw09
              END IF
              CALL s_yp(g_ruw.ruw09) RETURNING l_yy,l_mm #No.MOD-920007 mod by liuxqa
       
              IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                     CALL cl_err('','mfg6090',0)
                     NEXT FIELD ruw09
              END IF
           END IF
       
         AFTER INPUT 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_ruw.ruw09=g_ruw_t.ruw09
                   DISPLAY BY NAME g_ruw.ruw09
                   LET g_success = 'N'
                   RETURN
                END IF
                IF NOT cl_null(g_ruw.ruw09) THEN               
                   IF g_sma.sma53 IS NOT NULL AND g_ruw.ruw09 <= g_sma.sma53 THEN
                      CALL cl_err('','mfg9999',0) 
                      NEXT FIELD ruw09
                   END IF
                   CALL s_yp(g_ruw.ruw09) RETURNING l_yy,l_mm
                   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                      CALL cl_err(l_yy,'mfg6090',0) 
                      NEXT FIELD ruw09
                   END IF
                ELSE
                   CONTINUE INPUT
                END IF

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
 
   IF g_sma.sma53 IS NOT NULL AND g_ruw.ruw09 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'
      RETURN   
   END IF
 
   CALL s_yp(g_ruw.ruw09) RETURNING l_yy,l_mm
 
   IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0)
      LET g_success = 'N'
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL cl_err(l_mm,'mfg6091',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF


      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
      UPDATE ruw_file SET ruw09 =  g_ruw.ruw09 WHERE ruw01 = g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
   END IF 

#MOD-C30051 add end
 
   LET l_sql = "SELECT rux02,rux03,rux04,rux06,rux08 FROM rux_file ",
               " WHERE rux00 = '2' AND rux01 = '",g_ruw.ruw01,"'",
               "   AND rux08 <> 0 "
   PREPARE rux_upd FROM l_sql
   DECLARE ruxupd_cs CURSOR FOR rux_upd
 
   LET g_cnt = 1
   FOREACH ruxupd_cs INTO l_rux02,l_rux03,l_rux04,l_rux06,l_rux08
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
      IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
      IF l_rux08 IS NULL THEN LET l_rux08 = 0 END IF
 
      SELECT rty06 INTO l_rty06 FROM rty_file WHERE rty01 = g_ruw.ruwplant 
          AND rty02 = l_rux03
      #檢查該商品在倉庫中是否已經存在
      SELECT img01,img02,img03,img04 
	INTO l_img01,l_img02,l_img03,l_img04 FROM img_file 
         WHERE img01 = l_rux03 
           AND img02 = g_ruw.ruw05
           AND img03 = ' '
           AND img04 = ' '
#TQC-B10011--ADD--begin
      IF STATUS=100 THEN
         CALL s_add_img(l_rux03,g_ruw.ruw05,l_img03,l_img04,g_ruw.ruw01,l_rux02,g_ruw.ruw04)
#TQC-C30348 add begin
      SELECT img01,img02,img03,img04 INTO l_img01,l_img02,l_img03,l_img04 FROM img_file 
       WHERE img01 = l_rux03 
         AND img02 = g_ruw.ruw05
         AND img03 = ' '
         AND img04 = ' '
#TQC-C30348 add end
##MOD-C30051 mark begin
#      ELSE
#TQC-B10011--ADD--END
#      CALL s_upimg(l_img01,l_img02,l_img03,l_img04,'2',l_rux08,g_today,l_rux03,g_ruw.ruw05,'','',g_ruw.ruw01,
#                   l_rux02,l_rux04,l_rux08,l_rux04,1,1,1,'','','','','','')
##MOD-C30051 mark end
      END IF                                                                #TQC-B10011
      CALL s_upimg(l_img01,l_img02,l_img03,l_img04,'2',l_rux08,g_today,l_rux03,g_ruw.ruw05,'','',g_ruw.ruw01,
                   l_rux02,l_rux04,l_rux08,l_rux04,1,1,1,'','','','','','')  ##MOD-C30051 add
      IF g_success = 'N' THEN EXIT FOREACH END IF 
      SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
         FROM img_file WHERE img01 = l_rux03 AND img02 = g_ruw.ruw05
          AND img03 = ' ' AND img04 = ' '
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE g_tlf.* TO NULL
      IF l_rux08 < 0 THEN    
        LET l_rux08      =l_rux08 * -1
        #----來源----
        LET g_tlf.tlf02=50         	             #來源為倉庫(盤虧)
        LET g_tlf.tlf020=g_plant                 #工廠別
        LET g_tlf.tlf021=g_ruw.ruw05  	         #倉庫別
        LET g_tlf.tlf022=" "     	         #儲位別
        LET g_tlf.tlf023=" "     	         #入庫批號
        LET g_tlf.tlf024= l_img10                #(+/-)異動後庫存數量
        LET g_tlf.tlf025= l_img09                #庫存單位(ima or img) #TQC-660091     
    	LET g_tlf.tlf026=g_ruw.ruw01             #參考單据(盤點單)
    	LET g_tlf.tlf027= l_rux02
        #----目的----
        LET g_tlf.tlf03=0          	 	         #目的為盤點
        LET g_tlf.tlf030=g_plant       	         #工廠別
        LET g_tlf.tlf031=''            	         #倉庫別
        LET g_tlf.tlf032=''         	         #儲位別
        LET g_tlf.tlf033=''         	         #批號
        LET g_tlf.tlf034=''                      #異動後庫存數量
    	LET g_tlf.tlf035=''                   
    	LET g_tlf.tlf036='Physical'     
    	LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=''                       #貸方會計科目(盤虧)
        LET g_tlf.tlf16= l_img26                 #料件會計科目(存貨)
      ELSE 
        #----來源----
        LET g_tlf.tlf02=0          	             #來源為盤點(盤盈)
        LET g_tlf.tlf020=g_plant       	         #倉庫別
        LET g_tlf.tlf021=''            	         #倉庫別
        LET g_tlf.tlf022=''         	         #儲位別
        LET g_tlf.tlf023=''         	         #批號
        LET g_tlf.tlf024=''                      #異動後庫存數量
    	LET g_tlf.tlf025=''                   
    	LET g_tlf.tlf026=g_ruw.ruw01     
    	LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=50         	 	         #目的為倉庫
        LET g_tlf.tlf030=g_plant      	         #工廠別
        LET g_tlf.tlf031=g_ruw.ruw05  	         #倉庫別
        LET g_tlf.tlf032=" "     	         #儲位別
        LET g_tlf.tlf033=" "     	         #入庫批號
        LET g_tlf.tlf034=l_img10                 #(+/-)異動後庫存數量
        LET g_tlf.tlf035=l_img09                 #庫存單位(ima or img)
    	LET g_tlf.tlf036=g_ruw.ruw01             #參考單据
    	LET g_tlf.tlf037=l_rux02
 
        LET g_tlf.tlf15= l_img26             #料件會計科目(存貨)
        LET g_tlf.tlf16=' '                  #貸方會計科目(盤盈)
      END IF
      LET g_tlf.tlf01=l_rux03     	     #異動料件編號
#--->異動數量
      LET g_tlf.tlf04=' '                      #工作站
      LET g_tlf.tlf05=g_prog                   #作業序號
      LET g_tlf.tlf06=g_ruw.ruwcond  #g_ruw.ruw04              #盤點日期   #Modi by zm 090617
      LET g_tlf.tlf07=g_today                  #異動資料產生日期  
      LET g_tlf.tlf08=TIME                     #異動資料產生時:分:秒
      LET g_tlf.tlf09=g_user                   #產生人
      LET g_tlf.tlf10=l_rux08                  #異動數量
      LET g_tlf.tlf11=l_rux04                  #庫存單位
      LET g_tlf.tlf12=1                        #單位轉換率  
      #LET g_tlf.tlf13='差整'                  #異動命令代號
      LET g_tlf.tlf13='artt215'                #TQC-B30102
      LET g_tlf.tlf14=''                       #異動原因
      CALL s_imaQOH(l_rux03)
         RETURNING g_tlf.tlf18               #異動後總庫存量
      LET g_tlf.tlf19= ' '                     #異動廠商/客戶編號
      LET g_tlf.tlf20= ' '                     #project no.      
      LET g_tlf.tlfplant=g_ruw.ruwplant 
      LET g_tlf.tlflegal=g_ruw.ruwlegal 
      #LET g_tlf.tlf01 = l_rux03
      #LET g_tlf.tlf020 = g_ruw.ruwplant
      #LET g_tlf.tlf02 = '07'
      #LET g_tlf.tlf021 = g_ruw.ruw05
      #LET g_tlf.tlf022 = " "           #bnl 090205
      #LET g_tlf.tlf023 = " "           #bnl 090205
      #LET g_tlf.tlf024 = l_img10
 
      CALL s_tlf(1,0)
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt != 1 AND g_success = 'Y' THEN
      LET g_ruw.ruw08 = 'Y'
      LET g_ruw.ruw09 = g_today
      UPDATE ruw_file SET ruw08 = 'Y',ruw09 = g_today 
         WHERE ruw00 = '2' AND ruw01 = g_ruw.ruw01 
      IF SQLCA.sqlcode THEN 
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_ruw.ruw08 = 'N'
         LET g_ruw.ruw09 = ''
         ROLLBACK WORK
      ELSE
         COMMIT WORK
         DISPLAY BY NAME g_ruw.ruw08,g_ruw.ruw09
         CALL cl_err('','art-498',0)
      END IF
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#產生盤差單
FUNCTION t212_create()
DEFINE l_rux02     LIKE rux_file.rux02
DEFINE l_newno     LIKE ruw_file.ruw01
DEFINE li_result   LIKE type_file.num5
DEFINE l_rux03     LIKE rux_file.rux03
#FUN-B90103------------add--
DEFINE l_ruxslk02  LIKE ruxslk_file.ruxslk02
DEFINE l_ruxslk03  LIKE ruxslk_file.ruxslk03
#FUN-B90103-----------end--
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL   
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)      
      RETURN
   END IF
   
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruw03 IS NOT NULL THEN
      CALL cl_err('','art-407',1)
      RETURN
   END IF
 
   IF g_ruw.ruwconf <> 'Y' THEN
      CALL cl_err('','art-394',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('art-403') THEN RETURN END IF
   MESSAGE ""
   LET g_ruw01_t = g_ruw.ruw01
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL t212_show()
   #獲取盤差單的默認單別
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_newno FROM rye_file 
   #   WHERE rye01 = 'art' AND rye02 = 'J5' AND ryeacti = 'Y'      #FUN-A70130
   #IF SQLCA.sqlcode = 100 THEN
   #   CALL cl_err(l_newno,'art-315',1)
   #   CLOSE t212_cl
   #   ROLLBACK WORK
   #   RETURN
   #END IF
   #FUN-C90050 mark end-----

   #FUN-C90050 add begin---
   CALL s_get_defslip('art','J5',g_plant,'N') RETURNING l_newno    
   IF cl_null(l_newno) THEN
      CALL cl_err(l_newno,'art-315',1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   #FUN-C90050 add end----- 

#  CALL s_auto_assign_no("art",l_newno,g_today,"","ruw_file","ruw01","","","")  #FUN-A70130 mark                                            
   CALL s_auto_assign_no("art",l_newno,g_today,"J5","ruw_file","ruw01","","","")  #FUN-A70130 mod                                           
      RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   #生成盤差單
   DROP TABLE y
   SELECT * FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
       INTO TEMP y
   
   UPDATE y
       SET ruw00='2',
           ruw01=l_newno,
           ruw03 = g_ruw.ruw01,
           ruw06 = g_user,
           ruwconf = 'N',
           ruwcond = NULL,
           ruwconu = NULL,
           ruwuser=g_user,
           ruwgrup=g_grup,
           ruwmodu=NULL,
           ruwdate=NULL,
           ruwacti='Y',
           ruwcrat=g_today,
           ruworiu=g_user,      #TQC-A30050 ADD
           ruworig=g_grup,      #TQC-A30050 ADD
           ruwmksg = 'N',
           ruw900 = '0',
           ruw08 = 'N',
           ruwplant = g_plant,
           ruwlegal = g_legal,
           #ruwpos='N'  #FUN-870100
           ruwpos='1'  #FUN-B50042
   INSERT INTO ruw_file SELECT * FROM y
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   DROP TABLE x 
   SELECT * FROM rux_file
       WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00
         AND rux08 != 0
       INTO TEMP x
   UPDATE x SET rux00='2',rux01=l_newno,ruxplant = g_plant,ruxlegal = g_legal
   #對單身中的項次重新編號，防止跳號
   LET g_sql = "SELECT rux02,rux03 FROM x ORDER BY rux02 "
   PREPARE t212_get_x FROM g_sql
   DECLARE rux_cs_x CURSOR FOR t212_get_x
   LET g_cnt = 1
   FOREACH rux_cs_x INTO l_rux02,l_rux03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE x SET rux02 = g_cnt WHERE rux03 = l_rux03
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt = 1 THEN
      DELETE FROM ruw_file WHERE ruw00 = '2' AND ruw01 = l_newno 
      CALL cl_err('','art-411',1)
      RETURN
   END IF
   INSERT INTO rux_file SELECT * FROM x
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
      CALL cl_err3("ins","rux_file","","",SQLCA.sqlcode,"","",1)                                                                    
      RETURN                                                                                                                        
   END IF

#FUN-B90103---------add-------
#IF s_industry("slk") THEN
#  DROP TABLE x
#  SELECT * FROM ruxslk_file
#      WHERE ruxslk01=g_ruw.ruw01 AND ruxslk00=g_ruw.ruw00
#      INTO TEMP x
#  UPDATE x SET ruxslk00='2',ruxslk01=l_newno,ruxslkplant = g_plant,ruxslklegal = g_legal
#  #對單身中的項次重新編號，防止跳號
#  LET g_sql = "SELECT ruxslk02,ruxslk03 FROM x ORDER BY ruxslk02 "
#  PREPARE t212_get_slk_x FROM g_sql
#  DECLARE ruxslk_cs_slk_x CURSOR FOR t212_get_slk_x
#  LET g_cnt = 1
#  FOREACH ruxslk_cs_slk_x INTO l_ruxslk02,l_ruxslk03
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     UPDATE x SET ruxslk02 = g_cnt WHERE ruxslk03 = l_ruxslk03
#     LET g_cnt = g_cnt + 1
#  END FOREACH
#  IF g_cnt = 1 THEN
#     DELETE FROM ruw_file WHERE ruw00 = '2' AND ruw01 = l_newno
#     CALL cl_err('','art-411',1)
#     RETURN
#  END IF
#  INSERT INTO ruxslk_file SELECT * FROM x
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err3("ins","ruxslk_file","","",SQLCA.sqlcode,"","",1)
#     RETURN
#  END IF
#END IF 
#FUN-B90103---------end-------

   UPDATE ruw_file SET ruw03 = l_newno WHERE ruw00 = '1' AND ruw01 = g_ruw.ruw01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)                                                                    
      RETURN                                                                                                                        
   END IF
   DISPLAY l_newno TO ruw03
   CALL cl_err(l_newno,'art-399',1)
END FUNCTION
#取帳面庫存
FUNCTION t212_get_store()
DEFINE l_rux06          LIKE rux_file.rux06
DEFINE l_rux07          LIKE rux_file.rux07
DEFINE l_rut06          LIKE rut_file.rut06
DEFINE l_rux03          LIKE rux_file.rux03
  
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruwacti ='N' THEN
      CALL cl_err(g_ruw.ruw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-405',0)
      RETURN
   END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err(g_ruw.ruw01,'9024',0) RETURN END IF 
  #TQC-B10048 Begin---
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rut_file 
    WHERE rut01=g_ruw.ruw02
   IF g_cnt = 0 THEN
      CALL cl_err(g_ruw.ruw02,'art-692',1)
      RETURN
   END IF
  #TQC-B10048 End-----
   
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
   
   CALL t212_show()
   LET g_sql = "SELECT rux03,rux06,rux07 FROM rux_file ",
               " WHERE rux00 = '1' AND rux01 = '",g_ruw.ruw01,"'"
   PREPARE t121_rux1 FROM g_sql
   DECLARE rux1_cs CURSOR FOR t121_rux1
   FOREACH rux1_cs INTO l_rux03,l_rux06,l_rux07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
 #     SELECT rut06-rut07 INTO l_rut06 FROM rut_file WHERE rut01=g_ruw.ruw02 AND #bnl add rut07    #TQC-B20082 mark
       LET l_rut06 = 0  # MOD-C30051
       SELECT rut06 INTO l_rut06 FROM rut_file WHERE rut01=g_ruw.ruw02 AND                         #TQC-B20082 
         rut03 = g_ruw.ruw05 AND rut04 = l_rux03
      IF l_rut06 IS NULL THEN LET l_rut06 = 0 END IF
 
      UPDATE rux_file SET rux05 = l_rut06 WHERE rux00='1' AND rux01=g_ruw.ruw01
         AND rux03 = l_rux03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1) 
         CLOSE t212_cl
         ROLLBACK WORK
         RETURN
      END IF
      IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
      IF l_rux07 IS NULL THEN LET l_rux07 = 0 END IF
 
      UPDATE rux_file SET rux08 = l_rux06+l_rux07-l_rut06 WHERE rux00 = '1'   #bnl -090204
         AND rux01 = g_ruw.ruw01 
         AND rux03 = l_rux03
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)
         CLOSE t212_cl
         ROLLBACK WORK 
         RETURN
      END IF
   END FOREACH  
   COMMIT WORK
   CALL cl_err('','art-406',1)
   CALL t212_b_fill(" 1=1"," 1=1")  #FUN-B90103--add "1=1"  
END FUNCTION
 
FUNCTION t212_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
#FUN-B90103--add--begin--
   DEFINE   l_i      LIKE type_file.num5,
            l_index  LIKE type_file.num5,
            l_ima151 LIKE ima_file.ima151
#FUN-B90103--add--end-- 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B90103--add--begin---
 IF s_industry("slk")  AND g_argv1 = '1' THEN
  DIALOG ATTRIBUTES(UNBUFFERED)
     DISPLAY ARRAY g_ruxslk TO s_ruxslk.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL g_imx.clear()
            LET g_action_choice=""
            LET g_b_flag = '1'   #FUN-D30033 add

         BEFORE ROW
            CALL cl_set_comp_visible("color",FALSE)
            FOR l_i = 1 TO 15
                LET l_index = l_i USING '&&'
                CALL cl_set_comp_visible("imx" || l_index,FALSE)
            END FOR
            LET l_ac2 = DIALOG.getCurrentRow("s_ruxslk")
            IF l_ac2 != 0 THEN
               CALL s_settext_slk(g_ruxslk[l_ac2].ruxslk03)
               CALL s_fillimx_slk(g_ruxslk[l_ac2].ruxslk03,
                                   g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
               LET g_rec_b3 = g_imx.getLength()
            END IF
      END DISPLAY

      DISPLAY ARRAY g_imx TO s_imx.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_action_choice=""
            LET g_b_flag = '2'   #FUN-D30033 add

         BEFORE ROW
            LET l_ac3 = DIALOG.getCurrentRow("s_imx")
            CALL cl_show_fld_cont()
      END DISPLAY
#   DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #FUN-B90103--mark
    DISPLAY ARRAY g_rux TO s_rux.*                                       #FUN-B90103--add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_argv1 = '2' THEN
            CALL cl_set_action_active("INSERT,reproduce",FALSE)
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
     END DISPLAY      #FUN-B90103--add

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
 
      ON ACTION first
         CALL t212_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
 
      ON ACTION previous
         CALL t212_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
 
      ON ACTION jump
         CALL t212_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
 
      ON ACTION next
         CALL t212_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
 
      ON ACTION last
         CALL t212_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG

      ON ACTION controlb
         LET l_ac2 = DIALOG.getCurrentRow("s_ruxslk")
         SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_ruxslk[l_ac2].ruxslk03 
         IF l_ima151 = 'Y' THEN 
            IF li_a THEN
               LET li_a = FALSE
               NEXT FIELD ruxslk03 
            ELSE
               LET li_a = TRUE
               NEXT FIELD color 
            END IF
         END IF

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      
      #FUN-D20039 ----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20039 ----------end

      ON ACTION create_check
         LET g_action_choice="create_check"
         EXIT DIALOG
 
      ON ACTION get_store
         LET g_action_choice="get_store"
         EXIT DIALOG
 
      ON ACTION update_store
         LET g_action_choice = "update_store"
         EXIT DIALOG
 
     #FUN-B40039 Begin---
      ON ACTION sel_item
         LET g_action_choice = "sel_item"
         EXIT DIALOG
     #FUN-B40039 End-----
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
       END DIALOG
ELSE
    DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #FUN-B90103--mark

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_argv1 = '2' THEN
            CALL cl_set_action_active("INSERT,reproduce",FALSE)
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t212_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t212_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t212_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t212_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t212_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20039 --------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 --------end

      ON ACTION create_check
         LET g_action_choice="create_check"
         EXIT DISPLAY
 
      ON ACTION get_store
         LET g_action_choice="get_store"
         EXIT DISPLAY
 
      ON ACTION update_store
         LET g_action_choice = "update_store"
         EXIT DISPLAY
 
     #FUN-B40039 Begin---
      ON ACTION sel_item
         LET g_action_choice = "sel_item"
         EXIT DISPLAY
     #FUN-B40039 End-----
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
   END DISPLAY
END IF

#FUN-B90103-----------end-------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t212_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_ruwcont  LIKE ruw_file.ruwcont  #FUN-870100
DEFINE l_ruxslk02 LIKE ruxslk_file.ruxslk02   #FUN-C70098
DEFINE l_ruxslk03 LIKE ruxslk_file.ruxslk03   #FUN-C70098
DEFINE l_ruxslk06 LIKE ruxslk_file.ruxslk06   #FUN-C70098
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 ------------ add ------------- begin
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err(g_ruw.ruw01,'9024',0) RETURN END IF
   IF g_ruw.ruwacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 ------------ add ------------- end
   #Add by zm 090617
   SELECT sma53 INTO g_sma.sma53 FROM sma_file
   IF g_sma.sma53 IS NOT NULL AND g_ruw.ruw04 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      RETURN
   END IF
   #End by zm 090617
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err(g_ruw.ruw01,'9024',0) RETURN END IF 
   IF g_ruw.ruwacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rux_file
    WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00 
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #FUN-C70098----add----begin--------------
   IF s_industry("slk")  AND g_argv1= '1' THEN
       DECLARE ruxslk03_curs CURSOR FOR
          SELECT ruxslk02,ruxslk03,ruxslk06 FROM ruxslk_file WHERE ruxslk00 = g_ruw.ruw00 
                                                               AND ruxslk01 = g_ruw.ruw01
       CALL s_showmsg_init()       
       FOREACH ruxslk03_curs INTO l_ruxslk02,l_ruxslk03,l_ruxslk06 
           IF cl_null(l_ruxslk06) OR l_ruxslk06 = 0 THEN
              CALL s_errmsg('', g_ruw.ruw01 ,l_ruxslk03 ,'art-386',1)
              LET g_success = 'N'  
           END IF 
       END FOREACH 
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------
 
   SELECT * FROM ruw_file                                                                                                        
      WHERE ruw00 = g_ruw.ruw00 AND ruwconf = 'Y'                                                                               
        AND ruw02 = g_ruw.ruw02 AND ruw05 = g_ruw.ruw05                                                                         
   IF SQLCA.SQLCODE <> 100 THEN                                                                                                  
      CALL cl_err('','art-390',0)
      RETURN                                                                                                    
   END IF
   #add  FUN-AB0078
   IF NOT s_chk_ware(g_ruw.ruw05) THEN #检查仓库是否属于当前门店
      LET g_success='N'
      RETURN
   END IF
   #end  FUN-AB0078
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   LET l_ruwcont=TIME        #FUN-870100
   UPDATE ruw_file SET ruwconf='Y',
                       ruwcond=g_today, 
                       ruwconu=g_user,
                       ruwcont=l_ruwcont    #FUN-870100
     WHERE ruw01=g_ruw.ruw01
       AND ruw00=g_ruw.ruw00 
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_ruw.ruwconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY BY NAME g_ruw.ruwconf                                                                                         
   DISPLAY BY NAME g_ruw.ruwcond                                                                                         
   DISPLAY BY NAME g_ruw.ruwconu
   DISPLAY l_gen02 TO FORMONLY.ruwconu_desc
   DISPLAY BY NAME g_ruw.ruwcont          #FUN-870100
   #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
 
FUNCTION t212_no()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_n        LIKE type_file.num5
DEFINE l_ruwcont  LIKE ruw_file.ruwcont    #CHI-D20015 Add
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF

   #No.FUN-A50071 -----start---------   
   #-->POS單號不為空時不可取消確認
   IF NOT cl_null(g_ruw.ruw10) THEN
      CALL cl_err(' ','axm-743',0)
      RETURN
   END IF 
   #No.FUN-A50071 -----end---------
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   CALL t212_show()
   IF g_ruw.ruwconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF
   IF g_argv1 = '1' THEN
      SELECT COUNT(*) INTO l_n  FROM ruw_file 
         WHERE ruw00 = '2' AND ruw03 = g_ruw.ruw01 
      IF l_n > 0 THEN
         CALL cl_err('','art-402',0)
         RETURN
      END IF
   ELSE
      IF g_ruw.ruw08 = 'Y' THEN
         CALL cl_err('','art-404',0)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   LET l_ruwcont = TIME    #CHI-D20015 Add
   UPDATE ruw_file SET ruwconf='N',
                      #CHI-D20015 Mark&Add Str
                      #ruwcond=NULL,
                      #ruwconu=NULL,
                      #ruwpos='1', #No.FUN-870008 #NO.FUN-B50042
                      #ruwcont=NULL
                       ruwcond=g_today,
                       ruwconu=g_user,
                       ruwpos='1',
                       ruwcont=l_ruwcont
                      #CHI-D20015 Mark&Add End
     WHERE ruw01=g_ruw.ruw01
       AND ruw00=g_ruw.ruw00 
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_ruw.ruwconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY BY NAME g_ruw.ruwconf                                                                                         
   DISPLAY BY NAME g_ruw.ruwcond                                                                                         
   DISPLAY BY NAME g_ruw.ruwconu
  #DISPLAY '' TO FORMONLY.ruwconu_desc      #CHI-D20015 Mark
   DISPLAY l_gen02 TO FORMONLY.ruwconu_desc #CHI-D20015 Add
   DISPLAY BY NAME g_ruw.ruwpos #No.FUN-870008
   DISPLAY BY NAME g_ruw.ruwcont
   #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
 
FUNCTION t212_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
DEFINE l_ruwcont LIKE ruw_file.ruwcont     #FUN-870100
 
   IF s_shut(0) THEN RETURN END IF
      
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruw.ruwconf='X' THEN RETURN END IF
    ELSE
       IF g_ruw.ruwconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwacti = 'N' THEN CALL cl_err('','art-142',0) RETURN END IF
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_ruw.ruwconf) THEN
      LET g_chr = g_ruw.ruwconf
      IF g_ruw.ruwconf = 'N' THEN
         LET g_ruw.ruwconf = 'X'
      ELSE
         LET g_ruw.ruwconf = 'N'
      END IF
      LET l_ruwcont=TIME    #FUN-870100
      UPDATE ruw_file SET ruwconf=g_ruw.ruwconf,
                          ruwmodu=g_user,
                          ruwdate=g_today,
                          ruwpos='1', #No.FUN-870008 #NO.FUN-B40072
                          ruwcont=l_ruwcont     #FUN-870100
       WHERE ruw01 = g_ruw.ruw01 
         AND ruw00=g_ruw.ruw00
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","up ruwconf",1)
          LET g_ruw.ruwconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t212_cl
   COMMIT WORK
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
   DISPLAY BY NAME g_ruw.ruwconf                                                                                        
   DISPLAY BY NAME g_ruw.ruwmodu                                                                                        
   DISPLAY BY NAME g_ruw.ruwdate
   DISPLAY BY NAME g_ruw.ruwpos #No.FUN-870008
   DISPLAY BY NAME g_ruw.ruwcont        #FUN-870100
    #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
FUNCTION t212_bp_refresh()
  DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION

#FUN-B90103-----add---
FUNCTION t212_bp_refresh_slk()
  DISPLAY ARRAY g_ruxslk TO s_ruxslk.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

#FUN-B90103-----end--- 
FUNCTION t212_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rux.clear()
#FUN-B90103---add--begin--
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL g_ruxslk.clear()
   CALL g_imx.clear()
   LET g_wc3= NULL
END IF
#FUN-B90103---end---------
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruw.* LIKE ruw_file.*
   LET g_ruw01_t = NULL
 
   LET g_ruw_t.* = g_ruw.*
   LET g_ruw_o.* = g_ruw.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruw.ruwuser=g_user
      LET g_ruw.ruworiu = g_user #FUN-980030
      LET g_ruw.ruworig = g_grup #FUN-980030
      LET g_data_plant = g_plant #TQC-A10128 ADD
      LET g_ruw.ruwgrup=g_grup
      LET g_ruw.ruwacti='Y'
      LET g_ruw.ruwcrat = g_today
      LET g_ruw.ruwconf = 'N'
      LET g_ruw.ruw00 = g_argv1
      LET g_ruw.ruw06 = g_user
      LET g_ruw.ruw08 = 'N'
      LET g_ruw.ruwmksg = 'N'                    
      LET g_ruw.ruwplant = g_plant
      LET g_ruw.ruwlegal = g_legal
      LET g_ruw.ruw900 = '0'
      LET g_ruw.ruwcont = ''  #FUN-870100
      #LET g_ruw.ruwpos = 'N'  #FUN-870100
      LET g_ruw.ruwpos = '1'  #FUN-B40072
      DISPLAY g_ruw.ruwcont TO ruwcont  #FUN-870100
      DISPLAY g_ruw.ruwpos TO ruwpos  #FUN-870100
      CALL t212_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ruw.* TO NULL
         LET INT_FLAG = 0
         CLEAR FORM 
         DISPLAY g_argv1 TO ruw00
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruw.ruw01) OR cl_null(g_ruw.ruw00)
         OR cl_null(g_ruw.ruwplant) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#FUN-A70130--begin--
#     CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"","ruw_file","ruw01","","","")        #FUN-A70130 mark                                     
#          RETURNING li_result,g_ruw.ruw01                                                   #FUN-A70130 mark
      IF  g_ruw.ruw00 = '1' THEN
          CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"J4","ruw_file","ruw01","","","")                                             
               RETURNING li_result,g_ruw.ruw01
      ELSE
          CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"J5","ruw_file","ruw01","","","")                                             
               RETURNING li_result,g_ruw.ruw01
      END IF
#FUN-A70130--end--
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ruw.ruw01
      INSERT INTO ruw_file VALUES (g_ruw.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        ROLLBACK WORK  #TQC-B80044
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK  #TQC-B80044
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruw.ruw01,'I')
      END IF
 
      LET g_ruw01_t = g_ruw.ruw01
      LET g_ruw_t.* = g_ruw.*
      LET g_ruw_o.* = g_ruw.*
      CALL g_rux.clear()
#FUN-B90103---add--
IF s_industry("slk") AND g_argv1 = '1' THEN
      CALL g_ruxslk.clear()
      CALL g_imx.clear()
      LET g_rec_b2 = 0
END IF
#FUN-B90103---end-- 
      LET g_rec_b = 0
      CALL t212_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t212_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file
    WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruwacti ='N' THEN
      CALL cl_err(g_ruw.ruw01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruw01_t = g_ruw.ruw01
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t212_show()
 
   WHILE TRUE
      LET g_ruw01_t = g_ruw.ruw01
      LET g_ruw_t.* = g_ruw.*
      LET g_ruw_o.* = g_ruw.*
      LET g_ruw.ruwmodu=g_user
      LET g_ruw.ruwdate=g_today      
      #FUN-B40072 --START--
      #LET g_ruw.ruwpos='N' #No.FUN-870008
      IF g_ruw.ruwpos <> '1' THEN
        LET g_ruw.ruwpos='2'
      END IF
      #FUN-B40072 --END-- 
      CALL t212_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruw.*=g_ruw_t.*
         CALL t212_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruw.ruw01 != g_ruw01_t OR g_ruw.ruw00 != g_ruw_t.ruw00 THEN
         UPDATE ruw_file SET ruw01 = g_ruw.ruw01,ruw00=g_ruw.ruw00
           WHERE rux01 = g_ruw01_t
             AND rux00=g_ruw_t.ruw00 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rux_file",g_ruw01_t,"",SQLCA.sqlcode,"","rux",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruw_file SET ruw_file.* = g_ruw.*
       WHERE ruw01 = g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruw_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t212_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruw.ruw01,'U')
 
   CALL t212_b_fill(" 1=1"," 1=1") #FUN-B90103--add-"1=1"
#FUN-B90103---add---
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL t212_b_fill2(" 1=1"," 1=1") #FUN-B90103--add-"1=1"
   CALL t212_bp_refresh_slk()
END IF
#FUN-B90103--end-----
   CALL t212_bp_refresh()
 
END FUNCTION
 
FUNCTION t212_i(p_cmd)
DEFINE
   l_pmc05     LIKE pmc_file.pmc05,
   l_pmc30     LIKE pmc_file.pmc30,
   l_n         LIKE type_file.num5,
   p_cmd       LIKE type_file.chr1,
   li_result   LIKE type_file.num5,
   l_gen02     LIKE gen_file.gen02,
   l_azp02     LIKE azp_file.azp02,
   l_ck        LIKE type_file.chr50,
   tok         base.StringTokenizer,
   l_rus05     LIKE rus_file.rus05,
   l_temp      LIKE type_file.chr1000
DEFINE l_slip  LIKE smy_file.smyslip               #TQC-AB0290	 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03,
                   g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
      #             g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,g_ruw.ruwmksg,   #FUN-870100         #TQC-AB0290  mark
                   g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,                                      #TQC-AB0290
      #             g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08, #FUN-A50071 add ruw10     #TQC-AB0290  mark
                   g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,                                         #TQC-AB0290
                   g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwpos,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,  #FUN-870100
                   g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat,
                   g_ruw.ruworiu,g_ruw.ruworig                                   #TQC-A30050 ADD
                   
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruw.ruw06                
   DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruw.ruwplant
   DISPLAY l_azp02 TO FORMONLY.ruwplant_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ruw.ruw00,g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03,          #TQC-A30050 MARK g_ruw.ruworiu,g_ruw.ruworig,
                 g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
     #            g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwmksg,        #FUN-A50071 add ruw10           #TQC-AB0290  mark
                 g_ruw.ruwcond,g_ruw.ruwconu,                                                       #TQC-AB0290
     #            g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,                              #TQC-AB0290  mark
                 g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,                                            #TQC-AB0290
                 g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,
                 g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t212_set_entry(p_cmd)
         CALL t212_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruw01")
 
      AFTER FIELD ruw01
         IF NOT cl_null(g_ruw.ruw01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw01 != g_ruw_t.ruw01) THEN
               IF g_ruw.ruw00 = '1' THEN
#                 CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J","ruw_file","ruw01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J4","ruw_file","ruw01","")  #FUN-A70130 mod
                     RETURNING li_result,g_ruw.ruw01
               ELSE
#                 CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"L","ruw_file","ruw01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J5","ruw_file","ruw01","")  #FUN-A70130 mod
                     RETURNING li_result,g_ruw.ruw01
               END IF
               DISPLAY BY NAME g_ruw.ruw01
               IF (NOT li_result) THEN
                  LET g_ruw.ruw01=g_ruw_t.ruw01
                  NEXT FIELD ruw01
               END IF
            END IF
         END IF
         
      AFTER FIELD ruw02
         IF NOT cl_null(g_ruw.ruw02) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw02 != g_ruw_t.ruw02) THEN
               CALL t212_ruw02()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruw02        
               END IF
               
               CALL t212_ruw05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruw02        
               END IF
            END IF
         END IF
         
      AFTER FIELD ruw05
         IF NOT cl_null(g_ruw.ruw05) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_ruw.ruw05) THEN
               NEXT FIELD ruw05
            END IF 
            #No.FUN-AA0049--end         
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw05 != g_ruw_t.ruw05) THEN
               CALL t212_ruw05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN    
                  CALL cl_err('',g_errno,0)    
                  NEXT FIELD ruw05            
               END IF
            END IF
         END IF
      
      AFTER FIELD ruw06
         IF NOT cl_null(g_ruw.ruw06) THEN
            CALL t212_ruw06()
            IF NOT cl_null(g_errno)  THEN                                                                                         
               CALL cl_err('',g_errno,0)                                                                                          
               NEXT FIELD ruw06                                                                                                   
            END IF
         END IF   
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruw01)
               LET g_t1=s_get_doc_no(g_ruw.ruw01)
               IF g_argv1 = '1' THEN
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','J') RETURNING g_t1  #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J4','ART') RETURNING g_t1  #FUN-A70130--mod--
               ELSE
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','L') RETURNING g_t1  #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J5','ART') RETURNING g_t1  #FUN-A70130--mod--
               END IF
               LET g_ruw.ruw01 = g_t1
               DISPLAY BY NAME g_ruw.ruw01
               NEXT FIELD ruw01 
            
            WHEN INFIELD(ruw02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rus"
               LET g_qryparam.default1 = g_ruw.ruw02
               CALL cl_create_qry() RETURNING g_ruw.ruw02
               DISPLAY BY NAME g_ruw.ruw02
               CALL t212_ruw02()
               NEXT FIELD ruw02
                  
            WHEN INFIELD(ruw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ruw05"
               SELECT rus05 INTO l_rus05 FROM rus_file
                  WHERE rus01 = g_ruw.ruw02
                    AND rusplant=g_plant   #No.FUN-AA0049
               LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
               LET g_qryparam.where = " imd01 IN ('"
               WHILE tok.hasMoreTokens()
                  LET l_ck = tok.nextToken()
                  LET g_qryparam.where = g_qryparam.where,l_ck,"','"
               END WHILE
               LET g_qryparam.where = g_qryparam.where.trimRight()
               LET l_temp = g_qryparam.where
               LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
               LET g_qryparam.where = g_qryparam.where,")"
               LET g_qryparam.default1 = g_ruw.ruw05
               CALL cl_create_qry() RETURNING g_ruw.ruw05
               DISPLAY BY NAME g_ruw.ruw05
               CALL t212_ruw05()
               NEXT FIELD ruw05
               
            WHEN INFIELD(ruw06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ruw.ruw06
               CALL cl_create_qry() RETURNING g_ruw.ruw06
               DISPLAY BY NAME g_ruw.ruw06
               CALL t212_ruw06()
               NEXT FIELD ruw06
               
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t212_ruw02()
DEFINE l_rus02    LIKE rus_file.rus02
DEFINE l_rusacti  LIKE rus_file.rusacti
DEFINE l_rusconf  LIKE rus_file.rusconf
 
   LET g_errno = ""
   SELECT rus02,rus04 INTO l_rus02,g_ruw.ruw04
      FROM rus_file WHERE rus01 = g_ruw.ruw02 
      
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-388'
        WHEN l_rusacti='N'  LET g_errno = '9028'
        WHEN l_rusconf<>'Y' LET g_errno = 'art-384'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
                            DISPLAY l_rus02 TO FORMONLY.ruw02_desc
                            DISPLAY BY NAME g_ruw.ruw04
   END CASE
END FUNCTION
 
FUNCTION t212_ruw05()
DEFINE l_rus05    LIKE rus_file.rus05
DEFINE l_rusacti  LIKE rus_file.rusacti
DEFINE l_rusconf  LIKE rus_file.rusconf
DEFINE l_count    LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_imd02    LIKE imd_file.imd02
 
   LET g_errno = ""
   
   IF g_ruw.ruw02 IS NULL OR g_ruw.ruw05 IS NULL THEN
      RETURN
   END IF
   #檢查當前機構是否存在該盤點計劃
   SELECT rus05,rusacti,rusconf INTO l_rus05,l_rusacti,l_rusconf 
      FROM rus_file WHERE rus01 = g_ruw.ruw02 
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-392'
        WHEN l_rusacti='N'  LET g_errno = '9028'
        WHEN l_rusconf<>'Y' LET g_errno = 'art-384'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   #檢查當前錄入的倉庫是否屬于盤點計劃中的倉庫
   IF cl_null(g_errno) THEN
      LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
      LET l_count = 0
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         IF l_ck = g_ruw.ruw05 THEN LET l_count = 1 END IF 
      END WHILE
      IF l_count = 0 THEN LET g_errno = 'art-385' END IF 
   END IF 
   #檢查盤點計劃和盤點倉庫是否有重用
   IF cl_null(g_errno) THEN
      SELECT * FROM ruw_file
          WHERE ruw00 = g_ruw.ruw00 AND ruwconf = 'Y'
            AND ruw02 = g_ruw.ruw02 AND ruw05 = g_ruw.ruw05
      IF SQLCA.SQLCODE <> 100 THEN
         LET g_errno = 'art-390'
      END IF
   END IF
   IF cl_null(g_errno) THEN
      SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_ruw.ruw05 
      DISPLAY l_imd02 TO FORMONLY.ruw05_desc
   END IF
END FUNCTION 
 
FUNCTION t212_ruw06()
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_genacti  LIKE gen_file.genacti
 
   LET g_errno = ""
 
   SELECT gen02,genacti
     INTO l_gen02,l_genacti
     FROM gen_file WHERE gen01 = g_ruw.ruw06
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-391'
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   END CASE
 
END FUNCTION
 
FUNCTION t212_rux03()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.num5 
DEFINE l_rus07   LIKE rus_file.rus07                                                  
DEFINE l_rus09   LIKE rus_file.rus09                                                     
DEFINE l_rus11   LIKE rus_file.rus11                                                    
DEFINE l_rus13   LIKE rus_file.rus13
 
   LET g_errno = ""
 
   SELECT ima02,imaacti,ima25,gfe02
      INTO g_rux[l_ac].rux03_desc,l_imaacti,
           g_rux[l_ac].rux04,g_rux[l_ac].rux04_desc
      FROM ima_file,gfe_file 
      WHERE ima01 = g_rux[l_ac].rux03 AND gfe01 = ima25
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rux[l_ac].rux03_desc TO FORMONLY.rux03_desc
                           DISPLAY g_rux[l_ac].rux04_desc TO FORMONLY.rux04_desc
                           DISPLAY BY NAME g_rux[l_ac].rux04
                           
   END CASE
   
   IF cl_null(g_errno) THEN
      SELECT rtz04 INTO l_rtz04 
         FROM rtz_file WHERE rtz01=g_ruw.ruwplant
      IF NOT cl_null(l_rtz04) THEN
         SELECT rus07,rus09,rus11,rus13 
       	     INTO l_rus07,l_rus09,l_rus11,l_rus13
             FROM rus_file 
             WHERE rus01 = g_ruw.ruw02 
         CALL t212_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
         IF l_flag = 0 THEN
            SELECT COUNT(*) INTO l_n FROM rte_file 
               WHERE rte01 = l_rtz04 AND rte03 = g_rux[l_ac].rux03
            IF l_n = 0 OR l_n IS NULL THEN
               LET g_errno = 'art-054'
            END IF    
         ELSE
       	    FOR l_i=1 TO g_result.getLength()
               IF g_result[l_i] = g_rux[l_ac].rux03 THEN
                  LET l_flag = 3
               END IF
            END FOR
            IF l_flag <> '3' THEN
               LET g_errno = 'art-387'
            END IF
         END IF
      END IF
   END IF
   
   IF cl_null(g_errno) THEN
 #     SELECT rut06-rut07 INTO g_rux[l_ac].rux05 FROM rut_file WHERE rut01=g_ruw.ruw02 #bnl add rut07      #TQC-B20082 mark
       SELECT rut06 INTO g_rux[l_ac].rux05 FROM rut_file WHERE rut01=g_ruw.ruw02                           #TQC-B20082
         AND rut02=g_ruw.ruw04 AND rut03=g_ruw.ruw05
         AND rut04=g_rux[l_ac].rux03
      IF g_rux[l_ac].rux05 IS NULL THEN LET g_rux[l_ac].rux05 = 0 END IF
   END IF
END FUNCTION
 
FUNCTION t212_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rux.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t212_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruw.* TO NULL
      RETURN
   END IF
 
   OPEN t212_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruw.* TO NULL
   ELSE
      OPEN t212_count
      FETCH t212_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t212_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t212_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'P' FETCH PREVIOUS t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'F' FETCH FIRST    t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'L' FETCH LAST     t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      INITIALIZE g_ruw.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01 = g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruw_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ruw.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_ruw.ruwuser
   LET g_data_group = g_ruw.ruwgrup
   LET g_data_plant = g_ruw.ruwplant   #TQC-A10128 ADD
 
   CALL t212_show()
 
END FUNCTION
 
FUNCTION t212_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE  l_rus02  LIKE rus_file.rus02
DEFINE  l_imd02  LIKE imd_file.imd02
   LET g_ruw_t.* = g_ruw.*
   LET g_ruw_o.* = g_ruw.*
   DISPLAY BY NAME g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03, g_ruw.ruworiu,g_ruw.ruworig,
                   g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
  #                 g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,g_ruw.ruwmksg,         #FUN-870100      #TQC-AB0290  mark
                   g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,                                         #TQC-AB0290
  #                 g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,    #FUN-A50071 add ruw10     #TQC-AB0290  mark
                   g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,                                            #TQC-AB0290
                   g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwpos,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,  #FUN-870100
                   g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat
                  ,g_ruw.ruworiu,g_ruw.ruworig                                   #TQC-A30050 ADD
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY l_gen02 TO FORMONLY.ruwconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruw.ruwplant
   DISPLAY l_azp02 TO FORMONLY.ruwplant_desc
   SELECT rus02 INTO l_rus02 FROM rus_file WHERE rus01 = g_ruw.ruw02
   DISPLAY l_rus02 TO FORMONLY.ruw02_desc
   LET l_gen02 = ''
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruw06
   DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_ruw.ruw05
   DISPLAY l_imd02 TO FORMONLY.ruw05_desc
 
   #CKP                                                                                                                             
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL t212_b_fill(g_wc2,g_wc3)        
ELSE
   CALL t212_b_fill(g_wc2," 1=1")   #FUN-B90103--add-"1=1" 
END IF
#FUN-B90103--------add---
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL t212_b_fill2(g_wc2,g_wc3)
   CALL t212_rux06_sum()
END IF
#FUN-B90103--------end---
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t212_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t212_show()
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   IF cl_exp(0,0,g_ruw.ruwacti) THEN
      LET g_chr=g_ruw.ruwacti
      IF g_ruw.ruwacti='Y' THEN
         LET g_ruw.ruwacti='N'
      ELSE
         LET g_ruw.ruwacti='Y'
      END IF
 
      UPDATE ruw_file SET ruwacti=g_ruw.ruwacti,
                          ruwmodu=g_user,
                          ruwdate=g_today
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_ruw.ruwacti=g_chr
      END IF
   END IF
 
   CLOSE t212_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruwacti,ruwmodu,ruwdate
     INTO g_ruw.ruwacti,g_ruw.ruwmodu,g_ruw.ruwdate FROM ruw_file
    WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
   DISPLAY BY NAME g_ruw.ruwacti,g_ruw.ruwmodu,g_ruw.ruwdate
 
END FUNCTION
 
FUNCTION t212_r()
DEFINE l_rows       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   #FUN-B50042 --START--   
   #IF g_aza.aza88 = 'Y' THEN
   #   IF NOT (g_ruw.ruwacti='N' AND g_ruw.ruwpos='Y') THEN
   #     #CALL cl_err('', 'aim-944', 1)     #FUN-A30030 MARK
   #      CALL cl_err('', 'apc-139', 1)     #ADD
   #      RETURN
   #   END IF
   #ELSE
   #FUN-B50042 --START--
      IF g_ruw.ruwacti='N' THEN
         CALL cl_err('','mfg1000',1)
         RETURN
      END IF
   #END IF #NO.FUN-B50042
   
   
   SELECT * INTO g_ruw.* FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 
         AND ruw00 = g_ruw.ruw00
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_ruw.ruwconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t212_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruw.ruw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM ruw_file WHERE ruw01 = g_ruw.ruw01 
         AND ruw00 = g_ruw.ruw00 
#FUN-B90103---add---begin---
      IF s_industry("slk") AND g_argv1 = '1' THEN
         DELETE FROM ruxslk_file WHERE ruxslk00 = g_ruw.ruw00
           AND ruxslk01 = g_ruw.ruw01 
      END IF
#FUN-B90103---end-----------
      DELETE FROM rux_file WHERE rux01 = g_ruw.ruw01
         AND rux00 = g_ruw.ruw00 
      IF g_argv1 = '2' THEN
         UPDATE ruw_file SET ruw03 = NULL WHERE ruw00 = '1' 
            AND ruw03 = g_ruw.ruw01
      END IF
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_rows FROM ruw_file 
             WHERE ruw02 = g_ruw.ruw02 
               AND ruwconf <> 'X'
         IF l_rows IS NULL THEN LET l_rows = 0 END IF
         IF l_rows = 0 THEN 
            UPDATE rus_file SET rus900 = '0'
                WHERE rus01 = g_ruw.ruw02 
            UPDATE ruu_file SET ruu900 = '0' WHERE ruu02 = g_ruw.ruw02
         END IF
      END IF
      CLEAR FORM
      DISPLAY g_argv1 TO ruw00
#FUN-B90103----add---begin--
IF s_industry("slk") AND g_argv1 = '1' THEN
      CALL g_ruxslk.clear()
      CALL g_imx.clear()
END IF
#FUN-B90103----end----------
      CALL g_rux.clear()
      OPEN t212_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t212_cs
          CLOSE t212_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      FETCH t212_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t212_cs
          CLOSE t212_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t212_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t212_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t212_fetch('/')
      END IF
   END IF
 
   CLOSE t212_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruw.ruw01,'D')
END FUNCTION
 
FUNCTION t212_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_i       LIKE type_file.num5
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_rus07   LIKE rus_file.rus07
DEFINE l_rus09   LIKE rus_file.rus09
DEFINE l_rus11   LIKE rus_file.rus11
DEFINE l_rus13   LIKE rus_file.rus13
DEFINE l_flag    LIKE type_file.num5
DEFINE l_temp    LIKE type_file.chr1000
DEFINE l_sql     STRING             #FUN-AA0059
DEFINE l_ac2_t   LIKE type_file.num5   #FUN-B90103--add
DEFINE l_ima151  LIKE ima_file.ima151  #FUN-B90103--add
DEFINE l_imaag   LIKE ima_file.imaag   #FUN-C20006--add
DEFINE l_error   LIKE type_file.chr10  #TQC-C20348 add
DEFINE l_ima01   LIKE ima_file.ima01   #TQC-C20348 add

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruw.ruw01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruw.* FROM ruw_file
     WHERE ruw01=g_ruw.ruw01
       AND rux00 = g_ruw.ruw00 
 
    IF g_ruw.ruwacti ='N' THEN
       CALL cl_err(g_ruw.ruw01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_ruw.ruwconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_ruw.ruwconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruw.ruwplant                                     
    LET g_forupd_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
                       "  FROM rux_file ",
                       " WHERE rux00 = ? AND rux01=? AND rux02=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t212_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#FUN-B90103------------start--
    LET g_forupd_sql = "SELECT ruxslk02,ruxslk03,'',ruxslk04,'',ruxslk06,ruxslk09 ",
                       "  FROM ruxslk_file ",
                       " WHERE ruxslk00 = ? AND ruxslk01=? AND ruxslk02=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t212_bcl_slk CURSOR FROM g_forupd_sql      # LOCK CURSOR
#FUN-B90103------------end--- 

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
#FUN-B90103--add--str--
IF s_industry("slk") AND g_argv1 = '1' THEN
   IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF   #FUN-D30033 aedd
   IF g_rec_b3 > 0 THEN LET l_ac3 = 1 END IF   #FUN-D30033 add
   
 DIALOG ATTRIBUTES(UNBUFFERED)
       INPUT ARRAY g_ruxslk FROM s_ruxslk.*
             ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           LET li_a=FALSE                 #FUN-C60100 add
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
           CALL cl_set_comp_entry("ruxslk02",FALSE)    #項次不可錄入 
           LET g_b_flag = '1'   #FUN-D30033 add

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET g_success = 'Y'
           CALL s_settext_slk(g_ruxslk[l_ac2].ruxslk03)
           CALL s_fillimx_slk(g_ruxslk[l_ac2].ruxslk03,
                                   g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
           LET g_rec_b3 = g_imx.getLength()
           SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_ruxslk[l_ac2].ruxslk03 AND ima01 IS NOT NULL
           IF l_ima151 ='Y' THEN
              CALL cl_set_comp_entry("ruxslk06",FALSE)
           ELSE
              CALL cl_set_comp_entry("ruxslk06",TRUE)
           END IF

           BEGIN WORK

           OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
           IF STATUS THEN
              CALL cl_err("OPEN t212_cl:", STATUS, 1)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
           
           FETCH t212_cl INTO g_ruw.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
    
           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u' 
              LET g_ruxslk_t.* = g_ruxslk[l_ac2].*  #BACKUP
              LET g_ruxslk_o.* = g_ruxslk[l_ac2].*  #BACKUP
              OPEN t212_bcl_slk USING g_ruw.ruw00,g_ruw.ruw01,g_ruxslk_t.ruxslk02
              IF STATUS THEN
                 CALL cl_err("OPEN t212_bcl_slk:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t212_bcl_slk INTO g_ruxslk[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ruxslk_t.ruxslk02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t212_ruxslk03()
              END IF
          END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ruxslk[l_ac2].* TO NULL
           LET g_ruxslk_t.* = g_ruxslk[l_ac2].*
           LET g_ruxslk_o.* = g_ruxslk[l_ac2].*
           CALL cl_set_comp_entry("ruxslk02,ruxslk03_desc,ruxslk04,ruxslk04_desc",FALSE)
           CALL cl_show_fld_cont()
           NEXT FIELD ruxslk02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_ruxslk[l_ac2].ruxslk06) THEN LET g_ruxslk[l_ac2].ruxslk06=0 END IF
           INSERT INTO ruxslk_file(ruxslk00,ruxslk01,ruxslk02,ruxslk03,ruxslk04,ruxslk06,
                                   ruxslk09,ruxslkplant,ruxslklegal)
           VALUES(g_ruw.ruw00,g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02,
                  g_ruxslk[l_ac2].ruxslk03,g_ruxslk[l_ac2].ruxslk04,
                  g_ruxslk[l_ac2].ruxslk06,g_ruxslk[l_ac2].ruxslk09,
                  g_ruw.ruwplant,g_ruw.ruwlegal)

           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","ruxslk_file",g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              CALL t212_ins_rux('a')      #插入非子母料件
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF

#       BEFORE FIELD ruxslk02
#          IF g_ruxslk[l_ac2].ruxslk02 IS NULL OR g_ruxslk[l_ac2].ruxslk02 = 0 THEN
#             SELECT max(ruxslk02)+1
#               INTO g_ruxslk[l_ac2].ruxslk02
#               FROM ruxslk_file
#              WHERE ruxslk01 = g_ruw.ruw01
#                AND ruxslk00 = g_ruw.ruw00
#             IF g_ruxslk[l_ac2].ruxslk02 IS NULL THEN
#                LET g_ruxslk[l_ac2].ruxslk02 = 1
#             END IF
#          END IF

#       AFTER FIELD ruxslk02
#          IF NOT cl_null(g_ruxslk[l_ac2].ruxslk02) THEN
#             IF g_ruxslk[l_ac2].ruxslk02 != g_ruxslk_t.ruxslk02
#                OR g_ruxslk_t.ruxslk02 IS NULL THEN
#                SELECT count(*)
#                  INTO l_n
#                  FROM ruxslk_file
#                 WHERE ruxslk01 = g_ruw.ruw01
#                   AND ruxslk02 = g_ruxslk[l_ac2].ruxslk02
#                   AND ruxslk00 = g_ruw.ruw00
#                IF l_n > 0 THEN
#                   CALL cl_err('',-239,0)
#                   LET g_ruxslk[l_ac2].ruxslk02 = g_ruxslk_t.ruxslk02
#                   NEXT FIELD ruxslk02
#                END IF
#             END IF
#          END IF

      BEFORE FIELD ruxslk03
         IF g_ruxslk[l_ac2].ruxslk02 IS NULL OR g_ruxslk[l_ac2].ruxslk02 = 0 THEN
              SELECT max(ruxslk02)+1
                INTO g_ruxslk[l_ac2].ruxslk02
                FROM ruxslk_file
               WHERE ruxslk01 = g_ruw.ruw01
                 AND ruxslk00 = g_ruw.ruw00 
              IF g_ruxslk[l_ac2].ruxslk02 IS NULL THEN
                 LET g_ruxslk[l_ac2].ruxslk02 = 1
              END IF
         END IF

     AFTER FIELD ruxslk03
           IF NOT cl_null(g_ruxslk[l_ac2].ruxslk03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_ruxslk[l_ac2].ruxslk03,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_ruxslk[l_ac2].ruxslk03= g_ruxslk_t.ruxslk03
                 NEXT FIELD ruxslk03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF s_joint_venture(g_ruxslk[l_ac2].ruxslk03,'') OR NOT s_internal_item(g_ruxslk[l_ac2].ruxslk03,'') THEN
                 LET g_ruxslk[l_ac2].ruxslk03= g_ruxslk_t.ruxslk03
                 NEXT FIELD ruxslk03
              END IF
#FUN-B90103----add-----------begin---------------
              SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                                        WHERE ima01=g_ruxslk[l_ac2].ruxslk03
                                          AND imaacti='Y'

               IF l_ima151='N' AND l_imaag='@CHILD' THEN  #FUN-C20006--Modify
                  CALL cl_err('','axm1104',1)
                  NEXT FIELD ruxslk03 
              END IF
              SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_ruxslk[l_ac2].ruxslk03
              IF l_ima151='Y' THEN
                 CALL cl_set_comp_entry("ruxslk06",FALSE)
              ELSE
                 CALL cl_set_comp_entry("ruxslk06",TRUE)
              END IF   
#FUN-B90103--------end---------------------------
              IF g_ruxslk_o.ruxslk03 IS NULL OR
                 (g_ruxslk[l_ac2].ruxslk03 != g_ruxslk_o.ruxslk03 ) THEN
                 SELECT COUNT(*) INTO l_n FROM ruxslk_file WHERE ruxslk00 = g_ruw.ruw00
                    AND ruxslk01 = g_ruw.ruw01
                    AND ruxslk03 = g_ruxslk[l_ac2].ruxslk03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD ruxslk03
                 END IF
              END IF
                 CALL t212_ruxslk03()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ruxslk[l_ac2].ruxslk03,g_errno,0)
                    LET g_ruxslk[l_ac2].ruxslk03 = g_ruxslk_o.ruxslk03
                    DISPLAY BY NAME g_ruxslk[l_ac2].ruxslk03
                    NEXT FIELD ruxslk03
                 END IF
                 IF l_ima151='Y' THEN
                    CALL s_settext_slk(g_ruxslk[l_ac2].ruxslk03)
                    CALL s_fillimx_slk(g_ruxslk[l_ac2].ruxslk03,g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
                    LET g_rec_b3 = g_imx.getLength()
                 END IF
           END IF

     AFTER FIELD ruxslk06
           IF NOT cl_null(g_ruxslk[l_ac2].ruxslk06) THEN
              IF g_ruxslk[l_ac2].ruxslk06 < 0 THEN
                 CALL cl_err('','art-386',0)
                 NEXT FIELD ruxslk06
              END IF
           END IF

     BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_ruxslk_t.ruxslk02 > 0 AND g_ruxslk_t.ruxslk02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ruxslk_file
               WHERE ruxslk01 = g_ruw.ruw01
                 AND ruxslk02 = g_ruxslk_t.ruxslk02
                 AND ruxslk00 = g_ruw.ruw00
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ruxslk_file",g_ruw.ruw01,g_ruxslk_t.ruxslk02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
#-----------刪除子料件----------------FUN-B90103-add-
                DELETE FROM rux_file WHERE rux00=g_ruw.ruw00
                                       AND rux01=g_ruw.ruw01
                                       AND rux11s=g_ruxslk_t.ruxslk02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rux_file",g_ruw.ruw01,g_ruxslk_t.ruxslk02,SQLCA.sqlcode,"","",1) 
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF              
              CALL t212_rux06_sum()    
#------------FUN-B90103-----------end---------------
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
              CLOSE t212_bcl_slk
              ROLLBACK WORK
              EXIT DIALOG 
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ruxslk[l_ac2].ruxslk02,-263,1)
              LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
           ELSE
              UPDATE ruxslk_file SET ruxslk02=g_ruxslk[l_ac2].ruxslk02,
                                  ruxslk03=g_ruxslk[l_ac2].ruxslk03,
                                  ruxslk04=g_ruxslk[l_ac2].ruxslk04,
                                  ruxslk06=g_ruxslk[l_ac2].ruxslk06,
                                  ruxslk09=g_ruxslk[l_ac2].ruxslk09
               WHERE ruxslk01=g_ruw.ruw01
                 AND ruxslk02=g_ruxslk_t.ruxslk02
                 AND ruxslk00=g_ruw.ruw00
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ruxslk_file",g_ruw.ruw01,g_ruxslk_t.ruxslk02,SQLCA.sqlcode,"","",1)
                 LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
              ELSE

                 IF g_ruxslk[l_ac2].ruxslk03!=g_ruxslk_t.ruxslk03 AND NOT cl_null(g_ruxslk_t.ruxslk03) AND l_ima151='Y' THEN
                    DELETE FROM rux_file WHERE rux00=g_ruw.ruw00
                                           AND rux01=g_ruw.ruw01
                                           AND rux11s=g_ruxslk[l_ac2].ruxslk02
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("del","rux_file",g_ruw.ruw01,g_ruxslk_t.ruxslk02,SQLCA.sqlcode,"","",1)
                      LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
                   END IF 
                         
                 ELSE
                    IF l_ima151='Y' THEN
                       UPDATE rux_file SET rux04=g_ruxslk[l_ac2].ruxslk04,
                                           rux09=g_ruxslk[l_ac2].ruxslk09
                                          WHERE rux00=g_ruw.ruw00
                                            AND rux01=g_ruw.ruw01
                                            AND rux11s=g_ruxslk[l_ac2].ruxslk02 
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("upd","rux_file",g_ruw.ruw01,g_ruxslk_t.ruxslk02,SQLCA.sqlcode,"","",1)
                          LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
                       END IF                    
                    ELSE
                       CALL t212_ins_rux('u')   #更新子料件 
                    END IF
                 END IF        
             END IF
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ruxslk[l_ac2].* = g_ruxslk_t.*
              END IF
              CLOSE t212_bcl_slk
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           CLOSE t212_bcl_slk
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(ruxslk03)                                                 
                CALL q_sel_ima(FALSE,'q_ima01_slk',"",g_ruxslk[l_ac2].ruxslk03,"","","","","",'')   #開母料號和非子母料號 #TQC-C20348--addq_ima01_slk 
                            RETURNING g_ruxslk[l_ac2].ruxslk03                                         
                DISPLAY BY NAME g_ruxslk[l_ac2].ruxslk03
                CALL t212_ruxslk03()
                NEXT FIELD ruxslk03
              OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLO
           IF INFIELD(ruxslk02) AND l_ac2 > 1 THEN
              LET g_ruxslk[l_ac2].* = g_ruxslk[l_ac2-1].*
              LET g_ruxslk[l_ac2].ruxslk02 = g_rec_b2 + 1
              NEXT FIELD ruxslk02
           END IF
       
      END INPUT

   INPUT ARRAY g_imx FROM s_imx.*
             ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
          BEFORE INPUT
              LET li_a=TRUE                 #FUN-C60100 add
              IF g_rec_b3 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac3)
              END IF
              CALL cl_set_comp_required('color',TRUE)
              LET g_b_flag = '2'   #FUN-D30033 add

          BEFORE ROW  
             LET p_cmd3 = ''
             LET l_ac3 = ARR_CURR() 
             INITIALIZE g_imx_t.* TO NULL

             BEGIN WORK
                 
             OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
             IF STATUS THEN
                CALL cl_err("OPEN t212_cl:", STATUS, 1)
                CLOSE t212_cl
                ROLLBACK WORK
                RETURN
             END IF
             FETCH t212_cl INTO g_ruw.*               # 對DB鎖定
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
                CLOSE t212_cl
                ROLLBACK WORK
                RETURN
             END IF

             IF g_rec_b3 >= l_ac3 THEN
                LET p_cmd3='u'
                LET g_imx_t.* = g_imx[l_ac3].*
                LET l_lock_sw = 'N'
             END IF

           BEFORE INSERT
             LET p_cmd3='a'
             LET l_ac3 = ARR_CURR()
             INITIALIZE g_imx_t.* TO NULL

           AFTER FIELD color
              IF NOT cl_null(g_imx[l_ac3].color) THEN
                 IF NOT t212_check_color() THEN
                     LET g_imx[l_ac3].color=g_imx_t.color
                     NEXT FIELD color
                 END IF
             #TQC-C20348--add--begin--
                 IF p_cmd3 ='a' OR (g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL) THEN
                    IF NOT s_chk_color_strategy(l_ac3,g_ruxslk[l_ac2].ruxslk03) THEN
                       LET g_imx[l_ac3].color = g_imx_t.color
                       NEXT FIELD color
                    END IF
                 END IF
              #TQC-C20348--add--end--
                 IF g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL THEN
                      CALL s_updcolor_slk(l_ac3,g_ruxslk[l_ac2].ruxslk03,
                                  g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
                 END IF
              END IF

           AFTER FIELD imx01
              IF NOT cl_null(g_imx[l_ac3].imx01) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx01 !=g_imx_t.imx01 AND g_imx_t.imx01 IS NOT NULL) THEN
                    IF NOT t212_check_imx(1,g_imx[l_ac3].imx01,g_imx_t.imx01) THEN
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                       NEXT FIELD imx01
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,1,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx01) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                       NEXT FIELD imx01
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx02
              IF NOT cl_null(g_imx[l_ac3].imx02) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx02 !=g_imx_t.imx02 AND g_imx_t.imx02 IS NOT NULL) THEN
                    IF NOT t212_check_imx(2,g_imx[l_ac3].imx02,g_imx_t.imx02) THEN
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,2,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx02) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx03
              IF NOT cl_null(g_imx[l_ac3].imx03) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx03 !=g_imx_t.imx03 AND g_imx_t.imx03 IS NOT NULL) THEN
                    IF NOT t212_check_imx(3,g_imx[l_ac3].imx03,g_imx_t.imx03) THEN
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                       NEXT FIELD imx03
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,3,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx03) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                       NEXT FIELD imx03
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx04
              IF NOT cl_null(g_imx[l_ac3].imx04) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx04 !=g_imx_t.imx04 AND g_imx_t.imx04 IS NOT NULL) THEN
                     IF NOT t212_check_imx(4,g_imx[l_ac3].imx04,g_imx_t.imx04) THEN
                        LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                        NEXT FIELD imx04
                     END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,4,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx04) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                       NEXT FIELD imx04
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx05
              IF NOT cl_null(g_imx[l_ac3].imx05) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx05 !=g_imx_t.imx05 AND g_imx_t.imx05 IS NOT NULL) THEN
                    IF NOT t212_check_imx(5,g_imx[l_ac3].imx05,g_imx_t.imx05) THEN
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,5,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx05) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx06
              IF NOT cl_null(g_imx[l_ac3].imx06) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx06 !=g_imx_t.imx06 AND g_imx_t.imx06 IS NOT NULL) THEN
                    IF NOT t212_check_imx(6,g_imx[l_ac3].imx06,g_imx_t.imx06) THEN
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,6,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx06) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx07
              IF NOT cl_null(g_imx[l_ac3].imx07) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx07 !=g_imx_t.imx07 AND g_imx_t.imx07 IS NOT NULL) THEN
                    IF NOT t212_check_imx(7,g_imx[l_ac3].imx07,g_imx_t.imx07) THEN
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,7,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx07) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx08
              IF NOT cl_null(g_imx[l_ac3].imx08) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx08 !=g_imx_t.imx08 AND g_imx_t.imx08 IS NOT NULL) THEN
                    IF NOT t212_check_imx(8,g_imx[l_ac3].imx08,g_imx_t.imx08) THEN
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,8,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx08) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx09
              IF NOT cl_null(g_imx[l_ac3].imx09) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx09 !=g_imx_t.imx09 AND g_imx_t.imx09 IS NOT NULL) THEN
                    IF NOT t212_check_imx(9,g_imx[l_ac3].imx09,g_imx_t.imx09) THEN
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                       NEXT FIELD imx09
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,9,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx09) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                       NEXT FIELD imx09
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx10
              IF NOT cl_null(g_imx[l_ac3].imx10) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx10 !=g_imx_t.imx10 AND g_imx_t.imx10 IS NOT NULL) THEN
                    IF NOT t212_check_imx(10,g_imx[l_ac3].imx10,g_imx_t.imx10) THEN
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                       NEXT FIELD imx10
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,10,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx10) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                       NEXT FIELD imx10
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx11
              IF NOT cl_null(g_imx[l_ac3].imx11) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx11 !=g_imx_t.imx11 AND g_imx_t.imx11 IS NOT NULL) THEN
                    IF NOT t212_check_imx(11,g_imx[l_ac3].imx11,g_imx_t.imx11) THEN
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,11,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx11) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx12
              IF NOT cl_null(g_imx[l_ac3].imx12) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx12 !=g_imx_t.imx12 AND g_imx_t.imx12 IS NOT NULL) THEN
                    IF NOT t212_check_imx(12,g_imx[l_ac3].imx12,g_imx_t.imx12) THEN
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,12,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx12) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx13
              IF NOT cl_null(g_imx[l_ac3].imx13) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx13 !=g_imx_t.imx13 AND g_imx_t.imx13 IS NOT NULL) THEN
                    IF NOT t212_check_imx(13,g_imx[l_ac3].imx13,g_imx_t.imx13) THEN
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                       NEXT FIELD imx13
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,13,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx13) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                       NEXT FIELD imx13
                    END IF
                 #TQC-C20348--add--end--
                    END IF
              END IF
           AFTER FIELD imx14
              IF NOT cl_null(g_imx[l_ac3].imx14) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx14 !=g_imx_t.imx14 AND g_imx_t.imx14 IS NOT NULL) THEN
                    IF NOT t212_check_imx(14,g_imx[l_ac3].imx14,g_imx_t.imx14) THEN
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                       NEXT FIELD imx14
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,14,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx14) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                       NEXT FIELD imx14
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx15
              IF NOT cl_null(g_imx[l_ac3].imx15) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx15 !=g_imx_t.imx15 AND g_imx_t.imx15 IS NOT NULL) THEN
                    IF NOT t212_check_imx(15,g_imx[l_ac3].imx15,g_imx_t.imx15) THEN
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,15,g_ruxslk[l_ac2].ruxslk03,g_imx[l_ac3].imx15) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF

           BEFORE DELETE
             IF NOT cl_null(g_imx_t.color) THEN    #TQC-C20348 add
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                CALL s_ins_slk('r',l_ac3,g_ruxslk[l_ac2].ruxslk03,
                               g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
                LET g_rec_b3=g_rec_b3-1
                CALL t212_update_ruxslk()  #將數量回寫
                IF g_success = 'Y' THEN
                    COMMIT WORK
                ELSE
                    ROLLBACK WORK
                END IF
             END IF   #TQC-C20348 add

           AFTER INSERT
#MOD-C30217------add---begin-----------------
              IF (g_imx[l_ac3].imx01 IS NULL OR g_imx[l_ac3].imx01 = 0) AND
                 (g_imx[l_ac3].imx02 IS NULL OR g_imx[l_ac3].imx02 = 0) AND
                 (g_imx[l_ac3].imx03 IS NULL OR g_imx[l_ac3].imx03 = 0) AND
                 (g_imx[l_ac3].imx04 IS NULL OR g_imx[l_ac3].imx04 = 0) AND
                 (g_imx[l_ac3].imx05 IS NULL OR g_imx[l_ac3].imx05 = 0) AND
                 (g_imx[l_ac3].imx06 IS NULL OR g_imx[l_ac3].imx06 = 0) AND
                 (g_imx[l_ac3].imx07 IS NULL OR g_imx[l_ac3].imx07 = 0) AND
                 (g_imx[l_ac3].imx08 IS NULL OR g_imx[l_ac3].imx08 = 0) AND
                 (g_imx[l_ac3].imx09 IS NULL OR g_imx[l_ac3].imx09 = 0) AND
                 (g_imx[l_ac3].imx10 IS NULL OR g_imx[l_ac3].imx10 = 0) AND
                 (g_imx[l_ac3].imx11 IS NULL OR g_imx[l_ac3].imx11 = 0) AND
                 (g_imx[l_ac3].imx12 IS NULL OR g_imx[l_ac3].imx12 = 0) AND
                 (g_imx[l_ac3].imx13 IS NULL OR g_imx[l_ac3].imx13 = 0) AND
                 (g_imx[l_ac3].imx14 IS NULL OR g_imx[l_ac3].imx14 = 0) AND
                 (g_imx[l_ac3].imx15 IS NULL OR g_imx[l_ac3].imx15 = 0)
              THEN
                  CANCEL INSERT
              END IF
#MOD-C30217------end-------------------------
              CALL t212_rux_default()   #對rux_file表初始化
              CALL s_ins_slk('a',l_ac3,g_ruxslk[l_ac2].ruxslk03,
                            g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
              LET g_rec_b3=g_rec_b3+1
              CALL t212_update_ruxslk()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF

           ON ROW CHANGE
              CALL t212_rux_default()   #對rux_file表初始化
              CALL s_ins_slk('u',l_ac3,g_ruxslk[l_ac2].ruxslk03,
                            g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02)
              CALL t212_update_ruxslk()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF

           AFTER ROW
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
              CLOSE t212_cl

           AFTER INPUT
              IF INT_FLAG THEN                        
                 LET INT_FLAG = 0
                 EXIT DIALOG
              END IF
              CALL t212_b_fill(" 1=1"," 1=1")
              CALL t212_b_fill2(" 1=1"," 1=1")
        END INPUT 

      #FUN-D30033--add--begin--- 
        BEFORE DIALOG
           CASE g_b_flag
              WHEN '1' NEXT FIELD ruxslk02
              WHEN '2' NEXT FIELD color 
           END CASE
      #FUN-D30033--add--end---
 
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
         CONTINUE DIALOG  

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
      ON ACTION ACCEPT
          ACCEPT DIALOG

      ON ACTION CANCEL
         #FUN-D30033--add--begin---
         IF p_cmd = 'a' THEN
            CALL g_ruxslk.deleteElement(l_ac2)
            IF g_b_flag = '1' AND g_rec_b2 != 0 THEN
               LET g_action_choice = "detail"
            END IF
         END IF
         IF p_cmd3 = 'a' THEN
            CALL g_imx.deleteElement(l_ac3)
            IF g_b_flag = '2' AND g_rec_b3 != 0 THEN
               LET g_action_choice = "detail"
            END IF
         END IF 
         #FUN-D30033--add--end---
          EXIT DIALOG
      ON ACTION controlb
        SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_ruxslk[l_ac2].ruxslk03
        IF l_ima151 = 'Y' THEN
           IF li_a THEN
#              LET li_a = FALSE     #FUN-C60100---MARK----
              NEXT FIELD ruxslk03
           ELSE
#              LET li_a = TRUE      #FUN-C60100----MARK---
              NEXT FIELD color 
           END IF
        END IF 

 END DIALOG
ELSE
#FUN-B90103-------------end-----------------
    INPUT ARRAY g_rux WITHOUT DEFAULTS FROM s_rux.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
           IF STATUS THEN
              CALL cl_err("OPEN t212_cl:", STATUS, 1)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t212_cl INTO g_ruw.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rux_t.* = g_rux[l_ac].*  #BACKUP
              LET g_rux_o.* = g_rux[l_ac].*  #BACKUP
              OPEN t212_bcl USING g_ruw.ruw00,g_ruw.ruw01,g_rux_t.rux02
              IF STATUS THEN
                 CALL cl_err("OPEN t212_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t212_bcl INTO g_rux[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rux_t.rux02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t212_rux03() 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rux[l_ac].* TO NULL
           LET g_rux[l_ac].rux05 = 0                   #TQC-AB0290 add
           LET g_rux[l_ac].rux07 = 0               #Body default
           LET g_rux_t.* = g_rux[l_ac].*
           LET g_rux_o.* = g_rux[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rux02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rux_file(rux00,rux01,rux02,rux03,rux04,rux05,rux06,
                                rux07,rux08,rux09,ruxplant,ruxlegal)
           VALUES(g_ruw.ruw00,g_ruw.ruw01,g_rux[l_ac].rux02,
                  g_rux[l_ac].rux03,g_rux[l_ac].rux04,
                  g_rux[l_ac].rux05,g_rux[l_ac].rux06,
                  g_rux[l_ac].rux07,g_rux[l_ac].rux08,
                  g_rux[l_ac].rux09,g_ruw.ruwplant,g_ruw.ruwlegal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rux_file",g_ruw.ruw01,g_rux[l_ac].rux02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rux02
           IF g_rux[l_ac].rux02 IS NULL OR g_rux[l_ac].rux02 = 0 THEN
              SELECT max(rux02)+1
                INTO g_rux[l_ac].rux02
                FROM rux_file
               WHERE rux01 = g_ruw.ruw01
                 AND rux00 = g_ruw.ruw00
              IF g_rux[l_ac].rux02 IS NULL THEN
                 LET g_rux[l_ac].rux02 = 1
              END IF
           END IF
 
        AFTER FIELD rux02
           IF NOT cl_null(g_rux[l_ac].rux02) THEN
              IF g_rux[l_ac].rux02 != g_rux_t.rux02
                 OR g_rux_t.rux02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rux_file
                  WHERE rux01 = g_ruw.ruw01
                    AND rux02 = g_rux[l_ac].rux02
                    AND rux00 = g_ruw.ruw00
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rux[l_ac].rux02 = g_rux_t.rux02
                    NEXT FIELD rux02
                 END IF 
              END IF
           END IF
        AFTER FIELD rux03
           IF NOT cl_null(g_rux[l_ac].rux03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rux[l_ac].rux03,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rux[l_ac].rux03= g_rux_t.rux03
                 NEXT FIELD rux03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
             #FUN-B40062 Begin---
              IF s_joint_venture(g_rux[l_ac].rux03,'') OR NOT s_internal_item(g_rux[l_ac].rux03,'') THEN
                 LET g_rux[l_ac].rux03= g_rux_t.rux03
                 NEXT FIELD rux03
              END IF
             #FUN-B40062 End-----
              IF g_rux_o.rux03 IS NULL OR
                 (g_rux[l_ac].rux03 != g_rux_o.rux03 ) THEN
                 SELECT COUNT(*) INTO l_n FROM rux_file WHERE rux00 = g_ruw.ruw00
                    AND rux01 = g_ruw.ruw01 
                    AND rux03 = g_rux[l_ac].rux03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD rux03
                 END IF
                 CALL t212_rux03()          
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rux[l_ac].rux03,g_errno,0)
                    LET g_rux[l_ac].rux03 = g_rux_o.rux03
                    DISPLAY BY NAME g_rux[l_ac].rux03
                    NEXT FIELD rux03
                 END IF
                 #檢查商品是否在商品策略中
                 IF NOT cl_null(l_rtz04) THEN
                    SELECT COUNT(*) INTO l_n FROM rte_file 
                       WHERE rte01 = l_rtz04 AND rte03 = g_rux[l_ac].rux03
                    IF l_n = 0 OR l_n IS NULL THEN
                       CALL cl_err('','art-389',0)
                       NEXT FIELD rux03
                    END IF
                 END IF
                 IF NOT cl_null(g_rux[l_ac].rux05) AND NOT cl_null(g_rux[l_ac].rux06)
                    AND NOT cl_null(g_rux[l_ac].rux07) THEN
                    LET g_rux[l_ac].rux08 = g_rux[l_ac].rux06+g_rux[l_ac].rux07 -g_rux[l_ac].rux05 #bnl -090204
                 END IF
              END IF
           END IF
           
        AFTER FIELD rux06
           IF NOT cl_null(g_rux[l_ac].rux06) THEN
              LET g_rux[l_ac].rux06 = s_digqty(g_rux[l_ac].rux06,g_rux[l_ac].rux04)   #FUN-910088--add--
              DISPLAY BY NAME g_rux[l_ac].rux06                #FUN-910088-add--
              IF g_rux[l_ac].rux06 < 0 THEN
                 CALL cl_err('','art-386',0)
                 NEXT FIELD rux06                
              END IF
              IF NOT cl_null(g_rux[l_ac].rux05) AND NOT cl_null(g_rux[l_ac].rux06)
                 AND NOT cl_null(g_rux[l_ac].rux07) THEN
                 LET g_rux[l_ac].rux08 = g_rux[l_ac].rux06+g_rux[l_ac].rux07 -g_rux[l_ac].rux05 #bnl -090204
              END IF
           END IF
        
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rux_t.rux02 > 0 AND g_rux_t.rux02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rux_file
               WHERE rux01 = g_ruw.ruw01
                 AND rux02 = g_rux_t.rux02
                 AND rux00 = g_ruw.ruw00
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rux_file",g_ruw.ruw01,g_rux_t.rux02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
           
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rux[l_ac].* = g_rux_t.*
              CLOSE t212_bcl
              ROLLBACK WORK
              EXIT INPUT   
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rux[l_ac].rux02,-263,1)
              LET g_rux[l_ac].* = g_rux_t.*
           ELSE
              UPDATE rux_file SET rux02=g_rux[l_ac].rux02,
                                  rux03=g_rux[l_ac].rux03,
                                  rux04=g_rux[l_ac].rux04,
                                  rux05=g_rux[l_ac].rux05,
                                  rux06=g_rux[l_ac].rux06,
                                  rux07=g_rux[l_ac].rux07,
                                  rux08=g_rux[l_ac].rux08,
                                  rux09=g_rux[l_ac].rux09
               WHERE rux01=g_ruw.ruw01
                 AND rux02=g_rux_t.rux02
                 AND rux00=g_ruw.ruw00
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rux_file",g_ruw.ruw01,g_rux_t.rux02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rux[l_ac].* = g_rux_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
        
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rux[l_ac].* = g_rux_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rux.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t212_bcl
              ROLLBACK WORK
              EXIT INPUT  
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t212_bcl
           COMMIT WORK
           
        ON ACTION CONTROLO
           IF INFIELD(rux02) AND l_ac > 1 THEN
              LET g_rux[l_ac].* = g_rux[l_ac-1].*
              LET g_rux[l_ac].rux02 = g_rec_b + 1
              NEXT FIELD rux02
           END IF 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION controlp
           CASE
              WHEN INFIELD(rux03)
#FUN-AA0059---------mod------------str-----------------
      #           CALL cl_init_qry_var()                                                     #FUN-AA0059 mark
                  IF cl_null(l_rtz04) THEN
      #              LET g_qryparam.form = "q_ima"                                           #FUN-AA0059 mark
                     CALL q_sel_ima(FALSE,'q_ima',"",g_rux[l_ac].rux03,"","","","","",'') #FUN-AA0059 add
                         RETURNING g_rux[l_ac].rux03                                         #FUN-AA0059 add 
                  ELSE
               	    SELECT rus07,rus09,rus11,rus13 
                      INTO l_rus07,l_rus09,l_rus11,l_rus13
                      FROM rus_file 
                      WHERE rus01 = g_ruw.ruw02 
                    CALL t212_get_shop(l_rus07,l_rus09,l_rus11,l_rus13)
                       RETURNING l_flag
                   IF l_flag = 0 THEN
                        CALL cl_init_qry_var()                              #FUN-AA0059 add 
                        LET g_qryparam.form = "q_rte03"  
                        LET g_qryparam.arg1 = l_rtz04 
                        LET g_qryparam.default1 = g_rux[l_ac].rux03                 
                        CALL cl_create_qry() RETURNING g_rux[l_ac].rux03    #FUN-AA0059 add
                    ELSE
#FUN-AA0059 mark
#                      LET g_qryparam.where = " ima01 IN ('"
#                      FOR l_i = 1 TO g_result.getLength()
#                        LET g_qryparam.where = g_qryparam.where,g_result[l_i],"','"
#                      END FOR
#                      LET l_temp = g_qryparam.where
#                      LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
#                      LET g_qryparam.where = g_qryparam.where,")"
#                      LET g_qryparam.form = "q_ima" 
#                      LET g_qryparam.where = g_qryparam.where," AND ima01 IN (SELECT ",
#                                             " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "
#FUN-AA0059 mark
#FUN-AA0059 add
                       LET l_sql = " ima01 IN ('"
                       FOR l_i = 1 TO g_result.getLength()
                         LET l_sql  = l_sql,g_result[l_i],"','"
                       END FOR
                       LET l_temp = l_sql
                       LET l_sql = l_temp[1,l_sql.getLength()-2]
                       LET l_sql = l_sql,")"
                       LET l_sql = l_sql," AND ima01 IN (SELECT ",
                                              " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "
                       CALL q_sel_ima(FALSE,'q_ima',l_sql,g_rux[l_ac].rux03,"","","","","",'') #FUN-AA0059 add
                         RETURNING g_rux[l_ac].rux03                                                      #FUN-AA0059 add
#FUN-AA0059 add
                    END IF
                 END IF                       
       #          LET g_qryparam.default1 = g_rux[l_ac].rux03                 #FUN-AA0059 mark
       #          CALL cl_create_qry() RETURNING g_rux[l_ac].rux03            #FUN-AA0059 mark     
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_rux[l_ac].rux03
                 CALL t212_rux03()
                 NEXT FIELD rux03
              OTHERWISE EXIT CASE
            END CASE
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT  
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
   END INPUT  
 END IF  #FUN-B90103--add
   IF p_cmd = 'u' THEN
      UPDATE ruw_file SET ruwmodu = g_ruw.ruwmodu,ruwdate = g_ruw.ruwdate
         WHERE ruw01 = g_ruw.ruw01 AND rwx00 = g_ruw.ruw00 
     
      DISPLAY BY NAME g_ruw.ruwmodu,g_ruw.ruwdate
   END IF 
   CLOSE t212_bcl
#FUN-B90103----add----------------
IF s_industry("slk") AND g_argv1 = '1' THEN
   CLOSE t212_bcl_slk  
END IF
#FUN-B90103----end----------------
   COMMIT WORK
#  CALL t212_delall()  #CHI-C30002 mark
#FUN-B90103----add----------------
   CALL t212_delHeader()     #CHI-C30002 add
IF s_industry("slk") AND g_argv1 = '1' THEN
   CALL t212_show()  
END IF
#FUN-B90103----end----------------
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t212_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
IF s_industry("slk") AND g_argv1 = '1' THEN
   SELECT COUNT(*) INTO g_cnt FROM ruxslk_file
    WHERE ruxslk01 = g_ruw.ruw01
      AND ruxslk00 = g_ruw.ruw00
ELSE
   SELECT COUNT(*) INTO g_cnt FROM rux_file
    WHERE rux01 = g_ruw.ruw01
      AND rux00 = g_ruw.ruw00
END IF
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruw.ruw01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruw_file ",
                  "  WHERE ruw01 LIKE '",l_slip,"%' ",
                  "    AND ruw01 > '",g_ruw.ruw01,"'"
      PREPARE t212_pb4 FROM l_sql 
      EXECUTE t212_pb4 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t212_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruw_file WHERE ruw01 = g_ruw.ruw01
                                AND ruw00 = g_ruw.ruw00
         INITIALIZE g_ruw.* TO NULL
         CLEAR FORM
      END IF
   ELSE
      IF g_argv1 = "1" THEN
         UPDATE rus_file SET rus900 = '2'
             WHERE rus01 = g_ruw.ruw02
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t212_delall()
#FUN-B90103--------add------
#IF s_industry("slk") AND g_argv1 = '1' THEN
#   SELECT COUNT(*) INTO g_cnt FROM ruxslk_file
#    WHERE ruxslk01 = g_ruw.ruw01
#      AND ruxslk00 = g_ruw.ruw00 
#ELSE
#   SELECT COUNT(*) INTO g_cnt FROM rux_file
#    WHERE rux01 = g_ruw.ruw01 
#      AND rux00 = g_ruw.ruw00 
#END IF
#FUN-B90103--------end-------
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruw_file WHERE ruw01 = g_ruw.ruw01
#        AND ruw00 = g_ruw.ruw00 
#  ELSE
#     IF g_argv1 = "1" THEN
#        UPDATE rus_file SET rus900 = '2' 
#            WHERE rus01 = g_ruw.ruw02
#     END IF
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t212_b_fill(p_wc2,p_wc3)
DEFINE p_wc2   STRING
DEFINE p_wc3   STRING

  IF cl_null(p_wc2) THEN LET p_wc2=" 1=1" END IF
  IF cl_null(p_wc3) THEN LET p_wc3=" 1=1" END IF

#FUN-B90103--------------add----------------
IF s_industry("slk") AND g_argv1 = '1' THEN
   LET g_sql = "SELECT DISTINCT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
               "  FROM rux_file,ruxslk_file",
               " WHERE rux01 ='",g_ruw.ruw01,"' AND rux00 = '",g_ruw.ruw00,"'",
               "   AND ruxslk01=rux01 AND ruxslk00=rux00",
               "   AND rux11s=ruxslk02"      
ELSE
#FUN-B90103----------------end------------------
   LET g_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
               "  FROM rux_file",
               " WHERE rux01 ='",g_ruw.ruw01,"' AND rux00 = '",g_ruw.ruw00,"'"
END IF
#FUN-B90103---
#FUN-B90103-------------add-----------
IF NOT s_industry("slk") OR g_argv1 = '2' THEN
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
ELSE
      IF p_wc2 <> " 1=1" THEN
         LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
      END IF
      IF p_wc3 <> " 1=1" THEN
         LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
      END IF
END IF
#FUN-B90103-------------end-------------
   LET g_sql=g_sql CLIPPED," ORDER BY rux02 "
 
   DISPLAY g_sql
 
   PREPARE t212_pb FROM g_sql
   DECLARE rux_cs CURSOR FOR t212_pb
 
   CALL g_rux.clear()
   LET g_cnt = 1
 
   FOREACH rux_cs INTO g_rux[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rux[g_cnt].rux03_desc FROM ima_file
           WHERE ima01 = g_rux[g_cnt].rux03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rux[g_cnt].rux03,"",SQLCA.sqlcode,"","",0)  
          LET g_rux[g_cnt].rux03_desc = NULL
       END IF
       SELECT gfe02 INTO g_rux[g_cnt].rux04_desc FROM gfe_file
          WHERE gfe01 = g_rux[g_cnt].rux04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rux.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

#FUN-B90103---------add----------
FUNCTION t212_b_fill2(p_wc2,p_wc3)
   DEFINE p_wc3 STRING
   DEFINE p_wc2 STRING

   IF cl_null(p_wc2) THEN LET p_wc2=" 1=1" END IF
   IF cl_null(p_wc3) THEN LET p_wc3=" 1=1" END IF
   IF cl_null(p_wc2) OR p_wc2=" 1=1" THEN
      LET g_sql = "SELECT DISTINCT ruxslk02,ruxslk03,'',ruxslk04,'',ruxslk06,ruxslk09 ",
                  "  FROM ruxslk_file",
                  " WHERE ruxslk01 ='",g_ruw.ruw01,"' AND ruxslk00 = '",g_ruw.ruw00,"'",
                  "   AND ",p_wc3 CLIPPED,
                  " ORDER BY ruxslk02"
   ELSE
      LET g_sql = "SELECT DISTINCT ruxslk02,ruxslk03,'',ruxslk04,'',ruxslk06,ruxslk09 ",
                  "  FROM ruxslk_file,rux_file",
                  " WHERE ruxslk01 ='",g_ruw.ruw01,"' AND ruxslk00 = '",g_ruw.ruw00,"'",
                  "   AND ruxslk00=rux00 AND ruxslk01=rux01",
                  "   AND rux11s=ruxslk02",
                  "   AND ",p_wc2 CLIPPED,
                  "   AND ",p_wc3 CLIPPED,
                  " ORDER BY ruxslk02"
   END IF

   PREPARE t212_pb_slk FROM g_sql
   DECLARE rux_cs_slk CURSOR FOR t212_pb_slk

   CALL g_ruxslk.clear()
   LET g_cnt = 1

   FOREACH rux_cs_slk INTO g_ruxslk[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT ima02 INTO g_ruxslk[g_cnt].ruxslk03_desc FROM ima_file
           WHERE ima01 = g_ruxslk[g_cnt].ruxslk03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_ruxslk[g_cnt].ruxslk03,"",SQLCA.sqlcode,"","",0)
          LET g_ruxslk[g_cnt].ruxslk03_desc = NULL
       END IF
       SELECT gfe02 INTO g_ruxslk[g_cnt].ruxslk04_desc FROM gfe_file
          WHERE gfe01 = g_ruxslk[g_cnt].ruxslk04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ruxslk.deleteElement(g_cnt)

   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION
#FUN-B90103------end-------------
 
FUNCTION t212_get_shop(p_sort,p_sign,p_factory,p_shop)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE p_sort          LIKE rus_file.rus07
DEFINE p_sign          LIKE rus_file.rus09
DEFINE p_factory       LIKE rus_file.rus11
DEFINE p_shop          LIKE rus_file.rus13
 
   LET g_errno = ''
   
   IF cl_null(p_sort) AND cl_null(p_sign)
      AND cl_null(p_factory) AND cl_null(p_shop) THEN
      RETURN 0
   END IF

#FUN-9B0068 --begin-- 
#   CREATE TEMP TABLE sort(ima01 varchar(40))
#   CREATE TEMP TABLE sign(ima01 varchar(40))
#   CREATE TEMP TABLE factory(ima01 varchar(40))
#   CREATE TEMP TABLE no(ima01 varchar(40))
   CREATE TEMP TABLE sort(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE sign(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE factory(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE no(
             ima01   LIKE ima_file.ima01)
#FUN-9B0068 --end-- 
   CALL t210_get_sort(p_sort)
   CALL t210_get_sign(p_sign)
   CALL t210_get_factory(p_factory)
   CALL t210_get_no(p_shop)
 
   SELECT count(*) INTO l_n1 FROM sort
   SELECT count(*) INTO l_n2 FROM sign
   SELECT count(*) INTO l_n3 FROM factory
   SELECT count(*) INTO l_n4 FROM no
  
   CALL g_result.clear()
 
   IF l_n1 != 0 THEN
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
                           " AND C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
            END IF
         ELSE                     
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
                           " WHERE A.ima01 = B.ima01 "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
                           " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
                           " WHERE A.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
                           " WHERE A.ima01 = D.ima01"
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A "
            END IF
         END IF
      END IF
   ELSE
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
                           " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 " 
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
                           " WHERE B.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
                           " WHERE B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
                           " WHERE C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT C.ima01 FROM factory C "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT D.ima01 FROM no D "
            END IF
         END IF
      END IF
   END IF
   
   IF l_sql IS NULL THEN RETURN 0 END IF
   PREPARE t212_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR t212_get_pb
   LET g_cnt = 1
   FOREACH rus_get_cs1 INTO g_result[g_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_result.deleteElement(g_cnt)
 
   DROP TABLE sort
   DROP TABLE sign
   DROP TABLE factory
   DROP TABLE no
 
   IF g_result.getLength() = 0 THEN
      RETURN -1
   ELSE
      IF cl_null(g_result[1]) THEN
         RETURN -1
      END IF
      RETURN 1
   END IF
END FUNCTION
FUNCTION t210_get_sort(p_sort)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_sort          LIKE rus_file.rus07
 
    CALL g_sort.clear()
                                                                                                     
    IF NOT cl_null(p_sort) THEN
       LET tok = base.StringTokenizer.createExt(p_sort,"|",'',TRUE)
       LET g_cnt = 1
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
          LET g_sql = "SELECT ima01 FROM ima_file WHERE ima131 = '",l_ck,"'"  
          PREPARE t212_pb1 FROM g_sql
          DECLARE rus_cs1 CURSOR FOR t212_pb1
          FOREACH rus_cs1 INTO g_sort[g_cnt]
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             INSERT INTO sort VALUES(g_sort[g_cnt])
             LET g_cnt = g_cnt + 1
          END FOREACH
       END WHILE
       CALL g_sort.deleteElement(g_cnt)
    END IF
END FUNCTION
FUNCTION t210_get_sign(p_sign)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_sign          LIKE rus_file.rus09
 
   CALL g_sign.clear()
   IF NOT cl_null(p_sign) THEN
      LET tok = base.StringTokenizer.createExt(p_sign,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()                                                                                              
         LET g_sql = "SELECT ima01 FROM ima_file WHERE ima1005 = '",l_ck,"'"
         PREPARE t212_pb2 FROM g_sql
         DECLARE rus_cs2 CURSOR FOR t212_pb2
         FOREACH rus_cs2 INTO g_sign[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO sign VALUES(g_sign[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_sign.deleteElement(g_cnt)
   END IF   
END FUNCTION
FUNCTION t210_get_factory(p_factory)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_factory       LIKE rus_file.rus11
   
   CALL g_factory.clear()
   IF NOT cl_null(p_factory) THEN
      LET tok = base.StringTokenizer.createExt(p_factory,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()                                                                                               
         LET g_sql = "SELECT rty02 FROM rty_file ",
                    #" WHERE rty05 = '",l_ck,"' AND rty01 = '",g_ruw.ruwplant,"'"  #TQC-C90123 Mark
                     " WHERE rty05 = '",l_ck,"' AND rty01 = '",g_plant,"'"         #TQC-C90123 Add
         PREPARE t212_pb3 FROM g_sql
         DECLARE rus_cs3 CURSOR FOR t212_pb3
         FOREACH rus_cs3 INTO g_factory[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO factory VALUES(g_factory[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_factory.deleteElement(g_cnt)
   END IF
END FUNCTION
FUNCTION t210_get_no(p_shop)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_shop       LIKE rus_file.rus13  
 
   CALL g_no.clear()
   IF NOT cl_null(p_shop) THEN
      LET tok = base.StringTokenizer.createExt(p_shop,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         LET g_no[g_cnt] = l_ck
         INSERT INTO no VALUES(g_no[g_cnt]) 
         LET g_cnt = g_cnt + 1
      END WHILE
      CALL g_sort.deleteElement(g_cnt)
   END IF
END FUNCTION
 
FUNCTION t212_copy()
   DEFINE l_newno     LIKE ruw_file.ruw01,
          l_oldno     LIKE ruw_file.ruw01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruw.ruw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t212_set_entry('a')
   CALL cl_set_docno_format("ruw01")
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruw01
 
       AFTER FIELD ruw01
          IF l_newno IS NULL THEN                                                                                                  
              NEXT FIELD ruw01                                                                                                      
           ELSE                                                                                                                    
              IF g_ruw.ruw00 = '1' THEN
#                CALL s_check_no("art",l_newno,"","J","ruw_file","ruw01","")  #FUN-A70130 mark                                                         
                 CALL s_check_no("art",l_newno,"","J4","ruw_file","ruw01","")  #FUN-A70130 mod                                                          
                    RETURNING li_result,l_newno
              ELSE
#                CALL s_check_no("art",l_newno,"","L","ruw_file","ruw01","")  #FUN-A70130 mark
                 CALL s_check_no("art",l_newno,"","J5","ruw_file","ruw01","")  #FUN-A70130 mod
                    RETURNING li_result,l_newno
              END IF                                                                                
              IF (NOT li_result) THEN                                                                                               
                 LET g_ruw.ruw01=g_ruw_t.ruw01                                                                                      
                 NEXT FIELD ruw01                                                                                                   
              END IF                                                                                                                
              BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("art",l_newno,g_today,"","rus_file","rus01","","","")  #FUN-A70130 mark                                         
              CALL s_auto_assign_no("art",l_newno,g_today,"D5","rus_file","rus01","","","")  #FUN-A70130 mod                                         
                 RETURNING li_result,l_newno                                                                                        
              IF (NOT li_result) THEN                                                                                               
                 ROLLBACK WORK                                                                                                      
                 NEXT FIELD ruw01                                                                                                   
              ELSE                                                                                                                  
                 COMMIT WORK                                                                                                        
              END IF                                                                                                                
           END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION controlp
         CASE  
            WHEN INFIELD(ruw01) 
               LET g_t1=s_get_doc_no(g_ruw.ruw01) 
               IF g_argv1 = '1' THEN
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','J') RETURNING g_t1   #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J4','ART') RETURNING g_t1  #FUN-A70130--mod--
               ELSE                                                
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','L') RETURNING g_t1   #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J5','ART') RETURNING g_t1  #FUN-A70130--mod--
               END IF        
               LET l_newno = g_t1 
               DISPLAY l_newno TO ruw01
               NEXT FIELD ruw01
        END CASE
     ON ACTION about
        CALL cl_about()
 
     ON ACTION HELP
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_ruw.ruw01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
       INTO TEMP y
 
   UPDATE y
       SET ruw01=l_newno,
           ruwconf = 'N',
           ruwcond = NULL,
           ruwconu = NULL,
           ruwuser=g_user,
           ruwgrup=g_grup,
           ruworiu=g_user,         #TQC-A30050 ADD
           ruworig=g_grup,         #TQC-A30050 ADD
           ruwmodu=NULL,
           ruwdate=g_today,
           ruwacti='Y',
           ruwcrat=g_today,
           ruwmksg = 'N',
           ruw900 = '0',
           ruwplant = g_plant,
           ruwlegal = g_legal,
           ruw08 = 'N',
           ruwcont = '',           #FUN-870100
           #ruwpos = 'N'           #FUN-870100
           ruwpos = '1'           #FUN-B50042
 
   INSERT INTO ruw_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
#FUN-B90103-----add----begin----
IF s_industry("slk") AND g_argv1 = '1' THEN
   DROP TABLE x
  SELECT * FROM ruxslk_file
       WHERE ruxslk01=g_ruw.ruw01 AND ruxslk00=g_ruw.ruw00  
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET ruxslk01=l_newno,ruxslkplant=g_plant,ruxslklegal=g_legal

   INSERT INTO ruxslk_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruxslk_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK          
      RETURN
   END IF

END IF
#FUN-B90103-----end------------- 
   DROP TABLE x
 
   SELECT * FROM rux_file
       WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rux01=l_newno,ruxplant=g_plant,ruxlegal=g_legal
 
   INSERT INTO rux_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     ROLLBACK WORK            #TQC-B80044
      CALL cl_err3("ins","rux_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK            #TQC-B80044
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruw.ruw01
   SELECT ruw_file.* INTO g_ruw.* 
      FROM ruw_file 
      WHERE ruw01 = l_newno AND ruw00 = g_ruw.ruw00
   CALL t212_u()
   CALL t212_b()
   #FUN-C80046---begin
   #SELECT ruw_file.* INTO g_ruw.* 
   #   FROM ruw_file 
   #   WHERE ruw01 = l_oldno AND ruw00 = g_ruw.ruw00
   #CALL t212_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t212_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_ruw.ruw01 IS NOT NULL THEN
       LET g_wc = "ruw01='",g_ruw.ruw01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt212" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t212_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ruw01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t212_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ruw01",FALSE)
    END IF
END FUNCTION

#FUN-B90103-----add----
FUNCTION t212_check_imx(p_index,p_qty,p_qty_t)
 DEFINE p_index     LIKE type_file.num5,
          p_qty       LIKE pmn_file.pmn20,
          p_qty_t     LIKE pmn_file.pmn20

    IF cl_null(g_ruxslk[l_ac2].ruxslk03)  THEN
       RETURN FALSE
    END IF

#MOD-C30217---mark----
#   IF p_qty<0 THEN
#      RETURN FALSE
#   END IF
#MOD-C30217---end------

    RETURN TRUE
END FUNCTION

#將數量回到ruxslk06--------------------
FUNCTION t212_update_ruxslk()
  DEFINE l_sum_rux06  LIKE rux_file.rux06

  SELECT SUM(rux06) INTO l_sum_rux06 FROM rux_file WHERE rux00=g_ruw.ruw00
                                                     AND rux01=g_ruw.ruw01
                                                     AND rux11s=g_ruxslk[l_ac2].ruxslk02   #款號項次
   IF SQLCA.sqlcode OR cl_null(l_sum_rux06) THEN 
      LET l_sum_rux06 = 0 
   END IF
  UPDATE ruxslk_file SET ruxslk06=l_sum_rux06 WHERE ruxslk00=g_ruw.ruw00
                                                AND ruxslk01=g_ruw.ruw01
                                                AND ruxslk02=g_ruxslk[l_ac2].ruxslk02   #款號項次
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ruxslk_file",g_ruw.ruw01,g_ruxslk[l_ac2].ruxslk02,STATUS,"","x_upd ruxslk",1)
      LET g_success = 'N'
   END IF
   LET g_ruxslk[l_ac2].ruxslk06=l_sum_rux06
              
END FUNCTION

 FUNCTION t212_rux_default()

  LET g_rux_slk.rux00='1'
  LET g_rux_slk.rux01=g_ruw.ruw01
  LET g_rux_slk.rux04=g_ruxslk[l_ac2].ruxslk04 
  LET g_rux_slk.rux05=0
  LET g_rux_slk.rux07=0
  LET g_rux_slk.rux08=0
  LET g_rux_slk.rux09=g_ruxslk[l_ac2].ruxslk09
  LET g_rux_slk.rux10s=g_ruxslk[l_ac2].ruxslk03
  LET g_rux_slk.rux11s=g_ruxslk[l_ac2].ruxslk02
  LET g_rux_slk.ruxlegal=g_legal
  LET g_rux_slk.ruxplant=g_plant
 END FUNCTION

FUNCTION t212_ruxslk03()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.num5
DEFINE l_rus07   LIKE rus_file.rus07
DEFINE l_rus09   LIKE rus_file.rus09
DEFINE l_rus11   LIKE rus_file.rus11
DEFINE l_rus13   LIKE rus_file.rus13

   LET g_errno = ""

   SELECT ima02,imaacti,ima25,gfe02
      INTO g_ruxslk[l_ac2].ruxslk03_desc,l_imaacti,
           g_ruxslk[l_ac2].ruxslk04,g_ruxslk[l_ac2].ruxslk04_desc
      FROM ima_file,gfe_file
      WHERE ima01 = g_ruxslk[l_ac2].ruxslk03 AND gfe01 = ima25

   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_ruxslk[l_ac2].ruxslk03_desc TO FORMONLY.ruxslk03_desc
                           DISPLAY g_ruxslk[l_ac2].ruxslk04_desc TO FORMONLY.ruxslk04_desc
                           DISPLAY BY NAME g_ruxslk[l_ac2].ruxslk04

   END CASE

   IF cl_null(g_errno) THEN
      SELECT rtz04 INTO l_rtz04
         FROM rtz_file WHERE rtz01=g_ruw.ruwplant
      IF NOT cl_null(l_rtz04) THEN
         SELECT rus07,rus09,rus11,rus13
             INTO l_rus07,l_rus09,l_rus11,l_rus13
             FROM rus_file
             WHERE rus01 = g_ruw.ruw02
         CALL t212_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
         IF l_flag = 0 THEN
          # SELECT COUNT(*) INTO l_n FROM rte_file
          #    WHERE rte01 = l_rtz04 AND rte03 = g_ruxslk[l_ac2].ruxslk03
          # IF l_n = 0 OR l_n IS NULL THEN
          #    LET g_errno = 'art-054'
          # END IF
         ELSE
            FOR l_i=1 TO g_result.getLength()
               IF g_result[l_i] = g_ruxslk[l_ac2].ruxslk03 THEN
                  LET l_flag = 3
               END IF
            END FOR
            IF l_flag <> '3' THEN
               LET g_errno = 'art-387'
            END IF
         END IF
      END IF
   END IF

END FUNCTION

FUNCTION t212_ins_rux(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_rux    RECORD LIKE rux_file.*
 DEFINE l_rux2   RECORD LIKE rux_file.* 
 DEFINE l_n      LIKE type_file.num5
 DEFINE l_cnt    LIKE type_file.num5 
 SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_ruxslk[l_ac2].ruxslk03
                                          AND imaacti='Y'
                                          AND ( ima151 != 'N' OR imaag <> '@CHILD' OR imaag IS NULL)
                                          AND ima151 != 'Y'
  IF l_n >0 THEN
     LET l_rux.rux00=g_ruw.ruw00
     LET l_rux.rux01=g_ruw.ruw01
     SELECT MAX(rux02) INTO l_cnt FROM rux_file WHERE rux00=g_ruw.ruw00 AND rux01=g_ruw.ruw01
     IF cl_null(l_cnt) OR l_cnt=0 THEN
        LET l_rux.rux02=1
     ELSE
        LET l_rux.rux02=1+l_cnt 
     END IF
     LET l_rux.rux03=g_ruxslk[l_ac2].ruxslk03
     LET l_rux.rux04=g_ruxslk[l_ac2].ruxslk04
     LET l_rux.rux05=0
     LET l_rux.rux06=g_ruxslk[l_ac2].ruxslk06
     LET l_rux.rux07=0
     LET l_rux.rux08=0
     LET l_rux.rux09=g_ruxslk[l_ac2].ruxslk09
     LET l_rux.rux10s=g_ruxslk[l_ac2].ruxslk03
     LET l_rux.rux11s=g_ruxslk[l_ac2].ruxslk02
     LET l_rux.ruxlegal=g_legal
     LET l_rux.ruxplant=g_plant 
     IF p_cmd='a' THEN
        INSERT INTO rux_file VALUES(l_rux.*)
        IF STATUS THEN
           CALL cl_err3("ins","rux_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)
           RETURN
        END IF
     END IF
     IF p_cmd='u' THEN
        LET l_rux2.*=l_rux.*
        SELECT rux02 INTO l_rux2.rux02 FROM rux_file WHERE rux00=g_ruw.ruw00 
                                                       AND rux01=g_ruw.ruw01
                                                       AND rux11s=g_ruxslk[l_ac2].ruxslk02   #項次

        UPDATE rux_file SET *=l_rux2.* WHERE rux00=g_ruw.ruw00 AND rux01=g_ruw.ruw01 AND rux02=l_rux2.rux02
        IF STATUS THEN
           CALL cl_err3("upd","rux_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)
           RETURN
        END IF
     END IF
  END IF
END FUNCTION

FUNCTION t212_rux06_sum()
  DEFINE  l_qty    LIKE rux_file.rux06

   SELECT SUM(rux06) INTO l_qty FROM rux_file WHERE rux00=g_ruw.ruw00 AND rux01=g_ruw.ruw01
   DISPLAY l_qty TO FORMONLY.qty  
END FUNCTION 

#不允許顏色重複
FUNCTION t212_check_color()
  DEFINE l_i        LIKE type_file.num5
  DEFINE l_flag     LIKE type_file.chr1

    FOR l_i=1 TO g_imx.getLength()
      IF g_imx[l_i].color=g_imx[l_ac3].color AND l_i<>l_ac3 THEN
         LET l_flag='N'
         EXIT FOR
      END IF
    END FOR
    IF l_flag='N' THEN
       CALL cl_err('',1120,0)
       RETURN FALSE
    END IF
    RETURN TRUE

END FUNCTION
#FUN-B90103-----end----

#FUN-B60118 ADD
#FUN-960130
