/*
================================================================================
檔案代號:hrboa_file
檔案名稱:班段信息表
檔案目的:记录班段信息
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrboa_file
(
hrboa01     number(5) NOT NULL,      /*流水号                                 */
hrboa02     varchar2(5) NOT NULL,    /*开始时间                               */
hrboa03     varchar2(1) NOT NULL,    /*开始刷卡                               */
hrboa04     number(5) NOT NULL,      /*取卡提前                               */
hrboa05     varchar2(5) NOT NULL,    /*结束时间                               */
hrboa06     varchar2(1) NOT NULL,    /*结束刷卡                               */
hrboa07     number(5) NOT NULL,      /*取卡推后                               */
hrboa08     varchar2(20) NOT NULL,   /*班段类型                               */
hrboa09     varchar2(20) NOT NULL,   /*就餐类型                               */
hrboa10     varchar2(1) NOT NULL,    /*参与考勤                               */
hrboa11     number(5) NOT NULL,      /*班段时长/分钟                          */
hrboa12     number(4,2) NOT NULL,    /*班段时长/小时                          */
hrboa13     number(4,2) NOT NULL,    /*班段时长/天                            */
hrboa14     varchar2(255),           /*备注                                   */
hrboa15     varchar2(20) NOT NULL    /*班次编号                               */
);

alter table hrboa_file add  constraint tpc_hrboa_pk primary key  (hrboa01,hrboa15) enable validate;
grant select on hrboa_file to tiptopgp;
grant update on hrboa_file to tiptopgp;
grant delete on hrboa_file to tiptopgp;
grant insert on hrboa_file to tiptopgp;
grant index on hrboa_file to public;
grant select on hrboa_file to ods;
