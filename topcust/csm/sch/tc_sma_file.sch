/*
================================================================================
檔案代號:tc_sma_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sma_file
(
tc_sma01    varchar2(20) NOT NULL,   /*作业编号                               */
tc_sma02    varchar2(20) NOT NULL,   /*料件类型                               */
tc_sma03    number(10) NOT NULL,     /*市场类型                               */
tc_sma04    varchar2(20),
tc_sma05    varchar2(1),
tc_sma06    varchar2(20),            /*说明                                   */
tc_sma07    varchar2(20),            /*说明                                   */
tc_sma08    varchar2(1),
tc_sma09    varchar2(20),
tc_sma10    varchar2(200),           /*备注                                   */
tc_sma11    varchar2(1),
tc_sma12    varchar2(200),
tc_sma13    varchar2(200),
tc_sma14    varchar2(1),
tc_sma15    varchar2(200),
tc_sma16    varchar2(200),
tc_sma17    varchar2(1),
tc_sma18    varchar2(2000),
tc_sma19    varchar2(2000),
tc_sma20    varchar2(2000),
tc_smauser  varchar2(200),
tc_smamod   varchar2(400),
tc_sma21    date,
tc_sma22    date,
tc_sma23    date,
tc_sma24    number(15),
tc_sma25    number(15),
tc_sma26    number(15),
tc_sma27    number(15,3),
tc_sma28    number(15,3),
tc_sma29    number(15,6),
tc_sma30    number(15,10)
);

create unique index forewin on tc_sma_file (tc_sma01,tc_sma02,tc_sma03);
alter table tc_sma_file add  constraint forewin unique (tc_sma01,tc_sma02,tc_sma03) enable validate;
grant select on tc_sma_file to tiptopgp;
grant update on tc_sma_file to tiptopgp;
grant delete on tc_sma_file to tiptopgp;
grant insert on tc_sma_file to tiptopgp;
grant index on tc_sma_file to public;
grant select on tc_sma_file to ods;
