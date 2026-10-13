/*
================================================================================
檔案代號:rxo_file
檔案名稱:赠品发放/退还交易单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxo_file
(
rxo00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type1-Premiums Release 2-Premiums Return*/
rxo01       varchar2(20) DEFAULT ' ' NOT NULL, /*发放/退还单号*/
rxo02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxo03       varchar2(40),            /*赠品编号                               */
rxo04       varchar2(10),            /*仓库                                   */
rxo05       varchar2(4),             /*单位                                   */
rxo06       number(16,8),            /*单位换算率                             */
rxo07       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
rxo08       number(15,3) DEFAULT '0' NOT NULL, /*已退还量*/
rxo09       number(20,6) DEFAULT '0' NOT NULL, /*换赠单价*/
rxo10       number(20,6) DEFAULT '0' NOT NULL, /*换赠金额*/
rxo11       varchar2(20),            /*促销单号                               */
rxo12       varchar2(1),             /*促销哦类型                             */
                                     /*Promotion Type 1-Assembly Promotion 2-Full Amount Promotion*/
rxo13       varchar2(255),           /*備注                                   */
rxolegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxoplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rxo14       varchar2(20)             /*来源单号                               */
);

alter table rxo_file add  constraint rxo_pk primary key  (rxo00,rxo01,rxo02,rxoplant) enable validate;
grant select on rxo_file to tiptopgp;
grant update on rxo_file to tiptopgp;
grant delete on rxo_file to tiptopgp;
grant insert on rxo_file to tiptopgp;
grant index on rxo_file to public;
grant select on rxo_file to ods;
