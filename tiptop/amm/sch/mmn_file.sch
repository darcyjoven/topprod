/*
================================================================================
檔案代號:mmn_file
檔案名稱:开发运行单其它费用资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmn_file
(
mmn01       varchar2(20) NOT NULL,   /*开发运行单编号                         */
                                     /*開發執行單編號(開發案號)(mmg01)        */
mmn02       varchar2(20) NOT NULL,   /*运行工单编号                           */
                                     /*執行工單編號(mmg02)                    */
mmn03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
mmn04       varchar2(80),            /*费用说明                               */
                                     /*費用說明                               */
mmn05       number(20,6),            /*金额                                   */
                                     /*金額                                   */
mmnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table mmn_file add  constraint mmn_pk primary key  (mmn01,mmn02,mmn03) enable validate;
grant select on mmn_file to tiptopgp;
grant update on mmn_file to tiptopgp;
grant delete on mmn_file to tiptopgp;
grant insert on mmn_file to tiptopgp;
grant index on mmn_file to public;
grant select on mmn_file to ods;
