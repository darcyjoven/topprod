/*
================================================================================
檔案代號:bgm_file
檔案名稱:销货预算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgm_file
(
bgm01       varchar2(10) NOT NULL,   /*版本                                   */
bgm012      varchar2(10) NOT NULL,   /*地区编号                               */
                                     /*地區編號                               */
bgm013      varchar2(10) NOT NULL,   /*业务员编号                             */
                                     /*業務員編號                             */
bgm014      varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
bgm015      varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
bgm016      varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
bgm017      varchar2(40) NOT NULL,   /*产品别/品号                            */
                                     /*產品別/品號                            */
bgm02       number(5) NOT NULL,      /*预算销售年度                           */
                                     /*預算銷售年度                           */
bgm03       number(5) NOT NULL,      /*预算销售期别                           */
                                     /*預算銷售期別                           */
bgm04       number(20,6),            /*单价                                   */
                                     /*單價                                   */
bgm05       number(20,6),            /*预算销量                               */
                                     /*預算銷量                               */
bgm06       date,                    /*应收帐款日                             */
                                     /*應收帳款日 add in 2003/10/15  No.8563  */
bgm07       date,                    /*票到期日                               */
                                     /*票到期日   add in 2003/10/15  no.8563  */
bgm08       varchar2(4) NOT NULL,    /*销售单位                               */
                                     /*銷售單位   No.8563 031027              */
bgm08_fac   number(20,8) NOT NULL,   /*销售单位/库存单位换算率                */
                                     /*銷售單位/庫存單位換算率 No.8563 031027 */
bgm091      number(20,6),            /*材料单价                               */
                                     /*材料單價 No.8563 031030                */
bgm092      number(20,6),            /*人工单价                               */
                                     /*人工單價 No.8563 031030                */
bgm093      number(20,6),            /*制费单价                               */
                                     /*製費單價 No.8563 031030                */
bgm094      number(20,6)             /*加工单价                               */
                                     /*加工單價 No.8563 031030                */
);

alter table bgm_file add  constraint bgm_pk primary key  (bgm01,bgm012,bgm013,bgm014,bgm015,bgm016,bgm017,bgm08,bgm08_fac,bgm02,bgm03) enable validate;
grant select on bgm_file to tiptopgp;
grant update on bgm_file to tiptopgp;
grant delete on bgm_file to tiptopgp;
grant insert on bgm_file to tiptopgp;
grant index on bgm_file to public;
grant select on bgm_file to ods;
