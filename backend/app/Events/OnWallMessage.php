<?php

namespace App\Events;

use App\Wall;
use Illuminate\Queue\SerializesModels;

/**
 * Class OnWallMessage
 * @package App\Events
 *
 * Fires on wall post send
 */
class OnWallMessage extends Event implements Feedable
{
    use SerializesModels;

    /**
     * @var Wall
     */
    public $wall;

    /**
     * Create a new event instance.
     *
     * @param Wall $wall
     */
    public function __construct(Wall $wall)
    {
        $this->wall = $wall;
    }

    /**
     * {@inheritDoc}
     *
     * @return Wall
     */
    public function getFeedable()
    {
        return $this->wall;
    }

    /**
     * {@inheritDoc}
     *
     * @return \App\User
     */
    public function getFeedSender()
    {
        return $this->wall->sender;
    }

    /**
     * Check is user sent post on himself wall
     *
     * @return bool
     */
    public function isSelf()
    {
        return $this->wall->sender->id === $this->wall->receiver->id;
    }
}
