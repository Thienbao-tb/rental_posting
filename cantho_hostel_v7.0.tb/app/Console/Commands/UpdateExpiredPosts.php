<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
class UpdateExpiredPosts extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'posts:update-expired';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        DB::table('phong')
            ->whereNotNull('thoigian_batdau')
            ->whereNotNull('thoigian_ketthuc')
            ->where('thoigian_ketthuc', '<=', now())
            ->where('trangthai', 3)
            ->update(['trangthai' => -2]);

        $this->info('Updated expired posts.');
    }
}
