/*
================================================================================
檔案代號:rtt_file
檔案名稱:采购协议单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtt_file
(
rtt01       varchar2(20) DEFAULT ' ' NOT NULL, /*协议编号*/
rtt02       varchar2(10) DEFAULT ' ' NOT NULL, /*签订机构*/
rtt03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtt04       varchar2(40),            /*产品编号                               */
rtt05       varchar2(4),             /*库存单位                               */
rtt06       number(20,6),            /*税前单价                               */
rtt06t      number(20,6),            /*含税单价                               */
rtt07       number(5),               /*采购量满                               */
rtt08       number(5),               /*采购额满                               */
rtt09       number(5),               /*可搭赠量                               */
rtt10       number(5,2),             /*可折扣率%                              */
rtt11       number(5,2),             /*结算扣率%                              */
rtt12       number(5),               /*最低采购量                             */
rtt13       number(5),               /*采购倍量                               */
rtt14       varchar2(4),             /*默认采购单位                           */
rtt15       varchar2(1),             /*有效否                                 */
rttlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rttplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rtt16       number(5) DEFAULT '0' NOT NULL /*协议版本号*/
);

alter table rtt_file add  constraint rtt_pk primary key  (rtt01,rtt02,rtt16,rtt03,rttplant) enable validate;
grant select on rtt_file to tiptopgp;
grant update on rtt_file to tiptopgp;
grant delete on rtt_file to tiptopgp;
grant insert on rtt_file to tiptopgp;
grant index on rtt_file to public;
grant select on rtt_file to ods;
