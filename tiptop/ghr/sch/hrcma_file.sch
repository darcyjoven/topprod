/*
================================================================================
檔案代號:hrcma_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcma_file
(
hrcma01     varchar2(20) NOT NULL,   /* 加班信息编号                          */
hrcma02     varchar2(20) NOT NULL,   /* 加班计划编号                          */
hrcma03     varchar2(60) NOT NULL,   /* 人员ID                                */
hrcma04     date,                    /* 开始日期                              */
hrcma05     varchar2(5) NOT NULL,    /* 开始时间                              */
hrcma06     date,                    /* 结束日期                              */
hrcma07     varchar2(5) NOT NULL,    /* 结束时间                              */
hrcma08     number(15,2) NOT NULL,   /* 加班时长                              */
hrcma09     varchar2(20) NOT NULL,   /* 加班类型                              */
hrcma10     number(15,2),            /* 就餐时长                              */
hrcma11     varchar2(1) NOT NULL,    /* 固定扣除                              */
hrcma12     varchar2(1) NOT NULL,    /* 自动调休                              */
hrcma13     varchar2(255),           /* 备注                                  */
hrcma14     varchar2(1) NOT NULL,    /* 无效信息                              */
hrcma15     varchar2(1) NOT NULL     /* 规律加班                              */
);

alter table hrcma_file add  constraint tpc_hrcma_pk primary key  (hrcma01,hrcma02) enable validate;
grant select on hrcma_file to tiptopgp;
grant update on hrcma_file to tiptopgp;
grant delete on hrcma_file to tiptopgp;
grant insert on hrcma_file to tiptopgp;
grant index on hrcma_file to public;
grant select on hrcma_file to ods;
