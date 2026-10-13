/*
================================================================================
檔案代號:gds_file
檔案名稱:XtraGrid 报表样版记录单身文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gds_file
(
gds00       number(5) DEFAULT '0' NOT NULL,
gds01       number(5) DEFAULT '0' NOT NULL, /*序号*/
gds02       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gds03       varchar2(20),            /*字段编号                               */
gds04       varchar2(255),           /*字段说明                               */
gds05       number(5),               /*行序                                   */
gds06       number(5),               /*字段顺序                               */
gds07       varchar2(1) DEFAULT ' ' NOT NULL,
gds08       varchar2(1) DEFAULT ' ' NOT NULL,
gds09       varchar2(1) DEFAULT ' ' NOT NULL,
gds10       varchar2(1) DEFAULT ' ' NOT NULL,
gds11       number(5),
gds12       varchar2(1) DEFAULT ' ' NOT NULL,
gds13       varchar2(20),
gds14       varchar2(1) DEFAULT 'Y' NOT NULL,
gds15       varchar2(1) DEFAULT ' ' NOT NULL, /*字段类型*/
gds16       varchar2(1) DEFAULT 'N' NOT NULL,
gds17       varchar2(1) DEFAULT ' ' NOT NULL,
gds18       number(5),
gds19       varchar2(255),
gds20       varchar2(1) DEFAULT ' ' NOT NULL,
gds21       varchar2(1) DEFAULT 'N' NOT NULL,
gds22       varchar2(1) DEFAULT 'N' NOT NULL,
gds23       varchar2(1),
gds24       number(5),
gds25       varchar2(1) DEFAULT ' ' NOT NULL,
gds26       varchar2(1) DEFAULT ' ' NOT NULL,
gds27       varchar2(1) DEFAULT ' ' NOT NULL,
gds28       varchar2(20),
gds29       number(15,3),            /*字段宽度                               */
gds30       varchar2(1) DEFAULT ' ' NOT NULL,
gds31       varchar2(20),            /*条件隐藏栏位                           */
gds32       varchar2(1) DEFAULT ' ' NOT NULL, /*可设为取位栏位*/
gds33       number(15,3),
gds34       varchar2(1000),          /*可设为条件隐藏栏位                     */
gds35       varchar2(255),           /*总计取位对应栏位                       */
gds36       number(5),
gds37       varchar2(1000),
gds38       varchar2(1),
gds39       varchar2(1)
);

alter table gds_file add  constraint gds_pk primary key  (gds00,gds01) enable validate;
grant select on gds_file to tiptopgp;
grant update on gds_file to tiptopgp;
grant delete on gds_file to tiptopgp;
grant insert on gds_file to tiptopgp;
grant index on gds_file to public;
grant select on gds_file to ods;
