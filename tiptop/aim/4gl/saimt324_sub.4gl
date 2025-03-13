# Prog. Version..: '5.30.06-13.04.24(00010)'     #
#
# Pattern name...: saimt324_sub.4gl
# Descriptions...: 將原aimt324.4gl確認段拆解至aimt324_sub.4gl中
# Date & Author..: #FUN-A60034 11/03/07 By Mandy
# Modify.........: No.TQC-B50032 11/05/18 By destiny 审核时不存在的部门可以通过 
# Modify.........: No.FUN-BC0036 11/12/19 By jasin 由aimt324_sub.4gl改為saimt324_sub.4gl
                                                   #增加刻號/BIN確認前檢查s_icdchk  
# Modify.........: No.MOD-C20209 12/02/29 By Elise 有table lock時執行確認時不會有錯誤訊息，程式會直接關掉，324sub_y_chk、324sub_y_upd都加上WHENEVER ERROR CONTINUE
# Modify.........: No:CHI-C30106 12/04/06 By Elise 批序號維護
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段前
# Modify.........: No.CHI-BB0021 12/10/12 By Vampire 確認段應該也要做控卡撥出料/倉/儲/批
# Modify.........: No.MOD-CA0009 12/10/12 By Elise 倉庫有效日期不應控卡
# Modify.........: No.FUN-CB0087 12/12/06 By qiull 庫存單據理由碼改善
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No:DEV-D30046 13/04/10 By TSD.sophy 將saimt324.4gl的過帳段移至saimt324_sub.4gl
# Modify.........: No.FUN-D40053 13/04/15 By bart 增加過帳日欄位
# Modify.........: No.DEV-D40015 13/04/19 By Nina 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D40019 13/04/23 By Nina 修正DEV-D40015控卡的SQL
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:MOD-DC0097 13/12/13 By fengmy 啟用參考單位,imn32/imn42數量為0不讓過
# Modify.........: No:160602 16/06/02 By guanyao 修改审核，过账逻辑

DATABASE ds
GLOBALS "../../config/top.global"
globals "../../config/darcy.global" #darcy:2023/04/03 add

#FUN-BC0036 rename
#DEV-D30046 --add--begin
GLOBALS
   DEFINE g_padd_img    DYNAMIC ARRAY OF RECORD
             img01         LIKE img_file.img01,
             img02         LIKE img_file.img02,
             img03         LIKE img_file.img03,
             img04         LIKE img_file.img04,
             img05         LIKE img_file.img05,
             img06         LIKE img_file.img06,
             img09         LIKE img_file.img09,
             img13         LIKE img_file.img13,
             img14         LIKE img_file.img14,
             img17         LIKE img_file.img17,
             img18         LIKE img_file.img18,
             img19         LIKE img_file.img19,
             img21         LIKE img_file.img21,
             img26         LIKE img_file.img26,
             img27         LIKE img_file.img27,
             img28         LIKE img_file.img28,
             img35         LIKE img_file.img35,
             img36         LIKE img_file.img36,
             img37         LIKE img_file.img37
                        END RECORD

   DEFINE g_padd_imgg   DYNAMIC ARRAY OF RECORD
             imgg00        LIKE imgg_file.imgg00,
             imgg01        LIKE imgg_file.imgg01,
             imgg02        LIKE imgg_file.imgg02,
             imgg03        LIKE imgg_file.imgg03,
             imgg04        LIKE imgg_file.imgg04,
             imgg05        LIKE imgg_file.imgg05,
             imgg06        LIKE imgg_file.imgg06,
             imgg09        LIKE imgg_file.imgg09,
             imgg10        LIKE imgg_file.imgg10,
             imgg20        LIKE imgg_file.imgg20,
             imgg21        LIKE imgg_file.imgg21,
             imgg211       LIKE imgg_file.imgg211,
             imggplant     LIKE imgg_file.imggplant,
             imgglegal     LIKE imgg_file.imgglegal
                        END RECORD
END GLOBALS
  
DEFINE g_debit,g_credit    LIKE img_file.img26
DEFINE g_img10,g_img10_2   LIKE img_file.img10
#DEV-D30046 --add--end

FUNCTION t324sub_lock_cl() #FUN-A60034 
   DEFINE l_forupd_sql STRING                                                   

   LET l_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE t324sub_cl CURSOR FROM l_forupd_sql                                  
END FUNCTION

FUNCTION t324sub_y_chk(p_imm01)
   DEFINE p_imm01    LIKE imm_file.imm01
   DEFINE l_imm      RECORD LIKE imm_file.* 
   DEFINE l_cnt      LIKE type_file.num10   
   DEFINE b_imn      RECORD LIKE imn_file.* 
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06  
   DEFINE l_n        LIKE type_file.num10   
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_buf      LIKE gem_file.gem02 
   DEFINE l_flag     LIKE type_file.chr1   #FUN-BC0036
   DEFINE p_action_choice STRING                   #CHI-C30106
   DEFINE l_immmksg       LIKE imm_file.immmksg    #CHI-C30106
   DEFINE l_imm15         LIKE imm_file.imm15      #CHI-C30106
   DEFINE l_img10    LIKE img_file.img10   #CHI-BB0021 add
   DEFINE l_store    STRING                   #FUN-CB0087 add
   DEFINE l_where    STRING                   #FUN-CB0087 add
   DEFINE l_imn      RECORD LIKE imn_file.*   #FUN-CB0087 add
   DEFINE l_sql      STRING                   #FUN-CB0087 add
   DEFINE l_flag01   LIKE type_file.chr1      #FUN-D30024 add
   DEFINE l_ima930   LIKE ima_file.ima930     #DEV-D30040 add
   define l_fifo_img dynamic array of  fifo_img #darcy:2023/04/03 add
   define l_cnt1     like type_file.num5  #darcy:2023/04/03 add

   WHENEVER ERROR CONTINUE   #MOD-C20209 add

  #CHI-C30106---str---
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"
   THEN 
#CHI-C30107 ---------------- add ----------------- begin
     IF cl_null(p_imm01) THEN
        CALL cl_err('',-400,0)
        LET g_success = 'N'
        RETURN
     END IF
     IF l_imm.immconf='Y' THEN
        LET g_success = 'N'
        CALL cl_err('','9023',0)
        RETURN
     END IF

     IF l_imm.immconf = 'X' THEN
        LET g_success = 'N'
        CALL cl_err(' ','9024',0)
        RETURN
     END IF

     IF l_imm.immacti = 'N' THEN #當資料有效碼為'N'時,RETURN
        LET g_success = 'N'
        CALL cl_err(' ','mfg0301',1)
        RETURN
     END IF
#CHI-C30107 ---------------- add ----------------- end
      SELECT immmksg,imm15
        INTO l_immmksg,l_imm15
        FROM imm_file
       WHERE imm01=p_imm01
      IF l_immmksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_imm15 != '1' THEN
            CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
            LET g_success = 'N'
            RETURN
         END IF 
      END IF
      #FUN-BC0036 --START--
      IF NOT cl_confirm('axm-108') THEN
         LET g_success='N'
         RETURN    
      END IF       
      #FUN-BC0036 --END--
   END IF    
  #CHI-C30106---end---

   LET g_success = 'Y'
   IF cl_null(p_imm01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
   SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01

   #FUN-AB0066 --begin--
   IF NOT s_chk_ware(l_imm.imm08) THEN 
      LET g_success = 'N'
      RETURN 
   END IF 
   #FUN-AB0066 --end--
   #TQC-B50032--begin
   IF NOT cl_null(l_imm.imm14) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=l_imm.imm14
         AND gemacti='Y'   
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err3("sel","gem_file",l_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end
   IF l_imm.immconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF

   IF l_imm.immconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   IF l_imm.immacti = 'N' THEN #當資料有效碼為'N'時,RETURN
      LET g_success = 'N'   
      CALL cl_err(' ','mfg0301',1)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM imn_file   
    WHERE imn01= l_imm.imm01                 
   IF l_cnt = 0 THEN
      LET g_success = 'N'   
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n FROM imn_file
    WHERE imn01=l_imm.imm01
      AND (imn04 IS NULL OR imn15 IS NULL)
   IF l_n>0 THEN
      CALL cl_err('','aim-149',1)
      LET g_success = 'N'
      RETURN
   END IF

   DECLARE t324sub_y_chk_c CURSOR FOR SELECT * FROM imn_file
                                   WHERE imn01=l_imm.imm01
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_showmsg_init()
      let l_cnt = 1 #darcy:2023/04/03 add
      call l_fifo_img.clear() #darcy:2023/04/03 add
      FOREACH t324sub_y_chk_c INTO l_imn.*
         LET l_store = ''
         IF NOT cl_null(l_imn.imn04) THEN
            LET l_store = l_store,l_imn.imn04
         END IF
         IF NOT cl_null(l_imn.imn15) THEN
            IF NOT cl_null(l_store) THEN
               LET l_store = l_store,"','",l_imn.imn15
            ELSE
               LET l_store = l_store,l_imn.imn15
            END IF
         END IF
         #darcy:2023/04/03 add s---
         if b_imn.imn04 !='S005' and  b_imn.imn04 !='YP002' then
            let l_fifo_img[l_cnt].img01= l_imn.imn03
            let l_fifo_img[l_cnt].img02= l_imn.imn04
            let l_fifo_img[l_cnt].img03= l_imn.imn05
            let l_fifo_img[l_cnt].img04= l_imn.imn06
            let l_cnt = l_cnt + 1
         end if
         #darcy:2023/04/03 add e---
         #darcy:2022/10/25 s---
         # 检查出入的批号是否相同给予提示，但仍然可以审核
         if l_imn.imn06 != l_imn.imn17 then
            CALL s_errmsg('imn06,imn17',l_imn.imn06,l_imn.imn17,'cim-015',1)
         end if
         #darcy:2022/10/25 e---
         IF NOT cl_null(l_imn.imn28) THEN
            LET l_n = 0
            LET l_flag = FALSE
            CALL s_get_where(l_imm.imm01,'','',l_imn.imn03,l_store,'',l_imm.imm14) RETURNING l_flag,l_where
            IF g_aza.aza115='Y' AND l_flag THEN
               LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",l_imn.imn28,"' AND ",l_where
               PREPARE ggc08_pre FROM l_sql
               EXECUTE ggc08_pre INTO l_n
               IF l_n < 1 THEN
                  LET g_success='N'
                  CALL s_errmsg('imn28',l_imn.imn28,l_imn.imn28,'aim-425',1)
               END IF
            END IF
         END IF
      END FOREACH
      #darcy:2023/04/03 add s---
      call l_fifo_img.deleteElement(l_cnt)
      if g_prog = 'aimt324' then
         call cs_fifo(l_fifo_img)
      end if
      #darcy:2023/04/03 add e---
      CALL s_showmsg()
   END IF
   #FUN-CB0087---add---end---
   CALL s_showmsg_init() #darcy:2022/10/26 add
   let l_cnt1 = 1 #darcy:2023/04/03 add
   call l_fifo_img.clear() #darcy:2023/04/03 add
   FOREACH t324sub_y_chk_c INTO b_imn.*
      #FUN-AB0066 --begin--
      IF NOT s_chk_ware(b_imn.imn04) THEN 
         LET g_success = 'N'
         RETURN 
      END IF 
      IF NOT s_chk_ware(b_imn.imn15) THEN 
         LET g_success = 'N'
         RETURN 
      END IF    
      #FUN-AB0066 --end--
      #darcy:2022/10/25 s---
      # 检查出入的批号是否相同给予提示，但仍然可以审核
      if b_imn.imn06 != b_imn.imn17 then
         CALL s_errmsg('imn06,imn17',b_imn.imn06,b_imn.imn17,'cim-015',1)
      end if
      #darcy:2022/10/25 e---
      #FUN-CB0087--add--str--
      IF g_aza.aza115 = 'Y' AND cl_null(b_imn.imn28) THEN
         LET g_success = 'N'
         CALL cl_err('','aim-888',1)
         EXIT FOREACH
      END IF
      #FUN-CB0087--add--end

      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930
        FROM ima_file
       WHERE ima01 = b_imn.imn03
         AND imaacti = "Y"
      
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = b_imn.imn01
            AND rvbs02 = b_imn.imn02
            AND rvbs09 = -1
            AND rvbs13 = 0
            
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
         
         IF (l_ima930 = 'Y' and l_rvbs06 <> 0) OR l_ima930 = 'N' THEN  #DEV-D30040   
            IF b_imn.imn10 <> l_rvbs06 THEN
               LET g_success = "N"
               CALL cl_err(b_imn.imn03,"aim-011",1)
               CONTINUE FOREACH
            END IF
         END IF                                                        #DEV-D30040
      END IF

      #CHI-BB0021 ----- add start -----
      IF cl_null(b_imn.imn05) THEN
         LET b_imn.imn05 = ' '
      END IF

      IF cl_null(b_imn.imn06) THEN
         LET b_imn.imn06 = ' '
      END IF

      SELECT img10 INTO l_img10 FROM img_file
       WHERE img01=b_imn.imn03 AND img02=b_imn.imn04
         AND img03=b_imn.imn05 AND img04=b_imn.imn06
        #tianry add 170521   调拨有效期新增判断  
#         AND img18>=g_today
        #tianry add end 
      IF SQLCA.sqlcode THEN
          LET l_img10 = 0
          #在庫存明細資料查無該筆, 請重新輸入!!
          LET g_success = "N"
          CALL cl_err(b_imn.imn02,'mfg6101',1)
          CONTINUE FOREACH
      END IF
        #tianry add 170521
      SELECT img10 INTO l_img10 FROM img_file
       WHERE img01=b_imn.imn03 AND img02=b_imn.imn04
         AND img03=b_imn.imn05 AND img04=b_imn.imn06
        #tianry add 170521   调拨有效期新增判断
#       AND img18>=g_today
       IF SQLCA.sqlcode THEN
          LET l_img10 = 0
          #在庫存明細資料查無該筆, 請重新輸入!!
          LET g_success = "N"
          CALL cl_err(b_imn.imn03,'csf-a09',1)
          CONTINUE FOREACH
       END IF

        #tianry add end
 


      IF l_img10 <=0 THEN
          #庫存不足是否許調撥出庫='N'
        #FUN-D30024 ---------Begin-----------
          LET l_flag01 = NULL
          CALL s_inv_shrt_by_warehouse(b_imn.imn04,g_plant) RETURNING l_flag01 #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
        # IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
        #FUN-D30024 ---------End-------------
              #目前已無庫存量無法執行調撥動作
              LET g_success = "N"
              CALL cl_err(b_imn.imn02,'mfg3471',1)
              CONTINUE FOREACH
          END IF
      END IF
     #MOD-CA0009---mark---S
     ##-->有效日期
     #IF NOT s_actimg(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06) THEN
     #    LET g_success = "N"
     #    CALL cl_err('inactive','mfg6117',1)
     #    CONTINUE FOREACH
     #END IF
     #MOD-CA0009---mark---E
      CALL s_umfchk(b_imn.imn03,b_imn.imn09,b_imn.imn20) RETURNING l_cnt,b_imn.imn21
      IF l_cnt = 1 THEN
          LET g_success = "N"
          CALL cl_err('','mfg3075',1)
          CONTINUE FOREACH
      END IF
      #CHI-BB0021 ----- add end -----

      #FUN-BC0036 --START--
      IF s_industry('icd') THEN         
          IF s_icdbin(b_imn.imn03) THEN  
             CALL s_icdchk(-1,b_imn.imn03,
                             b_imn.imn04,
                             b_imn.imn05, 
                             b_imn.imn06, 
                             b_imn.imn10, 
                             b_imn.imn01, 
                             b_imn.imn02,
                             #l_imm.imm02,'')  #FUN-D40053
                             l_imm.imm17,'')  #FUN-D40053
                  RETURNING l_flag             
             IF l_flag = 0 THEN                
                LET g_success = 'N'
                RETURN
             END IF
          END IF
      END IF
      #FUN-BC0036 --END--
      #darcy:2023/04/03 add s---
      if b_imn.imn04 !='S005' and  b_imn.imn04 !='YP002' then
         let l_fifo_img[l_cnt1].img01= b_imn.imn03
         let l_fifo_img[l_cnt1].img02= b_imn.imn04
         let l_fifo_img[l_cnt1].img03= b_imn.imn05
         let l_fifo_img[l_cnt1].img04= b_imn.imn06
         let l_cnt1 = l_cnt1 + 1
      end if
      #darcy:2023/04/03 add e---
   END FOREACH
   #darcy:2023/04/03 add s---
   call l_fifo_img.deleteElement(l_cnt1)
   if g_prog = 'aimt324' then
      call cs_fifo(l_fifo_img)
   end if
   #darcy:2023/04/03 add e---
   CALL s_showmsg() #darcy:2022/10/26 add

   IF g_success = 'N' THEN RETURN END IF

END FUNCTION

#FUNCTION t324sub_y_upd(p_imm01,p_action_choice)                 #mark by guanyao160602
FUNCTION t324sub_y_upd(p_imm01,p_action_choice,p_inTransaction)  #add by guanyao160602
   DEFINE l_chr           LIKE type_file.chr1
   DEFINE l_immmksg       LIKE imm_file.immmksg 
   DEFINE l_imm15         LIKE imm_file.imm15   
   DEFINE p_action_choice STRING
   DEFINE p_imm01         LIKE imm_file.imm01
   DEFINE l_imm           RECORD LIKE imm_file.*
   DEFINE p_inTransaction  LIKE type_file.num5   #add by guanyao160602

   WHENEVER ERROR CONTINUE   #MOD-C20209 add
 
   LET g_success = 'Y'

  #CHI-C30106---mark---str---
  #IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
  #   g_action_choice CLIPPED = "insert"     
  #THEN 
  #   SELECT immmksg,imm15 
  #     INTO l_immmksg,l_imm15
  #     FROM imm_file
  #    WHERE imm01=p_imm01
  #   IF l_immmksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
  #      IF l_imm15 != '1' THEN
  #         CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
  #         LET g_success = 'N'
  #         RETURN
  #      END IF
  #   END IF
  #   #FUN-BC0036 --START--
  #   IF NOT cl_confirm('axm-108') THEN
  #      LET g_success='N'
  #      RETURN
  #   END IF 
  #   #FUN-BC0036 --END--
  #END IF
  #CHI-C30106---mark---end---
   IF NOT p_inTransaction THEN #add by guanyao160602
      BEGIN WORK
   END IF                      #add by guanyao160602

   CALL t324sub_lock_cl()

   OPEN t324sub_cl USING p_imm01
   IF STATUS THEN
      CALL cl_err("OPEN t324sub_cl:", STATUS, 1)
      CLOSE t324sub_cl
      #ROLLBACK WORK  mark by guanyao160602 
      IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'N' END IF #add by guanyao160602
      RETURN
   END IF
   FETCH t324sub_cl INTO l_imm.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324sub_cl 
       #ROLLBACK WORK mark by guanyao160602 
       IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'N' END IF #add by guanyao160602
       RETURN
   END IF
   CLOSE t324sub_cl
   UPDATE imm_file 
      SET immconf = 'Y',
          imm15 = '1' 
    WHERE imm01 = l_imm.imm01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imm_file",l_imm.imm01,"",SQLCA.sqlcode,"",
                   "upd ummconf",1)  
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      IF l_imm.immmksg = 'Y' AND l_imm.immconf = 'N' THEN  #簽核模式
         CASE aws_efapp_formapproval()                     #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET l_imm.immconf="N"
                   LET g_success = "N"
                   #ROLLBACK WORK
                   IF NOT p_inTransaction THEN ROLLBACK WORK  END IF #add by guanyao160602
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET l_imm.immconf="N"
                   #ROLLBACK WORK
                   IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'N' END IF #add by guanyao160602
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_imm.imm15='1'                #執行成功, 狀態值顯示為 '1' 已核准
         LET l_imm.immconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         #COMMIT WORK
         IF NOT p_inTransaction THEN COMMIT WORK END IF #add by guanyao160602
         CALL cl_flow_notify(l_imm.imm01,'Y')
      ELSE
         LET l_imm.immconf='N'
         LET g_success = 'N'
         #ROLLBACK WORK
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF #add by guanyao160602
      END IF
   ELSE
      LET l_imm.immconf='N'
      LET g_success = 'N'
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF #add by guanyao160602
   END IF
END FUNCTION

FUNCTION t324sub_refresh(p_imm01)
  DEFINE p_imm01 LIKE imm_file.imm01
  DEFINE l_imm RECORD LIKE imm_file.*

  SELECT * INTO l_imm.* FROM imm_file WHERE imm01=p_imm01
  RETURN l_imm.*
END FUNCTION

#DEV-D30046 --add--begin
#FUNCTION t324sub_s(p_imm01,p_argv2,p_argv4)  #mark by guanyao160602
FUNCTION t324sub_s(p_imm01,p_argv2,p_argv4,p_inTransaction)  #add by guanyao160602
   DEFINE l_cnt    LIKE type_file.num10   #No.FUN-690026 INTEGER
   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
   DEFINE p_inTransaction  LIKE type_file.num5   #add by guanyao160602
   DEFINE l_imn10  LIKE imn_file.imn10
   DEFINE l_imn29  LIKE imn_file.imn29
   DEFINE l_imn03  LIKE imn_file.imn03
   DEFINE l_qcs01  LIKE qcs_file.qcs01
   DEFINE l_qcs02  LIKE qcs_file.qcs02
   DEFINE l_imd11  LIKE imd_file.imd11   #MOD-A70068
   DEFINE l_imd11_1 LIKE imd_file.imd11   #MOD-B10114 add
   #&ifdef ICD
   DEFINE l_flag    LIKE type_file.num5    #FUN-920207
   #&endif
   DEFINE l_result LIKE type_file.chr1   #MOD-C50048 add
   DEFINE l_date   LIKE type_file.dat    #CHI-C50010 add
   DEFINE l_img37     LIKE img_file.img37     #CHI-C80007 add
   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
   DEFINE l_sel    LIKE type_file.num5   #CHI-C90036
   DEFINE l_t1     LIKE smy_file.smyslip #No:DEV-D30026
   DEFINE l_smyb01 LIKE smyb_file.smyb01 #No:DEV-D30026
   DEFINE l_ima906 LIKE ima_file.ima906  #MOD-CC0139 add
   #DEV-D30046 --add--begin
   DEFINE p_imm01     LIKE imm_file.imm01   
   DEFINE p_argv2     LIKE type_file.chr1
   DEFINE p_argv4     STRING
   DEFINE l_imm       RECORD LIKE imm_file.*
   DEFINE l_imn       RECORD LIKE imn_file.* 
   DEFINE l_yy,l_mm   LIKE type_file.num5 
   DEFINE l_imm01     LIKE imm_file.imm01
   DEFINE l_unit_arr  DYNAMIC ARRAY OF RECORD  
             unit        LIKE ima_file.ima25,
             fac         LIKE img_file.img21,
             qty         LIKE img_file.img10
                      END RECORD
   DEFINE l_msg       LIKE type_file.chr1000
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_qcs091    LIKE qcs_file.qcs091
   DEFINE l_imni      RECORD LIKE imni_file.*
   DEFINE l_sfp03     LIKE sfp_file.sfp03    #add by qianyuan170328
   define l_chk_imn04,l_chk_imn15 varchar(10)  #darcy:2023/08/16
   #DEV-D30046 --add--end
   
   WHENEVER ERROR CONTINUE   

   LET g_success = 'Y'

   SELECT * INTO l_imm.* FROM imm_file
    WHERE imm01 = p_imm01 
   #LET l_imm.imm17 = g_today #add by wangxt170210    #mark by qianyuan170328 

   #---str---add by qianyuan170328---
   IF g_prog='aimt324' THEN 
      LET l_imm.imm17 = g_today
   END IF 
   #---end---add by qianyuan170328---
   
   #DEV-D30037--mark--begin
   ##No:DEV-D30026  Add str---------
   # LET l_t1 = s_get_doc_no(l_imm.imm01)
   # SELECT smyb01 INTO l_smyb01 FROM smyb_file
   #  WHERE smybslip = l_t1
   # IF cl_null(l_smyb01) THEN
   #     LET l_smyb01 = '1'
   # END IF
   ##No:DEV-D30026  Add end--------- 
   #DEV-D30037--mark--end

   #DEV-D30037--add--begin
   CALL t324sub_chk_smyb2(l_imm.imm01)
      RETURNING l_smyb01
   #DEV-D30037--add--end

   IF l_imm.immconf = 'N' THEN #FUN-660029
      CALL cl_err('','aba-100',0)
      RETURN
   END IF

   IF l_imm.imm03 = 'Y' THEN
      CALL cl_err('','asf-812',0) #FUN-660029
      RETURN
   END IF

   IF l_imm.immconf = 'X' THEN #FUN-660029
      CALL cl_err('',9024,0)
      RETURN
   END IF

   IF l_imm.imm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #IF g_sma.sma53 IS NOT NULL AND l_imm.imm02 <= g_sma.sma53 THEN  #FUN-D40053
   IF g_sma.sma53 IS NOT NULL AND l_imm.imm17 <= g_sma.sma53 THEN  #FUN-D40053
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF

   #CALL s_yp(l_imm.imm02) RETURNING l_yy,l_mm  #FUN-D40053
   CALL s_yp(l_imm.imm17) RETURNING l_yy,l_mm  #FUN-D40053
   IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0)
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL cl_err(l_mm,'mfg6091',0)
         RETURN
      END IF
   END IF

   #No.+022 010328 by linda add 無單身不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM imn_file
    WHERE imn01 = l_imm.imm01 

   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   #No:DEV-D30026  Add str--------
   IF l_smyb01 = '2' AND cl_null(p_argv4) THEN
      CALL cl_err('','aba-043',0)
      RETURN
   END IF
   #No:DEV-D30026  Add end--------

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'aimt324' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
      #WHERE ima01 IN (SELECT imn03 FROM imn_file WHERE imn03 = l_imm.imm01) #料件  #DEV-D40019 mark
       WHERE ima01 IN (SELECT imn03 FROM imn_file WHERE imn01 = l_imm.imm01) #料件  #DEV-D40019 add
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_imm.imm01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------

   IF p_argv2!='A' THEN  #no.CHI-780041 
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #No:FUN-840012
         IF NOT cl_confirm('mfg0176') THEN
            RETURN
         END IF
      END IF
   END IF                #NO.CHI-780041
   #FUN-D40053---begin
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      IF NOT p_inTransaction THEN  #add by guanyao160602
      INPUT l_imm.imm17 WITHOUT DEFAULTS FROM imm17
             
         AFTER FIELD imm17
            IF NOT cl_null(l_imm.imm17) THEN
               IF g_sma.sma53 IS NOT NULL AND l_imm.imm17 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD imm17
               END IF
               CALL s_yp(l_imm.imm17) RETURNING l_yy,l_mm 
             
               IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                  CALL cl_err('','mfg6090',0)
                  NEXT FIELD imm17
               END IF
            END IF
             
         AFTER INPUT 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_success = 'N'
               RETURN
            END IF
            IF NOT cl_null(l_imm.imm17) THEN
               IF g_sma.sma53 IS NOT NULL AND l_imm.imm17 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0) 
                  NEXT FIELD imm17
               END IF
               CALL s_yp(l_imm.imm17) RETURNING l_yy,l_mm
               IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err(l_yy,'mfg6090',0) 
                  NEXT FIELD imm17
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
      END IF   #add by guanyao160602

      IF g_sma.sma53 IS NOT NULL AND l_imm.imm17 <= g_sma.sma53 THEN  
         CALL cl_err('','mfg9999',0)
         RETURN
      END IF

      CALL s_yp(l_imm.imm17) RETURNING l_yy,l_mm 
      IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
         CALL cl_err(l_yy,'mfg6090',0)
         RETURN
      ELSE
         IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
            CALL cl_err(l_mm,'mfg6091',0)
            RETURN
         END IF
      END IF
   END IF
   UPDATE imm_file SET imm17 = l_imm.imm17
    WHERE imm01 = l_imm.imm01 

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #FUN-D40053---end
   LET l_sql = "SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
               " WHERE imn01= '",l_imm.imm01,"'"
   PREPARE t324sub_curs1 FROM l_sql

   DECLARE t324sub_pre1 CURSOR FOR t324sub_curs1

   FOREACH t324sub_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
      IF l_imn29='Y' THEN
         LET l_qcs091=0
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01 = l_qcs01
            AND qcs02 = l_qcs02
            AND qcs14 = 'Y'

         IF cl_null(l_qcs091) THEN
            LET l_qcs091 = 0
         END IF

         IF l_qcs091 < l_imn10 THEN
            #CHI-C90036---begin
            CALL cl_getmsg('aim1013',g_lang) RETURNING l_msg
            LET INT_FLAG = 0  
            PROMPT l_msg CLIPPED,': ' FOR l_sel
            
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         
                  CALL cl_about()      
 
               ON ACTION help          
                  CALL cl_show_help()  
 
               ON ACTION controlg      
                  CALL cl_cmdask()     
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               RETURN
            END IF
            IF l_sel <> 1 AND l_sel <> 2 THEN
               RETURN
            END IF 
            #CALL cl_err(l_imn03,'aim1003',1)
            #RETURN
            #CHI-C90036---end
         END IF
      END IF
   END FOREACH

   DECLARE t324sub_s1_c CURSOR FOR
     SELECT * FROM imn_file WHERE imn01=l_imm.imm01 
   
   #MOD-AA0041---mark---start---
   #IF g_bgjob='N' OR cl_null(g_bgjob) THEN                                      
   #   IF NOT cl_confirm('mfg0176') THEN RETURN END IF                           
   #END IF                                                                       
   #MOD-AA0041---mark---end---
   IF NOT p_inTransaction THEN  #add by guanyao160602
      BEGIN WORK
   END IF    #add by guanyao160602

   CALL t324sub_lock_cl()   #DEV-D30046 --add
   
   OPEN t324sub_cl USING l_imm.imm01
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'Y' END IF #add by guanyao1606062
      #ROLLBACK WORK  #mark by guanyao1606062
      RETURN
   ELSE
      FETCH t324sub_cl INTO l_imm.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t324sub_cl
         IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'Y' END IF #add by guanyao1606062
         #ROLLBACK WORK  #mark by guanyao160602
         RETURN
      END IF
   END IF
   
   IF p_argv2!='A' THEN   #MOD-C80134 add
     #MOD-AA0041---add---start---
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN                                      
        #MOD-AA0103---modify---start---
        #IF NOT cl_confirm('mfg0176') THEN RETURN END IF
         IF NOT cl_confirm('mfg0176') THEN 
            CLOSE t324sub_cl
            #ROLLBACK WORK  #mark by guanyao160602
            IF NOT p_inTransaction THEN ROLLBACK WORK ELSE LET g_success = 'Y' END IF #add by guanyao1606062
            RETURN 
         END IF
        #MOD-AA0103---modify---end---
      END IF                                                                       
     #MOD-AA0041---add---end---
   END IF   #MOD-C80134 add
   
   #CHI-C90036---begin
   IF l_sel = 1 THEN 
      UPDATE imn_file
         SET imn10 = l_qcs091,imn22 = l_qcs091
       WHERE imn01 = l_qcs01
         AND imn02 = l_qcs02

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(l_imm.imm01,SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF 
   IF l_sel = 2 THEN 
      UPDATE imn_file
         SET imn10 = 0,imn22 = 0
       WHERE imn01 = l_qcs01
         AND imn02 = l_qcs02

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(l_imm.imm01,SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF 
   #CHI-C90036---end         
   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t325_y1_c3 CURSOR FOR SELECT * FROM imn_file
     WHERE imn01 = l_imm.imm01 

   FOREACH t325_y1_c3 INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn15
         AND img03 = l_imn.imn16
         AND img04 = l_imn.imn17
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imm.imm01,l_imn.imn02,l_imm.imm02,l_img_table)  #FUN-CC0095
          #CALL s_padd_img_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imm.imm01,l_imn.imn02,l_imm.imm02)  #FUN-CC0095  #FUN-D40053
          CALL s_padd_img_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imm.imm01,l_imn.imn02,l_imm.imm17)  #FUN-D40053
       END IF

       CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                       l_imn.imn16,l_imn.imn17,
                       l_imn.imn40) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn40,l_imm.imm01,l_imn.imn02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn40,l_imm.imm01,l_imn.imn02)  #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                       l_imn.imn16,l_imn.imn17,
                       l_imn.imn43) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn43,l_imm.imm01,l_imn.imn02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn43,l_imm.imm01,l_imn.imn02)  #FUN-CC0095
       END IF 
   END FOREACH 
   
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM g_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF
         END IF
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095 
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
   #FUN-C70087---end
  
   LET g_success = 'Y'
   
   CALL s_showmsg_init()   #No:FUN-6C0083 

   FOREACH t324sub_s1_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF

      LET l_cmd= 's_ read parts:',l_imn.imn03
      CALL cl_msg(l_cmd)
      #darcy:2023/08/16 add s---
      # 仓库要求非成本仓与成本仓之间不允许调拨，aimt324已经管控，此处管控为了发料自动调拨管控。
      let l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img FROM jce_file
       WHERE jce02=l_imn.imn04
      IF l_cnt_img>0 THEN
         LET l_chk_imn04 = 'N'
      END IF
      let l_cnt_img = 0
      SELECT COUNT(*) INTO g_cnt FROM jce_file
       WHERE jce02=l_imn.imn15
      IF l_cnt_img>0 THEN
         LET l_chk_imn15 = 'N'
      END IF
      if l_chk_imn15 != l_chk_imn04 then
         CALL s_errmsg("imn02/imn03/imn04/imn15",l_imn.imn02||"/"||l_imn.imn03||"/"||l_imn.imn04||"/"||l_imn.imn15,'','aim-133',1)
         let g_success='N'
      end if
      #darcy:2023/08/16 add e---
      #-----MOD-A70068---------
      #撥入倉
      LET l_imd11 = ''
      SELECT imd11 INTO l_imd11 FROM imd_file 
       WHERE imd01 = l_imn.imn15
      #MOD-B10114---modify---start---
      #IF l_imd11 = 'N' OR l_imd11 IS NULL THEN   
      #撥出倉
      LET l_imd11_1 = ''
      SELECT imd11 INTO l_imd11_1 FROM imd_file 
       WHERE imd01 = l_imn.imn04
      IF l_imd11_1 = 'Y' AND (l_imd11 = 'N' OR l_imd11 IS NULL) THEN 
      #MOD-B10114---modify---end---
         CALL t324sub_chk_avl_stk(l_imn.*)     
         IF g_success='N' THEN
            LET g_totsuccess="N"
            CONTINUE FOREACH   
         END IF    
      END IF   
      #-----END MOD-A70068-----

      #MOD-C50048 add begin-------------------
      #撥出倉庫過賬權限檢查
      CALL s_incchk(l_imn.imn04,l_imn.imn05,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_imn.imn03,"/",l_imn.imn04,"/",l_imn.imn05,"/",g_user
         CALL s_errmsg("imn03/imn04/imn05/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF

      #撥入倉庫過賬權限檢查
      CALL s_incchk(l_imn.imn15,l_imn.imn16,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_imn.imn03,"/",l_imn.imn15,"/",l_imn.imn16,"/",g_user
         CALL s_errmsg("imn03/imn15/imn16/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF
      #MOD-C50048 add end---------------------

      IF cl_null(l_imn.imn04) THEN CONTINUE FOREACH END IF
      
      #&ifdef ICD
      IF s_industry("icd") THEN   #DEV-D30046 --add
         #DEV-D30046 --add--begin
         SELECT * INTO l_imni.* FROM imni_file 
          WHERE imni01 = l_imm.imm01
            AND imni02 = l_imn.imn02
         #DEV-D30046 --add--end
         
         CALL s_icdpost(-1,l_imn.imn03,l_imn.imn04,l_imn.imn05,          
                        l_imn.imn06,l_imn.imn09,l_imn.imn10,
                        #l_imn.imn01,l_imn.imn02,l_imm.imm02,'Y',  #FUN-D40053
                        l_imn.imn01,l_imn.imn02,l_imm.imm17,'Y',  #FUN-D40053
                        '','',l_imni.imniicd029,l_imni.imniicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
              RETURNING l_flag                                            
         IF l_flag = 0 THEN                                               
           #str MOD-A20099 mod
           #LET g_success = 'N'
           #RETURN
            LET g_totsuccess="N"
            CONTINUE FOREACH
           #end MOD-A20099 mod
         END IF
             
         CALL s_icdpost(1,l_imn.imn03,l_imn.imn15,l_imn.imn16,          
                        l_imn.imn17,l_imn.imn20,l_imn.imn22,
                        #l_imn.imn01,l_imn.imn02,l_imm.imm02,'Y',  #FUN-D40053
                        l_imn.imn01,l_imn.imn02,l_imm.imm17,'Y',  #FUN-D40053
                        '','',l_imni.imniicd029,l_imni.imniicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
                     
              RETURNING l_flag                                            
         IF l_flag = 0 THEN
           #str MOD-A20099 mod
           #LET g_success = 'N'
           #RETURN
            LET g_totsuccess="N"
            CONTINUE FOREACH
          #end MOD-A20099 mod
         END IF 
      END IF    #DEV-D30046 --add
      #&endif     
 
      SELECT *
        FROM img_file WHERE img01=l_imn.imn03 AND
                            img02=l_imn.imn15 AND
                            img03=l_imn.imn16 AND
                            img04=l_imn.imn17
      IF SQLCA.sqlcode THEN
         IF l_imn.imn05 IS NULL THEN LET l_imn.imn05 =' ' END IF   #MOD-CB0122 add
         IF l_imn.imn06 IS NULL THEN LET l_imn.imn06 =' ' END IF   #MOD-CB0122 add
            #CHI-C50010 str add-----
            #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
            SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
            #TQC-C90089---add----
            #WHERE img01 = g_imn[l_ac].imn03
            #  AND img02 = g_imn[l_ac].imn04
            #  AND img03 = g_imn[l_ac].imn05
            #  AND img04 = g_imn[l_ac].imn06
             WHERE img01 = l_imn.imn03
               AND img02 = l_imn.imn04
               AND img03 = l_imn.imn05
               AND img04 = l_imn.imn06
           #TQC-C90089---add---
           #MOD-CB0122 add---S
           IF STATUS=100 THEN
              CALL cl_err('','mfg6101',1)  
              LET g_success ='N'
              CONTINUE FOREACH
           ELSE
           #MOD-CB0122 add---E
              CALL s_date_record(l_date,'Y')
           END IF    #MOD-CB0122 add
           #CHI-C50010 end add-----
            CALL s_idledate_record(l_img37)  #CHI-C80007 add
            CALL s_add_img(l_imn.imn03,l_imn.imn15,
                           l_imn.imn16,l_imn.imn17,
                           l_imm.imm01,l_imn.imn02,
                           #l_imm.imm02)  #FUN-D40053
                           l_imm.imm17)  #FUN-D40053
      END IF
      #MOD-CC0139 add
      
      #不做sma892[3,3]提示的处理，前FUN-C70087单号已增加
      IF g_sma.sma115 = 'Y' THEN
         LET l_ima906=''
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01 = l_imn.imn03
         #母子单位 单位一  --begin
         IF l_ima906 = '2' THEN
            CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                            l_imn.imn16,l_imn.imn17,
                            l_imn.imn40) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                               l_imn.imn16,l_imn.imn17,
                               l_imn.imn40,l_imn.imn41,
                               l_imm.imm01,l_imn.imn02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位 单位一  --end
         #母子单位&参考单位 单位二  --begin
         IF l_ima906 MATCHES '[23]' THEN
            CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                            l_imn.imn16,l_imn.imn17,
                            l_imn.imn43) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                               l_imn.imn16,l_imn.imn17,
                               l_imn.imn43,l_imn.imn44,
                               l_imm.imm01,l_imn.imn02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位&参考单位 单位二  --end
      END IF
      #MOD-CC0139 add--end

      #FUN-D30024 -----------Begin---------
      #IF NOT s_stkminus(l_imn.imn03,l_imn.imn04,l_imn.imn05,l_imn.imn06,
      #                  l_imn.imn10,1,l_imm.imm02,g_sma.sma894[4,4]) THEN
       IF NOT s_stkminus(l_imn.imn03,l_imn.imn04,l_imn.imn05,l_imn.imn06,
                         #l_imn.imn10,1,l_imm.imm02) THEN  #FUN-D40053
                         l_imn.imn10,1,l_imm.imm17) THEN  #FUN-D40053
      #FUN-D30024 -----------End-----------
         LET g_totsuccess="N"
         CONTINUE FOREACH   #No:FUN-6C0083
      END IF

      #-->撥出更新
      IF t324sub_t(l_imn.*,l_imm.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH   #No:FUN-6C0083
      END IF

      IF g_sma.sma115 = 'Y' THEN
         CALL t324sub_upd_s(l_imn.*,l_imm.*)
      END IF

      IF g_success = 'N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No:FUN-6C0083
      END IF

      #-->撥入更新
      IF t324sub_t2(l_imn.*,l_imm.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH   #No:FUN-6C0083
      END IF

      IF g_sma.sma115 = 'Y' THEN
         CALL t324sub_upd_t(l_imn.*,l_imm.*)
      END IF

      #FUN-AC0074--behin--add---
      CALL s_updsie_sie(l_imn.imn01,l_imn.imn02,'4')
      #FUN-AC0074--end--add-----

      IF g_success = 'N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No:FUN-6C0083
      END IF
 
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No:FUN-6C0083
  
   UPDATE imm_file SET imm03 = 'Y',
                       imm04 = 'Y'
    WHERE imm01 = l_imm.imm01 

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   IF NOT p_inTransaction THEN  #add by guanyao1606062
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(l_imm.imm01,'S')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   END IF #add by guanyao1606062
   

   SELECT imm03 INTO l_imm.imm03 FROM imm_file WHERE imm01 = l_imm.imm01 
   IF NOT p_inTransaction THEN  #add by guanyao1606062
   DISPLAY BY NAME l_imm.imm03
   END IF #add by guanyao1606062

   IF l_imm.imm03 = "N" THEN
   #str-----add by guanyao1606062
   IF NOT p_inTransaction THEN  
      LET g_success = 'N'
   ELSE 
   #end-----add by guanyao1606062
      DECLARE t324sub_s1_c2 CURSOR FOR SELECT * FROM imn_file
        WHERE imn01 = l_imm.imm01 

      LET l_imm01 = ""
      LET g_success = "Y"

      CALL s_showmsg_init()   #No:FUN-6C0083 
      IF NOT p_inTransaction THEN  #add by guanyao1606062
         BEGIN WORK
      END IF  #add by guanyao1606062

      FOREACH t324sub_s1_c2 INTO l_imn.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         
         LET l_ima906 = ''
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01 = l_imn.imn03
          
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' THEN  #子母單位
               LET l_unit_arr[1].unit= l_imn.imn30
               LET l_unit_arr[1].fac = l_imn.imn31
               LET l_unit_arr[1].qty = l_imn.imn32
               LET l_unit_arr[2].unit= l_imn.imn33
               LET l_unit_arr[2].fac = l_imn.imn34
               LET l_unit_arr[2].qty = l_imn.imn35
               #CALL s_dismantle(l_imm.imm01,l_imn.imn02,l_imm.imm02,  #FUN-D40053
               CALL s_dismantle(l_imm.imm01,l_imn.imn02,l_imm.imm17,  #FUN-D40053
                                l_imn.imn03,l_imn.imn04,l_imn.imn05,
                                l_imn.imn06,l_unit_arr,l_imm01)
                      RETURNING l_imm01
               IF g_success='N' THEN 
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No:FUN-6C0083
               END IF
            END IF
         END IF
      END FOREACH

      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
      CALL s_showmsg()   #No:FUN-6C0083
      
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         COMMIT WORK
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      ELSE
         ROLLBACK WORK   
      END IF
   END IF   #add by guanyao160602
   END IF

   #DEV-D30046 --add--begin
   #IF l_imm.immconf='X' THEN
   #   LET g_void = 'Y'
   #ELSE
   #   LET g_void = 'N'
   #END IF
   #CALL cl_set_field_pic(l_imm.immconf,"",l_imm.imm03,"",g_void,"")   
   #DEV-D30046 --add--end
END FUNCTION

#-->撥出更新
FUNCTION t324sub_t(p_imn,p_imm)
   DEFINE p_imn         RECORD LIKE imn_file.*,
          l_img         RECORD
             img16         LIKE img_file.img16,
             img23         LIKE img_file.img23,
             img24         LIKE img_file.img24,
             img09         LIKE img_file.img09,
             img21         LIKE img_file.img21
                        END RECORD,
          l_qty         LIKE img_file.img10,
          l_factor      LIKE ima_file.ima31_fac  #MOD-A70117 add
   #DEV-D30046 --add--begin
   DEFINE l_forupd_sql  STRING              
   DEFINE p_imm         RECORD LIKE imm_file.*
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_ima25       LIKE ima_file.ima25
   #DEV-D30046 --add--end
   define l_imd10_1,l_imd10_2 like imd_file.imd10 #darcy:2022/08/04 add
   define l_imm17 like imm_file.imm17 #darcy:2022/08/04 add

   CALL cl_msg("update img_file ...")
   IF cl_null(p_imn.imn05) THEN LET p_imn.imn05=' ' END IF
   IF cl_null(p_imn.imn06) THEN LET p_imn.imn06=' ' END IF

   LET l_forupd_sql =
       "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE img_lock CURSOR FROM l_forupd_sql
 
   OPEN img_lock USING p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06
   IF SQLCA.sqlcode THEN
      CALL cl_err("img_lock fail:", STATUS, 1)   #NO.TQC-93015
      LET g_success = 'N'
      RETURN 1
   ELSE
      FETCH img_lock INTO l_img.*,g_debit,g_img10
      IF SQLCA.sqlcode THEN
         CALL cl_err("sel img_file", STATUS, 1)   #NO.TQC-930155
         LET g_success = 'N'
         RETURN 1
      END IF
   END IF

   #str MOD-A70117 add
   CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_imn.imn10 * l_factor
   #end MOD-A70117 add

   # darcy:2022/08/04 add s--- 
   # 原材料仓之间调拨不异动呆滞日期
   select imd10 into l_imd10_1 from imd_file where imd01 = p_imn.imn04
   select imd10 into l_imd10_2 from imd_file where imd01 = p_imn.imn15
   if l_imd10_1=l_imd10_2 then
      select img37 into l_imm17 from img_file
       where img01 =p_imn.imn03 and img02 =p_imn.imn04
         and img03 =p_imn.imn05 and img04= p_imn.imn06
   else
      let l_imm17 = p_imm.imm17
   end if
   # darcy:2022/08/04 add e--- 
   #-->更新倉庫庫存明細資料
   #CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,p_imn.imn10,p_imm.imm02,  #FUN-8C0084  #MOD-A70117 mark
   #CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,l_qty,p_imm.imm02,  #FUN-8C0084        #MOD-A70117  #FUN-D40053
   # CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,l_qty,p_imm.imm17,  #FUN-D40053 #darcy: mark 20220804 
    CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,l_qty,l_imm17,  #FUN-D40053 #darcy: add 20220804 
       '','','','',p_imn.imn01,p_imn.imn02,'','','','','','','','','','','','')   #No:FUN-860045

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->若庫存異動後其庫存量小於等於零時將該筆資料刪除
   CALL s_delimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06) #FUN-8C0084
 
   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   CALL cl_msg("update ima_file ...")

   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock CURSOR FROM l_forupd_sql

   OPEN ima_lock USING p_imn.imn03
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   FETCH ima_lock INTO l_ima25  #,g_ima86 #FUN-560183
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   #-->料件庫存單位數量
   LET l_qty=p_imn.imn10 * l_img.img21
   IF cl_null(l_qty)  THEN RETURN 1 END IF

   IF s_udima(p_imn.imn03,             #料件編號
              l_img.img23,             #是否可用倉儲
              l_img.img24,             #是否為MRP可用倉儲
              l_qty,                   #調撥數量(換算為料件庫存單位)
              #l_img.img16,             #最近一次撥出日期    #MOD-C30001 mark
              #p_imm.imm02,                                  #MOD-C30001  #FUN-D40053
              p_imm.imm17,  #FUN-D40053
              -1)                      #表撥出
    THEN RETURN 1
       END IF
   IF g_success = 'N' THEN RETURN 1 END IF

   #-->將已鎖住之資料釋放出來
   CLOSE img_lock
 
   RETURN 0
END FUNCTION
 
FUNCTION t324sub_t2(p_imn,p_imm)
   DEFINE p_imn          RECORD LIKE imn_file.*,
          l_img          RECORD
             img16          LIKE img_file.img16,
             img23          LIKE img_file.img23,
             img24          LIKE img_file.img24,
             img09          LIKE img_file.img09,
             img21          LIKE img_file.img21,
             img19          LIKE img_file.img19,
             img27          LIKE img_file.img27,
             img28          LIKE img_file.img28,
             img35          LIKE img_file.img35,
             img36          LIKE img_file.img36
                         END RECORD,
          l_factor       LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
          l_qty          LIKE img_file.img10
   #DEV-D30046 --add--begin
   DEFINE l_forupd_sql   STRING               
   DEFINE p_imm          RECORD LIKE imm_file.*
   DEFINE l_cnt          LIKE type_file.num5  
   DEFINE l_ima25_2      LIKE ima_file.ima25
   #DEV-D30046 --add--end
   define l_imd10_1,l_imd10_2 like imd_file.imd10 #darcy:2022/08/04 add
   define l_imm17 like imm_file.imm17 #darcy:2022/08/04 add

   LET l_forupd_sql =
       "SELECT img15,img23,img24,img09,img21,img19,img27,",         #MOD-970033 img16 modify img15
              "img28,img35,img36,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
       " FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img2_lock CURSOR FROM l_forupd_sql

   OPEN img2_lock USING p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   CALL cl_msg("update ima2_file ...")
   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima2_lock CURSOR FROM l_forupd_sql

   OPEN ima2_lock USING p_imn.imn03
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF
   FETCH ima2_lock INTO l_ima25_2  #,g_ima86_2 #FUN-560183
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_imn.imn10 * l_factor
   #darcy:2022/08/08 add s---
   # 原材料仓之间调拨不异动呆滞日期
   select imd10 into l_imd10_1 from imd_file where imd01 = p_imn.imn04
   select imd10 into l_imd10_2 from imd_file where imd01 = p_imn.imn15
   if l_imd10_1=l_imd10_2 then
      select img37 into l_imm17 from img_file
       where img01 =p_imn.imn03 and img02 =p_imn.imn04
         and img03 =p_imn.imn05 and img04= p_imn.imn06
   else
      let l_imm17 = p_imm.imm17
   end if
   #darcy:2022/08/08 add e---
   #CALL s_upimg(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,+1,l_qty,p_imm.imm02,      #FUN-8C0084  #FUN-D40053
   CALL s_upimg(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,+1,l_qty,l_imm17,  #FUN-D40053 #modify darcy:2022/08/08 
      p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
      p_imn.imn01,p_imn.imn02,l_img.img09,l_qty,      l_img.img09,
      1,  l_img.img21,1,
      g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
      l_img.img36)

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   LET l_qty = p_imn.imn22 * l_img.img21
   IF s_udima(p_imn.imn03,            #料件編號
              l_img.img23,            #是否可用倉儲
              l_img.img24,            #是否為MRP可用倉儲
              l_qty,                  #發料數量(換算為料件庫存單位)
              #l_img.img16,            #最近一次發料日期   #MOD-C30001 mark
              #p_imm.imm02,                                #MOD-C30001  #FUN-D40053
              p_imm.imm17,  #FUN-D40053
              +1)                     #表收料
        THEN RETURN  1 END IF
   IF g_success = 'N' THEN RETURN 1 END IF
   
   #-->產生異動記錄檔
   #---- 97/06/20 insert 兩筆至 tlf_file 一出一入
   CALL t324sub_log_2(1,0,'1',p_imn.*,p_imm.*) #RETURN 0
   CALL t324sub_log_2(1,0,'0',p_imn.*,p_imm.*) RETURN 0
END FUNCTION

FUNCTION t324sub_upd_s(p_imn,p_imm)
   DEFINE p_imn     RECORD LIKE imn_file.*
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
   #DEV-D30046 --add--begin
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
   DEFINE p_imm     RECORD LIKE imm_file.*   
   #DEV-D30046 --add--end

   SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
    WHERE ima01 = p_imn.imn03
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      RETURN
   END IF

   IF l_ima906 = '1' OR cl_null(l_ima906) THEN
      RETURN
   END IF

   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(p_imn.imn33) THEN
         #CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2',p_imm.imm02) #FUN-D40053
         CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2',p_imm.imm17)  #FUN-D40053
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(p_imn.imn35) THEN                                #CHI-860005
            CALL t324sub_tlff_1('2',p_imn.*,-1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(p_imn.imn30) THEN
         #CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn30,p_imn.imn31,p_imn.imn32,-1,'1',p_imm.imm02)  #FUN-D40053
         CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn30,p_imn.imn31,p_imn.imn32,-1,'1',p_imm.imm17)  #FUN-D40053
         IF g_success='N' THEN RETURN END IF
          IF NOT cl_null(p_imn.imn32) THEN                               #CHI-860005   
            CALL t324sub_tlff_2('1',p_imn.*,-1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF

   IF l_ima906 = '3' THEN  #參考單位
      #MOD-DC0097 begin
       IF NOT cl_null(p_imn.imn32) AND NOT cl_null(p_imn.imn42) THEN
          IF (p_imn.imn32 <=0) OR (p_imn.imn42 <= 0) THEN
             CALL cl_err('','mfg9105',0)
             LET g_success = 'N'
             RETURN
          END IF 
       END IF
      #MOD-DC0097 end
      IF NOT cl_null(p_imn.imn33) THEN
         #CALL t324sub_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2',p_imm.imm02)  #FUN-D40053
         CALL t324sub_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2',p_imm.imm17)  #FUN-D40053
         IF g_success = 'N' THEN RETURN END IF
         IF NOT cl_null(p_imn.imn35) THEN                                #CHI-860005
            CALL t324sub_tlff_1('2',p_imn.*,-1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t324sub_upd_t(p_imn,p_imm)
   DEFINE p_imn     RECORD LIKE imn_file.*
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5      #No.FUN-690026 SMALLINT
   #DEV-D30046 --add--begin 
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
   DEFINE p_imm     RECORD LIKE imm_file.*   
   #DEV-D30046 --add--end 

   SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
    WHERE ima01 = p_imn.imn03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(p_imn.imn43) THEN
         #CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2',p_imm.imm02) #FUN-D40053
         CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2',p_imm.imm17) #FUN-D40053
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(p_imn.imn45) THEN                                  #CHI-860005
            CALL t324sub_tlff_1('2',p_imn.*,+1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(p_imn.imn40) THEN
         #CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn40,p_imn.imn41,p_imn.imn42,+1,'1',p_imm.imm02)  #FUN-D40053
         CALL t324sub_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn40,p_imn.imn41,p_imn.imn42,+1,'1',p_imm.imm17)  #FUN-D40053
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(p_imn.imn42) THEN                                  #CHI-860005
            CALL t324sub_tlff_2('1',p_imn.*,+1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(p_imn.imn43) THEN
         #CALL t324sub_upd_imgg('2',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2',p_imm.imm02) #FUN-D40053
         CALL t324sub_upd_imgg('2',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2',p_imm.imm17) #FUN-D40053
         IF g_success = 'N' THEN RETURN END IF
         IF NOT cl_null(p_imn.imn45) THEN                                  #CHI-860005
            CALL t324sub_tlff_1('2',p_imn.*,+1,p_imm.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t324sub_chk_smyb2(p_imm01)
   DEFINE p_imm01    LIKE imm_file.imm01
   DEFINE l_ima01    LIKE ima_file.ima01
   DEFINE l_ima931   LIKE ima_file.ima931
   DEFINE l_smyb01   LIKE smyb_file.smyb01
   
   LET l_smyb01 = '1'
   IF g_aza.aza131 = 'N' OR cl_null(g_aza.aza131) THEN
      RETURN l_smyb01
   END IF

   #找出第一筆資料
   LET l_ima01 = ''
   SELECT imn03 INTO l_ima01
     FROM imn_file
    WHERE imn01 = p_imm01
      AND imn02 = (SELECT MIN(imn02) FROM imn_file
                    WHERE imn01 = p_imm01)
   
   LET l_ima931 = ''
   SELECT ima931
     INTO l_ima931
     FROM ima_file
    WHERE ima01 = l_ima01
   IF cl_null(l_ima931) THEN LET l_ima931 = 'N' END IF
   
   IF l_ima931 = 'Y' THEN
      LET l_smyb01 = '2'
   END IF
   
   RETURN l_smyb01
END FUNCTION

FUNCTION t324sub_chk_avl_stk(p_imn)   
   DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12 
   DEFINE p_imn     RECORD LIKE imn_file.*   
   DEFINE l_ima25   LIKE ima_file.ima25
   #DEV-D30046 --add--begin
   DEFINE l_sw      LIKE type_file.num5
   DEFINE l_factor  LIKE img_file.img21
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_imd23   LIKE imd_file.imd23
   #DEV-D30046 --add--end

      
   CALL s_getstock(p_imn.imn03,g_plant)
      RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
   
   LET l_oeb12 = 0
   SELECT SUM(oeb905*oeb05_fac)
    INTO l_oeb12
    FROM oeb_file,oea_file   
   WHERE oeb04=p_imn.imn03
     AND oeb19= 'Y'
     AND oeb70= 'N'  
     AND oea01 = oeb01 AND oeaconf !='X' 
   IF l_oeb12 IS NULL THEN
      LET l_oeb12 = 0
   END IF
   
   LET l_qoh = l_avl_stk - l_oeb12
   
   SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01 = p_imn.imn03
   CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_ima25)
        RETURNING l_sw,l_factor
   
   #IF l_qoh < p_imn.imn10*l_factor AND g_sma.sma894[4,4]='N' THEN                      #FUN-C80107 mark 
   #FUN-D30024 -------Begin---------
   #INITIALIZE g_sma894 TO NULL                                                         #FUN-C80107
   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_imn.imn04) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
   #IF l_qoh < p_imn.imn10*l_factor AND g_sma894 = 'N' THEN                             #FUN-C80107
   INITIALIZE l_imd23 TO NULL 
   CALL s_inv_shrt_by_warehouse(p_imn.imn04,g_plant) RETURNING l_imd23                        #FUN-D30024 #TQC-D40078 g_plant
   IF l_qoh < p_imn.imn10*l_factor AND l_imd23 = 'N' THEN
   #FUN-D30024 -------End-----------
      LET l_msg = 'Line#',p_imn.imn02 USING '<<<',' ',
                   p_imn.imn03 CLIPPED,'-> QOH < 0 '
      CALL cl_err(l_msg,'mfg-075',1)   
      LET g_success='N' RETURN
   END IF 
END FUNCTION

#處理異動記錄
FUNCTION t324sub_log_2(p_stdc,p_reason,p_code,p_imn,p_imm)
   DEFINE p_stdc      LIKE type_file.num5,      #是否需取得標準成本  #No.FUN-690026 SMALLINT
          p_reason    LIKE type_file.num5,      #是否需取得異動原因  #No.FUN-690026 SMALLINT
          p_code      LIKE type_file.chr1,      #出/入庫  #No.FUN-690026 VARCHAR(1)
          p_imn       RECORD LIKE imn_file.*
   DEFINE l_img09     LIKE img_file.img09,
          l_factor    LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
          l_qty       LIKE img_file.img10
   #DEV-D30046 --add--begin
   DEFINE p_imm       RECORD LIKE imm_file.*
   DEFINE l_cnt       LIKE type_file.num5
   #DEV-D30046 --add--end

   LET l_qty=0
   SELECT img09 INTO l_img09 FROM img_file
      WHERE img01=p_imn.imn03 AND img02=p_imn.imn15
        AND img03=p_imn.imn16 AND img04=p_imn.imn17
   CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_imn.imn10 * l_factor


   #----來源----
   LET g_tlf.tlf01=p_imn.imn03                 #異動料件編號
   LET g_tlf.tlf02=50                          #來源為倉庫(撥出)
   LET g_tlf.tlf020=g_plant                    #工廠別
   LET g_tlf.tlf021=p_imn.imn04                #倉庫別
   LET g_tlf.tlf022=p_imn.imn05                #儲位別
   LET g_tlf.tlf023=p_imn.imn06                #批號
   LET g_tlf.tlf024=g_img10 - p_imn.imn10      #異動後庫存數量
   LET g_tlf.tlf025=p_imn.imn09                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=p_imn.imn01                #調撥單號
   LET g_tlf.tlf027=p_imn.imn02                #項次
   #----目的----
   LET g_tlf.tlf03=50                          #資料目的為(撥入)
   LET g_tlf.tlf030=g_plant                    #工廠別
   LET g_tlf.tlf031=p_imn.imn15                #倉庫別
   LET g_tlf.tlf032=p_imn.imn16                #儲位別
   LET g_tlf.tlf033=p_imn.imn17                #批號
    LET g_tlf.tlf034=g_img10_2 + l_qty          #異動後庫存量    #-No:MOD-57002
   LET g_tlf.tlf035=p_imn.imn20                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=p_imn.imn01                #參考號碼
   LET g_tlf.tlf037=p_imn.imn02                #項次

   #---- 97/06/20 調撥作業來源目的碼
   IF p_code='1' THEN #-- 出
      LET g_tlf.tlf02=50
      LET g_tlf.tlf03=99
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '
      LET g_tlf.tlf032=' '
      LET g_tlf.tlf033=' '
      LET g_tlf.tlf034=0
      LET g_tlf.tlf035=' '
      LET g_tlf.tlf036=' '
      LET g_tlf.tlf037=0
      LET g_tlf.tlf10=p_imn.imn10                 #調撥數量
      LET g_tlf.tlf11=p_imn.imn09                 #撥出單位
      LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
      LET g_tlf.tlf930=p_imn.imn9301  #FUN-670093
   ELSE               #-- 入
      LET g_tlf.tlf02=99
      LET g_tlf.tlf03=50
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '
      LET g_tlf.tlf022=' '
      LET g_tlf.tlf023=' '
      LET g_tlf.tlf024=0
      LET g_tlf.tlf025=' '
      LET g_tlf.tlf026=' '
      LET g_tlf.tlf027=0
      LET g_tlf.tlf10=p_imn.imn22                 #調撥數量
      LET g_tlf.tlf11=p_imn.imn20                 #撥入單位
      LET g_tlf.tlf12=1                           #撥入/撥出庫存轉換率
      LET g_tlf.tlf930=p_imn.imn9302  #FUN-670093
   END IF

   #--->異動數量
   LET g_tlf.tlf04=' '                         #工作站
   LET g_tlf.tlf05=' '                         #作業序號
   #LET g_tlf.tlf06=p_imm.imm02                 #發料日期  #FUN-D40053
   LET g_tlf.tlf06=p_imm.imm17  #FUN-D40053
   LET g_tlf.tlf07=g_today                     #異動資料產生日期
   LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user                      #產生人
   LET g_tlf.tlf13='aimt324'                   #異動命令代號
   LET g_tlf.tlf14=p_imn.imn28                 #異動原因
   LET g_tlf.tlf15=g_debit                     #借方會計科目
   LET g_tlf.tlf16=g_credit                    #貸方會計科目
   LET g_tlf.tlf17=p_imm.imm09                 #remark
   CALL s_imaQOH(p_imn.imn03)
        RETURNING g_tlf.tlf18                  #異動後總庫存量
   #LET g_tlf.tlf19= ' '                        #異動廠商/客戶編號      #MOD-A80004 mark
   LET g_tlf.tlf19= p_imm.imm14                #異動廠商/客戶編號      #MOD-A80004 add
   LET g_tlf.tlf20= ' '                        #project no.
   CALL s_tlf(p_stdc,p_reason)
END FUNCTION

FUNCTION t324sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       #p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_imm02) #FUN-D40053
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_imm17)  #FUN-D40053
   DEFINE p_imgg00     LIKE imgg_file.imgg00,
          p_imgg01     LIKE imgg_file.imgg01,
          p_imgg02     LIKE imgg_file.imgg02,
          p_imgg03     LIKE imgg_file.imgg03,
          p_imgg04     LIKE imgg_file.imgg04,
          p_imgg09     LIKE imgg_file.imgg09,
          p_imgg211    LIKE imgg_file.imgg211,
          p_imgg10     LIKE imgg_file.imgg10,
          p_no         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_ima25      LIKE ima_file.ima25,
          l_ima906     LIKE ima_file.ima906,
          l_imgg21     LIKE imgg_file.imgg21,
          p_type       LIKE type_file.num10    #No.FUN-690026 INTEGER
   #DEV-D30046 --add--begin
   #DEFINE p_imm02      LIKE imm_file.imm02  #FUN-D40053
   DEFINE p_imm17      LIKE imm_file.imm17  #FUN-D40053
   DEFINE l_forupd_sql STRING 
   DEFINE l_cnt        LIKE type_file.num5
   #DEV-D30046 --add--end

    LET l_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    DECLARE imgg_lock CURSOR FROM l_forupd_sql

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
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                    "ima25 null",1)   #No:FUN-660156 
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF

    #CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_imm02,  #FUN-8C0084  #FUN-D40053
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_imm17, #FUN-D40053
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
END FUNCTION

FUNCTION t324sub_tlff_1(p_flag,p_imn,p_type,p_imm)
   DEFINE p_imn      RECORD LIKE imn_file.*,
          p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_imgg10_s LIKE imgg_file.imgg10,
          l_imgg10_t LIKE imgg_file.imgg10
   #DEV-D30046 --add--begin
   DEFINE p_imm      RECORD LIKE imm_file.*
   #DEV-D30046 --add--end

    IF p_imn.imn33 IS NULL THEN
       CALL cl_err('p_imn33 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    IF p_imn.imn43 IS NULL THEN
       CALL cl_err('p_imn43 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

 
    INITIALIZE g_tlff.* TO NULL
    SELECT imgg10 INTO l_imgg10_s FROM imgg_file
     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
       AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
       AND imgg09=p_imn.imn33
    IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
 
    SELECT imgg10 INTO l_imgg10_t FROM imgg_file
     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
       AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
       AND imgg09=p_imn.imn43
    IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF

    LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
    #----來源----
    LET g_tlff.tlff02=50                          #來源為倉庫(撥出)
    LET g_tlff.tlff020=g_plant                    #工廠別
    LET g_tlff.tlff021=p_imn.imn04              #倉庫別
    LET g_tlff.tlff022=p_imn.imn05              #儲位別
    LET g_tlff.tlff023=p_imn.imn06              #批號
    LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn35     #異動後庫存數量
    LET g_tlff.tlff025=p_imn.imn33                #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=p_imn.imn01                #調撥單號
    LET g_tlff.tlff027=p_imn.imn02                #項次
#----目的----
    LET g_tlff.tlff03=50                          #資料目的為(撥入)
    LET g_tlff.tlff030=g_plant                    #工廠別
    LET g_tlff.tlff031=p_imn.imn15                #倉庫別
    LET g_tlff.tlff032=p_imn.imn16                #儲位別
    LET g_tlff.tlff033=p_imn.imn17              #批號
    LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn44     #異動後庫存量
    LET g_tlff.tlff035=p_imn.imn43              #庫存單位(ima_file or img_file)
    LET g_tlff.tlff036=p_imn.imn01                #參考號碼
    LET g_tlff.tlff037=p_imn.imn02                #項次

    #---- 97/06/20 調撥作業來源目的碼
    IF p_type=-1 THEN #-- 出
       LET g_tlff.tlff02=50
       LET g_tlff.tlff03=99
       LET g_tlff.tlff030=' '
       LET g_tlff.tlff031=' '
       LET g_tlff.tlff032=' '
       LET g_tlff.tlff033=' '
       LET g_tlff.tlff034=0
       LET g_tlff.tlff035=' '
       LET g_tlff.tlff036=' '
       LET g_tlff.tlff037=0
       LET g_tlff.tlff10=p_imn.imn35                 #調撥數量
       LET g_tlff.tlff11=p_imn.imn33                 #撥出單位
       LET g_tlff.tlff12=p_imn.imn34                 #撥出/撥入庫存轉換率
       LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
    ELSE               #-- 入
       LET g_tlff.tlff02=99
       LET g_tlff.tlff03=50
       LET g_tlff.tlff020=' '
       LET g_tlff.tlff021=' '
       LET g_tlff.tlff022=' '
       LET g_tlff.tlff023=' '
       LET g_tlff.tlff024=0
       LET g_tlff.tlff025=' '
       LET g_tlff.tlff026=' '
       LET g_tlff.tlff027=0
       LET g_tlff.tlff10=p_imn.imn45                 #調撥數量
       LET g_tlff.tlff11=p_imn.imn43                 #撥入單位
       LET g_tlff.tlff12=p_imn.imn44                 #撥入/撥出庫存轉換率
       LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
    END IF

#--->異動數量
    LET g_tlff.tlff04=' '                         #工作站
    LET g_tlff.tlff05=' '                         #作業序號
    #LET g_tlff.tlff06=p_imm.imm02                 #發料日期 #FUN-D40053
    LET g_tlff.tlff06=p_imm.imm17  #FUN-D40053
    LET g_tlff.tlff07=g_today                     #異動資料產生日期
    LET g_tlff.tlff08=TIME                        #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                      #產生人
    LET g_tlff.tlff13='aimt324'                   #異動命令代號
    LET g_tlff.tlff14=p_imn.imn28                 #異動原因
    LET g_tlff.tlff15=g_debit                     #借方會計科目
    LET g_tlff.tlff16=g_credit                    #貸方會計科目
    LET g_tlff.tlff17=p_imm.imm09                 #remark
   #LET g_tlff.tlff19= ' '                        #異動廠商/客戶編號    #MOD-A80004 mark
    LET g_tlff.tlff19= p_imm.imm14                #異動廠商/客戶編號    #MOD-A80004 add
    LET g_tlff.tlff20= ' '                        #project no.
    IF p_type=-1 THEN
       IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_imn.imn33)
       END IF
    ELSE
       IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_imn.imn43)
       END IF
    END IF
END FUNCTION

FUNCTION t324sub_tlff_2(p_flag,p_imn,p_type,p_imm)
   DEFINE p_imn      RECORD LIKE imn_file.*,
          p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_imgg10_s LIKE imgg_file.imgg10,
          l_imgg10_t LIKE imgg_file.imgg10
   #DEV-D30046 --add--begin
   DEFINE p_imm      RECORD LIKE imm_file.*
   #DEV-D30046 --add--end

    IF p_imn.imn30 IS NULL THEN
       CALL cl_err('p_imn30 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    IF p_imn.imn40 IS NULL THEN
       CALL cl_err('p_imn40 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    INITIALIZE g_tlff.* TO NULL
    SELECT imgg10 INTO l_imgg10_s FROM imgg_file
     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
       AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
       AND imgg09=p_imn.imn30
    IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
 
    SELECT imgg10 INTO l_imgg10_t FROM imgg_file
     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
       AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
       AND imgg09=p_imn.imn40
    IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF

    LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
    #----來源----
    LET g_tlff.tlff02=50                                #來源為倉庫(撥出)
    LET g_tlff.tlff020=g_plant                    #工廠別
    LET g_tlff.tlff021=p_imn.imn04              #倉庫別
    LET g_tlff.tlff022=p_imn.imn05              #儲位別
    LET g_tlff.tlff023=p_imn.imn06              #批號
    LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn31     #異動後庫存數量
    LET g_tlff.tlff025=p_imn.imn30                #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=p_imn.imn01                #調撥單號
    LET g_tlff.tlff027=p_imn.imn02                #項次
#----目的----
    LET g_tlff.tlff03=50                                #資料目的為(撥入)
    LET g_tlff.tlff030=g_plant                    #工廠別
    LET g_tlff.tlff031=p_imn.imn15                #倉庫別
    LET g_tlff.tlff032=p_imn.imn16                #儲位別
    LET g_tlff.tlff033=p_imn.imn17              #批號
    LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn41     #異動後庫存量
    LET g_tlff.tlff035=p_imn.imn40              #庫存單位(ima_file or img_file)
    LET g_tlff.tlff036=p_imn.imn01                #參考號碼
    LET g_tlff.tlff037=p_imn.imn02                #項次

    #---- 97/06/20 調撥作業來源目的碼
    IF p_type=-1 THEN #-- 出
       LET g_tlff.tlff02=50
       LET g_tlff.tlff03=99
       LET g_tlff.tlff030=' '
       LET g_tlff.tlff031=' '
       LET g_tlff.tlff032=' '
       LET g_tlff.tlff033=' '
       LET g_tlff.tlff034=0
       LET g_tlff.tlff035=' '
       LET g_tlff.tlff036=' '
       LET g_tlff.tlff037=0
       LET g_tlff.tlff10=p_imn.imn32                 #調撥數量
       LET g_tlff.tlff11=p_imn.imn30                 #撥出單位
       LET g_tlff.tlff12=p_imn.imn31                 #撥出/撥入庫存轉換率
       LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
    ELSE               #-- 入
       LET g_tlff.tlff02=99
       LET g_tlff.tlff03=50
       LET g_tlff.tlff020=' '
       LET g_tlff.tlff021=' '
       LET g_tlff.tlff022=' '
       LET g_tlff.tlff023=' '
       LET g_tlff.tlff024=0
       LET g_tlff.tlff025=' '
       LET g_tlff.tlff026=' '
       LET g_tlff.tlff027=0
       LET g_tlff.tlff10=p_imn.imn42                 #調撥數量
       LET g_tlff.tlff11=p_imn.imn40                 #撥入單位
       LET g_tlff.tlff12=p_imn.imn41                 #撥入/撥出庫存轉換率
       LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
    END IF

#--->異動數量
    LET g_tlff.tlff04=' '                         #工作站
    LET g_tlff.tlff05=' '                         #作業序號
    #LET g_tlff.tlff06=p_imm.imm02                 #發料日期  #FUN-D40053
    LET g_tlff.tlff06=p_imm.imm17  #FUN-D40053
    LET g_tlff.tlff07=g_today                     #異動資料產生日期
    LET g_tlff.tlff08=TIME                        #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                      #產生人
    LET g_tlff.tlff13='aimt324'                   #異動命令代號
    LET g_tlff.tlff14=p_imn.imn28                 #異動原因
    LET g_tlff.tlff15=g_debit                     #借方會計科目
    LET g_tlff.tlff16=g_credit                    #貸方會計科目
    LET g_tlff.tlff17=p_imm.imm09                 #remark
   #LET g_tlff.tlff19= ' '                        #異動廠商/客戶編號    #MOD-A80004 mark
    LET g_tlff.tlff19= p_imm.imm14                #異動廠商/客戶編號    #MOD-A80004 add
    LET g_tlff.tlff20= ' '                        #project no.
    IF p_type=-1 THEN
       IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_imn.imn33)
       END IF
    ELSE
       IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_imn.imn43)
       END IF
    END IF
END FUNCTION
#DEV-D30046 --add--end
