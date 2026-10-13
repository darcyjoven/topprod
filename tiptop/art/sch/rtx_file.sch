/*
================================================================================
檔案代號:rtx_file
檔案名稱:采购协议调整单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtx_file
(
rtx01       varchar2(20) DEFAULT ' ' NOT NULL, /*协议调整单号*/
rtx02       varchar2(10) DEFAULT ' ' NOT NULL, /*调整机构*/
rtx03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtx04       varchar2(40),            /*产品编号                               */
rtx05       varchar2(4),             /*库存单位                               */
rtx06       number(20,6),            /*原采购价                               */
rtx07       number(5,2),             /*调价比例%                              */
rtx08       number(20,6),            /*新采购价                               */
rtx09       number(5),               /*采购量满                               */
rtx10       number(5),               /*采购额满                               */
rtx11       number(5),               /*可打赠量                               */
rtx12       number(5,2),             /*可折扣率%                              */
rtx13       number(5,2),             /*原结算扣率%                            */
rtx14       number(5,2),             /*新结算扣率%                            */
rtx15       number(5),               /*原最低采购量                           */
rtx16       number(5),               /*新最低采购量                           */
rtx17       number(5),               /*原采购倍量                             */
rtx18       number(5),               /*新采购倍量                             */
rtx19       varchar2(1),             /*原有效否                               */
rtx20       varchar2(1),             /*新有效否                               */
rtxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtxplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rtx_file add  constraint rtx_pk primary key  (rtx01,rtx02,rtx03) enable validate;
grant select on rtx_file to tiptopgp;
grant update on rtx_file to tiptopgp;
grant delete on rtx_file to tiptopgp;
grant insert on rtx_file to tiptopgp;
grant index on rtx_file to public;
grant select on rtx_file to ods;
