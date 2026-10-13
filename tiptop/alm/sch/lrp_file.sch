/*
================================================================================
檔案代號:lrp_file
檔案名稱:積分/折扣規則單頭檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrp_file
(
lrp00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
lrp01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lrp02       varchar2(1) DEFAULT ' ' NOT NULL, /*规则方式*/
lrp03       varchar2(1) DEFAULT ' ' NOT NULL, /*排除方式*/
lrppos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
lrp04       date DEFAULT sysdate NOT NULL, /*生效日期*/
lrp05       date DEFAULT sysdate NOT NULL, /*失效日期*/
lrp06       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lrp07       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lrp08       number(5) DEFAULT '0' NOT NULL, /*版本号*/
lrp09       varchar2(1) DEFAULT 'N' NOT NULL, /*发布否*/
lrp10       date,                    /*发布日期                               */
lrp11       varchar2(1) DEFAULT '1' NOT NULL, /*折扣方式*/
lrpacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lrpcond     date,                    /*审核日期                               */
lrpconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
lrpconu     varchar2(10),            /*审核人员                               */
lrpcrat     date,                    /*资料创建日                             */
lrpdate     date,                    /*最近更改日                             */
lrpgrup     varchar2(10),            /*资料所有群                             */
lrplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lrpmodu     varchar2(10),            /*资料更改者                             */
lrporig     varchar2(10),            /*资料建立部门                           */
lrporiu     varchar2(10),            /*资料建立者                             */
lrpplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lrpuser     varchar2(10)             /*资料所有者                             */
);

alter table lrp_file add  constraint lrp_pk primary key  (lrp06,lrp07,lrp08,lrpplant) enable validate;
grant select on lrp_file to tiptopgp;
grant update on lrp_file to tiptopgp;
grant delete on lrp_file to tiptopgp;
grant insert on lrp_file to tiptopgp;
grant index on lrp_file to public;
grant select on lrp_file to ods;
