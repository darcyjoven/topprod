# Prog. Version..: '5.00.11-08.12.31(00002)'     #
#
# Program name...: cl_prt_aps.4gl
# Descriptions...: APS(DB:SQL Server 2005) Report ->CR 
# Date & Author..: 2007/05/31 by CoCo
# Usage..........: CALL cl_prt_aps('apsr001','apsr006',g_sql,'')
# Modify.........: No:FUN-750147 07/06/01 By coco for aps report
# Modify.........: No:FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-8C0025 08/12/29 By tsai_yen 因為function lib_cl_prt.cl_prt_cs3_t的回傳參數改了

IMPORT util
DATABASE ds       

GLOBALS "../../config/top.global"    #FUN-7C0053

GLOBALS
END GLOBALS

FUNCTION cl_prt_aps(p_prog,p_rep_template,p_sql,param_str)
    DEFINE p_prog                    LIKE zaw_file.zaw01, ## FUN-750147 ## 
           p_rep_template            LIKE zaw_file.zaw02,  
           p_rpt_name                LIKE zaw_file.zaw08,  
           p_cust                    LIKE zaw_file.zaw03,  
           p_rpt_path                LIKE zax_file.zax03,                    
           p_sql_zax                 LIKE zax_file.zax04,                   
           param1_zax                LIKE zax_file.zax05,                   
           param2_zax                LIKE zax_file.zax06,                   
           param3_zax                LIKE zax_file.zax07,                   
           l_trans_lang              LIKE zax_file.zax08,                   
           l_logo                    LIKE zax_file.zax09,                   
           l_tab_list                LIKE zax_file.zax10,                   
           l_rep_db,l_instance       STRING,                            
           l_rep_db_pw,l_str_ord     STRING,                            
           p_sql                     STRING,                 
           l_url,l_str,param_str     STRING,               
           l_modul                   LIKE zz_file.zz011,     
           l_saz10                   LIKE aps_saz.saz10,     
           l_gaz03                   LIKE gaz_file.gaz03,    
           l_certid,crip             STRING,                 
           li_status,res             LIKE type_file.num10,   
           i,l_cnt_param,certid      LIKE type_file.num5,    
           l_tok_param               base.StringTokenizer,        
           param_array               DYNAMIC ARRAY OF STRING
           ###FUN-8C0025 START ###
           DEFINE l_zaw   RECORD             
                  zaw04 LIKE zaw_file.zaw04,                   #權限類別
                  zaw05 LIKE zaw_file.zaw05                    #使用者   
                  END RECORD
           ###FUN-8C0025 END ###

    # 背景作業
    #IF g_bgjob = 'Y' THEN RETURN 1 END IF
    #CALL cl_prt_cs3_t(p_prog,p_rep_template) RETURNING p_cust,p_rpt_name #FUN-8C0025 mark
    CALL cl_prt_cs3_t(p_prog,p_rep_template) RETURNING p_cust,l_zaw.zaw04,l_zaw.zaw05,p_rpt_name #FUN-8C0025
    SELECT zz011 INTO l_modul FROM zz_file where zz01 = g_prog
    IF p_cust = 'Y' THEN
       LET p_rpt_path="topcust/",DOWNSHIFT(l_modul) CLIPPED,"/",p_prog CLIPPED,"/",g_rlang CLIPPED,"/",p_rpt_name CLIPPED,".rpt"
    ELSE 
       LET p_rpt_path="tiptop/",DOWNSHIFT(l_modul) CLIPPED,"/",p_prog CLIPPED,"/",g_rlang CLIPPED,"/",p_rpt_name CLIPPED,".rpt"
    END IF
 
    LET p_sql_zax = p_sql CLIPPED    
    SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = g_prog AND gaz02=g_rlang

    ### param1-param10###
    LET l_tok_param = base.StringTokenizer.createExt(param_str,";","",TRUE)
    LET l_cnt_param = l_tok_param.countTokens()
    IF l_cnt_param>0 THEN
       CALL param_array.clear()
       LET i=0
       WHILE l_tok_param.hasMoreTokens()
          #DISPLAY l_tok_table.nextToken()
          LET i=i+1
          LET param_array[i] =cl_prt_trans_str(l_tok_param.nextToken())
       END WHILE 
    END IF
    ### Get certificate_ID ###
    LET certid = util.Math.rand(99999)
    LET param2_zax = param_array[1] CLIPPED,"|",param_array[2] CLIPPED,"|",    
                     param_array[3] CLIPPED,"|",param_array[4] CLIPPED,"|",    
                     param_array[5] CLIPPED,"|",param_array[6] CLIPPED,"|",    
                     param_array[7] CLIPPED,"|",param_array[8] CLIPPED,"|",    
                     param_array[9] CLIPPED,"|",param_array[10] CLIPPED
    LET param3_zax = param_array[11] CLIPPED,"|",param_array[12] CLIPPED,"|",    
                     param_array[13] CLIPPED,"|",param_array[14] CLIPPED,"|",    
                     param_array[15] CLIPPED,"|",param_array[16] CLIPPED,"|",    
                     param_array[17] CLIPPED,"|",param_array[18] CLIPPED,"|",    
                     param_array[19] CLIPPED,"|",param_array[20] CLIPPED
    LET param1_zax =g_company CLIPPED,"|",l_gaz03 CLIPPED,"|",g_pdate,"|",TIME,"|",g_user,"|",g_prog 
    LET l_trans_lang = cl_prt_cr_trans_lang()
    LET l_logo = FGL_GETENV("FGLASIP") || "/tiptop/pic/pdf_logo_",g_dbs CLIPPED,g_rlang,".jpg"  ### FUN-750016 ###

    ### aps運用中,把zax10存放sql server的IP ###
    SELECT saz10 INTO l_saz10 FROM aps_saz where 1 = 1
    IF cl_null(l_saz10) THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','','aps-005',1)
      ELSE
         CALL cl_err('','aps-005',1)
      END IF
      RETURN
    ELSE
       LET l_tab_list = l_saz10 CLIPPED
    END IF

    INSERT INTO zax_file values(certid,g_user,p_rpt_path,p_sql_zax,param1_zax,param2_zax,param3_zax,l_trans_lang,l_logo,l_tab_list)  ###FUN-750092###
    #display "certid:",certid
    #display "p_rpt_path:",p_rpt_path
    #display "p_sql_zax:",p_sql_zax
    #display "param1_zax:",param1_zax
    #display "param2_zax:",param2_zax
    #display "param3_zax:",param3_zax
    #display "l_trans_lang:",l_trans_lang
    #display "l_logo:",l_logo
    #display "l_tab_list:",l_tab_list 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","zax_file",certid,"",SQLCA.sqlcode,"","",0)
       RETURN
    END IF

    LET l_rep_db = g_dbs CLIPPED
    LET l_str = "dbi.database.", g_dbs CLIPPED, ".password"
    LET l_rep_db_pw = fgl_getresource(l_str) CLIPPED
    LET l_instance = fgl_getenv('ORACLE_SID') CLIPPED
    ### report_DB ###
    LET l_str = ""
    FOR i=1 TO l_rep_db.getLength()
        LET l_str_ord = ORD(l_rep_db.subString(i,i))
        IF i=1 THEN 
           LET l_str = l_str_ord.trim() 
        ELSE 
           LET l_str = l_str.trim() ,'|',l_str_ord.trim() 
        END IF
    END FOR
    #display "db:",l_str 
    LET l_rep_db = l_str.trim()
    ### report_DB_PW ###
    LET l_str = ""
    FOR i=1 TO l_rep_db_pw.getLength()
        LET l_str_ord = ORD(l_rep_db_pw.subString(i,i))
        IF i=1 THEN 
           LET l_str = l_str_ord.trim() 
        ELSE 
           LET l_str = l_str.trim() ,'|',l_str_ord.trim() 
        END IF
    END FOR
    #display "db_pass:",l_str 
    LET l_rep_db_pw = l_str.trim()
    ### report_DB_instance ###
    LET l_str = ""
    FOR i=1 TO l_instance.getLength()
        LET l_str_ord = ORD(l_instance.subString(i,i))
        IF i=1 THEN 
           LET l_str = l_str_ord.trim() 
        ELSE 
           LET l_str = l_str.trim() ,'|',l_str_ord.trim() 
        END IF
    END FOR
    #display "instance:",l_str 
    LET l_instance = l_str.trim()

   # LET crip = "http://10.40.16.4/CR115/"
    LET crip = fgl_getenv("CRIP")   # Crystal report Server IP
    LET l_trans_lang = cl_prt_cr_trans_lang() 
    LET l_certid = certid
    LET l_certid = l_certid.trim() 
    LET l_url = crip CLIPPED,"Default_aps.aspx?certid=",l_certid            
    LET l_url = l_url CLIPPED,"&t=",l_rep_db,"&t1=",l_rep_db_pw,"&t2=",l_instance
    LET l_str="about:blank"            
    CALL ui.Interface.frontCall("standard","shellexec", [l_str], [res])
    CALL ui.Interface.frontCall("standard","shellexec", [l_url], [res])
END FUNCTION
