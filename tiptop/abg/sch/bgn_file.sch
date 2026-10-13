/*
================================================================================
檔案代號:bgn_file
檔案名稱:生产预算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgn_file
(
bgn01       varchar2(10) NOT NULL,   /*版本                                   */
bgn012      varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
bgn013      varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
bgn014      varchar2(40) NOT NULL,   /*产品别/品号                            */
                                     /*產品別/品號                            */
bgn02       number(5) NOT NULL,      /*预算生产年度                           */
                                     /*預算生產年度                           */
bgn03       number(5) NOT NULL,      /*预算生产期别                           */
                                     /*預算生產期別                           */
bgn04       number(15,3),            /*预算生产数量                           */
                                     /*預算生產數量                           */
bgn05       number(20,6),            /*材料单价                               */
                                     /*材料單價                               */
bgn06       number(20,6),            /*人工单价                               */
                                     /*人工單價                               */
bgn07       number(20,6),            /*制费单价                               */
                                     /*製費單價                               */
bgn08       number(20,6),            /*加工单价                               */
                                     /*加工單價                               */
bgn09       varchar2(1),             /*No Use                                 */
bgn10       varchar2(1),             /*No Use                                 */
bgn11       varchar2(4) NOT NULL,    /*生产单位                               */
                                     /*生產單位   No.8563 031030              */
bgn11_fac   number(20,8) NOT NULL    /*生产单位/库存单位换算率                */
                                     /*生產單位/庫存單位換算率 No.8563 031030 */
);

alter table bgn_file add  constraint bgn_pk primary key  (bgn01,bgn012,bgn013,bgn014,bgn02,bgn11,bgn11_fac,bgn03) enable validate;
grant select on bgn_file to tiptopgp;
grant update on bgn_file to tiptopgp;
grant delete on bgn_file to tiptopgp;
grant insert on bgn_file to tiptopgp;
grant index on bgn_file to public;
grant select on bgn_file to ods;
